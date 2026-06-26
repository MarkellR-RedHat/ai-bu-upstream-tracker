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

Good output: "Red Hat has zero reviewer presence in vllm/entrypoints/, which is where 4 of the last 6 breaking API changes originated. @alice reviews 90% of PRs in that directory. Recommendation: assign an engineer to review PRs in entrypoints/ and build a relationship with @alice."

Bad output: "Red Hat is an active contributor to the project with several engineers participating."

## Self-Critique

Before outputting, verify:
- Power structure reflects actual influence, not just commit counts
- Red Hat gaps reference specific project areas, not vague hand-waving
- Engagement recommendations name specific people, directories, and actions
- Bus factor assessment is honest, not optimistic

## Anti-Patterns

- Do not rank contributors by commit count without explaining influence
- Do not assume GitHub usernames map to companies without evidence
- Do not recommend "increasing contributions" without saying where and why
- Do not ignore the review layer - reviewers often have more power than authors
