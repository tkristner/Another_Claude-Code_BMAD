# Sprint Status Workflow

**Goal:** Display current sprint progress, story status breakdown, velocity metrics, and recommend next actions.

**Phase:** 4 - Implementation (Tracking)

**Agent:** Scrum Master

**Trigger keywords:** sprint status, sprint progress, backlog status, story status, what's next, burndown, velocity

**Inputs:** `accbmad/4-implementation/sprint.yaml`, story files from `accbmad/4-implementation/stories/`

**Output:** Status report with recommendations (displayed, not saved)

**Duration:** 2-5 minutes

---

## When to Use This Workflow

Use this workflow when:
- Checking current sprint progress
- Finding the next story to work on
- Reviewing what's in progress vs backlog
- Checking for blockers or stale items
- Getting velocity metrics

**Invoke:** `/sprint-status` or `/status`

---

## Workflow Steps

### Step 1: Locate Sprint Status File

**Objective:** Find and load sprint tracking data.

1. **Search for Status File**

   Look for `accbmad/4-implementation/sprint.yaml` or `.bmad/sprint-status.yaml`

2. **If Not Found**

   ```
   Sprint status file not found.

   Options:
   [P] Run sprint planning (/sprint-planning) - Creates status file
   [C] Check project docs for stories
   [S] Specify status file location
   ```

3. **If Found**

   Proceed to Step 2.

---

### Step 2: Parse Sprint Status

**Objective:** Extract and categorize all tracked items.

1. **Load Status File**

   Extract:
   - Project name and key
   - Generated timestamp
   - Story locations
   - Development status map

2. **Classify Items**

   | Item Type | Key Pattern | Example |
   |-----------|-------------|---------|
   | Epic | `epic-N` | `epic-1`, `epic-2` |
   | Story | `N-M-slug` | `1-2-user-login` |
   | Retrospective | `epic-N-retrospective` | `epic-1-retrospective` |

3. **Count by Status**

   **Story Statuses:**
   - `backlog` - Not yet ready for development
   - `ready-for-dev` - Story created, ready to implement
   - `in-progress` - Currently being implemented
   - `review` - Implementation done, in code review
   - `done` - Completed and merged

   **Epic Statuses:**
   - `backlog` - Not started
   - `in-progress` - At least one story in progress
   - `done` - All stories complete

---

### Step 3: Detect Issues and Risks

**Objective:** Identify potential problems.

**Issue Detection:**

| Condition | Risk | Recommendation |
|-----------|------|----------------|
| Story in `review` for >2 days | Stale review | Run `/code-review` |
| Story in `in-progress` with no `ready-for-dev` | Pipeline empty | Run `/create-story` |
| All epics `backlog`, no stories `ready-for-dev` | Sprint not started | Run `/sprint-planning` |
| Status file >7 days old | Stale data | Update status file |
| Epic `in-progress` with no stories | Orphaned epic | Verify epic setup |
| Story without matching epic | Orphaned story | Check story assignment |

---

### Step 4: Calculate Metrics

**Objective:** Compute velocity and progress metrics.

1. **Story Progress**

   ```
   Stories: {done}/{total} complete ({percent}%)

   Breakdown:
   - Done: {count}
   - Review: {count}
   - In Progress: {count}
   - Ready for Dev: {count}
   - Backlog: {count}
   ```

2. **Epic Progress**

   ```
   Epics: {done}/{total} complete

   Breakdown:
   - Done: {count}
   - In Progress: {count}
   - Backlog: {count}
   ```

3. **Velocity (if historical data available)**

   ```
   Velocity:
   - This sprint: {points} points
   - Average (3-sprint): {avg} points
   - Trend: {up/down/stable}
   ```

---

### Step 5: Determine Next Action

**Objective:** Recommend what to do next.

**Priority Order:**

1. **In-Progress Story Exists**

   → Continue with `/dev-story {story-id}`

   "You have work in progress. Focus on completing it."

2. **Story in Review**

   → Complete review with `/code-review {story-id}`

   "A story is waiting for code review."

3. **Ready-for-Dev Story Exists**

   → Start development with `/dev-story {story-id}`

   "Next story is ready for implementation."

4. **Only Backlog Stories**

   → Create story details with `/create-story`

   "Stories need to be detailed before development."

5. **Retrospective Available**

   → Run retrospective with `/retrospective`

   "Consider running a retrospective for the completed epic."

6. **All Done**

   → "Congratulations! All implementation items are complete."

---

### Step 6: Display Status Report

**Objective:** Present comprehensive status summary.

```
## Sprint Status

**Project:** {project_name} ({project_key})
**Status File:** accbmad/4-implementation/sprint.yaml
**Last Updated:** {timestamp}

---

### Story Progress

{done}/{total} stories complete ({percent}%)

| Status | Count | Stories |
|--------|-------|---------|
| Done | {n} | {story list} |
| Review | {n} | {story list} |
| In Progress | {n} | {story list} |
| Ready for Dev | {n} | {story list} |
| Backlog | {n} | {story list} |

### Epic Progress

{done}/{total} epics complete

| Epic | Status | Stories Done |
|------|--------|--------------|
| Epic 1: {title} | {status} | {x}/{y} |
| Epic 2: {title} | {status} | {x}/{y} |

---

### Risks & Issues

{risk list or "No issues detected"}

---

### Next Recommended Action

**{recommendation}**

Command: `{command}`
Story: {story-id} - {title}

---

[1] Run recommended workflow
[2] Show all stories by status
[3] Show velocity report
[4] Exit
```

---

### Step 7: Handle User Choice

**Objective:** Execute user's selected action.

**Option 1: Run Recommended Workflow**

```
To continue, run:
{recommended command}

For example:
/dev-story 2-3
```

**Option 2: Show All Stories**

```
### Stories by Status

**In Progress:**
- 2-3-password-reset (Epic 2)

**Ready for Dev:**
- 2-4-account-settings (Epic 2)
- 3-1-notification-preferences (Epic 3)

**Backlog:**
- 3-2-email-notifications (Epic 3)
- 3-3-push-notifications (Epic 3)

**Done:**
- 1-1-user-registration (Epic 1)
- 1-2-user-login (Epic 1)
- 2-1-profile-page (Epic 2)
- 2-2-edit-profile (Epic 2)
```

**Option 3: Show Velocity Report**

```
### Velocity Report

**Current Sprint:**
- Started: {date}
- Points planned: {n}
- Points completed: {n}
- Remaining: {n}

**Historical Velocity:**
| Sprint | Planned | Completed | Carryover |
|--------|---------|-----------|-----------|
| Sprint 3 | 40 | 35 | 5 |
| Sprint 2 | 35 | 38 | 0 |
| Sprint 1 | 30 | 32 | 0 |

**3-Sprint Average:** 35 points

**Burndown:**
Day 1: 40 pts remaining
Day 5: 28 pts remaining
Day 10: 15 pts remaining
Today: 8 pts remaining
```

---

## Status File Format

**Expected format for `accbmad/4-implementation/sprint.yaml`:**

```yaml
# Sprint Status File
# Generated by BMAD Sprint Planning

generated: 2026-02-01
project: My Project
project_key: my-project
tracking_system: bmad
story_location: accbmad/4-implementation/stories/

development_status:
  # Epic 1
  epic-1: done
  1-1-user-registration: done
  1-2-user-login: done
  epic-1-retrospective: done

  # Epic 2
  epic-2: in-progress
  2-1-profile-page: done
  2-2-edit-profile: done
  2-3-password-reset: in-progress
  2-4-account-settings: ready-for-dev
  epic-2-retrospective: optional

  # Epic 3
  epic-3: backlog
  3-1-notification-preferences: backlog
  3-2-email-notifications: backlog
  epic-3-retrospective: optional
```

---

## Notes for Claude

**Tool Usage:**
- Use Glob to find status file: `accbmad/4-implementation/sprint.yaml`
- Use Read to load status file
- Use Read to load story files for additional context
- Use TodoWrite to track any updates needed

**Key Principles:**
- Always recommend a concrete next action
- Show work in progress first (don't abandon active stories)
- Detect and surface risks proactively
- Keep output concise but complete
- Sort stories by epic and number for consistency

**Status Transitions:**
```
backlog → ready-for-dev → in-progress → review → done
```

**Velocity Calculation:**
- Sum story points of completed stories
- 3-sprint rolling average for planning
- Track carryover (incomplete stories moved to next sprint)

**Remember:**
- Sprint status is a snapshot, may need updating
- Recommend updating status when completing work
- Help user stay focused on one story at a time

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No sprint-status.yaml | "Cannot find sprint status file. Run `/sprint-planning` first." | Run sprint planning |
| No stories found | "No stories defined in sprint status." | Create stories first |
| Invalid YAML format | "Sprint status file has invalid YAML syntax." | Fix YAML syntax |
