#!/usr/bin/env bash
# Regenerates the committed generated code (`make generate`) with controller-gen:
#   - deepcopy methods for the API types in api/;
#   - CRD manifests into config/crd/bases (the chart reads them from there);
#   - the manager's ClusterRole (from the +kubebuilder:rbac markers) into config/rbac/role.yaml;
#   - the chart's CRD and ClusterRole templates (scripts/generate-chart.sh).
# Generated code is committed and never edited by hand.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

controller-gen object paths=./api/...
controller-gen rbac:roleName=manager-role crd paths=./... \
	output:crd:artifacts:config=config/crd/bases \
	output:rbac:artifacts:config=config/rbac

# The chart's CRD and ClusterRole templates, copied from the files above.
./scripts/generate-chart.sh

# The generated reference pages under docs/admin/.
./scripts/docs/generate-reference.sh

