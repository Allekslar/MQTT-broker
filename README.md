# ESP32-S3 MQTT Broker

MQTT broker project for the ESP32-S3, following a documentation-first architecture process.

The repository currently contains the normative design and governance baseline for the implementation:
- clean architecture
- modular core/ports/adapters separation
- host-side testability
- resource-aware ESP32-S3 constraints
- staged evolution from `single-broker mode` to `federated multi-broker mode`

## Repository layout

- [docs/](docs/README.md) - architecture, governance, testing, and planning documents
- [scripts/check_arch_invariants.sh](scripts/check_arch_invariants.sh) - architecture boundary checks
- [scripts/run_blocking_local_checks.sh](scripts/run_blocking_local_checks.sh) - local verification bundle

## Start here

Recommended reading order:

This is a minimal onboarding path, not an exhaustive reading list for every document in the repository.

1. [docs/architecture/ARCHITECTURE.md](docs/architecture/ARCHITECTURE.md)
2. [docs/architecture/TECH_STACK.md](docs/architecture/TECH_STACK.md)
3. [docs/GLOSSARY.md](docs/GLOSSARY.md)
4. [docs/architecture/MODULE_CONTRACTS.md](docs/architecture/MODULE_CONTRACTS.md)
5. [docs/testing/TEST_STRATEGY.md](docs/testing/TEST_STRATEGY.md)
6. [docs/planning/ROADMAP.md](docs/planning/ROADMAP.md)

## Current status

Implementation has not started yet.
The repository is prepared for the first skeleton milestone defined in:
- [docs/planning/SKELETON_PLAN.md](docs/planning/SKELETON_PLAN.md)
- [docs/architecture/API_HEADERS_PLAN.md](docs/architecture/API_HEADERS_PLAN.md)

## Verification

Before starting or reviewing code changes, run:

```bash
./scripts/run_blocking_local_checks.sh
```

## Documentation index

For the full documentation map, see:
- [docs/README.md](docs/README.md)

## License

This project is licensed under the GNU Affero General Public License v3.0.
Project SPDX identifier: `AGPL-3.0-only`.
See [LICENSE](LICENSE).
