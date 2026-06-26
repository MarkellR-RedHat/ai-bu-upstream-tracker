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

Only for projects with findings that need attention. Skip quiet ones entirely.

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

### Example 1: Reader Does the Work vs. Briefing Does the Work

Bad output: "This was an active week across the upstream ecosystem with 247 PRs merged across 10 projects. Here is a detailed breakdown of all activity organized by project..."
Good output: "Quiet week across most projects. One item needs attention: vLLM merged a memory allocator change that breaks our direct allocate() calls. See ACT NOW below. Everything else is routine."

The good version tells the reader whether to care. The bad version makes them do the work.

### Example 2: Activity Log vs. Threat Briefing

Bad output: "vLLM: 34 PRs merged. Ray: 12 PRs merged. KServe: 8 PRs merged. InstructLab: 15 PRs merged."
Good output: "Two items this week. First: vLLM dropped the --model-loader flag (PR #17289) and our Dockerfile still uses it -- fix before the next image build. Second: KServe opened an RFC to restructure InferenceService CRD fields (Issue #3400). No action yet, but this will affect our operator if it lands. Everything else was routine."

### Example 3: Fake Cross-Project Pattern vs. Real One

Bad output: "Multiple projects saw increased activity this week, suggesting a general trend toward more development."
Good output: "Both vLLM (PR #5200) and Ray Serve (PR #38100) bumped their minimum Python to 3.10. Our base images still ship 3.9. This blocks upgrades to both projects until we rebuild base images."

## Edge Cases

Handle these explicitly. Do not silently skip them.

### Complete Quiet Week
If no tracked project has any notable findings (no releases, no breaking PRs, no active proposals), produce a shortened report: the Executive Summary ("All clear across N tracked projects this week. No threats, no notable proposals, no releases."), an empty Urgency Dashboard with a single row noting "No items this week," and stop. Do not pad with routine PR counts or filler sections. A quiet week is a good report.

### Rate Limits Block Multiple Projects
If GitHub API rate limits prevent scanning 3+ projects, do not produce partial results without disclosure. Add a "**Coverage Gaps**" section at the top listing which projects were skipped, the gh commands to scan them manually, and a note: "This briefing is incomplete. The following projects were not scanned due to API rate limits." Do not present a partial scan as a full briefing.

### New Dependency Appears in Tracked Projects
If a tracked project introduces a new dependency (visible in merged PRs touching requirements.txt, go.mod, package.json, or similar) on a project not in our `projects/` directory, flag it in Cross-Project Patterns: "**New upstream dependency detected:** <project> now depends on <new-dep> (PR #NNN). This dependency is not in our tracked set. If it is in our critical path, consider adding a project definition."

### Project Archived or Ownership Transferred Mid-Week
If `gh repo view` shows a tracked project has been archived or transferred to a new org since the last briefing, this is an ACT NOW item regardless of other findings. Flag it in the Urgency Dashboard and add a Per-Project Intelligence section: "Repository <org/repo> has been <archived/transferred>. Immediate assessment needed. Run `/upstream-health <project>` for a full viability check."

### Correlated Changes Across Projects
If the same type of change appears in 3+ projects in the same week (e.g., Python version bumps, Kubernetes API version migrations, security patches for the same CVE), elevate this from Cross-Project Patterns to the Executive Summary. This is a systemic shift, not a coincidence. Provide a single consolidated action item rather than per-project duplicates.

### First Briefing / No Baseline
If this is the first time running `/upstream-weekly` (no prior briefing to compare against), note: "This is the initial briefing with no prior baseline for comparison. Trend indicators (up/down/stable) are not available this week. They will appear in subsequent runs."

## Cross-Tool Integration

After completing the briefing, suggest the most relevant follow-up based on findings:
- If ACT NOW items exist: "Run `/upstream-impact <org/repo> <PR#>` on the highest-priority ACT NOW item to get the full blast radius analysis."
- If health concerns surfaced (stalled projects, low activity): "Run `/upstream-health <project>` on the most concerning project for a deep dependency risk assessment."
- If contribution gaps were visible in the findings: "Run `/upstream-opportunity` to find strategic contribution targets that would improve our position."
- If all clear: "Clean week. No follow-up needed. Next scheduled briefing: <date + 7 days>."

## Anti-Patterns

- Do NOT include a project section just to say "no activity" or pad with routine PRs
- Do NOT mark everything as urgent. A quiet week is a good week. Say so.
- Do NOT recommend "keep monitoring" without saying what specifically to watch for
- Do NOT pad cross-project themes with obvious observations or forced connections
- Do NOT present a partial scan (due to rate limits) as a complete briefing without disclosure

## Self-Critique

Before outputting, verify:
- The urgency dashboard has correct priorities (not everything is ACT NOW)
- Action items are specific enough to assign to a person
- The full digest fits in roughly three screens of text
- If rate-limited on some projects, note which were skipped and provide the gh commands
- Edge cases (quiet week, archived repos, correlated changes) have been handled explicitly
