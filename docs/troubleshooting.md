---
layout: default
title: "Troubleshooting Guide - Another Claude-Code BMAD"
description: "Solutions for common Another Claude-Code BMAD issues. Installation problems, command errors, configuration issues, and workflow troubleshooting."
keywords: "BMAD troubleshooting, Claude Code errors, BMAD installation problems, workflow issues"
---

# Troubleshooting Guide

Solutions for common issues when using Another Claude-Code BMAD.

---

## Quick Fixes

Before diving into specific issues, try these common fixes:

1. **Restart Claude Code** - Skills load on startup
2. **Check file locations** - Ensure files are in correct directories
3. **Validate YAML** - Use a YAML linter
4. **Run /workflow-status** - See current state and recommendations

---

## Installation Issues

### Commands Not Recognized

**Symptom:** `/workflow-init` returns "command not found" or similar

**Causes & Fixes:**

1. **Didn't restart Claude Code**

   Skills and commands load on startup. Close and reopen your terminal:
   ```bash
   # Close terminal, then:
   claude
   ```

2. **Installation failed silently**

   Re-run installer:
   ```bash
   ./install-bmad-skills.sh
   ```

3. **Files in wrong location**

   Verify installation:
   ```bash
   # Check skills
   ls ~/.claude/skills/

   # Should see: bmad-orchestrator/ business-analyst/ developer/ tech-writer/ etc.

   # Check commands
   ls ~/.claude/commands/accbmad/

   # Should see: workflow-init.md, prd.md, etc.
   ```

4. **Claude Code not using default config location**

   Check if you have a custom Claude Code config:
   ```bash
   cat ~/.claude/config.json
   ```

   Ensure skill/command paths match your setup.

---

### Windows Installation

**Note:** The PowerShell installer has been deprecated. Windows users should use **WSL** (Windows Subsystem for Linux).

#### Installing via WSL

1. Install WSL if not already installed:
   ```powershell
   wsl --install
   ```

2. Open WSL terminal and navigate to the repository:
   ```bash
   cd /mnt/c/path/to/Another_Claude-Code_BMAD
   ./install-bmad-skills.sh
   ```

#### WSL Path Issues

This was fixed in v1.0.0. Update to latest version:
```bash
git pull origin main
./install-bmad-skills.sh
```

---

### Bash Installer Errors

**Symptom:** Errors when running `./install-bmad-skills.sh`

#### "Permission denied"

**Fix:** Make executable:
```bash
chmod +x install-bmad-skills.sh
./install-bmad-skills.sh
```

#### "No such file or directory"

**Fix:** Ensure you're in the correct directory:
```bash
cd Another_Claude-Code_BMAD
ls install-bmad-skills.sh  # Should exist
./install-bmad-skills.sh
```

#### Commands not installed

Update to the latest version:
```bash
git pull origin main
./install-bmad-skills.sh
```

---

## Command Errors

### "Project not initialized"

**Symptom:** Commands fail with "run /workflow-init first"

**Fix:** Initialize BMAD in your project:
```
/workflow-init
```

This creates `accbmad/config.yaml` in your project root.

---

### "Cannot find product-brief.md"

**Symptom:** `/prd` fails because it can't find the product brief

**Causes & Fixes:**

1. **Product brief not created**

   Create it first:
   ```
   /product-brief
   ```

2. **Product brief in wrong location**

   Check your output folder:
   ```yaml
   # accbmad/config.yaml
   output_folder: "docs"  # Product brief should be here
   ```

   Move file if needed:
   ```bash
   mv product-brief.md accbmad/1-analysis/product-brief.md
   ```

3. **Different output folder than expected**

   Check where BMAD is looking:
   ```
   /workflow-status
   ```

   This shows the expected file paths.

---

### "Cannot find architecture.md"

**Symptom:** `/sprint-planning` fails because architecture is missing

**Fix:** Create architecture first:
```
/architecture
```

Or if you're Level 0-1, you don't need architecture. Check your project level:
```yaml
# accbmad/config.yaml
project_level: 1  # No architecture needed
```

---

### YAML Parse Errors

**Symptom:** "YAML parse error" or "invalid syntax"

**Common causes:**

1. **Bad indentation**
   ```yaml
   # Wrong
   bmm:
   workflow_status_file: "docs/status.yaml"

   # Correct
   bmm:
     workflow_status_file: "docs/status.yaml"
   ```

2. **Unquoted special characters**
   ```yaml
   # Wrong
   project_name: My Project: v2

   # Correct
   project_name: "My Project: v2"
   ```

3. **Tabs instead of spaces**
   ```yaml
   # Wrong (tabs)
   bmm:
   	workflow_status_file: "..."

   # Correct (2 spaces)
   bmm:
     workflow_status_file: "..."
   ```

**Fix:** Validate your YAML:
```bash
# Online validator
# https://yamlvalidator.com

# Or use yamllint
pip install yamllint
yamllint accbmad/config.yaml
```

---

## Workflow Issues

### Wrong Workflow Recommended

**Symptom:** `/workflow-status` recommends the wrong next step

**Causes & Fixes:**

1. **Project level incorrect**

   Level affects what's required:
   ```yaml
   # accbmad/config.yaml
   project_level: 2  # Requires PRD, architecture
   project_level: 1  # Only tech spec needed
   ```

2. **Status file out of sync**

   Manually check status:
   ```bash
   cat accbmad/status.yaml
   ```

   Update if needed:
   ```yaml
   workflows:
     - name: "Product Brief"
       status: "complete"
       file: "accbmad/1-analysis/product-brief.md"
   ```

---

### Documents Not Saving

**Symptom:** Command completes but file not created

**Causes & Fixes:**

1. **Output directory doesn't exist**
   ```bash
   mkdir -p accbmad/4-implementation/stories
   ```

2. **Permission issues**
   ```bash
   chmod 755 docs
   ```

3. **Incorrect output_folder**
   ```yaml
   # accbmad/config.yaml
   output_folder: "docs"  # Must exist
   ```

---

### Sprint Planning Shows Wrong Stories

**Symptom:** Sprint plan doesn't match PRD stories

**Fix:** Regenerate sprint plan:
```
/sprint-planning
```

Or manually sync `accbmad/4-implementation/sprint.yaml` with your PRD.

---

### /dev-story Can't Find Story

**Symptom:** `/dev-story STORY-001` says story doesn't exist

**Causes & Fixes:**

1. **Story file not created**

   Run sprint planning first:
   ```
   /sprint-planning
   ```

2. **Wrong story ID format**
   ```
   # Wrong
   /dev-story Story-001
   /dev-story story-001

   # Correct
   /dev-story STORY-001
   ```

3. **Story in wrong directory**

   Check paths:
   ```yaml
   # accbmad/config.yaml
   paths:
     stories: "accbmad/4-implementation/stories"  # Stories should be here
   ```

---

## Configuration Issues

### Global Config Not Applied

**Symptom:** Settings from `~/.claude/config/accbmad/config.yaml` ignored

**Causes & Fixes:**

1. **Project config overrides global**

   Project settings take precedence. Check both files.

2. **Didn't restart Claude Code**

   Global config loads on startup.

3. **File in wrong location**
   ```bash
   # Should be:
   ~/.claude/config/accbmad/config.yaml

   # Not:
   ~/.claude/accbmad/config.yaml
   ```

---

### Modules Not Available

**Symptom:** `/brainstorm` not recognized (CIS module)

**Fix:** Enable module in global config:
```yaml
# ~/.claude/config/accbmad/config.yaml
modules_enabled:
  - core
  - bmm
  - cis    # Add this line
```

Then restart Claude Code.

---

### Custom Agents Not Loading

**Symptom:** Created agent with `/create-agent` but can't use it

**Causes & Fixes:**

1. **Didn't restart Claude Code**

   Agents load on startup.

2. **Agent in wrong directory**
   ```bash
   # Should be in:
   ls ~/.claude/skills/

   # Move if needed
   mv my-agent ~/.claude/skills/
   ```

3. **Invalid SKILL.md format**

   Check that SKILL.md has required sections:
   - Skill ID
   - Module
   - Purpose
   - Responsibilities
   - Commands

---

## Performance Issues

### Commands Running Slowly

**Symptom:** Commands take longer than expected

**Causes & Fixes:**

1. **Large context**

   BMAD loads previous documents. Reduce by:
   - Using lower project level
   - Splitting large documents

2. **Verbose mode enabled**
   ```yaml
   # ~/.claude/config/accbmad/config.yaml
   verbose_mode: false  # Turn off if not debugging
   ```

---

### Claude Code Hanging

**Symptom:** Claude Code stops responding during command

**Fixes:**

1. Press Ctrl+C to cancel
2. Check for infinite loops in custom agents
3. Reduce document size
4. Restart Claude Code

---

## Platform-Specific Issues

### Windows Path Issues

**Symptom:** Files not found on Windows

**Fix:** Use forward slashes in config:
```yaml
# Works on all platforms
output_folder: "docs"
workflow_status_file: "docs/status.yaml"

# Not this
output_folder: "docs\\"
workflow_status_file: "docs\\status.yaml"
```

---

### WSL Issues

**Symptom:** Commands work in Linux but not WSL

**Causes & Fixes:**

1. **Using Windows Claude Code for WSL project**

   Install Claude Code inside WSL:
   ```bash
   # Inside WSL
   curl -fsSL https://claude.ai/code/install | bash
   ```

2. **File permission issues**
   ```bash
   chmod -R 755 ~/.claude/
   ```

3. **Line ending issues**
   ```bash
   # Convert if needed
   sed -i 's/\r$//' install-bmad-skills.sh
   ```

---

### macOS Issues

**Symptom:** "Operation not permitted" errors

**Fix:** Allow terminal full disk access:
1. System Preferences → Security & Privacy → Privacy
2. Full Disk Access
3. Add your terminal app

---

## Common Error Messages

### "No active project found"

**Meaning:** BMAD can't find `accbmad/config.yaml`

**Fix:**
```
/workflow-init
```

Or ensure you're in the project root directory.

---

### "Workflow status file not found"

**Meaning:** `accbmad/status.yaml` doesn't exist

**Fix:** Create by running any workflow command, or manually:
```bash
touch accbmad/status.yaml
```

---

### "Invalid project level"

**Meaning:** Level must be 0-4

**Fix:**
```yaml
# accbmad/config.yaml
project_level: 2  # Must be 0, 1, 2, 3, or 4
```

---

### "Template not found"

**Meaning:** Missing template file

**Fix:** Reinstall BMAD:
```bash
./install-bmad-skills.sh
```

Or manually copy template from repository.

---

### "Helper reference not found"

**Meaning:** Command references missing helper section

**Fix:** Reinstall to get latest helpers.md:
```bash
./install-bmad-skills.sh
```

---

## Debugging Tips

### Enable Verbose Mode

```yaml
# ~/.claude/config/accbmad/config.yaml
verbose_mode: true
```

Restart Claude Code to see detailed logs.

---

### Check File Contents

```bash
# View configs
cat ~/.claude/config/accbmad/config.yaml
cat accbmad/config.yaml

# View status
cat accbmad/status.yaml
```

---

### Validate All YAML Files

```bash
# Install yamllint
pip install yamllint

# Check all YAML
find . -name "*.yaml" -exec yamllint {} \;
```

---

### Test Individual Commands

Before complex workflows, test simple commands:
```
/workflow-status  # Should work after init
```

---

### Reset Project State

If things are broken, start fresh:
```bash
# Backup your docs
cp -r docs docs.bak

# Remove BMAD state
rm accbmad/config.yaml
rm accbmad/status.yaml
rm accbmad/4-implementation/sprint.yaml

# Re-initialize
/workflow-init
```

---

## Getting Help

### Check Documentation

- [Getting Started](./getting-started) - Installation and first steps
- [Commands Reference](./commands/) - All command details
- [Configuration](./configuration) - All config options

### Report Issues

If you've tried the fixes above and still have problems:

1. **GitHub Issues:** [github.com/tkristner/Another_Claude-Code_BMAD/issues](https://github.com/tkristner/Another_Claude-Code_BMAD/issues)

2. **Include in your report:**
   - BMAD version (check config.yaml)
   - Operating system
   - Claude Code version
   - Error message (full text)
   - Steps to reproduce
   - Relevant config files

### Example Issue Report

```markdown
**Environment:**
- Another Claude-Code BMAD: 1.3.0
- OS: macOS 14.0
- Claude Code: 1.0.0

**Issue:**
/prd fails with "Cannot find product-brief.md"

**Steps:**
1. /workflow-init (Level 2)
2. /product-brief (completed, saved)
3. /prd

**Error:**
"Cannot find product-brief.md in docs/"

**Config:**
output_folder: "docs"

**Files present:**
accbmad/1-analysis/product-brief.md (exists)
```

---

## Updating BMAD

To update to the latest version:
```bash
git pull origin main
./install-bmad-skills.sh
```

---

## Uninstalling BMAD

To cleanly remove BMAD skills:
```bash
cd Another_Claude-Code_BMAD
./uninstall-bmad-skills.sh
```

Options:
- `-y` - Skip confirmation prompts
- `-p /path/to/project` - Also remove BMAD files from a project
- `--keep-commands` - Only remove skills, keep commands
