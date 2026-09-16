# Test plan — nginx-config

Maps **portable TP families** (proof molds) and product domain cases to product-root `tests/`.

| Field | Value |
|-------|--------|
| **Product** | nginx-config |
| **Ship unit** | `./nginx-config` · `VERSION=1.0.0` |
| **Companion** | `./nginx-config.sha256` |
| **Suite entry** | `./tests/run.sh` |
| **Live law** | **15** Active REQs — `docs/requirements/index.md` |
| **Bootstrap origin** | selfmanaged Type 0; GitLab features stripped from gitlab-nginx nginx DNA |
| **Last update** | 2026-09-16 (main-menu review: TP-CLI-18/19 todo) |

Status: **have** = automated · **todo** = needed · **n/a** = not applicable · **optional** = gated (root/host)

---

## Proof molds (cite by PM-ID)

| Family | Proof mold-ID | Suite file(s) | Primary product law |
|--------|---------------|---------------|---------------------|
| **TP-CLI** | `PM-SHELL-CLI-TEST-PLAN` | `tests/test_cli.sh` | RQ-SHELL-CLI-INTERFACE · RQ-SHELL-CLI-STORAGE · RQ-SHELL-OUTPUT-REQUIREMENTS · RQ-SHELL-CLI-DEFAULT-INTERACTION |
| **TP-LC** | `PM-INSTALL-LIFECYCLE-TEST-PLAN` | `tests/test_install_lifecycle.sh` | RQ-SHELL-SELF-MANAGEMENT · RQ-SHELL-IDEMPOTENCY · RQ-SHELL-AUTOMATIC-CHECKSUM |
| **TP-CSUM** | `PM-CHECKSUM-TEST-PLAN` | CLI + lifecycle | RQ-SHELL-AUTOMATIC-CHECKSUM |
| **TP-NGINX-CONFIG** | `PM-DOMAIN-TEST-PLAN` | `tests/test_domain.sh` | **RQ-DOMAIN-NGINX-CONFIG** · **RQ-NGINX-CONF** |
| Umbrella | `PM-SHELL-CLI-SUITE-TEST-PLAN` | `tests/run.sh` | full Type 0 + domain surface |

---

## Baseline result

| Date | Result | Notes |
|------|--------|-------|
| 2026-09-13 | **PASS=194 FAIL=0 SKIP=0** | 1.0.0 nginx-config after GitLab strip |

**How to re-baseline:** `cd` product root → `./tests/run.sh` → paste summary into this table when law/suite changes.

---

## TP-CLI — CLI surface

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| TP-CLI-01 | Syntax + companion digest | **have** | `sh -n`; `nginx-config.sha256` |
| TP-CLI-02 | Version human + JSON | **have** | app/version fields |
| TP-CLI-03 | Help Type 0; no CHECKSUM | **have** | test_cli |
| TP-CLI-04 | About JSON + cache/persistence fields | **have** | cache_preferred / cache_fallback / persistence_storage |
| TP-CLI-05 | Cache + persistence isolation under HOME | **have** | persistence under `${HOME}/.local/nginx-config` |
| TP-CLI-06 | Unknown command fail-closed | **have** | exit 1 + out_error |
| TP-CLI-07 | quiet / env -u HOME | **have** | test_cli |
| TP-CLI-08 | Zero-arg failed install non-zero | **have** | bad SCRIPT_URL + isolate |
| TP-CLI-09 | self-uninstall --json confirm_required | **have** | test_cli |
| TP-CLI-16 | No `$()` of `prompt_ask` | **have** | grep ship unit |
| TP-CLI-17 | Help lists menu; identity | **have** (partial) | help lists `menu`/`main` only — **todo**: TTY header `APP_NAME(VERSION)` + **bold** short + *italic* long (2026-09-16 main-menu) |
| TP-CLI-18 | After a valid leaf, reprint the **front** board (do not exit) | **todo** | PTY pick `2` then expect the numbered list again; 2026-09-16 Issue 1 |
| TP-CLI-19 | Invalid TTY pick: `[ERROR]`, reprint this layer, stay (not TP-CLI-06) | **todo** | PTY today asserts retry text + `[WARN]` — must assert `out_error`; 2026-09-16 Issue 3 |

---

## TP-LC — Install lifecycle (local HTTP channel)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| TP-LC-01 | install --json to USER_BIN | **have** | local channel |
| TP-LC-02 | Idempotent re-install | **have** | already installed |
| TP-LC-03 | Zero-arg Type O when installed (off-TTY) | **have** | local + global path cases |
| TP-LC-04 | version-check schema | **have** | ver_check keys |
| TP-LC-05 | self-update already-latest | **have** | lifecycle |
| TP-LC-06 | Human companion transparency | **have** | PASS digest lines |
| TP-LC-07 | Uninstall refuse / force | **have** | lifecycle |
| TP-LC-08 | CHECKSUM pin match/mismatch | **have** | lifecycle |
| TP-LC-09 | Downgrade blocked / --force | **have** | lifecycle |

---

## TP-NGINX-CONFIG — Domain surface

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| TP-NGINX-CONFIG-01 | Help lists work verbs; no GitLab | **have** | test_domain |
| TP-NGINX-CONFIG-02 | Help JSON notes | **have** | test_domain |
| TP-NGINX-CONFIG-03 | About JSON profile fields | **have** | test_domain |
| TP-NGINX-CONFIG-04 | Empty argv ≠ apply | **have** | test_domain |
| TP-NGINX-CONFIG-05 | Profile seed + placeholders | **have** | test_domain |
| TP-NGINX-CONFIG-06 | Off-TTY menu = help | **have** | test_domain |
| TP-NGINX-CONFIG-07 | nginx-conf missing operands fail-closed | **have** | test_domain |
| TP-NGINX-CONFIG-08 | Render fills output, not catalog | **have** | test_domain |
| TP-NGINX-CONFIG-09 | apply non-root fail-closed | **have** | test_domain |
| TP-NGINX-CONFIG-10 | remove-lpu non-root fail-closed | **have** | test_domain |
| TP-NGINX-CONFIG-11 | ssh-hostname unknown | **have** | test_domain |
