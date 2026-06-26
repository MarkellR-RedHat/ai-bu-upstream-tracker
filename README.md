# ai-bu-upstream-tracker

Last month, an upstream project deprecated an API you depend on. You found out when CI turned red. This tool makes sure that never happens again.

These are Claude Code slash commands that act as an early warning system for Red Hat's AI Business Unit. They watch upstream open source projects, flag the changes that could hurt you, and tell you exactly what to do about them. Not activity logs. Threat assessments.

## How It Catches Threats

Nine commands. Three tiers of analysis.

### Threat Detection

- `/upstream <project>` - Threat assessment for a single project. Classifies every finding as ACT NOW, PLAN, or WATCH. Ignores noise.
- `/upstream-weekly` - Weekly threat briefing across all tracked projects. If it was a quiet week, it says so in two sentences.
- `/upstream-breaking` - Threat sweep across all projects for breaking changes and deprecations. Produces a risk dashboard with migration steps.

### Deep Analysis

- `/upstream-impact <repo> <PR#>` - Blast radius analysis of a specific upstream change. Traces it through our stack, identifies what breaks, and estimates fix effort.
- `/upstream-migration <repo> <old-version> <new-version>` - Field upgrade playbook with before/after code, gotchas from community reports, and a dependency-ordered plan.
- `/upstream-health <project>` - Dependency risk assessment. Bus factor, release cadence, maintainer concentration. Answers "should we still bet on this project?"
- `/upstream-forecast <project>` - Forward-looking intelligence. What ships next, what is being discussed, what stalled. Predicts impact on our planning.

### Community Intelligence

- `/upstream-contributor <project>` - Power map of who controls what ships, where Red Hat has influence, and where we have gaps.
- `/upstream-opportunity` - Strategic contribution targets prioritized by influence value, not just labeled "good first issue."

## Example: Tracing a Threat to Your Code

```
/upstream-impact vllm-project/vllm 17289
```

Output:

```
Upstream Impact Analysis
Change: PR #17289 | Project: vllm-project/vllm | Date: 2026-06-26

Change Summary
  What changed: Removed the deprecated --model-loader CLI flag.
  Type: Breaking
  Status: Merged

Impact Assessment

| Layer      | Affected? | Severity | Details                             |
|------------|-----------|----------|-------------------------------------|
| Direct API | Yes       | CRITICAL | CLI flag we pass in our Dockerfile  |
| Behavior   | No        | NONE     |                                     |
| Ecosystem  | No        | NONE     |                                     |

Overall Impact: CRITICAL

Affected Components

  vllm-serving Dockerfile (line 47)
    Current: --model-loader=safetensors
    After PR: flag does not exist, container fails to start
    Fix: change to --load-format=safetensors

Migration Path
  Option A: Update Dockerfile line 47. Rebuild. Verify model loads.
  Effort: 15 minutes plus CI validation.
  Risk if delayed: next image build produces a broken container.
```

That is what every report looks like. Specific. Traceable. Actionable.

## Example: Threat Assessment

```
/upstream vllm
```

Output:

```
vLLM - Threat Assessment
Scanned: 2026-06-26 | Repo: vllm-project/vllm

Situation
vLLM is in active development between v0.8.2 and v0.8.3. 34 PRs merged
this week. High pace of change focused on disaggregated inference and
multi-LoRA support. One breaking change requires attention.

ACT NOW
[ACT NOW] PR #17289: Removed deprecated --model-loader CLI flag
  Blast radius: Our Dockerfile passes --model-loader=safetensors.
  This flag no longer exists in main.
  Action: Update Dockerfile to use --load-format=safetensors before
  next image build.

PLAN
[PLAN] PR #17100: RFC for new disaggregated prefill API
  Impact: llm-d routing logic depends on the current prefill interface.
  Runway: Targeting v0.9.0, likely 6-8 weeks out.
  Action: Review RFC and comment on our requirements by July 10.

WATCH
- PR #17234: Multi-LoRA batching improvements - performance gain, no
  API changes
- PR #17301: Async engine shutdown refactor - cleaner cleanup, no
  behavior change

Quick Reference
| Category              | Status                    |
|-----------------------|---------------------------|
| Latest release        | v0.8.2 (2026-06-15)      |
| PRs merged (7d)       | 34                        |
| Threats detected (14d)| 1 ACT NOW, 1 PLAN        |
| Open proposals        | 3                         |
| Overall threat level  | ACT NOW                   |
```

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

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- GitHub CLI (`gh`) installed and authenticated (the commands use `gh api` and `gh pr list` to fetch live data)

### Quick Start

```
/upstream-breaking
```

This scans all 10 tracked projects for breaking changes in the last 14 days. If something needs your attention, you will know in under a minute.

## Adding a New Project

1. Create a file in `projects/` named after the project (e.g., `projects/newproject.md`).

2. Use this template:

```markdown
# Project Name

## Repository
- **GitHub:** org/repo
- **License:** Apache 2.0

## What It Is
One-line description.

## Why We Track It
Why this project matters to the AI BU.

## Key Areas to Watch
- path/to/important/code - what to look for

## Release Cadence
How often releases happen.

## Related Repos
- org/other-repo (description)

## Breaking Change Patterns
- Types of breaking changes this project tends to make
```

3. Add an entry to [reference/key-upstreams.md](reference/key-upstreams.md).

4. The commands automatically pick up the new project definition. Run `./install.sh` again only if you updated command files.

## How It Works

The commands are Claude Code slash command files (Markdown with instructions for the AI). When you invoke one, Claude reads the project definitions from the `projects/` directory, uses the GitHub CLI to query recent activity, and produces structured threat assessments.

Every command follows the same analysis pattern:

1. Gather raw data via `gh` CLI
2. Filter signal from noise using project definitions
3. Trace impact to our downstream components
4. Classify urgency (ACT NOW / PLAN / WATCH)
5. Prescribe specific actions

The commands include calibration examples and self-critique checklists to prevent common failures like crying wolf, listing activity without context, or recommending vague "monitoring."

## Project Structure

```
ai-bu-upstream-tracker/
  commands/               # Slash command definitions (threat detection prompts)
    upstream.md           # Single project threat assessment
    upstream-weekly.md    # Weekly threat briefing across all projects
    upstream-breaking.md  # Breaking changes threat sweep
    upstream-impact.md    # Blast radius analysis of specific changes
    upstream-migration.md # Field upgrade playbook generator
    upstream-health.md    # Dependency risk assessment
    upstream-forecast.md  # Forward-looking intelligence
    upstream-contributor.md  # Contributor power map
    upstream-opportunity.md  # Strategic contribution targets
  projects/               # Project definitions (what we track and why)
  reference/              # Reference material
    key-upstreams.md      # Key upstream projects for AI BU
  install.sh              # Install commands to ~/.claude/commands/
```

## Limitations

- GitHub API rate limits apply. If you hit them, the commands tell you and provide the `gh` commands to run manually.
- Private repos require appropriate `gh` authentication and permissions.
- The commands check rolling windows (7 or 14 days by default). Override with arguments like "last 30 days."
- Health scores and forecasts are assessments based on available data. Use them as inputs to engineering judgment, not replacements for it.

## License

Apache 2.0
