# Dev Story Auto Workflow

**Goal:** Autonomous story implementation with automatic code review, fixes, and git management

**Phase:** 4 - Implementation (Autonomous Mode)

**Agent:** Developer

**Trigger keywords:** dev story auto, auto dev, autonomous dev, implement all stories, auto implement, sprint auto, continuous dev

**Inputs:** Sprint status file with ready-for-dev stories

**Output:** Implemented stories with commits on develop branch

**Duration:** Variable (depends on story count and complexity)

---

## When to Use

- Multiple stories ready for implementation
- Want hands-off development cycle
- Trust automated code review and fixes
- Clean sprint backlog ready to execute

**Invoke:** `/dev-story-auto` or `/dev-story-auto --epic {N}` or `/dev-story-auto --max {N}`

---

## Pre-Flight

1. **Load sprint status** - Read `accbmad/4-implementation/sprint.yaml`
2. **Verify git state** - Must be on develop, working tree clean
3. **Find ready stories** - Filter stories with status `ready-for-dev`
4. **Load project context** - Read `docs/project-context.md` if exists

**Pre-Flight Checks:**
```bash
# Must pass before starting
git status --porcelain  # Must be empty (clean)
git branch --show-current  # Must be "develop"
```

---

## Workflow Loop

For each story in queue:

### Step 1: Prepare Git Branch

```bash
# Ensure we're on latest develop
git checkout develop
git pull origin develop 2>/dev/null || true

# Create story branch
git checkout -b story/{story-id}
```

**Branch naming:** `story/{epic}-{story}-{slug}`
- Example: `story/2-3-password-reset`

---

### Step 2: Execute Dev-Story

Run the standard dev-story workflow for current story:

1. Load story file from `accbmad/4-implementation/stories/{story-id}.md`
2. Implement all acceptance criteria
3. Write/update tests
4. Ensure all tests pass

**Pass criteria:**
- All acceptance criteria implemented
- Tests written and passing
- No linter errors

---

### Step 3: Execute Code Review (Auto-Fix Mode)

Run adversarial code review with **automatic fix mode**:

1. Review all changes in current branch
2. Identify issues (security, quality, patterns)
3. **Automatically apply fixes** (no user prompt)
4. Re-verify after fixes

**Auto-Fix Rules:**
- Security issues: Fix immediately
- Code quality issues: Fix immediately
- Pattern violations: Fix immediately
- Style issues: Fix immediately

**Max fix iterations:** 3
- If still failing after 3 rounds → HALT and notify user

**Code Review Command (internal):**
```
Execute /code-review with AUTO_FIX=true
- Do not prompt user for [A] Fix All
- Automatically apply all recommended fixes
- Re-run review after fixes
- Continue until clean or max iterations
```

---

### Step 4: Git Commit

Once code review passes:

```bash
# Stage all changes
git add -A

# Commit with conventional format
git commit -m "feat({scope}): {story-title}

Implements story {story-id}
- {acceptance-criteria-1}
- {acceptance-criteria-2}
- {acceptance-criteria-3}

Code-reviewed and auto-fixed.

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

### Step 5: Final Verification Code Review

**Important:** Run a second code-review pass after commit to catch any issues that may have been missed due to context limitations.

1. Re-read all changed files in the branch
2. Run code-review one more time (verification mode)
3. If new issues found:
   - Apply fixes automatically
   - Amend commit: `git add -A && git commit --amend --no-edit`
4. If clean → proceed to merge

**Why this step:**
- Context compaction during long sessions can cause missed issues
- Fresh review after commit ensures nothing was overlooked
- Final safety gate before merge to develop

---

### Step 6: Merge to Develop

Once final verification passes:

```bash
# Merge to develop
git checkout develop
git merge story/{story-id} --no-ff -m "Merge story/{story-id}: {title}"

# Delete story branch
git branch -d story/{story-id}
```

---

### Step 7: Update Sprint Status

Update `accbmad/4-implementation/sprint.yaml`:

```yaml
development_status:
  {story-id}: done  # was: ready-for-dev
```

---

### Step 8: Next Story or Complete

**If more stories in queue:**
- Log completion: `✓ Story {story-id} complete`
- Continue to Step 1 with next story

**If queue empty:**
- Log summary
- Exit workflow

---

## Progress Display

During execution, show:

```
╔══════════════════════════════════════════════════════════════╗
║  DEV-STORY-AUTO: Sprint Progress                             ║
╠══════════════════════════════════════════════════════════════╣
║  Stories: 2/5 complete                                       ║
║  Current: 2-3-password-reset                                 ║
║  Phase:   Code Review (fix iteration 1/3)                    ║
╠══════════════════════════════════════════════════════════════╣
║  ✓ 2-1-profile-page         [done]                          ║
║  ✓ 2-2-edit-profile         [done]                          ║
║  → 2-3-password-reset       [in-progress]                   ║
║  ○ 2-4-account-settings     [queued]                        ║
║  ○ 2-5-user-preferences     [queued]                        ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Command Options

| Option | Description | Example |
|--------|-------------|---------|
| (none) | All ready-for-dev stories | `/dev-story-auto` |
| `--epic N` | Only stories from epic N | `/dev-story-auto --epic 2` |
| `--story ID` | Single specific story | `/dev-story-auto --story 2-3` |
| `--max N` | Maximum N stories then pause | `/dev-story-auto --max 3` |
| `--no-merge` | Commit but don't merge to develop | `/dev-story-auto --no-merge` |
| `--dry-run` | Show plan without executing | `/dev-story-auto --dry-run` |

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| Git not clean | "Working tree has uncommitted changes." | Commit or stash changes |
| Not on develop | "Must start from develop branch." | `git checkout develop` |
| No ready stories | "No stories with status 'ready-for-dev'." | Update sprint-status |
| Code review fails 3x | "Story {id} failed code review after 3 fix attempts." | Manual intervention |
| Tests failing | "Tests failing after implementation." | Manual fix required |
| Merge conflict | "Merge conflict on story {id}." | Manual resolution |
| Story file missing | "Cannot find story file: {path}" | Create story file |

---

## Recovery After HALT

If workflow halts mid-sprint:

1. Fix the blocking issue manually
2. Resume with: `/dev-story-auto --story {failed-story-id}`
3. Or skip and continue: update sprint-status, then `/dev-story-auto`

---

## Example Session

```
User: /dev-story-auto --epic 2

Developer:
Starting autonomous development for Epic 2...

Pre-flight checks:
✓ Git working tree clean
✓ On develop branch
✓ Sprint status loaded
✓ Project context loaded

Found 4 stories ready for development:
1. 2-1-profile-page (5 pts)
2. 2-2-edit-profile (3 pts)
3. 2-3-password-reset (5 pts)
4. 2-4-account-settings (3 pts)

Starting story 2-1-profile-page...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Git] Created branch: story/2-1-profile-page
[Dev] Implementing acceptance criteria...
[Dev] Writing tests...
[Dev] Tests passing: 12/12
[Review] Running adversarial code review...
[Review] Found 3 issues, applying fixes...
[Review] Fix iteration 1/3...
[Review] All issues resolved ✓
[Git] Committed: feat(profile): implement user profile page
[Git] Merged to develop
[Status] Updated: 2-1-profile-page → done

✓ Story 2-1-profile-page complete (4m 32s)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Starting story 2-2-edit-profile...
...

═══════════════════════════════════════
Sprint Auto Complete!

Stories completed: 4/4
Total time: 18m 45s
Commits: 4
All merged to develop ✓
═══════════════════════════════════════
```

---

## Integration

**Requires:**
- `accbmad/4-implementation/sprint.yaml` with story statuses
- `accbmad/4-implementation/stories/{story-id}.md` for each story
- Clean git repository on develop branch

**Calls internally:**
- `/dev-story` workflow (per story)
- `/code-review` workflow (with auto-fix flag)

**Updates:**
- `accbmad/4-implementation/sprint.yaml` (story status → done)
- Git branches and commits

---

## Notes for Claude

**CRITICAL - THIS IS A LOOP:**
- You MUST continue processing stories until ALL pending stories are done
- Do NOT stop after completing one story
- Do NOT ask user "should I continue?" - just continue automatically
- The only valid stop conditions are: no more stories, HALT condition, or --max limit

**MANDATORY CODE REVIEW (MUST FIND ISSUES):**
- You MUST run adversarial code review on EVERY story before committing
- You MUST find at least 3 issues - if you find 0, review harder
- "Code looks clean" is NOT acceptable - that means you didn't look hard enough
- List each issue found in a table: Severity | File:Line | Issue | Fix
- Auto-fix all issues, then verify fixes worked
- Run a SECOND verification review AFTER committing
- Be your own WORST critic - assume there ARE bugs

**Execution Mode:**
- This is an autonomous workflow - minimize user interaction
- Only HALT on blocking issues that require human decision
- Auto-fix all code review issues without prompting

**Git Safety:**
- Always verify clean state before starting
- Use `--no-ff` merges to preserve history
- Delete story branches after successful merge
- Never force push or rewrite history

**Progress Tracking:**
- Update sprint-status.yaml after EACH story (not at end)
- This allows recovery if workflow is interrupted
- Show clear progress indicators throughout

**Code Review Integration:**
- Run your own adversarial review - look for security, quality, test gaps
- Apply fixes automatically and re-verify
- Max 3 iterations before HALT
- DO NOT skip this step - it is mandatory

**Error Handling:**
- Catch and report errors clearly
- Leave repository in clean state if possible
- Provide clear recovery instructions

**REMEMBER: After completing a story, IMMEDIATELY start the next one. Do not stop.**

---

*Generated by BMAD Method - Developer Skill*
