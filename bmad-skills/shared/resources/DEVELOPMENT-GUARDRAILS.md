# Development Guardrails for Claude Code

**Purpose:** This document establishes mandatory development practices to minimize AI hallucination risks and ensure production-quality code. Claude Code MUST reference and follow these guidelines for ALL code generation.

**Last Updated:** 2026-01-25
**Applies To:** ICE Core, HiveMind, all Neural-ICE projects

---

## Table of Contents

1. [General Principles](#general-principles)
2. [Rust Guidelines](#rust-guidelines)
3. [Ansible Guidelines](#ansible-guidelines)
4. [Tauri Guidelines](#tauri-guidelines)
5. [Bash Guidelines](#bash-guidelines)
6. [Docker Guidelines](#docker-guidelines)
7. [**UI/UX Design System Guidelines**](#uiux-design-system-guidelines) ← NEW
8. [Vue.js/TypeScript Guidelines](#vuejstypescript-guidelines)
9. [YAML Guidelines](#yaml-guidelines)
10. [Git & Commit Guidelines](#git--commit-guidelines)
11. [Documentation Requirements](#documentation-requirements)
12. [Pre-Commit Checklist](#pre-commit-checklist)
13. [Packer Guidelines](#packer-guidelines)
14. [systemd Guidelines](#systemd-guidelines)
15. [GitHub Actions Guidelines](#github-actions-guidelines)
16. [Keygen.sh Guidelines](#keygensh-guidelines)
17. [Mender OTA Guidelines](#mender-ota-guidelines)

---

## General Principles

### MUST DO Before Writing Code

1. **Read existing code first** - Never propose changes without understanding the current implementation
2. **Check official documentation** - Verify API signatures, function parameters, and return types
3. **Follow existing patterns** - Match the style and conventions already in the codebase
4. **Test locally** - All code must be testable; provide test commands

### MUST AVOID

1. **Never hallucinate APIs** - If unsure about an API, ask or check docs first
2. **Never assume library versions** - Check Cargo.toml, package.json, requirements.txt
3. **Never skip error handling** - All errors must be handled explicitly
4. **Never hardcode secrets** - Use environment variables or config files
5. **Never ignore existing ADRs** - Architecture decisions are binding

### When Uncertain

```
STOP and ASK:
- "I need to verify the API for X before proceeding"
- "Let me check the current implementation of Y"
- "I'm not certain about Z - should I research this first?"
```

---

## Rust Guidelines

### Error Handling Strategy (2025)

| Crate | Use Case | When |
|-------|----------|------|
| **thiserror** | Custom error types | Libraries, APIs with matchable errors |
| **anyhow** | Flexible error wrapping | Applications, CLI tools, rapid prototyping |
| **snafu** | Context-driven errors | Large projects, complex error chains |

```rust
// LIBRARY CODE: Use thiserror for matchable errors
// Cargo.toml: thiserror = "2.0"
#[derive(Debug, thiserror::Error)]
pub enum LicenseError {
    #[error("Invalid license key format")]
    InvalidFormat,
    #[error("License expired on {0}")]
    Expired(chrono::DateTime<chrono::Utc>),
    #[error("Machine not authorized: {fingerprint}")]
    MachineNotAuthorized { fingerprint: String },
    #[error("Network error: {0}")]
    Network(#[from] reqwest::Error),
}

// APPLICATION CODE: Use anyhow for convenience
// Cargo.toml: anyhow = "2.0"
use anyhow::{Context, Result};

async fn activate_device() -> Result<()> {
    let license = validate_license(&key)
        .await
        .context("License validation failed")?;

    register_machine(&license, &fingerprint)
        .await
        .context("Machine registration failed")?;

    Ok(())
}
```

### Naming Conventions

```rust
// DO: Content-driven, concise names
let user_count = users.len();
let is_valid = validate(&input);

// DON'T: Type information in names
let user_count_usize = users.len();  // BAD
let is_valid_bool = validate(&input); // BAD
```

### Import Discipline

```rust
// DO: Explicit imports, grouped in order
use std::collections::HashMap;
use std::sync::Arc;

use anyhow::{Context, Result};
use tokio::sync::Mutex;

use crate::config::Settings;
use self::helpers::parse_input;

// DON'T: Wildcard imports in production code
use std::*;           // BAD
use crate::models::*; // BAD (except in tests)
```

### Error Handling

```rust
// DO: Use Result with context
fn load_config(path: &Path) -> Result<Config> {
    let content = std::fs::read_to_string(path)
        .context("Failed to read config file")?;

    let config: Config = toml::from_str(&content)
        .context("Failed to parse config TOML")?;

    Ok(config)
}

// DON'T: Unwrap in production code
let config = std::fs::read_to_string(path).unwrap(); // BAD
```

### Pattern Matching

```rust
// DO: Exhaustive matching with meaningful names
match result {
    Ok(value) => process(value),
    Err(error) => {
        tracing::error!(?error, "Operation failed");
        return Err(error.into());
    }
}

// DO: Destructure for clarity
let (host, port) = address;

// DON'T: Tuple indexing
let host = address.0; // BAD
let port = address.1; // BAD
```

### Struct Construction

```rust
// DO: Match field declaration order, use shorthand
let config = Config {
    host,
    port,
    timeout: Duration::from_secs(30),
};

// DON'T: Random order, repeated names
let config = Config {
    timeout: timeout,  // BAD: use shorthand
    host: host,
    port: port,
};
```

### Async/Await

```rust
// DO: Handle async errors properly
async fn fetch_data(url: &str) -> Result<Data> {
    let response = client.get(url)
        .send()
        .await
        .context("HTTP request failed")?;

    let data = response.json()
        .await
        .context("Failed to parse JSON")?;

    Ok(data)
}
```

### Async Runtime (2025)

```rust
// Tokio is the canonical async runtime for Rust (async-std discontinued)
// Cargo.toml:
// tokio = { version = "1.43", features = ["full"] }

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // Application entry point with error handling
    if let Err(e) = run().await {
        eprintln!("Error: {e:?}");
        std::process::exit(1);
    }
    Ok(())
}

// For libraries: don't choose runtime, be runtime-agnostic
// Use async-trait for async trait methods
#[async_trait::async_trait]
pub trait LicenseValidator {
    async fn validate(&self, key: &str) -> Result<License, LicenseError>;
}
```

### Recommended Dependencies (2025)

```toml
# Cargo.toml - Common dependencies for ICE Core
[dependencies]
# Error handling
thiserror = "2.0"      # For library error types
anyhow = "2.0"         # For application error handling

# Async runtime
tokio = { version = "1.43", features = ["full"] }
async-trait = "0.1"

# Serialization
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"

# HTTP client
reqwest = { version = "0.12", features = ["json", "rustls-tls"] }

# Logging/tracing
tracing = "0.1"
tracing-subscriber = { version = "0.3", features = ["env-filter"] }

# CLI (if needed)
clap = { version = "4.5", features = ["derive"] }
```

### Required Checks Before Commit

```bash
# Format check
cargo fmt --check

# Lint with warnings as errors (CI uses this!)
RUSTFLAGS="-Dwarnings" cargo clippy --all-targets

# Run tests
cargo test

# Security audit
cargo audit
```

---

## Ansible Guidelines

### Directory Structure (ICE Core)

```
roles/
└── neuralice/
    ├── defaults/
    │   └── main/
    │       ├── main.yml        # Task toggles
    │       ├── docker.yml      # Docker defaults
    │       └── ...
    ├── vars/
    │   └── main.yml            # Static values, not meant to be overridden
    ├── tasks/
    │   ├── main.yml            # Task dispatcher
    │   ├── 03-packages.yml     # Numbered for execution order
    │   ├── 04-system.yml
    │   └── lib/                # Reusable task includes
    ├── handlers/
    │   └── main.yml
    ├── templates/
    │   └── *.j2
    ├── files/
    │   └── ...
    └── meta/
        ├── main.yml            # Role metadata
        └── argument_specs.yml  # Parameter validation (Ansible 2.11+)
```

### Variable Naming (Red Hat CoP)

```yaml
# DO: Prefix ALL variables with role name to prevent collisions
neuralice_docker_data_root: "/data/docker"
neuralice_manage_docker: true

# DO: Use double underscore for internal variables (not for external use)
__neuralice_temp_dir: "/tmp/neuralice-build"
__neuralice_calculated_value: "{{ neuralice_base | hash('sha256') }}"

# DON'T: Generic names that could conflict
docker_root: "/data/docker"  # BAD: no prefix
manage_docker: true          # BAD: too generic
```

### Defaults vs Vars

```yaml
# defaults/main.yml - Every external argument must have a default
# These CAN be overridden by users
neuralice_docker_data_root: "/data/docker"
neuralice_docker_log_driver: "json-file"

# vars/main.yml - Static values, "magic values", NOT meant to be overridden
# High precedence - hard to override
__neuralice_supported_distributions:
  - Ubuntu
  - Debian
```

### Task Design

```yaml
# DO: Always name tasks, explicit state, FQCN
- name: task {{ task }} | Install required packages
  ansible.builtin.apt:
    name: "{{ item }}"
    state: present
    update_cache: true
  loop: "{{ neuralice_packages }}"
  become: true

# DON'T: Missing name, implicit state, short module name
- apt:
    name: nginx
  # BAD: no name, no state, no become, no FQCN
```

### Command Tasks & Idempotency

```yaml
# DO: Always use changed_when for command/shell tasks
- name: task {{ task }} | Check if reboot required
  ansible.builtin.command: needs-restarting -r
  register: __neuralice_reboot_check
  changed_when: __neuralice_reboot_check.rc == 1
  failed_when: __neuralice_reboot_check.rc > 1

# DO: Use creates/removes for idempotency
- name: task {{ task }} | Initialize database
  ansible.builtin.command: /opt/app/init-db.sh
  args:
    creates: /data/app/.initialized

# DON'T: Bare command without change detection
- name: Run script
  ansible.builtin.shell: ./script.sh  # BAD: always reports changed
```

### Check Mode Support

```yaml
# DO: Ensure tasks work with --check (dry-run)
- name: task {{ task }} | Get current version
  ansible.builtin.command: app --version
  register: __neuralice_app_version
  changed_when: false
  check_mode: false  # Run even in check mode to get version

# DO: Handle undefined variables from skipped tasks
- name: task {{ task }} | Configure app
  ansible.builtin.template:
    src: app.conf.j2
    dest: /etc/app/app.conf
  when: __neuralice_app_version is defined
```

### Debug Tasks

```yaml
# DO: Always set verbosity on debug tasks
- name: task {{ task }} | Debug configuration
  ansible.builtin.debug:
    var: neuralice_config
    verbosity: 2  # Only shown with -vv or higher

# DON'T: Debug without verbosity (clutters normal output)
- name: Show config
  ansible.builtin.debug:
    var: config  # BAD: shown on every run
```

### Handlers

```yaml
# DO: Named handlers, FQCN, explicit state
handlers:
  - name: Restart docker
    ansible.builtin.systemd:
      name: docker
      state: restarted
      daemon_reload: true
    become: true

  - name: Reload systemd
    ansible.builtin.systemd:
      daemon_reload: true
    become: true
    listen: daemon_reload  # Multiple tasks can notify this
```

### Conditionals & Blocks

```yaml
# DO: Use blocks for related tasks with shared attributes
- name: Docker configuration
  when: neuralice_manage_docker | bool
  become: true
  block:
    - name: task {{ task }} | Create Docker config directory
      ansible.builtin.file:
        path: /etc/docker
        state: directory
        mode: '0755'

    - name: task {{ task }} | Deploy Docker daemon config
      ansible.builtin.template:
        src: daemon.json.j2
        dest: /etc/docker/daemon.json
        mode: '0644'
        backup: true  # Always backup config files
      notify: Restart docker

  rescue:
    - name: task {{ task }} | Handle Docker config failure
      ansible.builtin.debug:
        msg: "Docker configuration failed, check logs"
        verbosity: 0
```

### Facts Usage (Bracket Notation)

```yaml
# DO: Use bracket notation for facts (more explicit, works with variables)
- name: task {{ task }} | Install OS-specific packages
  ansible.builtin.include_vars:
    file: "{{ ansible_facts['distribution'] }}.yml"
  when: ansible_facts['os_family'] == 'Debian'

# DON'T: Use ansible_* variables directly
- name: Install packages
  when: ansible_os_family == 'Debian'  # BAD: implicit fact access
```

### Platform-Specific Variables

```yaml
# DO: Load variables per distribution from vars/ directory
- name: task {{ task }} | Load OS-specific variables
  ansible.builtin.include_vars: "{{ item }}"
  loop: "{{ lookup('first_found', params, errors='ignore') }}"
  vars:
    params:
      files:
        - "{{ ansible_facts['distribution'] }}_{{ ansible_facts['distribution_version'] }}.yml"
        - "{{ ansible_facts['distribution'] }}_{{ ansible_facts['distribution_major_version'] }}.yml"
        - "{{ ansible_facts['distribution'] }}.yml"
        - "{{ ansible_facts['os_family'] }}.yml"
        - default.yml
      paths:
        - "{{ role_path }}/vars"
```

### Templates

```jinja2
{# DO: Add ansible_managed comment, use backup: true #}
{{ ansible_managed | comment }}
# Docker daemon configuration for Neural-ICE

{
  "data-root": "{{ neuralice_docker_data_root }}",
  "default-runtime": "{{ neuralice_docker_default_runtime }}",
{% if neuralice_docker_insecure_registries is defined %}
  "insecure-registries": {{ neuralice_docker_insecure_registries | to_json }},
{% endif %}
  "log-driver": "{{ neuralice_docker_log_driver }}"
}
```

### Tags Strategy

```yaml
# DO: Prefix tags with role name or use meaningful purpose
- name: task {{ task }} | Install Docker
  ansible.builtin.apt:
    name: docker-ce
    state: present
  tags:
    - neuralice_docker      # Role-specific tag
    - packages              # Purpose tag
    - never                 # Special: skip unless explicitly called

# Document all tags in role README
# neuralice_docker - Docker installation and configuration
# neuralice_nvidia - NVIDIA driver and container toolkit
# packages - All package installation tasks
# never - Tasks that require explicit invocation
```

### Secrets Management (Ansible Vault)

```yaml
# DO: Encrypt sensitive data with Ansible Vault
# Create encrypted file: ansible-vault create secrets.yml
# Edit encrypted file: ansible-vault edit secrets.yml

# In playbook, reference encrypted variables
- name: task {{ task }} | Configure API credentials
  ansible.builtin.template:
    src: api-config.j2
    dest: /etc/app/api.conf
    mode: '0600'  # Restrictive permissions for secrets
  vars:
    api_key: "{{ vault_api_key }}"  # From encrypted vars

# DON'T: Store secrets in plain text
api_key: "sk-live-xxxxx"  # BAD: plain text secret
```

### Performance Optimization

```yaml
# ansible.cfg - Performance settings
[defaults]
forks = 20                      # Parallel host execution
gathering = smart               # Cache facts
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 86400

[ssh_connection]
pipelining = true               # Reduces SSH round-trips
control_path = /tmp/ansible-%%h-%%p-%%r

# In playbooks - Limit fact gathering
- hosts: all
  gather_facts: false           # Skip if not needed
  tasks:
    - name: Gather only network facts
      ansible.builtin.setup:
        gather_subset:
          - network
      when: ansible_facts['default_ipv4'] is not defined
```

### Argument Validation (Ansible 2.11+)

```yaml
# meta/argument_specs.yml - Validate role parameters
argument_specs:
  main:
    short_description: Configure Neural-ICE system
    options:
      neuralice_manage_docker:
        description: Enable Docker management
        type: bool
        default: false
      neuralice_docker_data_root:
        description: Docker data directory
        type: path
        default: /data/docker
      neuralice_packages:
        description: List of packages to install
        type: list
        elements: str
        required: true
```

### Task Naming Convention (Neural-ICE)

This project uses a specific naming pattern:

```yaml
# Project convention: task {{ task }} | Description
- name: task {{ task }} | Install packages
  ansible.builtin.apt:
    name: "{{ neuralice_packages }}"
    state: present
```

The `{{ task }}` variable contains the task file number (e.g., "03-packages"):
- Automatic task numbering in output
- Easy identification of source file
- Consistent naming across all tasks

**Note:** Intentionally skipped in `.ansible-lint`:

```yaml
# .ansible-lint
skip_list:
  - name[template]  # Project uses "task {{ task }} | Description"
  - name[casing]    # Task names start with lowercase "task" by design
```

### Testing with Molecule

```bash
# Install Molecule
pip install molecule molecule-docker ansible-lint

# Initialize role testing
cd roles/neuralice
molecule init scenario -r neuralice -d docker

# Run tests
molecule test           # Full test sequence
molecule converge       # Just run playbook
molecule verify         # Run verification tests
molecule lint           # Run linters only
```

### Required Checks

```bash
# Syntax and lint (MUST pass before commit)
ansible-lint roles/
ansible-playbook --syntax-check build.yml

# Dry-run validation
ansible-playbook build.yml --check --diff

# List tasks without executing
ansible-playbook build.yml --list-tasks
ansible-playbook build.yml --list-hosts
```

### Zen of Ansible (Red Hat CoP)

> - Clear is better than cluttered
> - Concise is better than verbose
> - Simple is better than complex
> - Readability counts
> - Declarative is better than imperative (usually)
> - Focus avoids complexity; complexity kills productivity
> - User experience matters more than ideological purity
> - Automation is a journey, not a destination

---

## Tauri Guidelines

### Project Structure (Neural-ICE)

```
neuralice-app/
├── src/                      # Frontend (Vue.js/TypeScript)
│   ├── components/
│   ├── views/
│   └── main.ts
├── src-tauri/                # Backend (Rust)
│   ├── src/
│   │   ├── main.rs           # Entry point
│   │   ├── lib.rs            # Command implementations
│   │   └── commands/         # Modular command handlers
│   ├── capabilities/         # Permission definitions
│   │   └── default.json
│   ├── Cargo.toml
│   ├── tauri.conf.json       # App configuration
│   └── build.rs              # Build-time checks
└── package.json
```

### Trust Boundaries (Critical)

```
┌─────────────────────────────────────────────────────────────┐
│                    WEBVIEW (Untrusted)                      │
│  - Frontend code (Vue.js, TypeScript)                       │
│  - Can be modified by users (DevTools)                      │
│  - NO direct system access                                  │
├─────────────────────────────────────────────────────────────┤
│                    IPC LAYER (Boundary)                     │
│  - Capabilities define allowed commands                     │
│  - Permissions scope command access                         │
│  - All data must be validated                               │
├─────────────────────────────────────────────────────────────┤
│                    RUST CORE (Trusted)                      │
│  - Full system access                                       │
│  - Business logic lives here                                │
│  - Security enforcement                                     │
└─────────────────────────────────────────────────────────────┘
```

**Key Principle:** "The frontend can be modified by users" - ALL security must be enforced in Rust.

### Command Design

```rust
// DO: Validate all inputs, return Result, use serde
#[tauri::command]
async fn activate_license(
    key: String,
    app_handle: tauri::AppHandle,
) -> Result<LicenseInfo, String> {
    // Validate input FIRST
    if key.len() != 32 || !key.chars().all(|c| c.is_ascii_alphanumeric()) {
        return Err("Invalid license key format".to_string());
    }

    // Business logic in Rust
    let license = licensing::activate(&key)
        .await
        .map_err(|e| e.to_string())?;

    Ok(license)
}

// DON'T: Trust frontend input without validation
#[tauri::command]
fn execute_command(cmd: String) -> String {
    std::process::Command::new("sh")
        .arg("-c")
        .arg(&cmd)  // BAD: Command injection vulnerability!
        .output()
        .unwrap()
}
```

### Capabilities (Principle of Least Privilege)

```json
// src-tauri/capabilities/default.json
{
  "$schema": "../gen/schemas/desktop-schema.json",
  "identifier": "default",
  "description": "Default capabilities for main window",
  "windows": ["main"],
  "permissions": [
    "core:default",
    "shell:allow-open",
    {
      "identifier": "fs:allow-read",
      "allow": [{ "path": "$APPDATA/**" }]
    }
  ]
}
```

```json
// src-tauri/capabilities/admin.json - Higher privilege window
{
  "identifier": "admin",
  "description": "Admin panel with elevated permissions",
  "windows": ["admin"],
  "permissions": [
    "core:default",
    "fs:default",
    "process:default"
  ]
}
```

### IPC Security Patterns

```typescript
// Frontend: src/api/license.ts
import { invoke } from '@tauri-apps/api/core';

// DO: Type-safe invoke with error handling
interface LicenseInfo {
  key: string;
  valid_until: string;
  features: string[];
}

export async function activateLicense(key: string): Promise<LicenseInfo> {
  // Basic validation in frontend (defense in depth)
  if (!key || key.length !== 32) {
    throw new Error('Invalid key format');
  }

  // Invoke Rust command
  return await invoke<LicenseInfo>('activate_license', { key });
}

// DON'T: Pass unsanitized user input
async function dangerousInvoke(userInput: string) {
  return await invoke('execute', { cmd: userInput });  // BAD!
}
```

### Content Security Policy (CSP)

```json
// tauri.conf.json
{
  "app": {
    "security": {
      "csp": "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'"
    }
  }
}
```

**CSP Rules:**
- `default-src 'self'` - Only load resources from app
- Never use `'unsafe-eval'` - Prevents XSS
- Avoid loading remote scripts (CDNs)
- Use `style-src 'unsafe-inline'` only if necessary

### Isolation Pattern (Advanced Security)

```json
// tauri.conf.json - Enable isolation for high-security apps
{
  "app": {
    "security": {
      "pattern": {
        "use": "isolation",
        "options": {
          "dir": "./isolation"
        }
      }
    }
  }
}
```

Isolation intercepts all IPC messages for validation before reaching Rust core.

### Error Handling

```rust
// DO: Custom error types with serde
#[derive(Debug, thiserror::Error, serde::Serialize)]
pub enum AppError {
    #[error("License validation failed: {0}")]
    LicenseError(String),
    #[error("Network error: {0}")]
    NetworkError(String),
    #[error("Internal error")]  // Don't expose internal details
    InternalError,
}

#[tauri::command]
async fn activate(key: String) -> Result<License, AppError> {
    // Errors automatically serialized to frontend
    let license = validate_license(&key)
        .await
        .map_err(|e| AppError::LicenseError(e.to_string()))?;
    Ok(license)
}
```

### Build Configuration

```toml
# src-tauri/Cargo.toml
[profile.release]
panic = "abort"       # Smaller binary, no unwinding
lto = true            # Link-time optimization
opt-level = "s"       # Optimize for size
strip = true          # Strip symbols
codegen-units = 1     # Better optimization
```

### Security Checklist

- [ ] All commands validate inputs in Rust
- [ ] Capabilities use least privilege
- [ ] CSP configured (no unsafe-eval)
- [ ] No secrets in frontend code
- [ ] Error messages don't leak internals
- [ ] Window labels used for security boundaries
- [ ] File access scoped to specific paths
- [ ] No shell command execution with user input

---

## Bash Guidelines

### Script Header

```bash
#!/usr/bin/env bash
#
# Script: build.sh
# Description: Build Neural-ICE image
# Usage: ./build.sh <version> [--skip-packer] [--clean]
#

set -o errexit   # Exit on error
set -o pipefail  # Catch errors in pipes
set -o nounset   # Error on unset variables

# Debug mode (optional)
[[ "${DEBUG:-false}" == "true" ]] && set -o xtrace
```

### Variable Usage

```bash
# DO: Quote variables, use braces
readonly VERSION="${1:-}"
readonly OUTPUT_DIR="${OUTPUT_DIR:-./output}"

echo "Building version: ${VERSION}"
mkdir -p "${OUTPUT_DIR}"

# DON'T: Unquoted, no braces
VERSION=$1        # BAD: no quotes, no default
echo "Building $VERSION"  # BAD: no braces
```

### Function Design

```bash
# DO: Use local variables, descriptive names
_build_image() {
    local version="${1}"
    local output_dir="${2}"

    echo "Building image v${version}..."

    packer build \
        -var "version=${version}" \
        -var "output_dir=${output_dir}" \
        ubuntu-cloud-spark.pkr.hcl
}

# DON'T: Global variables, positional only
build_image() {
    echo "Building $1"  # BAD: no local, unclear
}
```

### Error Handling

```bash
# DO: Check command success, provide context
if ! command -v packer &> /dev/null; then
    echo "ERROR: packer is not installed" >&2
    exit 1
fi

# DO: Trap for cleanup
cleanup() {
    echo "Cleaning up temporary files..."
    rm -rf "${TEMP_DIR:-}"
}
trap cleanup EXIT

# DON'T: Ignore errors
packer build config.pkr.hcl  # No error check
```

### Conditionals

```bash
# DO: Use double brackets
if [[ -z "${VERSION}" ]]; then
    echo "ERROR: Version required" >&2
    echo "Usage: $0 <version>" >&2
    exit 1
fi

if [[ -f "${CONFIG_FILE}" && -r "${CONFIG_FILE}" ]]; then
    source "${CONFIG_FILE}"
fi

# DON'T: Single brackets
if [ -z "$VERSION" ]; then  # BAD: single brackets
```

### Command Substitution

```bash
# DO: Use $() syntax
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TIMESTAMP="$(date -Iseconds)"

# DON'T: Backticks
SCRIPT_DIR=`dirname $0`  # BAD: backticks, unquoted
```

### Naming Conventions (Google Style)

```bash
# Functions: lowercase with underscores
my_function() { ... }

# Variables: lowercase with underscores
local my_variable="value"

# Constants/Environment: UPPERCASE
readonly MAX_RETRIES=3
export NEURALICE_VERSION="0.13.16"

# Source files: lowercase, optional underscores
# Good: build_image.sh, make_installer
# Bad: build-image.sh, makeInstaller.sh
```

### Features to AVOID

```bash
# DON'T: Use eval (code injection risk)
eval "$user_input"  # DANGEROUS!

# DON'T: Use aliases (use functions instead)
alias ll='ls -la'  # BAD: use function

# DO: Use function instead
ll() { ls -la "$@"; }

# DON'T: Pipe to while (loses variable scope)
cat file | while read line; do
    count=$((count + 1))  # BAD: count lost after loop
done

# DO: Use process substitution
while read -r line; do
    count=$((count + 1))
done < <(cat file)
```

### Arrays (Safer Than Strings)

```bash
# DO: Use arrays for command arguments
declare -a cmd_args=(
    "--version=${VERSION}"
    "--output=${OUTPUT_DIR}"
    "--config=${CONFIG_FILE}"
)
packer build "${cmd_args[@]}"

# DON'T: Use strings with spaces
cmd_args="--version=${VERSION} --output=${OUTPUT_DIR}"
packer build $cmd_args  # BAD: word splitting issues
```

### Security Considerations

```bash
# DO: Validate input patterns
if [[ ! "${VERSION}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERROR: Invalid version format" >&2
    exit 1
fi

# DO: Use restricted permissions for sensitive scripts
chmod 700 scripts/deploy.sh

# DON'T: Use SUID/SGID on shell scripts (forbidden)
chmod u+s script.sh  # NEVER DO THIS

# DO: Quote to prevent globbing
rm -f "${TEMP_DIR:?}"/*  # :? prevents empty variable disaster
```

### Required Checks

```bash
# MUST pass before commit
shellcheck script.sh

# Optional: Format check
shfmt -d script.sh
```

### Script Size Guideline (Google)

> "If you are writing a script that is more than 100 lines long, or that uses non-straightforward control flow logic, you should rewrite it in a more structured language now."

---

## Docker Guidelines

### Dockerfile Best Practices

```dockerfile
# DO: Multi-stage builds, specific versions
FROM rust:1.75-bookworm AS builder
WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src
RUN cargo build --release

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/app /usr/local/bin/
USER 1000:1000
ENTRYPOINT ["/usr/local/bin/app"]

# DON'T: Latest tags, running as root
FROM rust:latest  # BAD: unpinned
RUN apt-get install -y stuff  # BAD: no cleanup
# Missing USER directive - runs as root
```

### Docker Compose

```yaml
# DO: Explicit versions, health checks
services:
  ollama:
    image: ollama/ollama:0.5.4
    container_name: ollama
    restart: unless-stopped
    volumes:
      - /data/ollama:/root/.ollama
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:11434/"]
      interval: 30s
      timeout: 10s
      retries: 3

# DON'T: Missing health checks, no resource limits
services:
  ollama:
    image: ollama/ollama  # BAD: no tag
    volumes:
      - ollama_data:/root/.ollama  # OK but prefer bind mount for /data
```

### Non-Root Containers (2025 Security Standard)

```dockerfile
# DO: Run as non-root with UID >= 10000 (avoids host UID conflicts)
FROM debian:bookworm-slim
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /sbin/nologin appuser
USER 10001:10001

# DO: Verify in compose
user: "10001:10001"

# Verify with:
docker exec container_name id
# Should show: uid=10001(appuser) gid=10001(appgroup)
```

> "58% of images run as root (UID 0). UIDs below 10,000 risk overlap with host system users."

### Security Hardening

```yaml
# docker-compose.yml - Security-hardened service
services:
  app:
    image: myapp:1.0.0
    user: "10001:10001"
    read_only: true                    # Read-only root filesystem
    security_opt:
      - no-new-privileges:true         # Prevent privilege escalation
    cap_drop:
      - ALL                            # Drop all capabilities
    cap_add:
      - NET_BIND_SERVICE               # Only add what's needed
    tmpfs:
      - /tmp:noexec,nosuid,size=100m   # Temp space without exec
```

### Secrets Management

```yaml
# DO: Use Docker secrets (not environment variables for sensitive data)
services:
  app:
    secrets:
      - db_password
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt

# DON'T: Expose secrets in environment or build args
services:
  app:
    environment:
      - DB_PASSWORD=mysecret123  # BAD: visible in inspect
    build:
      args:
        - API_KEY=sk-xxx         # BAD: visible in image history
```

### Image Scanning

```bash
# Scan for vulnerabilities before deployment
docker scout cves myimage:latest
trivy image myimage:latest

# In CI/CD pipeline
- name: Scan image
  run: |
    trivy image --exit-code 1 --severity HIGH,CRITICAL myimage:latest
```

### Required Checks

```bash
# Lint Dockerfile
hadolint Dockerfile

# Scan for secrets in image
trufflehog docker --image myimage:latest
```

---

## UI/UX Design System Guidelines

### Design System Architecture

A design system comprises three interconnected layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    GOVERNANCE LAYER                          │
│  • Defined roles (Lead, Designers, Developers, A11y)        │
│  • Versioning and change management                          │
│  • Contribution guidelines                                   │
├─────────────────────────────────────────────────────────────┤
│                    TECHNICAL LAYER                           │
│  • Design tokens (CSS variables)                             │
│  • Vue/React components (code)                               │
│  • Figma components (design)                                 │
│  • Storybook documentation                                   │
├─────────────────────────────────────────────────────────────┤
│                    VISUAL LANGUAGE LAYER                     │
│  • Grid system & spacing logic                               │
│  • Color palette (brand, UI, semantic, neutral)              │
│  • Typography system (hierarchy, weights)                    │
│  • Iconography guidelines                                    │
└─────────────────────────────────────────────────────────────┘
```

> "Documentation must not be a static PDF but up-to-date, accessible, version-controlled, and maintainable across teams." — Brightside Studio

### Core Design Principles

| Principle | Description | Implementation |
|-----------|-------------|----------------|
| **Visual Consistency** | Uniform colors, typography, spacing | Use design tokens exclusively |
| **Functional Consistency** | Predictable interactions, standardized controls | Component library with documented behavior |
| **Internal Consistency** | Coherent appearance across all app screens | Single source of truth for styles |
| **Hierarchy** | Clear visual priority guiding user attention | Size, weight, color, spacing |

> "Design consistency is what ties UI elements together with distinguishable and predictable actions." — UXPin

### Design Tokens (Single Source of Truth)

```css
/* DO: Use CSS custom properties (design tokens) */
:root {
  /* Semantic naming - purpose over value */
  --color-primary-500: #0066CC;      /* Neural Blue */
  --color-ice-500: #00C8FF;          /* Neural ICE signature */
  --color-neural-gold: #FFD700;      /* Premium accent */

  /* Spacing scale (4px base grid) */
  --space-1: 0.25rem;   /* 4px */
  --space-2: 0.5rem;    /* 8px */
  --space-4: 1rem;      /* 16px */

  /* Typography scale (Minor Third 1.2) */
  --text-sm: 0.833rem;  /* 13.3px */
  --text-base: 1rem;    /* 16px */
  --text-lg: 1.2rem;    /* 19.2px */
}

/* DON'T: Hardcode values */
.button {
  background: #0066CC;  /* BAD: not using token */
  padding: 8px 16px;    /* BAD: magic numbers */
}

/* DO: Reference tokens */
.button {
  background: var(--color-primary-500);
  padding: var(--space-2) var(--space-4);
}
```

### Icon System (SOTA 2024-2025)

**Icon Types:**

| Type | Purpose | Behavior |
|------|---------|----------|
| **Actionable** | Trigger actions, navigate, open/close | Must have touch target, hover state |
| **Informational** | Describe content, add emphasis | Decorative, use `aria-hidden="true"` |

**Technical Requirements:**

| Property | Requirement | Rationale |
|----------|-------------|-----------|
| Format | SVG only | Scalable, CSS-stylable, accessible |
| ViewBox | 24×24 | Industry standard, divisible by 4 and 8 |
| Style | Stroke-based | Modern, scales better than filled |
| Stroke width | 1.5px consistent | Visual harmony across set |
| Stroke caps | `round` | Modern, friendly aesthetic |
| Stroke joins | `round` | Consistent with caps |
| Color | `currentColor` | Inherits from parent, themeable |
| Padding | ~2px internal | Consistent visual weight |

> "All strokes within a set must match in weight. Space between strokes should reflect stroke weight proportionally." — DesignSystems.com

**Minimum Legibility:**
- Avoid stroked icons smaller than **10px** with 1-2px strokes—they become illegible
- For very small sizes, consider filled variants

```typescript
// DO: Consistent icon component (Neural ICE standard)
<svg
  width="20"
  height="20"
  viewBox="0 0 24 24"
  fill="none"
  stroke="currentColor"
  stroke-width="1.5"
  stroke-linecap="round"
  stroke-linejoin="round"
  aria-hidden="true"
>
  <path d="M21 21l-5.197-5.197..." />
</svg>

// DON'T: Emojis as icons
<span>🔍</span>  // BAD: inconsistent, unprofessional, inaccessible

// DON'T: Mixed icon styles in same context
// Using both filled and outlined icons together

// DON'T: Inconsistent stroke widths
<svg stroke-width="2">...</svg>  // In same context as
<svg stroke-width="1">...</svg>  // BAD: visual discord
```

**Color Rules:**

| Context | Colors | Rule |
|---------|--------|------|
| Product icons (UI) | 1 (monochrome) | Use `currentColor` only |
| Marketing icons | 2 maximum | If essential to brand |
| 3+ colors | — | "That's an illustration, not an icon" |

**Icon Sizing (4px/8px Grid):**

All sizes must be divisible by 4 or 8 for pixel-perfect alignment:

| Size | Use Case | With Text |
|------|----------|-----------|
| 16px | Inline, badges, dense UI | 14px caption text |
| 20px | Default buttons, inputs | 16px body text |
| 24px | Headers, navigation | 18-20px text |
| 32px | Feature cards, empty states | 24px headings |
| 48px | Hero sections | 32px+ headings |

> "The fewer sizes, the better. If everything works at 20px, that's ideal." — Koala UI

**Grid Alignment:**

```
┌──────────────────────────────┐
│     2px padding             │
│  ┌────────────────────────┐ │
│  │                        │ │
│  │   Icon content area    │ │  <- Align to pixel grid
│  │   (optical center)     │ │
│  │                        │ │
│  └────────────────────────┘ │
│     2px padding             │
└──────────────────────────────┘

- Pixel grid: Align all objects, especially straight lines
- Optical grid: Circles occupy less perceived space than squares
- Add padding equal to stroke weight around dominant object
```

**Touch Targets (Accessibility - WCAG 2.5.5):**

Minimum touch target: **44×44px** (Apple HIG: 44pt, Material: 48dp)

```css
/* DO: Invisible clickable area extends beyond icon */
.icon-button {
  /* Visible icon: 24×24px */
  width: 24px;
  height: 24px;

  /* Invisible touch target: 44×44px minimum */
  padding: 10px;
  margin: -10px;
  cursor: pointer;
}

/* Alternative: Pseudo-element approach */
.icon-button {
  position: relative;
}

.icon-button::before {
  content: '';
  position: absolute;
  inset: -10px;  /* Extends 10px in all directions */
}
```

**Icon Naming Convention:**

> "Name icons by what they *show*, not their conceptual meaning. A stopwatch icon should be named **stopwatch**, not **speed**." — DesignSystems.com

```typescript
// DO: Name by visual appearance (noun-based)
iconPaths.search      // The magnifying glass shape
iconPaths.mail        // The envelope shape
iconPaths.settings    // The gear shape
iconPaths.stopwatch   // NOT: speed, timer, performance

// DO: Use modifiers for variants
iconPaths.eye         // Show password
iconPaths.eyeOff      // Hide password
iconPaths.check       // Single check
iconPaths.checkCircle // Check in circle
iconPaths.bell        // Default notification
iconPaths.bellOff     // Muted notification

// DO: Structure: Category/Name or Name/Variant
'navigation/chevronRight'
'status/checkCircle'
'coffee/stroked'
'shield/dollar'

// Recommended libraries (500-1000 icons minimum):
// - Phosphor Icons (versatile, 6 weights per icon)
// - Lucide (Feather fork, actively maintained)
// - Heroicons (Tailwind ecosystem, 2 styles)
// - Tabler Icons (4,500+ icons, MIT license)
```

**Corner & End Cap Consistency:**

Choose ONE style and apply to ALL icons:

| Treatment | Style | Vibe |
|-----------|-------|------|
| Corners | Rounded | Friendly, modern |
| Corners | Mitered | Sharp, technical |
| Corners | Beveled | Industrial |
| End caps | Rounded | Softer, approachable |
| End caps | Squared | More formal |

**Neural ICE Standard:** Rounded corners + Rounded end caps (modern, friendly)

### Typography System

**Font Stack:**
```css
:root {
  /* Primary: Inter for UI, readable at small sizes */
  --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;

  /* Monospace: JetBrains Mono for code, technical data */
  --font-mono: 'JetBrains Mono', 'Fira Code', 'SF Mono', monospace;
}
```

**Sizing Hierarchy (Minor Third Scale - 1.2):**

| Token | Size | Line Height | Use |
|-------|------|-------------|-----|
| `--text-xs` | 11.1px | 1.4 | Captions, badges |
| `--text-sm` | 13.3px | 1.5 | Secondary text |
| `--text-base` | 16px | 1.5 | Body text (optimal) |
| `--text-lg` | 19.2px | 1.4 | Section headers |
| `--text-xl` | 23px | 1.3 | Page titles |
| `--text-2xl` | 27.6px | 1.2 | Hero text |

**Weight Usage:**

| Weight | Token | Use |
|--------|-------|-----|
| 400 | `--font-normal` | Body text, descriptions |
| 500 | `--font-medium` | UI labels, buttons |
| 600 | `--font-semibold` | Section headers |
| 700 | `--font-bold` | Page titles, emphasis |

### Color & Accessibility

**Contrast Requirements (WCAG 2.1 AA):**

| Text Size | Minimum Ratio |
|-----------|---------------|
| Normal text (< 18px) | 4.5:1 |
| Large text (≥ 18px bold or ≥ 24px) | 3:1 |
| UI components, graphics | 3:1 |

```css
/* Neural ICE color palette - accessibility verified */
:root {
  /* Text on dark backgrounds */
  --color-text-primary: #F8F8FC;    /* ✓ 15.8:1 on #0A0A14 */
  --color-text-secondary: #A0A0B0;  /* ✓ 6.8:1 on #0A0A14 */
  --color-text-tertiary: #6B6B7B;   /* ✓ 4.5:1 on #0A0A14 */
  --color-text-disabled: #4A4A5A;   /* ✗ Use with large text only */

  /* Semantic colors on dark backgrounds */
  --color-success: #00FF9F;         /* Neon green - high visibility */
  --color-warning: #FFAA00;         /* Neon orange */
  --color-error: #FF3264;           /* Neon red/magenta */
  --color-info: #00C8FF;            /* Neural ICE cyan */
}
```

**Color for Status (Never Color Alone):**

```vue
<!-- DO: Color + icon + text -->
<NiBadge color="success" dot>
  <NiIcon name="check" size="12" />
  ONLINE
</NiBadge>

<!-- DON'T: Color alone (colorblind users can't distinguish) -->
<span style="color: green">●</span>
```

### Component Architecture

**Atomic Design Pattern:**

```
Atoms → Molecules → Organisms → Templates → Pages

Atoms:      NiIcon, NiButton, NiBadge
Molecules:  NiInput (icon + input), NiToast (icon + text + action)
Organisms:  NiHeader (logo + nav + user), NiSidebar
Templates:  DashboardLayout, AuthLayout
Pages:      Dashboard.vue, Settings.vue
```

**Component API Consistency:**

```typescript
// DO: Consistent prop naming across components
interface BaseProps {
  variant?: 'primary' | 'secondary' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  disabled?: boolean
}

// All components follow same pattern
<NiButton variant="primary" size="md" />
<NiInput variant="primary" size="md" />
<NiBadge variant="label" size="md" />

// DON'T: Inconsistent naming
<Button type="primary" />      // type vs variant
<Input inputSize="medium" />   // inputSize vs size
<Badge kind="label" />         // kind vs variant
```

### Spacing & Layout

**4px Grid System:**

```css
/* All spacing is multiples of 4px */
:root {
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-6: 24px;
  --space-8: 32px;
}

/* DO: Use spacing tokens */
.card {
  padding: var(--space-4);      /* 16px */
  margin-bottom: var(--space-6); /* 24px */
  gap: var(--space-3);          /* 12px */
}

/* DON'T: Arbitrary values */
.card {
  padding: 15px;   /* BAD: not on grid */
  margin: 17px;    /* BAD: not on grid */
}
```

### Animation & Motion

**Duration Tokens:**

| Token | Duration | Use |
|-------|----------|-----|
| `--duration-fast` | 100ms | Micro-interactions (hover, focus) |
| `--duration-normal` | 200ms | Default transitions |
| `--duration-slow` | 300ms | Complex animations |
| `--duration-slower` | 500ms | Page transitions |

**Easing Functions:**

```css
:root {
  --ease-default: cubic-bezier(0.4, 0, 0.2, 1);  /* Smooth */
  --ease-in: cubic-bezier(0.4, 0, 1, 1);         /* Acceleration */
  --ease-out: cubic-bezier(0, 0, 0.2, 1);        /* Deceleration */
  --ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55); /* Playful */
}

/* DO: Consistent animation patterns */
.button {
  transition: background-color var(--duration-fast) var(--ease-default);
}

.modal {
  animation: fade-in var(--duration-slow) var(--ease-out);
}

/* DON'T: Random durations and easings */
.button {
  transition: all 0.15s ease;  /* BAD: 'all' is expensive, arbitrary duration */
}
```

**Reduce Motion (Accessibility):**

```css
/* Respect user's motion preferences */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

### Microinteractions

Microinteractions enhance engagement and provide feedback. Implement consistently:

| Interaction | Purpose | Implementation |
|-------------|---------|----------------|
| Hover state | Indicate interactivity | Subtle color/shadow change |
| Focus ring | Keyboard navigation | 3px offset outline, brand color |
| Active/pressed | Confirm action | Scale down slightly (0.98) |
| Loading | Async feedback | Skeleton or spinner |
| Success | Positive confirmation | Check icon + green accent |
| Error | Problem indication | Shake animation + red accent |

```css
/* DO: Consistent button microinteractions */
.ni-button {
  transition:
    background-color var(--duration-fast) var(--ease-default),
    transform var(--duration-fast) var(--ease-default),
    box-shadow var(--duration-fast) var(--ease-default);
}

.ni-button:hover {
  background-color: var(--color-primary-600);
  box-shadow: var(--shadow-glow);
}

.ni-button:focus-visible {
  outline: 2px solid var(--color-primary-400);
  outline-offset: 2px;
}

.ni-button:active {
  transform: scale(0.98);
}

.ni-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
```

### Dark Mode (Neural ICE Default)

Neural ICE is **dark-first** by design (cyberpunk aesthetic, reduced eye strain).

**Surface Hierarchy (Dark → Light for elevation):**

```css
:root {
  --color-surface-0: #0A0A14;  /* Deepest background */
  --color-surface-1: #12121F;  /* App background */
  --color-surface-2: #1A1A2E;  /* Cards, panels */
  --color-surface-3: #242438;  /* Elevated cards, hover */
  --color-surface-4: #2E2E44;  /* Active states */
  --color-surface-5: #3A3A52;  /* Highest elevation */
}

/* Glassmorphism for modern depth */
.glass-panel {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}
```

**Neon Accents (Cyberpunk Aesthetic):**

```css
/* Semantic colors with glow effects */
.status-success {
  color: #00FF9F;
  text-shadow: 0 0 8px rgba(0, 255, 159, 0.5);
}

.status-ice {
  color: #00C8FF;
  box-shadow: 0 0 12px rgba(0, 200, 255, 0.35);
}

.status-gold {
  color: #FFD700;
  text-shadow: 0 0 8px rgba(255, 215, 0, 0.5);
}
```

### Storybook Documentation

**Required Stories per Component:**

```typescript
// Component.stories.ts must include:

export default {
  title: 'Components/NiButton',
  component: NiButton,
  tags: ['autodocs'],  // Auto-generate docs
  argTypes: { /* Document all props */ },
}

// 1. Default state
export const Default: Story = {}

// 2. All variants
export const AllVariants: Story = {}

// 3. All sizes
export const AllSizes: Story = {}

// 4. Interactive states (hover, focus, active, disabled)
export const States: Story = {}

// 5. Real-world usage example
export const InContext: Story = {}
```

### Pre-Commit Checklist (UI/UX)

- [ ] All colors use design tokens (no hex codes in components)
- [ ] All spacing uses spacing tokens (no px values)
- [ ] Icons are SVG, 24×24 viewBox, stroke-based
- [ ] Touch targets are minimum 44×44px
- [ ] Color is not the only indicator of state
- [ ] Animations respect `prefers-reduced-motion`
- [ ] Components have Storybook stories
- [ ] New tokens are documented in `DesignTokens.mdx`

---

## Vue.js/TypeScript Guidelines

### Component Structure

```vue
<script setup lang="ts">
// DO: Composition API with TypeScript
import { ref, computed, onMounted } from 'vue'
import type { License } from '@/types'

interface Props {
  licenseKey: string
}

const props = defineProps<Props>()
const emit = defineEmits<{
  (e: 'activated', license: License): void
}>()

const isLoading = ref(false)
const error = ref<string | null>(null)

const isValid = computed(() => props.licenseKey.length === 32)

async function activate() {
  isLoading.value = true
  error.value = null

  try {
    const license = await api.activateLicense(props.licenseKey)
    emit('activated', license)
  } catch (e) {
    error.value = e instanceof Error ? e.message : 'Activation failed'
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="license-form">
    <input
      :value="props.licenseKey"
      :disabled="isLoading"
      placeholder="Enter license key"
    />
    <button
      :disabled="!isValid || isLoading"
      @click="activate"
    >
      {{ isLoading ? 'Activating...' : 'Activate' }}
    </button>
    <p v-if="error" class="error">{{ error }}</p>
  </div>
</template>
```

### TypeScript Types

```typescript
// DO: Explicit types, no any
interface SystemStatus {
  hostname: string
  version: string
  uptime: number
  gpu: GpuStatus
  license: LicenseStatus
}

interface GpuStatus {
  name: string
  memoryUsed: number
  memoryTotal: number
  utilization: number
}

// DON'T: any types
const status: any = await fetch('/api/status')  // BAD
```

### API Calls

```typescript
// DO: Type-safe API with error handling
async function fetchStatus(): Promise<SystemStatus> {
  const response = await fetch('/api/v1/status')

  if (!response.ok) {
    throw new Error(`API error: ${response.status}`)
  }

  return response.json() as Promise<SystemStatus>
}

// DON'T: No error handling
const status = await fetch('/api/status').then(r => r.json())  // BAD
```

---

## YAML Guidelines

### General Rules

```yaml
# DO: Consistent indentation (2 spaces), quoted strings when needed
services:
  api:
    image: "ghcr.io/neural-ice/api:v1.0.0"
    environment:
      - "DATABASE_URL=postgres://localhost/db"
      - "LOG_LEVEL=info"

# DON'T: Inconsistent, unquoted special chars
services:
  api:
    image: ghcr.io/neural-ice/api:v1.0.0  # OK but quote for consistency
    environment:
      - DATABASE_URL=postgres://localhost/db  # BAD: should quote
```

### Ansible-Specific YAML

```yaml
# DO: Explicit YAML, not inline
- name: Configure service
  ansible.builtin.template:
    src: config.j2
    dest: /etc/app/config.yml
    mode: '0644'
    owner: root
    group: root

# DON'T: Inline YAML
- name: Configure service
  template: src=config.j2 dest=/etc/app/config.yml mode=0644  # BAD
```

---

## Git & Commit Guidelines

### Branch Naming

```
feature/<issue>-<description>
fix/<issue>-<description>
refactor/<description>
docs/<description>
```

### Commit Message Format

```
<type>(<scope>): <description> (#<issue>)

[optional body]

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types:** feat, fix, docs, refactor, test, chore, security

### Examples

```
feat(cockpit): Add license enrollment wizard (#126)

Implements the first boot wizard step for license activation.
- Adds LicenseEnrollment.vue component
- Integrates with Keygen.sh API
- Handles offline fallback

Co-Authored-By: Claude <noreply@anthropic.com>
```

---

## Documentation Requirements

### Code Comments

```rust
// DO: Explain WHY, not WHAT
// We use a 30-second timeout because the Keygen API can be slow
// during peak hours, and we'd rather wait than fail activation.
let timeout = Duration::from_secs(30);

// DON'T: Obvious comments
// Set timeout to 30 seconds
let timeout = Duration::from_secs(30);  // BAD: obvious
```

### Function Documentation

```rust
/// Validates and activates a license key with Keygen.sh.
///
/// # Arguments
///
/// * `license_key` - The 32-character license key from customer email
/// * `fingerprint` - Hardware fingerprint (DMI serial + MAC)
///
/// # Returns
///
/// Returns the activated license on success, or an error if:
/// - The license key is invalid or already used
/// - The hardware fingerprint doesn't match
/// - Network connectivity issues
///
/// # Example
///
/// ```
/// let license = activate_license("XXXX-XXXX-XXXX-XXXX", &fingerprint).await?;
/// ```
pub async fn activate_license(
    license_key: &str,
    fingerprint: &HardwareFingerprint,
) -> Result<License> {
```

---

## Pre-Commit Checklist

Before EVERY commit, verify:

### Rust
- [ ] `cargo fmt --check` passes
- [ ] `cargo clippy -- -D warnings` passes
- [ ] `cargo test` passes
- [ ] No `unwrap()` in production code
- [ ] Error messages have context

### Ansible
- [ ] `ansible-lint` passes
- [ ] All tasks are named
- [ ] All tasks have explicit `state`
- [ ] Variables use `neuralice_` prefix
- [ ] Templates have `{{ ansible_managed }}`

### Bash
- [ ] `shellcheck` passes
- [ ] `set -euo pipefail` at top
- [ ] All variables quoted
- [ ] Functions use `local`

### General
- [ ] No hardcoded secrets
- [ ] No TODO/FIXME without issue reference
- [ ] Follows existing code style
- [ ] Documentation updated if needed

---

## Packer Guidelines

### Immutable Infrastructure Philosophy (2025)

> "Instead of patching, we just rebuild and redeploy. You can move infrastructure really fast."
> — HashiConf 2025

**Core Principles:**
- Images are **never modified** after deployment
- Changes = new version, not in-place updates
- Zero configuration drift (image contains ALL config)
- 100% reproducibility

### File Structure (ICE Core)

```
packer/
├── ubuntu-cloud-spark.pkr.hcl   # Main build definition
├── variables.pkr.hcl            # Variable definitions (optional)
└── scripts/                     # Provisioning scripts
```

### HCL2 Best Practices

```hcl
# DO: Use HCL2 format (not JSON)
packer {
  required_version = ">= 1.9.0"

  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

# DO: Define variables with types
variable "version" {
  type        = string
  description = "Image version (e.g., v0.13.16)"
}

variable "output_directory" {
  type    = string
  default = "output"
}

# DO: Use locals for computed values
locals {
  image_name = "neural-ice-${var.version}-golden.img"
  timestamp  = formatdate("YYYY-MM-DD", timestamp())
}

# DO: Separate source blocks
source "qemu" "ubuntu-spark" {
  iso_url          = var.iso_url
  output_directory = var.output_directory
  vm_name          = local.image_name

  # Boot command with heredoc for readability
  boot_command = <<-EOF
    <wait>
    autoinstall ds=nocloud-net;
    <enter>
  EOF
}

# DO: Build block with clear provisioner order
build {
  sources = ["source.qemu.ubuntu-spark"]

  # Provisioners run in order
  provisioner "ansible" {
    playbook_file = "../build.yml"
    extra_arguments = [
      "-e", "neuralice_version=${var.version}",
      "-e", "neuralice_packer_build=true"
    ]
  }

  post-processor "checksum" {
    checksum_types = ["sha256"]
    output         = "${var.output_directory}/${local.image_name}.sha256"
  }
}
```

### DON'T

```hcl
# DON'T: Use JSON format (deprecated)
# DON'T: Hardcode versions
source "qemu" "ubuntu" {
  vm_name = "neural-ice-v0.13.16.img"  # BAD: hardcoded
}

# DON'T: Skip required_plugins
# DON'T: Use @latest for plugins
```

### Validation

```bash
packer validate .
packer fmt -check .
```

### CI/CD Integration (2025 Best Practices)

```yaml
# .github/workflows/build-image.yml
name: Build Image

on:
  push:
    tags: ['v*']  # Trigger on version tags

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Packer
        uses: hashicorp/setup-packer@v3

      - name: Packer Init
        run: packer init packer/

      - name: Packer Validate
        run: packer validate packer/

      - name: Packer Build
        run: |
          packer build \
            -var "version=${{ github.ref_name }}" \
            packer/ubuntu-cloud-spark.pkr.hcl

      - name: Generate SBOM
        run: |
          syft packages output/*.img -o spdx-json > sbom.json

      - name: Upload Artifact
        uses: actions/upload-artifact@v4
        with:
          name: neural-ice-${{ github.ref_name }}
          path: |
            output/*.img
            output/*.sha256
            sbom.json
```

### 30-Day Repave Cycle (Security Best Practice)

```
Week 1: Build new base image with latest patches
Week 2: Test in staging environment
Week 3: Gradual rollout to production (10% → 50% → 100%)
Week 4: Monitor, collect feedback, plan next cycle

Benefits:
- Known-good baseline every 30 days
- Accumulated vulnerabilities eliminated
- Drift impossible (images are immutable)
- Audit trail via versioned artifacts
```

### SBOM and Provenance (HashiConf 2025)

```hcl
# Include SBOM generation in post-processor
post-processor "shell-local" {
  inline = [
    "syft packages ${var.output_directory}/${local.image_name} -o spdx-json > ${var.output_directory}/sbom.json"
  ]
}

# Sign artifacts for provenance
post-processor "shell-local" {
  inline = [
    "cosign sign-blob --key cosign.key ${var.output_directory}/${local.image_name}"
  ]
}
```

---

## systemd Guidelines

### Unit File Location

```bash
# For packages (Ansible deploys here)
/lib/systemd/system/neuralice-*.service

# For admin overrides (manual changes only)
/etc/systemd/system/neuralice-*.service

# For drop-in modifications
/etc/systemd/system/neuralice-tui.service.d/override.conf
```

### Service Unit Best Practices

```ini
# /lib/systemd/system/neuralice-tui.service
[Unit]
Description=Neural-ICE TUI Dashboard
Documentation=https://github.com/Neural-ICE/ICE-Core
After=network.target docker.service
Wants=docker.service

[Service]
# DO: Run as non-root user when possible
User=neuralice
Group=neuralice

# DO: Use Type=simple (don't fork)
Type=simple

# DO: Use absolute paths
ExecStart=/opt/neuralice/bin/neuralice-tui

# DO: Define restart policy
Restart=always
RestartSec=5

# DO: Set resource limits
MemoryMax=256M
CPUQuota=50%

# DO: Security hardening
ProtectSystem=strict
ProtectHome=true
PrivateTmp=true
NoNewPrivileges=true
ReadOnlyPaths=/

# DO: Allow write only where needed
ReadWritePaths=/data/neuralice

# DO: Restrict capabilities
CapabilityBoundingSet=
AmbientCapabilities=

[Install]
WantedBy=multi-user.target
```

### DON'T

```ini
# DON'T: Run as root without reason
User=root  # BAD unless absolutely required

# DON'T: Use Type=forking
Type=forking  # BAD: prefer foreground daemons
PIDFile=/run/app.pid  # BAD: not needed with Type=simple

# DON'T: Skip security hardening
# (missing ProtectSystem, NoNewPrivileges, etc.)

# DON'T: Use relative paths
ExecStart=neuralice-tui  # BAD: use absolute path
```

### After Changes

```bash
# ALWAYS reload after modifying unit files
sudo systemctl daemon-reload
sudo systemctl restart neuralice-tui

# Verify
systemctl status neuralice-tui
journalctl -u neuralice-tui -f
```

### Security Analysis

```bash
# Check security score (lower is better, aim for < 5.0)
systemd-analyze security neuralice-tui.service

# Example output:
# → Overall exposure level for neuralice-tui.service: 4.9 OK
```

**Score Interpretation:**
| Score | Rating | Action |
|-------|--------|--------|
| 0-2 | Excellent | Highly hardened |
| 2-5 | OK | Good for most services |
| 5-7 | Medium | Add more restrictions |
| 7-10 | Exposed | Needs hardening |

### Additional Hardening Directives

```ini
# For network-facing services
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX
IPAddressDeny=any
IPAddressAllow=localhost

# For services that don't need network
PrivateNetwork=true

# Restrict system calls (use with caution)
SystemCallFilter=@system-service
SystemCallArchitectures=native

# Restrict kernel features
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectKernelLogs=true
ProtectControlGroups=true
ProtectClock=true

# Memory protections
MemoryDenyWriteExecute=true
LockPersonality=true
RestrictRealtime=true
RestrictSUIDSGID=true

# Namespace isolation
PrivateUsers=true
ProtectHostname=true
RestrictNamespaces=true
```

> "Start by analyzing services exposed to the internet or handling untrusted data—these benefit most from sandboxing."

---

## GitHub Actions Guidelines

### Workflow Security

```yaml
# .github/workflows/build.yml
name: Build Image

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

# DO: Minimize default permissions
permissions:
  contents: read

jobs:
  build:
    runs-on: ubuntu-latest

    # DO: Set job-level permissions
    permissions:
      contents: read
      packages: write

    steps:
      # DO: Pin actions to full SHA
      - uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1

      # DO: Use OIDC for cloud auth (no secrets)
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@e3dd6a429d7300a6a4c196c26e071d42e0343502 # v4
        with:
          role-to-assume: arn:aws:iam::123456789:role/GitHubActions
          aws-region: eu-west-1

      # DO: Use secrets for sensitive values
      - name: Login to Registry
        uses: docker/login-action@343f7c4344506bcbf9b4de18042ae17996df046d # v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
```

### Secret Management

```yaml
# DO: Use GitHub Secrets
env:
  API_KEY: ${{ secrets.KEYGEN_API_KEY }}

# DO: Mask sensitive output
- name: Process secret
  run: |
    echo "::add-mask::${{ secrets.API_KEY }}"

# DON'T: Hardcode secrets
env:
  API_KEY: "sk-live-xxxxx"  # BAD: hardcoded secret

# DON'T: Echo secrets
- run: echo ${{ secrets.API_KEY }}  # BAD: exposes in logs
```

### Third-Party Actions

```yaml
# DO: Pin to full commit SHA
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11

# DON'T: Use mutable tags
- uses: actions/checkout@v4      # BAD: can change
- uses: actions/checkout@main    # BAD: very dangerous
- uses: some-org/untrusted@v1    # BAD: unverified action
```

### Workflow Triggers

```yaml
# DO: Restrict triggers
on:
  push:
    branches: [main, develop]
    paths:
      - 'src/**'
      - 'packer/**'
      - '.github/workflows/**'

# DON'T: Use pull_request_target with checkout
on:
  pull_request_target:  # DANGEROUS with untrusted PRs
```

### Self-Hosted Runners

```yaml
# DO: Use labels to restrict sensitive jobs
jobs:
  deploy:
    runs-on: [self-hosted, production]
    environment: production  # Requires approval

# DON'T: Run untrusted code on self-hosted
# Never use self-hosted runners for public repos
```

### OIDC Authentication (Preferred over Secrets)

```yaml
# DO: Use OIDC for cloud providers (no long-lived secrets)
jobs:
  deploy:
    permissions:
      id-token: write   # Required for OIDC
      contents: read

    steps:
      - name: Configure AWS credentials via OIDC
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789:role/GitHubActions
          aws-region: eu-central-1
          # No access keys needed!
```

**OIDC Benefits:**
- No long-lived secrets to rotate
- Tokens valid for minutes, not months
- Audit trail of which workflow requested access
- Cannot be exfiltrated from logs

### Security Scanning Tools

```yaml
# Static analysis for GitHub Actions
- name: Analyze workflow security
  uses: step-security/harden-runner@v2
  with:
    egress-policy: audit  # or 'block' for strict mode

# Use zizmor for local scanning
# pip install zizmor
# zizmor .github/workflows/
```

---

## Keygen.sh Guidelines

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    KEYGEN.SH CLOUD                          │
│  - License management                                       │
│  - Machine tracking                                         │
│  - Entitlements                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                    HTTPS + Signatures
                              │
┌─────────────────────────────────────────────────────────────┐
│                    ICE CORE DEVICE                          │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │ License Client  │───▶│ Offline Cache   │                │
│  │ (icecore-agent) │    │ (.lic file)     │                │
│  └─────────────────┘    └─────────────────┘                │
│           │                                                 │
│           ▼                                                 │
│  ┌─────────────────────────────────────────┐               │
│  │ Hardware Fingerprint                     │               │
│  │ - DMI Serial + MAC Address               │               │
│  │ - GPU ID (optional)                      │               │
│  └─────────────────────────────────────────┘               │
└─────────────────────────────────────────────────────────────┘
```

### License Validation

```rust
// DO: Validate online with signature verification
async fn validate_license(key: &str, fingerprint: &str) -> Result<License> {
    let response = client
        .post(format!("{}/v1/licenses/actions/validate-key", KEYGEN_API))
        .json(&json!({
            "meta": {
                "key": key,
                "scope": {
                    "fingerprint": fingerprint
                }
            }
        }))
        .send()
        .await?;

    // ALWAYS verify signature
    let signature = response
        .headers()
        .get("Keygen-Signature")
        .ok_or("Missing signature")?;

    verify_signature(&response, signature, &PUBLIC_KEY)?;

    Ok(response.json().await?)
}

// DON'T: Trust response without signature verification
let license = response.json().await?;  // BAD: MITM vulnerable
```

### Machine Fingerprinting

```rust
// DO: Generate deterministic fingerprint from hardware
fn generate_fingerprint() -> String {
    let dmi_serial = read_dmi_serial().unwrap_or_default();
    let mac_address = get_primary_mac().unwrap_or_default();

    // Combine and hash for privacy
    let combined = format!("{}:{}", dmi_serial, mac_address);
    sha256_hex(&combined)
}

// DO: Include components for validation
let machine = json!({
    "fingerprint": fingerprint,
    "name": hostname,
    "platform": "linux",
    "components": [
        {"fingerprint": gpu_id, "name": "GPU"},
        {"fingerprint": mobo_serial, "name": "Motherboard"}
    ]
});
```

### Offline Licensing

```rust
// DO: Checkout license for offline use with TTL
async fn checkout_offline(license_id: &str) -> Result<LicenseFile> {
    let response = client
        .post(format!(
            "{}/v1/licenses/{}/actions/check-out",
            KEYGEN_API, license_id
        ))
        .query(&[
            ("ttl", "2592000"),  // 30 days
            ("encrypt", "true")
        ])
        .bearer_auth(&license_token)
        .send()
        .await?;

    // Store encrypted .lic file
    let lic_file = response.text().await?;
    fs::write("/data/license/license.lic", &lic_file)?;

    Ok(parse_license_file(&lic_file)?)
}

// DO: Verify offline license
fn verify_offline_license(lic_content: &str) -> Result<License> {
    // 1. Strip PEM header/footer
    // 2. Base64 decode
    // 3. Parse JSON
    // 4. Verify Ed25519 signature with public key
    // 5. Decrypt with AES-256-GCM if encrypted
    // 6. Check expiry and clock tampering
}
```

### Security Best Practices

```rust
// DO: Store tokens securely
// Server-side tokens: environment variables only
let admin_token = std::env::var("KEYGEN_ADMIN_TOKEN")?;

// Client-side: use license tokens (scoped, short-lived)
let license_token = activate_license(&key).await?.token;

// DON'T: Embed admin tokens in client code
const ADMIN_TOKEN: &str = "admin-xxx";  // NEVER DO THIS

// DO: Implement rate limiting awareness
if response.status() == 429 {
    let retry_after = response
        .headers()
        .get("Retry-After")
        .and_then(|v| v.to_str().ok())
        .and_then(|v| v.parse().ok())
        .unwrap_or(60);

    tokio::time::sleep(Duration::from_secs(retry_after)).await;
}

// DO: Detect clock tampering for offline licenses
fn check_clock_integrity(license: &License) -> Result<()> {
    let last_check = read_timestamp_file()?;
    let now = SystemTime::now();

    if now < last_check {
        return Err("Clock tampering detected".into());
    }

    if now < license.issued {
        return Err("Clock set before license creation".into());
    }

    Ok(())
}
```

### User-Agent Requirements

```rust
// DO: Include descriptive User-Agent
let client = reqwest::Client::builder()
    .user_agent("ICE-Core/0.13.16 (Neural-ICE) linux/arm64")
    .build()?;
```

---

## Mender OTA Guidelines

### A/B Partition Strategy

```
┌─────────────────────────────────────────────────────────────┐
│                    ICE CORE PARTITION LAYOUT                │
├─────────────────────────────────────────────────────────────┤
│ p1: EFI      (512MB)  │ /boot/efi                          │
├───────────────────────┼─────────────────────────────────────┤
│ p2: boot     (1GB)    │ /boot (kernel, initramfs)          │
├───────────────────────┼─────────────────────────────────────┤
│ p3: root_a   (16GB)   │ / (ACTIVE - running system)        │
├───────────────────────┼─────────────────────────────────────┤
│ p4: root_b   (16GB)   │ (INACTIVE - OTA target)            │
├───────────────────────┼─────────────────────────────────────┤
│ p5: data     (~3.6TB) │ /data (persistent across updates)  │
│                       │ - Docker images & containers        │
│                       │ - AI models (/data/ollama)          │
│                       │ - Logs (/data/logs)                 │
│                       │ - License cache                     │
└───────────────────────┴─────────────────────────────────────┘
```

### Update Flow

```
1. DOWNLOAD    → Write new rootfs to inactive partition (root_b)
                 Device remains fully operational
2. INSTALL     → Verify checksum, update bootloader config
3. REBOOT      → Switch to new partition
4. COMMIT      → Mark update successful (or auto-rollback)

┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│ Download│───▶│ Install │───▶│ Reboot  │───▶│ Commit  │
└─────────┘    └─────────┘    └─────────┘    └─────────┘
     │              │              │              │
     ▼              ▼              ▼              ▼
  root_a        root_a         root_b         root_b
  (active)     (active)       (active)       (committed)
              root_b
             (writing)
```

### Data Persistence Rules

```yaml
# CRITICAL: Never store persistent data on root partitions!
# They get REPLACED during updates.

# DO: Store on /data partition
/data/docker/          # Docker data-root
/data/ollama/          # AI models
/data/logs/            # System logs
/data/config/          # User configuration
/data/license/         # License cache

# DON'T: Store on root filesystem
/var/lib/docker/       # BAD: lost on update
/home/user/data/       # BAD: lost on update
/opt/models/           # BAD: lost on update
```

### Artifact Creation

```bash
# Create Mender artifact from rootfs image
mender-artifact write rootfs-image \
    --device-type dgx-spark \
    --artifact-name neural-ice-v0.13.16 \
    --file neural-ice-v0.13.16-ab.img \
    --output-path neural-ice-v0.13.16.mender

# Sign artifact (REQUIRED for production)
mender-artifact sign neural-ice-v0.13.16.mender \
    --key private.key

# Verify artifact
mender-artifact validate neural-ice-v0.13.16.mender \
    --key public.key
```

### Mender Client Configuration

```yaml
# /etc/mender/mender.conf
{
  "ServerURL": "https://hosted.mender.io",
  "TenantToken": "{{ mender_tenant_token }}",
  "UpdatePollIntervalSeconds": 1800,
  "InventoryPollIntervalSeconds": 28800,
  "RetryPollIntervalSeconds": 300
}
```

### Update Verification (State Scripts)

```bash
#!/bin/bash
# /etc/mender/scripts/ArtifactCommit_Enter_00_verify

# Verify critical services are running
systemctl is-active docker || exit 1
systemctl is-active neuralice-tui || exit 1

# Verify network connectivity
ping -c 1 hosted.mender.io || exit 1

# Verify GPU is accessible
nvidia-smi || exit 1

# All checks passed - allow commit
exit 0

# If this script fails, Mender will rollback automatically
```

### Security Best Practices

```yaml
# DO: Sign all artifacts
# Generate key pair (once)
openssl genpkey -algorithm RSA -out private.key -pkeyopt rsa_keygen_bits:3072
openssl rsa -in private.key -pubout -out public.key

# Configure client to verify signatures
# /etc/mender/mender.conf
{
  "ArtifactVerifyKey": "/etc/mender/public.key"
}

# DO: Use TLS for all communications
# Mender hosted uses TLS by default

# DO: Authorize devices before accepting
# In Mender UI: Devices → Pending → Accept/Reject
```

### Rollback Scenarios

| Scenario | Behavior |
|----------|----------|
| Boot failure | Automatic rollback to previous partition |
| State script failure | Automatic rollback before commit |
| Network loss during download | Resume from checkpoint |
| Power loss during install | Safe - inactive partition was being written |
| Commit script failure | Automatic rollback |

### Deployment Best Practices

```yaml
# 1. Phased rollouts - don't deploy to all devices at once
# Mender UI: Create deployment → Select device group → Set phases

# 2. Deployment windows - schedule during maintenance windows
# Mender UI: Deployment → Schedule

# 3. Device groups - organize by environment/location
# Groups: development, staging, production

# 4. 30-day repave cycle - rebuild images regularly
# Ensures latest security patches are included
```

---

## Reference Links

### Core Languages
- [Canonical Rust Best Practices](https://canonical.github.io/rust-best-practices/)
- [Red Hat CoP - Automation Good Practices](https://redhat-cop.github.io/automation-good-practices/) (Ansible SOTA)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://www.shellcheck.net/)

### UI/UX Design Systems
- [UXPin - Design Consistency Best Practices](https://www.uxpin.com/studio/blog/guide-design-consistency-best-practices-ui-ux-designers/)
- [Figma - UI Design Principles](https://www.figma.com/resource-library/ui-design-principles/)
- [Untitled UI - What is a Design System](https://www.untitledui.com/blog/what-is-a-design-system)
- [Frontify - Design Systems Guide](https://www.frontify.com/en/guide/design-systems)
- [Brightside Studio - Design System Guide](https://www.brightside-studio.de/en/blog/design-system-guide)
- [UIDesignz - UI/UX Best Practices 2026](https://uidesignz.com/blogs/ui-ux-design-best-practices)
- [Cursor Directory - UI/UX Best Practices](https://cursor.directory/ui-ux-design-best-practices)
- [CyberiaTech - UI Design Best Practices](https://thecyberiatech.com/blog/ui-ux/ui-design-best-practices/)

### Iconography
- [Koala UI - Icon Best Practices 2024](https://www.koalaui.com/blog/ultimate-guide-best-practices-icons-2024)
- [Adobe Design - Constructing an Icon System](https://adobe.design/stories/design-for-scale/designing-design-systems-constructing-an-icon-system)
- [DesignSystems.com - Iconography Guide](https://www.designsystems.com/iconography-guide/)
- [Figma Forum - Icon Best Practices](https://forum.figma.com/ask-the-community-7/every-icon-best-practice-you-need-to-know-18030)

### Frontend & Desktop
- [Vue.js Style Guide](https://vuejs.org/style-guide/)
- [TypeScript Best Practices](https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html)
- [Tauri v2 Security](https://v2.tauri.app/security/)
- [Tauri Capabilities](https://v2.tauri.app/security/capabilities/)

### Infrastructure
- [Docker Build Best Practices](https://docs.docker.com/build/building/best-practices/)
- [OWASP Docker Security](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
- [Packer HCL2 Guide](https://developer.hashicorp.com/packer/guides/hcl)
- [systemd Sandboxing](https://wiki.archlinux.org/title/Systemd/Sandboxing)

### CI/CD & Security
- [GitHub Actions Security](https://docs.github.com/actions/security-for-github-actions)
- [GitHub OIDC](https://docs.github.com/en/actions/concepts/security/openid-connect)
- [StepSecurity Best Practices](https://www.stepsecurity.io/blog/github-actions-security-best-practices)

### OTA & Licensing (Project-Specific)
- [Mender Documentation](https://docs.mender.io/)
- [Mender A/B Partitioning](https://mender.io/blog/robust-ota-updates-with-partitions-for-linux-devices)
- [Keygen.sh Documentation](https://keygen.sh/docs/)
- [Keygen.sh LLM Reference](https://keygen.sh/llms.txt)

### Hardware & GPU
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/)

---

**This document is MANDATORY for all Claude Code development sessions.**

*When in doubt, read the existing code and match its style.*
