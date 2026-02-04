---
layout: default
title: "Getting Started"
description: "Installation guide and first steps for Another Claude-Code BMAD."
keywords: "BMAD installation, Claude Code setup, BMAD getting started"
---

# Getting Started

This guide walks you through installing Another Claude-Code BMAD and running your first workflow.

---

## Prerequisites

- **Claude Code** installed and working
- **Git** for cloning the repository
- Bash terminal (Linux/macOS/WSL)

---

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/tkristner/Another_Claude-Code_BMAD.git
cd Another_Claude-Code_BMAD
```

### Step 2: Run the Installer

```bash
./install-bmad-skills.sh
```

**What it does:**
- Installs 10 skills to `~/.claude/skills/accbmad/`
- Installs 34 workflow commands to `~/.claude/commands/accbmad/`
- Installs shared resources and hooks

### Step 3: Restart Claude Code

Skills are loaded on startup. Restart Claude Code after installation.

### Step 4: Verify Installation

```
/accbmad:workflow-status
```

If you see the workflow status, BMAD is installed correctly.

---

## Initialize a Project

Navigate to your project and initialize BMAD:

```
/accbmad:workflow-init
```

This creates:
- `accbmad/config.yaml` - Project configuration
- `accbmad/status.yaml` - Workflow tracking

---

## Project Levels

BMAD adapts workflow complexity based on project size:

| Level | Scope | Required Workflow |
|-------|-------|-------------------|
| 0 | Bug fix, single change | Tech Spec → Dev |
| 1 | Small feature (1-10 stories) | Tech Spec → Sprint → Dev |
| 2 | Feature set (5-15 stories) | PRD → Architecture → Sprint → Dev |
| 3-4 | Complex/Enterprise | Full BMAD workflow |

---

## Basic Workflow

### Level 0-1 (Small Projects)

```
/accbmad:workflow-init     # Initialize
/accbmad:tech-spec         # Define requirements
/accbmad:sprint-planning   # Plan stories
/accbmad:dev-story         # Implement
```

### Level 2+ (Larger Projects)

```
/accbmad:workflow-init     # Initialize
/accbmad:product-brief     # Discovery (optional)
/accbmad:prd               # Requirements
/accbmad:architecture      # System design
/accbmad:sprint-planning   # Plan sprints
/accbmad:dev-story         # Implement stories
```

---

## Quick Reference

### Core Commands

| Command | Purpose |
|---------|---------|
| `/accbmad:workflow-init` | Initialize BMAD in project |
| `/accbmad:workflow-status` | Check progress |
| `/accbmad:tech-spec` | Technical specification |
| `/accbmad:prd` | Product requirements |
| `/accbmad:architecture` | System design |
| `/accbmad:sprint-planning` | Plan iterations |
| `/accbmad:dev-story` | Implement a story |
| `/accbmad:dev-story-auto` | Autonomous sprint execution |

### Project Structure

After initialization:

```
your-project/
└── accbmad/
    ├── config.yaml
    ├── status.yaml
    ├── 1-analysis/
    │   └── product-brief.md
    ├── 2-planning/
    │   ├── prd.md
    │   └── tech-spec.md
    ├── 3-solutioning/
    │   └── architecture.md
    └── 4-implementation/
        ├── sprint.yaml
        └── stories/
            └── STORY-XXX.md
```

---

## Next Steps

- [Skills Reference](./skills/) - All 10 BMAD skills
- [Commands Reference](./commands/) - All 34 commands
- [Configuration](./configuration) - Customize BMAD
- [Troubleshooting](./troubleshooting) - Common issues

---

**Need help?** [Open an issue](https://github.com/tkristner/Another_Claude-Code_BMAD/issues)
