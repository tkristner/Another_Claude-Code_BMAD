# [Developer] Expedited Fix Workflow

**Goal:** Rapidly fix urgent issues with minimal ceremony while maintaining quality and safety.

**Phase:** 4 - Implementation (Emergency)

**Agent:** Developer

**Trigger keywords:** expedited fix, hotfix, urgent fix, emergency fix, production issue, quick fix urgent, critical bug, production down, security vulnerability

**Inputs:** Issue description, affected system/component, urgency level

**Output:** Fix committed, optional post-hoc documentation

**Duration:** 15-60 minutes (fix only), +15 min for documentation

---

## When to Use This Workflow

### USE for:

- Production outages (service unavailable)
- Critical security vulnerabilities
- Data corruption or data loss issues
- Blocking bugs affecting multiple users NOW
- Time-sensitive fixes (before demo, launch, deadline)
- Regulatory compliance issues requiring immediate action

### DO NOT USE for:

- Feature development → Use `/dev-story`
- Non-urgent bugs → Use `/quick-dev`
- Refactoring → Use `/dev-story`
- "Urgent" requests that can actually wait
- Performance improvements (unless causing outage)
- Technical debt cleanup

### Decision Tree

```
Is production down or data at risk?
├── Yes → Use /expedited-fix
└── No → Is it blocking multiple users RIGHT NOW?
    ├── Yes → Use /expedited-fix
    └── No → Can it wait until tomorrow?
        ├── Yes → Use /quick-dev or /dev-story
        └── No → Use /expedited-fix (document justification)
```

**Invoke:** `/expedited-fix` or `/hotfix`

---

## Pre-Flight (2 minutes max)

1. **Confirm urgency** - Is this truly expedited? (Ask: "What happens if we wait 1 hour?")
2. **Identify scope** - What's broken? Where is it?
3. **Notify team** - Alert relevant people (Slack, Teams, etc.)
4. **Create branch** - `hotfix/brief-description` from production branch

```bash
git checkout main
git pull origin main
git checkout -b hotfix/{{issue_slug}}
```

---

## Workflow Steps

### Step 1: Triage (5 minutes)

**Quick assessment:**

| Question | Answer |
|----------|--------|
| What is broken? | {{description}} |
| Who is affected? | {{scope}} |
| When did it start? | {{timestamp}} |
| What changed recently? | {{recent_changes}} |

**Capture minimum context (in PR or commit):**

```markdown
## Expedited Fix: {{brief_description}}

**Urgency:** Critical | High
**Impact:** {{description_of_impact}}
**Reported:** {{timestamp}}
**Assignee:** {{your_name}}
```

**Skip detailed documentation if truly critical** - verbal/Slack acknowledgment is sufficient initially.

---

### Step 2: Reproduce (5-10 minutes)

1. **Reproduce the issue** locally or in staging
2. **Identify root cause** - What exactly is failing?
3. **Determine minimal fix** - Smallest change that resolves it

**If cannot reproduce:**

```
Options:
1. Add logging/monitoring and deploy to gather data
2. Review recent commits for likely culprit
3. Check error logs/APM for clues
4. Consider: Is this truly urgent if we can't reproduce?
```

**Document reproduction steps:**

```markdown
## Reproduction
1. {{step_1}}
2. {{step_2}}
3. Error: {{error_message}}
```

---

### Step 3: Fix (10-30 minutes)

**Fix Guidelines:**

| Principle | What it means |
|-----------|---------------|
| **Minimal change** | Fix only what's broken, nothing more |
| **No refactoring** | Save improvements for later |
| **No scope creep** | One issue only |
| **Obvious solution** | Not clever, not optimized - just working |
| **Reversible** | Easy to rollback if needed |

**Security Standards (ALWAYS apply):**

- [ ] No security vulnerabilities introduced
- [ ] No credentials in code
- [ ] No SQL injection possible
- [ ] No XSS vulnerabilities
- [ ] Basic input validation
- [ ] Error handling (don't expose internals)

**Code Checklist:**

```
[ ] Fix addresses the root cause (not just symptoms)
[ ] No obvious bugs in the fix
[ ] Handles edge cases of the specific issue
[ ] Doesn't break unrelated functionality
```

---

### Step 4: Test (5-10 minutes)

**Minimum Testing Required:**

- [ ] Issue is fixed (manual verification)
- [ ] No obvious regression in affected area
- [ ] Existing tests pass (run fast test suite)
- [ ] Basic smoke test of main flow

**Testing Documentation:**

```markdown
## Testing
- [x] Verified fix resolves original issue
- [x] Smoke tested affected functionality
- [x] Existing tests pass
- [ ] Full regression (scheduled post-deploy)
```

**When to skip testing:**

Only if ALL of these are true:
1. Production is literally down/unusable
2. Fix is trivial (typo, config change)
3. Rollback is ready and tested
4. You accept explicit responsibility

---

### Step 5: Review & Merge (5 minutes)

**Even in emergencies, get another pair of eyes:**

- [ ] Quick pair review (even 2-minute walkthrough)
- [ ] Or: explain fix verbally to teammate
- [ ] Or: post in channel, merge after 2 min if no objections

**Commit Message Format:**

```
fix({{scope}}): {{brief description}} [HOTFIX]

- Root cause: {{what was wrong}}
- Fix: {{what this commit does}}
- Testing: {{what was verified}}

Resolves: {{issue_link_if_exists}}
```

**Merge Strategy:**

```bash
git add {{files}}
git commit -m "fix({{scope}}): {{description}} [HOTFIX]"
git push origin hotfix/{{issue_slug}}
# [Developer] Create PR → Quick review → Merge to main
```

---

### Step 6: Deploy (5-10 minutes)

**Deployment Checklist:**

- [ ] Code reviewed (even briefly)
- [ ] Merged to main/production branch
- [ ] Deployed to staging (if time permits)
- [ ] Deployed to production
- [ ] Verified fix works in production
- [ ] Monitoring shows improvement

**Rollback Plan (ALWAYS have this ready):**

```markdown
## Rollback Procedure

If fix causes issues:

1. Identify: Check monitoring dashboards for new errors
2. Decide: Is this worse than the original issue?
3. Revert:
   ```bash
   git revert {{commit_hash}}
   git push origin main
   # Deploy revert
   ```
4. Notify: Alert team that rollback occurred
5. Regroup: Return to Step 2 with more information
```

**Monitor post-deploy:**

- Check error rates for 5-15 minutes
- Verify affected functionality
- Watch for related issues

---

### Step 7: Post-Fix Documentation (15 minutes, can be async)

**Create incident record within 24 hours:**

Save to: `docs/incidents/{{YYYY-MM-DD}}-{{slug}}.md`

```markdown
# [Developer] Incident: {{YYYY-MM-DD}} - {{brief_description}}

**Severity:** Critical | High | Medium
**Duration:** {{start_time}} - {{end_time}} ({{total_minutes}} minutes)
**Status:** Resolved

---

## Timeline

| Time | Event |
|------|-------|
| {{HH:MM}} | Issue reported by {{reporter}} |
| {{HH:MM}} | Investigation started |
| {{HH:MM}} | Root cause identified |
| {{HH:MM}} | Fix deployed |
| {{HH:MM}} | Verified resolved |

---

## Root Cause

{{detailed_description_of_what_went_wrong}}

---

## Fix Applied

{{description_of_the_fix}}

- Commit: {{commit_hash}}
- PR: {{pr_link}}
- Files changed: {{list}}

---

## Impact

| Metric | Value |
|--------|-------|
| Duration | {{minutes}} |
| Users affected | {{estimate}} |
| Data impact | None / {{description}} |
| Revenue impact | None / {{estimate}} |

---

## Follow-up Actions

- [ ] Add regression test for this scenario
- [ ] Update monitoring/alerting
- [ ] Create story for proper fix (if expedited was temporary)
- [ ] Post-mortem meeting (if significant incident)
- [ ] Update runbooks/documentation

---

## Lessons Learned

{{what_can_we_do_to_prevent_this_in_the_future}}
```

---

### Step 8: Sprint Integration (Optional)

If tracking in BMAD sprint, add hotfix entry:

```yaml
# [Developer] In sprint-status.yaml, add under current sprint stories:
- story_id: "HOTFIX-{{YYYY-MM-DD}}"
  title: "{{brief_description}}"
  points: 1  # Expedited fixes count as 1 point
  priority: "must_have"
  status: "completed"
  type: "expedited_fix"
  incident_doc: "docs/incidents/{{YYYY-MM-DD}}-{{slug}}.md"
```

---

## Quality Safeguards

**Even in expedited mode, ALWAYS:**

- [ ] No credentials/secrets in code
- [ ] No SQL injection possible
- [ ] No XSS vulnerabilities
- [ ] Basic error handling present
- [ ] Someone else sees the code (even 2-minute review)
- [ ] Rollback plan exists

**NEVER (even in emergency):**

- Disable security controls "temporarily"
- Skip authentication checks
- Expose internal error details to users
- Deploy completely untested code
- Merge without any review

---

## After Expedited Fix

**Within 24-48 hours:**

1. [ ] Complete incident documentation
2. [ ] Full regression testing if skipped
3. [ ] Proper code review if abbreviated
4. [ ] Create follow-up story if fix was temporary
5. [ ] Add monitoring for similar issues
6. [ ] Update team in standup/retrospective

**Consider:**

- Is a post-mortem needed?
- Should on-call procedures be updated?
- Are there similar issues waiting to happen?

---

## Definition of Done

Expedited fix is complete when:

- [ ] Issue is resolved in production
- [ ] Fix is committed with clear message
- [ ] Rollback plan was prepared
- [ ] At least one other person reviewed code
- [ ] Monitoring confirms resolution
- [ ] Incident documentation created (can be async)

---

## Integration

**Works Standalone** - No prerequisites required

**Related Workflows:**

| Situation | Workflow |
|-----------|----------|
| Non-urgent quick fix | `/quick-dev` |
| Planned development | `/dev-story` |
| Post-fix code review | `/code-review` |
| Create follow-up story | `/create-story` |

---

## Notes for Claude

**Tool Usage:**

- Use Bash for git operations and deployment commands
- Use Read to understand affected code
- Use Edit for minimal, targeted fixes
- Use Write for incident documentation

**Key Principles:**

- Speed over ceremony, but NOT over safety
- Minimal viable fix - don't expand scope
- Document asynchronously if needed
- Always have rollback ready
- Get another human to look at the code

**HALT if:**

- Fix seems to require major changes (scope creep)
- Cannot reproduce the issue
- Fix introduces security concerns
- Multiple systems affected (need coordination)

**Remember:**

This workflow exists because emergencies happen. Having a structured fast-path is better than ad-hoc chaos. But "expedited" is not "reckless" - safety guardrails still apply.
