# Install registrygate

For: admins who install registrygate in a cluster. You know Kubernetes, Helm and cert-manager.

This page covers the chart install, the optional chart objects, the admission webhook, the security limits and the audit log. The install gives you a proxy with no upstream. Next, you tell the proxy which registries to stand in for:

1. [Upstream registries](upstreams.md): the certificate authority (CA), the certificate and the `UpstreamRegistry` for each host.
2. [Shared credentials](credentials.md): the `UpstreamCredential` objects that hold a personal access token (PAT) or other login, and their ceilings.
3. [Mirrors](mirrors.md): `RegistryMirror` objects for pull-through caches.
4. [CI pods](ci-pods.md): how a pod reaches the proxy.

## Requirements

- Kubernetes 1.33 or later. The `ImageVolume` feature must be on, because CI pods mount the credential helper as an image volume.
- A `TokenReview` API that the proxy can reach.
- Docker CLI and daemon 25 or later in the CI pods.


## Install the chart

Install the chart in the namespace of the proxy. The chart creates the four CRDs, the Deployment (two replicas), the Service, the RBAC and a Secret that signs upload session tokens. It creates no upstream, credential or mirror. You create those objects yourself.

<!-- e2e -->
```sh
kubectl create namespace registrygate
```

Pick a free address in the service range of your cluster for `service.clusterIP`. CI pods map the registry host names to this fixed address with `hostAliases`, so it must not change.

<!-- e2e -->
```sh
helm install registrygate oci://ghcr.io/soliddowant/charts/registrygate \
  --namespace registrygate \
  --set service.clusterIP=10.96.0.50
```

The proxy reads `UpstreamRegistry` objects and their Secrets only in its admin namespaces. By default, this is the namespace of the proxy. To add more, set `adminNamespaces` in the chart values. The chart then creates a Role and a RoleBinding for Secrets in each one. Add the release namespace to the list too.

[Chart values](chart-values.md) lists every value.

Make sure that the install works:

<!-- e2e -->
```sh
kubectl -n registrygate rollout status deploy/registrygate
```

A proxy pod answers `200` on `/readyz` (port 8080) when it has synced the custom resources and loaded the Secrets that they use. Until then, requests get `503` with the message `registrygate is not ready`. After the pod is ready, it stays ready. If an object then refers to a Secret that the proxy has not loaded yet, only the requests that need that object get this `503`. Other requests work as before. With no `UpstreamRegistry`, the proxy is ready but answers no host.

If the proxy cannot decide, it fails closed. It denies the request or forwards it with no credential. It never uses a credential as a fallback.

### Files on each GitHub release

From 0.4.1, each [GitHub release](https://github.com/solidDoWant/registrygate/releases) has these files:

- `crds.yaml`: the four CRDs of that version in one file. Use it if you manage CRDs outside the Helm release: set the chart value `crds.install` to `false`, and apply `https://github.com/solidDoWant/registrygate/releases/download/v<version>/crds.yaml` yourself.
- `docker-credential-registrygate-<os>-<arch>`: the credential helper for Linux and macOS, on amd64 and arm64. It is the same program as in the image `ghcr.io/soliddowant/registrygate-credential-helper`.
- `checksums.txt`: the SHA-256 sums of these files.

## Optional chart objects

Three objects are off by default. [Chart values](chart-values.md) lists their values.

- **PodDisruptionBudget** (`podDisruptionBudget.enabled`): allows `maxUnavailable: 1` pod down during a drain. If you set `replicas: 1`, this allows full disruption, so a drain can stop the only replica.
- **NetworkPolicy** (`networkPolicy.enabled`): your CNI (the cluster network plugin) must enforce NetworkPolicy. The policy allows:
  - port `8443` from the namespaces in `clientNamespaceSelector`;
  - port `8080` from the namespaces in `metricsNamespaceSelector`;
  - port `9443` from `apiServerCIDRs`;
  - for egress: DNS, `apiServerCIDRs` on `apiServerPorts` (default `443` and `6443`), port `443` to any address, the addresses in `egressHosts` on `egressPorts`, and your `extraEgress` rules.

  NetworkPolicy ports match the port of the destination pod, after the Service has translated the address. A Service on port `443` that points to pod port `8443` needs a rule for `8443`. Set `apiServerCIDRs` to the addresses from `kubectl get endpoints kubernetes`, not to the Service address. GHCR has no fixed addresses, so the chart allows port `443` to anywhere. With Cilium, you can replace this with a policy on the name `ghcr.io`. Use `extraEgress` for an in-cluster upstream or mirror.
- **ServiceMonitor** (`serviceMonitor.enabled`): scrapes the metrics port. It needs the Prometheus Operator CRDs.


## Turn on the admission webhook

The proxy enforces ceilings and admin namespaces whether or not you use the webhook. The webhook only gives fast feedback: `kubectl apply` fails at once. The webhook is off by default.

The webhook rejects an `UpstreamRegistry` that is not in an admin namespace. It also rejects a new `RegistryAccessPolicy`, and a change to its `spec`, when a rule with a `credentialRef` has a repository pattern or action outside the ceiling of that credential. The message names the rule and the patterns. A rule whose credential does not exist yet is admitted; the policy status reports it. The webhook reads the same view of the cluster as the proxy, and rejects a policy while that view is not yet built. The webhook admits an update that does not change the `spec`, and an update of an object that is being deleted. So labels and finalizers still change after you narrow a ceiling.

The webhook has its own Service and its own certificate. Every proxy replica serves it, also a replica that is not ready. If no replica runs, the webhook rejects all writes of `UpstreamRegistry` and `RegistryAccessPolicy` objects, because it fails closed (`failurePolicy: Fail`).

Choose one way to give the webhook a certificate:

1. With cert-manager, set `webhook.certManager.issuerRef.name` to an Issuer in the namespace of the proxy. The chart makes the certificate, and cainjector adds the CA bundle to the webhook. Make sure that cainjector runs.
2. Without cert-manager, make a `kubernetes.io/tls` Secret for the name `registrygate-webhook.registrygate.svc` (use the name of your Service and namespace). Set `webhook.existingSecret` to the Secret and `webhook.caBundle` to the base64 text of the CA certificate.

Then set `webhook.enabled=true`. For example:

```
helm upgrade registrygate oci://ghcr.io/soliddowant/charts/registrygate \
  --namespace registrygate --reuse-values \
  --set webhook.enabled=true \
  --set webhook.certManager.issuerRef.name=webhook-issuer
```

The API server must reach port `9443` of the proxy pods. If you use a NetworkPolicy, allow that port from the API server.

## Security limits

- A synced replica keeps the last policies it saw. During an outage of the Kubernetes API server, a revoked policy keeps working until the watch recovers.
- The proxy caches a token review for up to 30 seconds (`authentication.cacheTTL`). A deleted ServiceAccount can keep working for that time.
- Callers that use the same `UpstreamCredential` share one upstream identity and its rate limits. The audit log tells you who did what.
- A mirror serves public content only. See [mirrors](mirrors.md#mirrors-serve-public-content-only).
- ServiceAccount tokens must use the audience `registrygate` and a short life of 1 to 6 hours. Do not accept the default API server audience.

## Audit log

The proxy writes one JSON line to standard output for each request. This includes `404`, `401` and `503` answers. The lines never hold header values, tokens or query strings. Set `audit.enabled` to `false` to turn the log off.

These fields are in each line:

| Field | Meaning |
|---|---|
| `time` | When the request ended. |
| `clientIP` | The address of the client. |
| `namespace` | The namespace of the ServiceAccount. Empty for an anonymous request. |
| `serviceAccount` | The name of the ServiceAccount. |
| `pod` | The pod that the token is bound to, when the token review reports it. |
| `method` | The HTTP method. |
| `path` | The escaped request path, without the query. |
| `repository` | The repository of the request. |
| `from` | The source repository of a blob mount that the proxy forwarded. |
| `action` | `none`, `pull`, `push`, `delete` or `unknown`. |
| `decision` | The decision. See the next table. |
| `host` | The server name the client reached. |
| `upstream` | The `UpstreamRegistry` that the host resolved to, as `namespace/name`. Empty when no upstream matched. |
| `policy` | The policy that decided the request, as `namespace/name`. Several policies are joined by `,`. |
| `rule` | The name of the rule that decided the request. For `ambiguous`, every matching rule name, joined by `,`. |
| `credential` | The `UpstreamCredential` the proxy used, as `namespace/name`. |
| `mirror` | The `RegistryMirror` the proxy pulled from, as `namespace/name`. |
| `status` | The HTTP status that the client got. |
| `upstreamStatus` | The HTTP status from the upstream or mirror, when the request reached it. |
| `bytes` | The number of body bytes sent to the client. |
| `durationMs` | How long the request took, in milliseconds. |
| `digest` | The manifest digest, for a manifest push or delete. |

The `decision` field has one of these values:

| Value | Meaning |
|---|---|
| `allowed` | A policy and the ceiling of its credential allowed the request. The proxy used the rule's credential. |
| `mirror` | A rule with a mirror allowed the pull. The proxy used the mirror and no upstream credential. |
| `anonymous` | The proxy forwarded the request with no credential (a pull that no policy allows). |
| `denied` | No policy rule allowed the request. The client got `403`. |
| `ambiguous` | Two or more rules named different credentials for the request. The client got `403`. |
| `unauthenticated` | The credential was missing or not valid. The client got `401`. |
| `unavailable` | The proxy could not decide or reach GHCR. The client got `502` or `503`. |
| `notfound` | The route is not one that the proxy serves. The client got `404`. |
| `invalid` | The request was malformed. The client got `400`. |

To find out why a push failed, search for the `serviceAccount` and `repository` and read `decision` and `status`. To see how clients read the answers, see [why a push is denied](../user/policies.md#why-a-request-is-denied).
