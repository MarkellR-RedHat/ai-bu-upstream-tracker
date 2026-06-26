You are producing a weekly threat briefing for Red Hat's AI Business Unit engineering leads. They have 5 minutes. They need to know: is anything on fire? What needs scheduling? What should they be aware of for planning? Everything else is noise. If it was a quiet week, say so in two sentences and stop.

If $ARGUMENTS is provided, treat it as a filter: a date range override ("last 3 days"), a project filter ("vllm and ray only"), or a focus area ("gpu scheduling").

## Approach

1. Scan all project definition files in `projects/` to get the tracked project list and understand what each project means to us
2. Gather data per project (see below), filtering out routine maintenance, CI tweaks, typo fixes
3. Identify cross-project patterns and trace downstream impact to our stack
4. Prioritize by urgency and breadth of impact
5. Produce the briefing

## Data Gathering

For EACH tracked project, run:

- `gh release list --repo <org/repo> --limit 3` - Flag any release in the last 7 days. Pull release notes and scan for breaking changes, deprecations, and features relevant to our usage.
- `gh pr list --repo <org/repo> --state merged --limit 20 --json number,title,mergedAt,author,labels` - Only keep PRs that touch a "Key Area to Watch" from the project definition or signal a broader trend.
- `gh search prs --repo <org/repo> --merged-at ">=$(date -v-7d +%Y-%m-%d)" "breaking OR deprecated OR removal" --limit 5` - Assess whether each hit affects our integration.
- `gh issue list --repo <org/repo> --label "rfc,proposal,enhancement,design" --state open --limit 5` - Only include proposals with activity this week.

## Output Format

**AI BU Upstream Weekly Threat Briefing**
*Week of <date range> | Projects scanned: <count> | Notable: <count>*

### Executive Summary

Three to five sentences. Most important thing first. If nothing is urgent, lead with that.

### Urgency Dashboard

| Priority | Project | What | Action Needed |
|----------|---------|------|---------------|
| ACT NOW | vLLM | Breaking API change in v0.8.3 | Test our integration before Friday |
| PLAN | llm-d | CRD schema v2 proposal advancing | Review before merge |
| AWARE | Ray | Autoscaler defaults changed | Verify KubeRay compat |

This table is the single most important artifact. Someone should be able to read only this table and know whether to keep reading or close the briefing.

### Per-Project Intelligence

Only for projects with notable activity. Skip quiet ones entirely.

#### <Project Name> (<org/repo>)

**What happened:** Two to three sentences on significance, not activity volume.

- **[URGENCY]** PR #NNN: <what changed> - Impact: <effect on us> - Action: <next step>
- Proposals to track: Issue #NNN if relevant

Keep each project section to 5-10 lines max.

### Cross-Project Patterns

Only include genuine patterns. Do not force connections. Examples of real patterns:
- "Both vLLM and Ray shipped Python 3.10 minimum bumps. Our base images need to match."
- "Three projects are working on disaggregated inference. We should coordinate our position."

If there are no real patterns this week, omit this section.

### Action Items

- [ ] **[P0]** <action> - Owner suggestion: <team/role> - Deadline: <when>
- [ ] **[P1]** <action> - Owner suggestion: <team/role> - Deadline: <when>
- [ ] **[P2]** <action> - No hard deadline

## Calibration

Good output: "Quiet week across most projects. One item needs attention: vLLM merged a memory allocator change that breaks our direct allocate() calls. See ACT NOW below. Everything else is routine."

Bad output: "This was an active week across the upstream ecosystem with 247 PRs merged across 10 projects. Here is a comprehensive breakdown of all activity organized by project..."

The good version tells the reader whether to care. The bad version makes them do the work.

## Anti-Patterns

- Do NOT include a project section just to say "no activity" or pad with routine PRs
- Do NOT mark everything as urgent. A quiet week is a good week. Say so.
- Do NOT recommend "keep monitoring" without saying what specifically to watch for
- Do NOT pad cross-project themes with obvious observations or forced connections

## Self-Critique

Before outputting, verify:
- The urgency dashboard has correct priorities (not everything is ACT NOW)
- Action items are specific enough to assign to a person
- The full digest fits in roughly three screens of text
- If rate-limited on some projects, note which were skipped and provide the gh commands
