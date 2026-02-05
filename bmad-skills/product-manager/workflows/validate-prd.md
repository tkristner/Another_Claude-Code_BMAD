# [Product Manager] Validate PRD Workflow

**Goal:** Systematically validate an existing PRD against quality criteria to ensure it's ready for architecture and implementation.

**Trigger keywords:** validate PRD, PRD review, PRD quality, check PRD, PRD validation, requirements review, PRD audit

**Duration:** 30-60 minutes

**Output:** Validation report with findings and recommendations

---

## When to Use This Workflow

Use this workflow when:
- PRD has been created and needs quality assurance
- Before starting architecture design
- When reviewing PRDs from other sources
- To identify gaps before implementation

**Invoke:** `/validate-prd` or `/validate-prd path/to/prd.md`

---

## Validation Dimensions

The PRD is validated across multiple quality dimensions:

| Dimension | Description | Weight |
|-----------|-------------|--------|
| **Completeness** | All required sections present and populated | High |
| **Measurability** | Requirements are testable and quantifiable | High |
| **Traceability** | Clear links between objectives and requirements | High |
| **Density** | Sufficient detail without bloat | Medium |
| **Clarity** | Unambiguous, well-written requirements | Medium |
| **Feasibility** | Requirements are technically achievable | Medium |

---

## Workflow Steps

### Step 1: Load PRD Document

**Objective:** Locate and load the PRD for validation.

1. **Find PRD**

   If path provided:
   - Load specified file

   If no path:
   - Search for `docs/*prd*.md` or `accbmad/2-planning/prd-*.md`
   - If multiple found, ask user to select

2. **Verify PRD Structure**

   Check for expected sections:
   - Overview/Executive Summary
   - Problem Statement
   - User Segments/Personas
   - Functional Requirements
   - Non-Functional Requirements
   - Success Metrics
   - Dependencies/Constraints

3. **Extract Metadata**
   - Project name
   - Version/date
   - Author
   - Status

---

### Step 2: Validate Completeness

**Objective:** Ensure all required sections are present and populated.

**Required Sections Checklist:**

| Section | Required | Status |
|---------|----------|--------|
| Executive Summary | Yes | |
| Problem Statement | Yes | |
| Goals & Objectives | Yes | |
| User Segments | Yes | |
| Functional Requirements | Yes | |
| Non-Functional Requirements | Yes | |
| Success Metrics | Yes | |
| Assumptions | Yes | |
| Dependencies | Recommended | |
| Out of Scope | Recommended | |
| Risks | Recommended | |

**Scoring:**
- All required sections present and populated: PASS
- Required section missing or empty: FAIL
- Recommended section missing: WARNING

---

### Step 3: Validate Functional Requirements

**Objective:** Assess quality of functional requirements.

**For each FR, check:**

1. **Has Unique ID**
   - Format: FR-001, FR-002, etc.
   - No duplicates

2. **Has Priority**
   - MoSCoW (MUST/SHOULD/COULD/WON'T) or
   - Numeric priority

3. **Has Acceptance Criteria**
   - At least 2-3 criteria per FR
   - Criteria are testable

4. **Is Measurable**
   - Avoid vague terms ("fast", "user-friendly", "easy")
   - Include specific thresholds where applicable

5. **Describes WHAT not HOW**
   - No implementation details
   - Focus on capability/behavior

**Findings Format:**
```
FR-001: [Status]
  - ID: ✓
  - Priority: ✓
  - Acceptance Criteria: ⚠ Only 1 criterion
  - Measurable: ✗ Uses "fast" without threshold
  - What vs How: ✓
```

---

### Step 4: Validate Non-Functional Requirements

**Objective:** Assess quality of NFRs.

**NFR Categories to Check:**

| Category | Examples |
|----------|----------|
| Performance | Response time, throughput, latency |
| Scalability | Users, data volume, growth |
| Security | Auth, encryption, compliance |
| Reliability | Uptime, fault tolerance, backup |
| Usability | Accessibility, UX standards |
| Maintainability | Code quality, documentation |

**For each NFR, verify:**

1. **Is Quantifiable**
   - Has specific number or threshold
   - Example: "99.9% uptime" not "highly available"

2. **Is Testable**
   - Can be verified with measurement
   - Clear pass/fail criteria

3. **Has Context**
   - Under what conditions?
   - For what user segment?

**Common NFR Issues:**
- "System should be fast" → "API response < 200ms p95"
- "Must be secure" → "Implement OAuth 2.0 with JWT"
- "Highly scalable" → "Support 10,000 concurrent users"

---

### Step 5: Validate Traceability

**Objective:** Ensure requirements trace to business objectives.

**Check:**

1. **Objective → Requirement Mapping**
   - Each objective has supporting requirements
   - Each requirement maps to an objective

2. **Requirement → Epic Mapping** (if epics exist)
   - All requirements assigned to epics
   - No orphan requirements

3. **Create Traceability Matrix:**

```
| Objective | Requirements | Coverage |
|-----------|--------------|----------|
| O1: User growth | FR-001, FR-002, FR-005 | ✓ |
| O2: Revenue | FR-003, FR-004 | ✓ |
| O3: Retention | (none) | ⚠ Gap |
```

---

### Step 6: Validate Density & Clarity

**Objective:** Check document quality and readability.

**Density Check:**
- Requirements not too verbose (< 3 sentences each)
- Requirements not too sparse (meaningful content)
- Appropriate level of detail for implementation

**Clarity Check:**
- No ambiguous pronouns ("it", "this", "that")
- No undefined acronyms
- Consistent terminology throughout
- Active voice preferred

**Common Issues:**
- "The system will handle this appropriately" → What is "this"? What is "appropriately"?
- "Users should be able to easily..." → Define "easily"
- Mixed terminology (user/customer/client used interchangeably)

---

### Step 7: Generate Validation Report

**Objective:** Summarize findings and recommendations.

**Report Format:**

```markdown
# [Product Manager] PRD Validation Report

**Document:** {prd_name}
**Validated:** {date}
**Overall Status:** {PASS|CONDITIONAL PASS|FAIL}

## Executive Summary

| Dimension | Score | Status |
|-----------|-------|--------|
| Completeness | 9/10 | PASS |
| Measurability | 6/10 | CONDITIONAL |
| Traceability | 8/10 | PASS |
| Density | 7/10 | PASS |
| Clarity | 7/10 | PASS |

## Critical Findings (Must Fix)

1. [Finding description and recommendation]
2. [Finding description and recommendation]

## Warnings (Should Fix)

1. [Finding description and recommendation]
2. [Finding description and recommendation]

## Suggestions (Nice to Fix)

1. [Finding description and recommendation]

## Detailed Findings

### Functional Requirements

| FR ID | Priority | ACs | Measurable | What/How | Overall |
|-------|----------|-----|------------|----------|---------|
| FR-001 | ✓ | ✓ | ⚠ | ✓ | PASS |
| FR-002 | ✓ | ✗ | ✗ | ✓ | FAIL |

### Non-Functional Requirements

| NFR ID | Quantifiable | Testable | Context | Overall |
|--------|--------------|----------|---------|---------|
| NFR-001 | ✓ | ✓ | ✓ | PASS |
| NFR-002 | ✗ | ✗ | ✓ | FAIL |

### Traceability Gaps

- Objective X has no supporting requirements
- FR-Y is not mapped to any objective

## Recommendations

1. **Fix Critical Issues** before proceeding to architecture
2. **Address Warnings** to improve implementation clarity
3. **Consider Suggestions** for best practices

## Next Steps

- [ ] Address critical findings
- [ ] Re-validate after fixes
- [ ] Proceed to architecture when status is PASS
```

---

### Step 8: Present Findings and Options

**Objective:** Review results with user.

**Present:**
1. Overall status (PASS/CONDITIONAL/FAIL)
2. Key findings by severity
3. Recommendations

**Options:**

```
PRD Validation Complete!

Status: {status}
Critical Issues: {count}
Warnings: {count}

What would you like to do?

[F] Fix issues now (I'll help you update the PRD)
[R] Generate full report only
[S] Save report and proceed anyway
[E] Explain specific findings
```

---

## Validation Scoring

### Overall Status

| Score | Status | Meaning |
|-------|--------|---------|
| 90%+ | PASS | Ready for architecture |
| 70-89% | CONDITIONAL PASS | Minor issues, can proceed with caution |
| < 70% | FAIL | Significant issues, fix before proceeding |

### Dimension Scores

Each dimension scored 1-10:
- **10:** Exemplary
- **8-9:** Good, minor improvements possible
- **6-7:** Acceptable, some issues
- **4-5:** Below standard, needs work
- **1-3:** Poor, significant gaps

---

## Example Session

```
User: /validate-prd accbmad/2-planning/prd-ecommerce.md

Validate PRD: Loading PRD...

Document: E-Commerce Platform PRD
Version: 1.0
Date: 2026-01-15

Starting validation...

## Completeness Check
✓ All required sections present
⚠ Missing "Risks" section (recommended)

## Functional Requirements (24 total)
✓ 22 have proper IDs
✗ 2 missing IDs (page 3, page 5)
✓ All have priorities
⚠ 5 have vague acceptance criteria
✗ 3 use implementation language

## Non-Functional Requirements (8 total)
✓ 6 are quantifiable
✗ 2 use vague terms ("fast", "secure")

## Traceability
✓ All objectives have requirements
⚠ 2 requirements not mapped to objectives

---

PRD Validation Complete!

Overall Status: CONDITIONAL PASS (76%)

| Dimension | Score |
|-----------|-------|
| Completeness | 8/10 |
| Measurability | 6/10 |
| Traceability | 8/10 |
| Clarity | 7/10 |

Critical Issues: 5
Warnings: 7

[F] Fix issues now
[R] Generate full report
[S] Save and proceed
[E] Explain findings

User: F

I'll help you fix the critical issues. Let's start with the
requirements missing IDs...
```

---

## Integration Points

- **Input from:** `/prd` workflow output
- **Output to:** Architecture workflow, Sprint Planning
- **Related:** `/validate-architecture` (similar pattern)

---

## Tips for LLMs

- Be thorough but not pedantic
- Focus on issues that impact implementation
- Provide specific, actionable recommendations
- Offer to help fix issues, not just report them
- Explain WHY each criterion matters
- Use tables for easy scanning
- Categorize by severity (Critical > Warning > Suggestion)

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| PRD not found | "Cannot find PRD at specified path." | Provide correct path or run `/prd` |
| PRD is empty/stub | "PRD appears to be empty or a stub document." | Complete PRD first |
| No requirements found | "No functional or non-functional requirements detected." | Add requirements to PRD |
| Invalid YAML frontmatter | "PRD frontmatter is malformed." | Fix frontmatter syntax |
