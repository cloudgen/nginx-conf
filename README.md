# nginx-config - Expandable nginx configuration profiles

![Version](https://img.shields.io/badge/Version-1.0.1-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)
[![Stars](https://img.shields.io/github/stars/cloudgen/nginx-conf?style=flat-square)](https://github.com/cloudgen/nginx-conf)
[![Shell](https://img.shields.io/badge/Shell-POSIX%20sh-orange?style=flat-square)]()

You put one program file (`nginx-config`) on a Linux box, install it as yourself, then pick a **named nginx profile**. Local copies keep placeholders (`{{domain-name}}`, `{{cert-file-location}}`, `{{cert-key-location}}`) so nothing is frozen to one host.

This project started as **gitlab-nginx** and had every GitLab-only feature removed. It does **not** install GitLab.

| Who | Meaning | Example |
|-----|---------|---------|
| **You** | A person who wants nginx site conf from a catalog. You can install this program as yourself. | `curl … \| sh` then `nginx-config` |
| **The other role** | Root copies a rendered `{{domain-name}}.conf` into nginx, or removes `nginx-adm`. | `sudo nginx-config apply example.com` |
| **Not this** | GitLab CE, `gitlab-adm`, or a one-shot “setup GitLab” command. Empty `nginx-config` after install is the **numbered list**, not GitLab. | `nginx-config` with no arguments (already installed, terminal) |

| Includes | Excludes |
|----------|----------|
| Three expandable profiles plus a shared Cloudflare map | GitLab Omnibus, `gitlab.rb`, GitLab SSH hostname |
| Install for yourself (`~/.local/bin`) or for everyone (`/usr/local/bin`) | Treating empty argv as help |
| Automatic SHA-256 companion check on download | Requiring a `CHECKSUM=` pin for every install |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Install the program | Downloads `nginx-config` and places it on your PATH. Seeds local profiles with placeholders. | `curl -fsSL https://raw.githubusercontent.com/cloudgen/nginx-conf/main/nginx-config \| sh` |
| Open the numbered list | After install, on a real terminal, no arguments opens the list. A wrong number asks again. | `nginx-config` |
| Render a profile | Fill domain and cert paths; catalog files stay unfilled. | `nginx-config nginx-conf` |

This project follows [CIAO](https://github.com/cloudgen/ciao) (Caution • Intentional • Anti-fragile • Over-engineered).

## Features

- **Self-installing program file** — user-local (`~/.local/bin`) or global (`/usr/local/bin`)
- **Automatic SHA-256 companion check** — the program fetches `nginx-config.sha256` itself (no env pin required)
- **Numbered list** on a real terminal after install (`menu` / `main` are the same list)
- **Retry on a wrong choice** at every menu layer
- **Expandable profiles** stored under `~/.local/nginx-config/profiles/` with placeholders kept:
  - `cloudflared-protected-host`
  - `all-redirected`
  - `excluded-non-cloudflared-ip`
- **Render** a profile to `~/.local/nginx-config/rendered/{{domain-name}}.conf`
- **`apply`** (root) writes that file into nginx `sites-available`
- **`remove-lpu`** removes dedicated `nginx-adm` only
- **Idempotent CLI lifecycle** — `version-check`, `self-update`, `self-uninstall`

## Quick Installation

Install the program:

```bash
# For yourself → ~/.local/bin/nginx-config
curl -fsSL https://raw.githubusercontent.com/cloudgen/nginx-conf/main/nginx-config | sh
```

```bash
# For everyone → /usr/local/bin/nginx-config
sudo curl -fsSL https://raw.githubusercontent.com/cloudgen/nginx-conf/main/nginx-config | sudo sh
```

The channel URL is the product default (`SCRIPT_URL`). Override that env only if you fork the channel.

### Integrity (automatic SHA-256)

When you do **not** set `CHECKSUM`, the program downloads the companion digest itself from `${SCRIPT_URL}.sha256` (in-repo file: `nginx-config.sha256`). Human mode is designed to show the **link** (companion URL), the **value** (expected digest), and the **result**.

| Outcome | What happens |
|---------|----------------|
| Companion found and digest **matches** | Install continues |
| Companion found and digest **mismatches** | Install **aborts** |
| Companion **missing** | **Warning**, then install continues (best-effort) |

Algorithm: **SHA-256** (`sha256sum`). Same-channel companion files prove the two files on that channel match. They are not a substitute for signed releases.

### Advanced: optional digest pin (CI)

Optional process env — **not** listed in `help` / `about`. Paste the current `nginx-config.sha256` hex:

```bash
CHECKSUM=<64-hex-from-nginx-config.sha256> \
  curl -fsSL https://raw.githubusercontent.com/cloudgen/nginx-conf/main/nginx-config | sh
```

Regenerate the in-repo companion after editing `./nginx-config`: `sha256sum nginx-config | cut -d' ' -f1 > nginx-config.sha256`.

### After install — numbered list

On a real terminal (already installed):

```text
$ nginx-config
[INFO] **nginx-config**(*1.0.0*) — numbered list of live commands
1. domains: Show saved domains
2. profiles: List expandable nginx profiles
3. nginx-conf: Render a profile with domain and cert paths
4. apply: Write a rendered conf into nginx (root)
5. remove-lpu: Remove dedicated nginx-adm account
9. Exit
Choice (number or command):
```

Choose a number, or type the command name. A wrong number asks again. `9` (or `exit` / `quit`) leaves the list. `nginx-config menu` (alias `main`) is the same list.

Empty `nginx-config` in a script (no terminal) reports **already installed**. It does not hang.

## Usage

```text
nginx-config [command] [options]
```

| Command | Who may run it | What it does |
|---------|----------------|--------------|
| *(no arguments)* | You | Not installed → install this program. Installed + terminal → numbered list. Installed + script → already installed |
| `install` | You (root → global path) | Place the CLI binary; seed local profiles |
| `version` | You | Print version |
| `about` | You | Diagnostics (install + cache/persistence + profiles) |
| `help` | You | Full usage |
| `version-check` | You | Compare local vs channel version |
| `self-update` | You | Update this program from the channel |
| `self-uninstall` | You | Remove this program (not nginx, not `nginx-adm`) |
| `menu` (alias `main`) | You | Same numbered list |
| `domains` | You | Show saved domains |
| `profiles` | You | List expandable profiles in local storage |
| `nginx-conf` | You | Render a profile (domain + cert paths) |
| `apply` | Root | Write rendered `{{domain-name}}.conf` into nginx |
| `remove-lpu` | Root | Remove dedicated `nginx-adm` |

**Global options:** `--quiet` / `-q`, `--json`, `--force`, `--debug`

**Environment (listed in help):** `REPO_USER`, `REPO_NAME`, `SCRIPT_URL`. `CHECKSUM` is an install-path pin only — not a help/about field.

## Examples

```bash
nginx-config version
nginx-config about
nginx-config --json about
nginx-config profiles
nginx-config nginx-conf all-redirected tcfg.example.test /etc/letsencrypt/live/tcfg.example.test/fullchain.pem /etc/letsencrypt/live/tcfg.example.test/privkey.pem
sudo nginx-config apply tcfg.example.test
sudo nginx-config remove-lpu --force
nginx-config help
```

## Platform Compatibility

| Surface | Status |
|---------|--------|
| Ubuntu 20.04 / 22.04 / 24.04 | Supported for profile render + optional root apply |
| Other Debian-based Linux with `/bin/sh`, `curl` or `wget`, `sha256sum` | CLI install and self-update |
| Termux / Git Bash / Windows Command Prompt | CLI self-install as yourself only — no `apply`, no dedicated system users, no `sudo curl \| sh` |
| macOS as an nginx origin host | Not claimed |

Full numbered list needs a TTY. Non-interactive `menu` shows help so scripts do not wait.

## Related Projects

- [CIAO](https://github.com/cloudgen/ciao) — defensive programming philosophy this CLI follows
- [selfmanaged](https://github.com/cloudgen/selfmanaged) — Type 0 bootstrap this product specialized from
- Origin DNA: gitlab-nginx (GitLab features stripped)

## Contributing

Contributions are welcome. Open an issue or a pull request. Keep install, checksum, profile placeholders, and privilege behavior honest in `README.md` and `CHANGELOG.md` when you change them.

## License

MIT License. See [LICENSE.md](LICENSE.md).

## Last Update

2026-09-13 — **1.0.0**: GitLab features stripped; 0-argv numbered list; expandable profiles `cloudflared-protected-host`, `all-redirected`, `excluded-non-cloudflared-ip` stored locally with placeholders.
