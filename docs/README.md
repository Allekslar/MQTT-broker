# Documentation Index

This directory contains the normative documentation set for the ESP32-S3 MQTT broker.

## Structure

Cross-document terminology reference:
- [GLOSSARY.md](GLOSSARY.md)


### `architecture/`

Architecture and technical contracts:
- [ARCHITECTURE.md](architecture/ARCHITECTURE.md)
- [TECH_STACK.md](architecture/TECH_STACK.md)
- [CODING_GUIDELINES.md](architecture/CODING_GUIDELINES.md)
- [MODULE_CONTRACTS.md](architecture/MODULE_CONTRACTS.md)
- [DEPENDENCY_RULES.md](architecture/DEPENDENCY_RULES.md)
- [CONFIG_SCHEMA.md](architecture/CONFIG_SCHEMA.md)
- [ERROR_MODEL.md](architecture/ERROR_MODEL.md)
- [EVENT_CONTRACTS.md](architecture/EVENT_CONTRACTS.md)
- [READ_MODEL_STRATEGY.md](architecture/READ_MODEL_STRATEGY.md)
- [RUNTIME_EXECUTION_MODEL.md](architecture/RUNTIME_EXECUTION_MODEL.md)
- [ASYNC_OPERATION_MODEL.md](architecture/ASYNC_OPERATION_MODEL.md)
- [API_HEADERS_PLAN.md](architecture/API_HEADERS_PLAN.md)
- [MEMORY_BUDGETS.md](architecture/MEMORY_BUDGETS.md)

### `governance/`

Enforcement rules and team process:
- [ARCH_COMPLIANCE_MATRIX.md](governance/ARCH_COMPLIANCE_MATRIX.md)
- [ADR_EXCEPTIONS.md](governance/ADR_EXCEPTIONS.md)
- [ARCH_CHECKS.md](governance/ARCH_CHECKS.md)
- [CI_RULES.md](governance/CI_RULES.md)
- [TEAM_WORKFLOW.md](governance/TEAM_WORKFLOW.md)

### `testing/`

Testing strategy:
- [TEST_STRATEGY.md](testing/TEST_STRATEGY.md)

### `planning/`

Roadmap and implementation planning:
- [ROADMAP.md](planning/ROADMAP.md)
- [SKELETON_PLAN.md](planning/SKELETON_PLAN.md)

## Recommended reading order

This is a minimal onboarding path, not an exhaustive reading list for every document in this directory.

1. [ARCHITECTURE.md](architecture/ARCHITECTURE.md)
2. [TECH_STACK.md](architecture/TECH_STACK.md)
3. [GLOSSARY.md](GLOSSARY.md)
4. [MODULE_CONTRACTS.md](architecture/MODULE_CONTRACTS.md)
5. [DEPENDENCY_RULES.md](architecture/DEPENDENCY_RULES.md)
6. [TEST_STRATEGY.md](testing/TEST_STRATEGY.md)
7. [ARCH_COMPLIANCE_MATRIX.md](governance/ARCH_COMPLIANCE_MATRIX.md)
8. [CI_RULES.md](governance/CI_RULES.md)
9. [ROADMAP.md](planning/ROADMAP.md)

## Entry points by task

- If you are designing or changing architecture:
  [ARCHITECTURE.md](architecture/ARCHITECTURE.md),
  [MODULE_CONTRACTS.md](architecture/MODULE_CONTRACTS.md),
  [DEPENDENCY_RULES.md](architecture/DEPENDENCY_RULES.md)

- If you are changing runtime, configuration, or error behavior:
  [CONFIG_SCHEMA.md](architecture/CONFIG_SCHEMA.md),
  [ERROR_MODEL.md](architecture/ERROR_MODEL.md),
  [RUNTIME_EXECUTION_MODEL.md](architecture/RUNTIME_EXECUTION_MODEL.md),
  [ASYNC_OPERATION_MODEL.md](architecture/ASYNC_OPERATION_MODEL.md)

- If you are changing testable behavior:
  [TEST_STRATEGY.md](testing/TEST_STRATEGY.md),
  [EVENT_CONTRACTS.md](architecture/EVENT_CONTRACTS.md),
  [READ_MODEL_STRATEGY.md](architecture/READ_MODEL_STRATEGY.md)

- If you are changing governance or CI:
  [ARCH_COMPLIANCE_MATRIX.md](governance/ARCH_COMPLIANCE_MATRIX.md),
  [ARCH_CHECKS.md](governance/ARCH_CHECKS.md),
  [CI_RULES.md](governance/CI_RULES.md),
  [TEAM_WORKFLOW.md](governance/TEAM_WORKFLOW.md)
