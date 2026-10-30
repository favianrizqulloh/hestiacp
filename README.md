<h1 align="center"><a href="https://www.hestiacp.com/">Hestia Control Panel</a></h1>

![HestiaCP Web Interface screenshot](https://storage.hestiacp.com/hestiascreen.png)

<h2 align="center">Lightweight and powerful control panel for the modern web</h2>

<p align="center"><strong>Latest stable release:</strong> Version 1.10.5 | <a href="https://github.com/hestiacp/hestiacp/blob/release/CHANGELOG.md">View Changelog</a></p>

<p align="center">
	<a href="https://www.hestiacp.com/">HestiaCP.com</a> |
	<a href="https://docs.hestiacp.com/">Documentation</a> |
	<a href="https://forum.hestiacp.com/">Forum</a>
	<br/><br/>
	<a href="https://github.com/hestiacp/hestiacp/actions/workflows/lint.yml">
		<img src="https://github.com/hestiacp/hestiacp/actions/workflows/lint.yml/badge.svg" alt="Lint Status"/>
	</a>
	<a href="https://gurubase.io/g/hestia">
		<img src="https://img.shields.io/badge/Gurubase-Ask%20Hestia%20Guru-006BFF" alt="Gurubase"/>
	</a>
</p>

## **Welcome!**

Hestia Control Panel is designed to provide administrators an easy to use web and command line interface, enabling them to quickly deploy and manage web domains, mail accounts, DNS zones, and databases from one central dashboard without the hassle of manually deploying and configuring individual components or services.

## Donate

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ST87LQH2CHGLA)<br /><br />
Bitcoin : bc1q48jt5wg5jaj8g9zy7c3j03cv57j2m2u5anlutu<br>
Ethereum : 0xfF3Dd2c889bd0Ff73d8085B84A314FC7c88e5D51<br>
Binance: bnb1l4ywvw5ejfmsgjdcx8jn5lxj7zsun8ktfu7rh8<br>
Smart Chain: 0xfF3Dd2c889bd0Ff73d8085B84A314FC7c88e5D51<br>

Project infrastructure is partly provided by [infrahost](https://infrahost.ch/en/).

## Features and Services

- High-performance standalone NGINX with PHP-FPM
- Native QUIC & HTTP/3 support enabled by default across all web domains
- Full dual-stack IPv4 & IPv6 support with auto-detection and seamless service integration
- Default catch-all server block (`return 444;`) with 100-year self-signed SSL to drop direct IP scanning and unmatched hostnames
- TLS security hardening out-of-the-box (TLSv1.2 & TLSv1.3, modern ECDH curve, AEAD ciphers)
- Multiple PHP versions (5.6 - 8.5, 8.5 as default)
- DNS Server (Bind) with clustering capabilities
- POP/IMAP/SMTP mail services with Anti-Virus, Anti-Spam, and Webmail (ClamAV, SpamAssassin, Sieve, Roundcube)
- MariaDB/MySQL and/or PostgreSQL databases
- Let's Encrypt SSL support with wildcard certificates
- Dual-stack firewall with brute-force attack detection and IP lists (`iptables`, `ip6tables`, fail2ban, and ipset)
- Web-based File Manager (FileGator) fully patched and compatible with Debian 13 (Trixie) and OpenSSH 9.8+ (2048-bit SFTP key support)

## Supported platforms and operating systems

- **Debian:** 13, 12, 11
- **Ubuntu:** 26.04 LTS, 24.04 LTS, 22.04 LTS

**NOTES:**

- Hestia Control Panel does not support 32 bit operating systems!
- Hestia Control Panel in combination with OpenVZ 7 or lower might have issues with DNS and/or firewall. If you use a Virtual Private Server we strongly advice you to use something based on KVM or LXC!

## Installing Hestia Control Panel

- **NOTE:** You must install Hestia Control Panel on top of a fresh operating system installation to ensure proper functionality.

While we have taken every effort to make the installation process and the control panel interface as friendly as possible (even for new users), it is assumed that you will have some prior knowledge and understanding in the basics how to set up a Linux server before continuing.

### Step 1: Log in

To start the installation, you will need to be logged in as **root** or a user with super-user privileges. You can perform the installation either directly from the command line console or remotely via SSH:

```bash
ssh root@your.server
```

### Step 2: Download

Download the installation script for the latest release:

```bash
wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh
```

If the download fails due to an SSL validation error, please be sure you've installed the ca-certificate package on your system - you can do this with the following command:

```bash
apt-get update && apt-get install ca-certificates
```

### Step 3: Run

To begin the installation process, simply run the script and follow the on-screen prompts:

```bash
bash hst-install.sh
```

You will receive a welcome email at the address specified during installation (if applicable) and on-screen instructions after the installation is completed to log in and access your server.

### Custom installation

You may specify a number of various flags during installation to only install the features in which you need. To view a list of available options, run:

```bash
bash hst-install.sh -h
```

Alternatively, You can use <https://hestiacp.com/install.html> which allows you to easily generate the installation command via GUI.

### Key Architectural Notes

- **Pure NGINX Standalone**: Web traffic is served directly through NGINX and PHP-FPM for maximum performance and lower memory footprint. Apache2 is completely eliminated.
- **QUIC & HTTP/3 by Default**: All SSL-enabled web domains come pre-configured out-of-the-box with HTTP/3 / QUIC listeners on UDP port 443 and modern TLS 1.2/1.3 hardening.
- **Dual-Stack IPv4 & IPv6 Setup**: During installation, if a public Global Unicast IPv6 address (`2000::/3`) is detected on the machine, the installer will automatically offer to enable dual-stack support. Enabling it activates IPv6 bindings across Web (NGINX), DNS (Bind9 with automatic `AAAA` records), Mail (Exim4 & Dovecot), and the Dual-Stack Firewall (`iptables` + `ip6tables`).
- **Clean Domain Aliases**: Adding a new web domain will not append a `www.` alias automatically. The `www` alias is purely optional if specified in the Aliases field.
- **Default Catch-All Block (`return 444;`)**: Unmatched direct IP requests or unassigned hostnames are immediately dropped with HTTP status 444 using a dedicated 100-year self-signed certificate, shielding your server from automated scanners and scrapers.
- **Debian 13 (Trixie) Ready**: File Manager (FileGator) and SFTP subsystems are fully optimized for Debian 13 with 2048-bit RSA keys and modern OpenSSH 9.8+ cryptographic algorithms.

## Building and Installing from this Repository (Custom Build)

This repository contains customized architectural enhancements (NGINX-only, QUIC HTTP/3, dual-stack IPv4/IPv6, and Debian 13 optimizations). You can compile and deploy directly from this source code.

### Prerequisites for Building
Ensure basic build tools and git are installed:
```bash
apt-get update && apt-get install -y git build-essential dpkg-dev wget ca-certificates
```

### Method 1: Fresh Installation on a New Server (Recommended)
To deploy this custom version on a fresh server:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/<your-username>/hestiacp.git /tmp/hestiacp
   ```

2. **Compile the Hestia core package from local source:**
   ```bash
   cd /tmp/hestiacp/src
   ./hst_autocompile.sh --hestia --noinstall --keepbuild '~localsrc'
   ```
   *The compiled `.deb` package will be saved in `/tmp/hestiacp-src/deb/`.*

3. **Run the installer with the custom package:**
   ```bash
   cd /tmp/hestiacp/install
   bash hst-install-debian.sh --with-debs /tmp/hestiacp-src/deb
   ```
   *The installer will configure standard system dependencies from official repositories, but will use your custom compiled package for Hestia Control Panel.*

### Method 2: In-Place Upgrade on an Existing HestiaCP Server
To upgrade or test your custom changes on an existing HestiaCP server:

```bash
git clone https://github.com/<your-username>/hestiacp.git /tmp/hestiacp
cd /tmp/hestiacp/src
./hst_autocompile.sh --hestia --install '~localsrc'
```
After upgrading, rebuild configurations to apply template changes:
```bash
v-rebuild-web-domains admin
v-update-firewall
```

### Method 3: Compile All Packages (Including NGINX & PHP Backends)
If you also need to build custom `hestia-nginx`, `hestia-php`, and `hestia-web-terminal` backend engines:
```bash
cd /tmp/hestiacp/src
./hst_autocompile.sh --all --noinstall --keepbuild '~localsrc'
```
Then install using:
```bash
cd /tmp/hestiacp/install
bash hst-install-debian.sh --with-debs /tmp/hestiacp-src/deb
```

## How to upgrade an existing installation

Automatic Updates are enabled by default on new installations of Hestia Control Panel and can be managed from **Server Settings > Updates**. To manually check for and install available updates, use the apt package manager:

```bash
apt-get update
apt-get upgrade
```

## Issues & Support Requests

- If you encounter a general problem while using Hestia Control Panel and need help, please [visit our forum](https://forum.hestiacp.com/) to search for potential solutions or post a new thread where community members can assist.
- Bugs and other reproducible issues should be filed via GitHub by [creating a new issue report](https://github.com/hestiacp/hestiacp/issues) so that our developers can investigate further. Please note that requests for support will be redirected to our forum.

**IMPORTANT: We _cannot_ provide support for requests that do not describe the troubleshooting steps that have already been performed, or for third-party applications not related to Hestia Control Panel (such as WordPress). Please make sure that you include as much information as possible in your forum posts or issue reports!**

## Contributions

If you would like to contribute to the project, please [read our Contribution Guidelines](https://github.com/hestiacp/hestiacp/blob/release/CONTRIBUTING.md) for a brief overview of our development process and standards.

## Copyright

"Hestia Control Panel", "HestiaCP", and the Hestia logo are original copyright of hestiacp.com and the following restrictions apply:

**You are allowed to:**

- use the names "Hestia Control Panel", "HestiaCP", or the Hestia logo in any context directly related to the application or the project. This includes the application itself, local communities and news or blog posts.

**You are not allowed to:**

- sell or redistribute the application under the name "Hestia Control Panel", "HestiaCP", or similar derivatives, including the use of the Hestia logo in any brand or marketing materials related to revenue generating activities,
- use the names "Hestia Control Panel", "HestiaCP", or the Hestia logo in any context that is not related to the project,
- alter the name "Hestia Control Panel", "HestiaCP", or the Hestia logo in any way.

## License

Hestia Control Panel is licensed under [GPL v3](https://github.com/hestiacp/hestiacp/blob/release/LICENSE) license, and is based on the [VestaCP](https://vestacp.com/) project.<br>
