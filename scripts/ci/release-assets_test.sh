#!/usr/bin/env bash
# Tests of scripts/ci/build-release-assets.sh: the files it writes, that
# crds.yaml holds exactly the CRDs the chart renders, that the checksums match
# and that the linux/amd64 credential helper reports the release version.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

fail() { echo "release-assets_test: $*" >&2; exit 1; }

out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT
./scripts/ci/build-release-assets.sh v1.2.3 "$out/assets" >/dev/null

for name in crds.yaml checksums.txt docker-credential-registrygate-linux-amd64 docker-credential-registrygate-linux-arm64 \
	docker-credential-registrygate-darwin-amd64 docker-credential-registrygate-darwin-arm64; do
	[[ -s "$out/assets/$name" ]] || fail "missing asset $name"
done
(cd "$out/assets" && sha256sum --check --quiet checksums.txt) || fail "checksums do not match"

# crds.yaml equals the chart's CRDs when crds.install is on.
: >"$out/chart.yaml"
for file in deploy/charts/registrygate/templates/crds/*.yaml; do
	helm template registrygate deploy/charts/registrygate --set crds.install=true \
		--show-only "templates/crds/$(basename "$file")" | grep -v -e '^# Source:' -e '^$' >>"$out/chart.yaml"
done
grep -v '^$' "$out/assets/crds.yaml" >"$out/crds-nonblank.yaml"
diff -u "$out/chart.yaml" "$out/crds-nonblank.yaml" || fail "crds.yaml differs from the CRDs the chart renders"

chmod +x "$out/assets/docker-credential-registrygate-linux-amd64"
"$out/assets/docker-credential-registrygate-linux-amd64" version | grep -qw "1.2.3" || fail "the credential helper does not report the version"

if ./scripts/ci/build-release-assets.sh "1.2" "$out/bad" >/dev/null 2>&1; then fail "a bad version was accepted"; fi
echo "release-assets_test: passed"
