# OpenShift

## Repositories
- **GitHub:** openshift/origin (legacy, reference)
- **Enhancements:** openshift/enhancements
- **API:** openshift/api
- **Console:** openshift/console
- **Docs:** https://docs.openshift.com/
- **License:** Apache 2.0

## What It Is
Red Hat's Kubernetes distribution. The platform our AI workloads run on.

## Why We Track It
We ship on OpenShift. Enhancement proposals, API changes, and operator framework updates directly affect how we build and deploy AI platform components.

## Key Areas to Watch
- openshift/enhancements - OCP enhancement proposals, especially:
  - GPU and accelerator support
  - Operator SDK changes
  - Networking changes affecting inference traffic
  - Storage changes affecting model loading
- openshift/api - API group changes and deprecations
- openshift/machine-config-operator - Node configuration changes
- openshift/cluster-node-tuning-operator - Performance tuning for AI workloads

## Release Cadence
Roughly quarterly minor releases (4.x). Watch for feature freeze dates and enhancement proposal deadlines.

## Related Repos
- openshift/enhancements (enhancement proposals)
- openshift/api (API definitions)
- openshift/console (web console)
- openshift/machine-config-operator
- openshift/cluster-node-tuning-operator

## Breaking Change Patterns
- API version deprecations and removals
- Operator SDK version requirements
- OLM (Operator Lifecycle Manager) changes
- Security context constraint changes
- Network policy changes
