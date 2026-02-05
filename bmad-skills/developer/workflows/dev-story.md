# [Developer] Dev Story Workflow

**Purpose:** Implement user stories end-to-end with TDD, comprehensive testing, and adversarial code review to deliver production-ready code.

**Goal:** Implement a user story end-to-end with TDD, comprehensive testing, and adversarial code review.

**Phase:** 4 - Implementation (Execution)

**Agent:** Developer

**Trigger keywords:** dev story, implement story, dev STORY-ID, implement STORY-ID, full implementation, story implementation

**Inputs:** Story file from `accbmad/4-implementation/stories/STORY-*.md` or direct story ID

**Output:** Working, tested code with code review completed

**Duration:** Variable based on story complexity (1-8 hours typically)

---

## When to Use Dev-Story (vs Quick-Dev)

Use **Dev-Story** when:
- Implementing a formal story from sprint backlog
- Multi-component feature (frontend + backend + tests)
- Part of tracked sprint (story points, status tracking)
- Complex acceptance criteria (5+ ACs)
- Needs full TDD cycle

Use **Quick-Dev** when:
- Small, focused task (1-3 story points)
- Bug fix or refactor
- Has tech-spec from /quick-spec
- Single session work

**Invoke:** `/dev-story` or `/dev-story STORY-2-3`

---

## Pre-Flight

1. **Capture baseline commit** - `git rev-parse HEAD`
2. **Load project context** - Check for `CLAUDE.md` or `accbmad/config.yaml`
3. **Verify story exists** - Find in `accbmad/4-implementation/stories/` or sprint status
4. **Check dependencies** - Ensure blockers are resolved

---

## Workflow Steps

### Step 1: Find and Load Story

**Objective:** Identify which story to implement and load full context.

1. **User-Specified Story**

   If user provides story ID (e.g., "STORY-2-3" or "2-3"):
   - Find matching file in `accbmad/4-implementation/stories/`
   - Load complete story document
   - Proceed to Step 2

2. **Auto-Discovery**

   If no story specified and `accbmad/4-implementation/sprint.yaml` exists:
   - Parse YAML to find stories with status "ready-for-dev"
   - If multiple found: present list for selection
   - If one found: present for confirmation

   ```
   Found next story to implement:

   STORY-2-3: User Password Reset
   Points: 5
   Status: ready-for-dev

   [I] Implement - Start implementing this story now
   [S] Select - Choose a different story
   ```

   If multiple stories ready:
   ```
   Stories ready for implementation:
   1. STORY-2-3: User Password Reset (5 pts)
   2. STORY-2-4: Email Verification (3 pts)
   3. STORY-3-1: Product Listing (8 pts)

   Enter number to select, or [S] to specify path:
   ```

3. **No Stories Available**

   ```
   No ready-for-dev stories found.

   Options:
   [C] Create - Run /create-story to create a new story
   [P] Plan - Run /sprint-planning to plan sprint first
   [S] Specify - Enter story file path manually
   ```

---

### Step 2: Load Implementation Context

**Objective:** Gather all context needed for implementation.

1. **Parse Story Document**

   Extract from story file:
   - User story statement (As a/I want/So that)
   - All acceptance criteria
   - Technical notes and implementation approach
   - Files/modules affected
   - Data model changes
   - API changes
   - Edge cases
   - Security considerations
   - Testing requirements
   - Dependencies

2. **Load Architecture Context**

   From `accbmad/3-solutioning/architecture-*.md`:
   - Relevant component patterns
   - API conventions
   - Data model design
   - Security requirements

3. **Check Previous Stories**

   If not first story in epic:
   - Review patterns established
   - Check for dev notes and learnings
   - Identify code to reuse

4. **Understand Codebase Patterns**

   Scan existing code for:
   - File naming conventions
   - Code organization
   - Testing patterns
   - Error handling approach

---

### Step 3: Create Implementation Plan

**Objective:** Break story into implementable tasks.

Use TodoWrite to create task list:

```
Implementation Plan for STORY-{id}:

[ ] 1. Setup and preparation
    - [ ] 1.1 Create feature branch
    - [ ] 1.2 Review existing related code

[ ] 2. Backend/Data Layer
    - [ ] 2.1 Database migrations (if needed)
    - [ ] 2.2 Data models/entities
    - [ ] 2.3 Repository/service layer
    - [ ] 2.4 Unit tests for data layer

[ ] 3. Business Logic
    - [ ] 3.1 Core business logic
    - [ ] 3.2 Validation rules
    - [ ] 3.3 Error handling
    - [ ] 3.4 Unit tests for logic

[ ] 4. API/Backend Routes
    - [ ] 4.1 API endpoints
    - [ ] 4.2 Request validation
    - [ ] 4.3 Response formatting
    - [ ] 4.4 API tests

[ ] 5. Frontend/UI (if applicable)
    - [ ] 5.1 UI components
    - [ ] 5.2 Form handling
    - [ ] 5.3 State management
    - [ ] 5.4 Component tests

[ ] 6. Integration
    - [ ] 6.1 Integration tests
    - [ ] 6.2 E2E tests (critical paths)

[ ] 7. Documentation
    - [ ] 7.1 Update API docs
    - [ ] 7.2 Code comments for complex logic

[ ] 8. Validation
    - [ ] 8.1 All acceptance criteria verified
    - [ ] 8.2 All tests passing
    - [ ] 8.3 Security checklist complete
    - [ ] 8.4 Self code review
```

Adjust based on story scope - not all stories need all sections.

---

### Step 4: Execute Implementation (TDD Cycle)

**Objective:** Implement following Red-Green-Refactor pattern.

**CRITICAL RULES:**
- Follow task list sequence exactly
- Never skip writing tests
- Don't mark tasks complete until tests pass
- Don't proceed to next task with failing tests

**For Each Task:**

1. **RED Phase: Write Failing Test**

   ```
   Writing test for: {task description}

   [Test code that should fail]

   Running test... FAILED (as expected)
   ```

2. **GREEN Phase: Make Test Pass**

   ```
   Implementing minimal code to pass test...

   [Implementation code]

   Running test... PASSED
   ```

3. **REFACTOR Phase: Improve Code**

   ```
   Refactoring for clarity and maintainability...

   [Improved code]

   Running tests... STILL PASSING
   ```

4. **Mark Task Complete**

   Only mark `[x]` when:
   - Tests exist and pass
   - Code matches requirements
   - No regressions introduced

---

### Step 5: Continuous Validation

**Objective:** Validate as you implement, not just at the end.

**After Each Major Section:**

1. **Run Full Test Suite**

   ```bash
   npm test  # or equivalent
   ```

2. **Check for Regressions**

   If existing tests fail:
   - STOP implementation
   - Fix regression first
   - Understand what broke and why

3. **Validate Acceptance Criteria**

   Track which ACs are satisfied:
   ```
   Acceptance Criteria Status:
   [x] AC1: Valid password reset request
   [x] AC2: Invalid email handling
   [ ] AC3: Token expiration
   [ ] AC4: Password update
   ```

---

### Step 6: Security Validation

**Objective:** Ensure security requirements are met.

**Security Checklist (Mandatory):**

```
Security Validation:

[ ] Inputs validated and sanitized
[ ] SQL injection prevented (parameterized queries)
[ ] XSS prevented (output encoding)
[ ] Authentication checked where required
[ ] Authorization verified for resources
[ ] No secrets hardcoded
[ ] Error messages don't leak internals
[ ] Rate limiting considered (if applicable)
[ ] Sensitive data encrypted (if applicable)
```

**Common Security Patterns:**

- Input validation: Validate all external inputs
- SQL: Use parameterized queries, never string concat
- XSS: Escape output, use safe templating
- Auth: Check permissions on every request
- Secrets: Use environment variables

---

### Step 7: Final Validation

**Objective:** Verify story is complete before review.

1. **All Tasks Complete**

   Verify all task checkboxes are marked:
   ```
   Implementation Tasks: 15/15 complete
   ```

2. **All ACs Satisfied**

   Verify every acceptance criterion:
   ```
   AC1: Valid reset request ✓
   AC2: Invalid email handling ✓
   AC3: Token expiration ✓
   AC4: Password update ✓

   All 4 acceptance criteria SATISFIED
   ```

3. **All Tests Passing**

   ```
   Test Results:
   - Unit tests: 24/24 passing
   - Integration tests: 8/8 passing
   - Coverage: 87%

   All tests PASSING
   ```

4. **Code Quality**

   ```
   Quality Checks:
   - Linting: No errors
   - No console.logs or debug code
   - No TODO comments left
   - Error handling complete
   ```

---

### Step 8: Adversarial Code Review

**Objective:** Find problems before they reach production.

1. **Construct Diff**

   ```bash
   git diff {baseline_commit}
   ```

   Include all new untracked files.

2. **Review with Adversarial Mindset**

   > "You are a cynical, jaded reviewer with zero patience for sloppy work.
   > Be skeptical of everything. Look for what's MISSING, not just what's wrong."

3. **Review Categories:**

   - **Security:** Input validation, injection risks, auth/authz
   - **Error Handling:** Missing try/catch, unclear messages
   - **Edge Cases:** Null checks, boundaries, concurrency
   - **Code Quality:** DRY violations, naming, complexity
   - **Testing:** Missing tests, inadequate coverage
   - **Performance:** N+1 queries, memory leaks

4. **Document Findings**

   ```
   Code Review Findings:

   | ID | Severity | Issue | Location |
   |----|----------|-------|----------|
   | F1 | High | Token not invalidated after use | auth.ts:45 |
   | F2 | Medium | No rate limiting on endpoint | routes.ts:23 |
   | F3 | Low | Magic number should be constant | utils.ts:15 |

   Critical: 0 | High: 1 | Medium: 1 | Low: 1
   ```

5. **MINIMUM 3 FINDINGS**

   If zero findings, re-analyze. Something was missed.

---

### Step 9: Resolve Findings

**Objective:** Address review findings.

```
Review Summary:
- Critical: 0
- High: 1
- Medium: 1
- Low: 1

[A] Auto-fix - Claude fixes all findings automatically
[S] Select - Choose which findings to fix (interactive)
[I] Ignore - User will handle fixes manually (not recommended)
```

**Note:** If Critical or High findings exist, auto-fix is recommended before proceeding.

**For Auto-Fix:**

1. Address each finding systematically
2. Re-run tests after each fix
3. Add tests for issues found (regression prevention)
4. Re-run adversarial review if High/Critical fixed

**After Fixes:**

```
Findings Resolved:
- F1: Token invalidation added ✓
- F2: Rate limiting implemented ✓
- F3: Constant extracted ✓

All tests still passing: ✓
```

---

### Step 10: Update Sprint Status

**Objective:** Mark story complete and update tracking.

1. **Update Story Status**

   In story file:
   - Status: `completed`
   - Add completion notes

2. **Update Sprint Status**

   If `accbmad/4-implementation/sprint.yaml` exists:
   - Update story status to "done"
   - Add completion timestamp

3. **Commit Changes**

   ```bash
   git add <specific-files>
   git commit -m "feat(scope): implement {story title}

   - {change 1}
   - {change 2}
   - {change 3}

   Story: STORY-{id}
   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
   ```

---

### Step 11: Completion Summary

**Objective:** Present final summary.

```
Story Implementation Complete!

Story: STORY-{id} - {title}
Points: {estimate}
Status: completed

Implementation Summary:
- Files created: {count}
- Files modified: {count}
- Lines added: {count}
- Lines removed: {count}

Testing:
- Unit tests: {count} passing
- Integration tests: {count} passing
- Coverage: {percent}%

Quality:
- All acceptance criteria met ✓
- Security checklist complete ✓
- Code review findings resolved ✓

Commit: {commit_hash}

Next Steps:
[N] Start next story (/dev-story)
[R] Run retrospective (/retrospective)
[V] View completed story
```

---

---

## Subagent Strategy

For complex stories, use parallel agents to maximize efficiency.

### Pattern: Layer Parallel Implementation
**When:** Story touches multiple layers (backend + frontend + tests)
**Agents:** 3-4 parallel agents

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Backend/data layer implementation | Backend code + unit tests |
| Agent 2 | Business logic implementation | Service layer + tests |
| Agent 3 | Frontend/UI implementation | Components + tests |
| Agent 4 | Integration tests | E2E and integration tests |

**Coordination:**
1. Main context loads story and creates implementation plan
2. Write shared context to `accbmad/context/story-context.md`
3. Launch backend agent first (others depend on it)
4. Launch logic and frontend agents in parallel after backend
5. Launch test agent after all implementation complete
6. Main context runs final validation and code review

### Pattern: Test Writing Parallel
**When:** Large codebase needs test coverage
**Agents:** N parallel agents (one per module)

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Unit tests for module A | tests/module-a/*.test.* |
| Agent 2 | Unit tests for module B | tests/module-b/*.test.* |
| Agent N | Integration tests | tests/integration/*.test.* |

---

## HALT Conditions

**Stop and ask for guidance when:**

- Dependencies not available (blocked by unfinished story)
- Requirements ambiguous (AC unclear)
- 3+ consecutive test failures
- Security concern requiring user decision
- External API/service unavailable
- Database migration issues
- Major architecture decision needed
- Merge conflicts that require human decision

**Never stop for:**

- "Good progress" or "milestone reached"
- "Session boundaries"
- Preferring to pause for review (unless HALT condition)

---

## HALT Recovery Paths

### Recovery: Database Migration Failure

**Symptoms:**
- Migration script fails with error
- Database in inconsistent state
- Tests fail due to schema mismatch

**Recovery Steps:**

1. **Assess damage:**
   ```bash
   # Check migration status (adapt to your framework)
   npm run migrate:status
   # or: python manage.py showmigrations
   # or: npx prisma migrate status
   ```

2. **Rollback if possible:**
   ```bash
   npm run migrate:rollback
   # or: python manage.py migrate <app> <previous_migration>
   # or: npx prisma migrate reset (caution: drops data)
   ```

3. **If rollback fails:**
   - Restore from backup (if available)
   - Manual SQL to fix schema state
   - Document what went wrong for future reference

4. **Fix migration:**
   - Identify root cause (syntax, constraints, data issues)
   - Update migration script
   - Test on fresh database first

5. **Resume:**
   - Re-run migration
   - Verify tests pass
   - Continue with story implementation

**Prevention:**
- Always backup before migrations in production
- Test migrations on copy of production data
- Use transactions where possible
- Keep migrations small and focused

---

### Recovery: Story Blocked by Dependency

**Symptoms:**
- Story depends on incomplete work from another story
- External API or service not available
- Waiting on another team member's PR

**Recovery Steps:**

1. **Document the blocker:**
   - Update story status to "blocked"
   - Note what's blocking and who owns it
   - Update sprint-status.yaml:
     ```yaml
     - story_id: "STORY-XXX"
       status: "blocked"
       blocked_by: "STORY-YYY not complete"
       blocked_since: "2026-02-03"
     ```

2. **Evaluate options:**

   | Option | When to Use |
   |--------|-------------|
   | **Wait** | Unblocking is imminent (< 1 day) |
   | **Mock** | Can create stub to continue work |
   | **Swap** | Other stories available in sprint |
   | **Escalate** | Blocking critical path, needs intervention |

3. **If mocking:**
   - Create interface-based mock/stub
   - Document mock limitations clearly
   - Create follow-up task to remove mock
   - Mark story as "in_progress (with mock)"

4. **Resume when unblocked:**
   - Remove mock if used
   - Complete original implementation
   - Update status to "in_progress"
   - Re-run all tests

**Prevention:**
- Identify dependencies during sprint planning
- Prioritize blocking stories first
- Communicate daily about blockers

---

### Recovery: Merge Conflicts

**Symptoms:**
- `git merge` or `git rebase` shows conflicts
- CI/CD fails due to merge issues
- Multiple developers touched same files

**Recovery Steps:**

1. **Assess scope:**
   ```bash
   git status  # See conflicted files
   git diff --name-only --diff-filter=U  # List only conflicted files
   ```

2. **For simple conflicts (< 3 files):**
   ```bash
   # Open each file, look for conflict markers
   # <<<<<<< HEAD
   # Your changes
   # =======
   # Their changes
   # >>>>>>> branch-name

   # Resolve manually, then:
   git add <resolved-files>
   git commit -m "Resolve merge conflicts in <files>"
   ```

3. **For complex conflicts:**
   - Communicate with the other developer
   - Pair on resolution if needed
   - Decide which changes take precedence
   - Consider using merge tools:
     ```bash
     git mergetool  # Opens configured merge tool
     ```

4. **If stuck or unsure:**
   ```bash
   # Abort and start fresh
   git merge --abort   # If merging
   git rebase --abort  # If rebasing
   ```

5. **After resolution:**
   - Run full test suite
   - Verify both sets of changes work together
   - Push to trigger CI validation

**Prevention:**
- Pull/rebase frequently (daily minimum)
- Communicate about shared files
- Keep PRs small and focused
- Use feature flags for parallel development

---

### Recovery: 3+ Consecutive Test Failures

**Symptoms:**
- Same test fails repeatedly after fixes
- Test is flaky (sometimes passes, sometimes fails)
- Root cause unclear

**Recovery Steps:**

1. **Isolate the test:**
   ```bash
   # Run only the failing test
   npm test -- --grep "failing test name"
   # or: pytest -k "test_name" -v
   ```

2. **Check for flakiness:**
   ```bash
   # Run test multiple times
   for i in {1..10}; do npm test -- --grep "test name"; done
   ```

3. **Debug systematically:**
   - Add logging/console output
   - Check test isolation (does it pass alone?)
   - Verify test data/fixtures are correct
   - Check for async/timing issues

4. **If truly stuck:**
   - Skip test temporarily with explanation:
     ```javascript
     it.skip('failing test - see STORY-XXX', () => { ... });
     ```
   - Create follow-up task to fix
   - Continue with other work

5. **Document findings:**
   - Note root cause when found
   - Update test if it was incorrect
   - Add regression test if bug was real

**Prevention:**
- Write deterministic tests (no random, no time-dependent)
- Ensure proper test isolation
- Use test fixtures consistently

---

## Notes for Claude

**Tool Usage:**
- Use `git rev-parse HEAD` to capture baseline
- Use Glob to find story files: `accbmad/4-implementation/stories/STORY-*.md`
- Use Read to load story and architecture
- Use Edit/Write to implement changes
- Use Bash to run tests
- Use `git diff {baseline}` for review

**Key Principles:**
- NEVER lie about task completion
- NEVER mark done without passing tests
- Follow TDD: Red → Green → Refactor
- Security is mandatory, not optional
- Minimum 3 findings in code review (if zero, look harder)
- Don't stop prematurely

**Quality Checks:**
- All acceptance criteria satisfied
- All tests passing
- Security checklist complete
- Code review findings resolved
- No debug code left
- Documentation updated

**DISASTER PREVENTION:**
- Check for existing code before creating new
- Match project patterns and conventions
- Don't reinvent existing utilities
- Verify library versions match project
- Follow architecture document strictly
