# Caikit

## Repository
- **GitHub:** caikit/caikit
- **NLP Module:** caikit/caikit-nlp
- **TGIS Backend:** caikit/caikit-tgis-backend
- **License:** Apache 2.0

## What It Is
AI runtime framework that provides a uniform API layer for serving AI models. Abstracts model loading, inference, and training behind a consistent gRPC and REST interface regardless of the underlying model framework.

## Why We Track It
Caikit is used in OpenShift AI as a model runtime. Its API stability, supported model types, and integration with serving infrastructure (KServe, ModelMesh) directly impact our model serving capabilities and upgrade paths.

## Key Areas to Watch
- `caikit/core/` - Core runtime, module interface, data model definitions
- `caikit/runtime/` - gRPC and HTTP serving layer
- `caikit/interfaces/` - API interface definitions, proto files
- `caikit-nlp/` - NLP-specific module implementations
- `caikit-tgis-backend/` - TGIS integration for text generation
- Module interface contract changes

## Release Cadence
Regular releases. API interface changes tend to land in minor version bumps. Watch for gRPC proto file changes that affect client compatibility.

## Related Repos
- caikit/caikit (core framework)
- caikit/caikit-nlp (NLP modules)
- caikit/caikit-tgis-backend (TGIS integration)
- caikit/caikit-computer-vision (CV modules)

## Breaking Change Patterns
- Module interface signature changes
- gRPC proto definition changes
- Data model class restructuring
- Configuration format changes (config.yml schema)
- Python dependency version bumps affecting model compatibility
