# What to review — nginx-config

Living checklist for durable product reviews. Reload `lessons.md` first.

## Surfaces (this product)

| Surface | Path / command | High risk |
|---------|----------------|-----------|
| Numbered TTY list | `./nginx-config` (installed+TTY) · `menu` / `main` | Membership, Exit **9**, retry, after-leaf return |
| Profile picker | TTY `nginx-conf` with no profile | Nested layer; **0** Back vs **9** Exit |
| Domain Type 1 | `apply` / `remove-lpu` | Non-root fail-closed; `Next:` copy |
| Type 0 lifecycle | `install` / `self-update` / `self-uninstall` | Off the **front** board; CLI place ≠ nginx start |
| README demo | `README.md` Quick Installation | Live capture + markdown ink |

## Main menu (always when claimed)

Walk **`CL-CLI-DEFAULT-INTERACTION`**:

1. Labels = routed-verb table human-readable.
2. Look = default CLI main menu style (header nametag; **bold** short; *italic* gray long).
3. Front board **MUST NOT** list install / self-update / version / about / help / testers / `menu`.
4. Invalid pick at **any** layer: `out_error`, reprint **this** layer, re-prompt (**not** `out_die`).
5. After a **valid leaf**, redisplay the **front** board (do not exit; do not stay on a submenu).
6. Off-TTY `menu` = help; no hang.
7. Choice is current-shell `prompt_ask` then `PROMPT_ASK_VALUE` (no `$()` of `read`).

## Elevation / TTY traps

| Claim | Review |
|-------|--------|
| Type 1 **package** elevation / password sudo | **N/A** — this CLI is Type 0 place; `apply` is fail-closed `check_root`, not TTY password sudo |
| Domain Type 1 from the list | Non-root **4** / **5** must `out_die`; **MUST NOT** write nginx |
| `self-update` vs nginx start | CLI place only. Host `nginx -t` / sites-available is **`apply`**, not `self-update` |

## Operator-readable errors (CLI fatals)

Score **`CL-OPERATOR-READABLE-ERROR`** E1–E7 on:

- `check_root` when the leaf was chosen from the numbered list
- Invalid menu pick (must be `out_error`, not jargon-only)
- Off-TTY missing operands (`nginx-conf` / `apply`)

## JSON grant / re-encode

**N/A** — no file-based JSON sudoer grant on this product.

## LPU / LPA

`nginx-adm` is the dedicated nginx account. Menu **5** `remove-lpu` is root-only. No dest approver claimed.

## Publish

After a durable review:

1. `reviews/reports/YYYY-MM-DD-<scope>.md`
2. Update `index.md`, `lessons.md`, `test-plan.md` as needed
3. Do not treat `/tmp` as the deliverable

**Last update:** 2026-09-16
