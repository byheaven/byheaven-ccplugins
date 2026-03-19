#!/bin/bash
# bootstrap-labels.sh
#
# Creates or updates the standard GitHub label catalog used by the vendored
# issue templates and Dependabot workflow.
#
# Requires: gh CLI installed and authenticated.

set -euo pipefail

declare -a LABEL_SPECS=(
  "bug|d73a4a|Something is not working"
  "enhancement|a2eeef|New feature or improvement request"
  "needs-triage|fef2c0|Needs initial triage and routing"
  "dependencies|0366d6|Dependency updates and maintenance"
  "ci|1d76db|Continuous integration and automation"
  "major-update|b60205|Major dependency update requiring manual review"
  "documentation|0075ca|Documentation improvements or fixes"
  "security|b60205|Security fixes, reviews, or follow-up work"
  "release|5319e7|Release planning, packaging, or publication work"
)

for spec in "${LABEL_SPECS[@]}"; do
  IFS="|" read -r name color description <<< "${spec}"

  if gh label edit "${name}" \
    --color "${color}" \
    --description "${description}" >/dev/null 2>&1; then
    echo "Updated label: ${name}"
    continue
  fi

  gh label create "${name}" \
    --color "${color}" \
    --description "${description}" >/dev/null
  echo "Created label: ${name}"
done

echo "Standard label catalog is configured."
