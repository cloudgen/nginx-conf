**file**: docs/requirements/requirement-nginx-conf.md  
**Requirement-ID**: `RQ-NGINX-CONF`  
**Status**: Active (Version 1.0.0)  
**Area**: webserver  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth for nginx conf structure** of **nginx-config**: which artifact types the product generates, the type-2 basename, location roles, and the **complete sample bodies** for the three expandable profiles.

It is **not** a second domain SSOT. Domain verbs live on `requirement-domain-nginx-config`.

### 1.1 Human-facing

**In one sentence:** The program keeps named nginx samples as profiles and writes one `{{domain-name}}.conf` when you render.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Local catalog under persistence | `~/.local/nginx-config/profiles/all-redirected.conf` |
| The other role | Root apply uses the same basename under nginx | `/etc/nginx/sites-available/{{domain-name}}.conf` |
| Not this file | Numbered list membership | `requirement-shell-cli-default-interaction` |

| Includes | Excludes |
|----------|----------|
| Three artifact types + three named profiles + samples | GitLab `proxy_pass` to Unicorn/Puma |
| Placeholders in catalog copies | Filling `{{domain-name}}` at seed |

| Surface | What you open | What for |
|---------|---------------|----------|
| `profiles/*.conf` | files | catalog |
| `rendered/{{domain-name}}.conf` | file | filled output |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Inspect a catalog file | Placeholders still visible | `nginx-config profiles` |

## Under command line for normal user only

Catalog and rendered files still live under this login’s persistence folder. **MUST NOT** write `/etc/nginx` on Termux / Git Bash / Windows cmd.

---

## 2. Core Rules (Mandatory)

### 2.1 Artifact types this product generates

| Type id | Generate? |
|---------|-----------|
| `shared-cloudflare` | **YES** (`cloudflare-map.conf`) |
| `per-domain-https` | **YES** (`cloudflared-protected-host`, `excluded-non-cloudflared-ip`) |
| `redirect` | **YES** (`all-redirected`) |

**MUST NOT** invent a fourth portable artifact type.

### 2.2 Type-2 basename

Rendered and applied HTTPS/redirect files **MUST** use **`{{domain-name}}.conf`**. Layout: persistence `rendered/` and, on apply, `{{NGINX_CONF_ROOT}}/sites-available/{{domain-name}}.conf` (default `/etc/nginx`).

### 2.3 Document root

Default `root /var/www/{{domain-name}};`. Ownership default **www-data:www-data** when the product creates that tree (apply path **MAY** skip creating content).

### 2.4 Location roles (Cloudflare HTTPS profiles)

| Role | Match |
|------|--------|
| Content | `location /` |
| ACME | `/.well-known/acme-challenge/` |
| CF check | `= /cloudflare-check` |

`excluded-non-cloudflared-ip` **MUST** gate `location /` (no `CF-Connecting-IP` → 403). ACME and cloudflare-check **MUST NOT** inherit that gate.

### 2.5 Expandable profile samples (complete bodies)

Catalog copies **MUST** contain these three placeholders and **MUST NOT** replace them at seed:

`{{domain-name}}` · `{{cert-file-location}}` · `{{cert-key-location}}`

#### Sample A — `cloudflared-protected-host.conf`

```nginx
# profile: cloudflared-protected-host
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name {{domain-name}};
    root /var/www/{{domain-name}};
    index index.html;
    ssl_certificate {{cert-file-location}};
    ssl_certificate_key {{cert-key-location}};
    ssl_protocols TLSv1.2 TLSv1.3;
    location = /cloudflare-check { default_type text/html; return 200 '...'; }
    location / { try_files $uri $uri/ =404; }
    location /.well-known/acme-challenge/ { root /var/www/letsencrypt; try_files $uri =404; }
}
```

Ship-unit seed is the **full** body (comments + ssl_ciphers + `$is_cf`). Tests **MUST** prove placeholders remain.

#### Sample B — `all-redirected.conf`

```nginx
# profile: all-redirected
server {
    listen 80;
    listen [::]:80;
    server_name {{domain-name}};
    location /.well-known/acme-challenge/ { root /var/www/letsencrypt; try_files $uri =404; }
    location / { return 301 https://{{domain-name}}$request_uri; }
}
```

Cert placeholders **MUST** still appear in the catalog file comments so local copies never hard-code live paths.

#### Sample C — `excluded-non-cloudflared-ip.conf`

```nginx
# profile: excluded-non-cloudflared-ip
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name {{domain-name}};
    ssl_certificate {{cert-file-location}};
    ssl_certificate_key {{cert-key-location}};
    location / {
        if ($http_cf_connecting_ip = "") { return 403; }
        try_files $uri $uri/ =404;
    }
    location /.well-known/acme-challenge/ { root /var/www/letsencrypt; try_files $uri =404; }
}
```

### 2.6 Deploy hygiene

`apply` **MUST** backup an existing dest conf, then `nginx -t` when `nginx` is on PATH, and **MUST** fail closed on test failure.

### 2.7 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 2 – Intentional**: Three named profiles, not an unnamed “default conf”.  
- **CIAO Principle 5 – SSOT**: Sample bodies live here and in the ship-unit seed.  
- **CIAO Principle 21 – Dual policies**: Placeholders in catalog; real values only in rendered output.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: Do not apply untested conf.  
- **Intentional**: Profile names are the catalog.  
- **Anti-fragile**: Extra `*.conf` files may be added under the same placeholder contract.  
- **Over-protect**: Seed never writes filled domain/cert paths into the catalog.

## 4. Protection Rule (Sacred)

**MUST NOT**:

1. Collapse the three profiles into one unnamed default.  
2. Drop ACME / cloudflare-check from Cloudflare HTTPS samples without law.  
3. Specialize type 2 without `{{domain-name}}.conf`.  
4. Cite this file as a second `requirement-domain-*`.

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-NGINX-CONFIG-03,04,05** | `tests/test_domain.sh` | have |

**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`.

**Last Updated**: 2026-09-13  
**Owner**: nginx-config project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO (https://github.com/cloudgen/ciao).
