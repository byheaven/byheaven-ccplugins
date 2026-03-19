#!/bin/bash
# configure-branch-protection.sh
#
# Applies default branch protection rules to the main branch via GitHub CLI.
# Human review is opt-in; the default policy relies on required status checks.
# Requires: gh CLI installed and authenticated.
#
# Usage: ./configure-branch-protection.sh [branch-name]
# Default branch: main

set -euo pipefail

BRANCH="${1:-main}"
REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)

echo "Configuring branch protection for '${BRANCH}' on ${REPO}..."

gh api \
  --method PUT \
  "repos/${REPO}/branches/${BRANCH}/protection" \
  --field 'required_status_checks={"strict":true,"contexts":[]}' \
  --field 'enforce_admins=false' \
  --field 'required_pull_request_reviews=null' \
  --field 'restrictions=null' \
  --field 'allow_force_pushes=false' \
  --field 'allow_deletions=false' \
  --field 'block_creations=false'

echo "✅ Branch protection applied to '${BRANCH}'"
echo ""
echo "Next steps:"
echo "  1. After your CI workflow runs once, add status check names:"
echo "     gh api repos/${REPO}/branches/${BRANCH}/protection --jq .required_status_checks"
echo "  2. If your team wants mandatory human review, add required reviews separately"
echo "  3. Re-run this script or update via GitHub UI: Settings → Branches"
