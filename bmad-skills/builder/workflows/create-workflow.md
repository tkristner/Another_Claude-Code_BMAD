# [Builder] Create Workflow

**Purpose:** Create custom workflow commands for existing skills following BMAD patterns.

**Goal:** Create a custom workflow command for an existing skill following BMAD patterns.

**Phase:** Extension (Meta)

**Agent:** Builder

**Trigger keywords:** create workflow, new workflow, custom workflow, add command, new command, extend skill

**Inputs:** Target skill, workflow purpose, inputs/outputs, steps

**Output:** Workflow file (.md) ready to use

**Duration:** 15-30 minutes

---

## When to Use This Workflow

Use this workflow when:
- Adding new capability to existing skill
- Creating domain-specific command
- Automating repetitive multi-step process
- Standardizing a workflow for team use

**Invoke:** `/create-workflow` or `/create-workflow {skill-name}/{workflow-name}`

---

## Pre-Flight

1. **Identify target skill** - Which skill will own this workflow
2. **Check existing workflows** - Avoid duplication
3. **Define purpose** - Clear goal for the workflow
4. **List inputs/outputs** - What goes in, what comes out

---

## Workflow Steps

### Step 1: Gather Requirements

**Objective:** Understand what the workflow needs to do.

1. **Identify Target Skill**

   Which skill will this workflow belong to?
   - Existing BMAD skill (developer, scrum-master, etc.)
   - Custom skill created with /create-agent

2. **Define Workflow Purpose**

   Answer:
   - What problem does this workflow solve?
   - When should a user invoke it?
   - What trigger keywords should activate it?

3. **Specify Inputs**

   What does the workflow need?
   - Required documents (PRD, architecture, etc.)
   - User input (parameters, selections)
   - Project context (config files)

4. **Define Outputs**

   What does the workflow produce?
   - Documents (reports, specs, plans)
   - Code artifacts
   - Status updates
   - Recommendations

5. **Estimate Duration**

   How long should this workflow take?
   - Quick (5-15 min)
   - Standard (15-45 min)
   - Complex (45-120 min)

6. **Present Summary**

   ```
   Workflow Requirements:

   Target Skill: {skill-name}
   Workflow Name: {workflow-name}
   Command: /{command-name}

   Purpose: {what it does}

   Trigger Keywords: {keywords}

   Inputs:
   - {input 1}
   - {input 2}

   Output: {what it produces}

   Duration: {estimated time}

   [A] Approve and create workflow
   [R] Revise requirements
   ```

---

### Step 2: Design Workflow Steps

**Objective:** Break workflow into clear, executable steps.

1. **Identify Major Phases**

   Typical workflow phases:
   - Pre-flight (validate prerequisites)
   - Input gathering (load/collect data)
   - Processing (main work)
   - Output generation (create deliverable)
   - Status update (track completion)

2. **Define Each Step**

   For each step:
   - Objective (what it achieves)
   - Actions (what to do)
   - Tools (Read, Write, Bash, etc.)
   - Validation (how to verify success)

3. **Map Dependencies**

   - Which steps must be sequential?
   - Which can be parallel?
   - What are the handoff points?

4. **Present Step Outline**

   ```
   Workflow Steps:

   1. Pre-Flight
      - Check prerequisites
      - Load project context

   2. {Step 2 Name}
      - {action 1}
      - {action 2}

   3. {Step 3 Name}
      - {action 1}
      - {action 2}

   4. Generate Output
      - Create {output type}
      - Save to {location}

   5. Status Update
      - Update tracking
      - Present completion

   [A] Approve steps
   [R] Revise steps
   ```

---

### Step 3: Write Workflow File

**Objective:** Create the workflow markdown file.

**Workflow File Structure:**

```markdown
# [Builder] {Workflow Name}

**Goal:** {clear goal statement}

**Phase:** {phase number or domain}

**Agent:** {skill name}

**Trigger keywords:** {comma-separated keywords}

**Inputs:** {required inputs}

**Output:** {what it produces}

**Duration:** {estimated time}

---

## When to Use This Workflow

Use this workflow when:
- {scenario 1}
- {scenario 2}
- {scenario 3}

**Invoke:** `/{command-name}` or `/{command-name} {args}`

---

## Pre-Flight

1. **Load project context** - Check for config files
2. **Verify prerequisites** - {prerequisites}
3. **Check dependencies** - {what must exist}

---

## Workflow Steps

### Step 1: {Step Name}

**Objective:** {what this step achieves}

1. **{Sub-step 1}**

   {detailed instructions}

2. **{Sub-step 2}**

   {detailed instructions}

3. **Validation**

   - [ ] {check 1}
   - [ ] {check 2}

---

### Step 2: {Step Name}

**Objective:** {what this step achieves}

{step content...}

---

### Step N: Generate Output

**Objective:** Create the workflow deliverable.

1. **Output Format**

   {describe output structure}

2. **Save Location**

   `{output path pattern}`

3. **Present Completion**

   ```
   Workflow Complete!

   Output: {path}
   Summary: {brief summary}

   Next Steps:
   [{option 1}]
   [{option 2}]
   ```

---

## Error Handling

**{Error Type 1}:**
- Symptom: {what happens}
- Resolution: {how to fix}

**{Error Type 2}:**
- Symptom: {what happens}
- Resolution: {how to fix}

---

## Notes for Claude

- {guidance 1}
- {guidance 2}
- Use TodoWrite to track workflow progress
- {tool-specific guidance}

**Quality Checks:**
- [ ] {check 1}
- [ ] {check 2}
```

---

### Step 4: Add Workflow to Skill

**Objective:** Register workflow with parent skill.

1. **Update SKILL.md**

   Add workflow reference:
   ```markdown
   ### {Workflow Name}

   **Trigger:** {when to invoke}

   **Steps:**
   1. {step 1}
   2. {step 2}
   3. {step 3}

   **Output:** {what it produces}

   See [workflows/{workflow-name}.md](workflows/{workflow-name}.md) for details.
   ```

2. **Add Trigger Keywords**

   Update skill description with new triggers:
   ```yaml
   description: ... {new trigger keywords}
   ```

3. **Update Available Commands**

   If skill has a commands section, add new workflow.

---

### Step 5: Create Supporting Files (if needed)

**Objective:** Create templates or scripts the workflow uses.

1. **Templates**

   If workflow generates documents:
   ```markdown
   # {Document Type}

   **Project:** {{project_name}}
   **Date:** {{date}}

   ## {Section 1}
   {{content}}

   ## {Section 2}
   {{content}}
   ```

   Save to: `templates/{template-name}.template.md`

2. **Scripts**

   If workflow needs automation:
   ```bash
   #!/bin/bash
   # {script description}
   ...
   ```

   Save to: `scripts/{script-name}.sh`
   Make executable: `chmod +x scripts/{script-name}.sh`

---

### Step 6: Validate Workflow

**Objective:** Ensure workflow works correctly.

1. **Structure Validation**

   ```
   [ ] Clear goal statement
   [ ] Trigger keywords defined
   [ ] Inputs and outputs specified
   [ ] Duration estimated
   [ ] Steps are sequential and clear
   [ ] Notes for Claude included
   [ ] Error handling documented
   ```

2. **Integration Validation**

   ```
   [ ] SKILL.md updated with reference
   [ ] Trigger keywords in skill description
   [ ] Templates exist (if referenced)
   [ ] Scripts executable (if referenced)
   ```

3. **Test Workflow**

   - Mentally walk through steps
   - Check tool usage makes sense
   - Verify outputs match requirements

---

### Step 7: Present Completion

**Objective:** Summarize created workflow.

```
Workflow Created Successfully!

Workflow: {workflow-name}
Command: /{command-name}
Skill: {skill-name}

Location: bmad-skills/{skill-name}/workflows/{workflow-name}.md

Files Created/Updated:
- workflows/{workflow-name}.md (new)
- SKILL.md (updated with reference)
- templates/{template}.md (if created)

Trigger Keywords: {keywords}

To use this workflow:
  /{command-name}

Next Steps:
[T] Test with sample project
[D] Document in REFERENCE.md
[A] Add related workflows
```

---

## Workflow Patterns

### Common Workflow Types

**Analysis Workflow:**
- Reads inputs
- Analyzes content
- Produces report/findings
- Example: `/security-audit`, `/code-quality`

**Generation Workflow:**
- Gathers requirements
- Generates artifact
- Validates output
- Example: `/create-test-plan`, `/create-deployment`

**Validation Workflow:**
- Loads artifact
- Runs checks
- Reports pass/fail
- Example: `/validate-prd`, `/check-coverage`

**Transformation Workflow:**
- Takes input A
- Transforms to output B
- Validates result
- Example: `/prd-to-stories`, `/spec-to-tests`

### Level-Specific Patterns

**Level 0-1 (Simple):**
- 3-5 steps
- Single output
- Minimal validation

**Level 2 (Standard):**
- 5-8 steps
- Structured output
- Quality validation

**Level 3-4 (Complex):**
- 8+ steps
- Multiple outputs
- Subagent support
- Comprehensive validation

---

## Notes for Claude

**Tool Usage:**
- Use Write to create workflow file
- Use Edit to update SKILL.md
- Use Read to check existing patterns
- Use TodoWrite to track creation tasks

**Key Principles:**
- Match existing workflow format
- Clear trigger keywords
- Actionable steps
- Good error handling
- Notes for LLM execution

**Quality Checklist:**
- [ ] Purpose clearly stated
- [ ] Steps are executable
- [ ] Outputs defined
- [ ] SKILL.md updated
- [ ] Triggers registered
- [ ] Templates created (if needed)

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No parent skill | "Cannot create workflow without parent skill." | Create or specify parent skill |
| Duplicate workflow name | "Workflow '{name}' already exists in this skill." | Choose different name |
| No clear purpose | "Workflow must have defined goal and outputs." | Define workflow purpose |
| Missing SKILL.md | "Parent skill SKILL.md not found." | Create parent skill first |
