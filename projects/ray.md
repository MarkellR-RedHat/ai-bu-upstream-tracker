# Ray

## Repository
- **GitHub:** ray-project/ray
- **Docs:** https://docs.ray.io/
- **License:** Apache 2.0

## What It Is
Distributed computing framework for scaling AI and Python workloads. Includes Ray Serve (model serving), Ray Train (distributed training), Ray Data (data processing), and Ray Tune (hyperparameter tuning).

## Why We Track It
Ray is used for distributed training and serving workloads on OpenShift AI. KubeRay operator deploys Ray clusters on Kubernetes. Changes to Ray Serve and Ray Train affect our AI platform capabilities.

## Key Areas to Watch
- `python/ray/serve/` - Ray Serve changes affecting model serving
- `python/ray/train/` - Distributed training API changes
- `python/ray/data/` - Data loading and preprocessing changes
- `python/ray/autoscaler/` - Autoscaler behavior changes
- `deploy/` - Deployment configuration changes

## Key Maintainers
- @ericl - Co-creator
- @edoakes - Ray Serve lead
- @matthewdeng - Ray Train lead

## Release Cadence
Monthly minor releases, with patch releases as needed. Major versions roughly annually.

## Related Repos
- ray-project/ray (main)
- ray-project/kuberay (Kubernetes operator)
- ray-project/ray-llm (LLM serving, now part of Anyscale)

## Breaking Change Patterns
- Ray Serve API changes (deployment config, ingress)
- Ray Train trainer interface changes
- Autoscaler configuration changes
- Python version support changes
- KubeRay CRD changes (in kuberay repo)
