#!/usr/bin/env bash
# Prints the pinned images the e2e cluster's pods pull, one per line, derived
# from the files that name them (run from the repository root). test/e2e/up.sh
# preloads them through the Docker daemon, and the shared CI's cleanup (ci.yaml's keep-images) keeps them
# while it removes older versions. With --node it prints the kind node image too.
set -euo pipefail
repos="$(mktemp)"
tags="$(mktemp)"
trap 'rm -f "$repos" "$tags"' EXIT
cert_manager_version="$(grep -o -m1 -- '--version v[0-9][0-9.]*' docs/admin/upstreams.md | head -n1 | cut -d' ' -f2)"
{
	if [ "${1:-}" = --node ]; then
		grep -oE '^node_image="[^"]+"' test/e2e/up.sh | cut -d'"' -f2
	fi
	grep -E '^\s*repository:' test/e2e/harbor-values.yaml | awk '{print $2}' >"$repos"
	grep -E '^\s*tag:' test/e2e/harbor-values.yaml | awk '{print $2}' >"$tags"
	paste -d: "$repos" "$tags"
	grep -oE '"mirror\.gcr\.io/[^"]+"' test/e2e/env_test.go | tr -d '"'
	helm template cert-manager oci://quay.io/jetstack/charts/cert-manager --version "$cert_manager_version" --set crds.enabled=true |
		awk '$1 == "image:" || $1 == "-" && $2 == "image:" {print}' | sed -E 's/.*image: *//; s/"//g'
} | sort -u
