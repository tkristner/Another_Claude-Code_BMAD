# [Orchestrator] Workflow Init

You are executing the **Workflow Init** command to initialize BMAD Method in the current project.

## Purpose
Set up BMAD Method structure and configuration in the current project.

## Execution
1. Activate the **bmad-orchestrator** skill
2. Check for existing `accbmad/config.yaml`
3. Create project structure:
   ```
   accbmad/
   ├── config.yaml
   ├── status.yaml
   ├── 1-analysis/
   ├── 2-planning/
   ├── 3-solutioning/
   ├── 4-implementation/
   │   └── stories/
   ├── context/
   └── outputs/
   ```
4. Collect project info (name, type, level 0-4)
5. Create configuration files
6. Show recommended workflow path based on level

## Project Levels
- Level 0: Single change (1 story) → Tech Spec only
- Level 1: Small feature (1-10 stories) → Tech Spec required
- Level 2: Medium (5-15 stories) → PRD + Architecture required
- Level 3: Complex (12-40 stories) → PRD + Architecture required
- Level 4: Enterprise (40+ stories) → Full documentation suite

## Next Steps
After initialization, recommend the appropriate first workflow based on project level.
