# InstructLab

## Repository
- **GitHub:** instructlab/instructlab
- **Taxonomy:** instructlab/taxonomy
- **Docs:** https://instructlab.ai/
- **License:** Apache 2.0

## What It Is
Open source project for community-driven LLM fine-tuning using a synthetic data generation and alignment methodology. Lets contributors add knowledge and skills to models without needing massive datasets.

## Why We Track It
InstructLab is Red Hat's upstream for model training and alignment. It underpins the RHEL AI model customization workflow and is core to our AI platform story. Changes to its CLI, taxonomy format, training pipeline, or SDK affect our downstream product directly.

## Key Areas to Watch
- `src/instructlab/` - Core CLI and training pipeline
- `instructlab/taxonomy` - Taxonomy schema, qna.yaml format, validation rules
- `instructlab/sdg` - Synthetic data generation pipeline changes
- `instructlab/training` - Training backend changes, GPU requirements
- `instructlab/eval` - Model evaluation methodology
- Model compatibility (granite, merlinite, mixtral support changes)
- LAB methodology papers and design proposals

## Release Cadence
Active development with regular releases. Watch for CLI breaking changes between minor versions. Taxonomy schema changes can break existing contributions.

## Related Repos
- instructlab/instructlab (main CLI)
- instructlab/taxonomy (knowledge and skills definitions)
- instructlab/sdg (synthetic data generation)
- instructlab/training (training backends)
- instructlab/eval (evaluation)
- instructlab/schema (taxonomy schema definitions)

## Breaking Change Patterns
- Taxonomy qna.yaml format changes
- CLI command renames or flag changes
- Training pipeline dependency updates (PyTorch, DeepSpeed versions)
- Model format or checkpoint compatibility changes
- SDG pipeline prompt template changes
