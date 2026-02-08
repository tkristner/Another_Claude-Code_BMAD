# Another Claude-Code BMAD

> **An optimized fork of aj-geddes's BMAD implementation for Claude Code**
>
> Experimental enhancements to the BMAD Method skills, with autonomous workflows, Agent Teams integration, enforced code reviews, and improved developer experience.

[![Version](https://img.shields.io/badge/version-1.6.0-blue.svg)](https://github.com/tkristner/Another_Claude-Code_BMAD/releases)
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
| **Agent Teams** | Smart upgrade pattern — existing commands auto-detect when multi-agent collaboration adds value |
| **Autonomous Sprint Execution** | `/dev-sprint-auto` processes all pending stories (sequential or parallel with teams) |
| **Adversarial Research** | 4 researcher agents with challenge/rebuttal rounds |
| **Multi-Lens Code Review** | 3 specialist reviewers (security, performance, testing) with debate phase |
| **Mandatory Code Review** | Enforced adversarial review with `--auto-fix` mode |
| **Double Review Pattern** | Verification review after commit catches context issues |
| **Lifecycle Hooks** | 5 hooks for session, tool use, teammate idle, and task completion |
| **Uninstall Script** | Clean removal with `uninstall-bmad-skills.sh` |

### Core BMAD Features (from original)

- **10 Specialized Skills** - AI agents for different roles (Analyst, PM, Architect, Developer, etc.)
- **37 Workflow Commands** - Slash commands for every development phase
- **4 Development Phases** - Analysis → Planning → Solutioning → Implementation
- **Quick Flow** - Fast-track workflows (`/quick-spec`, `/quick-dev`)
- **Adversarial Reviews** - Code review that finds 3-10 issues minimum

### Why This Fork?

This fork experiments with:
1. **Multi-agent collaboration** - Agent Teams with inter-agent messaging, plan approval, and shared task lists
2. **Reducing manual intervention** - Autonomous story loops instead of one-at-a-time
3. **Enforcing quality gates** - Mandatory skill invocation for code reviews
4. **Improving reliability** - Script-driven state management over instruction-following
5. **Better developer experience** - Install/uninstall scripts, lifecycle hooks

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

Based on your project level, BMAD recommends the appropriate next step.

**Quick Flow** (Level 0-1, small changes):
```
/accbmad:quick-spec  →  /accbmad:quick-dev  →  Done!
```

**Standard Flow** (Level 2+):
```
/accbmad:product-brief  →  /accbmad:prd  →  /accbmad:architecture  →  /accbmad:sprint-planning  →  /accbmad:dev-sprint-auto
```

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
**Skills:** Business Analyst, Creative Intelligence
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
**Commands:** `/accbmad:sprint-planning`, `/accbmad:dev-story`, `/accbmad:dev-sprint-auto`

Plan sprints, create stories, and implement features.

---

## Skills Overview

| Skill | Phase | Purpose |
|-------|-------|---------|
| **bmad-orchestrator** | All | Workflow management, routing, Agent Teams coordination |
| **business-analyst** | 1 | Requirements discovery |
| **product-manager** | 2 | PRD and planning |
| **ux-designer** | 2-3 | Interface design |
| **system-architect** | 3 | Technical architecture |
| **scrum-master** | 4 | Sprint planning |
| **developer** | 4 | Implementation and code review |
| **tech-writer** | Any | Documentation (README, API docs, guides) |
| **builder** | N/A | Custom agents/workflows |
| **creative-intelligence** | Any | Brainstorming/research |

---

## Commands Reference (37 commands)

### Core Workflow
- `/accbmad:workflow-init` - Initialize BMAD in project
- `/accbmad:workflow-status` - Check progress and get recommendations
- `/accbmad:generate-project-context` - Generate AI agent context rules
- `/accbmad:validate-phase-transition` - Validate outputs between phases

### Analysis (Phase 1)
- `/accbmad:product-brief` - Create product brief
- `/accbmad:brainstorm` - Structured brainstorming session
- `/accbmad:research` - Comprehensive research (auto-upgrades to team mode)

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
- `/accbmad:dev-sprint-auto` - **Autonomous sprint execution** (auto-upgrades to team mode)
- `/accbmad:quick-dev` - Quick implementation for small changes
- `/accbmad:expedited-fix` - Quick fix for urgent bugs
- `/accbmad:code-review` - Adversarial code review (auto-upgrades to team mode)
- `/accbmad:qa-automate` - Generate tests
- `/accbmad:retrospective` - Sprint retrospective

### Agent Teams (shortcuts)
- `/accbmad:team-research` - Force team mode for `/research`
- `/accbmad:team-implement` - Force team mode for `/dev-sprint-auto`
- `/accbmad:team-review` - Force team mode for `/code-review`

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

## Workflow Guide

### How to Choose a Workflow

```
What do you need?
|
+-- Bug fix or tiny change (< 1 day)
|     --> /quick-spec + /quick-dev             (Level 0)
|
+-- Small feature (1-3 features, clear scope)
|     --> /tech-spec + /dev-story              (Level 1)
|
+-- Feature set (4+ features, multiple users)
|     --> /prd + /architecture + /sprint-planning + /dev-sprint-auto   (Level 2-4)
|
+-- Urgent hotfix
|     --> /expedited-fix or /quick-dev         (any level)
|
+-- Existing project (brownfield)
|     --> /generate-project-context first, then choose path above
|
+-- Not sure?
      --> /workflow-status (shows current phase + next recommendation)
```

### Complete Flow Paths

#### Path 1: Quick Flow (Level 0-1)

For bug fixes, small tweaks, and single features:

```
/quick-spec ──> /quick-dev ──> Done!
   15-30 min     Built-in review
```

#### Path 2: Feature Addition (Level 1-2)

For adding a well-defined feature to an existing project:

```
/tech-spec ──> /create-story ──> /dev-story ──> /code-review
                                   |               (optional)
                              Full TDD cycle
```

#### Path 3: Standard Product (Level 2-3)

For new feature sets or medium-complexity projects:

```
Phase 1          Phase 2          Phase 3          Phase 4
/product-brief   /prd             /architecture    /sprint-planning
     |           /validate-prd    /check-impl-     /create-epics-stories
     v                |           readiness        /dev-sprint-auto
(optional)           v                |            /retrospective
                  Required            v
                                   Required
```

#### Path 4: Enterprise (Level 3-4)

For complex integrations or large-scale projects — all phases mandatory:

```
Phase 1                Phase 2                Phase 3                Phase 4
/product-brief         /prd                   /architecture          /sprint-planning
/brainstorm            /create-ux-design      /solutioning-gate      /create-epics-stories
/research              /validate-prd          /check-impl-readiness  /dev-sprint-auto (team)
                       /wcag-validate                                /code-review (team)
                                                                     /retrospective
```

### Requirements Workflows Comparison

| Aspect | `/quick-spec` | `/tech-spec` | `/prd` |
|--------|---------------|--------------|--------|
| **Scope** | Single change | Technical feature | Full product |
| **Duration** | 15-30 min | 30-60 min | 1-2 hours |
| **Best for** | Bug fixes, tweaks | API design, algorithms | New products, feature sets |
| **Level** | 0-1 | 1-2 | 2-4 |

### Implementation Workflows Comparison

| Aspect | `/quick-dev` | `/dev-story` | `/dev-sprint-auto` |
|--------|-------------|-------------|---------------------|
| **Input** | Problem description | Story file | Sprint with stories |
| **Scope** | Single fix | One story (TDD) | All pending stories |
| **Review** | Built-in | Built-in (Step 8) | Mandatory + auto-fix |
| **Tracking** | None | Updates sprint status | Full sprint tracking |
| **Team mode** | No | No | Yes (wave-based parallel) |

### Validation Workflows

| When | Command | What it checks |
|------|---------|---------------|
| After writing PRD | `/validate-prd` | Completeness, testability, clarity |
| Quick Phase 3 check | `/solutioning-gate-check` | Architecture exists, basic readiness |
| Before Sprint 1 | `/check-implementation-readiness` | PRD, Architecture, FR coverage, dependencies, estimates |
| Between any phases | `/validate-phase-transition` | Alignment between phase outputs |

### Anti-Patterns

| Avoid | Why | Do Instead |
|-------|-----|------------|
| Skipping `/prd` for Level 2+ | Missing requirements later | Plan properly upfront |
| Using `/dev-story` without story file | No tracking, unclear scope | Use `/quick-dev` or create story first |
| Multiple `/quick-dev` for multi-change work | Technical debt | Use stories and sprints |
| Skipping validation gates | Quality issues downstream | Always validate before next phase |

---

## Agent Teams

**v1.6.0** integrates Claude Code's Agent Teams feature directly into existing commands using a **smart upgrade pattern** - each command auto-detects when multi-agent collaboration adds value and offers the upgrade transparently.

```
User runs /accbmad:dev-sprint-auto
    |
    v
Command checks: Teams available? Multiple independent stories?
    |
    +-- Teams NOT available --> sequential mode (transparent fallback)
    +-- Scope too small -----> sequential mode (transparent fallback)
    +-- Teams + scope OK ----> PROPOSES team mode
         |
         "I can run this as a team workflow:
          - N agents working in parallel
          [T] Team (recommended) / [S] Standard"
```

### Team-Capable Commands

| Command | Team Mode Enhancement | When Team Activates |
|---------|----------------------|---------------------|
| `/dev-sprint-auto` | N parallel devs + reviewer + plan approval (wave-based) | 2+ independent stories |
| `/research` | 4 adversarial researchers (Research > Challenge > Rebuttal) | Level 2+ or complex topic |
| `/code-review` | 3 specialists (security/perf/testing) + severity debate | Level 2+ or full codebase |
| `/architecture` | Research + parallel component design + cross-review | Level 3+ or 4+ components |
| `/create-epics-stories` | Parallel writers + live FR coverage validator | Level 3+ or 4+ epics |
| `/validate-prd` | 3 parallel validators + synthesized report | Level 2+ |
| `/check-implementation-readiness` | 5 parallel checkers | Level 2+ |

All team-capable commands gracefully degrade to subagent patterns when Agent Teams are unavailable. See [BMAD-AGENT-TEAMS.md](bmad-skills/BMAD-AGENT-TEAMS.md) for the complete guide.

---

## Autonomous Sprint Execution

`/accbmad:dev-sprint-auto` implements an entire sprint with two execution modes:

### Sequential Mode (Classic)

```
For each pending story:
  1. Create git branch (story/{id})
  2. Implement all acceptance criteria (TDD)
  3. Run adversarial code review (auto-fix)
  4. Commit changes
  5. Run verification review (post-commit)
  6. Merge to develop
  7. Update sprint-status.yaml
  8. Continue to next story
```

### Team Mode (Parallel)

```
Wave 1: Independent stories run in parallel
  dev-agent-1 --+
  dev-agent-2 --+--> reviewer validates each
  dev-agent-3 --+
       |
  merge all to develop
       |
Wave 2: Stories that depended on Wave 1
  dev-agent-1 --+
  dev-agent-2 --+--> reviewer validates each
       |
  merge all to develop
```

### Usage

```bash
# Auto-detect best mode
/accbmad:dev-sprint-auto

# Force team mode
/accbmad:dev-sprint-auto --team

# Force sequential mode
/accbmad:dev-sprint-auto --sequential

# Limit to specific number
/accbmad:dev-sprint-auto --max 3

# Preview only (dry run)
/accbmad:dev-sprint-auto --dry-run
```

---

## Lifecycle Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| `bmad-session-start.sh` | SessionStart | Initialize environment |
| `bmad-pre-tool.sh` | PreToolUse | Validate tool usage |
| `bmad-post-tool.sh` | PostToolUse | Track workflow progress |
| `bmad-teammate-idle.sh` | TeammateIdle | Check for unclaimed tasks |
| `bmad-task-completed.sh` | TaskCompleted | Validate output quality + run tests |

---

## Installation Paths

After installation, files are located at:

```
~/.claude/
├── skills/
|   └── accbmad/
|       ├── bmad-orchestrator/
|       ├── business-analyst/
|       ├── product-manager/
|       ├── system-architect/
|       ├── scrum-master/
|       ├── developer/
|       ├── ux-designer/
|       ├── tech-writer/
|       ├── creative-intelligence/
|       ├── builder/
|       ├── shared/
|       └── hooks/
├── commands/
|   └── accbmad/         (37 workflow commands)
└── hooks/
```

When BMAD is initialized in a project:

```
your-project/
└── accbmad/
    ├── config.yaml              # Project configuration
    ├── status.yaml              # Workflow progress tracking
    ├── 1-analysis/              # Phase 1 outputs
    ├── 2-planning/              # Phase 2 outputs
    ├── 3-solutioning/           # Phase 3 outputs
    ├── 4-implementation/        # Phase 4 outputs
    |   └── stories/
    ├── context/                 # Subagent shared context
    ├── outputs/                 # Subagent outputs
    └── tmp/                     # Temporary workflow state
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
