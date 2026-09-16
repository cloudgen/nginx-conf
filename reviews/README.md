# Reviews — nginx-config

Public git-tracked reviews surface (peer of `tests/`). Not product law (`docs/requirements/`). Not incidents.

| Surface | Path | Role |
|---------|------|------|
| Index | `index.md` | Plans + reports registry |
| What to review | `what-to-review.md` | Living checklist |
| Test plan | `test-plan.md` | TP-ID map → `tests/` |
| Lessons | `lessons.md` | P-* / L-* re-check |
| Requirement ↔ test matrix | `requirement-test-matrix.md` | RQ-* → TP families |
| Routed-verb table | `cli-routed-verb-table.md` | Menu labels |
| Suite | `../tests/run.sh` | Automated CLI + domain surface |

**Latest menu review:** 2026-09-16 · **Revise** · ship unit **1.0.0** (`./nginx-config`)

**Latest full suite baseline (unchanged this review):** 2026-09-13 · **PASS=194 FAIL=0 SKIP=0**

## Conventions

| Element | Rule |
|---------|------|
| Reports | `reports/YYYY-MM-DD-<scope>.md` |
| Severity | bug · suggestion · nit (product-review) |
| Status | open · closed |
| Finding IDs in lessons | `L-*` |

## Agent rules

1. Load `lessons.md` before a durable review.
2. Map every new **bug** to a TP row (have / todo).
3. Do not gitignore this tree.
4. No secrets in reports.
