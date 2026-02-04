# Phase Transition Validation Workflow

**Goal:** Validate alignment between workflow phases before proceeding to ensure quality and traceability.

**Phase:** Cross-phase (Quality Gate)

**Agent:** BMAD Orchestrator

**Trigger keywords:** validate transition, phase gate, check alignment, validate phase, gate check, verify phase, readiness check

**Inputs:** Documents from current and previous phases

**Output:** Validation report with pass/fail status and remediation guidance

**Duration:** 10-20 minutes

---

## When to Use This Workflow

Use before major phase transitions to catch issues early:

| Transition | When to Validate | Invoke |
|------------|------------------|--------|
| Phase 1 → 2 | Before starting PRD | `/validate-phase-transition 1 2` |
| Phase 2 → 3 | Before starting Architecture | `/validate-phase-transition 2 3` |
| Phase 3 → 4 | Before starting Implementation | `/validate-phase-transition 3 4` |

**Note:** This validation is **recommended but optional**. Projects can proceed without it, but validation catches drift and requirement gaps early.

**Invoke:** `/validate-phase-transition` or `/validate-phase-transition [from] [to]`

---

## Pre-Flight

1. **Load project context** - Check `accbmad/config.yaml` for project level
2. **Identify transition** - Determine which phases to validate
3. **Locate documents** - Find relevant phase artifacts in `docs/`
4. **Check prerequisites** - Ensure previous phase documents exist

---

## Gate 1: Brief → PRD (Phase 1 → 2)

**Purpose:** Ensure PRD accurately reflects Product Brief vision.

### Validation Criteria

| ID | Criterion | Check | Pass Threshold |
|----|-----------|-------|----------------|
| G1.1 | Problem alignment | PRD problem statement matches Brief | 90%+ similarity |
| G1.2 | Target user coverage | All Brief personas appear in PRD | 100% coverage |
| G1.3 | Scope boundaries | PRD scope within Brief scope | No scope creep |
| G1.4 | Success metrics | Brief KPIs reflected in PRD | 100% coverage |
| G1.5 | Value proposition | Core value preserved | Explicit match |
| G1.6 | Constraints respected | Brief constraints in PRD | 100% transferred |

### Validation Steps

1. **Load Documents**
   ```
   - Product Brief: accbmad/1-analysis/product-brief-*.md
   - PRD: accbmad/2-planning/prd-*.md
   ```

2. **Extract Key Elements**

   From Product Brief:
   - Problem statement
   - Target users/personas
   - In-scope features
   - Out-of-scope items
   - Success metrics/KPIs
   - Constraints

   From PRD:
   - Problem statement
   - User personas
   - Functional requirements (FRs)
   - Non-functional requirements (NFRs)
   - Success metrics

3. **Compare and Score**

   For each criterion:
   - Extract relevant sections from both documents
   - Compare for alignment
   - Calculate match percentage
   - Note gaps or discrepancies

4. **Generate Assessment**

   ```markdown
   ## Gate 1: Brief → PRD Validation

   | Criterion | Status | Score | Notes |
   |-----------|--------|-------|-------|
   | Problem alignment | ✓ | 95% | Problem statement consistent |
   | Target users | ✓ | 100% | All 3 personas covered |
   | Scope boundaries | ⚠ | 85% | 2 features added not in Brief |
   | Success metrics | ✓ | 100% | All KPIs mapped to requirements |
   | Value proposition | ✓ | 100% | Core value preserved |
   | Constraints | ✓ | 100% | All constraints documented |
   ```

### Pass/Fail Criteria

- **PASS:** All criteria meet threshold
- **WARN:** 1-2 criteria below threshold but fixable
- **FAIL:** 3+ criteria below threshold or critical gap

### Common Issues and Remediation

| Issue | Remediation |
|-------|-------------|
| Scope creep (features added) | Document justification or remove from PRD |
| Missing persona | Add persona to PRD or explain exclusion |
| KPI not mapped | Add requirement tracing KPI |
| Problem drift | Realign PRD with Brief or update Brief |

---

## Gate 2: PRD → Architecture (Phase 2 → 3)

**Purpose:** Ensure Architecture covers all PRD requirements.

### Validation Criteria

| ID | Criterion | Check | Pass Threshold |
|----|-----------|-------|----------------|
| G2.1 | FR coverage | Each FR has implementing component | 100% mapped |
| G2.2 | NFR coverage | Each NFR addressed in design | 100% addressed |
| G2.3 | Data requirements | All entities defined in data model | 100% coverage |
| G2.4 | Integration points | External systems documented | 100% identified |
| G2.5 | Security requirements | Security NFRs have controls | 100% mapped |
| G2.6 | API coverage | All user-facing FRs have API endpoints | 100% coverage |

### Validation Steps

1. **Load Documents**
   ```
   - PRD: accbmad/2-planning/prd-*.md
   - Architecture: accbmad/3-solutioning/architecture-*.md
   ```

2. **Extract Requirements**

   From PRD:
   - All FR-XXX functional requirements
   - All NFR-XXX non-functional requirements
   - Data entities mentioned
   - External systems/integrations
   - Security requirements

3. **Build Traceability Matrix**

   ```markdown
   ## FR Traceability

   | FR ID | Description | Component | Covered? |
   |-------|-------------|-----------|----------|
   | FR-001 | User registration | AuthService | ✓ |
   | FR-002 | Password reset | AuthService | ✓ |
   | FR-003 | Data export | ? | ✗ |

   ## NFR Traceability

   | NFR ID | Description | How Addressed | Status |
   |--------|-------------|---------------|--------|
   | NFR-001 | 99.9% uptime | Load balancer, auto-scaling | ✓ |
   | NFR-002 | <200ms response | Caching layer | ✓ |
   | NFR-003 | GDPR compliance | Data encryption, anonymization | ✓ |
   ```

4. **Identify Gaps**

   - Flag uncovered FRs
   - Note unaddressed NFRs
   - List missing data entities
   - Identify undocumented integrations

5. **Generate Assessment**

### Pass/Fail Criteria

- **PASS:** 100% FR coverage, 100% NFR addressed
- **WARN:** 95%+ coverage with minor gaps
- **FAIL:** <95% coverage or critical security gap

### Common Issues and Remediation

| Issue | Remediation |
|-------|-------------|
| FR not covered | Add component or extend existing |
| NFR not addressed | Document architectural approach |
| Missing data entity | Update data model |
| Undocumented integration | Add to external systems section |
| Security gap | Add security control or document risk acceptance |

---

## Gate 3: Architecture → Implementation (Phase 3 → 4)

**Purpose:** Verify project is ready for implementation.

### Validation Criteria

| ID | Criterion | Check | Pass Threshold |
|----|-----------|-------|----------------|
| G3.1 | Epic coverage | All FRs mapped to epics | 100% |
| G3.2 | Story breakdown | All epics have stories | 100% |
| G3.3 | Story estimates | All stories have points | 100% |
| G3.4 | Dependencies | No circular dependencies | 0 cycles |
| G3.5 | Tech decisions | ADRs for major decisions | ≥1 ADR |
| G3.6 | Dev environment | Setup documented | Exists |
| G3.7 | Acceptance criteria | All stories have ACs | 100% |

### Validation Steps

1. **Load Documents**
   ```
   - Architecture: accbmad/3-solutioning/architecture-*.md
   - Sprint Status: accbmad/4-implementation/sprint.yaml
   - Stories: accbmad/4-implementation/stories/STORY-*.md
   - Epics: docs/epics/*.md (if exists)
   ```

2. **Verify Traceability Chain**

   ```
   FR → Epic → Story → Acceptance Criteria
   ```

   Check each level:
   - FR-001 → Epic-1 → STORY-001, STORY-002 → ACs defined

3. **Check Story Readiness**

   For each story:
   - [ ] Has acceptance criteria (≥3 ACs)
   - [ ] Has story points estimate
   - [ ] Has technical notes
   - [ ] Dependencies declared
   - [ ] No blockers

4. **Validate Dependencies**

   ```
   Build dependency graph:
   STORY-001 → STORY-002 → STORY-003
   Check for cycles: A → B → C → A (FAIL)
   ```

5. **Check Development Prerequisites**

   - [ ] Tech stack decisions documented
   - [ ] Development environment setup guide exists
   - [ ] API contracts defined (if applicable)
   - [ ] Database schema defined (if applicable)

6. **Generate Assessment**

### Pass/Fail Criteria

- **PASS:** All criteria met, ready to implement
- **WARN:** Minor gaps (missing estimates, incomplete ACs)
- **FAIL:** Critical gaps (no stories, circular deps, no architecture)

### Common Issues and Remediation

| Issue | Remediation |
|-------|-------------|
| Stories missing estimates | Run estimation session |
| Missing acceptance criteria | Refine stories with /create-story |
| Circular dependencies | Refactor story dependencies |
| No dev environment docs | Create setup guide |
| FR not in any epic | Add epic or extend existing |

---

## Output Format

Save to: `docs/validation-phase-{from}-{to}-{date}.md`

```markdown
# Phase Transition Validation Report

**Transition:** Phase {{from_phase}} → Phase {{to_phase}}
**Date:** {{date}}
**Project:** {{project_name}}
**Status:** {{PASS | WARN | FAIL}}

---

## Executive Summary

{{summary_paragraph}}

**Overall Score:** {{score}}%
**Recommendation:** {{proceed | fix_minor_issues | address_gaps_first}}

---

## Validation Results

### Gate {{gate_number}}: {{gate_name}}

| ID | Criterion | Status | Score | Notes |
|----|-----------|--------|-------|-------|
| {{id}} | {{criterion}} | ✓/⚠/✗ | {{score}}% | {{notes}} |

**Gate Status:** {{PASS | WARN | FAIL}}

---

## Gaps Identified

### Gap 1: {{gap_title}}

- **Severity:** High | Medium | Low
- **Criterion:** {{criterion_id}}
- **Details:** {{gap_description}}
- **Impact:** {{what_happens_if_not_fixed}}
- **Remediation:** {{fix_recommendation}}
- **Effort:** {{estimated_effort}}

---

## Traceability Matrix

{{include_relevant_matrix_from_validation}}

---

## Recommendation

### Status: {{PASS | WARN | FAIL}}

{{recommendation_paragraph}}

### Action Required

{{if PASS}}
✓ Ready to proceed to Phase {{to_phase}}
{{/if}}

{{if WARN}}
⚠ Minor issues to address:
1. {{issue_1}}
2. {{issue_2}}

Can proceed with caution, but recommend fixing first.
{{/if}}

{{if FAIL}}
✗ Not ready for Phase {{to_phase}}

Must address before proceeding:
1. {{blocker_1}}
2. {{blocker_2}}

Run `/{{remediation_workflow}}` to fix gaps.
{{/if}}

---

## Next Steps

| Priority | Action | Workflow |
|----------|--------|----------|
| {{priority}} | {{action}} | {{workflow}} |

---

*Generated by BMAD Phase Transition Validator*
```

---

## Quick Validation Checklists

For inline use within other workflows:

### Brief → PRD Quick Check

Before starting PRD, verify:

- [ ] Product Brief exists at `accbmad/1-analysis/product-brief-*.md`
- [ ] Brief has problem statement defined
- [ ] Brief has target users/personas
- [ ] Brief has success metrics/KPIs
- [ ] Brief has scope boundaries (in/out)

### PRD → Architecture Quick Check

Before starting Architecture, verify:

- [ ] PRD exists at `accbmad/2-planning/prd-*.md`
- [ ] PRD has numbered FRs (FR-XXX)
- [ ] PRD has numbered NFRs (NFR-XXX)
- [ ] PRD scope is bounded (out-of-scope defined)
- [ ] PRD has epics breakdown

### Architecture → Sprint Quick Check

Before starting Sprint Planning, verify:

- [ ] Architecture exists at `accbmad/3-solutioning/architecture-*.md` (Level 2+)
- [ ] Components are defined with responsibilities
- [ ] Data model is documented
- [ ] Epics exist with story breakdown
- [ ] Stories have estimates

---

## Integration

### Works After

- Any phase completion
- `/product-brief` (enables Gate 1)
- `/prd` (enables Gate 2)
- `/architecture` (enables Gate 3)

### Works Before

- `/prd` - Recommend Gate 1 validation first
- `/architecture` - Recommend Gate 2 validation first
- `/sprint-planning` - Recommend Gate 3 validation first

### Related Workflows

| Workflow | Relationship |
|----------|--------------|
| `/workflow-status` | Shows current phase |
| `/solutioning-gate-check` | Detailed Phase 3→4 (same as Gate 3) |
| `/validate-prd` | Quality check for PRD content |

---

## Definition of Done

Validation is complete when:

- [ ] Relevant documents loaded and parsed
- [ ] All criteria for gate evaluated
- [ ] Traceability matrix generated (where applicable)
- [ ] Gaps identified with severity
- [ ] Remediation guidance provided
- [ ] Report saved to `docs/validation-phase-*.md`
- [ ] Clear PASS/WARN/FAIL status

---

## Notes for Claude

**Tool Usage:**
- Use Glob to find phase documents: `accbmad/1-analysis/product-brief-*.md`
- Use Read to load and parse documents
- Use Write to save validation report
- Use grep patterns to extract FR-XXX, NFR-XXX

**Key Principles:**
- Be thorough but not blocking - WARN allows proceeding
- Provide actionable remediation for each gap
- Build traceability matrices to visualize coverage
- Score objectively based on criteria
- Don't invent requirements - only validate existing

**Quality Checks:**
- Every gap has remediation guidance
- Traceability is bidirectional (FR→Component, Component→FR)
- Severity reflects actual impact
- Recommendations are actionable

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| Source phase document missing | "Cannot validate - no {{phase}} document found." | Create source document first |
| Target phase already complete | "Phase {{to}} already has deliverables. Validation may be redundant." | Proceed or skip |
| Invalid phase transition | "Invalid transition: Phase {{from}} → Phase {{to}}." | Specify valid transition |
| No project config | "No accbmad/config.yaml found. Run `/workflow-init` first." | Initialize project |
