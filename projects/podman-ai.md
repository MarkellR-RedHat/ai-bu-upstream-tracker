# Podman AI Lab

## Repository
- **GitHub:** containers/podman-desktop-extension-ai-lab
- **Podman Desktop:** containers/podman-desktop
- **Docs:** https://podman-desktop.io/docs/ai-lab
- **License:** Apache 2.0

## What It Is
Extension for Podman Desktop that brings LLM experimentation to the developer desktop. Supports downloading models, running inference locally, building AI-powered applications using recipes, and integrating with container-native workflows.

## Why We Track It
Podman AI Lab is Red Hat's container-native approach to local AI development. It connects the developer desktop experience to the OpenShift AI production path. Changes to its model catalog, recipe framework, or inference backends affect the developer-to-production story.

## Key Areas to Watch
- `packages/backend/` - Backend service handling model management and inference
- `packages/frontend/` - UI components for model catalog, playgrounds, recipes
- `recipes/` - Application recipe definitions and templates
- Model catalog updates (supported models, quantization formats)
- Integration points with Podman and container runtime
- API surface for programmatic model interaction

## Release Cadence
Tied to Podman Desktop release cycle. Frequent updates. Watch for model catalog format changes and recipe schema updates.

## Related Repos
- containers/podman-desktop-extension-ai-lab (main extension)
- containers/podman-desktop (Podman Desktop host application)
- containers/podman (container engine)

## Breaking Change Patterns
- Recipe catalog format changes
- Model download and storage path changes
- Extension API changes between Podman Desktop versions
- Inference backend swaps (llama.cpp version bumps, GGUF format changes)
- Container image build template changes
