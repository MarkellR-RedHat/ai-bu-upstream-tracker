# ai-bu-upstream-tracker

Claude Code commands for tracking upstream open source project activity relevant to Red Hat's AI Business Unit.

## What It Does

Gives you quick, structured summaries of what is happening in the upstream projects our team depends on. Instead of manually checking GitHub repos, release pages, and mailing lists, you run a slash command and get a focused report.

Five commands are included:

- `/upstream <project>` - Check recent activity for a single project (commits, merged PRs, RFCs, releases, breaking changes)
- `/upstream-weekly` - Generate a weekly digest covering all tracked projects
- `/upstream-breaking` - Report only breaking changes and deprecations across all tracked projects
- `/upstream-contributor <project>` - Show top contributors to a project this month
- `/upstream-opportunity` - Find good-first-issue and help-wanted issues across tracked projects

## Tracked Projects

| Project | Repository | Why We Care |
|---------|-----------|-------------|
| vLLM | vllm-project/vllm | Core inference engine for LLM serving |
| Kubernetes | kubernetes/kubernetes | Platform foundation, scheduling, device plugins |
| KServe | kserve/kserve | Model serving framework on OpenShift AI |
| llm-d | llm-d/llm-d | Distributed LLM serving, scalability pillar focus |
| Ray | ray-project/ray | Distributed training and serving workloads |
| OpenShift | openshift/enhancements | The platform we ship on |
| InstructLab | instructlab/instructlab | Red Hat's upstream for model training and alignment |
| Podman AI Lab | containers/podman-desktop-extension-ai-lab | Container-native local AI development |
| Caikit | caikit/caikit | AI runtime framework for model serving |
| Kubeflow | kubeflow/kubeflow | ML platform on Kubernetes, training operator |

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

## Usage

### Check a single project

```
/upstream vllm
```

Returns a one-screen summary of recent vLLM activity, including merged PRs, releases, breaking changes, and anything that might affect our work.

### Weekly digest

```
/upstream-weekly
```

Generates a digest covering all tracked projects for the past week. Skips projects with no meaningful activity.

Example output:

```
AI BU Upstream Weekly Digest
Week of 2026-06-19 to 2026-06-26
Projects scanned: 10 | Projects with activity: 6

Quick Reference

| Project        | Release | PRs Merged | Breaking Changes | Action Needed |
|----------------|---------|------------|-----------------|---------------|
| vLLM           | v0.8.3  | 34         | yes             | yes           |
| llm-d          | -       | 12         | no              | no            |
| InstructLab    | v0.25.0 | 8          | no              | no            |
| KServe         | -       | 5          | no              | no            |
| Kubeflow       | -       | 3          | no              | no            |
| Ray            | v2.46.0 | 22         | no              | yes           |

vLLM (vllm-project/vllm)
- Releases: v0.8.3 released 2026-06-22
- Key merges: PR #17234 adds multi-LoRA batching (@alice),
  PR #17301 refactors async engine shutdown (@bob)
- Breaking changes: PR #17289 removes deprecated --model-loader flag
- Watch list: RFC #17100 proposing new disaggregated prefill API

llm-d (llm-d/llm-d)
- Key merges: PR #482 improves prefix cache hit rate (@carol),
  PR #491 adds Prometheus metrics for routing decisions (@dave)
- Watch list: PR #488 proposes CRD schema v2

...

Cross-Project Themes
- vLLM and llm-d both working on disaggregated inference improvements
- Multiple projects bumped minimum Python version to 3.10

Action Items
- [ ] Test vLLM v0.8.3 with current llm-d integration
- [ ] Review llm-d CRD v2 proposal (PR #488) before it merges
- [ ] Ray v2.46.0 changes autoscaler defaults, verify KubeRay compat
```

### Breaking changes only

```
/upstream-breaking
```

Scans all tracked projects for breaking changes and deprecations in the last 14 days. Useful before planning upgrades or cutting releases.

### Top contributors

```
/upstream-contributor vllm
```

Shows who is most active in a project this month. Useful for knowing who to reach out to for reviews, who the key maintainers are, and where Red Hat engineers are contributing.

### Contribution opportunities

```
/upstream-opportunity
```

Finds issues labeled good-first-issue, help-wanted, and similar tags across all tracked projects. Useful for onboarding new contributors or prepping for a hackathon.

```
/upstream-opportunity instructlab
```

Filters to a single project.

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

3. The weekly and breaking-changes commands will automatically pick up the new project definition.

4. Run `./install.sh` again if you updated command files (project definitions do not need reinstallation since they are read from this repo at runtime).

## How It Works

The commands are Claude Code slash command files (Markdown with instructions). When you invoke one, Claude Code reads the project definitions from the `projects/` directory, uses the GitHub CLI to query recent activity, and produces a structured summary.

All commands produce a quick-reference table at the top of their output so you can scan results fast and drill into details only where needed.

The commands rely on `gh` (GitHub CLI) for API access. Make sure you are authenticated (`gh auth status`) and have access to the repos you want to track.

## Limitations

- GitHub API rate limits apply. If you hit rate limits, the commands will tell you.
- Private repos require appropriate `gh` authentication and permissions.
- The commands check a rolling window (7 or 14 days by default). For longer-term trends, adjust the time window by passing instructions like "last 30 days" as part of your prompt.

## License

Apache 2.0
