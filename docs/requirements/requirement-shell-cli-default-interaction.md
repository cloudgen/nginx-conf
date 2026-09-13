**file**: docs/requirements/requirement-shell-cli-default-interaction.md  
**Status**: Active (Version 1.0.0)  
**Area**: shell  
**Key**: `requirement-shell-cli-default-interaction`  
**id**: RQ-SHELL-CLI-DEFAULT-INTERACTION  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for nginx-config’s **TTY numbered list of live work commands**. The product **claims** that list. Look **MUST** be default CLI main menu style: header **nginx-config**(*version*) then `command: what it does` with gray italic descriptions on a TTY.

The zero-argument requirement assigns **installed + interactive** empty argv to this list and keeps not-installed empty argv as Type O install-ensure. `menu` / `main` are the same handler.

**Incorrect choice at any layer MUST re-prompt** (main list, profile picker, required field). **MUST NOT** die on a typo.

### 1.1 Human-facing

**In one sentence:** On a real terminal, after this program is installed, type `nginx-config` with no arguments to get a numbered list; a wrong number asks again.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Pick a number or a command name | `nginx-config` then `2` or `profiles` |
| A script / pipe | The list does not appear | `nginx-config </dev/null` when already installed → already-installed |
| Not this file | First-time empty argv still installs | `requirement-shell-cli-zero-arguments` |

| Includes | Excludes |
|----------|----------|
| Numbered 1…5 work commands; Exit **9**; retry on invalid | `help` as a row; install / self-update / version / about; testers; `menu` as a choice |

| Surface | What you open | What for |
|---------|---------------|----------|
| `nginx-config` (installed, real terminal) | command | numbered list |
| `nginx-config menu` | command | same list |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Leave the list | Exit is **9** (five command rows) | `9` |
| Mistype | The list asks again | `0` then `9` |

## Under command line for normal user only

The numbered list **MUST** still omit install/setup and testers. `apply` / `remove-lpu` chosen from the list **MUST** fail closed if the class cannot elevate.

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Claim and case

| Field | Value |
|-------|--------|
| **Claims a default function** | **yes** |
| **Zero-argument requirement present** | **yes** |
| **Online-installable** | **yes** (Type O) |
| **Case** | **3** (empty argv owned by zero-arg REQ; that REQ routes installed+TTY to this list) |

1. Empty argv **MUST** follow `requirement-shell-cli-zero-arguments`.  
2. The numbered list **MUST** also be routed-verb **`menu`**. **`main` MUST** be the same handler.  
3. **MUST NOT** draw the list off-TTY.  
4. **MUST NOT** list `menu` / `main` as a numbered choice.  
5. Choice **MUST** be current-shell `prompt_ask` then `PROMPT_ASK_VALUE`. **MUST NOT** `_choice=$(prompt_ask …)`.  
6. Look **MUST** use `util_app_ident` + `out_menu_choice`.  
7. **Invalid or empty choice MUST re-prompt** that same layer. **MUST NOT** `out_die` for a bad menu number. Nested profile picker **MUST** retry the same way.

### 2.2 `menu` / `main` mode check

| Invocation | `--json` | MUST | MUST NOT |
|------------|----------|------|----------|
| Interactive `nginx-config menu` | **Ignore** | Show the numbered list; read a number or a command name | Treat `--json` as JSON help; hang |
| Non-interactive `nginx-config menu` | **Follow** | Help (human or JSON) | Draw the list; hang |

### 2.3 Numbered list

| # | Command | Human-readable |
|---|---------|----------------|
| 1 | `domains` | `domains: Show saved domains` |
| 2 | `profiles` | `profiles: List expandable nginx profiles` |
| 3 | `nginx-conf` | `nginx-conf: Render a profile with domain and cert paths` |
| 4 | `apply` | `apply: Write a rendered conf into nginx (root)` |
| 5 | `remove-lpu` | `remove-lpu: Remove dedicated nginx-adm account` |
| 9 | Exit | not a routed-verb |

**N = 5** → Exit **9**.

**MUST NOT** list: `help`; `install` / `setup`; self-managed; `version` / `about`; test-purpose; `menu` / `main`.

### 2.4 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution**: Scripts never hang on the list.  
- **CIAO Principle 2 – Intentional**: Claimed numbered list; retry is explicit.  
- **CIAO Principle 16 – Interactive vs Non-Interactive**: TTY list; off-TTY help/ensure.  
- **CIAO Principle 5 – SSOT**: Labels match help one-liners.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: No menu in pipes.  
- **Intentional**: Five work rows; Exit 9.  
- **Anti-fragile**: Typo does not abort the session.  
- **Over-protect**: do-not-capture-read.

### 2.1 Implementation Notes (this project)

| Item | Value for nginx-config |
|------|---------------------|
| **Product / binary** | `nginx-config` |
| **Claimed** | yes |
| **Case** | **3** with zero-arg overlay (installed+TTY) |
| **Handler** | `app_main_menu` |
| **Ship-unit status** | **Implemented** |
| **N** | **5** |
| **Exit** | **9** |
| **Prompt helper** | `prompt_ask` → `PROMPT_ASK_VALUE` |

## 4. Protection Rule (Sacred)

**MUST NOT**:

1. Invent labels.  
2. Put install / version / about / help / menu on the list.  
3. Capture the choice with `$()` of `prompt_ask`.  
4. Die on an incorrect number instead of retrying.  
5. Hang off-TTY.

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-16** | `tests/test_cli.sh` | have |
| **TP-CLI-17** | `tests/test_cli.sh` | have |
| **TP-NGINX-CONFIG-06** | `tests/test_domain.sh` | have |

**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`.

**Last Updated**: 2026-09-13  
**Owner**: nginx-config project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO (https://github.com/cloudgen/ciao).
