You are mapping the power structure of an upstream project for Red Hat's AI Business Unit. This is not a leaderboard. You need to answer: who actually controls what ships? Who can block our PRs? Where are we absent from decisions that affect us? Commit counts are a starting point, not the answer. The person who reviews 80% of PRs in a critical directory has more power than someone with twice the commits in docs.

Parse $ARGUMENTS to identify the target project and optional time range. If no project is specified, list available projects from the `projects/` directory and ask the user to pick one. Default time range is 30 days.

## Approach

1. Gather contributor data (commits, PRs, reviews, issue engagement, maintainer signals)
2. Identify the power structure (who merges, who blocks, who drives direction)
3. Map Red Hat presence and find the gaps that matter
4. Assess community health and fragility
5. Recommend specific engagement moves

## Data Gathering

Look up the project definition in `projects/`. Then gather data for the specified time range:

**PR authors (merged):** `gh pr list --repo <org/repo> --state merged --limit 50 --json author,mergedAt,title,number` - count per author, note areas from titles.

**Reviewers:** `gh pr list --repo <org/repo> --state merged --limit 30 --json reviews,number,title` - review gatekeepers often have more influence than PR authors.

**Commit authors:** `gh api repos/<org/repo>/commits?since=$(date -v-30d +%Y-%m-%dT%H:%M:%SZ)&per_page=100 --jq '.[].author.login'`

**Issue engagement:** `gh api repos/<org/repo>/issues/comments?since=$(date -v-30d +%Y-%m-%dT%H:%M:%SZ)&per_page=100 --jq '.[].user.login'` - active commenters shape direction even without code.

**Maintainer signals:** Check who merges PRs, who gets tagged for review, who responds fastest. Check OWNERS/MAINTAINERS/CODEOWNERS files if referenced in the project definition.

Cross-reference with known Red Hat contributors and affiliations.

## Output Format

**<Project Name> - Contributor Power Map**
*Generated: <today's date> | Period: last <N> days | Repository: <org/repo>*

### Power Structure

**Maintainers / Gatekeepers** (people who merge PRs and control direction)
| Contributor | Role | PRs Merged | Reviews | Areas of Focus |
|-------------|------|------------|---------|----------------|

**Top Contributors** (top 10 by merged PRs)
| Rank | Contributor | Org (if known) | PRs Merged | Focus Areas |
|------|-------------|----------------|------------|-------------|

**Review Gatekeepers** (people whose approval is effectively required)
| Contributor | Reviews Given | Approval Rate | Areas |
|-------------|---------------|---------------|-------|

### Red Hat Presence

List active RH contributors with PR counts and focus areas, then:

| Area (from project definition) | RH Active? | Key RH Contributor | Gap? |
|--------------------------------|------------|---------------------|------|

One paragraph recommendation on where to increase engagement and why.

### Community Health

| Metric | Value | Assessment |
|--------|-------|------------|
| Active contributors (period) | N | Healthy / Concerning / Critical |
| New contributors (period) | N | Growing / Stable / Shrinking |
| Bus factor (top N do 80% of work) | N | Healthy (5+) / Risky (2-4) / Critical (1) |
| Median PR review time | ~N days | Fast / Acceptable / Slow |
| Contribution concentration | top 3 do X% | Distributed / Concentrated / Dangerous |

### Who to Engage

For each critical technical area, name the specific person, why they matter, and how responsive they are to external PRs.

### Strategic Observations

Two to three sentences about contributor dynamics that affect Red Hat's planning.

## Calibration

### Example 1: Vanity Metrics vs. Power Analysis

Bad output: "Red Hat is an active contributor to the project with several engineers participating."
Good output: "Red Hat has zero reviewer presence in vllm/entrypoints/, which is where 4 of the last 6 breaking API changes originated. @alice reviews 90% of PRs in that directory. Recommendation: assign an engineer to review PRs in entrypoints/ and build a relationship with @alice."

### Example 2: Commit Count vs. Influence Map

Bad output: "The top 5 contributors by commit count are listed below."
Good output: "@maintainerX has only 12 commits this quarter but reviews 80% of PRs in the scheduler directory. They approved the last 3 breaking changes before anyone downstream noticed. @maintainerY has 200 commits, all in docs and CI. For scheduling decisions, @maintainerX is the gatekeeper."

### Example 3: Generic Gap vs. Specific Risk

Bad output: "Red Hat could increase its contributions to this project."
Good output: "Red Hat has 3 active contributors, all focused on vllm/engine/. Nobody from Red Hat touches vllm/distributed/ or vllm/worker/. The last two changes that broke our multi-GPU setup both came from vllm/worker/. We are blind in the area that hurts us most."

## Self-Critique

Before outputting, verify:
- Power structure reflects actual influence, not just commit counts
- Red Hat gaps reference specific project areas, not vague hand-waving
- Engagement recommendations name specific people, directories, and actions
- Bus factor assessment is honest, not optimistic

## Edge Cases

Handle these explicitly. Do not silently skip them.

### Single-Org Dominance
If 80%+ of commits and reviews come from one organization, add a "**Concentration Risk**" callout after the Power Structure section. Name the org, the percentage, and the strategic implication: "If <org> deprioritizes this project, there is no fallback maintainer base. Red Hat should either diversify the contributor pool or plan for a fork scenario."

### Key Maintainer Departure
If a top-3 contributor (by review activity or merge authority) has zero activity in the last 30 days after being consistently active, flag this in the Community Health section: "<username> was a top reviewer in <area> and has gone quiet. Last activity: <date>. If they have left the project, the bus factor in <area> drops to N." Do not speculate on personal reasons.

### Fork Divergence from Upstream Contributor Base
If the project definition mentions a downstream fork, check whether our fork's active contributors overlap with upstream's power structure. If there is zero overlap (no Red Hat contributor reviews PRs in the areas we fork), flag: "Our fork contributors have no upstream review presence. Changes we make downstream have no advocate upstream. Risk: rebase conflicts go undetected until they break the build."

### Ghost Town Project
If fewer than 3 unique contributors have committed in the last 30 days, skip the normal Power Structure table and instead produce a "**Project Viability Warning**": contributor count, last meaningful PR, and whether the project should be evaluated for replacement or internal adoption. Recommend running `/upstream-health` for a full risk assessment.

### Bot-Dominated Activity
If automated accounts (dependabot, renovate, github-actions) represent more than 50% of commit or PR activity, exclude them from contributor counts and note: "N% of activity is automated. Human contributor metrics are reported separately below." This prevents inflated health signals.

## Cross-Tool Integration

After completing the power map, suggest exactly one follow-up:
- If Red Hat has gaps in critical areas: "Run `/upstream-opportunity <project>` to find contribution targets that would fill the gaps identified above."
- If bus factor is critical (1-2): "Run `/upstream-health <project>` to assess overall dependency risk given the contributor concentration."
- If a maintainer departure is detected: "Run `/upstream-forecast <project>` to check whether stalled PRs correlate with the missing maintainer."
- If the power map looks healthy: "No immediate concerns. Run `/upstream <project>` for a threat scan of recent changes."

## Anti-Patterns

- Do not rank contributors by commit count without explaining influence
- Do not assume GitHub usernames map to companies without evidence
- Do not recommend "increasing contributions" without saying where and why
- Do not ignore the review layer - reviewers often have more power than authors
- Do not count bot activity as human contribution
