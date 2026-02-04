# Another Claude-Code BMAD

> **An optimized fork of aj-geddes's BMAD implementation for Claude Code**
>
> Experimental enhancements to the BMAD Method skills, focusing on autonomous workflows, enforced code reviews, and improved developer experience.

[![Version](https://img.shields.io/badge/version-1.3.0-blue.svg)](https://github.com/tkristner/Another_Claude-Code_BMAD/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20WSL-lightgrey.svg)](#installation)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Native-orange.svg)](https://claude.ai/code)

---

## Attribution & Credits

### Original Work

This project is a fork of **aj-geddes**'s Claude Code BMAD implementation:

- **Original Repository**: https://github.com/aj-geddes/another-claude-code-bmad

Special thanks to **aj-geddes** for the foundational work on adapting BMAD for Claude Code's native skills system. This fork builds upon that excellent foundation.

### BMAD Method

The **BMAD Method** (Breakthrough Method for Agile AI-Driven Development) is created and maintained by the **BMAD Code Organization**.

**All credit for the BMAD methodology belongs to:**

- **BMAD Code Organization**: https://github.com/bmad-code-org
- **Official BMAD Method**: https://github.com/bmad-code-org/BMAD-METHOD
- **Website**: https://bmadcodes.com/bmad-method/
- **YouTube**: [@BMadCode](https://www.youtube.com/@BMadCode)
- **Discord Community**: https://discord.gg/gk8jAdXWmj

The methodology, workflow patterns, agent roles, and all BMAD concepts are the intellectual property of the BMAD Code Organization.

**Please support the original creators** by visiting their resources above.

---

## What is This Fork?

This fork is an **experimental optimization** of the BMAD Skills for Claude Code, adding features to improve autonomous development workflows.

### Enhancements in This Fork

| Feature | Description |
|---------|-------------|
| **Autonomous Sprint Execution** | `/dev-story-auto` processes all pending stories automatically |
| **Script-Driven Story Queue** | `story-queue.sh` manages story progression reliably |
| **Mandatory Code Review** | Enforced adversarial review with `--auto-fix` mode |
| **Double Review Pattern** | Verification review after commit catches context issues |
| **Uninstall Script** | Clean removal with `uninstall-bmad-skills.sh` |

### Core BMAD Features (from original)

- **10 Specialized Skills** - AI agents for different roles (Analyst, PM, Architect, Developer, etc.)
- **34 Workflow Commands** - Slash commands for every development phase
- **4 Development Phases** - Analysis → Planning → Solutioning → Implementation
- **Quick Flow** - Fast-track workflows (`/quick-spec`, `/quick-dev`)
- **Adversarial Reviews** - Code review that finds 3-10 issues minimum

### Why This Fork?

This fork experiments with:
1. **Reducing manual intervention** - Autonomous story loops instead of one-at-a-time
2. **Enforcing quality gates** - Mandatory skill invocation for code reviews
3. **Improving reliability** - Script-driven state management over instruction-following
4. **Better developer experience** - Install/uninstall scripts, clearer documentation

---

## Installation

### Requirements

- Claude Code installed and configured
- Bash shell (Linux, macOS, or WSL on Windows)

### Quick Install

```bash
# Clone the repository
git clone https://github.com/tkristner/Another_Claude-Code_BMAD.git
cd Another_Claude-Code_BMAD

# Run the installer
./install-bmad-skills.sh

# Restart Claude Code (skills load on startup)
```

### Windows Users

Windows users should use **WSL** (Windows Subsystem for Linux):

```powershell
# Install WSL if needed
wsl --install

# Then in WSL terminal:
cd /mnt/c/path/to/Another_Claude-Code_BMAD
./install-bmad-skills.sh
```

### Verify Installation

After restarting Claude Code:

```
/accbmad:workflow-status
```

---

## Quick Start

### 1. Initialize BMAD in your project

```
/accbmad:workflow-init
```

This creates:
- `accbmad/config.yaml` - Project configuration
- `accbmad/status.yaml` - Workflow tracking

### 2. Check status and get recommendations

```
/accbmad:workflow-status
```

### 3. Follow the recommended workflow

Based on your project level, BMAD will recommend the appropriate next step.

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
**Commands:** `/accbmad:sprint-planning`, `/accbmad:create-story`, `/accbmad:dev-story`

Plan sprints, create stories, and implement features.

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

## Commands Reference (34 commands)

### Core Workflow
- `/accbmad:workflow-init` - Initialize BMAD in project
- `/accbmad:workflow-status` - Check progress and get recommendations
- `/accbmad:generate-project-context` - Generate AI agent context rules
- `/accbmad:validate-phase-transition` - Validate outputs between phases

### Analysis (Phase 1)
- `/accbmad:product-brief` - Create product brief
- `/accbmad:brainstorm` - Structured brainstorming session
- `/accbmad:research` - Comprehensive research

### Planning (Phase 2)
- `/accbmad:prd` - Create Product Requirements Document
- `/accbmad:tech-spec` - Create Technical Specification
- `/accbmad:quick-spec` - Lightweight spec for small changes
- `/accbmad:validate-prd` - Validate PRD quality
- `/accbmad:create-ux-design` - Create UX design
- `/accbmad:wcag-validate` - Validate WCAG accessibility
- `/accbmad:check-contrast` - Check color contrast ratios

### Solutioning (Phase 3)
- `/accbmad:architecture` - Create system architecture
- `/accbmad:solutioning-gate-check` - Validate implementation readiness
- `/accbmad:check-implementation-readiness` - Comprehensive Phase 3 gate check

### Implementation (Phase 4)
- `/accbmad:sprint-planning` - Plan sprint
- `/accbmad:create-story` - Create user story
- `/accbmad:create-epics-stories` - Create epics and stories
- `/accbmad:dev-story` - Implement a story
- `/accbmad:dev-story-auto` - **Autonomous sprint execution** (implements all pending stories)
- `/accbmad:quick-dev` - Quick implementation for small changes
- `/accbmad:expedited-fix` - Quick fix for urgent bugs
- `/accbmad:code-review` - Adversarial code review
- `/accbmad:qa-automate` - Generate tests
- `/accbmad:retrospective` - Sprint retrospective

### Documentation (Tech Writer)
- `/accbmad:readme` - Generate README file
- `/accbmad:api-docs` - Generate API documentation
- `/accbmad:user-guide` - Create user guide
- `/accbmad:changelog` - Maintain changelog
- `/accbmad:architecture-docs` - Document system architecture

### Meta (Builder)
- `/accbmad:create-agent` - Create custom agent
- `/accbmad:create-workflow` - Create custom workflow

---

## Autonomous Development Mode

Another Claude-Code BMAD v1.3.0 introduces **autonomous sprint execution** with `/accbmad:dev-story-auto`.

### What It Does

Automatically processes **all pending stories** in your sprint:

```
/accbmad:dev-story-auto
    ↓
┌─────────────────────────────────────────────┐
│  For each pending story:                    │
│  1. Create git branch (story/{id})          │
│  2. Implement all acceptance criteria       │
│  3. Run adversarial code review (auto-fix)  │
│  4. Commit changes                          │
│  5. Run verification review (post-commit)   │
│  6. Merge to develop                        │
│  7. Update sprint-status.yaml               │
│  8. Continue to next story                  │
└─────────────────────────────────────────────┘
    ↓
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

## Installation Paths

After installation, files are located at:

```
~/.claude/
├── skills/
│   └── accbmad/
│       ├── bmad-orchestrator/
│       ├── business-analyst/
│       ├── product-manager/
│       ├── system-architect/
│       ├── scrum-master/
│       ├── developer/
│       ├── ux-designer/
│       ├── tech-writer/
│       ├── creative-intelligence/
│       ├── builder/
│       ├── shared/
│       └── examples/
├── commands/
│   └── accbmad/
│       ├── workflow-init.md
│       ├── workflow-status.md
│       ├── dev-story-auto.md
│       └── ... (34 workflow commands)
└── hooks/
```

---

## Documentation

Full documentation is available at the [GitHub Pages site](https://tkristner.github.io/Another_Claude-Code_BMAD/):

- [Getting Started](https://tkristner.github.io/Another_Claude-Code_BMAD/getting-started)
- [User Manual (French)](https://tkristner.github.io/Another_Claude-Code_BMAD/user-manual)
- [Skills Reference](https://tkristner.github.io/Another_Claude-Code_BMAD/skills/)
- [Commands Reference](https://tkristner.github.io/Another_Claude-Code_BMAD/commands/)
- [Configuration](https://tkristner.github.io/Another_Claude-Code_BMAD/configuration)
- [Troubleshooting](https://tkristner.github.io/Another_Claude-Code_BMAD/troubleshooting)

---

## Uninstallation

To remove BMAD skills, use the uninstall script:

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

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Support

- **Issues**: [GitHub Issues](https://github.com/tkristner/Another_Claude-Code_BMAD/issues)
- **Original BMAD Method**: [bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD)
