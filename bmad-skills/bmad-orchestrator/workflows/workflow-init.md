# [Orchestrator] Workflow Init

You are executing the **Workflow Init** command to initialize BMAD Method in the current project.

## Purpose
Set up BMAD Method structure and configuration in the current project, with automatic detection and migration of artifacts from legacy BMAD directory structures.

## Execution

### Step 1: Activate Skill
1. Activate the **bmad-orchestrator** skill

### Step 2: Legacy Migration Detection
Before creating any new structure, check for artifacts from previous BMAD versions.

1. Run the detection script:
   ```bash
   bash bmad-skills/bmad-orchestrator/scripts/migrate-legacy.sh --detect
   ```

2. **If output starts with `NO_LEGACY_ARTIFACTS_FOUND`** → skip to Step 3.

3. **If output starts with `LEGACY_ARTIFACTS_DETECTED`** → present the inventory to the user, grouped by phase. Example:

   ```
   ## Legacy BMAD Artifacts Detected

   ### Phase 1 - Analysis (2 files)
   - docs/product-brief-myapp.md → accbmad/1-analysis/product-brief-myapp.md
   - docs/research-market.md → accbmad/1-analysis/research-market.md

   ### Phase 2 - Planning (1 file)
   - bmad/prd-myapp.md → accbmad/2-planning/prd-myapp.md

   ### Status Files (1 file)
   - bmad/workflow-status.yaml (needs manual review)
   ```

4. Ask the user:
   ```
   [M] Migrate all — copy all ready artifacts to accbmad/
   [S] Select which — choose specific files to migrate
   [K] Skip — start fresh (no migration)
   ```

5. **If Migrate All or Select:**
   - Write a manifest file to `accbmad/tmp/migration-manifest.txt` with one `source|destination` per line for each file to migrate
   - For **Select** mode: present numbered list, let user pick which files
   - Run the execution script:
     ```bash
     bash bmad-skills/bmad-orchestrator/scripts/migrate-legacy.sh --execute --manifest accbmad/tmp/migration-manifest.txt
     ```
   - Report results to user

6. **After migration — update status.yaml:**
   - For each migrated artifact, set the corresponding workflow entry in `accbmad/status.yaml` to the new file path (which means "completed" per the status format)
   - Example: if `prd-myapp.md` was migrated to `accbmad/2-planning/prd-myapp.md`, set the `prd` workflow status to `"accbmad/2-planning/prd-myapp.md"`

7. **Status file handling** (entries marked `needs_transform`):
   - Read the legacy status file content
   - Extract any completed workflow entries
   - Map them to new status entries in `accbmad/status.yaml`
   - Inform user of any entries that could not be mapped

8. **CLAUDE.md integration:**
   - If `DEVELOPMENT-GUARDRAILS.md` was found among legacy artifacts, **do NOT migrate it to `accbmad/`**. Instead, inform the user:
     ```
     ℹ DEVELOPMENT-GUARDRAILS.md detected — this file is now part of the BMAD package.
       It is installed globally to ~/.claude/DEVELOPMENT-GUARDRAILS.md by install-bmad-skills.sh.
       Ensure you have run the BMAD installer to get the latest version.
     ```
   - If `~/.claude/CLAUDE.md` does not already reference the guardrails, add:
     ```
     ## CRITICAL: Development Guardrails
     **BEFORE writing ANY code, Claude MUST read:**
     - `~/.claude/DEVELOPMENT-GUARDRAILS.md`
     ```
   - Also update any existing `docs/` or `bmad/` path references in `CLAUDE.md` to point to their new `accbmad/` locations

### Step 3: Check Configuration
2. Check for existing `accbmad/config.yaml`

### Step 4: Create Structure
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
   ├── outputs/
   └── tmp/               # Temporary workflow state
   ```

### Step 5: Configure Project
4. Collect project info (name, type, level 0-4)
5. Create configuration files

### Step 6: Finalize
6. Show recommended workflow path based on level
7. If migration was performed, highlight which phases already have completed artifacts

## Project Levels
- Level 0: Single change (1 story) → Tech Spec only
- Level 1: Small feature (1-10 stories) → Tech Spec required
- Level 2: Medium (5-15 stories) → PRD + Architecture required
- Level 3: Complex (12-40 stories) → PRD + Architecture required
- Level 4: Enterprise (40+ stories) → Full documentation suite

## Legacy Migration Notes
- Files are **copied, never moved** — originals remain untouched
- Existing files in `accbmad/` are **never overwritten**
- Legacy directories scanned: `docs/`, `bmad/`, `.bmad/`
- Migration is fully optional — user controls what gets migrated
- Status files from old formats are flagged for Claude to interpret and map

## Next Steps
After initialization, recommend the appropriate first workflow based on project level. If migration populated some phases, skip those in the recommendation.
