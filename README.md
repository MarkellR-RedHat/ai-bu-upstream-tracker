# ai-bu-upstream-tracker

Claude Code commands for tracking upstream open source project activity relevant to Red Hat's AI Business Unit.

## What It Does

Gives you quick, structured summaries of what is happening in the upstream projects our team depends on. Instead of manually checking GitHub repos, release pages, and mailing lists, you run a slash command and get a focused report.

Three commands are included:

- `/upstream <project>` - Check recent activity for a single project (commits, merged PRs, RFCs, releases, breaking changes)
- `/upstream-weekly` - Generate a weekly digest covering all tracked projects
- `/upstream-breaking` - Report only breaking changes and deprecations across all tracked projects

## Tracked Projects

| Project | Repository | Why We Care |
|---------|-----------|-------------|
| vLLM | vllm-project/vllm | Core inference engine for LLM serving |
| Kubernetes | kubernetes/kubernetes | Platform foundation, scheduling, device plugins |
| KServe | kserve/kserve | Model serving framework on OpenShift AI |
| llm-d | llm-d/llm-d | Distributed LLM serving, scalability pillar focus |
| Ray | ray-project/ray | Distributed training and serving workloads |
| OpenShift | openshift/enhancements | The platform we ship on |

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

### Breaking changes only

```
/upstream-breaking
```

Scans all tracked projects for breaking changes and deprecations in the last 14 days. Useful before planning upgrades or cutting releases.

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

The commands rely on `gh` (GitHub CLI) for API access. Make sure you are authenticated (`gh auth status`) and have access to the repos you want to track.

## Limitations

- GitHub API rate limits apply. If you hit rate limits, the commands will tell you.
- Private repos require appropriate `gh` authentication and permissions.
- The commands check a rolling window (7 or 14 days). For longer-term trends, adjust the time window by passing instructions like "last 30 days" as part of your prompt.

## License

Apache 2.0
