# Upgrading Node.js on Debian 12 (Bookworm - now outdated) using NVM.

Debian 12's official repositories restrict Node.js to older legacy versions (such as v18), which lack modern web application programming interfaces like the Web Crypto API. This documentation covers the exact environment cleanup and installation steps required to successfully deploy the latest Long-Term Support (LTS) release of Node.js using Node Version Manager (NVM).

---

## Prerequisites

* A running instance of **Debian 12**.
* A user account with `sudo` privileges (required for the cleanup phase only).
* `curl` installed on the system (`sudo apt install curl -y`).

---

## Step 1: Purge Conflicting Native Packages

Before installing an isolated version of Node via NVM, it is critical to eliminate all existing system-wide Node.js configurations, documentation packages, and npm components to prevent environmental variable conflicts.

```bash
sudo apt-get purge nodejs nodejs-doc npm -y
```

---

## Step 2: Download and Execute the NVM Installer

Pull the installation script down directly from GitHub. This downloads the codebase, configures your environment, and hooks into your user profile folder (`~/.nvm`).

```bash
curl -o- https://githubusercontent.com | bash
```

---

## Step 3: Refresh Active Shell Runtime

The installer adds paths to your shell file. To load NVM immediately without logging out or closing your current terminal screen, source your configuration file:

```bash
source ~/.bashrc
```

---

## Step 4: Deploy and Activate Node.js LTS

Instruct NVM to query the remote server for the newest Long-Term Support (LTS) builds, fetch the binaries, and set them as your system default workspace.

```bash
nvm install --lts
nvm use --lts
```

---

## Step 5: Verify the Target Version

Confirm that the active binary matches modern runtimes required by advanced frameworks and language server integrations (e.g., `coc-rust-analyzer`).

```bash
node -v
```

### Expected Output

```text
v24.17.0
```

---

## Troubleshooting & Maintenance

* **Command Not Found**: If typing `nvm` fails after Step 3, make sure your shell profile is actively evaluating the initialisation block. If you use Zsh instead of Bash, substitute `source ~/.bashrc` with `source ~/.zshrc`.
* **Switching Versions**: If a project ever requires a specific version down the road, you can seamlessly pull it using `nvm install <version_number>` and jump between versions using `nvm use <version_number>`.
