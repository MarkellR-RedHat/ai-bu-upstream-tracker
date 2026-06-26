# KServe

## Repository
- **GitHub:** kserve/kserve
- **Docs:** https://kserve.github.io/website/
- **License:** Apache 2.0

## What It Is
Kubernetes-native model serving framework. Provides serverless inference with autoscaling, canary rollouts, and multi-model serving.

## Why We Track It
KServe is used in OpenShift AI for model serving. Changes to its inference APIs, storage interfaces, or Kubernetes resource definitions affect our model serving stack.

## Key Areas to Watch
- `pkg/apis/` - CRD and API changes for InferenceService, TrainedModel
- `python/kserve/` - Python SDK changes for custom predictors/transformers
- `config/` - Default Kubernetes configurations, webhook changes
- `charts/` - Helm chart changes affecting deployment

## Key Maintainers
- @yuzisun - Project lead
- @chinhuang007 - Core maintainer

## Release Cadence
Roughly quarterly releases. Watch for breaking CRD schema changes between minor versions.

## Related Repos
- kserve/kserve (main)
- kserve/modelmesh-serving (ModelMesh integration)
- kserve/website (docs)

## Breaking Change Patterns
- InferenceService CRD spec changes
- Python SDK API changes
- Storage initializer interface changes
- Knative dependency version bumps
