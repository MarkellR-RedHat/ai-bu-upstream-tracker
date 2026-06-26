# Kubeflow

## Repository
- **GitHub:** kubeflow/kubeflow
- **Training Operator:** kubeflow/training-operator
- **Notebooks:** kubeflow/notebooks
- **Docs:** https://www.kubeflow.org/docs/
- **License:** Apache 2.0

## What It Is
ML platform for Kubernetes that provides components for training, serving, pipeline orchestration, and notebook-based development. The training-operator manages distributed training jobs (PyTorchJob, TFJob, etc.) on Kubernetes.

## Why We Track It
Kubeflow components are used in OpenShift AI. The training-operator is critical for distributed training workloads. Changes to CRD schemas, SDK interfaces, and Kubernetes version compatibility affect our platform directly.

## Key Areas to Watch
- `kubeflow/training-operator` - Distributed training job CRDs and controller
- `kubeflow/notebooks` - Notebook controller and spawner changes
- `kubeflow/pipelines` - Pipeline SDK and backend changes
- Training operator CRD schemas (PyTorchJob, training.kubeflow.org API group)
- Python SDK changes for job submission
- Kubernetes version compatibility matrix

## Release Cadence
Major releases roughly annually. Components release independently. Training operator follows its own release cadence with regular minor releases.

## Related Repos
- kubeflow/kubeflow (main)
- kubeflow/training-operator (distributed training)
- kubeflow/notebooks (notebook controller)
- kubeflow/pipelines (ML pipelines)
- kubeflow/katib (hyperparameter tuning)
- kubeflow/manifests (deployment manifests)

## Breaking Change Patterns
- Training CRD API version promotions (v1alpha1 to v1)
- Python SDK method signature changes
- Kubernetes minimum version bumps
- Notebook controller image and spawner config changes
- Pipeline SDK v1 to v2 migration
- Manifest structure changes affecting kustomize overlays
