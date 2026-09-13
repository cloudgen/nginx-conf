# Requirement ↔ test matrix — nginx-config

Maps live `RQ-*` to **TP** families. Status SSOT for individual TP-IDs: `reviews/test-plan.md`.

| Requirement-ID | Key | TP families | Suite | Notes |
|----------------|-----|-------------|-------|-------|
| `RQ-CLASS-SOFTWARE-DEV` | requirement-class-software-dev | TP-CLI-01 | `tests/test_cli.sh` | Class residual; syntax/companion |
| `RQ-SHELL-CLI-INTERFACE` | requirement-shell-cli-interface | TP-CLI · TP-NGINX-CONFIG-01 | `tests/test_cli.sh` · `tests/test_domain.sh` | Dual mention of domain verbs |
| `RQ-SHELL-CLI-STORAGE` | requirement-shell-cli-storage | TP-CLI-04,05 | `tests/test_cli.sh` | Cache + persistence folders |
| `RQ-SHELL-CLI-ZERO-ARGUMENTS` | requirement-shell-cli-zero-arguments | TP-CLI-08 · TP-LC-03 · TP-NGINX-CONFIG-04 | CLI + lifecycle + domain | Empty argv ≠ apply |
| `RQ-SHELL-CLI-DEFAULT-INTERACTION` | requirement-shell-cli-default-interaction | TP-CLI-16,17 · TP-NGINX-CONFIG-06 | CLI + domain | Retry; Exit 9 |
| `RQ-SHELL-OUTPUT-REQUIREMENTS` | requirement-shell-output-requirements | TP-CLI-02,04,07 | `tests/test_cli.sh` | quiet / json |
| `RQ-SHELL-SELF-MANAGEMENT` | requirement-shell-self-management | TP-LC-04…09 · TP-CLI-09 | lifecycle + CLI | |
| `RQ-SHELL-AUTOMATIC-CHECKSUM` | requirement-shell-automatic-checksum | TP-LC-06,08 · TP-CLI-03 | lifecycle + CLI | help/about omit CHECKSUM |
| `RQ-SHELL-IDEMPOTENCY` | requirement-shell-idempotency | TP-LC-01,02 | `tests/test_install_lifecycle.sh` | |
| `RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE` | requirement-shell-interactive-vs-noninteractive | TP-CLI-07,09 | CLI | TTY measured outside functions |
| `RQ-SHELL-MODULAR-FUNCTION-DESIGN` | requirement-shell-modular-function-design | TP-CLI-01 | `tests/test_cli.sh` | `sh -n` |
| `RQ-SHELL-SCRIPT-CODING` | requirement-shell-script-coding | TP-CLI-01 | `tests/test_cli.sh` | POSIX ship unit |
| `RQ-SHELL-SUDO-COMMAND` | requirement-shell-sudo-command | TP-NGINX-CONFIG-09,10 | `tests/test_domain.sh` | No in-tool wrap; non-root fail-closed |
| `RQ-DOMAIN-NGINX-CONFIG` | requirement-domain-nginx-config | TP-NGINX-CONFIG-01…11 | `tests/test_domain.sh` | GitLab stripped |
| `RQ-NGINX-CONF` | requirement-nginx-conf | TP-NGINX-CONFIG-05,08 | `tests/test_domain.sh` | Placeholders kept |

**Last update:** 2026-09-13
