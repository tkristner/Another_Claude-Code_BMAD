# [Scrum Master] Sprint Retrospective Workflow

**Goal:** Facilitate sprint or epic retrospective to extract lessons learned, celebrate wins, identify improvements, and create actionable commitments.

**Phase:** 4 - Implementation (Review)

**Agent:** Scrum Master

**Trigger keywords:** retrospective, retro, sprint review, epic review, lessons learned, what went well, improvements, start stop continue

**Inputs:** Completed sprint/epic, story files, sprint-status.yaml

**Output:** `docs/retrospective-{epic|sprint}-{number}-{date}.md`

**Duration:** 30-60 minutes depending on scope

---

## When to Use This Workflow

Use this workflow when:
- Completing a sprint (end of 1-2 week iteration)
- Finishing an epic (all stories in epic are done)
- After a significant milestone or release
- Team wants to reflect on recent work
- Preparing for the next sprint or epic

**Invoke:** `/retrospective` or `/sprint-retrospective` or `/retro`

---

## Pre-Flight

1. **Load project context** - Check for `accbmad/config.yaml` or `CLAUDE.md`
2. **Identify scope** - Sprint number or Epic number to review
3. **Load sprint status** - Check `accbmad/4-implementation/sprint.yaml` for completion status
4. **Find story files** - Gather completed stories for analysis

---

## Level-Specific Guidance

| Level | Scope | Depth |
|-------|-------|-------|
| **0-1** | Quick review | 15-20 min, informal |
| **2** | Standard retrospective | 30-45 min, structured |
| **3-4** | Comprehensive retrospective | 45-60 min, full analysis |

---

## Workflow Steps

### Step 1: Context Discovery

**Objective:** Gather all relevant data about the completed work.

1. **Identify Retrospective Scope**

   Ask user to clarify:
   - Sprint retrospective (Sprint N) OR
   - Epic retrospective (Epic N)
   - Date range covered

2. **Load Completed Stories**

   For the sprint/epic being reviewed:
   - Find all story files in `accbmad/4-implementation/stories/`
   - Extract story outcomes (done/blocked/carried over)
   - Note any dev notes or challenges documented

3. **Gather Metrics**

   ```
   | Metric | Value |
   |--------|-------|
   | Stories planned | {count} |
   | Stories completed | {count} |
   | Stories carried over | {count} |
   | Story points delivered | {points} |
   | Blockers encountered | {count} |
   ```

4. **Check Previous Retrospective**

   If exists, load previous retrospective:
   - What action items were committed?
   - Were they completed?
   - Did lessons get applied?

---

### Step 2: What Went Well

**Objective:** Celebrate wins and identify strengths to maintain.

1. **Review Successes**

   Guide reflection on:
   - Stories delivered on time
   - Technical wins (good patterns, clean code)
   - Collaboration successes
   - Process improvements that helped
   - User feedback received

2. **Prompt Questions**

   - What are you most proud of this sprint/epic?
   - What would you do exactly the same way again?
   - What helped the team move faster?
   - What technical decisions paid off?

3. **Capture Themes**

   Group successes into themes:
   - **Process:** What worked in how we work
   - **Technical:** What worked in how we build
   - **Collaboration:** What worked in how we communicate
   - **Quality:** What worked in maintaining standards

---

### Step 3: What Didn't Go Well

**Objective:** Identify challenges and pain points without blame.

**Ground Rules:**
- Focus on systems and processes, not people
- No blame or judgment
- Specific examples are better than generalizations
- Everything shared is for improvement, not criticism

1. **Review Challenges**

   Guide reflection on:
   - Stories that took longer than expected
   - Blockers encountered and their impact
   - Communication breakdowns
   - Technical debt incurred
   - Process friction points

2. **Prompt Questions**

   - What frustrated you this sprint/epic?
   - What would you do differently next time?
   - Where did we struggle or get stuck?
   - What slowed us down?

3. **Extract Patterns**

   Look for recurring issues:
   - Same problem in multiple stories?
   - Repeated feedback in code reviews?
   - Consistent estimation misses?
   - Common blockers?

---

### Step 4: Improvements

**Objective:** Generate actionable improvements.

1. **Brainstorm Improvements**

   For each challenge identified, ask:
   - What could prevent this in the future?
   - What process change would help?
   - What tooling would make this easier?
   - What knowledge gap needs filling?

2. **Categorize Improvements**

   **Start Doing:**
   - New practices to adopt
   - Tools to introduce
   - Processes to add

   **Stop Doing:**
   - Practices that hurt us
   - Processes that slow us down
   - Habits that create problems

   **Continue Doing:**
   - Working practices to keep
   - Processes that are helping
   - Habits that serve us well

3. **Prioritize**

   For each improvement, assess:
   - Impact: High/Medium/Low
   - Effort: High/Medium/Low
   - Focus on high-impact, low-effort first

---

### Step 5: Create Action Items

**Objective:** Convert improvements into specific, actionable commitments.

**Action Item Format:**

```markdown
### Action Item: {title}

**Owner:** {who is responsible}
**Deadline:** {when it should be done}
**Success Criteria:** {how we know it's done}
**Category:** Process | Technical | Documentation | Team
```

**Guidelines:**

- Limit to 2-4 action items per retrospective
- Each must have a clear owner
- Each must have a deadline
- Each must be verifiable (clear done criteria)
- Don't overcommit - fewer is better

**Example Action Items:**

```
1. Add PR template with security checklist
   Owner: Dev Lead
   Deadline: Next sprint start
   Success: Template in use, checklist checked on all PRs

2. Time-box spike tasks to 4 hours max
   Owner: Scrum Master
   Deadline: Immediate
   Success: No spikes exceed 4 hours in next sprint

3. Document API error codes
   Owner: Backend Dev
   Deadline: End of next sprint
   Success: Error codes page in docs/
```

---

### Step 6: Next Sprint/Epic Preparation

**Objective:** Connect lessons to upcoming work.

1. **Review Next Work**

   If next epic/sprint is defined:
   - What dependencies exist on completed work?
   - Are there gaps to fill before starting?
   - What preparation is needed?

2. **Knowledge Gaps**

   Identify and plan for:
   - Technical research needed
   - Documentation to create
   - Training or learning required

3. **Technical Debt**

   From this sprint/epic:
   - What debt was incurred?
   - What's the priority to address?
   - Should any be addressed before next work?

4. **Critical Path Items**

   ```
   CRITICAL (Must do before next sprint/epic):
   [ ] {item 1}
   [ ] {item 2}

   RECOMMENDED (Should do soon):
   [ ] {item 1}

   OPTIONAL (Would be nice):
   [ ] {item 1}
   ```

---

### Step 7: Generate Retrospective Document

**Objective:** Create permanent record of retrospective.

**Output:** `docs/retrospective-{scope}-{number}-{date}.md`

**Document Structure:**

```markdown
---
project: {project_name}
scope: {sprint|epic}
number: {N}
date: {date}
participants: Scrum Master (AI), User
---

# [Scrum Master] Retrospective: {Sprint|Epic} {N}

## Summary

| Metric | Value |
|--------|-------|
| Stories Completed | X/Y |
| Points Delivered | Z |
| Duration | N days |

## What Went Well

### Process
- {success 1}

### Technical
- {success 2}

### Collaboration
- {success 3}

## What Didn't Go Well

### Challenges
- {challenge 1}
- {challenge 2}

### Root Causes
- {cause 1}

## Improvements

### Start Doing
- {new practice}

### Stop Doing
- {bad practice}

### Continue Doing
- {good practice}

## Action Items

### 1. {Action Title}
- **Owner:** {name}
- **Deadline:** {date}
- **Success Criteria:** {how we know it's done}

### 2. {Action Title}
- **Owner:** {name}
- **Deadline:** {date}
- **Success Criteria:** {how we know it's done}

## Next Sprint/Epic Preparation

### Critical Path Items
- [ ] {item}

### Knowledge Gaps to Address
- {gap}

### Technical Debt
- {debt item} - Priority: {high/medium/low}

## Previous Action Item Follow-Up

| Action | Status | Notes |
|--------|--------|-------|
| {item from last retro} | Done/In Progress/Not Done | {notes} |

---

*Generated by BMAD Scrum Master*
```

---

### Step 8: Completion

1. **Save Document**

   Save to: `docs/retrospective-{scope}-{N}-{date}.md`

2. **Update Sprint Status**

   If `accbmad/4-implementation/sprint.yaml` exists:
   - Mark retrospective as completed
   - Update any relevant tracking

3. **Present Summary**

   ```
   Retrospective Complete!

   Reviewed: {Sprint|Epic} {N}
   Document: docs/retrospective-{scope}-{N}-{date}.md

   Key Takeaways:
   - {takeaway 1}
   - {takeaway 2}

   Action Items: {count}
   Critical Path Items: {count}

   Next Steps:
   [P] Plan next sprint (/sprint-planning)
   [S] Start next story (/dev-story)
   [V] View retrospective document
   ```

---

## Alternative Formats

### 4Ls Retrospective

Use when team prefers structured categories:

- **Liked:** What went well?
- **Learned:** What did we learn?
- **Lacked:** What was missing?
- **Longed for:** What do we wish we had?

### Mad/Sad/Glad

Use for quick emotional check-in:

- **Mad:** What frustrated us?
- **Sad:** What disappointed us?
- **Glad:** What made us happy?

### Sailboat

Use for visual/metaphorical approach:

- **Wind (Propelling):** What's pushing us forward?
- **Anchor (Holding Back):** What's slowing us down?
- **Rocks (Risks):** What dangers should we avoid?
- **Island (Goal):** Where are we trying to get to?

---

## Definition of Done

A retrospective is complete when all criteria below are satisfied:

### Content Requirements

| Category | Minimum | Requirements |
|----------|---------|--------------|
| What Went Well | ≥3 items | Each with specific example from sprint |
| What Could Improve | ≥3 items | Each with root cause identified |
| Action Items | ≥2 items | Each with owner, deadline, success criteria |

### Action Item Quality (REQUIRED)

Every action item MUST have:

| Field | Requirement | Example |
|-------|-------------|---------|
| **Description** | Specific, actionable task | "Add unit test coverage report to CI" |
| **Owner** | Single accountable person | "@sarah" |
| **Due Date** | Specific date | "2026-02-15" |
| **Success Criteria** | How to verify completion | "Coverage report visible in PR checks" |
| **Size** | Achievable in 1-2 weeks | Not "rewrite entire system" |

### Participation Check

- [ ] All team members contributed (or explicitly absent/excused)
- [ ] Both positive AND negative feedback captured
- [ ] No individual blame - focus on systems/processes
- [ ] Safe environment maintained throughout

### Previous Actions Review

- [ ] Previous retrospective action items reviewed
- [ ] Each marked: Completed / In Progress / Not Started / Dropped
- [ ] Incomplete items either carried forward or explicitly closed

### Format Compliance

At least one structured format used:
- [ ] Start/Stop/Continue, OR
- [ ] 4Ls (Liked, Learned, Lacked, Longed For), OR
- [ ] Mad/Sad/Glad, OR
- [ ] Sailboat (Wind/Anchor/Rocks/Island), OR
- [ ] Custom format (documented)

### Metrics Captured

- [ ] Sprint velocity noted (planned vs actual)
- [ ] Sprint goal achievement (met/partially/missed)
- [ ] Number of stories completed vs committed
- [ ] Key blockers identified

### Exit Criteria

Retrospective is complete when:
1. All content minimums met (3+3+2)
2. Every action item has owner AND deadline AND success criteria
3. Previous actions reviewed and addressed
4. Document saved to `docs/retrospective-sprint-{N}.md`
5. Action items added to next sprint backlog (if applicable)

**Not ready if:**
- Action items missing owners or deadlines
- Only positive OR only negative feedback (need both)
- Previous actions ignored
- Vague action items ("be better at testing")

---

## Notes for Claude

**Tool Usage:**
- Use Glob to find story files: `accbmad/4-implementation/stories/*.md`
- Use Read to load stories and previous retrospectives
- Use Write to save retrospective document
- Use TodoWrite to track action items

**Key Principles:**
- Psychological safety is paramount - no blame
- Focus on systems and processes, not individuals
- Specific examples are better than generalizations
- Action items must be achievable with clear ownership
- Limit action items to 2-4 (don't overcommit)
- Follow up on previous retrospective action items
- Connect learnings to upcoming work

**Quality Checks:**
- Every challenge has at least one improvement idea
- All action items have owners and deadlines
- Previous action items are reviewed
- Document is saved for future reference

**Remember:**
- Retrospectives are for learning, not blame
- Small improvements compound over time
- Following through on action items is crucial
- The best retrospective is one that leads to real change

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No sprint data | "Cannot run retrospective without sprint context." | Specify sprint/epic scope |
| No completed stories | "No completed stories found for retrospective." | Complete at least one story |
| Action items without owners | "All action items must have assigned owners." | Assign owners to action items |
| Missing previous retro review | "Must review previous retrospective actions." | Review previous action items |
