# [Scrum Master] Create Story Workflow

**Purpose:** Create implementation-ready user stories with comprehensive acceptance criteria and technical context to enable seamless developer handoff.

**Goal:** Create detailed, implementation-ready user stories with comprehensive acceptance criteria, technical context, and developer guardrails.

**Phase:** 4 - Implementation (Planning)

**Agent:** Scrum Master

**Trigger keywords:** create story, write story, story for epic, detailed story, story breakdown, story refinement

**Inputs:** Epic definition (from `docs/epics.md` or direct input), PRD, Architecture (optional)

**Output:** `accbmad/4-implementation/stories/STORY-{epic}-{num}-{slug}.md`

**Duration:** 15-30 minutes per story

---

## When to Use This Workflow

Use this workflow when:
- Need to create a **single detailed story** from an epic item
- Have a high-level requirement to break into implementable story
- Preparing story for developer handoff
- Refining backlog item with full acceptance criteria

**Invoke:** `/create-story` or `/create-story {epic-num}-{story-num}`

### Workflow Comparison

| Workflow | Purpose | When to Use |
|----------|---------|-------------|
| **`/create-story`** | Create ONE detailed story | Refining a specific backlog item |
| **`/create-epics-stories`** | Create ALL epics and stories from PRD | After PRD approval, bulk creation |
| **`/prd`** | Create PRD (includes high-level epics) | Phase 2 planning, requirements |

**Choose `/create-story` when:**
- You have existing epics and need to detail ONE story
- Adding a new story to an existing epic
- Refining a story that needs more detail

---

## Pre-Flight

1. **Load project context** - Check for `accbmad/config.yaml` or `CLAUDE.md`
2. **Check for epics** - Search `docs/epics.md` for story definitions
3. **Load architecture** - Search `docs/*architecture*.md` for technical constraints
4. **Check sprint status** - If exists, find next story to create

---

## Workflow Steps

### Step 1: Identify Target Story

**Objective:** Determine which story to create.

1. **User-Specified Story**

   If user provides story identifier (e.g., "2-3" or "Epic 2, Story 3"):
   - Parse epic number and story number
   - Look up in `docs/epics.md`
   - Proceed to Step 2

2. **Auto-Discovery from Sprint Status**

   If no story specified and `accbmad/4-implementation/sprint.yaml` exists:
   - Open and parse the YAML file
   - Search for stories with status: "backlog" or "pending"
   - If multiple found: present list for selection
   - If one found: present for confirmation

   ```
   Found next story to create:

   Epic 2, Story 3: User Password Reset
   Status: backlog

   [C] Create - Create this story now
   [S] Select - Choose a different story from the list
   ```

   If multiple stories available:
   ```
   Stories ready for creation:
   1. Epic 2, Story 3: User Password Reset (backlog)
   2. Epic 2, Story 4: Account Settings (backlog)
   3. Epic 3, Story 1: Product Listing (pending)

   Enter number to select, or [S] to specify manually:
   ```

3. **Manual Input**

   If no epics file exists:
   - Ask user to describe the story requirements
   - Proceed with direct input mode

---

### Step 2: Gather Context

**Objective:** Load all relevant context for comprehensive story creation.

**CRITICAL:** This step prevents developer mistakes by gathering everything needed.

1. **Load Epic Context**

   From `docs/epics.md`, extract:
   - Epic title and goal
   - Story's high-level description
   - Acceptance criteria (if pre-defined)
   - FRs covered by this story
   - Related stories in same epic

2. **Load Architecture Context**

   From `accbmad/3-solutioning/architecture-*.md`, extract:
   - Tech stack and frameworks
   - Relevant component design
   - API patterns and conventions
   - Data model for affected entities
   - Security requirements

3. **Load Previous Story Context**

   If this isn't the first story in epic:
   - Check for previous story files
   - Extract patterns established
   - Note any dev notes or learnings
   - Identify dependencies created

4. **Check PRD for Details**

   From `accbmad/2-planning/prd-*.md`, extract:
   - Detailed FR requirements
   - User personas and needs
   - Edge cases mentioned
   - Non-functional requirements

---

### Step 3: Write User Story

**Objective:** Create the user story statement.

**Format:**

```markdown
## User Story

As a **{user type/role}**
I want to **{capability or feature}**
So that **{business value or benefit}**
```

**Guidelines:**

- **User type** should be specific (registered user, admin, guest, etc.)
- **Capability** should be concrete and observable
- **Value** should explain the business/user benefit

**Good Examples:**

```
As a registered user
I want to reset my password via email
So that I can regain access to my account if I forget my password
```

**Bad Examples:**

```
As a user
I want the system to have password reset
So that it works
```

---

### Step 4: Write Acceptance Criteria

**Objective:** Create specific, testable acceptance criteria.

**Format: Given/When/Then (BDD)**

```markdown
## Acceptance Criteria

### AC1: {Title}
**Given** {precondition/context}
**When** {action taken}
**Then** {expected outcome}
**And** {additional outcome}

### AC2: {Title}
**Given** {precondition}
**When** {action}
**Then** {outcome}
```

**Guidelines:**

- 3-7 acceptance criteria per story (if more, story may be too large)
- Each AC should be independently testable
- Include happy path and error cases
- Cover edge cases from PRD

**Good AC Example:**

```
### AC1: Valid Password Reset Request
**Given** I am on the password reset page
**And** I have a registered account with email "user@example.com"
**When** I enter my email address and click "Send Reset Link"
**Then** I see a confirmation message "Reset link sent to your email"
**And** I receive an email with a password reset link within 5 minutes
**And** The reset link is valid for 1 hour

### AC2: Invalid Email Address
**Given** I am on the password reset page
**When** I enter an email not associated with any account
**And** I click "Send Reset Link"
**Then** I see the same confirmation message (for security)
**And** No email is sent
```

---

### Step 5: Add Technical Context

**Objective:** Provide developer guardrails to prevent mistakes.

**DISASTER PREVENTION:** This section prevents common LLM developer mistakes.

1. **Technical Requirements**

   ```markdown
   ## Technical Notes

   ### Implementation Approach
   {Brief description of technical approach based on architecture}

   ### Files/Modules Affected
   - `src/services/auth.ts` - Add password reset methods
   - `src/api/routes/auth.ts` - Add reset endpoints
   - `src/models/user.ts` - Add reset token fields

   ### Architecture Compliance
   - Follow existing auth patterns in `src/services/auth.ts`
   - Use existing email service in `src/services/email.ts`
   - Store reset tokens in users table (not separate table)
   - Token format: UUID v4, expires in 1 hour
   ```

2. **Data Model Changes**

   ```markdown
   ### Data Model Changes
   Add to User model:
   - `reset_token: string | null`
   - `reset_token_expires: timestamp | null`

   Index: `idx_users_reset_token` on `reset_token`
   ```

3. **API Changes**

   ```markdown
   ### API Changes
   | Method | Path | Description | Auth |
   |--------|------|-------------|------|
   | POST | /api/auth/forgot-password | Request reset | None |
   | POST | /api/auth/reset-password | Reset with token | None |
   ```

4. **Edge Cases**

   ```markdown
   ### Edge Cases
   - **Multiple reset requests:** Invalidate previous token
   - **Expired token:** Show clear error, offer new reset
   - **Already logged in:** Still allow reset (don't auto-logout)
   - **Rate limiting:** Max 3 requests per email per hour
   ```

5. **Security Considerations**

   ```markdown
   ### Security Considerations
   - Same response for valid/invalid emails (prevent enumeration)
   - Cryptographically secure token generation
   - Token stored hashed in database
   - HTTPS required for reset links
   - Log reset attempts for audit
   ```

---

### Step 6: Define Dependencies

**Objective:** Identify blocking relationships.

```markdown
## Dependencies

### Story Dependencies
- **Blocked by:** None (or STORY-2-1 if applicable)
- **Blocks:** STORY-2-4 (Account settings page)

### Technical Dependencies
- Email service must be configured
- User model must have email field
- Frontend routing must support /reset-password

### Open Questions
- [ ] Should password history be enforced? (Ask PM)
- [ ] Minimum password length? (Check security requirements)
```

---

### Step 7: Define Testing Requirements

**Objective:** Specify what tests are needed.

```markdown
## Testing Requirements

### Unit Tests
- [ ] Reset token generation returns valid UUID
- [ ] Reset token expires after 1 hour
- [ ] Invalid token is rejected
- [ ] Password is properly hashed after reset

### Integration Tests
- [ ] Full reset flow from request to new password
- [ ] Email is sent with valid reset link
- [ ] Token invalidated after use

### Manual Testing
- [ ] Reset link works in email client
- [ ] UI shows appropriate messages
- [ ] Mobile-responsive reset page
```

---

### Step 8: Estimate Story Points

**Objective:** Assign complexity estimate.

**Fibonacci Scale:**

| Points | Complexity | Duration | Indicators |
|--------|------------|----------|------------|
| 1 | Trivial | 1-2 hours | Config change, copy update |
| 2 | Simple | 2-4 hours | Basic CRUD, simple component |
| 3 | Moderate | 4-8 hours | Complex component, business logic |
| 5 | Complex | 1-2 days | Multi-component feature |
| 8 | Very Complex | 2-3 days | Full feature (frontend + backend) |
| 13 | **TOO BIG** | - | **Break down into smaller stories** |

**Estimation Factors:**

- How many files will change?
- Is there new business logic?
- Frontend, backend, or both?
- Testing complexity?
- External dependencies?
- Uncertainty/unknowns?

**If story estimates at 13+ points:** Break it into smaller stories before proceeding.

---

### Step 9: Generate Story Document

**Objective:** Create the final story file.

**Output Location:** `accbmad/4-implementation/stories/STORY-{epic}-{num}-{slug}.md`

**Example:** `accbmad/4-implementation/stories/STORY-2-3-password-reset.md`

**Document Structure:**

```markdown
# [Scrum Master] {Story Title}

**ID:** STORY-{epic}-{num}
**Epic:** {Epic Number}: {Epic Name}
**Priority:** {Must Have | Should Have | Could Have}
**Story Points:** {estimate}
**Status:** ready-for-dev

## User Story

As a **{user type}**
I want to **{capability}**
So that **{value}**

## Acceptance Criteria

### AC1: {Title}
**Given** {precondition}
**When** {action}
**Then** {outcome}

[Additional ACs...]

## Technical Notes

### Implementation Approach
{approach}

### Files/Modules Affected
- {file list}

### Data Model Changes
{changes}

### API Changes
{endpoints}

### Edge Cases
{cases}

### Security Considerations
{security}

## Dependencies

### Story Dependencies
{dependencies}

### Technical Dependencies
{tech deps}

### Open Questions
{questions}

## Testing Requirements

### Unit Tests
{tests}

### Integration Tests
{tests}

### Manual Testing
{tests}

## Definition of Done

- [ ] Code written and follows project standards
- [ ] All acceptance criteria met
- [ ] Unit tests written and passing
- [ ] Integration tests passing (if applicable)
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] Merged to main branch

## Notes

{Any additional context, links, decisions}
```

---

### Step 10: Update Sprint Status

**Objective:** Update tracking after story creation.

1. **Update Status File**

   If `accbmad/4-implementation/sprint.yaml` exists:
   - Update story status from "backlog" to "ready-for-dev"
   - Update epic status to "in-progress" if first story

2. **Present Completion**

   ```
   Story Created!

   File: accbmad/4-implementation/stories/STORY-{epic}-{num}-{slug}.md
   Status: ready-for-dev
   Points: {estimate}

   Summary:
   - {count} Acceptance Criteria
   - {count} Files Affected
   - {count} Tests Required

   Next Steps:
   [D] Start development (/dev-story STORY-{epic}-{num})
   [N] Create next story
   [V] View story document
   ```

---

## Subagent Strategy

For large epics with many stories, use parallel story creation:

**Pattern:** Parallel Story Generation
**When:** Epic has 5+ stories to create

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Create stories 1-3 | `accbmad/4-implementation/stories/STORY-{epic}-{1,2,3}-*.md` |
| Agent 2 | Create stories 4-6 | `accbmad/4-implementation/stories/STORY-{epic}-{4,5,6}-*.md` |

**Coordination:**
1. Main context gathers all shared context (architecture, PRD)
2. Write to `accbmad/context/story-context.md`
3. Launch parallel agents with story assignments
4. Each agent creates complete story documents
5. Main context updates sprint-status.yaml

---

## Notes for Claude

**Tool Usage:**
- Use Glob to find epics: `docs/epics.md`
- Use Glob to find architecture: `docs/*architecture*.md`
- Use Read to load documents completely
- Use Write to save story document to `accbmad/4-implementation/stories/`
- Create stories directory if it doesn't exist

**Key Principles:**
- Stories must be implementation-ready (developer can start immediately)
- Include all technical context to prevent mistakes
- Acceptance criteria must be specific and testable
- Always check for previous story patterns
- Estimate realistically - break down 13+ point stories
- Security considerations are never optional

**Common Mistakes to Prevent:**
- Vague acceptance criteria ("it should work")
- Missing error handling cases
- No security considerations
- No technical context (files, patterns)
- Dependencies not identified
- Too large (should be broken down)

**Quality Checklist:**
- [ ] User story follows As a/I want/So that format
- [ ] 3-7 acceptance criteria in Given/When/Then
- [ ] Technical approach specified
- [ ] Files affected identified
- [ ] Edge cases documented
- [ ] Security considered
- [ ] Dependencies identified
- [ ] Story points assigned (not 13+)
- [ ] Testing requirements defined

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No epic found | "Cannot find epic {N}. Run `/create-epics-stories` first." | Create epics |
| PRD missing | "Cannot gather context without PRD or requirements." | Create PRD/tech-spec |
| Story >13 points | "Story too large to implement. Must break down." | Split into smaller stories |
| Missing acceptance criteria | "Cannot complete story without testable criteria." | Define criteria with user |
| Circular dependencies | "Detected circular story dependencies." | Review and restructure |
