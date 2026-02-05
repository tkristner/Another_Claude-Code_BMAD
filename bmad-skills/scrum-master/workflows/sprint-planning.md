# [Scrum Master] Sprint Planning Workflow

**Goal:** Plan sprint iterations with detailed, estimated stories allocated by capacity

**Phase:** 4 - Implementation (Planning)

**Agent:** Scrum Master

**Trigger keywords:** sprint planning, plan sprint, allocate stories, sprint capacity, velocity planning, sprint allocation

**Inputs:** PRD or tech-spec, Architecture (if Level 2+), Epics/Stories document, Team capacity

**Output:** `docs/sprint-plan-{project-name}-{date}.md`, `bmad/sprint-status.yaml`

**Duration:** 30-90 minutes depending on project level

---

## When to Use This Workflow

Use this workflow when:
- Epics and stories have been created (`/create-epics-stories`)
- Ready to allocate work to sprints
- Need to calculate team capacity and velocity
- Planning implementation timeline

**Invoke:** `/sprint-planning`

---

## Pre-Flight

1. **Load project config** - Check `accbmad/config.yaml`
2. **Load planning documents:**
   - PRD: `accbmad/2-planning/prd-*.md`
   - Tech-spec: `accbmad/2-planning/tech-spec-*.md` (if no PRD)
   - Architecture: `accbmad/3-solutioning/architecture-*.md` (Level 2+)
   - Epics: `docs/epics.md`
3. **Check existing sprint status** - `bmad/sprint-status.yaml`
   - If exists: Resume or plan next sprint
   - If not: First-time sprint planning
4. **Extract project level** (0-4) from config

---

## Workflow Steps

### Part 1: Inventory Stories

**Objective:** Collect all stories with estimates.

1. **Load epics document** and extract all stories
2. **Verify each story has:**
   - Story ID (STORY-001, etc.)
   - Title
   - Epic assignment
   - Priority (Must/Should/Could Have)
   - Story points estimate
   - Acceptance criteria

3. **Create story inventory:**
   ```
   Story Inventory:
   - Total Stories: {count}
   - Total Points: {sum}
   - Must Have: {count} stories, {points} points
   - Should Have: {count} stories, {points} points
   - Could Have: {count} stories, {points} points
   ```

4. **Flag issues:**
   - Stories without estimates
   - Stories >8 points (need breakdown)
   - Missing acceptance criteria

---

### Part 2: Calculate Team Capacity

**Objective:** Determine sprint capacity in story points.

**Ask user for inputs:**
```
Sprint Capacity Questions:

1. Team size (developers): [default: 1]
2. Sprint length (weeks): [default: 2]
3. Productive hours/day: [Junior: 4, Mid: 5, Senior: 6]
4. Holidays or PTO this sprint: [days]
5. Known velocity (points/sprint, if available): [optional]
```

**Calculate capacity:**
```
If velocity known:
  Capacity = historical velocity

If no velocity:
  Total hours = team_size × (sprint_days - pto) × hours_per_day
  Capacity = total_hours ÷ hours_per_point

  Hours per point:
  - Junior team: 4 hours/point
  - Mid team: 3 hours/point
  - Senior team: 2 hours/point
```

**Example:**
```
1 senior developer
2-week sprint = 10 workdays
6 productive hours/day
No holidays

Total: 1 × 10 × 6 = 60 hours
Capacity: 60 ÷ 2 = 30 points/sprint
```

---

### Part 3: Allocate Stories to Sprints

**Level 0 (1 story):**
- No sprint allocation needed
- Single story = single implementation task
- Skip to output

**Level 1 (1-10 stories):**
- Usually single sprint
- Order by priority and dependency
- Allocate all stories

**Level 2+ (Multiple sprints):**

**Allocation rules:**
1. **Must Have stories first** - Highest priority
2. **Respect dependencies** - Foundation before features
3. **Fill to 80-90% capacity** - Leave buffer for unknowns
4. **Group by epic** - Keep related stories together
5. **Balance sprints** - Don't front-load all complexity

**Sprint format:**
```markdown
### Sprint {N} - {points}/{capacity} points

**Goal:** {One-sentence description of sprint deliverable}
**Dates:** {start} to {end}

| Story ID | Title | Points | Priority | Dependencies |
|----------|-------|--------|----------|--------------|
| STORY-001 | User registration | 5 | Must Have | - |
| STORY-002 | User login | 3 | Must Have | STORY-001 |

**Risks:** {Any identified risks}
```

---

### Part 4: Define Sprint Goals

**For each sprint, create SMART goals:**

**Good goals:**
- "Deliver complete user authentication (register, login, password reset)"
- "Enable product browsing with listing, search, and detail views"
- "Complete checkout flow from cart to order confirmation"

**Bad goals:**
- "Do Sprint 1 work" (vague)
- "STORY-001 to STORY-010" (not user-focused)
- "Finish everything" (unrealistic)

---

### Part 5: Create Traceability

**Epic to Sprint mapping:**
```markdown
| Epic ID | Epic Name | Stories | Points | Sprint(s) |
|---------|-----------|---------|--------|-----------|
| Epic-001 | Authentication | 5 | 21 | Sprint 1 |
| Epic-002 | Product Catalog | 5 | 28 | Sprint 1-2 |
```

**FR Coverage:**
```markdown
| FR ID | Requirement | Story | Sprint |
|-------|-------------|-------|--------|
| FR-001 | User registration | STORY-001 | 1 |
| FR-002 | User login | STORY-002 | 1 |
```

---

### Part 6: Identify Risks

**Risk categories:**
- **Technical:** New technology, integration complexity
- **Resource:** Team availability, holidays
- **Dependency:** External APIs, third-party services
- **Scope:** Unclear requirements, scope creep

**Format:**
```markdown
## Risks

| Risk | Severity | Mitigation |
|------|----------|------------|
| Payment gateway integration | High | Prototype in Sprint 1 |
| Database performance | Medium | Load testing in Sprint 2 |
```

---

### Part 7: Generate Sprint Plan Document

**Save to:** `docs/sprint-plan-{project-name}-{date}.md`

**Document structure:**
```markdown
# [Scrum Master] Sprint Plan: {project_name}

**Date:** {date}
**Project Level:** {level}
**Total Stories:** {count}
**Total Points:** {sum}
**Planned Sprints:** {count}

---

## Executive Summary

{2-3 sentence overview}

## Team Configuration

| Parameter | Value |
|-----------|-------|
| Developers | {count} |
| Sprint Length | {weeks} weeks |
| Capacity/Sprint | {points} points |

## Story Inventory

{All stories with epic, priority, points}

## Sprint Allocation

{Sprint-by-sprint breakdown}

## Epic Traceability

{Epic to story mapping}

## Requirements Coverage

{FR to story mapping}

## Risks and Mitigation

{Risk table}

## Definition of Done

For a story to be complete:
- [ ] Code implemented and committed
- [ ] Tests written (≥80% coverage)
- [ ] Code reviewed
- [ ] Acceptance criteria validated
- [ ] Documentation updated

## Next Steps

Begin Sprint 1 with `/dev-story STORY-001`
```

---

### Part 8: Initialize Sprint Status

**Create/update:** `bmad/sprint-status.yaml`

```yaml
version: "6.0.0"
project_name: "{project_name}"
project_level: {level}
current_sprint: 1
sprint_plan_path: "docs/sprint-plan-{project}-{date}.md"

sprints:
  - sprint_number: 1
    start_date: "{date}"
    end_date: "{date + sprint_length}"
    capacity_points: {capacity}
    committed_points: {committed}
    completed_points: 0
    status: "not_started"
    goal: "{sprint goal}"
    stories:
      - story_id: "STORY-001"
        title: "{title}"
        points: {points}
        status: "not_started"

velocity:
  rolling_average: null

team:
  size: {developers}
  sprint_length_weeks: {weeks}
  capacity_per_sprint: {points}
```

---

## Display Summary

```
Sprint Plan Created!

Project: {project_name} (Level {level})

Summary:
- Total Stories: {count}
- Total Points: {sum}
- Planned Sprints: {count}
- Capacity: {points} points/sprint

Sprint 1 Goal: {goal}
Sprint 1 Stories: {count} stories, {points} points

Plan: docs/sprint-plan-{project}-{date}.md
Status: bmad/sprint-status.yaml

Ready to begin implementation!
Next: /dev-story STORY-001
```

---

## Story Point Reference

| Points | Complexity | Duration | Examples |
|--------|------------|----------|----------|
| 1 | Trivial | 1-2 hours | Config change, text update |
| 2 | Simple | 2-4 hours | Basic CRUD, simple component |
| 3 | Moderate | 4-8 hours | Complex component, business logic |
| 5 | Complex | 1-2 days | Feature with multiple components |
| 8 | Very Complex | 2-3 days | Full feature frontend + backend |
| 13 | **TOO BIG** | - | **Break this down!** |

---

## Subagent Strategy

For large projects (Level 3+), use parallel planning:

**Pattern:** Parallel Section Generation
**Agents:** 3 parallel agents

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Analyze dependencies and create graph | accbmad/outputs/dependencies.md |
| Agent 2 | Calculate velocity and capacity | accbmad/outputs/capacity.md |
| Agent 3 | Generate sprint goals from epics | accbmad/outputs/sprint-goals.md |

**Coordination:**
1. Load all stories from epics document
2. Launch parallel agents for analysis
3. Synthesize into sprint allocation
4. Generate final sprint plan document

---

## Notes for Claude

- Use TodoWrite to track 8 planning parts
- Load epics document completely before planning
- Apply sizing guidelines strictly (no stories >8 points)
- Calculate realistic capacity based on team experience
- Create traceability tables to ensure FR coverage
- Initialize sprint-status.yaml for tracking
- Hand off to Developer with specific story recommendation

**Quality Checks:**
- All Must Have stories allocated
- Dependencies respected (no impossible ordering)
- Each sprint has clear, achievable goal
- Buffer exists for unknowns (10-20%)
- Traceability complete (all FRs covered)

**Remember:** Good planning = smooth implementation. Take time to allocate properly.

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No epics/stories found | "No stories to plan. Run `/create-epics-stories` first." | Create stories |
| No PRD or tech-spec | "No requirements document. Run `/prd` or `/tech-spec` first." | Create requirements |
| All stories >13 points | "All stories are too large. Stories must be broken down." | Re-estimate stories |
| No team capacity info | "Cannot calculate capacity. Provide team size and sprint length." | Collect capacity inputs |

---

## Integration Points

**Works After:**
- `/create-epics-stories` - Provides stories to allocate
- `/architecture` - Provides technical guidance

**Works Before:**
- `/dev-story` - Implements allocated stories
- `/create-story` - Creates detailed story documents

**Related:**
- `/sprint-status` - Check sprint progress
- `/velocity-report` - Calculate velocity metrics
