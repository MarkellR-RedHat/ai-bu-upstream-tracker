# Key Upstream Projects for Red Hat AI Business Unit

Quick reference for the upstream open source projects most relevant to Red Hat's AI BU engineering work. Use this to understand what each project does, why we care, and who to pay attention to.

## Inference and Serving

### vLLM
- **Repo:** [vllm-project/vllm](https://github.com/vllm-project/vllm)
- **What it is:** High-throughput LLM inference engine with PagedAttention, continuous batching, and broad model support.
- **What we use it for:** Core inference backend for LLM serving on OpenShift AI. The engine underneath our model serving stack.
- **Downstream owner:** AI Platform / Model Serving team
- **Key maintainers to watch:** @WoosukKwon (project lead), @simon-mo, @zhuohan123, @robertgshaw2-redhat (Red Hat)
- **Release cadence:** Roughly monthly. Fast-moving, frequent breaking changes.
- **Critical areas:** `vllm/engine/`, `vllm/entrypoints/`, `vllm/distributed/`

### llm-d
- **Repo:** [llm-d/llm-d](https://github.com/llm-d/llm-d)
- **What it is:** Distributed LLM serving framework for Kubernetes with smart routing, disaggregated inference, and prefix-aware scheduling.
- **What we use it for:** Scalability pillar core project. Active contributors and consumers. Provides the orchestration layer on top of vLLM for multi-node serving.
- **Downstream owner:** Scalability pillar
- **Key maintainers to watch:** Core team (check OWNERS file for current list)
- **Release cadence:** Active development, main branch is the primary integration point.
- **Related repos:** llm-d/llm-d-deployer, llm-d/llm-d-inference-scheduler, llm-d/llm-d-routing-sidecar
- **Critical areas:** CRD definitions, routing logic, scheduler integration

### KServe
- **Repo:** [kserve/kserve](https://github.com/kserve/kserve)
- **What it is:** Kubernetes-native model serving framework with serverless inference, autoscaling, canary rollouts, and multi-model serving.
- **What we use it for:** Model serving framework in OpenShift AI. InferenceService CRD is the user-facing API for deploying models.
- **Downstream owner:** AI Platform / Model Serving team
- **Key maintainers to watch:** @yuzisun (project lead), @chinhuang007
- **Release cadence:** Roughly quarterly.
- **Related repos:** kserve/modelmesh-serving
- **Critical areas:** `pkg/apis/` (CRD changes), `python/kserve/` (SDK), `config/`

### Caikit
- **Repo:** [caikit/caikit](https://github.com/caikit/caikit)
- **What it is:** AI runtime framework providing a uniform gRPC and REST API for serving AI models regardless of underlying framework.
- **What we use it for:** Model runtime in OpenShift AI. API stability and proto file compatibility directly affect model serving upgrades.
- **Downstream owner:** AI Platform / Runtime team
- **Key maintainers to watch:** Check MAINTAINERS file for current list
- **Release cadence:** Regular releases. Watch for gRPC proto changes.
- **Related repos:** caikit/caikit-nlp, caikit/caikit-tgis-backend
- **Critical areas:** `caikit/core/`, `caikit/runtime/`, `caikit/interfaces/` (proto files)

## Training and Fine-Tuning

### InstructLab
- **Repo:** [instructlab/instructlab](https://github.com/instructlab/instructlab)
- **What it is:** Community-driven LLM fine-tuning using synthetic data generation and alignment. Contributors add knowledge and skills to models through a taxonomy.
- **What we use it for:** Red Hat's upstream for model customization. Powers the RHEL AI model training workflow. Taxonomy format and CLI are the user-facing interface.
- **Downstream owner:** InstructLab team / RHEL AI
- **Key maintainers to watch:** Check the instructlab org maintainers
- **Release cadence:** Active development with regular releases. CLI and taxonomy schema changes can be breaking.
- **Related repos:** instructlab/taxonomy, instructlab/sdg, instructlab/training, instructlab/eval, instructlab/schema
- **Critical areas:** `src/instructlab/` (CLI), taxonomy schema, SDG pipeline

### PyTorch
- **Repo:** [pytorch/pytorch](https://github.com/pytorch/pytorch)
- **What it is:** Deep learning framework. The foundation for model training and inference across the ML ecosystem.
- **What we use it for:** Transitive dependency for nearly everything -- vLLM, InstructLab training, Ray Train, and model development. Version compatibility across projects is a constant concern.
- **Downstream owner:** Multiple teams (no single owner -- everyone depends on it)
- **Key maintainers to watch:** @soumith (project lead), @malfet, @ezyang
- **Release cadence:** Roughly quarterly major releases. CUDA version compatibility is critical.
- **Critical areas:** Distributed training APIs, CUDA/ROCm support, torch.compile, quantization APIs

## Platform and Orchestration

### Kubernetes
- **Repo:** [kubernetes/kubernetes](https://github.com/kubernetes/kubernetes)
- **What it is:** Container orchestration platform. The foundation everything runs on.
- **What we use it for:** OpenShift is built on Kubernetes. API changes, feature gates, device plugin framework, and scheduling changes for GPU/accelerator workloads flow directly into our platform.
- **Downstream owner:** OpenShift platform team (AI BU consumes via OpenShift)
- **Key maintainers to watch:** SIG-Node and SIG-Scheduling leads for AI/ML workload relevance
- **Release cadence:** Three releases per year (roughly April, August, December).
- **Related repos:** kubernetes/enhancements (KEPs)
- **Critical areas:** `pkg/scheduler/` (GPU scheduling), `staging/src/k8s.io/api/` (API deprecations), device plugin framework

### OpenShift
- **Repo:** [openshift/enhancements](https://github.com/openshift/enhancements)
- **What it is:** Red Hat's Kubernetes distribution. The platform we ship on.
- **What we use it for:** All AI BU components deploy on OpenShift. Enhancement proposals, operator framework changes, and networking/storage updates directly affect our deployment and operations.
- **Downstream owner:** OpenShift platform team
- **Key maintainers to watch:** Enhancement proposal reviewers in areas relevant to AI workloads
- **Release cadence:** Roughly quarterly (4.x releases).
- **Related repos:** openshift/api, openshift/machine-config-operator, openshift/cluster-node-tuning-operator
- **Critical areas:** GPU/accelerator support proposals, operator SDK changes, networking for inference traffic

### Kubeflow
- **Repo:** [kubeflow/kubeflow](https://github.com/kubeflow/kubeflow)
- **What it is:** ML platform for Kubernetes. Provides training operator (PyTorchJob, etc.), notebook controller, and pipeline orchestration.
- **What we use it for:** Training operator is used in OpenShift AI for distributed training jobs. CRD schemas and SDK compatibility matter for our integration.
- **Downstream owner:** AI Platform / Training team
- **Key maintainers to watch:** Training operator maintainers
- **Release cadence:** Components release independently. Training operator has its own cadence.
- **Related repos:** kubeflow/training-operator, kubeflow/notebooks, kubeflow/pipelines
- **Critical areas:** Training CRD schemas, Python SDK, Kubernetes version compatibility

## Distributed Computing

### Ray
- **Repo:** [ray-project/ray](https://github.com/ray-project/ray)
- **What it is:** Distributed computing framework for AI workloads. Includes Ray Serve (model serving), Ray Train (distributed training), and Ray Data (data processing).
- **What we use it for:** Distributed training and serving workloads on OpenShift AI. KubeRay operator deploys Ray clusters on Kubernetes.
- **Downstream owner:** AI Platform team
- **Key maintainers to watch:** @ericl (co-creator), @edoakes (Ray Serve), @matthewdeng (Ray Train)
- **Release cadence:** Monthly minor releases.
- **Related repos:** ray-project/kuberay
- **Critical areas:** `python/ray/serve/`, `python/ray/train/`, autoscaler behavior

## Developer Experience

### Podman AI Lab
- **Repo:** [containers/podman-desktop-extension-ai-lab](https://github.com/containers/podman-desktop-extension-ai-lab)
- **What it is:** Podman Desktop extension for local AI development. Download models, run inference, build AI apps using recipes.
- **What we use it for:** Container-native local AI development experience. Connects developer desktop to OpenShift AI production path.
- **Downstream owner:** Developer Tools team
- **Key maintainers to watch:** Check OWNERS file
- **Release cadence:** Tied to Podman Desktop releases. Frequent updates.
- **Related repos:** containers/podman-desktop, containers/podman
- **Critical areas:** Model catalog format, recipe schema, inference backend (llama.cpp version)

## Not Yet Tracked (Consider Adding)

These projects are relevant but do not yet have project definitions in this repo:

| Project | Repo | Why It Matters |
|---------|------|---------------|
| llama.cpp | ggerganov/llama.cpp | CPU/edge inference engine, GGUF format used by Podman AI Lab and local inference |
| Open Data Hub | opendatahub-io/opendatahub-operator | Upstream for OpenShift AI operator and dashboard |
| NVIDIA GPU Operator | NVIDIA/gpu-operator | GPU provisioning on Kubernetes, critical for our GPU workloads |
| Triton Inference Server | triton-inference-server/server | Alternative inference backend, used in some KServe deployments |
| DeepSpeed | microsoft/DeepSpeed | Distributed training optimization, used by InstructLab training |
| Hugging Face Transformers | huggingface/transformers | Model loading and tokenization, transitive dependency everywhere |
| GGUF/llama.cpp | ggerganov/llama.cpp | Quantized model format, local inference engine |
| KubeRay | ray-project/kuberay | Kubernetes operator for Ray, how we deploy Ray on OpenShift |
| Model Registry | kubeflow/model-registry | ML model metadata management, being integrated into OpenShift AI |

## How to Use This Reference

- **Before running `/upstream <project>`:** Check here for context on what the project means to us
- **When evaluating a new dependency:** Check if the project is listed here. If not, run `/upstream-health <org/repo>` first.
- **When planning contributions:** Cross-reference with `/upstream-contributor` and `/upstream-opportunity` results
- **When a breaking change hits:** Check "Critical areas" and "Downstream owner" to know who to notify

## Maintaining This List

When adding a new project:
1. Create a project definition in `projects/<name>.md` using the template in the README
2. Add an entry to this reference file
3. Run `/upstream-health <repo>` to establish a baseline assessment
