# Changelog

## 0.4.1-rc.1

registrygate is a proxy for container registries, such as `ghcr.io` and `quay.io`. It runs in a Kubernetes cluster. CI pods send their pushes, pulls and deletes to the proxy with the token of their own ServiceAccount. The proxy adds the registry credential, so the pods never see it. This release is a candidate (a test version before the final release) for 0.4.1. The proxy, the credential helper and the chart behave the same as in 0.4.0. What is new is the files on each GitHub release. Install it with the Helm chart `oci://ghcr.io/soliddowant/charts/registrygate`, version `0.4.1-rc.1`. [Install registrygate](https://github.com/solidDoWant/registrygate/blob/v0.4.1-rc.1/docs/admin/install.md) tells you how.

### Upgrade notes for admins

You do not have to change anything. To upgrade from 0.4.0, install the chart version `0.4.1-rc.1` with the same values.

### Deployment

- Each GitHub release now has these files: `crds.yaml`, with the four CRDs of that version in one file; the credential helper `docker-credential-registrygate` for Linux and macOS on amd64 and arm64; and `checksums.txt` with their SHA-256 sums. If you manage the CRDs yourself (chart value `crds.install: false`), you can apply `https://github.com/solidDoWant/registrygate/releases/download/v<version>/crds.yaml`. [Files on each GitHub release](https://github.com/solidDoWant/registrygate/blob/v0.4.1-rc.1/docs/admin/install.md#files-on-each-github-release) has the details. ([#262](https://github.com/solidDoWant/registrygate/pull/262))

Internal work: releases are built on Tekton instead of GitHub Actions, CI runs on the shared Tekton Pipelines, the e2e tests are faster (parallel tests, cached kind images, faster polling), and the project's agents act as the GitHub App through githubgate interception ([#225](https://github.com/solidDoWant/registrygate/pull/225), [#226](https://github.com/solidDoWant/registrygate/pull/226), [#227](https://github.com/solidDoWant/registrygate/pull/227), [#232](https://github.com/solidDoWant/registrygate/pull/232)–[#236](https://github.com/solidDoWant/registrygate/pull/236), [#238](https://github.com/solidDoWant/registrygate/pull/238), [#244](https://github.com/solidDoWant/registrygate/pull/244)–[#249](https://github.com/solidDoWant/registrygate/pull/249), [#252](https://github.com/solidDoWant/registrygate/pull/252), [#254](https://github.com/solidDoWant/registrygate/pull/254), [#256](https://github.com/solidDoWant/registrygate/pull/256), [#258](https://github.com/solidDoWant/registrygate/pull/258), [#259](https://github.com/solidDoWant/registrygate/pull/259), [#261](https://github.com/solidDoWant/registrygate/pull/261), [#262](https://github.com/solidDoWant/registrygate/pull/262)).

### Known issues

None.

## 0.4.0

registrygate is a proxy for container registries, such as `ghcr.io` and `quay.io`. It runs in a Kubernetes cluster. CI pods send their pushes, pulls and deletes to the proxy with the token of their own ServiceAccount. The proxy adds the registry credential, so the pods never see it. Release 0.4.0 completes the fourth phase of work. This phase changed how the project is built and tested: CI now runs on Tekton. The proxy, the credential helper and the chart behave the same as in 0.3.0. Install it with the Helm chart `oci://ghcr.io/soliddowant/charts/registrygate`, version `0.4.0`. [Install registrygate](https://github.com/solidDoWant/registrygate/blob/v0.4.0/docs/admin/install.md) tells you how.

### Upgrade notes for admins

You do not have to change anything. To upgrade from 0.3.0, install the chart version `0.4.0` with the same values.

### Deployment

- The proxy uses controller-runtime `v0.25.3`. This is a patch update of the library that watches the custom resources ([#201](https://github.com/solidDoWant/registrygate/pull/201)).

Internal work: CI moved from GitHub Actions to Tekton, with faster end-to-end tests on their own kind clusters, fixes to the CI cleanup and the stage selection, and fixes to the agent scheduler ([#183](https://github.com/solidDoWant/registrygate/pull/183), [#184](https://github.com/solidDoWant/registrygate/pull/184), [#185](https://github.com/solidDoWant/registrygate/pull/185), [#188](https://github.com/solidDoWant/registrygate/pull/188), [#190](https://github.com/solidDoWant/registrygate/pull/190), [#192](https://github.com/solidDoWant/registrygate/pull/192), [#194](https://github.com/solidDoWant/registrygate/pull/194), [#196](https://github.com/solidDoWant/registrygate/pull/196), [#197](https://github.com/solidDoWant/registrygate/pull/197), [#202](https://github.com/solidDoWant/registrygate/pull/202), [#203](https://github.com/solidDoWant/registrygate/pull/203), [#204](https://github.com/solidDoWant/registrygate/pull/204), [#210](https://github.com/solidDoWant/registrygate/pull/210), [#211](https://github.com/solidDoWant/registrygate/pull/211), [#212](https://github.com/solidDoWant/registrygate/pull/212), [#213](https://github.com/solidDoWant/registrygate/pull/213), [#216](https://github.com/solidDoWant/registrygate/pull/216), [#217](https://github.com/solidDoWant/registrygate/pull/217), [#219](https://github.com/solidDoWant/registrygate/pull/219), [#220](https://github.com/solidDoWant/registrygate/pull/220)).

### Known issues

- `ghcr.io` does not accept deletes through the registry API. A delete of a `ghcr.io` image through the proxy gets `405`. Delete the image in GitHub instead.
- A mirror serves public content only. It must reach its registry with no credential. [Mirrors serve public content only](https://github.com/solidDoWant/registrygate/blob/v0.4.0/docs/admin/mirrors.md#mirrors-serve-public-content-only) tells you why.

## 0.3.0

registrygate is a proxy for container registries, such as `ghcr.io` and `quay.io`. It runs in a Kubernetes cluster. CI pods send their pushes, pulls and deletes to the proxy with the token of their own ServiceAccount. The proxy adds the registry credential, so the pods never see it. Until this release, the project was called ghcr-proxy and served only `ghcr.io`. Release 0.3.0 completes the third phase of work. The project has a new name, it serves several registries, and four custom resources configure it. Install it with the Helm chart `oci://ghcr.io/soliddowant/charts/registrygate`, version `0.3.0`. [Install registrygate](https://github.com/solidDoWant/registrygate/blob/v0.3.0/docs/admin/install.md) tells you how.

### Upgrade notes for admins

Release 0.3.0 is not an in-place upgrade of ghcr-proxy 0.2.0. Install it as a new release, then move your CI pods to it.

- Install the new chart `oci://ghcr.io/soliddowant/charts/registrygate`, and use the images `ghcr.io/soliddowant/registrygate` and `ghcr.io/soliddowant/registrygate-credential-helper`. The project has a new name, so the chart, the images, the binaries and the API group `registrygate.soliddowant.dev` changed name ([#121](https://github.com/solidDoWant/registrygate/pull/121)).
- Remove the chart values `pat`, `tls`, `upstream`, `mirrors` and `grants`. Create the objects `UpstreamRegistry`, `UpstreamCredential` and `RegistryMirror` instead. The chart no longer holds the registry, the credential or the mirrors. A configuration file that still has the sections `upstream`, `grants`, `mirrors` or `tls` does not load ([#142](https://github.com/solidDoWant/registrygate/pull/142), [#144](https://github.com/solidDoWant/registrygate/pull/144)).
- Replace each `GHCRAccessPolicy` with a `RegistryAccessPolicy`. The kind `GHCRAccessPolicy` and its CRD are gone ([#134](https://github.com/solidDoWant/registrygate/pull/134), [#144](https://github.com/solidDoWant/registrygate/pull/144)).
- Change the CI pods. The token audience is now `registrygate`, the token path is `/var/run/secrets/registrygate/token`, and the helper reads `REGISTRYGATE_TOKEN_FILE`. Set `REGISTRYGATE_HOSTS` to the hosts that the proxy serves, and run `docker-credential-registrygate configure`. [Set up a CI pod](https://github.com/solidDoWant/registrygate/blob/v0.3.0/docs/admin/ci-pods.md) shows the full pod ([#121](https://github.com/solidDoWant/registrygate/pull/121), [#122](https://github.com/solidDoWant/registrygate/pull/122)).
- Update your dashboards and alerts. The metric prefix is now `registrygate_` instead of `ghcr_proxy_`, and most metrics have a new `upstream` label. The metrics `ghcr_proxy_policies` and `ghcr_proxy_credential_reloads_total` are gone ([#121](https://github.com/solidDoWant/registrygate/pull/121), [#145](https://github.com/solidDoWant/registrygate/pull/145)).
- Do not expect a delete on `ghcr.io` to remove the image. The proxy now sends a delete to the registry like any other request, and `ghcr.io` answers every delete with `405`. The GitHub REST API path of 0.2.0 is gone, so the PAT does not need the `delete:packages` scope ([#142](https://github.com/solidDoWant/registrygate/pull/142)).

### Registries and credentials

- The proxy can stand in for several registries at the same time. Each `UpstreamRegistry` names the hosts that the proxy answers for, the URL of the registry and the serving certificate. The proxy selects the certificate by the host name that the client asks for. [Upstream registries](https://github.com/solidDoWant/registrygate/blob/v0.3.0/docs/admin/upstreams.md) tells you how ([#124](https://github.com/solidDoWant/registrygate/pull/124), [#133](https://github.com/solidDoWant/registrygate/pull/133), [#142](https://github.com/solidDoWant/registrygate/pull/142)).
- The proxy logs in to each registry the way the registry asks for it: with no credential, with a username and password, or with the token flow of Docker. It keeps the tokens of each credential in a cache ([#141](https://github.com/solidDoWant/registrygate/pull/141)).
- An `UpstreamCredential` holds a username and password from a Secret, and a ceiling. The ceiling is the most that any policy can do with the credential. Its `allowedNamespaces` says which namespaces can use it. [Shared credentials](https://github.com/solidDoWant/registrygate/blob/v0.3.0/docs/admin/credentials.md) tells you how ([#124](https://github.com/solidDoWant/registrygate/pull/124), [#132](https://github.com/solidDoWant/registrygate/pull/132)).
- An `UpstreamRegistry` or a `RegistryMirror` can use plain HTTP, for example to reach Harbor through its Service in the cluster. `aliasHosts` lists other names that the registry uses for itself, and `tokenRealmHosts` lists other hosts that a mirror can use for its tokens. The hosts of an `UpstreamRegistry` are always alias hosts ([#162](https://github.com/solidDoWant/registrygate/pull/162), [#169](https://github.com/solidDoWant/registrygate/pull/169)).
- The proxy reads each Secret that an object names, and applies a change to it without a restart. A Secret in a tenant namespace needs a Role that lets the proxy read only that Secret ([#130](https://github.com/solidDoWant/registrygate/pull/130)).

### Access policies

- A `RegistryAccessPolicy` replaces the `GHCRAccessPolicy`. Each rule names repositories, actions, and a credential or a mirror. A rule that goes outside the ceiling of its credential is not accepted, and the status of the policy tells you why. [Write a RegistryAccessPolicy](https://github.com/solidDoWant/registrygate/blob/v0.3.0/docs/user/policies.md) tells you how ([#124](https://github.com/solidDoWant/registrygate/pull/124), [#136](https://github.com/solidDoWant/registrygate/pull/136), [#149](https://github.com/solidDoWant/registrygate/pull/149)).
- If two rules match the same request and do not agree, the proxy does not guess. It denies the request, and the audit log shows the decision `ambiguous` ([#136](https://github.com/solidDoWant/registrygate/pull/136)).
- Each of the four kinds has a `Ready` condition with a reason. A policy also has a condition for each rule ([#135](https://github.com/solidDoWant/registrygate/pull/135)).
- The admission webhook now checks `UpstreamRegistry` and `RegistryAccessPolicy` objects. It rejects an `UpstreamRegistry` outside the admin namespaces, and a rule outside the ceiling of its credential ([#134](https://github.com/solidDoWant/registrygate/pull/134)).

### Mirrors

- A `RegistryMirror` sends pulls to a pull-through cache, for example one Harbor proxy-cache project for each CI namespace. A tenant can create its own mirror with its own Secret. An `UpstreamRegistry` can name a default mirror. [Mirrors](https://github.com/solidDoWant/registrygate/blob/v0.3.0/docs/admin/mirrors.md) tells you how ([#124](https://github.com/solidDoWant/registrygate/pull/124), [#140](https://github.com/solidDoWant/registrygate/pull/140), [#142](https://github.com/solidDoWant/registrygate/pull/142)).

### Pushing and pulling

- A request with a path that is not in its canonical form gets `400`, for example a path with `..`, an empty segment or percent-encoding. A request outside `/v2` gets `404`. The proxy sends nothing to the registry for these requests ([#125](https://github.com/solidDoWant/registrygate/pull/125)).
- The proxy gives each upload its own signed upload URL. Every registry works the same way, and a client cannot move an upload to another repository. The chart makes the signing key, or you can give your own Secret in `uploadSigning.existingSecret` ([#125](https://github.com/solidDoWant/registrygate/pull/125), [#142](https://github.com/solidDoWant/registrygate/pull/142), [#144](https://github.com/solidDoWant/registrygate/pull/144)).

### Credential helper

- The helper gives the token only to the hosts in `REGISTRYGATE_HOSTS`. The new command `docker-credential-registrygate configure` writes the `credHelpers` entries for these hosts to `~/.docker/config.json`, and keeps the other keys of the file. For Docker Hub, it also writes the key `https://index.docker.io/v1/` ([#122](https://github.com/solidDoWant/registrygate/pull/122), [#164](https://github.com/solidDoWant/registrygate/pull/164)).

### Deployment

- The chart installs the four CRDs and the RBAC that the proxy needs. The new value `adminNamespaces` lists the namespaces where `UpstreamRegistry` objects count. The new value `networkPolicy.egressHosts` lists the addresses of the registries and mirrors. [Chart values](https://github.com/solidDoWant/registrygate/blob/v0.3.0/docs/admin/chart-values.md) lists all values ([#144](https://github.com/solidDoWant/registrygate/pull/144)).
- The new metrics `registrygate_objects` and `registrygate_secret_updates_total` count the objects by readiness and the Secret updates. Audit lines have the new fields `host`, `upstream`, `rule`, `credential` and `mirror`, and the new decisions `mirror` and `ambiguous` ([#145](https://github.com/solidDoWant/registrygate/pull/145)).
- New guides for admins and users cover the four custom resources, CI pods, Harbor and Docker Hub. A test runs the commands of the admin guides ([#149](https://github.com/solidDoWant/registrygate/pull/149), [#163](https://github.com/solidDoWant/registrygate/pull/163)).

### Fixes

- A ready replica stays ready when a new object names a Secret that the proxy did not load yet. Only the requests that need that object get `503`. Before the fix, the replica became unready for all namespaces ([#171](https://github.com/solidDoWant/registrygate/pull/171)).
- A `RegistryMirror` timeout of zero or less now uses the default. Before the fix, it turned the mirror off ([#170](https://github.com/solidDoWant/registrygate/pull/170)).
- Harbor works through its Service when its `externalURL` is the host that the proxy stands in for. You can also list a host of an `UpstreamRegistry` in its `aliasHosts`, and the object stays ready ([#169](https://github.com/solidDoWant/registrygate/pull/169)).

Internal work: design documents, the generalized fake registry, end-to-end tests with two registries and Harbor, tests against the real `ghcr.io` that the operator runs by hand, test names for the checklist, CI changes and dependency updates ([#99](https://github.com/solidDoWant/registrygate/pull/99), [#100](https://github.com/solidDoWant/registrygate/pull/100), [#120](https://github.com/solidDoWant/registrygate/pull/120), [#123](https://github.com/solidDoWant/registrygate/pull/123), [#126](https://github.com/solidDoWant/registrygate/pull/126), [#127](https://github.com/solidDoWant/registrygate/pull/127), [#129](https://github.com/solidDoWant/registrygate/pull/129), [#131](https://github.com/solidDoWant/registrygate/pull/131), [#137](https://github.com/solidDoWant/registrygate/pull/137), [#143](https://github.com/solidDoWant/registrygate/pull/143), [#147](https://github.com/solidDoWant/registrygate/pull/147), [#151](https://github.com/solidDoWant/registrygate/pull/151), [#152](https://github.com/solidDoWant/registrygate/pull/152), [#153](https://github.com/solidDoWant/registrygate/pull/153), [#159](https://github.com/solidDoWant/registrygate/pull/159), [#160](https://github.com/solidDoWant/registrygate/pull/160), [#161](https://github.com/solidDoWant/registrygate/pull/161), [#165](https://github.com/solidDoWant/registrygate/pull/165), [#97](https://github.com/solidDoWant/registrygate/pull/97)).

### Known issues

- `ghcr.io` does not accept deletes through the registry API. A delete of a `ghcr.io` image through the proxy gets `405`. Delete the image in GitHub instead.
- A mirror serves public content only. It must reach its registry with no credential. [Mirrors serve public content only](https://github.com/solidDoWant/registrygate/blob/v0.3.0/docs/admin/mirrors.md#mirrors-serve-public-content-only) tells you why.

## 0.2.0

ghcr-proxy is a proxy for the GitHub container registry, `ghcr.io`. It runs in a Kubernetes cluster and holds one GitHub personal access token (PAT). CI pods push, pull and delete images through the proxy with the token of their own ServiceAccount, and they never see the PAT. This release completes the second phase of work: deleting images, pull mirrors and operations. The mirrors, the admission webhook, the metrics and the new chart objects that 0.1.1 marked as in progress are now complete. Install it with the Helm chart `oci://ghcr.io/soliddowant/charts/ghcr-proxy`, version `0.2.0`. [Install ghcr-proxy](https://github.com/solidDoWant/ghcr-proxy/blob/v0.2.0/docs/admin/install.md) tells you how.

### Upgrade notes for admins

- Give the PAT the `delete:packages` scope if you want CI pods to delete images. The proxy now deletes an image through the GitHub REST API, and the API needs this scope. The PAT needs `read:packages`, `write:packages` and `delete:packages` ([#91](https://github.com/solidDoWant/ghcr-proxy/pull/91)).
- If you use a NetworkPolicy that is not the one from the chart, let the proxy connect to `api.github.com` on port 443. The proxy sends deletes there. The NetworkPolicy of the chart already allows port 443 to any address ([#91](https://github.com/solidDoWant/ghcr-proxy/pull/91)).
- You do not have to change your chart values. All new chart values have defaults that keep the behaviour of 0.1.1.

### Pushing and pulling

- You can delete an image by digest through the proxy, for example with `crane delete` or `regctl manifest rm`. The policy of the ServiceAccount must allow the `delete` action. `ghcr.io` does not accept the registry delete request, so the proxy deletes the package version through the GitHub REST API with the PAT. The new chart value `upstream.apiURL` sets the URL of that API. The default is `https://api.github.com/` ([#89](https://github.com/solidDoWant/ghcr-proxy/pull/89), [#91](https://github.com/solidDoWant/ghcr-proxy/pull/91)).
- A delete by tag and a delete of a blob get the `405` answer of `ghcr.io`, because `ghcr.io` does not support them. Delete by digest instead ([#89](https://github.com/solidDoWant/ghcr-proxy/pull/89), [#91](https://github.com/solidDoWant/ghcr-proxy/pull/91)).
- A delete that the policy does not allow fails with `403`, and the proxy sends nothing to `ghcr.io` ([#91](https://github.com/solidDoWant/ghcr-proxy/pull/91)).

### Mirrors

- The proxy can send pulls to two pull mirrors. A pull mirror is a registry that keeps copies of GHCR images, for example a Harbor proxy-cache project. Allowed pulls go to the policy mirror. Anonymous pulls and pulls that no policy allows go to the anonymous mirror. If a mirror fails, the pull goes to `ghcr.io`, unless you set `fallbackToUpstream: false`. Set the chart values `mirrors.policy` and `mirrors.anonymous`. The proxy never sends the PAT to a mirror. [Configure pull mirrors](https://github.com/solidDoWant/ghcr-proxy/blob/v0.2.0/docs/admin/install.md#configure-pull-mirrors) tells you how ([#71](https://github.com/solidDoWant/ghcr-proxy/pull/71), [#75](https://github.com/solidDoWant/ghcr-proxy/pull/75), [#84](https://github.com/solidDoWant/ghcr-proxy/pull/84)).
- Tests now use Harbor as the policy mirror ([#84](https://github.com/solidDoWant/ghcr-proxy/pull/84)).

### Access policies and grants

- An optional admission webhook rejects a `GHCRAccessPolicy` at `kubectl apply` when a repository pattern or an action is outside the grants of its namespace. The proxy enforces the grants with or without the webhook. Set `webhook.enabled=true` and give the webhook a certificate, from cert-manager or from your own Secret. [Turn on the admission webhook](https://github.com/solidDoWant/ghcr-proxy/blob/v0.2.0/docs/admin/install.md#turn-on-the-admission-webhook) tells you how ([#70](https://github.com/solidDoWant/ghcr-proxy/pull/70)).

### Deployment

- The proxy serves Prometheus metrics at `/metrics` on the health port (`8080`). They count requests, requests to `ghcr.io`, to the GitHub REST API and to the mirrors, mirror fallbacks, token reviews, policies and credential reloads. No metric has a label for a repository, namespace or ServiceAccount. [Metrics](https://github.com/solidDoWant/ghcr-proxy/blob/v0.2.0/docs/admin/metrics.md) lists them ([#81](https://github.com/solidDoWant/ghcr-proxy/pull/81), [#91](https://github.com/solidDoWant/ghcr-proxy/pull/91)).
- The chart can create a PodDisruptionBudget, a NetworkPolicy and a Prometheus Operator ServiceMonitor. Each one is off by default. [Optional chart objects](https://github.com/solidDoWant/ghcr-proxy/blob/v0.2.0/docs/admin/install.md#optional-chart-objects) tells you about them ([#72](https://github.com/solidDoWant/ghcr-proxy/pull/72)).
- The admin guides have full commands that you can copy and run, from an empty cluster to a CI pod that pushes an image. Tests run these commands ([#74](https://github.com/solidDoWant/ghcr-proxy/pull/74)).

### Fixes

- A pull mirror that needs no authentication now works. In 0.1.1, the proxy treated such a mirror as unavailable. Pulls then went to `ghcr.io`, or failed with `502` when `fallbackToUpstream` was `false` ([#95](https://github.com/solidDoWant/ghcr-proxy/pull/95)).

Internal work: the record of how `ghcr.io` answers deletes, tests against the real `ghcr.io` that the operator runs by hand, end-to-end test fixes and dependency updates ([#87](https://github.com/solidDoWant/ghcr-proxy/pull/87), [#88](https://github.com/solidDoWant/ghcr-proxy/pull/88), [#90](https://github.com/solidDoWant/ghcr-proxy/pull/90), [#93](https://github.com/solidDoWant/ghcr-proxy/pull/93)).

### Known issues

- Deleting an image by tag is not supported, because `ghcr.io` does not support it. Delete by digest instead.

## 0.1.1

ghcr-proxy is a proxy for the GitHub container registry, `ghcr.io`. It runs in a Kubernetes cluster and holds one GitHub personal access token (PAT). CI pods push and pull images through the proxy with the token of their own ServiceAccount, and they never see the PAT. This patch release fixes pushes to `ghcr.io`, which did not work in 0.1.0. It also includes the first parts of the next phase of work. These parts are off by default. Install it with the Helm chart `oci://ghcr.io/soliddowant/charts/ghcr-proxy`, version `0.1.1`. [Install ghcr-proxy](https://github.com/solidDoWant/ghcr-proxy/blob/v0.1.1/docs/admin/install.md) tells you how.

### Upgrade notes for admins

- If you run 0.1.0, upgrade to 0.1.1. With 0.1.0, every push to `ghcr.io` through the proxy fails. You do not have to change your chart values. All new chart values are off by default.

### Pushing and pulling

- Pushes through the proxy to `ghcr.io` work. In 0.1.0, they failed with `404 NOT_FOUND`. The reason is that `ghcr.io` gives upload paths of the form `/v2/<name>/blobs/upload/<session>` (singular `upload`), and the proxy accepted only the plural form of the registry specification. The proxy now accepts both forms ([#76](https://github.com/solidDoWant/ghcr-proxy/pull/76), [#79](https://github.com/solidDoWant/ghcr-proxy/pull/79)).

### Mirrors

This work is part of the next phase and is still in progress.

- The proxy can send pulls to a pull mirror, which is a registry that keeps copies of GHCR images (for example a Harbor proxy-cache project). Set the chart values `mirrors.policy` and `mirrors.anonymous`. Allowed pulls of manifests and blobs go to the policy mirror. Anonymous and not-allowed pulls go to the anonymous mirror. If a mirror fails, the pull goes to `ghcr.io`, unless you set `fallbackToUpstream: false`. Each mirror has its own credentials Secret and CA Secret. The proxy never sends the PAT to a mirror. [Configure pull mirrors](https://github.com/solidDoWant/ghcr-proxy/blob/v0.1.1/docs/admin/install.md#configure-pull-mirrors) tells you how ([#71](https://github.com/solidDoWant/ghcr-proxy/pull/71), [#75](https://github.com/solidDoWant/ghcr-proxy/pull/75)).

### Access policies and grants

This work is part of the next phase and is still in progress.

- An optional admission webhook rejects a `GHCRAccessPolicy` at `kubectl apply` when a repository pattern or an action is outside the grants of its namespace. The proxy enforces the grants with or without the webhook. Set `webhook.enabled=true` and give the webhook a certificate, from cert-manager or from your own Secret. [Turn on the admission webhook](https://github.com/solidDoWant/ghcr-proxy/blob/v0.1.1/docs/admin/install.md#turn-on-the-admission-webhook) tells you how ([#70](https://github.com/solidDoWant/ghcr-proxy/pull/70)).

### Deployment

This work is part of the next phase and is still in progress.

- The chart can create a PodDisruptionBudget, a NetworkPolicy and a Prometheus Operator ServiceMonitor. Each one is off by default. Set `podDisruptionBudget.enabled`, `networkPolicy.enabled` or `serviceMonitor.enabled` to `true`. [Optional chart objects](https://github.com/solidDoWant/ghcr-proxy/blob/v0.1.1/docs/admin/install.md#optional-chart-objects) tells you about them ([#72](https://github.com/solidDoWant/ghcr-proxy/pull/72)).
- The proxy serves Prometheus metrics at `/metrics` on the health port (`8080`). They count requests, requests to `ghcr.io` and the mirrors, mirror fallbacks, token reviews, policies and credential reloads. No metric has a label for a repository, namespace or ServiceAccount. [Metrics](https://github.com/solidDoWant/ghcr-proxy/blob/v0.1.1/docs/admin/metrics.md) lists them ([#81](https://github.com/solidDoWant/ghcr-proxy/pull/81)).
- The admin guides have full commands that you can copy and run, from an empty cluster to a CI pod that pushes an image. Tests run these commands ([#74](https://github.com/solidDoWant/ghcr-proxy/pull/74)).

Internal work: the design for the next phase, tests against the real `ghcr.io` that the operator runs by hand, test fixes, scheduler fixes and dependency updates ([#60](https://github.com/solidDoWant/ghcr-proxy/pull/60), [#61](https://github.com/solidDoWant/ghcr-proxy/pull/61), [#64](https://github.com/solidDoWant/ghcr-proxy/pull/64), [#73](https://github.com/solidDoWant/ghcr-proxy/pull/73), [#80](https://github.com/solidDoWant/ghcr-proxy/pull/80), [#83](https://github.com/solidDoWant/ghcr-proxy/pull/83)).

### Known issues

- Deleting images through the proxy is not yet tested with `ghcr.io`, and it can fail. The next phase finishes it ([#65](https://github.com/solidDoWant/ghcr-proxy/issues/65)).
- The pull mirrors are not yet tested with Harbor ([#68](https://github.com/solidDoWant/ghcr-proxy/issues/68)).

## 0.1.0

ghcr-proxy is a proxy for the GitHub container registry, `ghcr.io`. It runs in a Kubernetes cluster and holds one GitHub personal access token (PAT). CI pods push and pull images through the proxy with the token of their own ServiceAccount, and they never see the PAT. This is the first release. It covers pushing and pulling through the proxy. Install it with the Helm chart `oci://ghcr.io/soliddowant/charts/ghcr-proxy`, version `0.1.0`. [Install ghcr-proxy](https://github.com/solidDoWant/ghcr-proxy/blob/v0.1.0/docs/admin/install.md) tells you how, and [Set up CI pods](https://github.com/solidDoWant/ghcr-proxy/blob/v0.1.0/docs/admin/ci-pods.md) tells you how to connect Docker in your CI pods to the proxy.

### Pushing and pulling

- Docker in a CI pod can push and pull images through the proxy with the same image names and commands as on `ghcr.io` ([#29](https://github.com/solidDoWant/ghcr-proxy/pull/29), [#34](https://github.com/solidDoWant/ghcr-proxy/pull/34), [#36](https://github.com/solidDoWant/ghcr-proxy/pull/36)).
- The proxy uses the PAT only for a request that a policy allows. It sends every other pull to `ghcr.io` with no credential, so public images still work ([#34](https://github.com/solidDoWant/ghcr-proxy/pull/34), [#35](https://github.com/solidDoWant/ghcr-proxy/pull/35)).
- A push that a policy does not allow fails with `403`. The error that Docker prints names the repository and the action, and tells you if no policy or the grant refused it ([#35](https://github.com/solidDoWant/ghcr-proxy/pull/35)).
- `/v2/_catalog` and unknown paths get `404`. The proxy does not send them to `ghcr.io` ([#29](https://github.com/solidDoWant/ghcr-proxy/pull/29)).

### Access policies and grants

- A `GHCRAccessPolicy` resource in a namespace says which repositories each ServiceAccount of that namespace can pull from or push to. Repository names can use globs (`*` and `**`) ([#28](https://github.com/solidDoWant/ghcr-proxy/pull/28), [#35](https://github.com/solidDoWant/ghcr-proxy/pull/35)).
- Grants in the configuration of the proxy limit what the policies of each namespace can allow ([#27](https://github.com/solidDoWant/ghcr-proxy/pull/27)).
- The proxy writes the status of each policy: the `Ready` condition (with the reason `Accepted`, `OutsideGrant`, `InvalidPattern` or `NoGrant`) and a `status.rejected` list of the repository patterns that lost actions. Only one replica writes the status ([#33](https://github.com/solidDoWant/ghcr-proxy/pull/33)).
- A change to a policy takes effect within a few seconds, without a restart ([#35](https://github.com/solidDoWant/ghcr-proxy/pull/35)).

### Credential helper

- The Docker credential helper `docker-credential-ghcr-proxy` gives the ServiceAccount token of the pod to Docker for `ghcr.io`. It reads the token file again on each request, so a rotated token works without a restart. Its image, `ghcr.io/soliddowant/ghcr-proxy-credential-helper`, holds only the static binary, for amd64 and arm64 ([#30](https://github.com/solidDoWant/ghcr-proxy/pull/30)).

### Deployment

- The Helm chart installs the proxy with two replicas, the Service, the configuration, the `GHCRAccessPolicy` CRD and the RBAC. You create the PAT and TLS Secrets before you install it. The pods run as non-root with a read-only root filesystem ([#37](https://github.com/solidDoWant/ghcr-proxy/pull/37)).
- The proxy serves the registry API over TLS, with `/healthz`, `/readyz` and `/metrics`. A replica is not ready until its policies are synced and the PAT and the certificate are loaded ([#36](https://github.com/solidDoWant/ghcr-proxy/pull/36)).
- The proxy loads a new PAT or a new TLS certificate from its Secret without a restart ([#34](https://github.com/solidDoWant/ghcr-proxy/pull/34), [#36](https://github.com/solidDoWant/ghcr-proxy/pull/36)).
- The chart value `upstream.ca.existingSecret` adds a CA certificate to trust for a private or test upstream ([#40](https://github.com/solidDoWant/ghcr-proxy/pull/40)).
- The proxy writes one JSON audit line for each request, with the namespace, the ServiceAccount, the repository, the action, the decision and the upstream status ([#38](https://github.com/solidDoWant/ghcr-proxy/pull/38)).
- New guides for admins (install and CI pod setup) and for users (how to write a policy) ([#39](https://github.com/solidDoWant/ghcr-proxy/pull/39)).

### Security

- The proxy checks each ServiceAccount token with the Kubernetes `TokenReview` API. A token without the `ghcr-proxy` audience gets `401`. If the API server is down, the proxy answers `503` and does not use the PAT ([#32](https://github.com/solidDoWant/ghcr-proxy/pull/32)).
- If `ghcr.io` rejects the PAT, the proxy answers `502` with a message that says the credential of the proxy was rejected. The PAT is never in a log line, a response or a status ([#34](https://github.com/solidDoWant/ghcr-proxy/pull/34)).
- The binaries are built with Go 1.26.11, `golang.org/x/net` v0.60.0 and `github.com/klauspost/compress` v1.20.2, which fix known vulnerabilities ([#52](https://github.com/solidDoWant/ghcr-proxy/pull/52), [#55](https://github.com/solidDoWant/ghcr-proxy/pull/55)).

### Fixes

- The proxy no longer sends interim (1xx) responses from `ghcr.io` on to the client ([#53](https://github.com/solidDoWant/ghcr-proxy/pull/53)).
- A replica that loses the lease for writing policy status keeps serving requests. It also gives up the lease when it shuts down ([#56](https://github.com/solidDoWant/ghcr-proxy/pull/56)).

Internal work: the design review, the fake GHCR for tests, end-to-end tests on kind and the tests for the acceptance checklist ([#26](https://github.com/solidDoWant/ghcr-proxy/pull/26), [#31](https://github.com/solidDoWant/ghcr-proxy/pull/31), [#40](https://github.com/solidDoWant/ghcr-proxy/pull/40), [#44](https://github.com/solidDoWant/ghcr-proxy/pull/44), [#45](https://github.com/solidDoWant/ghcr-proxy/pull/45), [#46](https://github.com/solidDoWant/ghcr-proxy/pull/46)).

### Known issues

- Deleting images through the proxy is not tested against `ghcr.io` yet. The next phase covers it ([#19](https://github.com/solidDoWant/ghcr-proxy/issues/19)).
