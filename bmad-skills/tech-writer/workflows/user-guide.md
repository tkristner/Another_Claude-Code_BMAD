# [Tech Writer] User Guide Workflow

**Goal:** Create comprehensive user-facing documentation

**Phase:** Cross-phase (Documentation)

**Agent:** Tech Writer

**Trigger keywords:** user guide, tutorial, how-to, user documentation, getting started

**Inputs:** Product features, user workflows

**Output:** User guide documentation

**Duration:** 45-90 minutes

---

## When to Use

- Launching new product/feature
- Users struggling with adoption
- Support requests indicate confusion
- Onboarding new users

**Invoke:** `/user-guide`

---

## Pre-Flight

1. **Identify target audience** - Technical level, goals
2. **List key workflows** - What users need to accomplish
3. **Review existing docs** - Don't duplicate
4. **Gather examples** - Real use cases

---

## User Guide Structure

### 1. Getting Started

**Purpose:** Get users to first success quickly

**Content:**
- Prerequisites
- Installation/setup
- First task walkthrough
- Expected outcomes

### 2. Core Concepts

**Purpose:** Build understanding of the system

**Content:**
- Key terminology
- How things work (high-level)
- Important relationships

### 3. How-To Guides

**Purpose:** Task-oriented instructions

**Format:**
```markdown
## How to [Task Name]

**Goal:** What user will accomplish

**Prerequisites:** What's needed first

**Steps:**
1. Do this
2. Then this
3. Finally this

**Result:** What user should see

**Troubleshooting:** Common issues
```

### 4. Reference

**Purpose:** Detailed technical information

**Content:**
- Configuration options
- API reference
- CLI commands
- Error codes

### 5. Troubleshooting

**Purpose:** Help users solve problems

**Format:**
```markdown
### Problem: [Description]

**Symptoms:** What user sees

**Cause:** Why it happens

**Solution:** How to fix it
```

---

## Workflow Steps

### Step 1: Define User Journeys

Map primary user workflows:

| Journey | Goal | Key Steps |
|---------|------|-----------|
| New user | First success | Install → Configure → Use |
| Power user | Advanced features | Custom config → Automation |

### Step 2: Create Outline

Structure documentation:

```
docs/
├── getting-started.md
├── concepts/
│   ├── overview.md
│   └── architecture.md
├── how-to/
│   ├── task-1.md
│   └── task-2.md
├── reference/
│   └── configuration.md
└── troubleshooting.md
```

### Step 3: Write Content

For each section:
1. State the goal
2. Provide context
3. Give step-by-step instructions
4. Show expected results
5. Link to related content

### Step 4: Add Examples

- Real-world scenarios
- Code samples (tested!)
- Screenshots where helpful
- Before/after comparisons

---

## Writing Guidelines

**Be task-focused:**
- "How to export data" not "Export functionality"

**Use consistent format:**
- Same structure for all how-to guides
- Predictable navigation

**Include visuals:**
- Screenshots for UI tasks
- Diagrams for concepts
- Code blocks for commands

---

## Definition of Done

- [ ] Getting started guide complete
- [ ] Core workflows documented
- [ ] Examples tested and working
- [ ] Consistent formatting
- [ ] No undefined terms

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No user journeys defined | "Cannot write guide without understanding user workflows." | Define user journeys |
| No product/feature context | "Need product context to write meaningful documentation." | Provide context or run discovery |
| Missing examples | "User guide requires working examples." | Create/test examples |
