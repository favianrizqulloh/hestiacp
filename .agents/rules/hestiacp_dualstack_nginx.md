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

1. **Dual-Stack Default Server Separation**:
   - Never place wildcard `[::]:80 default_server` or `[::]:443 default_server ssl` inside per-IP configuration templates (such as `unassigned.inc` or `/etc/nginx/conf.d/$ip.conf`).
   - All IPv6 wildcard catch-all listeners must reside in a dedicated single file (`/etc/nginx/conf.d/00-default-ip6.conf`).
   - Per-IP files must only bind to their specific IPv4 socket (`directIP:80 default_server`, `directIP:443 default_server ssl`).

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

6. **Installer Repository Directory Sync Invariant**:
   - When copying repository directories (`bin/`, `func/`, `install/`, `web/`) into existing Hestia installation directories (`/usr/local/hestia/`), always use `cp -rfT` (no-target-directory).
   - This prevents GNU `cp` from creating nested subdirectories such as `/usr/local/hestia/bin/bin` when the target directory already exists.
