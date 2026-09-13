# CLI routed-verb table — nginx-config

Human-readable column = menu labels (`{{short-descript}}: {{explain}}`).

| Verb | Live? | Human-readable | On main menu? |
|------|-------|----------------|---------------|
| `domains` | yes | `domains: Show saved domains` | yes |
| `profiles` | yes | `profiles: List expandable nginx profiles` | yes |
| `nginx-conf` | yes | `nginx-conf: Render a profile with domain and cert paths` | yes |
| `apply` | yes | `apply: Write a rendered conf into nginx (root)` | yes |
| `remove-lpu` | yes | `remove-lpu: Remove dedicated nginx-adm account` | yes |
| `menu` | yes | — | **no** (opens the list) |
| `main` | yes | alias of `menu` | **no** |
| `install` | yes | — | **no** (self-managed) |
| `version` | yes | — | **no** |
| `about` | yes | — | **no** |
| `help` | yes | — | **no** |
| `version-check` | yes | — | **no** |
| `self-update` | yes | — | **no** |
| `self-uninstall` | yes | — | **no** |

**N = 5** → Exit **9**.

**Last update:** 2026-09-13
