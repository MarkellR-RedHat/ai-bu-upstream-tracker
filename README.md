# ai-bu-upstream-tracker

Claude Code slash commands that turn upstream open source project monitoring into actionable engineering intelligence for Red Hat's AI Business Unit.

## What It Does

These are not activity logs. They are intelligence reports that tell you what changed, what it means for your work, and whether you need to act.

Nine commands, three categories:

### Core Intelligence
- `/upstream <project>` -- Intelligence report on a single project. Goes beyond "what happened" to assess impact on our stack and classify urgency as ACT NOW, PLAN FOR IT, or BE AWARE.
- `/upstream-weekly` -- Weekly digest across all tracked projects with an executive summary, urgency dashboard, and cross-project pattern analysis.
- `/upstream-breaking` -- Breaking changes risk assessment with severity classification, impact traces, and specific migration steps.

### Deep Analysis
- `/upstream-impact <repo> <PR#>` -- Deep impact analysis of a specific upstream change. Traces the blast radius through our components, assesses compatibility, and produces a migration plan with effort estimates.
- `/upstream-migration <repo> <old-version> <new-version>` -- Step-by-step migration guide with before/after code examples, gotchas from community reports, and a dependency-ordered upgrade plan.
- `/upstream-health <project>` -- Health assessment scoring commit activity, bus factor, PR review time, release cadence, and more. Produces a "should we depend on this?" recommendation.
- `/upstream-forecast <project>` -- Forward-looking briefing on what ships next, what is being discussed, and what is stalled, with confidence levels and planning implications.

### Community Intelligence
- `/upstream-contributor <project>` -- Contributor landscape mapping: who holds influence, where Red Hat stands, where we have gaps, and who to engage.
- `/upstream-opportunity` -- Strategic contribution opportunities prioritized by value to Red Hat, not just labeled "good first issue."

## Tracked Projects

| Project | Repository | Why We Care |
|---------|-----------|-------------|
| vLLM | vllm-project/vllm | Core inference engine for LLM serving |
| llm-d | llm-d/llm-d | Distributed LLM serving, scalability pillar focus |
| KServe | kserve/kserve | Model serving framework on OpenShift AI |
| InstructLab | instructlab/instructlab | Red Hat's upstream for model training and alignment |
| Kubernetes | kubernetes/kubernetes | Platform foundation, scheduling, device plugins |
| OpenShift | openshift/enhancements | The platform we ship on |
| Ray | ray-project/ray | Distributed training and serving workloads |
| Kubeflow | kubeflow/kubeflow | ML platform on Kubernetes, training operator |
| Caikit | caikit/caikit | AI runtime framework for model serving |
| Podman AI Lab | containers/podman-desktop-extension-ai-lab | Container-native local AI development |

See [reference/key-upstreams.md](reference/key-upstreams.md) for detailed information on each project including key maintainers, critical code areas, and downstream ownership.

## Installation

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-upstream-tracker.git
cd ai-bu-upstream-tracker
chmod +x install.sh
./install.sh
```

This copies the command files to `~/.claude/commands/` so they are available as slash commands in Claude Code.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- GitHub CLI (`gh`) installed and authenticated (the commands use `gh api` and `gh pr list` to fetch data)

## Usage Examples

### Intelligence report on a single project

```
/upstream vllm
```

Produces a report like:

```
vLLM - Upstream Intelligence Report
Generated: 2026-06-26 | Repo: vllm-project/vllm

Situation Overview

vLLM is in active development between v0.8.2 and v0.8.3, with 34 PRs
merged this week. The pace of change is high, focused on disaggregated
inference and multi-LoRA support. One breaking change requires attention.

Immediate Attention Required

[ACT NOW] PR #17289: Removed deprecated --model-loader CLI flag
  Impact on us: Our Dockerfile passes --model-loader=safetensors.
  This flag no longer exists in main.
  Action: Update Dockerfile to use --load-format=safetensors before
  next image build.

Plan For Next Cycle

[PLAN] PR #17100: RFC for new disaggregated prefill API
  Impact on us: llm-d routing logic depends on the current prefill
  interface. If this RFC ships, our scheduler integration needs updating.
  Timeline: Targeting v0.9.0, likely 6-8 weeks out.
  Action: Review RFC and comment on our requirements by July 10.

Awareness

- PR #17234: Multi-LoRA batching improvements (@alice) - performance
  gain for multi-model serving, no API changes
- PR #17301: Async engine shutdown refactor (@bob) - cleaner cleanup,
  no behavior change for consumers

Quick Reference

| Category             | Status                    |
|----------------------|---------------------------|
| Latest release       | v0.8.2 (2026-06-15)      |
| PRs merged (7d)      | 34                        |
| Breaking changes (14d)| 1                        |
| Open proposals       | 3                         |
| Overall urgency      | ACT NOW                   |
```

### Project health assessment

```
/upstream-health vllm-project/vllm
```

Produces a health scorecard:

```
vLLM - Upstream Health Assessment
Generated: 2026-06-26
Repository: vllm-project/vllm

Health Score: 4.2/5.0 - HEALTHY

vLLM is a healthy, rapidly evolving project with strong contributor
diversity and fast release cadence. The main risk is the pace of
breaking changes, which requires active tracking.

Scorecard

| Dimension            | Score | Trend  | Details                          |
|----------------------|-------|--------|----------------------------------|
| Commit Activity      | 5/5   | Stable | 120+ commits/week avg            |
| Bus Factor           | 4/5   | -      | Top 5 contributors do 60%        |
| PR Review Time       | 4/5   | -      | Median 3 days                    |
| Issue Response       | 3/5   | -      | Median 5 days to first response  |
| Release Cadence      | 5/5   | -      | Monthly releases                 |
| CI Health            | 4/5   | -      | 92% of recent runs passed        |
| Dependency Freshness | 4/5   | -      | 2 stale dependency PRs           |
| Org Diversity        | 4/5   | -      | Contributors from 15+ orgs       |

Strengths
- Very active development with strong community engagement
- Fast PR review turnaround for a project this size
- Multiple organizations contributing significantly

Risks
- High pace of breaking changes means frequent downstream work
- Core engine knowledge concentrated in 3 maintainers

Recommendation: Continue depending on this project. Increase our
review presence in vllm/entrypoints/ to catch API changes earlier.
```

### Breaking changes risk assessment

```
/upstream-breaking
```

Scans all tracked projects and produces a risk dashboard:

```
Upstream Breaking Changes Risk Assessment
Scanned: 2026-06-26 | Window: last 14 days
Projects scanned: 10 | Breaking changes found: 3 | Deprecations found: 2

Risk Dashboard

| Severity | Project | Change                      | Affects Us | Action Deadline  |
|----------|---------|-----------------------------|------------|------------------|
| CRITICAL | vLLM    | Removed --model-loader flag | Yes        | Before next build|
| HIGH     | KServe  | CRD v1beta1 field removed   | Yes        | Before OCP 4.17  |
| MEDIUM   | Ray     | Autoscaler config format    | Maybe      | Next quarter     |

Clean Projects: llm-d, InstructLab, Kubernetes, OpenShift, Kubeflow,
Caikit, Podman AI Lab
```

### Deep impact analysis

```
/upstream-impact vllm-project/vllm 17289
```

Traces a specific PR through our stack, identifies affected components, provides migration steps, and estimates effort.

### Migration guide

```
/upstream-migration vllm-project/vllm v0.7.3 v0.8.2
```

Generates a step-by-step upgrade playbook with breaking changes, deprecated APIs, gotchas, and a dependency-ordered plan.

### Forecast what ships next

```
/upstream-forecast vllm
```

Analyzes open PRs, RFCs, and maintainer signals to predict what is coming and what it means for our planning.

### Weekly digest

```
/upstream-weekly
```

Covers all tracked projects with an urgency dashboard and action items. Filter with arguments:

```
/upstream-weekly vllm and ray only
/upstream-weekly last 3 days
```

### Contributor intelligence

```
/upstream-contributor vllm
```

Maps the contributor landscape: power structure, Red Hat presence, community health, and who to engage.

### Contribution opportunities

```
/upstream-opportunity
/upstream-opportunity hackathon
/upstream-opportunity instructlab
```

Finds opportunities prioritized by strategic value, not just label.

## Adding a New Project

1. Create a new file in `projects/` named after the project (e.g., `projects/newproject.md`).

2. Use this template:

```markdown
# Project Name

## Repository
- **GitHub:** org/repo
- **Docs:** https://docs.example.com/
- **License:** Apache 2.0

## What It Is
One-line description.

## Why We Track It
Why this project matters to the AI BU.

## Key Areas to Watch
- path/to/important/code - what to look for
- another/path - why it matters

## Release Cadence
How often releases happen.

## Related Repos
- org/repo (main)
- org/other-repo (description)

## Breaking Change Patterns
- Types of breaking changes this project tends to make
```

3. Add an entry to [reference/key-upstreams.md](reference/key-upstreams.md).

4. The commands will automatically pick up the new project definition. Run `./install.sh` again only if you updated command files.

## How It Works

The commands are Claude Code slash command files (Markdown with instructions). When you invoke one, Claude reads the project definitions from the `projects/` directory, uses the GitHub CLI to query recent activity, and produces structured intelligence reports.

Every command follows the same analysis pattern:
1. Gather raw data via `gh` CLI
2. Filter signal from noise using project definitions
3. Assess impact on our downstream usage
4. Classify urgency
5. Recommend specific actions

The commands include self-critique checklists to prevent common failure modes like flagging everything as urgent, listing activity without context, or recommending vague "monitoring."

## Project Structure

```
ai-bu-upstream-tracker/
  commands/               # Slash command definitions
    upstream.md           # Single project intelligence report
    upstream-weekly.md    # Weekly digest across all projects
    upstream-breaking.md  # Breaking changes risk assessment
    upstream-contributor.md  # Contributor landscape mapping
    upstream-opportunity.md  # Strategic contribution opportunities
    upstream-impact.md    # Deep impact analysis of specific changes
    upstream-migration.md # Version migration guide generator
    upstream-health.md    # Project health assessment
    upstream-forecast.md  # Forward-looking predictions
  projects/               # Project definitions (what we track and why)
  reference/              # Reference material
    key-upstreams.md      # Key upstream projects for AI BU
  install.sh              # Install commands to ~/.claude/commands/
```

## Limitations

- GitHub API rate limits apply. If you hit rate limits, the commands will tell you and provide the `gh` commands to run manually.
- Private repos require appropriate `gh` authentication and permissions.
- The commands check rolling windows (7 or 14 days by default). Override with arguments like "last 30 days."
- Health scores and forecasts are assessments, not guarantees. Use them as inputs to engineering judgment, not replacements for it.

## License

Apache 2.0
