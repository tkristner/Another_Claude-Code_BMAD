---
layout: default
title: "Commands Reference - Another Claude-Code BMAD"
description: "Complete reference for all 34 Another Claude-Code BMAD slash commands. Learn how to use each command with detailed examples and best practices."
keywords: "BMAD commands, Claude Code commands, slash commands, workflow commands, agile commands"
---

# Commands Reference

Another Claude-Code BMAD provides **34 slash commands** for managing your agile development workflow. Each command is designed for a specific phase and purpose.

> **Note:** All commands use the `/accbmad:` prefix (e.g., `/accbmad:workflow-init`).

---

## How Commands Work

Commands are markdown files in `~/.claude/commands/accbmad/` that define interactive workflows. When you type a command like `/prd`, Claude Code loads the command definition and guides you through the process.

**Quick tip:** Type `/workflow-status` anytime to see which command to run next.

---

## Commands by Phase

### Initialization

| Command | Purpose |
|---------|---------|
| [/workflow-init](#workflow-init) | Initialize BMAD in your project |
| [/workflow-status](#workflow-status) | Check progress and get recommendations |

### Phase 1 - Analysis

| Command | Purpose |
|---------|---------|
| [/product-brief](#product-brief) | Create comprehensive product brief |

### Phase 2 - Planning

| Command | Purpose |
|---------|---------|
| [/prd](#prd) | Product Requirements Document |
| [/tech-spec](#tech-spec) | Technical Specification (Level 0-1) |
| [/quick-spec](#quick-spec) | Quick conversational spec (15-45 min) |
| [/validate-prd](#validate-prd) | Validate PRD quality |
| [/create-ux-design](#create-ux-design) | UX/UI design workflow |

### Phase 3 - Solutioning

| Command | Purpose |
|---------|---------|
| [/architecture](#architecture) | System architecture design |
| [/solutioning-gate-check](#solutioning-gate-check) | Validate architecture |
| [/check-implementation-readiness](#check-implementation-readiness) | Pre-implementation gate check |
| [/generate-project-context](#generate-project-context) | Generate AI agent context rules |

### Phase 4 - Implementation

| Command | Purpose |
|---------|---------|
| [/sprint-planning](#sprint-planning) | Plan sprint iterations |
| [/create-epics-stories](#create-epics-stories) | Transform PRD into epics and stories |
| [/create-story](#create-story) | Create individual story |
| [/dev-story](#dev-story) | Implement user story |
| [/dev-story-auto](#dev-story-auto) | **Autonomous sprint execution** |
| [/quick-dev](#quick-dev) | Quick implementation with built-in review |
| [/code-review](#code-review) | Adversarial code review (3-10 issues min) |
| [/qa-automate](#qa-automate) | Auto-generate tests |

### Builder (Custom)

| Command | Purpose |
|---------|---------|
| [/create-agent](#create-agent) | Create custom BMAD agent |
| [/create-workflow](#create-workflow) | Create custom workflow |

### Creative Intelligence

| Command | Purpose |
|---------|---------|
| [/brainstorm](#brainstorm) | Structured brainstorming |
| [/research](#research) | Market/tech/competitive research |

---

## Initialization Commands

<h3 id="workflow-init">/workflow-init</h3>

Initialize BMAD in your project. This creates the project configuration and sets up the output directory structure.

**When to use:** At the start of any new project

**Output:** `accbmad/config.yaml`

#### Example

~~~~
User: /workflow-init

Claude: Welcome to BMAD! I'll initialize your project.

## Project Configuration

What is your project name?
> Real-time Chat Application

What type of project is this?
1. web-app
2. mobile-app
3. api
4. game
5. library
6. other
> 1

## Project Level

Based on scope, select the appropriate level:

| Level | Stories | Example |
|-------|---------|---------|
| 0 | 1 | Bug fix |
| 1 | 1-10 | Single feature |
| 2 | 5-15 | Feature set |
| 3 | 12-40 | System integration |
| 4 | 40+ | Enterprise |

For a chat app with user auth, real-time messaging, channels,
and notifications, I recommend Level 2.

Select level (0-4):
> 2

## Created Configuration

```yaml
# accbmad/config.yaml
project_name: "Real-time Chat Application"
project_type: "web-app"
project_level: 2
output_folder: "docs"

bmm:
  workflow_status_file: "accbmad/status.yaml"
  sprint_status_file: "accbmad/4-implementation/sprint.yaml"

paths:
  docs: "docs"
  stories: "accbmad/4-implementation/stories"
  tests: "tests"
```

Created directories:
- docs/
- accbmad/4-implementation/stories/

Project initialized! Run /workflow-status to see next steps.
~~~~

---

<h3 id="workflow-status">/workflow-status</h3>

Check your project's current progress and get recommendations for what to do next.

**When to use:** Anytime you're unsure what to do next

**Output:** Status display (no file)

#### Example

```
User: /workflow-status

Claude: ## Real-time Chat Application - Workflow Status

### Project Info
- Type: web-app
- Level: 2 (Medium feature set)
- Output: docs/

### Phase Status

| Phase | Document | Status | File |
|-------|----------|--------|------|
| 1 - Analysis | Product Brief | ✓ Complete | accbmad/1-analysis/product-brief.md |
| 2 - Planning | PRD | ✓ Complete | accbmad/2-planning/prd.md |
| 2 - Planning | UX Design | Optional | - |
| 3 - Solutioning | Architecture | ⚠ In Progress | - |
| 4 - Implementation | Sprint Plan | Pending | - |

### Recommendation

**Current Focus:** Phase 3 - Solutioning

Continue with `/architecture` to complete the system architecture design.

After architecture is complete:
1. Run `/solutioning-gate-check` to validate
2. Proceed to `/sprint-planning`

### Quick Stats
- Documents: 2/4 complete
- Estimated remaining: Architecture, Sprint Plan
```

---

## Phase 1 - Analysis Commands

<h3 id="product-brief">/product-brief</h3>

Create a comprehensive product brief that defines the problem space, target audience, and business goals.

**When to use:** Starting a new product (Level 1+, required for Level 2+)

**Output:** `accbmad/1-analysis/product-brief.md`

**Prerequisite:** `/workflow-init`

#### Example

```
User: /product-brief

Claude: I'll help create a product brief for Real-time Chat Application.

## Executive Summary

In 2-3 sentences, what does this product do?
> A team collaboration platform focused on real-time communication.
> Combines chat, voice, and video with deep integrations for
> developer tools.

## Problem Statement

What problems does this solve? I'll structure them:

1. **Communication silos:** Teams use multiple apps (Slack, Discord, Teams)
2. **Context switching:** Developers lose focus switching between chat and IDE
3. **Limited customization:** Existing tools have rigid workflows

Is this accurate?
> Yes, also add "Poor code sharing experience"

Added: **Poor code sharing:** Pasting code in chat loses formatting and context

## Target Audience

Primary users:
> Software development teams, 5-50 people
> Tech-forward companies
> Remote-first teams

Secondary users:
> Individual developers in open source communities

## Solution Overview

Based on problems, your solution will:
- Unified chat, voice, video in one app
- IDE extensions (VS Code, JetBrains)
- Rich code snippets with syntax highlighting
- Customizable workflows and bots

## Competitive Landscape

Key competitors:
- **Slack:** Market leader, expensive, slow
- **Discord:** Gaming-focused, poor enterprise features
- **Teams:** Microsoft-only, complex

Your differentiation:
> Developer-first experience, superior code handling,
> privacy-focused (self-hostable)

## Business Model

How will you monetize?
> Freemium - free for small teams (<10)
> Pro: $8/user/month
> Enterprise: $15/user/month (SSO, audit logs)

## Success Metrics

How will you measure success?
> - 1000 teams in 6 months
> - 40% weekly active users
> - <200ms message delivery
> - NPS > 50

## Constraints and Risks

Technical constraints:
> - Must support 10k concurrent users
> - End-to-end encryption required

Risks:
> - Slack network effects
> - Feature parity expectations

Saving product brief to: accbmad/1-analysis/product-brief.md

Product brief complete! Run /workflow-status for next steps.
```

---

## Phase 2 - Planning Commands

<h3 id="prd">/prd</h3>

Create a Product Requirements Document with detailed functional requirements, user stories, and acceptance criteria.

**When to use:** Level 2+ projects after product brief

**Output:** `accbmad/2-planning/prd.md`

**Prerequisite:** `accbmad/1-analysis/product-brief.md`

#### Example

```
User: /prd

Claude: I'll create a PRD based on your product brief.

Loading: accbmad/1-analysis/product-brief.md

## Functional Requirements

### FR-001: User Authentication
Users can register, login, and manage their accounts.

**Acceptance Criteria:**
- [ ] Email/password registration
- [ ] OAuth (Google, GitHub)
- [ ] Email verification
- [ ] Password reset flow
- [ ] 2FA support

### FR-002: Real-time Messaging
Users can send and receive messages instantly.

**Acceptance Criteria:**
- [ ] Text messages with markdown support
- [ ] Message delivery <200ms
- [ ] Typing indicators
- [ ] Read receipts
- [ ] Message editing and deletion
- [ ] Thread replies

### FR-003: Channels and DMs
Users can communicate in channels or direct messages.

**Acceptance Criteria:**
- [ ] Create public/private channels
- [ ] Channel topics and descriptions
- [ ] Direct messages (1:1 and group)
- [ ] Channel member management
- [ ] Channel archiving

### FR-004: Code Sharing
Developers can share code with syntax highlighting.

**Acceptance Criteria:**
- [ ] Code blocks with language detection
- [ ] Syntax highlighting for 50+ languages
- [ ] Line numbers
- [ ] Copy button
- [ ] Expandable for long snippets

### FR-005: Search
Users can search messages and files.

**Acceptance Criteria:**
- [ ] Full-text message search
- [ ] Filter by channel/user/date
- [ ] Search within code blocks
- [ ] Search suggestions

### FR-006: Notifications
Users receive timely notifications.

**Acceptance Criteria:**
- [ ] Desktop notifications
- [ ] Mobile push notifications
- [ ] @mention highlighting
- [ ] Custom notification schedules
- [ ] Do not disturb mode

## Non-Functional Requirements

### NFR-001: Performance
- Message delivery: <200ms P99
- Search results: <500ms
- App load time: <3s
- Support 10k concurrent users per server

### NFR-002: Security
- End-to-end encryption option
- SOC 2 compliance path
- Data residency options
- Audit logging for enterprise

### NFR-003: Scalability
- Horizontal scaling for message service
- Sharded database for messages
- CDN for file attachments

### NFR-004: Availability
- 99.9% uptime SLA
- Multi-region deployment
- Automated failover

## Epics and User Stories

### Epic 1: User Management

**STORY-001: User Registration**
As a new user, I want to create an account so I can join my team's workspace.

Points: 5 | Priority: Must

Acceptance Criteria:
- Register with email/password
- Validate email format
- Password strength requirements
- Email verification sent
- Redirect to workspace setup

**STORY-002: OAuth Login**
As a user, I want to login with Google/GitHub so I don't need another password.

Points: 5 | Priority: Must

**STORY-003: Two-Factor Authentication**
As a security-conscious user, I want to enable 2FA to protect my account.

Points: 5 | Priority: Should

### Epic 2: Messaging

**STORY-004: Send Message**
As a user, I want to send messages so I can communicate with my team.

Points: 3 | Priority: Must

**STORY-005: Real-time Updates**
As a user, I want to see new messages instantly without refreshing.

Points: 8 | Priority: Must

**STORY-006: Message Threading**
As a user, I want to reply in threads to keep discussions organized.

Points: 5 | Priority: Must

[... continued for all stories]

## Prioritization (MoSCoW)

### Must Have (MVP)
- FR-001: Authentication (basic)
- FR-002: Real-time messaging
- FR-003: Channels and DMs
- FR-004: Code sharing
- FR-006: Notifications (desktop)

### Should Have
- FR-001: 2FA
- FR-005: Search
- FR-006: Mobile notifications
- Voice calls

### Could Have
- Video calls
- Screen sharing
- Custom workflows

### Won't Have (this release)
- Self-hosting
- Mobile apps
- API marketplace

## Summary

- **Total epics:** 6
- **Total stories:** 28
- **Total points:** 142
- **Must-have points:** 89
- **Estimated MVP sprints:** 4 (at 25 pts/sprint)

Saving PRD to: accbmad/2-planning/prd.md
```

---

<h3 id="tech-spec">/tech-spec</h3>

Create a lightweight technical specification for Level 0-1 projects. Simpler than a full PRD.

**When to use:** Level 0-1 projects (small features, bug fixes)

**Output:** `accbmad/2-planning/tech-spec.md`

**Prerequisite:** `/workflow-init`

#### Example

~~~~
User: /tech-spec

Claude: I'll create a tech spec for your project.

## Feature Overview

What are you building?
> Add password reset functionality to existing auth system

## Requirements

List the core requirements:
> 1. User requests reset via email
> 2. System sends reset link (expires in 1 hour)
> 3. User clicks link and sets new password
> 4. Old sessions are invalidated

## Technical Details

### Files to Modify/Create

1. `src/routes/auth.js` - Add reset endpoints
2. `src/services/email.js` - Reset email template
3. `src/models/PasswordReset.js` - Reset token model
4. `tests/auth.test.js` - Test coverage

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /auth/forgot-password | Request reset email |
| GET | /auth/reset-password/:token | Validate token |
| POST | /auth/reset-password/:token | Set new password |

### Data Model

```javascript
// PasswordReset model
{
  userId: ObjectId,
  token: String (hashed),
  expiresAt: Date,
  used: Boolean
}
```

### Email Template

Subject: "Reset your password"
Body: "Click here to reset: {reset_link}"
Expiration note: "This link expires in 1 hour"

## Acceptance Criteria

- [ ] Request reset with valid email sends reset email
- [ ] Request with invalid email shows generic success (security)
- [ ] Token valid for 1 hour
- [ ] Token can only be used once
- [ ] Password meets strength requirements
- [ ] All existing sessions invalidated after reset
- [ ] Unit tests pass with >80% coverage

## Dependencies

- Existing: nodemailer, bcrypt
- New: none

## Estimated Effort

2-3 points (half day to one day)

Saving tech spec to: accbmad/2-planning/tech-spec.md
~~~~

---

<h3 id="quick-spec">/quick-spec</h3>

Create a quick technical specification through conversational elicitation. Ideal for small features (1-5 story points).

**When to use:** Small focused features, bug fixes requiring spec, rapid prototyping

**Output:** `accbmad/2-planning/tech-spec-quick-{feature}.md`

**Duration:** 15-45 minutes

#### Example

```
User: /quick-spec

Claude: Describe the feature you want to implement.
> Add an endpoint to export orders as CSV

[Automatic codebase scan...]

Found:
- Framework: Express.js
- Model: src/models/order.js
- Routing pattern: src/routes/api/v1/

Questions:
1. Date range filter needed? > Yes
2. Which fields to include? > id, date, customer, total, status
3. Pagination for large exports? > No, stream response

Generating spec...

Output: accbmad/2-planning/tech-spec-quick-export-orders-csv-2026-02-02.md

Ready for /quick-dev
```

---

<h3 id="validate-prd">/validate-prd</h3>

Validate a PRD against quality criteria before proceeding to architecture.

**When to use:** After creating a PRD, before architecture phase

**Input:** Path to PRD (optional, auto-detects if not provided)

**Output:** Validation report with recommendations

#### Example

```
User: /validate-prd accbmad/2-planning/prd-inventory.md

Claude: Validating PRD...

## Validation Report

| Dimension | Score | Status |
|-----------|-------|--------|
| Completeness | 9/10 | PASS |
| Measurability | 6/10 | CONDITIONAL |
| Traceability | 8/10 | PASS |
| Clarity | 7/10 | PASS |

## Critical Issues (Must Fix)
1. FR-007: Missing acceptance criteria
2. NFR-003: "Fast" is not measurable → suggest "< 200ms p95"

## Warnings
1. Section "Risks" is missing (recommended)
2. FR-012 and FR-013 appear duplicated

Status: CONDITIONAL PASS (76%)

[F] Fix issues now
[R] Generate full report
[S] Save and proceed anyway
```

---

<h3 id="create-ux-design">/create-ux-design</h3>

Create UX designs including user flows, wireframes, and design system specifications.

**When to use:** Level 2+ projects with user interfaces

**Output:** `accbmad/2-planning/ux-design.md`

**Prerequisite:** `accbmad/2-planning/prd.md`

#### Example

~~~~
User: /create-ux-design

Claude: I'll create UX designs for Real-time Chat Application.

Loading: accbmad/2-planning/prd.md

## User Personas

### Primary: Sarah - Senior Developer
- 32 years old, remote worker
- Uses Slack, VS Code, GitHub daily
- Frustrated by context switching
- Values keyboard shortcuts and speed

### Secondary: Mike - Engineering Manager
- 45 years old, manages 12 developers
- Needs visibility into team communication
- Cares about security and compliance

## User Flows

### Flow 1: Onboarding
```
Sign Up → Verify Email → Create Workspace → Invite Team → Tutorial → Dashboard
```

### Flow 2: Send Message
```
Open Channel → Type Message → Format (optional) → Send → Confirm Delivery
```

### Flow 3: Code Sharing
```
Type ``` → Select Language → Paste Code → Preview → Send
```

## Information Architecture

```
App
├── Sidebar
│   ├── Workspace Switcher
│   ├── Search
│   ├── Channels
│   │   ├── Public
│   │   └── Private
│   ├── Direct Messages
│   └── Settings
├── Main Content
│   ├── Channel Header
│   ├── Message List
│   └── Message Input
└── Right Panel (contextual)
    ├── Thread View
    ├── User Profile
    └── Channel Info
```

## Wireframes

### Main Chat View
```
┌──────────────────────────────────────────┐
│ [=] Search...                 [@] [⚙️]  │
├────────────┬─────────────────────────────┤
│ # general  │ # general                   │
│ # random   │ ────────────────────────    │
│ # dev      │ Sarah: Hey team, check out  │
│            │ this PR: github.com/...     │
│ DMs        │                             │
│ @ Mike     │ Mike: LGTM! 👍              │
│ @ Alex     │                             │
│            │ Sarah: Thanks! Merging now  │
│            │                             │
│ ────────── │ ────────────────────────    │
│ [+ Add]    │ [📎] Type message... [→]    │
└────────────┴─────────────────────────────┘
```

### Code Snippet
```
┌─────────────────────────────┐
│ javascript               📋 │
├─────────────────────────────┤
│ 1  function greet(name) {   │
│ 2    return `Hello ${name}` │
│ 3  }                        │
└─────────────────────────────┘
```

## Design System

### Colors
```
Primary:    #5865F2 (Blurple)
Success:    #57F287 (Green)
Warning:    #FEE75C (Yellow)
Error:      #ED4245 (Red)
Background: #36393F (Dark)
Surface:    #2F3136 (Darker)
Text:       #DCDDDE (Light)
Muted:      #72767D (Gray)
```

### Typography
```
Headings: Inter, 600
Body:     Inter, 400
Code:     JetBrains Mono, 400

Sizes:
H1: 24px
H2: 20px
H3: 16px
Body: 14px
Small: 12px
```

### Spacing
```
4px  - Icon padding
8px  - Small gaps
12px - Component padding
16px - Section gaps
24px - Large sections
```

### Components

1. **Button**
   - Primary (filled blue)
   - Secondary (outline)
   - Danger (red)
   - Ghost (text only)

2. **Input**
   - Text field
   - Search with icon
   - Message composer

3. **Avatar**
   - Sizes: 24px, 32px, 48px
   - Status indicator (green/yellow/red/gray)

4. **Message**
   - User avatar + name + timestamp
   - Message content
   - Reactions bar
   - Thread indicator

5. **Code Block**
   - Language label
   - Copy button
   - Line numbers
   - Syntax highlighting

## Accessibility (WCAG 2.1 AA)

### Color Contrast
- [x] Text/background: 7.2:1 (AAA)
- [x] Interactive elements: 4.6:1 (AA)

### Keyboard Navigation
- [x] All interactive elements focusable
- [x] Visible focus indicators
- [x] Logical tab order
- [x] Keyboard shortcuts documented

### Screen Readers
- [x] Semantic HTML structure
- [x] ARIA labels for icons
- [x] Live regions for new messages
- [x] Alt text for images

### Motion
- [x] Respects prefers-reduced-motion
- [x] No auto-playing animations

## Responsive Breakpoints

- Mobile: 320px - 767px
- Tablet: 768px - 1023px
- Desktop: 1024px+

Mobile layout: Sidebar as overlay, single column
Tablet: Collapsible sidebar
Desktop: Full three-column layout

Saving UX design to: accbmad/2-planning/ux-design.md
~~~~

---

## Phase 3 - Solutioning Commands

<h3 id="architecture">/architecture</h3>

Design the system architecture including components, data models, APIs, and technology choices.

**When to use:** Level 2+ projects after PRD

**Output:** `accbmad/3-solutioning/architecture.md`

**Prerequisite:** `accbmad/2-planning/prd.md`

#### Example

See the [System Architect skill documentation](../skills/#system-architect) for a complete architecture example.

---

<h3 id="solutioning-gate-check">/solutioning-gate-check</h3>

Validate that the architecture addresses all requirements from the PRD.

**When to use:** After completing architecture, before sprint planning

**Output:** Status display (no file)

**Prerequisites:** `accbmad/2-planning/prd.md`, `accbmad/3-solutioning/architecture.md`

#### Example

```
User: /solutioning-gate-check

Claude: I'll validate your architecture against the PRD.

Loading: accbmad/2-planning/prd.md, accbmad/3-solutioning/architecture.md

## Functional Requirements Check

| FR | Description | Addressed | Notes |
|----|-------------|-----------|-------|
| FR-001 | Authentication | ✓ | Auth service, JWT, OAuth |
| FR-002 | Real-time messaging | ✓ | WebSocket service, Redis |
| FR-003 | Channels/DMs | ✓ | Channel service |
| FR-004 | Code sharing | ✓ | Message service + Prism.js |
| FR-005 | Search | ✓ | Elasticsearch |
| FR-006 | Notifications | ✓ | Push service, FCM |

## Non-Functional Requirements Check

| NFR | Requirement | Solution | Status |
|-----|-------------|----------|--------|
| NFR-001 | <200ms messages | WebSocket + Redis PubSub | ✓ |
| NFR-001 | <500ms search | Elasticsearch | ✓ |
| NFR-002 | E2E encryption | Signal protocol | ✓ |
| NFR-003 | 10k users | Horizontal scaling, sharding | ✓ |
| NFR-004 | 99.9% uptime | Multi-AZ, failover | ✓ |

## Gap Analysis

### Addressed
All functional and non-functional requirements have corresponding
architecture components.

### Potential Concerns

1. **Message ordering:** Architecture mentions "eventual consistency"
   but FR-002 requires strict ordering. Consider:
   - Vector clocks for ordering
   - Single leader per channel

2. **Search latency:** Elasticsearch is specified but indexing
   strategy not detailed. Consider:
   - Index message on write vs. async
   - Partial word matching approach

3. **File attachments:** FR-002 mentions file sharing but
   architecture doesn't specify:
   - Storage solution (S3?)
   - CDN for delivery
   - Virus scanning

### Recommendations

1. Add message ordering strategy to architecture
2. Detail Elasticsearch indexing approach
3. Add file attachment subsystem

## Gate Status: CONDITIONAL PASS

Address the 3 concerns above before proceeding to sprint planning.

Would you like me to help update the architecture document?
> Yes

[Updates architecture.md with the missing details]

Re-running gate check...

Gate Status: PASS ✓

Ready for /sprint-planning
```

---

<h3 id="check-implementation-readiness">/check-implementation-readiness</h3>

Comprehensive gate check before Phase 4 implementation. Validates PRD, Architecture, and Epics/Stories are complete and aligned using an adversarial review approach.

**When to use:** Before starting implementation, after all planning artifacts are complete

**Output:** `docs/implementation-readiness-report-{date}.md`

**Prerequisites:** PRD, Architecture, Epics/Stories (if Level 2+)

#### Validation Steps

1. **Document Discovery** - Inventory all planning documents
2. **PRD Analysis** - Extract and validate all Functional Requirements
3. **Architecture Analysis** - Validate NFR coverage and component definitions
4. **Epic/Story Analysis** - Create traceability matrix (FRs → Stories)
5. **UX Alignment** - Cross-reference UI requirements (if applicable)
6. **Final Assessment** - Compile findings and determine readiness status

#### Example

```
User: /check-implementation-readiness

Claude: I'll perform an implementation readiness assessment.

## Document Discovery

**PRD:** ✓ accbmad/2-planning/prd-chat-app-2026-01-15.md
**Architecture:** ✓ accbmad/3-solutioning/architecture-chat-app-2026-01-20.md
**Epics/Stories:** ✓ 12 stories in accbmad/4-implementation/stories/

## PRD Analysis

**Total FRs:** 18
- Critical: 6
- High: 5
- Medium: 4
- Low: 3

**Issues Found:**
- FR-012: Missing acceptance criteria

## Architecture Analysis

**Components:** 7
**NFRs:** 8
**NFR Coverage:** 8/8 mapped to decisions

## Epic/Story Traceability

| FR ID | Epic | Stories | Coverage |
|-------|------|---------|----------|
| FR-001 | E1 | S-001, S-002 | ✓ Full |
| FR-002 | E2 | S-005, S-006 | ✓ Full |
| FR-012 | - | - | ❌ Missing |

**Issues:**
- 🔴 CRITICAL: FR-012 has no stories
- 🟠 HIGH: S-008 missing acceptance criteria

## Final Assessment

**Status:** NEEDS WORK

**Recommendations:**
1. Add acceptance criteria to FR-012
2. Create story for FR-012
3. Add acceptance criteria to S-008

Report saved: docs/implementation-readiness-report-2026-01-25.md
```

---

<h3 id="generate-project-context">/generate-project-context</h3>

Generate a `project-context.md` file containing critical rules and patterns that AI agents must follow when implementing code in the project.

**When to use:** Before starting AI-assisted implementation, when onboarding AI agents

**Output:** `docs/project-context.md`

#### Categories Covered

- **Technology Stack** - Exact versions and constraints
- **Language-Specific Rules** - Import conventions, error handling patterns
- **Framework-Specific Rules** - Component structure, state management
- **Testing Rules** - Test framework, coverage requirements
- **Code Quality & Style** - Formatting, linting, naming conventions
- **Critical Don't-Miss Rules** - Anti-patterns, edge cases, security rules

#### Example

```
User: /generate-project-context

Claude: I'll discover your project's context for AI agents.

## Discovery Summary

**Technology Stack:**
- Runtime: Node.js 20.x
- Framework: Next.js 14.1.0
- Database: PostgreSQL 15

**Patterns Found:**
- 8 naming conventions
- 12 coding patterns
- 5 critical rules

[C] Continue to rule generation

> c

## Technology Stack & Versions

| Technology | Version | Purpose |
|------------|---------|---------|
| Next.js | 14.1.0 | React framework |
| TypeScript | 5.3.0 | Type safety |
| PostgreSQL | 15 | Primary database |

Are these correct? [C] Continue

> c

## Language-Specific Rules

### TypeScript
- ✓ Strict mode enabled (tsconfig.json)
- Import paths: Use @/ aliases
- Error handling: Use Result type from neverthrow

[C] Continue

> c

...

## Project Context Generated

**File:** docs/project-context.md

AI agents should load this file at the start of implementation tasks.
```

---

## Phase 4 - Implementation Commands

<h3 id="sprint-planning">/sprint-planning</h3>

Break down the PRD into stories and plan sprint iterations.

**When to use:** After architecture is complete

**Output:** `accbmad/4-implementation/sprint.yaml`, `accbmad/4-implementation/stories/*.md`

**Prerequisites:** `accbmad/2-planning/prd.md`, `accbmad/3-solutioning/architecture.md`

#### Example

See the [Scrum Master skill documentation](../skills/#scrum-master) for a complete sprint planning example.

---

<h3 id="create-story">/create-story</h3>

Create a single user story with acceptance criteria and implementation notes.

**When to use:** Need to add a story outside of sprint planning

**Output:** `accbmad/4-implementation/stories/STORY-XXX.md`

#### Example

```
User: /create-story

Claude: I'll help create a new user story.

## Story Details

What epic does this belong to?
> Epic 2: Messaging

Story title:
> Message Reactions

As a (user type):
> team member

I want to:
> add emoji reactions to messages

So that:
> I can quickly acknowledge or respond without typing

## Acceptance Criteria

What conditions must be met?
> - Can add any emoji as reaction
> - Multiple users can add same reaction (shows count)
> - Can remove own reaction
> - Reactions show who added them on hover
> - Real-time updates when others react

## Technical Notes

Any implementation considerations?
> - Store reactions in separate collection
> - Index by messageId
> - Broadcast via WebSocket
> - Limit to 20 unique emojis per message

## Estimation

Story points (Fibonacci: 1,2,3,5,8,13):
> 5

Priority (Must/Should/Could):
> Should

## Story Created

```markdown
# STORY-029: Message Reactions

**Epic:** Messaging
**Points:** 5
**Priority:** Should
**Status:** Pending

## User Story
As a team member, I want to add emoji reactions to messages
so that I can quickly acknowledge or respond without typing.

## Acceptance Criteria
- [ ] Can add any emoji as reaction
- [ ] Multiple users can add same reaction (shows count)
- [ ] Can remove own reaction
- [ ] Reactions show who added them on hover
- [ ] Real-time updates when others react

## Technical Notes
- Store reactions in separate collection
- Index by messageId
- Broadcast via WebSocket
- Limit to 20 unique emojis per message

## Implementation
[To be filled during development]
```

Saved to: accbmad/4-implementation/stories/STORY-029.md
Updated: accbmad/4-implementation/sprint.yaml (added to backlog)
```

---

<h3 id="dev-story">/dev-story</h3>

Implement a user story end-to-end with code and tests.

**When to use:** Ready to implement a story

**Argument:** Story ID (e.g., `/dev-story STORY-004`)

**Output:** Code files, updated story status

#### Example

See the [Developer skill documentation](../skills/#developer) for a complete implementation example.

---

<h3 id="dev-story-auto">/dev-story-auto</h3>

Autonomous sprint execution - processes all pending stories automatically with integrated code review and git workflow.

**When to use:** You have multiple stories ready and want hands-off development

**Output:** Implemented stories with commits on develop branch

**Prerequisite:** `accbmad/4-implementation/sprint.yaml` with stories marked `pending` or `ready-for-dev`

#### How It Works

The workflow uses a script-driven loop that processes each story through 8 mandatory steps:

```
┌─────────────────────────────────────────────────────────────────┐
│  story-queue.sh next → Returns next pending story               │
├─────────────────────────────────────────────────────────────────┤
│  Step 1: git checkout -b story/{id}                             │
│  Step 2: Implement story (all acceptance criteria + tests)      │
│  Step 3: CODE REVIEW (mandatory, auto-fix)                      │
│  Step 4: git commit                                             │
│  Step 5: VERIFICATION REVIEW (post-commit safety check)         │
│  Step 6: git merge to develop                                   │
│  Step 7: Update sprint-status.yaml                              │
│  Step 8: story-queue.sh next → Loop or STOP                     │
└─────────────────────────────────────────────────────────────────┘
```

#### Options

| Option | Description | Example |
|--------|-------------|---------|
| (none) | All pending stories | `/dev-story-auto` |
| `--story ID` | Single specific story | `/dev-story-auto --story 2-3` |
| `--max N` | Maximum N stories | `/dev-story-auto --max 3` |
| `--dry-run` | Show plan only | `/dev-story-auto --dry-run` |

#### HALT Conditions

The workflow stops automatically when:
- No more pending stories (sprint complete)
- Code review fails 3 times on same issues
- Git merge conflict requiring manual resolution

#### Example Session

```
User: /dev-story-auto

Developer: Starting autonomous development...

╔══════════════════════════════════════════════════════════════╗
║  DEV-STORY-AUTO: Sprint 5 Progress                           ║
╠══════════════════════════════════════════════════════════════╣
║  Stories: 0/4 complete                                       ║
║  Current: VS-002-S18 (Screenshot Capture)                    ║
║  Phase:   Starting implementation                            ║
╠══════════════════════════════════════════════════════════════╣
║  → VS-002-S18  Screenshot Capture        [starting]          ║
║  ○ VS-002-S19  Multimodal Assessment     [queued]            ║
║  ○ VS-002-S20  Visual Threshold          [queued]            ║
║  ○ VS-002-S21  Quality Dashboard         [queued]            ║
╚══════════════════════════════════════════════════════════════╝

[Git] Created branch: story/VS-002-S18
[Dev] Implementing acceptance criteria...
[Dev] Writing tests...
[Dev] Tests passing: 15/15
[Review] Running adversarial code review...
[Review] Found 4 issues, applying fixes...
[Review] All issues resolved ✓
[Git] Committed: feat(capture): implement screenshot capture
[Review] Verification review... clean ✓
[Git] Merged to develop
[Status] Updated: VS-002-S18 → done

✓ Story VS-002-S18 complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━

Starting story VS-002-S19...
[...continues until all stories done...]

═══════════════════════════════════════
Sprint Auto Complete!

Stories completed: 4/4
Commits: 4
All merged to develop ✓
═══════════════════════════════════════
```

#### Script Commands

The `story-queue.sh` script manages the queue:

```bash
# Get next pending story
./scripts/story-queue.sh next

# Show code review checklist
./scripts/story-queue.sh review VS-002-S18

# Show queue status
./scripts/story-queue.sh status
```

---

<h3 id="create-epics-stories">/create-epics-stories</h3>

Transform PRD requirements into user-value-focused epics and detailed stories.

**When to use:** After PRD is complete, before sprint planning

**Output:** `docs/epics.md`

**Prerequisite:** `accbmad/2-planning/prd.md`

#### Key Principles

- **User-Value First:** Organize epics by user outcomes, not technical layers
- **Standalone Epics:** Each epic delivers value independently
- **No Future Dependencies:** Stories don't depend on future stories

#### Example

```
User: /create-epics-stories

Claude: Loading PRD... Found 12 functional requirements.

## Epic Design

✅ GOOD: Epic 1 "User Authentication" → Users can login
❌ BAD: Epic 1 "Database Setup" → No user value

Proposed Epic Structure:

| Epic | Title | FRs | User Value |
|------|-------|-----|------------|
| 1 | Authentication | FR-001, FR-002 | Secure access |
| 2 | Product Management | FR-003, FR-004, FR-005 | CRUD products |
| 3 | Sync Engine | FR-006, FR-007, FR-008 | Real-time sync |

Coverage: 12/12 FRs (100%)

[A] Approve and create stories
[R] Revise epics

User: A

Creating stories for Epic 1...

### Story 1.1: User Registration

As a new user,
I want to register with my email,
So that I can access the system.

**Acceptance Criteria:**
Given I am on the registration page
When I submit a valid email and password
Then my account is created
And I receive a confirmation email

[...continues for all stories...]

Saved: docs/epics.md
```

---

<h3 id="quick-dev">/quick-dev</h3>

Quick implementation workflow with built-in adversarial code review. Pairs with `/quick-spec`.

**When to use:** Implementing small features (1-5 story points)

**Input:** Optional path to tech-spec

**Output:** Code, tests, review findings

#### Workflow

1. **Mode Detection:** Tech-spec mode or direct mode
2. **Baseline Commit:** Creates reference for diff tracking
3. **Implementation:** Code + tests
4. **Self-Check:** Run tests, verify coverage
5. **Adversarial Review:** Find 3-10 issues minimum
6. **Fix Option:** Auto-fix or selective fix

#### Example

```
User: /quick-dev accbmad/2-planning/tech-spec-quick-export-csv.md

Claude: Loading spec...

## Implementation

1. Creating endpoint: src/routes/api/v1/orders.js ✓
2. Service method: src/services/orderService.js ✓
3. Tests: tests/unit/orderService.test.js ✓

## Self-Check

Running tests... ✓ 8/8 passed
Coverage: 87%

## Adversarial Review

| ID | Severity | Description |
|----|----------|-------------|
| M1 | MEDIUM | Missing date validation |
| M2 | MEDIUM | No index on created_at |
| L1 | LOW | Magic number "1000" for limit |

[F] Fix all
[S] Skip and finish
```

---

<h3 id="code-review">/code-review</h3>

Adversarial code review that actively searches for issues. Minimum 3-10 findings expected.

**When to use:** Before marking a story complete, before PR merge

**Input:** Optional path or story ID

**Mindset:** Zero findings = insufficient review

#### Review Categories

- **Git vs Claims:** Verify claimed changes match actual git diff
- **Code Quality:** Logic errors, error handling, style
- **Testing:** Coverage, real assertions, edge cases
- **Security:** Injection, secrets, validation
- **Performance:** N+1 queries, blocking calls, memory leaks

#### Example

```
User: /code-review STORY-015

Claude: Loading story and analyzing git diff...

## Git vs Claims Validation

| Claimed File | In Git Diff |
|--------------|-------------|
| src/services/sync.js | ✓ |
| src/models/product.js | ✓ |
| tests/sync.test.js | ✓ |

## Findings

| ID | Severity | Category | Description | Location |
|----|----------|----------|-------------|----------|
| C1 | CRITICAL | Security | SQL injection | sync.js:45 |
| H1 | HIGH | Logic | Race condition | sync.js:78-92 |
| H2 | HIGH | Testing | Placeholder test | sync.test.js:34 |
| M1 | MEDIUM | Error | Silent exception | product.js:112 |
| M2 | MEDIUM | Perf | N+1 query | sync.js:156 |
| L1 | LOW | Style | Unused import | product.js:3 |

Total: 6 issues (1 Critical, 2 High, 2 Medium, 1 Low)

## Verdict: ❌ BLOCKED

[A] Auto-fix Critical/High
[S] Selective fix
[D] Details per issue
```

---

<h3 id="qa-automate">/qa-automate</h3>

Auto-generate tests for existing code. Detects framework and generates appropriate tests.

**When to use:** Code lacks test coverage, adding tests to legacy code

**Input:** Path to file or directory

**Output:** Generated test files

#### Capabilities

- **Framework Detection:** Jest, Pytest, Go test, JUnit, etc.
- **Test Types:** Unit, integration, API, E2E
- **Coverage Analysis:** Before/after comparison
- **Smart Generation:** Understands code patterns

#### Example

```
User: /qa-automate src/services/

Claude: Analyzing services directory...

## Framework Detection

- Test Framework: Jest
- Assertion: expect
- Mocking: jest.mock
- Config: jest.config.js

## Coverage Analysis

| Service | Methods | Existing Tests | Coverage |
|---------|---------|----------------|----------|
| orderService | 8 | 5 | 62% |
| productService | 6 | 6 | 85% |
| syncService | 12 | 3 | 25% |

## Generating Tests

Priority: syncService (lowest coverage)

Creating: tests/unit/syncService.test.js

```javascript
describe('SyncService', () => {
  describe('syncInventory', () => {
    it('should sync inventory for single channel', async () => {
      const mockChannel = createMockChannel('shopify');
      const result = await syncService.syncInventory(mockChannel);
      expect(result.synced).toBe(1);
      expect(result.errors).toHaveLength(0);
    });

    it('should handle API failure gracefully', async () => {
      // ...
    });
  });
});
```

## Results

| Metric | Before | After |
|--------|--------|-------|
| Total Tests | 14 | 29 |
| Coverage | 57% | 82% |
| Services < 80% | 2 | 0 |

All generated tests passing ✓
```

---

## Builder Commands

<h3 id="create-agent">/create-agent</h3>

Create a custom BMAD agent for specialized domains.

**When to use:** Need capabilities not covered by default agents

**Output:** `~/.claude/skills/{agent}/SKILL.md`

#### Example

See the [Builder skill documentation](../skills/#builder) for a complete example.

---

<h3 id="create-workflow">/create-workflow</h3>

Create a custom workflow command.

**When to use:** Need a specialized workflow for your process

**Output:** `~/.claude/commands/accbmad/custom/{command}.md`

#### Example

```
User: /create-workflow

Claude: I'll help create a custom workflow command.

## Workflow Details

Command name (without /):
> security-review

What does this workflow do?
> Reviews code for security vulnerabilities and generates
> a security report

What inputs does it need?
> - Files or directories to review
> - Security checklist to use
> - Output format (markdown/JSON)

What outputs does it produce?
> docs/security-review.md with findings

What skills does it use?
> Custom security-reviewer agent (or Developer)

## Workflow Created

```markdown
# /security-review

## Description
Perform security review of code and generate findings report.

## Usage
/security-review [path] [--checklist=owasp|custom] [--format=md|json]

## Workflow

1. **Load configuration**
   - Per helpers.md#Combined-Config-Load

2. **Identify scope**
   - If path provided, review that path
   - Otherwise, review src/ directory

3. **Load checklist**
   - OWASP Top 10 (default)
   - Or custom checklist from docs/security-checklist.md

4. **Perform review**
   - Static analysis patterns
   - Dependency audit (npm audit)
   - Secret scanning
   - Input validation check

5. **Generate report**
   - Summary of findings
   - Severity levels (Critical/High/Medium/Low)
   - Remediation recommendations
   - Code references

6. **Save output**
   - Save to docs/security-review.md (or .json)
   - Update workflow status

## Example Output

# Security Review Report

**Date:** 2025-01-15
**Scope:** src/
**Checklist:** OWASP Top 10

## Summary
- Critical: 1
- High: 2
- Medium: 5
- Low: 8

## Critical Findings

### SQL-001: SQL Injection
**File:** src/models/user.js:45
**Risk:** Unsanitized user input in query
**Fix:** Use parameterized queries
```

Saved to: ~/.claude/commands/accbmad/custom/security-review.md

Restart Claude Code to load the new command.
```

---

## Creative Intelligence Commands

<h3 id="brainstorm">/brainstorm</h3>

Run a structured brainstorming session using multiple techniques.

**When to use:** Starting a project, stuck on a problem, exploring ideas

**Output:** `docs/brainstorm-{topic}.md`

#### Example

See the [Creative Intelligence skill documentation](../skills/#creative-intelligence) for a complete brainstorming example.

---

<h3 id="research">/research</h3>

Conduct comprehensive research on a topic.

**When to use:** Need market intelligence, competitive analysis, or technical research

**Output:** `docs/research-{topic}.md`

**Research types:**
- Market research
- Competitive analysis
- Technical research
- User research

#### Example

See the [Creative Intelligence skill documentation](../skills/#creative-intelligence) for a complete research example.

---

## Command Cheatsheet

### Start a New Project
```
/workflow-init
/product-brief      # Level 2+
/prd               # Level 2+
  OR
/tech-spec         # Level 0-1
/architecture      # Level 2+
/sprint-planning
/dev-story STORY-001
```

### Check Status
```
/workflow-status
```

### Research First
```
/brainstorm
/research
/product-brief
```

### Create Custom Tools
```
/create-agent
/create-workflow
```

---

## Next Steps

- See [real-world examples](../examples/) of complete workflows
- Learn about [configuration options](../configuration)
- Check [troubleshooting](../troubleshooting) for common issues
