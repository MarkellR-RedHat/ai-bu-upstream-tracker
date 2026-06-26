You are writing a field-tested upgrade playbook for Red Hat AI Business Unit engineers. This is not a changelog. This is the document an engineer follows at 2am when the upgrade has to happen before morning. Every breaking change has before/after code. Every gotcha is sourced from real community reports. Every step has a verification check. If you cannot determine the exact migration for a change, say so and explain how to investigate.

Parse $ARGUMENTS to get: the upstream repo (org/repo), the old version (current), and the new version (target). If any are missing, ask the user to provide all three.

## Approach

1. Diff the versions and get the full changelog between old and new
2. Identify every breaking change that requires code modification on our side
3. Find deprecated APIs (still work, will break later) with removal timelines
4. Collect gotchas from issues, discussions, and community reports
5. Build a dependency-ordered upgrade plan with verification at each step

## Data Gathering

1. Look up the project definition in the `projects/` directory.

2. Fetch version comparison data:
   - Release notes: `gh release view <new-version> --repo <org/repo>` (also get intermediate releases via `gh release list --repo <org/repo> --limit 20`)
   - Commits: `gh api repos/<org/repo>/compare/<old-version>...<new-version> --jq '.commits[].commit.message' | head -100`
   - PRs with labels "breaking", "deprecated", "migration", "API change" merged between versions
   - Migration issues: `gh search issues --repo <org/repo> "migration OR upgrade OR breaking" --limit 20`
   - Migration docs: check for CHANGELOG.md, MIGRATION.md, UPGRADING.md, or docs/migration/ in the repo

3. Cross-reference with community reports of upgrade problems filed after the new version release.
## Output Format

**Migration Guide: <Project> <old-version> to <new-version>**
*Generated: <date> | Repo: <org/repo> | Commits between versions: <count>*

### Migration Summary

| Category | Count | Effort Estimate |
|----------|-------|-----------------|
| Breaking changes | N | N hours/days |
| Deprecated APIs | N | N hours/days |
| Known gotchas | N | - |
| **Total** | | **N hours/days** |

### Pre-Migration Checklist

- [ ] Read this entire guide before starting
- [ ] Ensure test suite passes on current version
- [ ] Create a branch for the upgrade

### Breaking Changes (ordered by severity)

**BC-1: <Short description>** (CRITICAL / HIGH / MEDIUM) PR: #NNN
```
# Old (no longer works)
<code example>

# New (replacement)
<code example>
```
Files to update: <list with line numbers where possible>
Verification: <how to confirm the migration worked>

### Deprecated APIs

| API/Feature | Deprecated In | Removal Target | Replacement | Update Now? |
|------------|--------------|----------------|-------------|-------------|
| old_function() | <version> | <future version> | new_function() | Yes/No |

For high-priority deprecations, include before/after code examples.

### Gotchas

Non-obvious issues not in the changelog. For each: **<Title>** - <description>. Source: Issue #NNN / community report. Workaround: <if applicable>

### Step-by-Step Upgrade Plan (dependency order)

1. Update dependency version in <file>. Verify: <check>
2. Apply each BC-N change in order. Verify after each: <test command>
3. Run full test suite. Expected: <what should pass>
4. Update deprecated API usage (can be a follow-up PR)
5. Post-upgrade verification: all tests pass, functional checks, performance checks

### Rollback Plan

How to revert, and what to check before re-attempting.

## Calibration

### Example 1: Changelog Paste vs. Migration Step

Bad output: "Several API parameters were renamed. See the changelog for details."
Good output: "BC-1: model_loader parameter removed. Old: `engine = LLMEngine(model_loader="safetensors")`. New: `engine = LLMEngine(load_format="safetensors")`. Files to update: serving/config.py line 34, tests/test_engine.py line 12."

### Example 2: Hand-Waving Gotchas vs. Sourced Warnings

Bad output: "There may be some compatibility issues when upgrading."
Good output: "Gotcha: the new async engine silently drops requests that exceed the new 30s timeout default (changed from 120s in v0.7). Three users reported this in Issue #4890. Workaround: set VLLM_REQUEST_TIMEOUT=120 until you audit your expected latencies. This is not in the changelog."

### Example 3: Generic Plan vs. Dependency-Ordered Steps

Bad output: "Update your dependencies and test thoroughly."
Good output: "Step 1: Bump vllm in requirements.txt from 0.4.2 to 0.4.3. Do NOT update ray yet. Step 2: Apply BC-1 (model_loader rename) in serving/config.py. Step 3: Apply BC-2 (scheduler API change) in scheduler/priority.py. Step 4: Run `pytest tests/serving/` -- expect 2 new warnings about deprecated batch_size parameter. Step 5: Now bump ray to 2.10 (requires vllm 0.4.3+). Step 6: Full test suite."

## Anti-Patterns

- Do NOT paste the changelog and call it a migration guide
- Do NOT list breaking changes without showing old and new code
- Do NOT skip the gotchas section - it is often the most valuable part
- Do NOT forget to include test suite updates in effort estimates

## Self-Critique

- Every breaking change has before/after code with specific file locations
- Upgrade plan is in correct dependency order
- Effort estimates account for testing, not just code changes
- Gotchas are based on evidence (issues, reports), not speculation
