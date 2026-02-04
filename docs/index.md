---
layout: default
title: "Another Claude-Code BMAD - Optimized AI-Driven Development"
description: "An optimized fork of BMAD Skills for Claude Code with autonomous sprint execution, enforced code reviews, and improved developer experience."
keywords: "Claude Code, BMAD Method, agile development, AI development, Claude skills, autonomous development, code review"
---

<div class="hero-section" markdown="1">

# Another Claude-Code BMAD

<p class="hero-subtitle">An optimized fork of BMAD Skills for Claude Code</p>

<div class="badges">
<a href="https://github.com/tkristner/Another_Claude-Code_BMAD/releases"><img src="https://img.shields.io/badge/version-1.3.0-blue.svg" alt="Version" /></a>
<a href="https://github.com/tkristner/Another_Claude-Code_BMAD/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License" /></a>
<a href="#installation"><img src="https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20WSL-lightgrey.svg" alt="Platform" /></a>
</div>

</div>

---

## Attribution & Credits

<div class="attribution-box" markdown="1">

### Original Work

This project is a fork of **aj-geddes**'s Claude Code BMAD implementation:
- **Original Repository:** [github.com/aj-geddes/another-claude-code-bmad](https://github.com/aj-geddes/another-claude-code-bmad)

Special thanks to **aj-geddes** for the foundational work on adapting BMAD for Claude Code's native skills system.

### BMAD Method

The **BMAD Method** (Breakthrough Method for Agile AI-Driven Development) is created and maintained by the **BMAD Code Organization**:
- **Official BMAD Method:** [github.com/bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD)
- **Website:** [bmadcodes.com](https://bmadcodes.com/bmad-method/)
- **YouTube:** [@BMadCode](https://www.youtube.com/@BMadCode)
- **Discord:** [Join the community](https://discord.gg/gk8jAdXWmj)

All credit for the methodology, workflow patterns, and agent roles belongs to the BMAD Code Organization.

</div>

---

## What is This Fork?

This fork is an **experimental optimization** of the BMAD Skills for Claude Code, adding features to improve autonomous development workflows.

### Enhancements in This Fork

| Feature | Description |
|---------|-------------|
| **Autonomous Sprint Execution** | `/accbmad:dev-story-auto` processes all pending stories automatically |
| **Script-Driven Story Queue** | `story-queue.sh` manages story progression reliably |
| **Mandatory Code Review** | Enforced adversarial review with `--auto-fix` mode |
| **Double Review Pattern** | Verification review after commit catches context issues |
| **Uninstall Script** | Clean removal with `uninstall-bmad-skills.sh` |

### Core BMAD Features (from original)

- **10 Specialized Skills** - AI agents for different roles (Analyst, PM, Architect, Developer, etc.)
- **34 Workflow Commands** - Slash commands for every development phase
- **4 Development Phases** - Analysis -> Planning -> Solutioning -> Implementation
- **Quick Flow** - Fast-track workflows (`/quick-spec`, `/quick-dev`)
- **Adversarial Reviews** - Code review that finds 3-10 issues minimum

### Why This Fork?

This fork experiments with:
1. **Reducing manual intervention** - Autonomous story loops instead of one-at-a-time
2. **Enforcing quality gates** - Mandatory skill invocation for code reviews
3. **Improving reliability** - Script-driven state management over instruction-following
4. **Better developer experience** - Install/uninstall scripts, clearer documentation

---

## Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/tkristner/Another_Claude-Code_BMAD.git
cd Another_Claude-Code_BMAD

# Run the installer (Linux/macOS/WSL)
./install-bmad-skills.sh

# Restart Claude Code (skills load on startup)
```

### Initialize in Your Project

```
/accbmad:workflow-init
```

This creates:
- `accbmad/config.yaml` - Project configuration
- `accbmad/status.yaml` - Workflow tracking

### Check Status

```
/accbmad:workflow-status
```

---

## The Four Phases

### Phase 1: Analysis
**Skill:** Business Analyst
**Commands:** `/accbmad:product-brief`, `/accbmad:brainstorm`, `/accbmad:research`

Discover requirements, research markets, and define the problem space.

### Phase 2: Planning
**Skills:** Product Manager, UX Designer
**Commands:** `/accbmad:prd`, `/accbmad:tech-spec`, `/accbmad:create-ux-design`

Create comprehensive requirements and design documents.

### Phase 3: Solutioning
**Skill:** System Architect
**Commands:** `/accbmad:architecture`, `/accbmad:solutioning-gate-check`

Design system architecture and validate against requirements.

### Phase 4: Implementation
**Skills:** Scrum Master, Developer
**Commands:** `/accbmad:sprint-planning`, `/accbmad:dev-story`, `/accbmad:dev-story-auto`

Plan sprints, create stories, and implement features.

---

## Autonomous Development Mode

Version 1.3.0 introduces **autonomous sprint execution** with `/accbmad:dev-story-auto`.

### What It Does

Automatically processes **all pending stories** in your sprint:

```
/accbmad:dev-story-auto
    |
+---------------------------------------------+
|  For each pending story:                    |
|  1. Create git branch (story/{id})          |
|  2. Implement all acceptance criteria       |
|  3. Run adversarial code review (auto-fix)  |
|  4. Commit changes                          |
|  5. Run verification review (post-commit)   |
|  6. Merge to develop                        |
|  7. Update sprint-status.yaml               |
|  8. Continue to next story                  |
+---------------------------------------------+
    |
Sprint complete!
```

### Key Features

| Feature | Description |
|---------|-------------|
| **Script-Driven Loop** | Uses `story-queue.sh` to manage story queue |
| **Mandatory Code Review** | Auto-fix mode - no user prompts |
| **Double Review** | Verification review after commit catches context issues |
| **Git Workflow** | Branch per story, merge to develop |
| **HALT Conditions** | Stops on conflicts or repeated failures |

### Usage

```bash
# Process all pending stories
/accbmad:dev-story-auto

# Limit to specific number
/accbmad:dev-story-auto --max 3

# Single story only
/accbmad:dev-story-auto --story VS-002-S11

# Preview only (dry run)
/accbmad:dev-story-auto --dry-run
```

---

## Documentation

<div class="docs-grid">

<div class="docs-card">
<h3><a href="./user-manual">Manuel Utilisateur</a></h3>
<p>Guide complet en francais avec tous les workflows et bonnes pratiques.</p>
</div>

<div class="docs-card">
<h3><a href="./getting-started">Getting Started</a></h3>
<p>Installation, first steps, and your first BMAD project.</p>
</div>

<div class="docs-card">
<h3><a href="./skills/">Skills Reference</a></h3>
<p>Detailed documentation for all 10 BMAD skills.</p>
</div>

<div class="docs-card">
<h3><a href="./commands/">Commands Reference</a></h3>
<p>Complete guide to all 34 workflow commands.</p>
</div>

<div class="docs-card">
<h3><a href="./examples/">Examples</a></h3>
<p>Real-world examples and complete workflow walkthroughs.</p>
</div>

<div class="docs-card">
<h3><a href="./configuration">Configuration</a></h3>
<p>Customize BMAD for your needs.</p>
</div>

<div class="docs-card">
<h3><a href="./troubleshooting">Troubleshooting</a></h3>
<p>Common issues and solutions.</p>
</div>

</div>

---

## Project Levels

BMAD right-sizes your planning based on project complexity:

| Level | Name | Stories | Example | Required Docs |
|-------|------|---------|---------|---------------|
| 0 | Atomic | 1 | Bug fix | Tech Spec only |
| 1 | Small | 1-10 | Single feature | Tech Spec only |
| 2 | Medium | 5-15 | Feature set | PRD + Architecture |
| 3 | Complex | 12-40 | System integration | Full workflow |
| 4 | Enterprise | 40+ | Platform expansion | Full workflow + UX |

---

## Skills Overview

| Skill | Phase | Purpose |
|-------|-------|---------|
| **bmad-orchestrator** | All | Workflow management and routing |
| **business-analyst** | 1 | Requirements discovery |
| **product-manager** | 2 | PRD and planning |
| **ux-designer** | 2-3 | Interface design |
| **system-architect** | 3 | Technical architecture |
| **scrum-master** | 4 | Sprint planning |
| **developer** | 4 | Implementation |
| **tech-writer** | Any | Documentation (README, API docs, guides) |
| **builder** | N/A | Custom agents/workflows |
| **creative-intelligence** | Any | Brainstorming/research |

---

## Installation Paths

After installation, files are located at:

```
~/.claude/
+-- skills/
|   +-- accbmad/
|       +-- bmad-orchestrator/
|       +-- business-analyst/
|       +-- product-manager/
|       +-- system-architect/
|       +-- scrum-master/
|       +-- developer/
|       +-- ux-designer/
|       +-- tech-writer/
|       +-- creative-intelligence/
|       +-- builder/
|       +-- shared/
|       +-- examples/
+-- commands/
|   +-- accbmad/
|       +-- workflow-init.md
|       +-- workflow-status.md
|       +-- dev-story-auto.md
|       +-- ... (34 workflow commands)
+-- hooks/
```

---

## Uninstallation

To remove BMAD skills:

```bash
cd Another_Claude-Code_BMAD
./uninstall-bmad-skills.sh
```

Options:
```bash
./uninstall-bmad-skills.sh -y              # Skip confirmation
./uninstall-bmad-skills.sh -p /path/to/project  # Also clean project BMAD files
./uninstall-bmad-skills.sh --keep-commands  # Only remove skills
```

---

## Community & Support

- **Issues:** [GitHub Issues](https://github.com/tkristner/Another_Claude-Code_BMAD/issues)
- **Original Fork:** [aj-geddes/another-claude-code-bmad](https://github.com/aj-geddes/another-claude-code-bmad)
- **Original BMAD Method:** [bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.3.0 | 2026-02 | Autonomous sprint execution, mandatory code review, double review pattern, uninstall script |
| 1.1.0 | 2026-01 | Script-driven story queue, improved documentation |
| 1.0.0 | 2025-12 | Initial fork with 10 skills, 34 workflow commands |

---

<div class="cta-section">
<p>Ready to transform your development workflow?</p>
<a href="./getting-started">Get Started</a>
</div>
