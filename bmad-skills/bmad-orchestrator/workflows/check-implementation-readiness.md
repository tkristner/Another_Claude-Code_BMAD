# Check Implementation Readiness Workflow

**Goal:** Validate that all Phase 3 deliverables are complete before starting implementation.

**Phase:** Phase 3→4 Transition Gate

**Agent:** BMAD Orchestrator

**Trigger keywords:** check implementation readiness, implementation gate, ready for implementation, phase 4 gate, solutioning complete, readiness check, pre-implementation, ready to build

**Inputs:** Project documentation (PRD, Architecture, Epics, Stories)

**Output:** Readiness Report with PASS/FAIL status and specific remediation steps

**Duration:** 15-30 minutes

---

## When to Use This Workflow

Use this workflow:
- **Before Sprint 1** - Final validation before committing development resources
- **After completing architecture design** - Verify Phase 3 deliverables
- **When onboarding new team members** - Verify project state for context
- **Before major milestones** - Ensure prerequisites are met

**Invoke:** `/check-implementation-readiness` or `/solutioning-gate-check`

**Relationship to `/validate-phase-transition 3 4`:** This workflow provides **deeper validation** than Gate 3 in the phase transition workflow. Use this for the comprehensive final check; use `/validate-phase-transition` for quick alignment verification.

---

## Pre-Flight

1. **Load project configuration** - Read `accbmad/config.yaml` for project level
2. **Determine validation scope**:
   - Level 0-1: PRD completeness, story coverage, estimation only
   - Level 2+: Full validation including architecture
3. **Locate all documents**:
   - PRD: `accbmad/2-planning/prd-*.md` or `accbmad/2-planning/prd.md`
   - Architecture: `accbmad/3-solutioning/architecture-*.md` (Level 2+)
   - Stories: `accbmad/4-implementation/stories/STORY-*.md`
   - Epics: Extract from PRD or `docs/epics/EPIC-*.md`
   - Sprint Status: `accbmad/4-implementation/sprint.yaml` or `bmad/sprint-status.yaml`

---

## Validation Categories

### Category 1: PRD Completeness Check

**Applies to:** All project levels

| ID | Criterion | Required | Validation Method |
|----|-----------|----------|-------------------|
| PRD-01 | Executive Summary | Yes | Section exists, ≥3 sentences, no placeholders |
| PRD-02 | Problem Statement | Yes | Section exists, clear problem definition |
| PRD-03 | Goals & Objectives | Yes | At least 2 measurable goals with success criteria |
| PRD-04 | User Segments/Personas | Yes | At least 1 user persona with needs documented |
| PRD-05 | Functional Requirements | Yes | At least 1 FR with ID (FR-XXX), priority, ACs |
| PRD-06 | Non-Functional Requirements | Yes | At least 1 NFR with measurable target |
| PRD-07 | Success Metrics | Yes | At least 3 KPIs with quantitative targets |
| PRD-08 | Scope Boundaries | Yes | Both in-scope AND out-of-scope sections defined |
| PRD-09 | No Placeholder Values | Yes | No "TBD", "TODO", "PLACEHOLDER", "XXX" in content |

**Validation Steps:**

```
1. Read PRD file
2. For each criterion:
   a. Search for required section header
   b. Validate content meets minimum requirements
   c. Scan for placeholder patterns: /TBD|TODO|PLACEHOLDER|XXX|\[.*\]/i
3. Score: (passed_criteria / total_criteria) * 100
```

**Pass Threshold:** 100% (9/9 criteria)

**Common Issues:**

| Issue | Remediation |
|-------|-------------|
| Missing executive summary | Add 3-5 sentence overview at document start |
| No measurable goals | Convert vague goals to SMART format |
| FRs without IDs | Number all requirements: FR-001, FR-002... |
| TBD values present | Replace each TBD with actual content |
| Missing out-of-scope | Explicitly list what is NOT included |

---

### Category 2: Architecture Completeness Check

**Applies to:** Level 2+ projects only (skip for Level 0-1)

| ID | Criterion | Required | Validation Method |
|----|-----------|----------|-------------------|
| ARCH-01 | System Overview | Yes | High-level description with context |
| ARCH-02 | Component Design | Yes | At least 2 components with responsibilities |
| ARCH-03 | Data Model | Yes | Entities and relationships documented |
| ARCH-04 | API Contracts | Conditional | Required if system exposes/consumes APIs |
| ARCH-05 | Technology Stack | Yes | Languages, frameworks, infrastructure listed |
| ARCH-06 | Security Design | Yes | Authentication/authorization approach documented |
| ARCH-07 | ADRs | Recommended | At least 1 ADR for major technology decisions |

**Validation Steps:**

```
1. Check project level from config
2. If Level < 2: Skip this category (auto-pass)
3. If Level >= 2:
   a. Read architecture document
   b. Validate each required criterion
   c. For conditional criteria, check if applicable
4. Score: (passed_criteria / applicable_criteria) * 100
```

**Pass Threshold:** 100% of required criteria

**API Detection Heuristic:**
- Check PRD for terms: "API", "endpoint", "REST", "GraphQL", "integration"
- If found, ARCH-04 becomes required

**Common Issues:**

| Issue | Remediation |
|-------|-------------|
| No component breakdown | Add Components section with responsibilities |
| Data model missing | Create entity-relationship description |
| No security section | Document auth approach, even if "N/A for MVP" |
| Missing ADRs | Run `/adr-create` for major decisions |

---

### Category 3: Epic/Story FR Coverage Check

**Applies to:** All project levels

**Goal:** Verify 100% bidirectional traceability: FR → Epic → Story

| ID | Validation | Requirement |
|----|------------|-------------|
| COV-01 | FR→Epic Mapping | Every FR-XXX maps to at least 1 Epic |
| COV-02 | Epic→Story Breakdown | Every Epic has at least 1 Story |
| COV-03 | Story→FR Traceability | Every Story references its source FR |
| COV-04 | Orphan Detection | No Stories without FR connection |
| COV-05 | Coverage Completeness | 100% of FRs have implementing stories |

**Traceability Matrix Construction:**

```
1. Extract all FR IDs from PRD: FR-001, FR-002, ...
2. Extract all Epic IDs: EPIC-001, EPIC-002, ... (from PRD or epic files)
3. Extract all Story IDs: STORY-001, STORY-002, ... (from story files)
4. Build mappings:
   a. For each FR, find which Epics reference it
   b. For each Epic, find which Stories implement it
   c. For each Story, verify FR reference exists
5. Identify gaps:
   a. FRs with no Epic → Missing epic
   b. Epics with no Stories → Missing breakdown
   c. Stories with no FR → Orphan story
```

**Pass Threshold:** 100% coverage (COV-05)

**Output Format:**

```markdown
## FR→Epic→Story Traceability Matrix

| FR ID | Description | Epic(s) | Stories | Status |
|-------|-------------|---------|---------|--------|
| FR-001 | User login | EPIC-001 | STORY-001, STORY-002 | ✓ Covered |
| FR-002 | Password reset | EPIC-001 | STORY-003 | ✓ Covered |
| FR-003 | Data export | - | - | ✗ No Epic |

**Coverage:** 2/3 FRs covered (67%)
```

**Common Issues:**

| Issue | Remediation |
|-------|-------------|
| FR not mapped to Epic | Add FR to existing Epic or create new Epic |
| Epic has no Stories | Run `/create-story` for each Epic |
| Orphan Story | Add FR reference or remove if obsolete |
| Missing FR in Story | Update Story with `Implements: FR-XXX` |

---

### Category 4: Dependency Health Check

**Applies to:** All project levels

**Goal:** Ensure story dependencies are valid and acyclic.

| ID | Validation | Requirement |
|----|------------|-------------|
| DEP-01 | No Circular Dependencies | 0 cycles in dependency graph |
| DEP-02 | Valid References | All `depends_on` reference existing stories |
| DEP-03 | Blocked Ratio | <30% of stories should be blocked |
| DEP-04 | Blocker Chain Length | No chain >3 levels deep |

**Cycle Detection Algorithm (DFS-based):**

```python
def detect_cycles(stories):
    """
    Detect circular dependencies using DFS with coloring.

    Colors:
    - WHITE (0): Unvisited
    - GRAY (1): In current path (visiting)
    - BLACK (2): Fully processed
    """
    color = {s.id: WHITE for s in stories}
    cycles = []

    def dfs(story_id, path):
        if color[story_id] == GRAY:
            # Found cycle - extract it from path
            cycle_start = path.index(story_id)
            cycles.append(path[cycle_start:] + [story_id])
            return

        if color[story_id] == BLACK:
            return  # Already processed

        color[story_id] = GRAY
        path.append(story_id)

        for dep in get_dependencies(story_id):
            if dep not in color:
                # Invalid reference
                log_warning(f"{story_id} depends on non-existent {dep}")
                continue
            dfs(dep, path)

        path.pop()
        color[story_id] = BLACK

    for story in stories:
        if color[story.id] == WHITE:
            dfs(story.id, [])

    return cycles
```

**Dependency Extraction:**

From sprint-status.yaml:
```yaml
stories:
  - story_id: "STORY-001"
    depends_on: ["STORY-002", "STORY-003"]
```

From Story files (accbmad/4-implementation/stories/STORY-*.md):
```markdown
## Dependencies
- **Depends on:** STORY-002, STORY-003
- **Blocks:** STORY-004
```

**Pass Threshold:**
- DEP-01: 0 cycles (mandatory)
- DEP-02: 100% valid references
- DEP-03: <30% blocked
- DEP-04: Chain ≤3 levels

**Common Issues:**

| Issue | Remediation |
|-------|-------------|
| Circular dependency | Refactor: merge stories or break cycle |
| Invalid reference | Fix story ID or remove dependency |
| Too many blocked | Re-prioritize or split blocking stories |
| Deep chain | Parallelize work by reducing dependencies |

---

### Category 5: Estimation Completeness Check

**Applies to:** All project levels

| ID | Criterion | Validation |
|----|-----------|------------|
| EST-01 | Points Assigned | 100% of stories have story points |
| EST-02 | Valid Point Values | All points in Fibonacci: 1, 2, 3, 5, 8, 13 |
| EST-03 | No Large Stories | No stories >8 points (recommend split) |
| EST-04 | Total Estimated | Sprint capacity calculation possible |
| EST-05 | Consistent Sizing | No >3x variance for similar work |

**Validation Steps:**

```
1. Load all stories from sprint-status.yaml or story files
2. For each story:
   a. Check points field exists and is numeric
   b. Verify value is in [1, 2, 3, 5, 8, 13]
   c. Flag stories >8 as oversized
3. Calculate totals:
   a. Total stories
   b. Stories with points
   c. Stories without points
   d. Oversized stories
4. Score: (stories_with_valid_points / total_stories) * 100
```

**Pass Threshold:** 100% estimated with valid values

**Common Issues:**

| Issue | Remediation |
|-------|-------------|
| Missing estimates | Run estimation session with `/sprint-planning` |
| Invalid point value | Use Fibonacci: 1, 2, 3, 5, 8, 13 |
| Story >8 points | Split into smaller stories |
| No sprint capacity | Define team velocity in sprint-status.yaml |

---

## Workflow Steps

### Step 1: Load Project Documents

```
1. Read accbmad/config.yaml → project_level, project_name
2. Glob accbmad/2-planning/prd-*.md → PRD file(s)
3. Glob accbmad/3-solutioning/architecture-*.md → Architecture file(s) (if Level 2+)
4. Glob accbmad/4-implementation/stories/STORY-*.md → Story files
5. Read accbmad/4-implementation/sprint.yaml or bmad/sprint-status.yaml → Sprint data
```

### Step 2: Execute Validation Checks

Execute checks based on project level:

| Check | Level 0-1 | Level 2+ |
|-------|-----------|----------|
| PRD Completeness | ✓ | ✓ |
| Architecture | Skip | ✓ |
| FR Coverage | ✓ | ✓ |
| Dependencies | ✓ | ✓ |
| Estimation | ✓ | ✓ |

For each check:
1. Run validation logic
2. Record pass/fail for each criterion
3. Collect issues with severity
4. Note remediation steps

### Step 3: Calculate Overall Status

```
PASS = All categories pass their thresholds
CONDITIONAL = 1-2 minor issues (warnings only)
FAIL = Any category fails or critical issue found

Critical Issues (cause FAIL):
- Any TBD in PRD critical sections
- <100% FR coverage
- Circular dependencies detected
- <80% estimation completeness

Warnings (allow CONDITIONAL):
- Missing ADRs (recommended, not required)
- >30% blocked stories
- Stories >8 points
```

### Step 4: Generate Report

Save to: `docs/implementation-readiness-{date}.md`

---

## Report Template

```markdown
# Implementation Readiness Report

**Project:** {{project_name}}
**Date:** {{date}}
**Project Level:** {{project_level}}
**Overall Status:** {{PASS | CONDITIONAL | FAIL}}

---

## Executive Summary

{{summary_paragraph}}

**Validation Scope:**
- PRD Completeness: {{status}}
- Architecture: {{status_or_skipped}}
- FR Coverage: {{status}}
- Dependency Health: {{status}}
- Estimation: {{status}}

---

## Validation Results

### Category 1: PRD Completeness

| ID | Criterion | Status | Notes |
|----|-----------|--------|-------|
| PRD-01 | Executive Summary | ✓/✗ | {{notes}} |
| PRD-02 | Problem Statement | ✓/✗ | {{notes}} |
| PRD-03 | Goals & Objectives | ✓/✗ | {{notes}} |
| PRD-04 | User Segments | ✓/✗ | {{notes}} |
| PRD-05 | Functional Requirements | ✓/✗ | {{notes}} |
| PRD-06 | Non-Functional Requirements | ✓/✗ | {{notes}} |
| PRD-07 | Success Metrics | ✓/✗ | {{notes}} |
| PRD-08 | Scope Boundaries | ✓/✗ | {{notes}} |
| PRD-09 | No Placeholder Values | ✓/✗ | {{notes}} |

**Score:** {{passed}}/{{total}} ({{percentage}}%)
**Status:** {{PASS | FAIL}}

---

### Category 2: Architecture Completeness

{{#if level_gte_2}}
| ID | Criterion | Status | Notes |
|----|-----------|--------|-------|
| ARCH-01 | System Overview | ✓/✗ | {{notes}} |
| ARCH-02 | Component Design | ✓/✗ | {{notes}} |
| ARCH-03 | Data Model | ✓/✗ | {{notes}} |
| ARCH-04 | API Contracts | ✓/✗/N/A | {{notes}} |
| ARCH-05 | Technology Stack | ✓/✗ | {{notes}} |
| ARCH-06 | Security Design | ✓/✗ | {{notes}} |
| ARCH-07 | ADRs | ✓/⚠ | {{notes}} |

**Score:** {{passed}}/{{total}} ({{percentage}}%)
**Status:** {{PASS | FAIL}}
{{else}}
*Skipped - Not required for Level {{project_level}} projects*
{{/if}}

---

### Category 3: FR→Epic→Story Coverage

**Total FRs:** {{total_frs}}
**FRs with Epics:** {{frs_with_epics}}
**FRs with Stories:** {{frs_with_stories}}
**Coverage:** {{coverage_percentage}}%

#### Traceability Matrix

| FR ID | Description | Epic(s) | Stories | Status |
|-------|-------------|---------|---------|--------|
{{#each frs}}
| {{id}} | {{description}} | {{epics}} | {{stories}} | {{status}} |
{{/each}}

#### Gaps Identified

{{#each coverage_gaps}}
- **{{fr_id}}:** {{gap_description}} → {{remediation}}
{{/each}}

**Status:** {{PASS | FAIL}}

---

### Category 4: Dependency Health

**Total Stories:** {{total_stories}}
**Stories with Dependencies:** {{stories_with_deps}}
**Blocked Stories:** {{blocked_count}} ({{blocked_percentage}}%)
**Max Chain Depth:** {{max_depth}}

{{#if has_cycles}}
#### Circular Dependencies Detected

{{#each cycles}}
**Cycle {{index}}:** {{story_a}} → {{story_b}} → ... → {{story_a}}

**Resolution:** {{resolution_suggestion}}
{{/each}}
{{else}}
✓ No circular dependencies detected
{{/if}}

{{#if invalid_refs}}
#### Invalid References

{{#each invalid_refs}}
- **{{story_id}}** references non-existent **{{invalid_ref}}**
{{/each}}
{{/if}}

**Status:** {{PASS | FAIL}}

---

### Category 5: Estimation Completeness

**Total Stories:** {{total_stories}}
**Estimated:** {{estimated_count}} ({{estimated_percentage}}%)
**Unestimated:** {{unestimated_count}}
**Oversized (>8 pts):** {{oversized_count}}

{{#if unestimated_stories}}
#### Stories Missing Estimates

{{#each unestimated_stories}}
- {{story_id}}: {{story_title}}
{{/each}}
{{/if}}

{{#if oversized_stories}}
#### Stories Requiring Split (>8 points)

{{#each oversized_stories}}
- {{story_id}}: {{points}} points - {{recommendation}}
{{/each}}
{{/if}}

**Status:** {{PASS | FAIL}}

---

## Critical Issues (Must Fix Before Implementation)

{{#if critical_issues}}
{{#each critical_issues}}
### Issue {{number}}: {{title}}

- **Category:** {{category}}
- **Severity:** CRITICAL
- **Details:** {{description}}
- **Impact:** {{impact}}
- **Remediation:** {{fix_steps}}
- **Workflow:** `{{workflow_command}}`

{{/each}}
{{else}}
✓ No critical issues found
{{/if}}

---

## Warnings (Should Fix)

{{#if warnings}}
{{#each warnings}}
- **{{category}}:** {{description}} → {{remediation}}
{{/each}}
{{else}}
✓ No warnings
{{/if}}

---

## Recommendation

### Status: {{overall_status}}

{{recommendation_text}}

{{#if status_pass}}
### ✓ Ready for Implementation

The project has passed all validation gates. You may proceed to Sprint 1.

**Recommended next steps:**
1. Run `/sprint-planning` to create Sprint 1
2. Assign stories to team members
3. Begin implementation with `/dev-story STORY-XXX`
{{/if}}

{{#if status_conditional}}
### ⚠ Conditional Approval

The project has minor issues that should be addressed but do not block implementation.

**Before proceeding:**
{{#each conditional_fixes}}
- [ ] {{fix}}
{{/each}}

Can proceed with caution. Track warnings in Sprint 1 backlog.
{{/if}}

{{#if status_fail}}
### ✗ Not Ready for Implementation

Critical issues must be resolved before starting implementation.

**Required actions:**
{{#each required_actions}}
1. [ ] {{action}} → `{{workflow}}`
{{/each}}

Run `/check-implementation-readiness` again after fixing issues.
{{/if}}

---

## Appendix: Full Traceability

### A. FR List (from PRD)

| ID | Description | Priority | Epic | Stories |
|----|-------------|----------|------|---------|
{{#each all_frs}}
| {{id}} | {{description}} | {{priority}} | {{epic}} | {{stories}} |
{{/each}}

### B. Story List

| ID | Title | Points | Depends On | Status |
|----|-------|--------|------------|--------|
{{#each all_stories}}
| {{id}} | {{title}} | {{points}} | {{depends_on}} | {{status}} |
{{/each}}

---

*Generated by BMAD Implementation Readiness Validator*
*Workflow: `/check-implementation-readiness`*
```

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| PRD not found | "No PRD found. Run `/prd` first." | Create PRD |
| No stories exist | "No stories found. Run `/create-epics-stories` first." | Create stories |
| Architecture missing (Level 2+) | "Architecture required for Level 2+. Run `/architecture` first." | Create architecture |
| Sprint status corrupt | "Cannot parse sprint-status.yaml" | Fix YAML syntax |

---

## Integration

### Skill Updates

Add to `bmad-orchestrator/SKILL.md`:
```markdown
**Gate Workflows:**
- `/check-implementation-readiness` - Comprehensive Phase 3→4 validation
```

### Related Workflows

| Workflow | Relationship |
|----------|--------------|
| `/validate-phase-transition 3 4` | Quick alignment check (lighter) |
| `/solutioning-gate-check` | Alias for this workflow |
| `/sprint-planning` | Next step after passing gate |
| `/create-story` | Fix coverage gaps |
| `/prd` | Fix PRD completeness issues |
| `/architecture` | Fix architecture issues |

### Works After

- `/architecture` - After Phase 3 completion
- `/create-epics-stories` - After story creation
- `/sprint-planning` - Can run before to validate

### Works Before

- `/sprint-planning` - Gate must pass first
- `/dev-story` - Implementation requires passing gate

---

## Definition of Done

Validation is complete when:

- [ ] PRD completeness validated (all 9 criteria)
- [ ] Architecture validated (Level 2+) or skipped (Level 0-1)
- [ ] FR→Epic→Story traceability matrix generated
- [ ] Dependency graph analyzed for cycles
- [ ] Estimation completeness verified
- [ ] Overall status determined (PASS/CONDITIONAL/FAIL)
- [ ] Report saved to `docs/implementation-readiness-{date}.md`
- [ ] Clear remediation steps provided for any issues

---

## Notes for Claude

**Tool Usage:**
- Use Glob to find documents: `accbmad/2-planning/prd-*.md`, `accbmad/4-implementation/stories/STORY-*.md`
- Use Grep to extract patterns: `FR-\d{3}`, `STORY-\d{3}`
- Use Read to parse document content
- Use Write to save validation report

**Key Principles:**
- Be thorough but actionable - every issue has a fix
- Provide specific line numbers or sections when citing issues
- Don't block on warnings - only critical issues cause FAIL
- Build complete traceability matrix for transparency
- Offer to run remediation workflows

**Cycle Detection:**
- Build graph from `depends_on` fields in sprint-status.yaml
- Also check story files for dependency sections
- Report each cycle with specific resolution steps

**Placeholder Detection Patterns:**
```regex
/\bTBD\b|\bTODO\b|\bPLACEHOLDER\b|\bXXX\b|\bFIXME\b|\[.*TBD.*\]|\[.*TODO.*\]/gi
```

**Quality Checks:**
- Every FAIL has a specific workflow to fix it
- Traceability is bidirectional and complete
- Recommendations are prioritized by impact
