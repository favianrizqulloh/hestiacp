---
description: Critical guidelines and invariants for HestiaCP NGINX standalone, dual-stack IPv6, and firewall configuration.
globs:
  - "bin/v-*"
  - "install/**"
  - "func/**"
  - "web/**"
---

# HestiaCP Dual-Stack & NGINX Standalone Development Rules

When maintaining or developing features in this repository, strictly adhere to the following invariants:

1. **Dual-Stack Default Server Separation & Catch-All Flow**:
   - Never place wildcard `[::]:80 default_server` or `[::]:443 default_server ssl` inside per-IP configuration templates (such as `unassigned.inc` or `/etc/nginx/conf.d/$ip.conf`).
   - All IPv6 wildcard catch-all listeners must reside in a dedicated single file (`/etc/nginx/conf.d/00-default-ip6.conf`).
   - Per-IP files must only bind to their specific IPv4 socket (`directIP:80 default_server`, `directIP:443 default_server ssl`).
   - Catch-all blocks (both IPv4 per-IP and IPv6 wildcard) MUST enforce the two-step flow:
     - **Port 80 (HTTP)**: `return 301 https://$host$request_uri;` (redirect unassigned/direct IP to HTTPS).
     - **Port 443 (HTTPS)**: Serve 100-year self-signed dummy certificate (`/etc/nginx/ssl/default/cert.pem`), enable HTTP/2 + HTTP/3 QUIC (`quic reuseport default_server`, `http2 on`, `http3 on`, `quic_retry on`, `add_header Alt-Svc 'h3=":443"; ma=86400' always;`), and terminate with `return 444;`.

2. **Firewall Protocol Formatting**:
   - Always convert protocols to lowercase before passing to `ip6tables` (e.g. `proto_lower="${PROTOCOL,,}"`).
   - For ICMP on IPv6, specify `-p ipv6-icmp`.
   - Never apply IPv4 CIDRs to `ip6tables` or IPv6 CIDRs to `iptables`.

3. **HTTP/3 QUIC Reuseport Invariant**:
   - The `reuseport` directive for QUIC (`listen ... quic reuseport`) must only appear on the default server block for a socket family.
   - Virtual host templates and domain include generators must specify `listen ... quic;` without `reuseport`.

4. **HestiaCP Upstream Merge Compatibility**:
   - Avoid deleting existing function signatures in `bin/` or `func/`.
   - Keep Apache execution paths safely bypassed or no-op'd rather than rewriting entire CLI scripts, preventing upstream git merge conflicts.

5. **ACME HTTP-01 Validation & Dual-Stack Port 80 Invariant**:
   - Let's Encrypt HTTP-01 ACME challenge operates strictly over HTTP (port 80) and *always prioritizes IPv6* if an `AAAA` record is published.
   - When dual-stack is enabled, any domain (and specifically the hostname domain) MUST have `listen [::]:80;` alongside `listen [::]:443 ssl;` in NGINX.
   - Failure to bind `[::]:80` on the domain causes NGINX to route the ACME query to `00-default-ip6.conf`, terminating with `return 444;` (TCP RST) and triggering `Connection reset by peer`.
   - In `v-add-letsencrypt-host`, always auto-detect public IPv6, enable `v-change-web-domain-ip6`, and force a rebuild of the domain before requesting Let's Encrypt certificate issuance.
   - In `v-add-letsencrypt-domain`, always pass `"yes"` to `$BIN/v-restart-web "yes"` and `$BIN/v-restart-proxy "yes"` to force an immediate reload rather than queueing under `SCHEDULED_RESTART`.

6. **Object Configuration Key Invariant (`add_object_key`)**:
   - `update_object_value` only updates fields that already exist on a configuration line in `web.conf`.
   - Before updating or setting `IP6`, always ensure `add_object_key "web" 'DOMAIN' "$domain" 'IP6' 'IP'` is called to guarantee the key exists in the record.

7. **Installer Repository Directory Sync Invariant**:
   - When copying repository directories (`bin/`, `func/`, `install/`, `web/`) into existing Hestia installation directories (`/usr/local/hestia/`), always use `cp -rfT` (no-target-directory).
   - This prevents GNU `cp` from creating nested subdirectories such as `/usr/local/hestia/bin/bin` when the target directory already exists.
