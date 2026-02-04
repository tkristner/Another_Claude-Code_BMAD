# Quick-Dev Workflow

**Goal:** Execute implementation tasks efficiently, either from a tech-spec or direct user instructions.

**Phase:** 4 - Implementation (Execution)

**Agent:** Developer

**Trigger keywords:** quick dev, quick fix, implement directly, fast implementation, small feature, bug fix

**Inputs:** Tech-spec file OR direct user instructions

**Output:** Working, tested code with adversarial review completed

**Duration:** 30 minutes to few hours depending on scope

---

## When to Use Quick-Dev

Use this workflow when:
- You have a tech-spec from /quick-spec
- Small, focused task (bug fix, refactor, simple feature)
- Clear scope that fits in one session
- Want built-in quality checks (self-review + adversarial)

**Escalate to full /dev-story when:**
- Multi-day implementation
- Part of formal sprint tracking
- Complex story with extensive acceptance criteria
- Multiple interdependent changes

---

## Workflow Steps

### Step 1: Mode Detection

**Objective:** Determine execution mode and capture baseline.

1. **Capture Baseline Commit**
   ```bash
   git rev-parse HEAD
   ```
   Store as `{baseline_commit}` - needed for diff in review step.

   If not a git repo, set `{baseline_commit}` = "NO_GIT"

2. **Load Project Context**

   Check for `**/project-context.md` or `CLAUDE.md` - use as reference for all implementation decisions.

3. **Determine Mode**

   **Mode A: Tech-Spec**
   - User provided path to tech-spec file
   - Load spec, extract tasks and acceptance criteria
   - Skip to Step 3 (Execute)

   **Mode B: Direct Instructions**
   - User provided task description directly
   - Evaluate escalation threshold
   - Proceed to Step 2 (Context Gathering)

4. **Escalation Check** (Mode B only)

   **Triggers escalation** (2+ signals):
   - Multiple components mentioned (dashboard + api + database)
   - System-level language (platform, integration, architecture)
   - Uncertainty about approach ("how should I", "best way to")
   - Multi-layer scope (UI + backend + data together)

   **Reduces signal**:
   - Simplicity markers ("just", "quickly", "fix", "bug", "simple")
   - Single file/component focus
   - Confident, specific request

   **If escalation triggered:**
   ```
   This looks like a focused feature with multiple components.

   [P] Plan first (quick-spec) - recommended
   [W] Seems bigger - recommend full BMAD flow
   [E] Execute directly - feeling lucky
   ```

---

### Step 2: Context Gathering (Mode B only)

**Objective:** Build implementation context for direct instructions.

1. **Scan Affected Code**
   - Search for relevant files/components
   - Understand existing patterns
   - Identify dependencies

2. **Clarify Requirements**
   - Ask informed questions based on code scan
   - Confirm scope and approach
   - Note any constraints

3. **Create Mental Task List**
   - What files to modify/create
   - What order (dependencies first)
   - What tests to write

---

### Step 3: Execute Implementation

**Objective:** Write the code following project patterns.

**DISASTER PREVENTION CHECKLIST (Before Coding):**

| Check | Verified? |
|-------|-----------|
| **Reinventing wheels** - Is there existing code I should reuse/extend? | |
| **Wrong libraries** - Am I using the correct framework/version? | |
| **Wrong file locations** - Does this follow project structure? | |
| **Breaking regressions** - Will this break existing functionality? | |
| **Ignoring UX** - Am I following UX design requirements? | |

1. **Follow Existing Patterns**
   - Match code style and conventions
   - Use established patterns from codebase
   - Follow project structure
   - **Reuse existing code** - don't reinvent

2. **Implement Incrementally**
   - Data/backend layer first
   - Business logic with tests
   - Frontend/UI components
   - Integration points

3. **Write Tests Alongside**
   - Unit tests for new functions
   - Integration tests for flows
   - Edge case coverage

4. **Document Non-Obvious Decisions**
   - Comments for complex logic
   - Update relevant docs if needed

---

### Step 4: Self-Check

**Objective:** Validate implementation before adversarial review.

**Functional Checklist:**
- [ ] All tasks from spec completed (if Mode A)
- [ ] Tests written and passing
- [ ] Code follows project conventions
- [ ] No console.logs or debug code
- [ ] Error handling in place
- [ ] Acceptance criteria met

**Security Checklist:**
- [ ] Inputs validated and sanitized
- [ ] No SQL injection risks (parameterized queries)
- [ ] No XSS risks (output encoding)
- [ ] Authentication checked where needed
- [ ] Authorization verified for resources
- [ ] No secrets hardcoded
- [ ] Error messages don't leak internals

**Run tests:**
```bash
npm test  # or equivalent
```

**If tests fail:**
1. Read failure output carefully
2. Fix the failing code (not the test, unless test is wrong)
3. Re-run tests
4. Repeat until all pass
5. **Do NOT proceed to review with failing tests**

**If issues found:** Fix before proceeding to review.

---

### Step 5: Adversarial Code Review

**Objective:** Find problems before they reach production.

1. **Construct Diff**

   If git repo:
   ```bash
   git diff {baseline_commit}
   ```

   Include new untracked files created during session.

2. **Invoke Adversarial Review**

   Review with extreme skepticism. The review MUST:
   - Find at least 3-10 issues (if zero, re-analyze)
   - Look for what's missing, not just what's wrong
   - Check security, error handling, edge cases
   - Verify tests are comprehensive

3. **Process Findings**

   For each finding:
   - ID (F1, F2, F3...)
   - Severity (Critical, High, Medium, Low)
   - Validity (Real issue, Noise, Undecided)
   - Description

   Present as table or task list.

---

### Step 6: Resolve Findings

**Objective:** Address review findings with user guidance.

1. **Present Findings Summary**
   ```
   Adversarial Review Complete

   Critical: 0
   High: 2
   Medium: 3
   Low: 1

   [A] Auto-fix all (let me handle it)
   [S] Select which to fix
   [I] Ignore all (I'll handle later)
   [R] Re-review after discussion
   ```

2. **For Auto-Fix**
   - Address each finding systematically
   - Re-run tests after fixes
   - Optionally re-run adversarial review

3. **For Selective Fix**
   - Present each finding
   - User decides: Fix / Skip / Discuss
   - Apply fixes as directed

4. **Completion**
   ```
   Quick-Dev Complete!

   Changes:
   - {N} files modified
   - {N} files created
   - {N} tests added

   Review:
   - {N} findings addressed
   - {N} findings deferred

   Ready to commit!
   ```

5. **Commit Message Format**

   Use conventional commits:
   ```
   feat(scope): add password reset functionality
   fix(scope): resolve null pointer in user service
   refactor(scope): extract validation logic to helper
   ```

   **Commit command:**
   ```bash
   git add <specific-files>
   git commit -m "feat(auth): add password reset flow

   - Add reset token generation
   - Add email sending for reset link
   - Add password update endpoint
   - Add validation for token expiry

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
   ```

   **Important:** Stage specific files, not `git add .` (avoid committing unrelated changes)

---

## Adversarial Review Mindset

The review step is CRITICAL. Approach with:

> "You are a cynical, jaded reviewer with zero patience for sloppy work.
> The content was submitted by someone who expects to find problems.
> Be skeptical of everything. Look for what's MISSING, not just what's wrong."

**Review Categories:**
- **Security:** Input validation, SQL injection, XSS, auth/authz
- **Error Handling:** Missing try/catch, swallowed errors, unclear messages
- **Edge Cases:** Null checks, boundary values, concurrent access
- **Code Quality:** DRY violations, unclear naming, complex functions
- **Testing:** Missing tests, inadequate coverage, untested paths
- **Performance:** N+1 queries, memory leaks, inefficient algorithms

**Zero findings is suspicious.** Re-analyze or ask for guidance.

---

## Example Session

```
User: quick-dev accbmad/2-planning/tech-spec-password-reset.md

Quick-Dev: Loading tech-spec...

Baseline captured: abc123

Mode A: Tech-Spec
Found 12 tasks, 8 acceptance criteria

Starting implementation...

## Step 3: Execute Implementation

Creating backend endpoint...
[Edit] api/routes/auth.js - Added POST /reset-password route
[Edit] api/services/passwordReset.js - Created reset service
[Edit] api/services/email.js - Added sendResetEmail function

Creating frontend...
[Edit] src/pages/ResetPassword.jsx - Created reset form
[Edit] src/api/auth.js - Added requestReset, confirmReset functions

Writing tests...
[Write] tests/api/passwordReset.test.js - 12 unit tests
[Write] tests/e2e/passwordReset.spec.js - 4 E2E tests

## Step 4: Self-Check

Functional Checklist: ✓ All passed
Security Checklist: ✓ All passed

Running tests...
✓ 24 tests passing (87% coverage)

## Step 5: Adversarial Review

Analyzing diff against baseline abc123...
Changed files: 6 modified, 2 created

**Adversarial Findings:**

| ID | Severity | Issue | Location |
|----|----------|-------|----------|
| F1 | High | Token not invalidated after successful reset | passwordReset.js:45 |
| F2 | Medium | No rate limiting on reset request endpoint | auth.js:23 |
| F3 | Medium | Error "Email not found" reveals email existence | passwordReset.js:28 |
| F4 | Low | Magic number 3600 should be TOKEN_EXPIRY_SECONDS | passwordReset.js:15 |

Critical: 0 | High: 1 | Medium: 2 | Low: 1

[A] Auto-fix all (let me handle it)
[S] Select which to fix
[I] Ignore all

User: A

## Step 6: Resolve Findings

Fixing F1 (High)...
[Edit] passwordReset.js:45 - Added: await Token.delete(token.id)
✓ Token now invalidated after use

Fixing F2 (Medium)...
[Edit] auth.js:23 - Added rate limiter middleware (5 req/15min)
✓ Rate limiting in place

Fixing F3 (Medium)...
[Edit] passwordReset.js:28 - Changed to generic "If email exists, reset link sent"
✓ Email enumeration prevented

Fixing F4 (Low)...
[Edit] passwordReset.js:1 - Added const TOKEN_EXPIRY_SECONDS = 3600
[Edit] passwordReset.js:15 - Replaced magic number
✓ Constant extracted

Re-running tests... ✓ 24 passing

---

Quick-Dev Complete!

Changes:
- 6 files modified
- 2 files created
- 24 tests added

Review:
- 4 findings addressed
- 0 findings deferred

Ready to commit:
git add api/routes/auth.js api/services/passwordReset.js api/services/email.js \
        src/pages/ResetPassword.jsx src/api/auth.js \
        tests/api/passwordReset.test.js tests/e2e/passwordReset.spec.js

git commit -m "feat(auth): add password reset functionality

- Add reset token generation with 1-hour expiry
- Add email sending for reset link
- Add password update endpoint with validation
- Add rate limiting (5 req/15min)
- Prevent email enumeration in error messages

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
```

---

## Integration with BMAD

Quick-Dev is the "Phase 4 Express" option. It complements:
- `/quick-spec` → produces specs that quick-dev consumes
- `/dev-story` → formal story implementation for sprint tracking
- `/code-review` → deeper review for PRs

---

## Notes for Claude

**Tool Usage:**
- Use Bash `git rev-parse HEAD` to capture baseline commit
- Use Glob to find relevant files
- Use Read to understand existing patterns
- Use Edit/Write to implement changes
- Use Bash to run tests: `npm test`, `pytest`, etc.
- Use Bash `git diff {baseline}` for review

**Key Principles:**
- ALWAYS capture baseline commit first
- Follow existing code patterns religiously
- Write tests alongside implementation, not after
- Self-check before adversarial review
- Zero findings in review is suspicious - dig deeper
- Present findings clearly with severity
- Offer auto-fix option for efficiency
- Don't skip steps even for "simple" changes

**LLM Optimization Principles:**
- **Clarity over verbosity** - Be precise and direct
- **Actionable instructions** - Every output guides implementation
- **Token efficiency** - Maximum information, minimum text
- **Unambiguous language** - Clear requirements, no interpretation needed

**Disaster Prevention:**
- Check for existing code before creating new
- Verify library/framework versions match project
- Confirm file locations follow project structure
- Ensure changes won't break existing tests

**Quality Checks:**
- All tests passing before completion
- No console.logs or debug code left
- Error handling in place
- Code matches project conventions

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| Tech-spec file not found | "Tech-spec not found at specified path." | Check path or use Mode B |
| No baseline commit | "Cannot capture git baseline. Ensure git is initialized." | Run `git init` |
| Tests fail after changes | "Tests failing. Address failures before proceeding." | Fix test failures |
| Escalation threshold met | "Scope appears too large for quick-dev." | Use `/dev-story` instead |
