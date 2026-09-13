**file**: docs/requirements/requirement-domain-nginx-config.md  
**Requirement-ID**: `RQ-DOMAIN-NGINX-CONFIG`  
**Status**: Active (Version 1.0.0)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth for domain product law** of the **nginx-config** POSIX shell CLI: **expandable nginx configuration profiles** beyond installing this program itself.

**Specialized from:** bootstrap product **selfmanaged** (Type 0 architecture) + gitlab-nginx nginx DNA **stripped of all GitLab features** (no GitLab CE, no `gitlab-adm`, no `gitlab.rb`, no `gitlab-ctl`, no GitLab SSH hostname).

It owns the **four domain pillars**:

1. **Specialized CLI subcommands**
2. **Specialized features** (profiles, placeholders, local storage, render/apply)
3. **Specialized project help items**
4. **Specialized project about items**

**Mandatory peers:**

| Peer | Requirement-ID | Owns |
|------|----------------|------|
| CLI interface | **RQ-SHELL-CLI-INTERFACE** | Dispatch, dual mention of domain verbs |
| Zero arguments | **RQ-SHELL-CLI-ZERO-ARGUMENTS** | Empty argv Type O + installed TTY menu overlay |
| Default interaction | **RQ-SHELL-CLI-DEFAULT-INTERACTION** | Numbered list membership / retry |
| Nginx conf structure | **RQ-NGINX-CONF** | Artifact types, basename, sample bodies |
| Storage | **RQ-SHELL-CLI-STORAGE** | Persistence folder where profiles live |

**Registry role:** This is the **one Active domain-requirements SSOT**. Parallel Active `requirement-domain-*` files are forbidden.

### 1.1 Human-facing

**In one sentence:** After the program is installed, you pick a named nginx profile, fill domain and certificate paths, and get a rendered conf without GitLab.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Install as yourself; list and render profiles from local storage | `nginx-config profiles` |
| The other role | Root writes a rendered `{{domain-name}}.conf` into nginx | `sudo nginx-config apply example.com` |
| Not this file | Installing *this* CLI | `nginx-config` with no arguments on first use |

| Includes | Excludes |
|----------|----------|
| `domains`, `profiles`, `nginx-conf`, `apply`, `remove-lpu` | GitLab CE, `gitlab-adm`, `ssh-hostname`, `run` 13-step GitLab setup |
| Local profile catalog with placeholders | Hard-coding live domain/cert paths into stored profiles |

| Surface | What you open | What for |
|---------|---------------|----------|
| `nginx-config` (terminal, already installed) | numbered list | work commands |
| `${HOME}/.local/nginx-config/profiles/` | folder | expandable catalog |
| `nginx-config nginx-conf` | command | render one profile |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| See the three shipped profiles | Local copies keep `{{domain-name}}` placeholders | `nginx-config profiles` |

## Under command line for normal user only

When this program runs on Termux, Git Bash, Windows Command Prompt, or the same class: **admin privilege** and **dedicated system user privilege** are unused. Do not wrap `sudo`, do not wrap Linux `apt`/`dnf`, do not create `nginx-adm`, and do not recommend `sudo curl | sh`. Git Bash and Windows cmd must not invoke Termux `pkg`.

**This requirement:** `apply` and `remove-lpu` are unused on that class. `domains` / `profiles` / `nginx-conf` still render into this login’s persistence folder.

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Specialized CLI subcommands

| Command | Privilege | Handler | Operands | Required behavior | Non-zero |
|---------|-----------|---------|----------|-------------------|----------|
| `domains` | invoker (read) | `app_domains` | `--json` | Show domains from persistence `domains.conf` | missing file → warn, not crash |
| `profiles` | invoker | `app_profiles` | `--json` | List expandable work-profiles in local storage; seed if missing | I/O fail → fail |
| `nginx-conf` | invoker | `app_nginx_conf` | profile, domain, cert-file, cert-key | TTY: one field at a time, **retry** invalid profile; render into persistence `rendered/{{domain-name}}.conf`. Non-TTY: operands required | unknown profile off-TTY → fail |
| `apply` | root | `app_apply` | domain | Copy rendered `{{domain-name}}.conf` to nginx sites-available; backup existing; `nginx -t` when nginx exists | not root → fail; missing render → fail; `nginx -t` fail → fail |
| `remove-lpu` | root | `app_remove_lpu` | global `--force` | Remove **nginx-adm only** (`userdel -r`; sudoers backup+remove). **MUST NOT** mention or remove `gitlab-adm` | not root → fail; non-TTY without `--force` → fail |
| `menu` / `main` | invoker | `app_main_menu` | — | Same numbered list as installed TTY empty argv | off-TTY → help (no hang) |

**Dispatch rules:**

1. Domain commands **MUST** be recognized in the same flag parse as Type 0 lifecycle commands.  
2. Empty argv **MUST NOT** start host apply — empty argv is Type O install-ensure when not installed, and the numbered list when installed on a TTY (**RQ-SHELL-CLI-ZERO-ARGUMENTS**).  
3. **MUST NOT** route `run`, `setup`, `ssh-hostname`, `email`, `remove-gitlab-adm`.  
4. All user-facing domain messages **MUST** go through `out_*`.  
5. Type 0 routes remain available.  
6. **`remove-lpu` is not** Type 0 `self-uninstall`.

### 2.2 Specialized features

#### 2.2.1 Expandable profiles (normative names)

The default nginx samples **MUST** be three expandable work-profiles:

| Profile name | Meaning |
|--------------|---------|
| `cloudflared-protected-host` | HTTPS origin host behind Cloudflare |
| `all-redirected` | Redirect all cleartext traffic to HTTPS |
| `excluded-non-cloudflared-ip` | Deny origin requests not from Cloudflare |

Plus shared helper `cloudflare-map` (type 1; not a numbered work-profile).

Operators **MAY** add more `*.conf` files under the profiles directory. New files **MUST** keep the three placeholders.

#### 2.2.2 Filename grammar + sample bodies

**Catalog (local storage):**

| Field | Value |
|-------|--------|
| Directory | `${HOME}/.local/${APP_NAME}/profiles/` |
| Grammar | `{profile-name}.conf` |
| Sample basename | `cloudflared-protected-host.conf` |
| Placeholders **MUST** remain | `{{domain-name}}` · `{{cert-file-location}}` · `{{cert-key-location}}` |

**Rendered output:**

| Field | Value |
|-------|--------|
| Directory | `${HOME}/.local/${APP_NAME}/rendered/` |
| Grammar | `{{domain-name}}.conf` |
| Sample basename | `example.com.conf` (synthetic in tests) |

**Domains list:** `${HOME}/.local/${APP_NAME}/domains.conf` — one FQDN per line.

Complete sample bodies for the three work-profiles **MUST** match **RQ-NGINX-CONF** (same text as the ship-unit seed). **MUST NOT** fill placeholders at seed time.

#### 2.2.3 Local install seed

When the CLI is installed locally (or already-installed empty argv / `install` no-op), **MUST** copy bundled profiles into the persistence profiles directory if missing. **MUST NOT** overwrite a local file that still contains `{{domain-name}}`. **MUST NOT** write live domain or cert paths into the catalog.

#### 2.2.4 Non-goals

- GitLab CE / Omnibus / `gitlab.rb` / `gitlab-ctl`  
- `gitlab-adm`  
- GitLab SSH hostname  
- Empty argv starting host apply  
- Treating Certbot obtain as this product’s domain setup (cert **paths** are operator inputs)

### 2.3 Specialized project help items

`help` **MUST** list:

- `domains` · `profiles` · `nginx-conf` · `apply` · `remove-lpu` · `menu` / `main`  
- Type 0 self-management table  
- Empty-argv meaning (not installed / installed terminal / installed script)

**MUST NOT** list GitLab verbs (`run` as GitLab setup, `ssh-hostname`, `remove-gitlab-adm`).

### 2.4 Specialized project about items

`about` **MUST** expose:

- domains file path + count  
- profiles dir + count  
- cache folder + persistence folder (shell storage peer)  
- useful commands: numbered list, `profiles`, `nginx-conf`

---

## 3. Acceptance criteria (summary)

| ID | Criterion |
|----|-----------|
| AC-D1 | `nginx-config version` / `help` / `about` work under Type 0 + domain |
| AC-D2 | Empty argv does **not** apply nginx host conf |
| AC-D3 | `profiles` lists the three named profiles with placeholders kept |
| AC-D4 | `nginx-conf` renders without writing filled values back into the catalog |
| AC-D5 | Help / about / dispatcher contain **no** GitLab CE / `gitlab-adm` / `ssh-hostname` |

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Reintroduce GitLab CE, `gitlab-adm`, `gitlab.rb`, `ssh-hostname`, or `run` as GitLab host setup.  
2. Hard-code a live domain or cert path into shipped or seeded profiles.  
3. Skip retry on invalid profile / menu choice (die on typo).  
4. Store catalog profiles under `/etc/letsencrypt` as this product’s SSOT.  
5. Create a second Active `requirement-domain-*`.

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-NGINX-CONFIG-01…08** | `tests/test_domain.sh` | have |

**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`.

**Last Updated**: 2026-09-13  
**Owner**: nginx-config project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
