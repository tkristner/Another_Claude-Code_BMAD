# [Product Manager] PRD (Product Requirements Document) Workflow

**Goal:** Create comprehensive PRD defining functional requirements, non-functional requirements, and epics

**Phase:** 2 - Planning

**Agent:** Product Manager

**Trigger keywords:** PRD, product requirements, requirements document, create PRD, write PRD, functional requirements, non-functional requirements, epics, FRs, NFRs

**Duration:** 45-90 minutes

**Best for:** Level 2+ projects (5+ stories)

**Output:** `accbmad/2-planning/prd-{project-name}-{date}.md`

---

## Pre-Flight

1. Load project configuration from `accbmad/config.yaml`
2. Check workflow status in `accbmad/status.yaml`
3. Load product brief if exists (`accbmad/1-analysis/product-brief-*.md`)
4. Load template `templates/prd.template.md` if available

---

## Requirements Gathering Process

Use TodoWrite to track: Pre-flight → FRs → NFRs → Epics → Stories → Generate → Validate → Update

**Approach:** Strategic, organized, pragmatic.

---

### Part 1: Foundation

**If product brief exists:**
- Extract executive summary, objectives, metrics, personas, scope
- Ask: "I've reviewed your product brief. Any changes before we define requirements?"

**If NO brief:**
- Ask: "What are your top 3 business objectives for this project?"

---

### Part 2: Functional Requirements (FRs)

**Explain:**
> "Functional Requirements define WHAT the system does. Each FR is a specific capability. We'll use MoSCoW prioritization (Must/Should/Could)."

**For each feature area:**

1. Ask: "What should the system do for {feature area}?"
2. Collect: Description, Priority, Acceptance Criteria
3. Assign FR-ID: FR-001, FR-002, etc.

**Format:**
```markdown
### FR-{ID}: {Title}

**Priority:** {Must Have | Should Have | Could Have}

**Description:**
{What the system should do - specific and testable}

**Acceptance Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2

**Dependencies:** {FR-XXX if applicable}
```

**Guidance:**
- **Must Have:** Critical for MVP, project fails without it
- **Should Have:** Important but workaround exists
- **Could Have:** Nice to have, skip if constrained

**Typical counts:**
- Level 2: 8-15 FRs
- Level 3: 15-30 FRs
- Level 4: 30-50 FRs

---

### Part 3: Non-Functional Requirements (NFRs)

**Explain:**
> "Non-Functional Requirements define HOW the system performs - quality attributes."

**Categories to cover:**

1. **Performance** - Response time, throughput, concurrent users
2. **Security** - Authentication, authorization, encryption, compliance
3. **Scalability** - Growth, load, data volume
4. **Reliability** - Uptime (99%, 99.9%), DR, backup
5. **Usability** - Accessibility (WCAG), browser/device support, i18n
6. **Maintainability** - Code quality, documentation, test coverage
7. **Compatibility** - Integrations, API standards, data formats

**Format:**
```markdown
### NFR-{ID}: {Category} - {Title}

**Priority:** {Must Have | Should Have}

**Description:**
{Specific, measurable requirement}

**Acceptance Criteria:**
- [ ] Measurable criterion (e.g., "Response time < 200ms for 95%")

**Rationale:**
{Why this matters}
```

**Typical count:** 5-12 NFRs

---

### Part 4: Epics

**Explain:**
> "Epics are large bodies of work that group related FRs. Each breaks into 2-10 user stories."

**Epic Creation:**
1. Review FRs, identify groupings
2. For each epic:
   - ID: EPIC-001, EPIC-002...
   - Name (short, descriptive)
   - Description
   - Related FRs
   - Story count estimate (2-10)

**Format:**
```markdown
### EPIC-{ID}: {Name}

**Description:**
{What this epic delivers}

**Functional Requirements:**
- FR-001
- FR-003
- FR-007

**Story Count Estimate:** {2-10}

**Priority:** {Must Have | Should Have | Could Have}

**Business Value:**
{Why this epic matters}
```

**Typical counts:**
- Level 2: 2-4 epics
- Level 3: 4-8 epics
- Level 4: 8-15 epics

---

### Part 5: High-Level Stories (Optional)

**Ask:** "Create high-level user stories now, or wait for sprint planning?"

**If YES:**
For each epic, create 2-3 example stories:
> "As a {user type}, I want {goal} so that {benefit}."

**If NO:**
> "Detailed stories will be created during sprint planning (Phase 4)."

---

### Part 6: Additional Sections

**Collect briefly:**

1. **User Personas** - Primary user types
2. **Key User Flows** - 2-3 most important journeys
3. **Dependencies** - Internal systems, external APIs
4. **Assumptions** - What we're assuming
5. **Out of Scope** - Confirm from brief
6. **Open Questions** - Unresolved items
7. **Stakeholders** - Key people

---

## Generate Document

1. Load template if available
2. Substitute all variables
3. Generate traceability matrix:
   ```
   | Epic ID | Epic Name | FRs | Story Estimate |
   |---------|-----------|-----|----------------|
   | EPIC-001 | User Management | FR-001, FR-002 | 5-8 stories |
   ```
4. Generate prioritization summary (Must/Should/Could counts)
5. Save to `accbmad/2-planning/prd-{project-name}-{date}.md`
6. Display summary:
   ```
   PRD Created!

   - Functional Requirements: {count} ({must} must, {should} should)
   - Non-Functional Requirements: {count}
   - Epics: {count}
   - Estimated Stories: {total}
   ```

---

## Validation Checklist

```
[ ] All Must-Have FRs clearly defined
[ ] Each FR has testable acceptance criteria
[ ] NFRs cover key quality attributes
[ ] NFRs are measurable (specific numbers)
[ ] Epics logically group related FRs
[ ] All FRs assigned to epics
[ ] Priorities realistic (not all "Must Have")
[ ] Requirements trace to business objectives
[ ] Out of scope clearly stated
```

**Ask:** "Please review. Are requirements complete and clear?"

---

## Update Status

Update `accbmad/status.yaml`:
```yaml
prd: "accbmad/2-planning/prd-{project-name}-{date}.md"
last_updated: {date}
```

---

## Recommend Next Steps

**Level 2:**
```
PRD complete!

Next: Architecture Design
Run /architecture to design system meeting all requirements.
```

**Level 3-4:**
```
PRD complete!

Next: Architecture Design (Required)
Run /architecture for comprehensive system architecture.

With {count} requirements and {epic_count} epics,
architectural planning is critical.
```

---

## Tips

**Functional Requirements:**
- Be specific: "User can upload PDF up to 10MB" not "User can upload files"
- Be testable: Include clear acceptance criteria
- Avoid solutions: "User can reset password" not "System uses JWT"
- One requirement per FR

**Non-Functional Requirements:**
- Be measurable: "API response < 200ms" not "System is fast"
- Include context: "99.9% uptime during business hours"
- Consider cost: Some NFRs are expensive

**Epics:**
- Right-sized: 2-10 stories each
- Vertical slices: Each delivers end-to-end value

**Prioritization:**
- Not everything is "Must Have"
- Use data: Impact x Reach / Effort
- Consider dependencies

---

## HALT Conditions

**Stop and ask for guidance when:**

- PRD exceeds 100 functional requirements (scope too large)
- Stakeholders fundamentally disagree on scope
- Core requirements are contradictory
- Timeline makes requirements infeasible
- Critical user research is missing

**Never stop for:**

- Normal scope discussions
- Prioritization debates (use MoSCoW framework)
- Minor wording changes

---

## HALT Recovery Paths

### Recovery: PRD Too Large (100+ Requirements)

**Symptoms:**
- PRD exceeds 100 functional requirements
- Scope keeps growing during requirements gathering
- Document becomes unwieldy and hard to review
- Stakeholders lose focus on priorities

**Recovery Steps:**

1. **Acknowledge the size:**
   - This is a sign of scope creep or a very large project
   - A PRD this size cannot be effectively implemented in one phase
   - Need to split into manageable chunks

2. **Categorize all requirements:**

   | Category | Description | Criteria |
   |----------|-------------|----------|
   | **MVP** | Must launch with | Core value proposition |
   | **Phase 2** | Next release | Important but not blocking |
   | **Future** | Nice to have | Low priority or dependent |

3. **Create MVP PRD (target 20-40 requirements):**
   - Extract MVP requirements to `prd-{project}-mvp.md`
   - Ensure MVP is self-contained and valuable
   - MVP should deliver core user value
   - Consider: What's the smallest thing we can ship that's useful?

4. **Document the roadmap:**
   ```markdown
   ## Release Roadmap

   ### MVP (v1.0) - 25 requirements
   - Core user authentication
   - Basic product catalog
   - Simple checkout

   ### Phase 2 (v1.1) - 30 requirements
   - Advanced search
   - User reviews
   - Wishlist

   ### Phase 3 (v2.0) - 35 requirements
   - Recommendations
   - Social features
   - Advanced analytics

   ### Backlog - 15+ requirements
   - Internationalization
   - Mobile app
   - Marketplace
   ```

5. **Create separate documents:**
   - `prd-{project}-mvp.md` - MVP PRD (primary)
   - `prd-{project}-phase2.md` - Phase 2 PRD
   - `prd-{project}-backlog.md` - Master backlog

6. **Continue with MVP PRD:**
   - Focus on MVP for architecture and sprint planning
   - Reference future phases for context only
   - Revisit Phase 2 after MVP ships

**Prevention:**
- Challenge scope early in discovery
- Use MoSCoW ruthlessly (max 60% Must Have)
- Time-box requirements gathering
- Ask "Can we launch without this?"

---

### Recovery: Stakeholders Disagree on Scope

**Symptoms:**
- Different stakeholders have conflicting visions
- Meetings go in circles without resolution
- Requirements keep changing based on who you talk to

**Recovery Steps:**

1. **Document all perspectives:**
   - Who wants what and why?
   - What's the underlying need (not the stated request)?
   - Where do they agree vs disagree?

2. **Identify the decision-maker:**
   - Who has authority to resolve scope disputes?
   - Product Owner? Sponsor? Steering committee?

3. **Create options analysis:**
   ```markdown
   ## Scope Options

   ### Option A: Full Integration
   - Stakeholder A's preference
   - Includes: Feature X, Y, Z
   - Timeline: 6 months
   - Risk: High complexity

   ### Option B: Minimal Integration
   - Stakeholder B's preference
   - Includes: Feature X only
   - Timeline: 2 months
   - Risk: May need rework

   ### Option C: Phased Approach (Recommended)
   - Phase 1: Feature X (2 months)
   - Phase 2: Feature Y, Z (4 months)
   - Lower risk, faster initial value
   ```

4. **Facilitate decision:**
   - Present options objectively
   - Focus on user value and business goals
   - Get explicit decision documented
   - Record decision rationale

5. **Move forward:**
   - Update PRD with agreed scope
   - Communicate decision to all stakeholders
   - Don't relitigate unless new information emerges

**Prevention:**
- Align on vision before requirements
- Establish clear decision-making authority
- Document decisions as they're made
- Regular stakeholder sync meetings

---

## Notes for LLMs

- Maintain strategic, organized, pragmatic approach
- Use TodoWrite to track 8 major sections
- Apply MoSCoW consistently
- Ensure all requirements are testable
- Create traceability (FRs → Epics → Stories)
- Don't rush - good requirements save time later
- Validate completeness before finalizing
- **PRD quality determines implementation success**
