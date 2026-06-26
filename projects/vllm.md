# vLLM

## Repository
- **GitHub:** vllm-project/vllm
- **Docs:** https://docs.vllm.ai/
- **License:** Apache 2.0

## What It Is
High-throughput LLM serving engine. Core inference backend for AI platform workloads.

## Why We Track It
vLLM is a key dependency for LLM serving on OpenShift AI and related AI platform offerings. Changes to its API, supported model architectures, or deployment patterns directly affect our work.

## Key Areas to Watch
- `vllm/engine/` - Core engine changes, async engine refactors
- `vllm/model_executor/` - New model support, architecture changes
- `vllm/entrypoints/` - API server changes, OpenAI-compatible endpoint updates
- `vllm/distributed/` - Multi-GPU and multi-node changes
- `vllm/worker/` - Worker process and memory management

## Key Maintainers
- @WoosukKwon - Project lead
- @zhuohan123 - Core maintainer
- @simon-mo - Core maintainer

## Release Cadence
Frequent releases, roughly monthly. Check for both stable releases and pre-releases.

## Related Repos
- vllm-project/vllm (main)

## Breaking Change Patterns
- Model loading API changes
- Configuration parameter renames or removals
- Tensor parallelism behavior changes
- Docker image base changes
