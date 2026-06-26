# llm-d

## Repository
- **GitHub:** llm-d/llm-d
- **License:** Apache 2.0

## What It Is
Distributed LLM serving framework built for Kubernetes. Focuses on scalable, disaggregated inference with smart routing and scheduling.

## Why We Track It
llm-d is a core project for the AI BU scalability pillar. We are active contributors and consumers. All changes are directly relevant.

## Key Areas to Watch
- Core routing and scheduling logic
- API surface changes
- Kubernetes operator and CRD definitions
- Integration points with vLLM and other backends
- Performance benchmarks and configuration defaults

## Release Cadence
Active development. Watch main branch closely for breaking changes.

## Related Repos
- llm-d/llm-d (main)
- llm-d/llm-d-deployer (deployment tooling)
- llm-d/llm-d-inference-scheduler (scheduling component)
- llm-d/llm-d-routing-sidecar (routing component)

## Breaking Change Patterns
- CRD schema changes
- Configuration format changes
- API endpoint changes
- Container image and dependency updates
