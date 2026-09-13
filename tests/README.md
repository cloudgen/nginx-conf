# tests — nginx-config

| File | Role |
|------|------|
| `run.sh` | Suite entry (CI + local) |
| `helpers.sh` | Assertions + isolated HOME/USER_BIN/**GLOBAL_BIN** + local HTTP channel |
| `test_cli.sh` | Type 0 CLI surface (TP-CLI-*) |
| `test_install_lifecycle.sh` | Install / update / checksum / uninstall (TP-LC-*) |
| `test_domain.sh` | Domain surface TP-NGINX-CONFIG-* (RQ-DOMAIN-NGINX-CONFIG) |

```bash
./tests/run.sh
```

**Baseline:** see `../reviews/test-plan.md` (**PASS=162 FAIL=0 SKIP=0**, 2026-09-06).
