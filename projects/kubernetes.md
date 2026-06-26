# Kubernetes

## Repository
- **GitHub:** kubernetes/kubernetes
- **KEPs:** kubernetes/enhancements
- **Docs:** https://kubernetes.io/docs/
- **License:** Apache 2.0

## What It Is
Container orchestration platform. The foundation everything else runs on.

## Why We Track It
OpenShift is built on Kubernetes. API changes, feature gates, and deprecations in upstream K8s flow directly into OpenShift releases. AI workload scheduling (GPU, TPU) depends on K8s resource management.

## Key Areas to Watch
- KEPs (Kubernetes Enhancement Proposals) in kubernetes/enhancements
- `pkg/scheduler/` - Scheduling changes relevant to GPU/accelerator workloads
- `staging/src/k8s.io/api/` - API group changes and deprecations
- `pkg/kubelet/` - Node-level changes affecting device plugins
- SIG-Node and SIG-Scheduling for AI/ML workload relevance

## Key SIGs
- SIG-Node - Device plugin framework, resource management
- SIG-Scheduling - Gang scheduling, topology-aware scheduling
- SIG-Auth - RBAC and security policy changes

## Release Cadence
Three releases per year (roughly April, August, December). Alpha/beta features gate-controlled.

## Related Repos
- kubernetes/kubernetes (main)
- kubernetes/enhancements (KEPs)
- kubernetes/website (docs)

## Breaking Change Patterns
- API version removals (v1beta1 -> v1 transitions)
- Feature gate promotions and removals
- Deprecated flag removals in kubelet/kube-apiserver
- CSI and device plugin interface changes
