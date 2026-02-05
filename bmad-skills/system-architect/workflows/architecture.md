# [Architect] Create Architecture Workflow

**Purpose:** Design comprehensive system architecture from PRD requirements, covering components, data model, APIs, and NFRs.

**Phase:** 3 - Solutioning

**Agent:** System Architect

**Trigger keywords:** create architecture, design architecture, system design, tech stack, architecture design, technical architecture

**Inputs:** PRD (`accbmad/2-planning/prd-*.md`), Product Brief (optional), UX Design (optional)

**Output:** `accbmad/3-solutioning/architecture-{project}-{date}.md`

**Duration:** 60-120 minutes depending on project complexity

---

## Glossary

Quick reference for architectural terms used in this workflow:

| Term | Definition |
|------|------------|
| **Sharding** | Splitting database across multiple servers by key |
| **Multi-AZ** | Deploying across multiple availability zones for redundancy |
| **CQRS** | Command Query Responsibility Segregation - separate read/write models |
| **Event Sourcing** | Storing state changes as sequence of events |
| **Denormalization** | Duplicating data to optimize read performance |
| **Circuit Breaker** | Pattern to prevent cascading failures |

---

## When to Use This Workflow

Use this workflow when:
- PRD is complete and approved (Phase 2 done)
- Need to design technical implementation approach
- Selecting technology stack
- Defining system components and interfaces
- Planning data model and API design

**Invoke:** `/architecture` or `/create-architecture`

---

## Pre-Flight

1. **Load project context** - Check for `accbmad/config.yaml` or `CLAUDE.md`
2. **Verify PRD exists** - Search `docs/*prd*.md`
3. **Determine project level** - Affects architecture depth
4. **Check for existing architecture** - Resume vs new

---

## Level-Specific Guidance

| Level | Architecture Depth | Expected Output |
|-------|-------------------|-----------------|
| **0** | None needed | Skip to tech-spec |
| **1** | Lightweight | Single component, simple data model |
| **2** | Standard | Full architecture document |
| **3-4** | Comprehensive | Multi-component, detailed NFR coverage |

**Level 0-1:** Architecture is optional. Consider `/quick-spec` instead.

**Level 2+:** Full workflow with all steps required.

---

## Workflow Steps

### Step 1: Context Analysis

**Objective:** Understand requirements and constraints before making decisions.

1. **Load Input Documents**

   Search and read:
   - `accbmad/2-planning/prd-*.md` - Product Requirements Document
   - `accbmad/1-analysis/product-brief-*.md` - Product Brief (optional)
   - `docs/ux-*.md` - UX Design (optional)

2. **Extract Requirements Inventory**

   From PRD, identify:
   - **Functional Requirements (FRs):** FR-001, FR-002, etc.
   - **Non-Functional Requirements (NFRs):** Performance, security, scalability
   - **Technical Constraints:** Platform, language, existing systems
   - **Integration Points:** External APIs, third-party services

3. **Assess Project Context**

   **Greenfield vs Brownfield:**
   - Greenfield: New project, freedom in choices
   - Brownfield: Existing codebase, must integrate

   **Complexity Indicators:**
   - [ ] Multiple user types/roles
   - [ ] Real-time requirements
   - [ ] High availability needs (99.9%+)
   - [ ] Data compliance (GDPR, HIPAA)
   - [ ] Multi-tenant architecture
   - [ ] Offline capabilities
   - [ ] Complex workflows/state machines

4. **Present Context Summary**

   ```
   ## Context Analysis Complete

   **Project Type:** [Greenfield/Brownfield]
   **Complexity Level:** [Low/Medium/High]

   **Requirements Summary:**
   - Functional: {count} FRs
   - Non-Functional: {count} NFRs
   - Constraints: {list}

   **Key Challenges:**
   1. [Challenge 1]
   2. [Challenge 2]

   [C] Continue to architecture design
   [Q] Clarify requirements first
   ```

---

### Step 2: Architecture Pattern Selection

**Objective:** Choose the right architectural pattern for the project.

1. **Evaluate Pattern Options**

   | Pattern | Best For | Trade-offs |
   |---------|----------|------------|
   | **Monolith** | Simple apps, small teams, fast MVP | Scaling limits, deployment coupling |
   | **Modular Monolith** | Medium complexity, single deployment | Module boundaries need discipline |
   | **Microservices** | Large scale, multiple teams | Operational complexity, network overhead |
   | **Serverless** | Event-driven, variable load | Cold starts, vendor lock-in |
   | **Event-Driven** | Async workflows, decoupling | Eventual consistency, debugging |

2. **Pattern Selection Criteria**

   Based on NFRs:
   - **Scalability need high?** → Microservices or Serverless
   - **Team size < 5?** → Monolith or Modular Monolith
   - **Time to market critical?** → Monolith
   - **Independent deployments needed?** → Microservices
   - **Variable load patterns?** → Serverless

3. **Document Selection**

   ```
   ## Architecture Pattern

   **Selected:** {pattern}

   **Rationale:**
   - [Reason 1 tied to NFR/constraint]
   - [Reason 2]

   **Trade-offs Accepted:**
   - [Trade-off 1]
   - [Trade-off 2]
   ```

---

### Step 3: Technology Stack Selection

**Objective:** Select technologies that meet requirements and constraints.

1. **Stack Decision Categories**

   | Category | Decision Needed | Considerations |
   |----------|-----------------|----------------|
   | **Language/Runtime** | Primary language | Team skills, ecosystem, performance |
   | **Framework** | Web/API framework | Maturity, community, learning curve |
   | **Database** | Primary datastore | SQL vs NoSQL, scale, consistency |
   | **Cache** | Caching layer | Read patterns, invalidation strategy |
   | **Message Queue** | Async communication | Durability, ordering, throughput |
   | **Search** | Full-text search | If needed by requirements |
   | **Frontend** | UI framework | SPA vs SSR, mobile needs |
   | **Infrastructure** | Cloud/hosting | Cost, compliance, team familiarity |

2. **Constraint-First Selection**

   If PRD specifies constraints:
   - Use specified technologies
   - Document any concerns with rationale

   If no constraints:
   - Prefer mature, well-supported options
   - Consider team skills (if known)
   - Favor simplicity over novelty

3. **Present Stack Proposal**

   ```
   ## Technology Stack Proposal

   | Layer | Technology | Rationale |
   |-------|------------|-----------|
   | Backend | {tech} | {reason} |
   | Database | {tech} | {reason} |
   | Frontend | {tech} | {reason} |
   | Infrastructure | {tech} | {reason} |

   **Alternatives Considered:**
   - [Alternative 1]: Rejected because [reason]

   [A] Approve stack
   [R] Revise selection
   ```

---

### Step 4: Component Design

**Objective:** Define system components, responsibilities, and interfaces.

1. **Identify Components**

   From requirements, identify:
   - **Core Components:** Essential for main functionality
   - **Supporting Components:** Authentication, logging, monitoring
   - **External Integrations:** Third-party services

2. **Define Each Component**

   For each component:
   ```
   ### {Component Name}

   **Purpose:** {single sentence}

   **Responsibilities:**
   - [Responsibility 1]
   - [Responsibility 2]

   **Interfaces:**
   - Exposes: [API/Events/Methods]
   - Consumes: [Dependencies]

   **Data Owned:**
   - [Entity 1]
   - [Entity 2]
   ```

3. **Component Interaction Diagram**

   Create ASCII or Mermaid diagram:
   ```
   [Client] → [API Gateway] → [Auth Service]
                           → [Core Service] → [Database]
                           → [Notification Service]
   ```

4. **Validate Component Design**

   Checklist:
   - [ ] Each FR maps to at least one component
   - [ ] No circular dependencies
   - [ ] Single responsibility per component
   - [ ] Clear data ownership (no shared databases)

---

### Step 5: Data Model Design

**Objective:** Define entities, relationships, and data storage strategy.

1. **Identify Core Entities**

   From FRs, extract:
   - Primary entities (User, Order, Product, etc.)
   - Relationships (1:1, 1:N, M:N)
   - Key attributes per entity

2. **Data Model Decisions**

   | Decision | Options | Considerations |
   |----------|---------|----------------|
   | **Normalization** | Normalized vs Denormalized | Write vs Read optimization |
   | **Partitioning** | Horizontal vs Vertical | Scale requirements |
   | **Audit** | Soft delete, versioning | Compliance needs |
   | **Multi-tenancy** | Shared vs Isolated | Security, scale |

3. **Entity Definitions**

   For each entity:
   ```
   ### {Entity Name}

   | Field | Type | Constraints | Notes |
   |-------|------|-------------|-------|
   | id | UUID | PK | |
   | name | string | required, max 255 | |
   | created_at | timestamp | auto | |

   **Relationships:**
   - Has many: {related entities}
   - Belongs to: {parent entity}

   **Indexes:**
   - {field} - for {query pattern}
   ```

---

### Step 6: API Design

**Objective:** Define external and internal API contracts.

1. **API Style Selection**

   | Style | Best For | Considerations |
   |-------|----------|----------------|
   | **REST** | CRUD operations, wide compatibility | Standard choice |
   | **GraphQL** | Complex queries, mobile clients | Query complexity |
   | **gRPC** | Internal services, performance | Binary protocol |
   | **WebSocket** | Real-time, bidirectional | Stateful connections |

2. **Define API Endpoints**

   For each major capability:
   ```
   ### {Resource} API

   | Method | Path | Description | Auth |
   |--------|------|-------------|------|
   | GET | /api/v1/{resource} | List all | Required |
   | POST | /api/v1/{resource} | Create new | Required |
   | GET | /api/v1/{resource}/{id} | Get by ID | Required |
   | PUT | /api/v1/{resource}/{id} | Update | Required |
   | DELETE | /api/v1/{resource}/{id} | Delete | Required |
   ```

3. **API Design Principles**

   Apply consistently:
   - Versioning strategy (URL path `/v1/`)
   - Error response format (consistent structure)
   - Pagination pattern (cursor vs offset)
   - Rate limiting approach
   - Authentication method (JWT, API Key, OAuth)

---

### Step 7: NFR Coverage Mapping

**Objective:** Ensure every non-functional requirement has an architectural solution.

1. **NFR Categories**

   | Category | Common NFRs | Architectural Approaches |
   |----------|-------------|-------------------------|
   | **Performance** | Response time, throughput | Caching, async, CDN |
   | **Scalability** | Users, data volume | Horizontal scaling, sharding |
   | **Security** | Auth, encryption, audit | Zero trust, encryption at rest |
   | **Reliability** | Uptime, disaster recovery | Redundancy, backups, failover |
   | **Maintainability** | Code quality, updates | Modular design, CI/CD |
   | **Compliance** | GDPR, HIPAA, SOC2 | Data handling, audit logs |

2. **Create NFR Mapping**

   For each NFR from PRD:
   ```
   | NFR ID | Requirement | Solution | Component |
   |--------|-------------|----------|-----------|
   | NFR-001 | 99.9% uptime | Multi-AZ deployment | Infrastructure |
   | NFR-002 | < 200ms response | Redis cache | API Gateway |
   | NFR-003 | GDPR compliance | Data encryption, audit logs | All |
   ```

3. **Validate Coverage**

   - [ ] Every NFR has at least one solution
   - [ ] Solutions are feasible with chosen stack
   - [ ] Trade-offs documented

---

### Step 8: Architecture Quality Review

**Objective:** Validate architecture before finalizing.

**Quality Checklist:**

| Category | Check | Status |
|----------|-------|--------|
| **Completeness** | All FRs have component mapping | |
| **Completeness** | All NFRs have solutions | |
| **Consistency** | No conflicting decisions | |
| **Feasibility** | Stack supports all requirements | |
| **Scalability** | Can handle projected load | |
| **Security** | Auth, authz, encryption addressed | |
| **Maintainability** | Clear boundaries, no tight coupling | |
| **Operability** | Logging, monitoring, alerting planned | |

**Architecture Anti-Pattern Check:**

- [ ] No single points of failure
- [ ] No shared mutable state between services
- [ ] No synchronous chains > 3 services
- [ ] No database as integration point
- [ ] No hardcoded secrets or endpoints

---

### Step 9: Generate Output Document

**Objective:** Create the final architecture document.

1. **Use Template**

   Load `templates/architecture.template.md` and populate all sections.

2. **Document Structure**

   The architecture document should include:
   1. System Overview
   2. Architecture Pattern
   3. Component Design
   4. Data Model
   5. API Specifications
   6. NFR Mapping
   7. Technology Stack
   8. Trade-off Analysis
   9. Deployment Architecture
   10. Future Considerations

3. **Save Document**

   Output: `accbmad/3-solutioning/architecture-{project}-{date}.md`

4. **Present Completion**

   ```
   ## Architecture Design Complete

   **Document:** accbmad/3-solutioning/architecture-{project}-{date}.md

   **Summary:**
   - Pattern: {pattern}
   - Components: {count}
   - Entities: {count}
   - API Endpoints: {count}
   - NFR Coverage: {count}/{total}

   **Next Steps:**
   [G] Gate check - Run /solutioning-gate-check to validate before implementation
   [E] Epics - Run /create-epics-stories to break down into user stories
   [R] Review - Examine specific section in detail
   ```

### Handling Edge Cases

**If PRD has no explicit NFRs:**
1. Derive NFRs from FRs (e.g., "fast search" implies performance NFR)
2. Apply standard NFR categories as checklist
3. Document assumptions and get stakeholder confirmation

**If existing architecture needs extension:**
1. Load existing `accbmad/3-solutioning/architecture-*.md`
2. Identify sections to update
3. Mark changes with `[UPDATED]` tags
4. Maintain backwards compatibility unless explicitly changing

---

## Subagent Strategy

For complex projects (Level 3-4), use parallel analysis:

**Pattern:** Fan-Out Architecture Analysis
**When:** 6+ components, 10+ NFRs

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Data model design | `accbmad/outputs/data-model.md` |
| Agent 2 | API design | `accbmad/outputs/api-design.md` |
| Agent 3 | NFR solutions | `accbmad/outputs/nfr-solutions.md` |
| Main | Synthesize into architecture | `accbmad/3-solutioning/architecture-*.md` |

**Coordination:**
1. Main context selects pattern and stack
2. Write shared context to `accbmad/context/arch-decisions.md`
3. Launch parallel agents for independent design tasks
4. Collect outputs and synthesize
5. Run quality review on combined result

---

## ADR (Architecture Decision Record)

For significant decisions, create ADR:

```markdown
# [Architect] ADR-{number}: {Title}

**Status:** Proposed | Accepted | Deprecated | Superseded

**Context:** What situation requires a decision?

**Decision:** What decision was made?

**Consequences:**
- Positive: [benefits]
- Negative: [trade-offs]
- Risks: [potential issues]

**Alternatives Considered:**
1. [Alternative 1]: Rejected because [reason]
2. [Alternative 2]: Rejected because [reason]
```

Save to: `docs/adr/ADR-{number}-{slug}.md`

---

## Integration Points

- **Input from:** `/prd`, `/product-brief`, `/create-ux-design`
- **Output to:** `/solutioning-gate-check`, `/create-epics-stories`
- **Related:** `/tech-spec` (lightweight alternative)

---

## HALT Conditions

**Stop and ask for guidance when:**

- Stakeholders disagree on fundamental approach
- Multiple valid architectures with no clear winner
- Previous decisions contradict new requirements
- Critical NFR cannot be met with proposed approach
- Security requirements unclear or conflicting
- Budget/timeline constraints make approach infeasible

**Never stop for:**

- Minor technology choices (can decide independently)
- Standard pattern selection (use best practices)
- Documentation formatting

---

## HALT Recovery Paths

### Recovery: Conflicting Architecture Decisions

**Symptoms:**
- Stakeholders disagree on approach (monolith vs microservices, cloud vs on-prem)
- Multiple valid solutions exist with different trade-offs
- Previous architectural decisions contradict new requirements

**Recovery Steps:**

1. **Document the conflict clearly:**
   - Create draft ADR for each option
   - List pros/cons objectively
   - Note stakeholder positions and concerns
   - Identify what's driving the disagreement

2. **Create decision matrix:**

   | Criterion | Weight | Option A | Option B | Option C |
   |-----------|--------|----------|----------|----------|
   | Performance | 3 | 8 | 6 | 7 |
   | Maintainability | 2 | 7 | 9 | 6 |
   | Cost | 2 | 5 | 8 | 7 |
   | Time to market | 3 | 6 | 7 | 9 |
   | Team expertise | 2 | 8 | 5 | 6 |
   | **Weighted Total** | | **70** | **70** | **72** |

3. **Facilitate decision:**
   - Schedule architecture review meeting if needed
   - Present options with trade-offs
   - Focus on project goals, not preferences
   - Use data and evidence where possible

4. **If still deadlocked:**
   - Identify the decision-maker (tech lead, architect, CTO)
   - Present summary with your recommendation
   - Accept the decision and document rationale
   - Don't relitigate once decided

5. **Finalize:**
   - Create ADR with chosen approach
   - Document why alternatives were rejected
   - Update architecture document
   - Communicate decision to team

**Prevention:**
- Establish decision-making authority upfront
- Document architectural principles early
- Have regular architecture review meetings
- Create ADRs for significant decisions

---

### Recovery: NFR Cannot Be Met

**Symptoms:**
- Performance requirement exceeds what architecture can deliver
- Security requirement conflicts with usability needs
- Cost constraints make required approach infeasible

**Recovery Steps:**

1. **Quantify the gap:**
   - Current capability vs requirement
   - What would it take to meet the requirement?
   - What's the cost/complexity delta?

2. **Options to present:**

   | Option | Description | Trade-off |
   |--------|-------------|-----------|
   | **Reduce requirement** | Lower the bar | May not meet user needs |
   | **Increase budget** | Add resources | Cost increase |
   | **Change approach** | Different architecture | Rework required |
   | **Phase delivery** | Meet partially now | Delayed full compliance |

3. **Document clearly:**
   ```markdown
   ## NFR Conflict: Performance

   **Requirement:** 99.99% uptime
   **Current capability:** 99.9% with proposed architecture
   **Gap:** 0.09% (roughly 8 hours/year difference)

   **Options:**
   1. Multi-region deployment (+$50K/year) → Meets 99.99%
   2. Accept 99.9% SLA → Save cost, document risk
   3. Hybrid: 99.99% for critical paths only
   ```

4. **Escalate for decision:**
   - Present to product owner/stakeholders
   - Get explicit acceptance of trade-off
   - Document the decision in architecture

**Prevention:**
- Validate NFRs early with rough architecture
- Challenge unrealistic requirements upfront
- Prototype critical paths before committing

---

## Notes for Claude

**Tool Usage:**
- Use Glob to find PRD: `docs/*prd*.md`
- Use Read to load documents completely
- Use Write to save architecture document
- Use TodoWrite to track progress

**Key Principles:**
- Architecture serves requirements, not preferences
- Document trade-offs explicitly
- Every decision needs rationale
- Keep solutions appropriate to project level
- Don't over-engineer Level 1-2 projects
- Security is not optional

**Common Mistakes to Avoid:**
- Choosing tech based on hype, not fit
- Over-architecting simple projects
- Under-specifying NFR solutions
- Ignoring operational concerns
- Creating circular dependencies
- Shared databases between services

**Quality Checks:**
- 100% FR coverage by components
- 100% NFR coverage by solutions
- All decisions have rationale
- No architectural anti-patterns
