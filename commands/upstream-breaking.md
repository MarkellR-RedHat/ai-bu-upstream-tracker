You are running a threat sweep across all upstream dependencies for Red Hat's AI Business Unit. Your mission: find every breaking change and deprecation that shipped in the last 14 days, confirm whether it actually affects us, and provide migration steps for anything that does. Do not cry wolf. A PR that mentions "breaking" in its title but only affects an internal test helper is not a threat. Verify before you flag.

If $ARGUMENTS is provided, use it as a filter: a specific project name, time window ("last 30 days"), or version ("vllm 0.8.x").

## Approach

1. Read all project definition files in `projects/`. Use each project's "Breaking Change Patterns" section to know what to look for.
2. For EACH tracked project, scan the last 14 days:
   - `gh search prs --repo <org/repo> --merged-at ">=$(date -v-14d +%Y-%m-%d)" "breaking OR deprecated OR removal OR migration OR incompatible OR removed" --limit 10`
   - `gh release list --repo <org/repo> --limit 3` then `gh release view <tag> --repo <org/repo>` for releases in the window
   - `gh issue list --repo <org/repo> --label "breaking-change,deprecation,migration,breaking" --state open --limit 5`
3. Read the body of each matching PR or release note. Confirm the change is genuinely breaking before including it.
4. For each confirmed breaking change, trace impact: which of our repos or components use the affected API, behavior, or interface? What version are we pinned to? When does this actually hit us?
5. Classify severity:
   - CRITICAL - Breaks our build or runtime in production. Must fix before next deploy.
   - HIGH - Breaks integration tests or staging. Blocks upgrade path.
   - MEDIUM - Requires code changes to adopt new version but current version still works.
   - LOW - Deprecation warning only. No breakage yet, but removal is planned.

## Calibration

Good output: "[CRITICAL] vLLM removed --model-loader flag (PR #17289). Our Dockerfile uses this flag. Migration: change line 47 of Dockerfile from --model-loader=safetensors to --load-format=safetensors. Test: rebuild and verify model loads."

Bad output: "[HIGH] vLLM had several breaking changes this week. Review the changelog."

## Output Format

**Upstream Breaking Changes - Threat Sweep**
*Scanned: <today's date> | Window: last 14 days*
*Projects scanned: <count> | Breaking changes found: <count> | Deprecations found: <count>*

### Risk Dashboard

| Severity | Project | Change | Affects Us | Action Deadline |
|----------|---------|--------|------------|-----------------|
| CRITICAL | vLLM | Removed --model-loader flag | Yes - our Dockerfile | Before next build |
| HIGH | KServe | InferenceService CRD v1beta1 removed | Yes - our operator | Before OCP 4.17 |
| MEDIUM | Ray | Autoscaler config format changed | Maybe - check KubeRay | Next quarter |

### Critical and High Severity

For each CRITICAL or HIGH finding:

#### [SEVERITY] <Project> - <One-line description>

**What changed:** Technically precise description.
**PR/Release:** #NNN or vX.Y.Z (link)
**Impact on our stack:** Which component, how we use it, what breaks (build / runtime / tests / config).
**Migration steps:**
1. Specific step with code or config example
2. Verification step

**Estimated effort:** <hours/days> for <role>

### Medium Severity

Condensed, one entry per line:
- **<Project>** PR #NNN: <what changed> - *Affects:* <component> - *Migration:* <one-line> - *Timeline:* <when>

### Deprecations with Removal Timeline

| Project | What | Deprecated In | Removal Target | Our Usage |
|---------|------|--------------|----------------|-----------|

### Upcoming Breaking Changes (Not Yet Shipped)

Open issues or PRs that signal future breakage:
- **<Project>** Issue #NNN: <what is proposed> - *Risk:* <what would break> - *Timeline:* <when it might land>

### Clean Projects

Projects with no breaking changes or deprecations in this window: <comma-separated list>

## Anti-Patterns

- Do not report a PR as breaking just because it contains the word "breaking" in the title. Read the content.
- Do not classify everything as CRITICAL. Save that for real production breakage.
- Do not say "review this change" without explaining what specifically might break and how to fix it.
- Do not include migration steps that are just "see the PR for details."

## Self-Critique

Before outputting, verify:
- Every CRITICAL/HIGH item has specific migration steps an engineer can follow without further research.
- Severity levels are honest. CRITICAL means actually broken, not "could be a problem."
- Impact traces reference our actual components, not generic statements.
- False positives have been filtered out. If you cannot confirm something is truly breaking, mark it UNCONFIRMED and explain your uncertainty.
