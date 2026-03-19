# Design Decisions & Alternatives

---

## Why YAML issue forms over markdown templates?

GitHub issue forms (YAML) create structured forms with dropdowns, text areas,
and validation. Markdown templates are plain text that users can ignore entirely.

YAML forms:

- Enforce required fields
- Provide dropdowns for structured data (priority, category)
- Automatically apply labels
- Auto-populate the PR title prefix (`title: "bug: "`)

The main drawback is that YAML forms are slightly more complex to author. The
templates in this skill make that a one-time cost.

---

## Why bootstrap labels up front?

The vendored issue templates and Dependabot config already reference labels.
Creating the label catalog first avoids a half-configured repository where forms
and bot workflows refer to labels that do not exist yet.

The bootstrap step is idempotent:

- missing labels are created
- existing labels are updated to the standard colors and descriptions
- repeated runs converge on the same baseline instead of failing

---

## Why `gh api` for branch protection instead of documenting the UI?

The GitHub UI for branch protection changes frequently and varies by plan tier.
`gh api` is:

- Reproducible and scriptable
- Works the same across all plan tiers
- Can be committed as a script and re-run after repo recreation
- Faster than clicking through nested settings pages

---

## Why leave `required_status_checks.contexts` empty initially?

Status check names are only known after a workflow has run at least once.
GitHub requires exact check names (e.g., `CI (Node 20)`) that come from the
`name` field of the GitHub Actions job. Running branch protection setup before
the first CI run would require hardcoding names that may not match.

The recommended workflow: apply protection without status checks → push to main →
check Actions tab for job names → update protection with those exact names.

---

## Why leave human review opt-in by default?

The default target for `newproject` is a solo-maintained or lightly maintained
repository. Requiring a human review by default blocks common automation flows,
especially Dependabot patch and minor PR auto-merge.

The safer default is:

- require status checks
- block force pushes and deletions
- keep mandatory human review optional

Teams that want review gates can opt in later without changing the rest of the setup.

---

## Why only dismiss stale reviews when review requirements are enabled?

`dismiss_stale_reviews` matters only when the repository requires approvals.
When no approval is required, enabling review-specific settings adds noise
without changing merge policy.

If a team later enables required reviews, stale review dismissal is still the
right companion setting because it prevents the "approve now, change later"
pattern after new commits are pushed.

---

## Why one PR template at `.github/pull_request_template.md`?

GitHub supports multiple PR templates but requires users to select them manually.
A single template that covers all PR types is simpler and has higher adoption.
Teams that genuinely need different templates for different PR types (e.g., release
vs. feature) can add multiple templates after the default is established.

---

## Why CODEOWNERS in `.github/` instead of the root?

GitHub checks three locations for CODEOWNERS in this priority order:
`.github/`, root, and `docs/`. `.github/` is the most explicit and conventional
location for all GitHub-specific configuration files.

---

## Why ship `CODEOWNERS.example` instead of active `CODEOWNERS` by default?

An active `CODEOWNERS` file immediately changes repository behavior by requesting
reviewers on every matching pull request. That is useful for teams with clear
ownership boundaries, but it is too opinionated as a default for solo repos.

Shipping `CODEOWNERS.example` preserves the template and the documentation while
keeping automatic reviewer assignment opt-in.
