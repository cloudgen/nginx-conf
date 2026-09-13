# =============================================================================
# tests/test_domain.sh — nginx-config domain surface (RQ-DOMAIN-NGINX-CONFIG)
# =============================================================================
# Proves help/about domain rows, GitLab verbs gone, profile seed/placeholders,
# render, off-TTY menu = help, apply/remove-lpu non-root fail-closed.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_domain() {
    t_header "Domain surface (TP-NGINX-CONFIG-*)"

    require_cmd sh

    # --- TP-NGINX-CONFIG-01: help lists work verbs + Type 0; no GitLab ---
    _out=$(sh "${SCRIPT}" help 2>/dev/null)
    _ec=$?
    assert_eq "TP-NGINX-CONFIG-01 help exit 0" 0 "$_ec"
    assert_contains "TP-NGINX-CONFIG-01 help lists domains" "$_out" "domains"
    assert_contains "TP-NGINX-CONFIG-01 help lists profiles" "$_out" "profiles"
    assert_contains "TP-NGINX-CONFIG-01 help lists nginx-conf" "$_out" "nginx-conf"
    assert_contains "TP-NGINX-CONFIG-01 help lists apply" "$_out" "apply"
    assert_contains "TP-NGINX-CONFIG-01 help lists remove-lpu" "$_out" "remove-lpu"
    assert_contains "TP-NGINX-CONFIG-01 help lists menu" "$_out" "menu"
    assert_contains "TP-NGINX-CONFIG-01 help still lists install" "$_out" "install"
    assert_contains "TP-NGINX-CONFIG-01 help still lists self-update" "$_out" "self-update"
    assert_contains "TP-NGINX-CONFIG-01 help lists --reset as --force" "$_out" "--reset"
    assert_not_contains "TP-NGINX-CONFIG-01 help must not list ssh-hostname" "$_out" "ssh-hostname"
    assert_not_contains "TP-NGINX-CONFIG-01 help must not list GitLab CE" "$_out" "GitLab CE"
    assert_not_contains "TP-NGINX-CONFIG-01 help must not list gitlab-adm" "$_out" "gitlab-adm"
    assert_not_contains "TP-NGINX-CONFIG-01 help must not list Alias: run" "$_out" "Alias: run"

    # --- TP-NGINX-CONFIG-02: help --json mentions domain note surface ---
    _out=$(sh "${SCRIPT}" --json help 2>/dev/null)
    _ec=$?
    assert_eq "TP-NGINX-CONFIG-02 help --json exit 0" 0 "$_ec"
    assert_contains "TP-NGINX-CONFIG-02 help --json success" "$_out" '"type":"success"'
    assert_contains "TP-NGINX-CONFIG-02 help --json notes domains" "$_out" "domains"
    assert_contains "TP-NGINX-CONFIG-02 help --json notes nginx-conf" "$_out" "nginx-conf"
    assert_contains "TP-NGINX-CONFIG-02 help --json notes profiles" "$_out" "profiles"
    assert_not_contains "TP-NGINX-CONFIG-02 help --json no ssh-hostname" "$_out" "ssh-hostname"

    # --- TP-NGINX-CONFIG-03: about JSON domain fields ---
    _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
    _ec=$?
    assert_eq "TP-NGINX-CONFIG-03 about --json exit 0" 0 "$_ec"
    assert_contains "TP-NGINX-CONFIG-03 about type" "$_out" '"type":"about"'
    assert_contains "TP-NGINX-CONFIG-03 about domains_file" "$_out" '"domains_file"'
    assert_contains "TP-NGINX-CONFIG-03 about profiles_dir" "$_out" '"profiles_dir"'
    assert_contains "TP-NGINX-CONFIG-03 about domain_count" "$_out" '"domain_count"'
    assert_contains "TP-NGINX-CONFIG-03 about domain product" "$_out" '"domain":"nginx-config"'
    assert_not_contains "TP-NGINX-CONFIG-03 about no email_file" "$_out" '"email_file"'

    # --- TP-NGINX-CONFIG-04: empty argv is Type O install-ensure, NOT apply ---
    ci_isolated_env
    _errf="${CI_HOME}/empty-arg-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        SCRIPT_URL="http://127.0.0.1:1/nginx-config-unreachable" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    _all="${_out}${_err}"
    if [ "$_ec" -ne 0 ]; then
        t_pass "TP-NGINX-CONFIG-04 empty argv failed install exits non-zero (Type O)"
    else
        t_fail "TP-NGINX-CONFIG-04 empty argv expected non-zero without channel, got 0"
    fi
    assert_not_contains "TP-NGINX-CONFIG-04 empty argv must not start GitLab install text" "$_all" "Installing GitLab"
    assert_not_contains "TP-NGINX-CONFIG-04 empty argv must not apply nginx" "$_all" "sites-available"
    assert_file_missing "TP-NGINX-CONFIG-04 empty argv left no binary" "${CI_USER_BIN}/nginx-config"
    ci_cleanup_env

    # --- TP-NGINX-CONFIG-05: profiles seeds catalog with placeholders ---
    ci_isolated_env
    _errf="${CI_HOME}/prof-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        sh "${SCRIPT}" profiles 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-NGINX-CONFIG-05 profiles exit 0" 0 "$_ec"
    assert_contains "TP-NGINX-CONFIG-05 lists cloudflared-protected-host" "${_out}${_err}" "cloudflared-protected-host"
    assert_contains "TP-NGINX-CONFIG-05 lists all-redirected" "${_out}${_err}" "all-redirected"
    assert_contains "TP-NGINX-CONFIG-05 lists excluded-non-cloudflared-ip" "${_out}${_err}" "excluded-non-cloudflared-ip"
    _pdir="${CI_HOME}/.local/nginx-config/profiles"
    assert_file_exists "TP-NGINX-CONFIG-05 seeded cloudflared-protected-host" "${_pdir}/cloudflared-protected-host.conf"
    assert_file_exists "TP-NGINX-CONFIG-05 seeded all-redirected" "${_pdir}/all-redirected.conf"
    assert_file_exists "TP-NGINX-CONFIG-05 seeded excluded-non-cloudflared-ip" "${_pdir}/excluded-non-cloudflared-ip.conf"
    for _n in cloudflared-protected-host all-redirected excluded-non-cloudflared-ip; do
        _body=$(cat "${_pdir}/${_n}.conf")
        assert_contains "TP-NGINX-CONFIG-05 ${_n} keeps {{domain-name}}" "$_body" "{{domain-name}}"
        assert_contains "TP-NGINX-CONFIG-05 ${_n} keeps {{cert-file-location}}" "$_body" "{{cert-file-location}}"
        assert_contains "TP-NGINX-CONFIG-05 ${_n} keeps {{cert-key-location}}" "$_body" "{{cert-key-location}}"
        assert_not_contains "TP-NGINX-CONFIG-05 ${_n} no live example.com fill" "$_body" "example.com"
    done
    ci_cleanup_env

    # --- TP-NGINX-CONFIG-06: off-TTY menu is help (no hang) ---
    _errf=$(mktemp)
    _out=$(sh "${SCRIPT}" menu </dev/null 2>"${_errf}")
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    rm -f "${_errf}"
    assert_eq "TP-NGINX-CONFIG-06 menu off-TTY exit 0" 0 "$_ec"
    assert_contains "TP-NGINX-CONFIG-06 menu off-TTY shows help usage" "${_out}${_err}" "Usage:"
    assert_not_contains "TP-NGINX-CONFIG-06 menu off-TTY not Choice prompt" "${_out}${_err}" "Choice (number or command)"

    # --- TP-NGINX-CONFIG-07: nginx-conf non-TTY without operands fails closed ---
    ci_isolated_env
    _errf="${CI_HOME}/nc-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        sh "${SCRIPT}" nginx-conf </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-NGINX-CONFIG-07 nginx-conf missing operands exit 1" 1 "$_ec"
    assert_not_contains "TP-NGINX-CONFIG-07 nginx-conf not unknown" "${_out}${_err}" "Unknown command"
    assert_contains "TP-NGINX-CONFIG-07 nginx-conf Next:" "${_out}${_err}" "Next:"
    ci_cleanup_env

    # --- TP-NGINX-CONFIG-08: nginx-conf render keeps catalog placeholders ---
    ci_isolated_env
    _errf="${CI_HOME}/render-err.txt"
    _syn="tcfg$(($$ % 10000)).example.test"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        sh "${SCRIPT}" --json nginx-conf all-redirected "${_syn}" /tmp/fullchain.pem /tmp/privkey.pem 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-NGINX-CONFIG-08 render exit 0" 0 "$_ec"
    assert_contains "TP-NGINX-CONFIG-08 render json success" "${_out}${_err}" '"type":"success"'
    _rendered="${CI_HOME}/.local/nginx-config/rendered/${_syn}.conf"
    assert_file_exists "TP-NGINX-CONFIG-08 rendered file" "${_rendered}"
    _rbody=$(cat "${_rendered}")
    assert_contains "TP-NGINX-CONFIG-08 rendered has synthetic domain" "$_rbody" "${_syn}"
    assert_contains "TP-NGINX-CONFIG-08 rendered 301" "$_rbody" "return 301"
    _cat="${CI_HOME}/.local/nginx-config/profiles/all-redirected.conf"
    _cbody=$(cat "${_cat}")
    assert_contains "TP-NGINX-CONFIG-08 catalog still {{domain-name}}" "$_cbody" "{{domain-name}}"
    assert_not_contains "TP-NGINX-CONFIG-08 catalog not filled with synthetic domain" "$_cbody" "${_syn}"
    ci_cleanup_env

    # --- TP-NGINX-CONFIG-09: apply without root fails closed ---
    _errf=$(mktemp)
    _out=$(sh "${SCRIPT}" apply tcfg.example.test 2>"${_errf}")
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    rm -f "${_errf}"
    assert_eq "TP-NGINX-CONFIG-09 apply non-root exit 1" 1 "$_ec"
    assert_not_contains "TP-NGINX-CONFIG-09 apply not unknown" "${_out}${_err}" "Unknown command"
    assert_contains "TP-NGINX-CONFIG-09 apply root required" "${_out}${_err}" "root"

    # --- TP-NGINX-CONFIG-10: remove-lpu without root fails closed ---
    _errf=$(mktemp)
    _out=$(sh "${SCRIPT}" remove-lpu 2>"${_errf}")
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    rm -f "${_errf}"
    assert_eq "TP-NGINX-CONFIG-10 remove-lpu non-root exit 1" 1 "$_ec"
    assert_not_contains "TP-NGINX-CONFIG-10 remove-lpu not unknown" "${_out}${_err}" "Unknown command"
    assert_contains "TP-NGINX-CONFIG-10 remove-lpu root required" "${_out}${_err}" "root"

    # --- TP-NGINX-CONFIG-11: unknown GitLab verbs fail closed ---
    _errf=$(mktemp)
    _out=$(sh "${SCRIPT}" ssh-hostname 2>"${_errf}")
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    rm -f "${_errf}"
    assert_eq "TP-NGINX-CONFIG-11 ssh-hostname unknown exit 1" 1 "$_ec"
    assert_contains "TP-NGINX-CONFIG-11 ssh-hostname unknown command" "${_out}${_err}" "Unknown command"
}
