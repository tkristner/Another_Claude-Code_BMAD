# [Business Analyst] Product Brief Workflow

**Goal:** Create a comprehensive product brief through guided discovery

**Phase:** 1 - Analysis

**Agent:** Business Analyst

**Trigger keywords:** product brief, create brief, new product, project brief, product definition, problem brief, opportunity brief

**Inputs:** User's product idea or problem statement

**Output:** Complete product brief document at `accbmad/1-analysis/product-brief-{{project_name}}-{{date}}.md`

**Duration:** 45-90 minutes

---

## Step-Based Execution

This workflow uses step files for modular execution. Each step loads just-in-time to preserve context window.

### Steps Overview

| Step | File | Purpose | Duration |
|------|------|---------|----------|
| 1 | [step-01-discovery.md](product-brief/steps/step-01-discovery.md) | Problem & opportunity | 15-20 min |
| 2 | [step-02-users.md](product-brief/steps/step-02-users.md) | User segments | 10-15 min |
| 3 | [step-03-value.md](product-brief/steps/step-03-value.md) | Value proposition | 10-15 min |
| 4 | [step-04-validation.md](product-brief/steps/step-04-validation.md) | Review & finalize | 10-15 min |

---

## State Tracking

Progress is tracked in: `accbmad/workflow-state.yaml`

```yaml
workflow: product-brief
started: {{timestamp}}
current_step: 1
completed_steps: []
data:
  project_name: ""
  problem_statement: ""
  opportunity_description: ""
  user_segments: []
  primary_persona: {}
  value_proposition: ""
  in_scope: []
  out_of_scope: []
  success_metrics: []
```

---

## Pre-Flight

1. **Check for existing state file**
   - If `accbmad/workflow-state.yaml` exists with `workflow: product-brief`
   - Offer to resume or restart

2. **Load project configuration**
   - Check for `accbmad/config.yaml`
   - Note project level for recommendations

3. **Check workflow status**
   - Read `accbmad/status.yaml`
   - Warn if product brief already exists

---

## Execution Flow

### Starting the Workflow

1. Check for existing state file
2. If resuming: Load state, continue from `current_step`
3. If new: Initialize state, start at Step 1
4. Load step file for current step
5. Execute step instructions
6. On step completion: Update state, advance to next step
7. Repeat until all steps complete

### Step Completion Criteria

Each step defines its own completion criteria. General pattern:
- User confirms output
- Required data captured in state
- No blocking questions remain

### Resuming a Workflow

```
User: /product-brief

BA: I found an in-progress product brief. Current status:
- Step 1 (Discovery): Complete
- Step 2 (Users): Complete
- Step 3 (Value): In Progress
- Step 4 (Validation): Pending

Would you like to:
[C] Continue from Step 3
[R] Restart from beginning
[V] View completed data
```

---

## State Management

### Initializing State

When starting fresh:

```yaml
# [Business Analyst] accbmad/workflow-state.yaml
workflow: product-brief
started: "2026-02-04T10:00:00Z"
current_step: 1
completed_steps: []
data: {}
```

### Updating State

After each step completion:

```yaml
current_step: 2
completed_steps: [1]
data:
  project_name: "MyApp"
  problem_statement: "Users struggle to..."
  # ... accumulated data
```

### Clearing State

On workflow completion:
- Archive to `bmad/completed/product-brief-{{timestamp}}.yaml`
- Or delete `accbmad/workflow-state.yaml`

---

## Integration

**Related Workflows:**
- After product-brief: `/prd` (Phase 2 - Level 2+) or `/tech-spec` (Level 0-1)
- For research: `/research` (Creative Intelligence)
- For brainstorming: `/brainstorm` (Creative Intelligence)

**State Dependencies:**
- Creates: Product Brief document
- Updates: `accbmad/workflow-state.yaml`, `accbmad/status.yaml`
- Enables: PRD workflow

---

## Output

Final deliverable: `accbmad/1-analysis/product-brief-{{project_name}}-{{date}}.md`

Uses template: [product-brief.template.md](../templates/product-brief.template.md)

---

## Definition of Done

A product brief is complete when all criteria below are satisfied:

### Mandatory Sections (100% Required)

| Section | Minimum Requirement | Check |
|---------|---------------------|-------|
| Problem Statement | >=3 sentences explaining the problem | [ ] |
| Target Users | >=1 persona with characteristics | [ ] |
| Value Proposition | Clear statement of unique value | [ ] |
| Success Metrics | >=3 measurable KPIs with targets | [ ] |
| Scope Boundaries | Both in-scope AND out-of-scope lists | [ ] |
| Key Features | >=3 core capabilities identified | [ ] |

### Quality Checks

- [ ] Problem validated with at least 1 data point
- [ ] No undefined terms or unexplained acronyms
- [ ] Stakeholders identified and listed
- [ ] No sections marked "TBD" or left empty
- [ ] All success metrics are SMART

### Exit Criteria

Product brief is ready for next phase when:
1. All mandatory sections complete with substantive content
2. Stakeholder has reviewed (or explicitly waived review)
3. No open questions blocking progress
4. Project level determined (0-4)

---

## Notes for Claude

**Step Loading:**
- Load only the current step file, not all steps
- Each step has its own entry/exit criteria
- Update state after each step completion

**State Management:**
- Always check for existing state before starting
- Offer resume option if in-progress workflow found
- Save state incrementally (not just at end)

**Best Practices:**
- One question at a time - don't overwhelm
- Listen actively - probe for specifics
- Use frameworks - SMART goals, 5 Whys
- Confirm understanding - summarize back

**Tool Usage:**
- Use Read to load step files
- Use Write to update state file
- Use Write to generate final document

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No stakeholder identified | "Cannot proceed without at least one stakeholder." | Identify key stakeholders |
| Problem statement unclear | "Problem statement is too vague to continue." | Clarify with user |
| No success metrics | "Cannot complete brief without measurable success criteria." | Define SMART metrics |
| Conflicting requirements | "Detected conflicting requirements that need resolution." | Resolve conflicts with stakeholder |
| Scope undefined | "Both in-scope and out-of-scope must be defined." | Define scope boundaries |
