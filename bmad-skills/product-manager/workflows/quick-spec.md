# [Product Manager] Quick-Spec Workflow

**Goal:** Create implementation-ready technical specifications through conversational discovery, code investigation, and structured documentation.

**Trigger keywords:** quick spec, fast spec, lightweight spec, small feature spec, quick requirements, fast requirements

**Duration:** 15-45 minutes

**Output:** Tech spec ready for immediate development

---

## When to Use Quick-Spec

Use this workflow when:
- Small to medium feature (1-5 story points)
- Clear, focused scope
- Single developer or small team
- Need to move fast but want documentation
- Brownfield (existing code) or greenfield projects

**Skip to full PRD workflow when:**
- Multiple stakeholders need alignment
- Complex, multi-team effort
- Strategic, long-term feature
- Regulatory or compliance requirements

---

## Ready for Development Standard

A specification is "Ready for Development" ONLY when:

| Criteria | Description |
|----------|-------------|
| **Actionable** | Every task has a clear file path and specific action |
| **Logical** | Tasks are ordered by dependency (lowest level first) |
| **Testable** | All ACs follow Given/When/Then and cover happy path + edge cases |
| **Complete** | All investigation results inlined; no placeholders or "TBD" |
| **Self-Contained** | A fresh agent can implement without reading workflow history |

---

## Workflow Steps

### Step 1: Analyze Requirement Delta

**Objective:** Understand what we're building and the gap between current state and target state.

1. **Greet and Get Initial Request**
   ```
   Hey! What are we building today?
   ```
   Get high-level description. Don't ask detailed questions yet.

2. **Quick Orient Scan** (< 30 seconds)
   - Check for existing context docs (PRD, architecture, epics)
   - Look for `**/project-context.md` or `CLAUDE.md`
   - If user mentioned specific code, do a quick scan
   - Build mental model of the landscape

3. **Ask Informed Questions**

   Instead of generic "What's the scope?", ask specific questions based on code scan:
   - "I see `AuthService` handles validation in controller - should the new field follow that pattern?"
   - "The `NavigationSidebar` uses local state - should we stick with that or move to global store?"

   Adapt to user skill level. Technical users want technical questions.

4. **Capture Core Understanding**

   Extract and confirm:
   - **Title**: Clear, concise name
   - **Problem Statement**: What problem are we solving?
   - **Solution**: High-level approach (1-2 sentences)
   - **In Scope**: What's included
   - **Out of Scope**: What's explicitly NOT included

5. **Initialize WIP File**

   Create tech spec at `accbmad/2-planning/tech-spec-{slug}-wip.md` using template.

---

### Step 2: Deep Investigation

**Objective:** Gather all technical context needed for implementation.

1. **Map Affected Components**
   - Search for files/modules that will change
   - Understand existing patterns and conventions
   - Identify dependencies and integration points

2. **Document Technical Context**

   For each component:
   - Current file path and purpose
   - Existing patterns to follow
   - Dependencies and imports
   - Test file locations

3. **Identify Edge Cases**
   - Error conditions
   - Boundary values
   - Concurrent access scenarios
   - Integration failure modes

4. **Update WIP with Investigation Results**

   Add all findings to the tech spec. NO placeholders allowed.

---

### Step 3: Generate Spec

**Objective:** Produce the complete, implementation-ready specification.

1. **Generate Task List**

   Create ordered tasks with:
   - [ ] Task description
   - File: `path/to/file.ts`
   - Action: Create/Modify/Delete
   - Details: Specific implementation guidance

   Order by dependency (data layer → business logic → API → UI)

2. **Write Acceptance Criteria**

   For each requirement, use Given/When/Then:
   ```
   AC-1: User can reset password
   Given: User is on login page
   When: User clicks "Forgot Password" and enters email
   Then: System sends reset email within 30 seconds
   ```

3. **Define Test Approach**
   - Unit tests for each component
   - Integration tests for flows
   - Edge case coverage

4. **Finalize Tech Spec**

   Move WIP file to final location: `accbmad/2-planning/tech-spec-{slug}.md`

---

### Step 4: Review and Validate

**Objective:** Ensure spec meets Ready for Development standard.

1. **Self-Review Checklist**

   - [ ] Every task has file path and specific action
   - [ ] Tasks ordered by dependency
   - [ ] All ACs are Given/When/Then format
   - [ ] No TBD, placeholders, or missing details
   - [ ] Fresh developer could implement from this alone

2. **Present Summary to User**
   ```
   Tech Spec Complete: {title}

   - Tasks: {count}
   - Acceptance Criteria: {count}
   - Files to modify: {list}

   Ready for development with /quick-dev {spec-path}
   ```

3. **Offer Next Steps**
   - [D] Start development now with /quick-dev
   - [R] Review and refine spec
   - [E] Exit with spec saved

---

## Resume Handling

If a WIP file exists when starting:

```
Found a tech-spec in progress:

**{title}** - Step {N} of 4 complete

[Y] Yes, pick up where I left off
[N] No, archive it and start fresh
```

Archive old WIP files to `docs/archive/` before starting new work.

---

## Example Session

```
User: I need to add password reset to the auth system

Quick-Spec: Hey! Let me understand what we're building.

[Does quick scan - finds AuthService, UserController, existing patterns]

I see you have an AuthService that handles login/logout. I have a few questions:

1. Should password reset tokens be stored in the users table or a separate table?
2. What's your email sending setup - I see nodemailer in package.json?
3. Reset link should go where - /reset-password/{token}?

[User answers]

Got it. Let me capture the scope:

Title: Password Reset Flow
Problem: Users can't recover accounts when they forget passwords
Solution: Add token-based password reset with email delivery
In Scope: Request form, email sending, reset form, token validation
Out of Scope: 2FA, account lockout policies

Creating tech-spec-wip...

[Step 2: Investigation]

I'm mapping the affected components:
- backend/services/AuthService.ts - add reset methods
- backend/models/User.ts - add reset_token fields
- backend/routes/auth.ts - add new endpoints
- frontend/pages/ResetPassword.tsx - new page
- Tests: backend/tests/auth.test.ts

[Step 3: Generate]

Tech spec complete with 12 tasks and 8 acceptance criteria.
Ready for development!

[D] Start /quick-dev now
[R] Review spec first
```

---

## Integration with Full BMAD

Quick-Spec is the "Phase 2 Express" option. If during investigation you discover:
- Scope is larger than expected
- Multiple stakeholders need alignment
- Architectural decisions needed

Escalate to full PRD workflow:
```
This looks bigger than quick-spec can handle.
Recommend: /prd for full requirements gathering
```

---

## Tips for LLMs

- Always scan code BEFORE asking questions
- Make questions specific and informed
- Never leave TBD or placeholders in final spec
- Order tasks by dependency
- Use Given/When/Then for all ACs
- Include file paths in every task
- Capture investigation results inline
- Validate against Ready for Development standard

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| Scope escalation needed | "This looks bigger than quick-spec can handle. Recommend: `/prd`." | Escalate to PRD |
| No codebase to scan | "Quick-spec requires existing code context. Use `/tech-spec` for greenfield." | Switch to tech-spec |
| Architectural decisions needed | "Changes require architecture decisions. Use `/architecture` first." | Run architecture workflow |
| Multiple stakeholders | "Multiple stakeholders need alignment. Use `/prd` for proper requirements." | Escalate to PRD |
