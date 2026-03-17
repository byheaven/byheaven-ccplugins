---
name: github-repo-setup
description: "Configures GitHub repository settings: PR templates, issue templates (YAML forms), CODEOWNERS, and branch protection rules. Use this skill when the user wants to add a pull request template, set up structured issue forms, configure code ownership, protect the main branch, or automate repository configuration via the GitHub CLI. Also use when the user mentions improving PR quality, wanting structured bug reports or feature requests, setting up required reviewers, or enabling branch protection rules programmatically."
---

# GitHub Repository Setup Skill

Configures the GitHub-specific files and repository settings that make collaboration
structured and consistent: PR templates, issue forms, CODEOWNERS, and branch protection.

## Step 0: Prerequisites

```bash
# Confirm GitHub CLI is installed and authenticated
gh auth status

# Confirm we're in a git repo with a remote
git remote -v

# Get the repo name for gh api calls
gh repo view --json nameWithOwner --jq .nameWithOwner
```

If `gh` is not installed or authenticated, guide the user:
```bash
# Install (macOS)
brew install gh

# Authenticate
gh auth login
```

---

## Step 1: Pull Request Template

Check if `.github/pull_request_template.md` already exists. If not, create it
from `assets/templates/pull-request-template.md`:

```bash
mkdir -p .github
cp assets/templates/pull-request-template.md .github/pull_request_template.md
```

Review the template with the user and customize checklist items for the project's
specific requirements (e.g., add "Run database migrations" for backend projects).

---

## Step 2: Issue Templates (YAML Forms)

Create the issue templates directory and copy the templates:

```bash
mkdir -p .github/ISSUE_TEMPLATE
cp assets/templates/bug-report.yml .github/ISSUE_TEMPLATE/bug-report.yml
cp assets/templates/feature-request.yml .github/ISSUE_TEMPLATE/feature-request.yml
```

Ask the user:
- **Project name**: used in the form labels (e.g., `project: my-app`)
- **Additional labels**: any project-specific labels to add to issue forms

Update the `labels:` field in each YAML template to include project-specific labels.

---

## Step 3: CODEOWNERS

Ask the user:
- Do you have a team? How is ownership divided?
  - By area (frontend/backend/infra)?
  - By file type?
  - One owner for the whole repo?

Create `.github/CODEOWNERS` from `assets/templates/CODEOWNERS.template`.
Replace the placeholder entries with the actual GitHub usernames or team names.

**Common patterns:**
```
# Single owner for everything
*  @username

# Team ownership by directory
src/frontend/   @org/frontend-team
src/backend/    @org/backend-team
.github/        @org/platform-team

# File type ownership
*.tf            @org/infra-team
*.sql           @org/dba-team
```

---

## Step 4: Branch Protection

Apply branch protection to `main` using the GitHub CLI.
Copy `assets/scripts/configure-branch-protection.sh` and run it after customization:

```bash
chmod +x assets/scripts/configure-branch-protection.sh
```

Or apply directly via `gh api`:

```bash
REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)

gh api \
  --method PUT \
  "repos/${REPO}/branches/main/protection" \
  --field required_status_checks='{"strict":true,"contexts":[]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
  --field restrictions=null \
  --field allow_force_pushes=false \
  --field allow_deletions=false
```

**Ask the user before running:**
- How many required reviewers? (default: 1)
- Should CI status checks be required? (yes, but we'll add them after CI is set up)
- Should admins be exempt from protection? (default: no)

**Note:** Required status checks (`contexts`) should be added after the CI workflow
has run at least once and the check names are known. Leave empty initially.

---

## Step 5: Commit and Push

```bash
git add .github/
git commit -m "chore: add GitHub repository configuration"
git push
```

---

## Step 6: Verify

- Open a test PR and verify the template auto-fills
- Go to the repo → Issues → New Issue and verify both issue forms appear
- Go to Settings → Branches and confirm protection rules are applied

---

## Reference Files

- `references/decisions.md` — Why YAML issue forms, CODEOWNERS placement, and gh api over UI
- `assets/templates/` — PR template, issue forms, CODEOWNERS template
- `assets/scripts/configure-branch-protection.sh` — Reusable branch protection script
