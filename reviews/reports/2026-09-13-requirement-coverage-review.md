# Requirement coverage review — nginx-config 1.0.0

**Date:** 2026-09-13  
**Scope:** registry-only after GitLab strip + profile/menu specialize  
**Verdict:** **Approve** — `./tests/run.sh` **PASS=194 FAIL=0 SKIP=0**

## Registry inventory (Step −1)

- Registered on disk: 15 Active `requirement-*.md` (`index.md`)
- On disk, not in registry: none expected after delete of `requirement-domain-gitlab-nginx.md`
- Ghosts: none
- Foreign candidates: gitlab-nginx **origin ship unit** `./gitlab-nginx` kept as DNA reference; **not** product law

## Coverage vs user claim

| Claim | Owner | Coverage |
|-------|--------|----------|
| Strip GitLab features | RQ-DOMAIN-NGINX-CONFIG | Pass — forbidden verb list + tests TP-NGINX-CONFIG-01,11 |
| 0-argv interactive → main menu | RQ-SHELL-CLI-ZERO-ARGUMENTS + RQ-SHELL-CLI-DEFAULT-INTERACTION | Pass — installed+TTY list; not-installed Type O |
| Incorrect choice retry | RQ-SHELL-CLI-DEFAULT-INTERACTION | Pass — law + mold + PTY test |
| Expandable named profiles | RQ-DOMAIN-NGINX-CONFIG + RQ-NGINX-CONF | Pass — three names + samples |
| Local storage without filled placeholders | RQ-SHELL-CLI-STORAGE + domain | Pass — seed keeps `{{domain-name}}` etc. |
| Nginx samples in molds | LM-NGINX-CONF-STRUCTURE §2.7 | Pass |
| Checklists / tests aligned | CL-NGINX-CONF-STRUCTURE · CL-CLI-DEFAULT-INTERACTION · TP maps | Pass (design); suite run is the remaining gate |

## Class / dest

- software-development class file present
- Actor/approver: considered — **no dest approver**
- Dest fences: considered — **none**
- Coding-style related REQ: `requirement-shell-script-coding`

## Follow-ups

1. `./tests/run.sh` must be green before claiming DTV **have** in a release cut.
2. Do not advertise `./gitlab-nginx` as the product ship unit.
