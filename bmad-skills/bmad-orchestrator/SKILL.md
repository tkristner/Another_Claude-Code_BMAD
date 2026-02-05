---
name: bmad-orchestrator
description: Orchestrates BMAD workflows for structured AI-driven development. Use when initializing BMAD in projects, checking workflow status, or routing between 4 phases (Analysis, Planning, Solutioning, Implementation). Manages project configs, tracks progress through project levels 0-4, and coordinates with specialized workflows. Generates project context for AI agents. Trigger on /workflow-init, /workflow-status, project context, generate context, AI rules, agent guidelines, or when users need BMAD setup.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TodoWrite
---

# BMAD Orchestrator

**Purpose:** Core orchestrator for the BMAD Method (Breakthrough Method for Agile AI-Driven Development), managing workflows, tracking status, and routing users through structured development phases.

## When to Use This Skill

Use this skill when:
- User requests `/workflow-init` or `/init` - Initialize BMAD in a project
- User requests `/workflow-status` or `/status` - Check progress and get recommendations
- User mentions "BMAD setup" or "start BMAD workflow"
- Project needs structured development methodology
- Coordination between multiple development phases is required

## Core Responsibilities

1. **Project Initialization** - Set up BMAD directory structure and configuration
2. **Status Tracking** - Monitor progress across 4 development phases
3. **Workflow Routing** - Direct users to appropriate next steps based on project state
4. **Progress Management** - Maintain workflow status and completion tracking

## BMAD Method Overview

### 4 Development Phases

1. **Analysis** (Optional) - Research, brainstorming, product brief
2. **Planning** (Required) - PRD or Tech Spec based on project complexity
3. **Solutioning** (Conditional) - Architecture design for medium+ projects
4. **Implementation** (Required) - Sprint planning, stories, development

### Project Levels

- **Level 0:** Single atomic change (1 story) - Quick fixes, small tweaks
- **Level 1:** Small feature (1-10 stories) - Single feature additions
- **Level 2:** Medium feature set (5-15 stories) - Multiple related features
- **Level 3:** Complex integration (12-40 stories) - System integrations
- **Level 4:** Enterprise expansion (40+ stories) - Large-scale projects

**Planning Requirements by Level:**
- Level 0-1: Tech Spec required, PRD optional/recommended
- Level 2+: PRD required, Tech Spec optional
- Level 2+: Architecture required

## Available Commands

### /workflow-init or /init

Initialize BMAD structure in the current project.

**Steps:**
1. Create directory structure:
   ```
   accbmad/
   ├── config.yaml
   ├── status.yaml
   ├── 1-analysis/
   ├── 2-planning/
   ├── 3-solutioning/
   ├── 4-implementation/
   │   └── stories/
   ├── context/           # Subagent shared context
   ├── outputs/           # Subagent outputs
   └── tmp/               # Temporary workflow state

   .claude/commands/accbmad/ (if not exists)
   ```

2. Collect project information:
   - Project name
   - Project type (web-app, mobile-app, api, game, library, other)
   - Project level (0-4)

3. Create project config using [config.template.yaml](templates/config.template.yaml)

4. Create workflow status file with conditional requirements based on level:
   - Use [workflow-status template](templates/workflow-status.template.yaml)
   - Set PRD: required if level >= 2, else recommended
   - Set Tech-spec: required if level <= 1, else optional
   - Set Architecture: required if level >= 2, else optional

5. Display initialization summary and recommend next workflow

6. Offer to start recommended workflow

**Example interaction:**
```
User: /workflow-init

Orchestrator: I'll initialize BMAD for your project.
[Collects info, creates files...]

✓ BMAD Method initialized!

Project: MyApp
Type: web-app
Level: 2 (Medium feature set)

Configuration: accbmad/config.yaml
Status tracking: accbmad/status.yaml

Recommended next step: Create Product Brief with /product-brief
This will help define your product vision and requirements.

Would you like to start with /product-brief?
```

### /workflow-status or /status

Check project status and get recommendations for next steps.

### /generate-project-context or /analyze-codebase

Analyze existing codebase and generate comprehensive `project-context.md` file with critical rules for AI agents. Essential for brownfield projects.

**Use Cases:**
- Starting BMAD on an existing (brownfield) project
- Onboarding AI agents to legacy code
- Creating documentation from existing code
- Understanding an unfamiliar codebase

**Analysis Categories:**
1. **Technology Stack Detection** - Language, framework, dependencies (Node.js, Python, Go, Rust, Java, etc.)
2. **Project Structure Analysis** - Directory patterns, code organization
3. **Coding Convention Detection** - Naming, style, imports
4. **Testing Framework Detection** - Framework, location, patterns
5. **Quality Tool Detection** - Linters, formatters, type checkers
6. **Critical Pattern Extraction** - Error handling, logging, auth, database patterns

**Output:** `accbmad/3-solutioning/project-context.md`

**Trigger keywords:** generate project context, analyze codebase, brownfield setup, project context, ai rules, code conventions, understand codebase, reverse engineer, existing project, implementation rules, agent guidelines

See [workflows/generate-project-context.md](workflows/generate-project-context.md) for detailed workflow.

---

### /workflow-status Details

**Steps:**
1. Load project config (accbmad/config.yaml)
2. Load workflow status (accbmad/status.yaml)
3. Determine current phase and next recommended workflow
4. Display status with visual indicators
5. Offer to execute recommended workflow

**Status Indicators:**
- ✓ = Completed (shows file path)
- ⚠ = Required but not started
- → = Current phase
- - = Optional/not required

**Example interaction:**
```
User: /status

Orchestrator: Checking your project status...

Project: MyApp (Web Application, Level 2)

✓ Phase 1: Analysis
  ✓ product-brief (accbmad/1-analysis/product-brief-myapp-2025-01-11.md)

→ Phase 2: Planning [CURRENT]
  ⚠ prd (required - NOT STARTED)
  - tech-spec (optional)

Phase 3: Solutioning
  - architecture (required)

Phase 4: Implementation
  - sprint-planning (required)

Recommended next step: Create PRD with /prd command

Would you like to run /prd to create your PRD?
```

**If project not initialized:**
- Inform user BMAD not detected
- Offer to run `/workflow-init`

## Workflow Routing Logic

After determining project status, route users to specialized workflows:

### Phase 1 - Analysis
- `/product-brief` - Create comprehensive product brief
- `/brainstorm` - Structured brainstorming session
- `/research` - Market/competitive/technical research

### Phase 2 - Planning
- `/prd` - Product Requirements Document (Level 2+)
- `/tech-spec` - Technical Specification (Level 0-1)
- `/quick-spec` - Quick conversational spec (small changes)
- `/validate-prd` - Validate PRD quality
- `/create-ux-design` - UX/UI design workflow

### Phase 3 - Solutioning
- `/architecture` - System architecture design
- `/solutioning-gate-check` - Validate architecture
- `/check-implementation-readiness` - Pre-implementation gate check
- `/generate-project-context` - Generate AI agent context rules

### Phase 4 - Implementation
- `/sprint-planning` - Plan sprint iterations
- `/create-epics-stories` - Transform PRD into epics and stories
- `/create-story` - Create individual user story
- `/dev-story` - Implement user story
- `/quick-dev` - Quick implementation with built-in review
- `/code-review` - Adversarial code review (3-10 issues minimum)
- `/qa-automate` - Auto-generate tests

### Cross-Phase
- `/workflow-status` - Check progress and recommendations
- `/workflow-init` - Initialize BMAD in project
- `/validate-phase-transition` - Validate alignment between phases

**Recommendation logic:**
1. If no product-brief and project new → Recommend: `/product-brief`
2. If product-brief complete, no PRD/tech-spec:
   - Level 0-1 → Recommend: `/tech-spec` or `/quick-spec`
   - Level 2+ → Recommend: `/prd`
   - *Optional:* `/validate-phase-transition 1 2` before starting PRD
3. If PRD/tech-spec complete, no architecture, level 2+ → Recommend: `/architecture`
   - *Optional:* `/validate-phase-transition 2 3` before starting Architecture
4. If architecture complete → Recommend: `/check-implementation-readiness`
   - Or `/validate-phase-transition 3 4` for full phase validation
5. If readiness check passed → Recommend: `/sprint-planning`
6. If sprint active, no stories → Recommend: `/create-epics-stories`
7. If stories exist → Recommend: `/dev-story` on first pending story
8. If story complete → Recommend: `/code-review` or next story

**Quick Flow Path (Small Changes):**
For Level 0-1 or small brownfield changes:
1. `/quick-spec` - Fast conversational spec
2. `/quick-dev` - Implementation with built-in review
3. Done!

See [REFERENCE.md](REFERENCE.md) for detailed routing logic.

## Configuration Files

### Project Config (accbmad/config.yaml)
```yaml
project_name: "MyApp"
project_type: "web-app"  # web-app, mobile-app, api, game, library, other
project_level: 2         # 0-4
stories_folder: "accbmad/4-implementation/stories"
communication_language: "English"
```

### Workflow Status (accbmad/status.yaml)
Tracks completion of each workflow with status values:
- `"optional"` - Can be skipped
- `"recommended"` - Strongly suggested
- `"required"` - Must be completed
- `"{file-path}"` - Completed (shows output file)
- `"skipped"` - Explicitly skipped

See [templates/config.template.yaml](templates/config.template.yaml) for full template.

## Helper Scripts

Execute via Bash tool:

- **init-project.sh** - Automated project initialization
  ```bash
  bash scripts/init-project.sh --name "MyApp" --type web-app --level 2
  ```

- **check-status.sh** - Display current workflow status
  ```bash
  bash scripts/check-status.sh
  ```

- **validate-config.sh** - Validate YAML configuration
  ```bash
  bash scripts/validate-config.sh accbmad/config.yaml
  ```

See script help (`--help`) for detailed usage.

## Error Handling

**Config missing:**
- Suggest `/workflow-init`
- Explain BMAD not initialized

**Invalid YAML:**
- Show error location
- Offer to fix or reinitialize

**Template missing:**
- Use inline fallback
- Log warning
- Continue operation

**Status file inconsistent:**
- Validate against project level
- Offer to regenerate

## Integration with Other Skills

This orchestrator coordinates with specialized BMAD skills:
- `bmad-analyst` - Analysis phase workflows
- `bmad-planner` - Planning phase workflows
- `bmad-architect` - Architecture design
- `bmad-sprint-master` - Sprint and story management
- `bmad-developer` - Development workflows

When routing to these skills, pass context:
- Current project config
- Workflow status
- Project level
- Output folder location

## Token Optimization

- Use script automation for repetitive tasks
- Reference REFERENCE.md for detailed logic
- Load files only when needed
- Keep status displays concise
- Delegate detailed work to specialized skills

## Subagent Strategy

> For comprehensive subagent patterns and examples, see [BMAD-SUBAGENT-PATTERNS.md](../BMAD-SUBAGENT-PATTERNS.md)

This skill leverages parallel subagents to maximize context utilization (each agent has 200K tokens).

### Workflow Status Check Workflow
**Pattern:** Fan-Out Research
**Agents:** 3-4 parallel agents

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Check project config and validate structure | accbmad/outputs/config-status.md |
| Agent 2 | Analyze workflow status file and phase completion | accbmad/outputs/workflow-status.md |
| Agent 3 | Scan docs directory for completed artifacts | accbmad/outputs/artifacts-status.md |
| Agent 4 | Generate recommendations based on project level | accbmad/outputs/recommendations.md |

**Coordination:**
1. Launch all agents with shared project context
2. Each agent writes status findings to designated output
3. Main context synthesizes results into unified status report
4. Display visual status indicators and next steps

### Project Initialization Workflow
**Pattern:** Parallel Section Generation
**Agents:** 3 parallel agents

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Create directory structure and validate paths | accbmad/outputs/directory-setup.md |
| Agent 2 | Generate project config from template | accbmad/config.yaml |
| Agent 3 | Generate workflow status file with level-based requirements | accbmad/status.yaml |

**Coordination:**
1. Gather project information from user (sequential)
2. Launch parallel agents to create structures and configs
3. Main context validates all outputs and displays summary

### Example Subagent Prompt
```
Task: Analyze workflow status and determine current phase
Context: Read accbmad/config.yaml and accbmad/status.yaml
Objective: Identify completed workflows, current phase, and required next steps
Output: Write analysis to accbmad/outputs/workflow-status.md

Deliverables:
1. List of completed workflows with file paths
2. Current phase determination
3. Required vs optional next workflows
4. Blocking issues or missing dependencies

Constraints:
- Use project level to determine requirements
- Flag any inconsistencies in status file
```

## Special Cases

### Brownfield Project (Existing Code)

**Detection Triggers:**
- Existing source files (`.ts`, `.py`, `.go`, `.rs`, `.java`, etc.)
- Package manifest files (`package.json`, `requirements.txt`, `go.mod`, etc.)
- User mentions "existing project", "legacy code", "brownfield"
- `/workflow-init` run on non-empty directory

**When detected during `/workflow-init`:**
```
User: /workflow-init

Orchestrator: I detect this is an existing project with code.

Found:
- 47 TypeScript files
- package.json (Next.js 14)
- Existing tests in __tests__/

Would you like me to:
[A] Analyze codebase and generate project context first (recommended)
[S] Skip analysis and configure BMAD manually
[M] Manual configuration with guided questions
```

**Recommended Brownfield Path:**
1. `/generate-project-context` - Document existing patterns for AI agents (essential)
2. `/research` - Analyze existing architecture (optional)
3. `/quick-spec` or `/prd` - Define new features/changes
4. `/quick-dev` or `/dev-story` - Implement changes

**Quick Flow for Small Changes:**
```
/quick-spec → /quick-dev → Done!
```

**Brownfield Detection Commands:**
```bash
# Count source files
find . -type f \( -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.java" \) 2>/dev/null | wc -l

# Check for package files
ls package.json requirements.txt go.mod Cargo.toml pom.xml 2>/dev/null

# Check for existing tests
find . -type f \( -name "*.test.*" -o -name "*_test.*" -o -name "test_*" \) 2>/dev/null | head -5
```

**Integration with Developer Workflows:**
After context generation, `/quick-dev` and `/dev-story` automatically load `accbmad/3-solutioning/project-context.md` to ensure AI-generated code follows established patterns.

### Level 0 Project (Single Change)

```
Level 0 projects follow simplified path:
Phase 1: Optional (can skip directly to Phase 2)
Phase 2: /tech-spec or /quick-spec (lightweight requirements)
Phase 4: /quick-dev or /dev-story (single story)

Skip architecture and sprint planning for single-story work.
```

### Quick Flow Path

For small, well-defined changes (Level 0-1, brownfield enhancements):
```
/quick-spec → /quick-dev → Done!

- 15-45 min spec conversation
- Built-in code review
- No heavy documentation overhead
```

## Notes for Claude

- This is the entry point for BMAD workflows
- Always check if project is initialized before operations
- Maintain phase-based progression (don't skip required phases)
- Detect brownfield vs greenfield early
- Use TodoWrite for multi-step initialization
- Keep responses focused and actionable
- Hand off to specialized skills for detailed workflows
- Update workflow status after completing workflows
- Recommend Quick Flow for small changes

## Quick Reference

- Detailed routing logic: [REFERENCE.md](REFERENCE.md)
- **Workflow selection guide**: [../shared/resources/workflow-selection-guide.md](../shared/resources/workflow-selection-guide.md)
- Workflow phases: [resources/workflow-phases.md](resources/workflow-phases.md)
- Config template: [templates/config.template.yaml](templates/config.template.yaml)
- Init script: [scripts/init-project.sh](scripts/init-project.sh)
- Status script: [scripts/check-status.sh](scripts/check-status.sh)
