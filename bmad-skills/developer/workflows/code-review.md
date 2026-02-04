# Adversarial Code Review Workflow

**Goal:** Find problems before they reach production. Validate story claims against actual implementation.

**Phase:** 4 - Implementation (Quality Assurance)

**Agent:** Developer

**Trigger keywords:** code review, review code, adversarial review, PR review, check implementation, validate code

**Inputs:** Story file or PR/diff to review

**Output:** Review findings with severity, fix recommendations, and updated story status

**Duration:** 15-45 minutes depending on scope

---

## Adversarial Mindset

> You are a cynical, jaded reviewer with zero patience for sloppy work.
> The code was submitted by someone who expects you to find problems.
> Be skeptical of everything. Look for what's MISSING, not just what's wrong.

**Core Principle:** Find 3-10 specific issues minimum in every review. Zero findings is suspicious - dig deeper!

---

## When to Use This Workflow

Use this workflow when:
- Story implementation is complete and ready for review
- PR needs adversarial review before merge
- Self-review during quick-dev workflow
- Periodic code quality audits

**Invoke:** `/code-review` or `/code-review path/to/story.md` or `/code-review --auto-fix`

**Flags:**
- `--auto-fix`: Automatically fix all issues without prompting (for autonomous workflows)

---

## Workflow Steps

### Step 1: Load Context and Discover Changes

**Objective:** Understand what was changed and what claims are being made.

1. **Identify Review Scope**

   If story file provided:
   - Load complete story file
   - Extract: Acceptance Criteria, Tasks, File List
   - Parse completion status ([x] vs [ ])

   If PR/diff review:
   - Get PR description or commit message
   - Identify claimed changes

2. **Discover Actual Changes via Git**

   ```bash
   git status --porcelain        # Uncommitted changes
   git diff --name-only          # Modified files
   git diff --cached --name-only # Staged files
   ```

3. **Cross-Reference Claims vs Reality**

   Compare story File List (or PR description) with actual git changes:
   - Files in git but NOT in story → Document gap
   - Files in story but NO git changes → False claim (HIGH finding)
   - Uncommitted changes not documented → Transparency issue

4. **Load Project Context**

   Check for `project-context.md` or `CLAUDE.md` for coding standards.

---

### Step 2: Build Review Attack Plan

**Objective:** Create structured approach to find problems.

**Review Categories:**

| Category | What to Find |
|----------|--------------|
| **AC Validation** | Is each acceptance criterion actually implemented? |
| **Task Audit** | Is each [x] task really done? |
| **Git Discrepancies** | Do claims match reality? |
| **Security** | Input validation, injection risks, auth/authz |
| **Error Handling** | Missing try/catch, swallowed errors |
| **Edge Cases** | Null checks, boundary values, concurrent access |
| **Code Quality** | DRY violations, complex functions, poor naming |
| **Test Quality** | Real assertions vs placeholders |
| **Performance** | N+1 queries, memory leaks, inefficient algorithms |

**Create Review Plan:**
1. List all ACs to verify
2. List all tasks marked [x] to audit
3. Compile comprehensive file list (story + git)
4. Prioritize by risk (security/auth first)

---

### Step 3: Execute Adversarial Review

**Objective:** Find every problem, miss nothing.

#### 3.1 Git vs Story Discrepancies

| Finding Type | Severity |
|--------------|----------|
| Story claims file changed but NO git evidence | CRITICAL |
| Task marked [x] but NOT implemented | CRITICAL |
| Files changed but not in story File List | MEDIUM |
| Uncommitted changes not documented | MEDIUM |

#### 3.2 Acceptance Criteria Validation

For EACH Acceptance Criterion:
1. Read the AC requirement exactly
2. Search implementation files for evidence
3. Determine: IMPLEMENTED / PARTIAL / MISSING
4. If MISSING or PARTIAL → HIGH severity finding
5. Record specific proof (file:line)

#### 3.3 Task Completion Audit

For EACH task marked [x]:
1. Read the task description
2. Search files for evidence it was done
3. If marked [x] but NOT done → CRITICAL finding
4. Record evidence location

#### 3.4 Code Quality Deep Dive

For EACH file in review scope:

**Security:**
- Input validation present?
- SQL injection risks?
- XSS vulnerabilities?
- Authentication/authorization checks?
- Secrets exposed?

**Error Handling:**
- Try/catch where needed?
- Errors logged appropriately?
- User-friendly error messages?
- Resources cleaned up in all paths?

**Code Quality:**
- Functions under 50 lines?
- Single responsibility?
- Descriptive naming?
- Magic numbers extracted?
- DRY principle followed?

**Test Quality:**
- Tests have real assertions?
- Edge cases covered?
- Error paths tested?
- Not just happy path?

#### 3.5 Minimum Finding Check

```
IF total_issues_found < 3:
    NOT LOOKING HARD ENOUGH!

    Re-examine for:
    - Edge cases and null handling
    - Architecture violations
    - Documentation gaps
    - Integration issues
    - Dependency problems
    - Performance concerns

    Find at least 3 more specific, actionable issues.
```

---

### Step 4: Present Findings

**Objective:** Organize findings by severity and get direction.

**Severity Definitions:**

| Severity | Definition | Action |
|----------|------------|--------|
| CRITICAL | Broken functionality, security hole, false claims | Must fix now |
| HIGH | AC not implemented, significant bug | Must fix before merge |
| MEDIUM | Code quality, missing tests, documentation | Should fix |
| LOW | Style, minor improvements | Nice to fix |

**Output Format:**

```markdown
## Code Review Findings

**Story/PR:** {{identifier}}
**Files Reviewed:** {{count}}
**Git Discrepancies:** {{count}}
**Issues Found:** {{critical}} Critical, {{high}} High, {{medium}} Medium, {{low}} Low

### CRITICAL Issues
- [C1] Task marked [x] but not implemented: {{description}} [file:line]
- [C2] Security: {{description}} [file:line]

### HIGH Issues
- [H1] AC not fully implemented: {{AC_description}} [file:line]
- [H2] {{description}} [file:line]

### MEDIUM Issues
- [M1] Missing error handling: {{description}} [file:line]
- [M2] Test coverage gap: {{description}}

### LOW Issues
- [L1] {{description}} [file:line]
```

**Decision Options:**

```
What should I do with these findings?

[A] Auto-fix all - I'll update code and tests
[S] Select which to fix - Review each finding
[I] Ignore all - Create action items for later
[D] Deep dive - Explain specific issues in detail
```

**If `--auto-fix` flag was provided:** Skip the prompt and automatically proceed with Option A (Auto-fix all). This is used by autonomous workflows like `/dev-story-auto`.

---

### Step 5: Resolve Findings

**Objective:** Address issues based on user direction.

#### Option A: Auto-Fix All

1. Fix all CRITICAL and HIGH issues in code
2. Add/update tests as needed
3. Update story File List if files changed
4. Re-run tests to verify fixes
5. Optionally re-run adversarial review

#### Option S: Selective Fix

For each finding:
1. Present details and recommendation
2. User decides: Fix / Skip / Discuss
3. Apply selected fixes
4. Track deferred items

#### Option I: Create Action Items

1. Add "Review Follow-ups" section to story/PR
2. Format: `- [ ] [Severity] Description [file:line]`
3. Ensure nothing is lost

---

### Step 6: Update Status

**Objective:** Reflect review outcome in project tracking.

**Status Determination:**

| Condition | New Status |
|-----------|------------|
| All CRITICAL/HIGH fixed AND all ACs implemented | done |
| Any CRITICAL/HIGH remains OR ACs incomplete | in-progress |

**Actions:**
1. Update story status field
2. Sync sprint-status.yaml if sprint tracking enabled
3. Update change log with review entry

**Completion Output:**

```markdown
## Review Complete!

**Story Status:** {{status}}
**Issues Fixed:** {{fixed_count}}
**Issues Deferred:** {{deferred_count}}

{{#if status == "done"}}
Ready to merge!
{{else}}
Address remaining issues and re-request review.
{{/if}}
```

---

## Review Checklist

Quick reference for what to verify:

- [ ] Story file loaded and parsed
- [ ] Git changes discovered and cross-referenced
- [ ] All Acceptance Criteria validated
- [ ] All [x] tasks audited for completion
- [ ] Security review performed
- [ ] Error handling reviewed
- [ ] Code quality assessed
- [ ] Test quality evaluated
- [ ] At least 3-10 findings documented
- [ ] Findings categorized by severity
- [ ] User direction obtained
- [ ] Fixes applied (if selected)
- [ ] Status updated
- [ ] Sprint tracking synced

---

## Example Session

```
User: /code-review accbmad/4-implementation/stories/STORY-042.md

Code Review: Loading story STORY-042...

Story: User Password Reset
Status: review
ACs: 5
Tasks: 12 (all marked [x])

Discovering git changes...
- 6 files modified
- 2 files added
- 1 file in story but no git changes (FLAG)

Building review plan...

Executing adversarial review...

## Code Review Findings

**Story:** STORY-042 User Password Reset
**Files Reviewed:** 8
**Git Discrepancies:** 1
**Issues Found:** 1 Critical, 2 High, 3 Medium, 2 Low

### CRITICAL Issues
- [C1] Story lists `api/reset.ts` but no git changes - false claim

### HIGH Issues
- [H1] AC-3 "Token expires after 1 hour" - No expiry check found [api/validate.ts]
- [H2] Password not validated against policy [api/reset.ts:45]

### MEDIUM Issues
- [M1] Missing rate limiting on reset endpoint [api/reset.ts]
- [M2] Error message reveals email existence [api/reset.ts:32]
- [M3] No test for expired token scenario

### LOW Issues
- [L1] Magic number 3600 should be constant [api/validate.ts:12]
- [L2] Inconsistent error message format

[A] Auto-fix all
[S] Select which to fix
[I] Ignore all
[D] Deep dive

User: A

Fixing C1... Updated story File List (removed false entry)
Fixing H1... Added token expiry check with 1-hour TTL
Fixing H2... Added password policy validation
Fixing M1... Added rate limiter middleware (5 req/15min)
Fixing M2... Changed to generic error message
Fixing M3... Added expired token test

Re-running tests... 28 passing

## Review Complete!

**Story Status:** done
**Issues Fixed:** 6
**Issues Deferred:** 2 (L1, L2 - minor)

Ready to merge!
```

---

## Integration Points

- **quick-dev workflow:** Step 5 invokes this for adversarial self-review
- **dev-story workflow:** Called at story completion
- **Sprint tracking:** Syncs status to sprint-status.yaml
- **PR process:** Can review before merge

---

## Subagent Strategy

For reviewing multiple PRs or large changes:

**Pattern:** Fan-Out Review
**Agents:** N parallel agents (one per PR or major component)

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Review PR #1 or Component A | bmad/outputs/review-1.md |
| Agent 2 | Review PR #2 or Component B | bmad/outputs/review-2.md |

**Coordination:**
1. Identify independent review scopes
2. Launch parallel review agents
3. Synthesize findings into consolidated report
4. Present combined severity summary

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| Story file not found | "Story file not found at specified path." | Check path |
| No git repository | "Not a git repository. Cannot discover changes." | Initialize git |
| No changes to review | "No code changes detected. Nothing to review." | Make changes first |
| Story has no ACs | "Story has no acceptance criteria to validate." | Add ACs to story |

---

## Notes for Claude

**Tool Usage:**
- Use Bash `git status --porcelain` to find uncommitted changes
- Use Bash `git diff --name-only` to find modified files
- Use Read to examine implementation files
- Use Grep to search for patterns (validation, error handling)
- Use Bash `git diff {baseline}` to get full diff

**Key Principles:**
- NEVER accept "looks good" as valid - always find problems
- Use git diff to verify claims - don't trust File List alone
- Check edge cases: null, empty, boundary values
- Security issues are HIGH minimum, CRITICAL if exploitable
- Test quality matters - placeholder tests are MEDIUM findings
- Zero findings means you're not looking hard enough
- Be specific: include file:line references
- Offer auto-fix for efficiency
- Track what's deferred - nothing should be lost

**Minimum Finding Target:** 3-10 issues per review. Re-examine if fewer found.

**Auto-Fix Mode (`--auto-fix`):**
- When invoked with `--auto-fix`, DO NOT prompt the user
- Automatically apply Option A (fix all issues)
- Fix all CRITICAL, HIGH, MEDIUM issues
- Re-run tests after fixes
- If fixes introduce new issues, fix those too (max 3 iterations)
- This mode is used by `/dev-story-auto` for autonomous development
