# Phase Validation Helper

Quick validation checklists for embedding in workflows. These are lightweight checks that can run inline before starting a new phase.

---

## Usage

Include these checklists at the start of phase workflows to ensure prerequisites are met.

```markdown
Before proceeding, run the appropriate quick check below.
If any items fail, consider running `/validate-phase-transition` for detailed analysis.
```

---

## Brief → PRD Quick Check (Phase 1 → 2)

Run before `/prd` workflow:

```markdown
### Pre-PRD Validation

- [ ] Product Brief exists at `accbmad/1-analysis/product-brief-*.md`
- [ ] Brief has problem statement (≥3 sentences)
- [ ] Brief has target users/personas defined
- [ ] Brief has success metrics/KPIs (≥3 measurable)
- [ ] Brief has scope boundaries (in-scope AND out-of-scope)
- [ ] Brief has constraints documented

**Status:** ○ Ready | ⚠ Gaps Found | ✗ Not Ready

If gaps found:
- Missing Brief → Run `/product-brief` first
- Incomplete Brief → Review and complete Brief sections
- For detailed validation → Run `/validate-phase-transition 1 2`
```

---

## PRD → Architecture Quick Check (Phase 2 → 3)

Run before `/architecture` workflow:

```markdown
### Pre-Architecture Validation

- [ ] PRD exists at `accbmad/2-planning/prd-*.md`
- [ ] PRD has numbered FRs (FR-XXX format)
- [ ] PRD has numbered NFRs (NFR-XXX format)
- [ ] PRD scope is bounded (out-of-scope list exists)
- [ ] PRD has epic breakdown
- [ ] PRD status is "approved" or "review"

**Status:** ○ Ready | ⚠ Gaps Found | ✗ Not Ready

If gaps found:
- Missing PRD → Run `/prd` first
- No FRs/NFRs → PRD needs requirements sections
- No epics → Add epic breakdown to PRD
- For detailed validation → Run `/validate-phase-transition 2 3`
```

---

## Architecture → Sprint Quick Check (Phase 3 → 4)

Run before `/sprint-planning` workflow:

```markdown
### Pre-Sprint Validation

**For Level 2+ Projects:**
- [ ] Architecture exists at `accbmad/3-solutioning/architecture-*.md`
- [ ] Components are defined with responsibilities
- [ ] Data model is documented
- [ ] Tech stack decisions documented
- [ ] API contracts defined (if applicable)

**For All Projects:**
- [ ] Epics exist with story breakdown
- [ ] Stories have estimates (story points)
- [ ] Stories have acceptance criteria
- [ ] No unresolved blockers

**Status:** ○ Ready | ⚠ Gaps Found | ✗ Not Ready

If gaps found:
- Missing Architecture (Level 2+) → Run `/architecture` first
- No stories → Run `/create-epics-stories` first
- Missing estimates → Run estimation session
- For detailed validation → Run `/validate-phase-transition 3 4`
```

---

## PRD Completeness Quick Check

Run within `/validate-prd` or standalone:

```markdown
### PRD Completeness Check

**Required Sections:**
- [ ] Executive Summary
- [ ] Problem Statement
- [ ] User Personas (≥1)
- [ ] Functional Requirements (≥3 FRs)
- [ ] Non-Functional Requirements (≥2 NFRs)
- [ ] Scope (in-scope + out-of-scope)
- [ ] Epic breakdown

**Quality Checks:**
- [ ] FRs are numbered (FR-001, FR-002, ...)
- [ ] NFRs are numbered (NFR-001, NFR-002, ...)
- [ ] Each FR is testable (has clear acceptance)
- [ ] NFRs have measurable targets
- [ ] No TBD/TODO placeholders remaining

**Traceability:**
- [ ] FRs trace to user needs
- [ ] Epics cover all FRs
- [ ] Success metrics are measurable
```

---

## Architecture Completeness Quick Check

Run within architecture workflow or standalone:

```markdown
### Architecture Completeness Check

**Required Sections:**
- [ ] System Overview
- [ ] Architecture Pattern (with justification)
- [ ] Component Design
- [ ] Data Model
- [ ] API Specifications (if applicable)
- [ ] NFR Mapping
- [ ] Technology Stack
- [ ] Deployment Architecture

**Quality Checks:**
- [ ] All PRD FRs have implementing components
- [ ] All PRD NFRs have architectural solutions
- [ ] Component responsibilities are clear
- [ ] Interfaces between components defined
- [ ] Security considerations documented
- [ ] Scalability approach documented

**Decisions:**
- [ ] Major tech decisions documented (ADRs)
- [ ] Trade-offs explained
- [ ] Alternatives considered
```

---

## Story Readiness Quick Check

Run before implementing any story:

```markdown
### Story Readiness Check

**Required Elements:**
- [ ] User story statement (As a/I want/So that)
- [ ] Acceptance criteria (≥3 ACs)
- [ ] Story points estimate
- [ ] Priority assigned

**Technical Readiness:**
- [ ] Technical approach outlined
- [ ] Files/modules to modify identified
- [ ] Dependencies declared
- [ ] No blocking dependencies unresolved

**Quality:**
- [ ] ACs are testable
- [ ] Story is independent (can be completed alone)
- [ ] Story is small enough (≤8 points)
- [ ] Definition of Done is clear
```

---

## When to Use Full Validation

Use the full `/validate-phase-transition` workflow when:

- Quick check fails multiple items
- Starting a critical phase (Architecture, Sprint 1)
- Team wants formal validation record
- Onboarding new team members
- Project audit or review

Quick checks are sufficient when:

- Quick check passes all items
- Continuing existing work (not phase boundary)
- Small projects (Level 0-1)
- Time-sensitive situations

---

## Integration Points

These helpers can be embedded in:

| Workflow | Quick Check to Use |
|----------|-------------------|
| `/prd` | Brief → PRD Quick Check |
| `/architecture` | PRD → Architecture Quick Check |
| `/sprint-planning` | Architecture → Sprint Quick Check |
| `/dev-story` | Story Readiness Quick Check |
| `/validate-prd` | PRD Completeness Quick Check |

---

## Notes for Claude

When using these quick checks:

1. Run at workflow start as pre-flight
2. Report status clearly (Ready/Gaps/Not Ready)
3. For gaps, suggest specific remediation
4. Offer to run full validation if gaps found
5. Don't block on minor gaps - warn and proceed
6. Log validation result in workflow output
