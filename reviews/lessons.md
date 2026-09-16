# Lessons — nginx-config

Prior-report failure modes. Every durable product review **MUST** reload this file and re-check each row.

| ID | Mode | Origin | Re-check |
|----|------|--------|----------|
| **L-MENU-CLAIM** | CLI-interface still says the numbered list is **not claimed** after default-interaction law claims it | 2026-09-06 README review (menu unclaimed) vs 2026-09-13 specialize (menu claimed) | `requirement-shell-cli-interface.md` “Explicitly out of scope” vs live `app_main_menu` |
| **L-MENU-NEXT** | Root-required fatal `Next:` uses dispatcher `COMMAND` (`menu` / empty), not the leaf verb | 2026-09-06 follow-up P1; confirmed 2026-09-16 PTY `apply` from menu | `check_root` after a numbered pick |
| **L-MENU-WARN** | Invalid TTY pick prints `[WARN]` instead of `[ERROR]` (`out_warn` vs `out_error`) | 2026-09-16 main-menu review; term `invalid-choice-retry` | PTY unused integer (`0` / `6`) |
| **L-MENU-LEAF-EXIT** | Valid front-board leaf (`profiles`, `domains`, …) **exits** the CLI instead of reprinting the front board | 2026-09-16; term `command-finished-front-board` (H1 2026-09-16) | `app_main_menu` after `app_run_command` |
| **L-MENU-INK** | Numbered short name is unstyled on TTY; README rows omit `**short**: *long*` | 2026-09-16; term `default-cli-main-menu-style` | `out_menu_choice` SGR 1; README § After install |
| **L-NONROOT-HOST** | Non-root domain mutation must fail closed (never exit 0 after touching host nginx) | 2026-08-11 F1 (`run` as non-root) | Menu **4** `apply` / **5** `remove-lpu` as a normal user |
| **L-REVIEWS-IDENTITY** | `reviews/README.md` still titled gitlab-nginx after specialize | 2026-09-13 strip; noticed 2026-09-16 | Public reviews header vs `APP_NAME` |

**Last update:** 2026-09-16
