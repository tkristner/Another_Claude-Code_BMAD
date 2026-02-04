# Create Epics and Stories Workflow

**Goal:** Transform PRD requirements and Architecture decisions into comprehensive stories organized by user value, creating detailed, actionable stories with complete acceptance criteria.

**Phase:** 4 - Implementation (Planning)

**Agent:** Scrum Master

**Trigger keywords:** create epics, create stories, breakdown requirements, epic breakdown, story creation, requirements to stories

**Inputs:** PRD (`accbmad/2-planning/prd-*.md`), Architecture (`accbmad/3-solutioning/architecture-*.md`, optional)

**Output:** `docs/epics.md` - Complete epic and story breakdown

**Duration:** 60-120 minutes depending on project complexity

---

## When to Use This Workflow

Use this workflow when:
- PRD is complete and approved
- Architecture is designed (or not needed for simple projects)
- Ready to plan implementation sprints
- Need to break down **ALL requirements** into implementable stories

**Invoke:** `/create-epics-stories` or `/epics`

### Workflow Comparison

| Workflow | Purpose | When to Use |
|----------|---------|-------------|
| **`/create-epics-stories`** | Create ALL epics and stories from PRD | After PRD approval, bulk creation |
| **`/create-story`** | Create ONE detailed story | Refining a specific backlog item |
| **`/prd`** | Create PRD (includes high-level epics) | Phase 2 planning, requirements |

**Choose `/create-epics-stories` when:**
- Starting sprint planning from scratch
- PRD is approved and you need complete breakdown
- Creating initial backlog for the project

---

## Pre-Flight

1. **Load project context** - Check for `accbmad/config.yaml` or `CLAUDE.md`
2. **Verify PRD exists** - Search `docs/*prd*.md`
3. **Check for architecture** - Search `docs/*architecture*.md` (optional for Level 0-1)
4. **Load existing epics** - Check if `docs/epics.md` already exists (resume vs new)
5. **Determine project level** - Affects story count and complexity

---

## Level-Specific Guidance

| Level | Expected Epics | Expected Stories | Approach |
|-------|---------------|------------------|----------|
| **0** | 0-1 | 1 | Single story, no epic needed |
| **1** | 1-2 | 1-10 | Simple breakdown, minimal epics |
| **2** | 2-4 | 5-15 | Standard epic/story structure |
| **3** | 4-8 | 12-40 | Full breakdown with dependencies |
| **4** | 8+ | 40+ | Multi-phase, use subagents |

**Level 0:** Skip epic creation. Create single story directly from tech-spec.

**Level 1:** Epics optional. Group stories by feature area if helpful.

**Level 2+:** Full epic structure required. Each epic should have 3-6 stories.

---

## Workflow Steps

### Step 1: Load Prerequisites

**Objective:** Gather all input documents and validate readiness.

1. **Find Input Documents**

   Search for:
   - `accbmad/2-planning/prd-*.md` or `docs/*prd*.md` - Product Requirements Document
   - `accbmad/3-solutioning/architecture-*.md` - Architecture document (optional)
   - `docs/ux-*.md` or `docs/design-*.md` - UX Design (optional)

2. **Extract Requirements Inventory**

   From PRD, identify:
   - **Functional Requirements (FRs):** FR-001, FR-002, etc.
   - **Non-Functional Requirements (NFRs):** Performance, security, etc.
   - **Additional Requirements:** From architecture or UX documents

3. **Validate Readiness**

   Check:
   - [ ] PRD exists and has requirements
   - [ ] Requirements have IDs and priorities
   - [ ] Scope is clearly defined

   If PRD is missing or incomplete:
   ```
   ⚠️ PRD not found or incomplete.

   Options:
   [P] Create PRD first (/prd)
   [Q] Create quick spec (/quick-spec)
   [C] Continue anyway with provided requirements
   ```

---

### Step 2: Design Epic List

**Objective:** Organize requirements into user-value-focused epics.

**EPIC DESIGN PRINCIPLES:**

1. **User-Value First**: Each epic must enable users to accomplish something meaningful
2. **Standalone Delivery**: Each epic delivers value independently
3. **Logical Flow**: Natural progression from user's perspective
4. **Dependency-Free**: Epics should not depend on future epics

**CORRECT Epic Organization (User Value):**
```
Epic 1: User Authentication & Profiles
  → Users can register, login, manage profiles
  → FRs: FR-001, FR-002, FR-003

Epic 2: Content Creation
  → Users can create, edit, publish content
  → FRs: FR-004, FR-005, FR-006

Epic 3: Social Interaction
  → Users can follow, comment, like
  → FRs: FR-007, FR-008
```

**WRONG Epic Organization (Technical Layers):**
```
❌ Epic 1: Database Setup
❌ Epic 2: API Development
❌ Epic 3: Frontend Components
```

**Process:**

1. **Identify User Value Themes**
   - Group related FRs by user outcomes
   - Consider user journeys and workflows
   - Map to user types/personas

2. **Propose Epic Structure**

   For each epic, define:
   - **Epic Title**: User-centric, value-focused
   - **User Outcome**: What users accomplish after this epic
   - **FR Coverage**: Which FR numbers this epic addresses

3. **Create Requirements Coverage Map**

   Ensure every FR is assigned to exactly one epic:
   ```
   FR-001 → Epic 1 (User Registration)
   FR-002 → Epic 1 (User Login)
   FR-003 → Epic 2 (Create Content)
   ...
   ```

4. **Review and Approve**

   Present epic structure for review:
   ```
   Epic List Proposal:

   | Epic | Title | FRs | User Value |
   |------|-------|-----|------------|
   | 1 | Authentication | FR-001, FR-002 | Users can access the system |
   | 2 | Content | FR-003, FR-004 | Users can create content |

   Does this structure align with your product vision?
   [A] Approve and continue
   [R] Revise epic structure
   ```

---

### Step 3: Create Stories for Each Epic

**Objective:** Break down each epic into implementable user stories.

**STORY PRINCIPLES:**

1. **Single Dev Session**: Each story completable in one focused session
2. **Independent**: Stories don't depend on future stories
3. **Testable**: Clear acceptance criteria
4. **User Value**: Describes user capability, not technical task

**STORY FORMAT:**

```markdown
### Story {N}.{M}: {story_title}

As a {user_type},
I want {capability},
So that {value_benefit}.

**Acceptance Criteria:**

**Given** {precondition}
**When** {action}
**Then** {expected_outcome}
**And** {additional_criteria}
```

**GOOD Story Examples:**
```
✅ Story 1.1: User Registration with Email
✅ Story 1.2: User Login with Password
✅ Story 2.1: Create New Blog Post
```

**BAD Story Examples:**
```
❌ "Set up database" (no user value)
❌ "Create all models" (too large)
❌ "Login UI requires Story 1.3" (future dependency)
```

**DATABASE/ENTITY PRINCIPLE:**
Create tables/entities ONLY when needed by the story:
- ❌ WRONG: Story 1 creates all 50 database tables
- ✅ RIGHT: Each story creates only the tables it needs

**Process for Each Epic:**

1. **Display Epic Context**
   ```
   Processing Epic 1: User Authentication

   Goal: Users can register, login, and manage profiles
   FRs covered: FR-001, FR-002, FR-003
   ```

2. **Identify Story Boundaries**
   - Each distinct user capability = 1 story
   - Include error handling in same story
   - Keep stories focused

3. **Write Each Story**
   - Clear title (action-oriented)
   - Complete user story format
   - Specific acceptance criteria (Given/When/Then)

4. **Review Story Set**
   ```
   Epic 1 Stories:

   1.1: User Registration with Email (3 ACs)
   1.2: User Login with Password (4 ACs)
   1.3: Password Reset via Email (3 ACs)

   [A] Approve stories for Epic 1
   [E] Edit a story
   [+] Add another story
   ```

---

### Step 3.5: Estimate Story Points

**Objective:** Assign Fibonacci estimates to each story.

**Estimation Scale:**

| Points | Complexity | Duration | Examples |
|--------|------------|----------|----------|
| 1 | Trivial | 1-2 hours | Config change, copy update |
| 2 | Simple | 2-4 hours | Basic CRUD, simple component |
| 3 | Moderate | 4-8 hours | Complex component, business logic |
| 5 | Complex | 1-2 days | Multi-component feature |
| 8 | Very Complex | 2-3 days | Full feature with frontend + backend |
| 13 | **TOO BIG** | - | **Must break down further** |

**Estimation Process:**

1. For each story, consider:
   - How many files will change?
   - Is there new business logic?
   - Frontend, backend, or both?
   - Testing complexity?
   - External dependencies?

2. Assign points using the scale above

3. **If story is 13+ points:** Break it into smaller stories

**Add estimates to story format:**
```markdown
### Story 1.1: User Registration (5 pts)

As a new user...
```

**Estimation Summary:**
```
Epic 1: User Authentication - 16 points total
  - Story 1.1: User Registration (5 pts)
  - Story 1.2: User Login (3 pts)
  - Story 1.3: Password Reset (5 pts)
  - Story 1.4: Email Verification (3 pts)
```

---

### Step 4: Epic Quality Review

**Objective:** Validate epics against best practices before finalizing.

**EPIC QUALITY CHECKLIST:**

For each epic, verify:

| Check | Pass? | Red Flags |
|-------|-------|-----------|
| Delivers user value | | "Setup Database", "Create Models", "API Development" |
| User-centric title | | Technical milestones, infrastructure-focused |
| Functions independently | | Requires future epics to work |
| No forward dependencies | | Epic N requires Epic N+1 |
| Stories properly sized | | Stories > 8 points |
| Database created incrementally | | Story 1 creates all tables upfront |

**CRITICAL RED FLAGS (Violations):**

- ❌ "Setup Database" or "Create Models" - no user value
- ❌ "API Development" - technical milestone
- ❌ "Infrastructure Setup" - not user-facing
- ❌ "Epic 2 requires Epic 3 features to function"
- ❌ Story referencing features not yet implemented

**Epic Independence Test:**

- **Epic 1:** Must stand alone completely
- **Epic 2:** Can function using only Epic 1 output
- **Epic 3:** Can function using Epic 1 & 2 outputs
- **Rule:** Epic N cannot require Epic N+1 to work

**Database Creation Timing:**

- ❌ **Wrong:** Epic 1 Story 1 creates all tables upfront
- ✅ **Right:** Each story creates only the tables it needs

---

### Step 5: Final Validation

**Objective:** Verify completeness and quality.

**Validation Checklist:**

| Check | Status |
|-------|--------|
| All FRs mapped to stories | |
| All stories have acceptance criteria | |
| No future dependencies in stories | |
| Stories are appropriately sized (≤8 pts) | |
| Epic progression is logical | |
| No technical epics (user value only) | |
| Database tables created incrementally | |

**Coverage Report:**
```
Requirements Coverage:
- Functional: 12/12 FRs covered (100%)
- Non-Functional: 5/5 NFRs addressed
- Epics: 4 total
- Stories: 18 total
```

---

### Step 6: Generate Output Document

**Objective:** Create the final epics.md document.

**Output Location:** `docs/epics.md`

**Document Structure:**

```markdown
---
project: {project_name}
created: {date}
prd_source: accbmad/2-planning/prd-{project}.md
status: ready_for_sprint
---

# {Project Name} - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown,
decomposing requirements into implementable stories.

## Requirements Inventory

### Functional Requirements
{fr_list with IDs and descriptions}

### Non-Functional Requirements
{nfr_list}

### FR Coverage Map
{mapping of FR to Epic}

## Epic List

| Epic | Title | Stories | FRs |
|------|-------|---------|-----|
| 1 | {title} | 4 | FR-001, FR-002 |
| 2 | {title} | 5 | FR-003, FR-004, FR-005 |

## Epic 1: {epic_title}

{epic_goal}

### Story 1.1: {story_title}

As a {user_type},
I want {capability},
So that {value_benefit}.

**Acceptance Criteria:**

**Given** {precondition}
**When** {action}
**Then** {expected_outcome}

[... continue for all stories ...]
```

---

### Step 7: Present Completion Options

```
Epic Breakdown Complete!

📋 Created: docs/epics.md
📊 Summary:
   - {N} Epics
   - {M} Stories total
   - 100% FR coverage

What would you like to do?

[S] Start sprint planning (/sprint-planning)
[E] Estimate stories
[V] Validate with PRD (/validate-prd)
[R] Review a specific epic
```

---

## Subagent Strategy

For large PRDs (15+ requirements), use parallel agents:

**Pattern:** Fan-Out Story Generation
**When:** Level 3-4 projects with 4+ epics

### Agent Configuration

| Agent | Role | Input | Output |
|-------|------|-------|--------|
| Main | Epic structure design | PRD | `bmad/context/epics-structure.md` |
| Agent 1 | Story writer for Epic 1 | Epic 1 FRs | `bmad/outputs/epic-1-stories.md` |
| Agent 2 | Story writer for Epic 2 | Epic 2 FRs | `bmad/outputs/epic-2-stories.md` |
| Agent N | Story writer for Epic N | Epic N FRs | `bmad/outputs/epic-n-stories.md` |
| Validator | Coverage check | All outputs | Validation report |

### Coordination Flow

1. **Main context:** Design epic structure, assign FRs to epics
2. **Write shared context:** Save to `bmad/context/epics-structure.md`
3. **Launch parallel agents:** One per epic (up to 6 concurrent)
4. **Each agent:** Creates 3-6 stories with acceptance criteria and estimates
5. **Collect outputs:** Read all `bmad/outputs/epic-*.md` files
6. **Synthesize:** Combine into final `docs/epics.md`
7. **Validate:** Check 100% FR coverage, no orphans

### Example Subagent Prompt

```
Task: Create stories for Epic 2 (Task Management)
Context: Read bmad/context/epics-structure.md for epic definition and assigned FRs
Objective: Create 4-6 user stories with Given/When/Then acceptance criteria

Requirements to cover:
- FR-004: Create task
- FR-005: Edit task
- FR-006: Delete task
- FR-007: Mark task complete

Output: Write to bmad/outputs/epic-2-stories.md

Format each story with:
- Title and story points estimate (Fibonacci)
- User story format (As a... I want... So that...)
- 3-5 acceptance criteria in Given/When/Then format
- Technical notes if relevant
```

---

## Notes for Claude

**Key Principles:**
- Organize by USER VALUE, never by technical layers
- Each story should be completable in a single dev session (1-3 days max)
- Acceptance criteria must be specific and testable
- Use Given/When/Then format for clarity
- Ensure no story depends on a future story
- Create database tables incrementally, not all upfront
- Map every FR to ensure nothing is missed
- Keep epics to 3-6 stories for manageability

**Tool Usage:**
- Use Glob to find PRD: `docs/*prd*.md`
- Use Read to load PRD completely
- Use Write to save `docs/epics.md`
- Use TodoWrite to track epic breakdown progress

**Quality Checks:**
- 100% FR coverage required
- All stories have acceptance criteria
- No story exceeds 8 points (break down if larger)
- Each epic delivers standalone user value

---

## Example Session

```
User: /create-epics-stories

Loading prerequisites...

Found: accbmad/2-planning/prd-task-manager.md
Extracted: 12 Functional Requirements, 4 NFRs

Designing Epic Structure...

Proposed Epics:

| Epic | Title | FRs | User Value |
|------|-------|-----|------------|
| 1 | User Management | FR-001, FR-002, FR-003 | Users can register and login |
| 2 | Task CRUD | FR-004, FR-005, FR-006, FR-007 | Users can manage tasks |
| 3 | Organization | FR-008, FR-009, FR-010 | Users can organize tasks |
| 4 | Collaboration | FR-011, FR-012 | Users can share tasks |

Coverage: 12/12 FRs (100%)

[A] Approve and create stories
[R] Revise epics

User: A

Creating stories for Epic 1: User Management...

### Story 1.1: User Registration

As a new user,
I want to register with my email and password,
So that I can access the task management system.

**Acceptance Criteria:**

**Given** I am on the registration page
**When** I enter a valid email and password
**Then** my account is created
**And** I receive a confirmation email

[...continues...]
```

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No PRD found | "Cannot create stories without requirements. Run `/prd` first." | Create PRD |
| PRD has no FRs | "PRD has no functional requirements to decompose." | Add FRs to PRD |
| FR coverage <100% | "Not all FRs are mapped to epics. Review mapping." | Fix FR allocation |
| Story >13 points | "Story too large to implement. Must break down." | Split the story |

---

## Integration Points

- **Input from:** `/prd`, `/architecture`, `/create-ux-design`
- **Output to:** `/sprint-planning`, `/dev-story`
- **Related:** `/validate-prd` (pre-check), `/create-story` (detailed story)
