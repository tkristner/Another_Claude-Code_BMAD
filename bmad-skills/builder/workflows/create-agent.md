# [Builder] Create Agent Workflow

**Purpose:** Create custom agent skills for specific domains following BMAD patterns and Anthropic skill specification.

**Goal:** Create a custom agent skill following BMAD patterns and Anthropic Claude Code skill specification.

**Phase:** Extension (Meta)

**Agent:** Builder

**Trigger keywords:** create agent, new skill, custom skill, create skill, scaffold agent, new agent

**Inputs:** Domain description, responsibilities, workflows needed

**Output:** Complete skill directory with SKILL.md, templates, scripts, resources

**Duration:** 30-60 minutes depending on complexity

---

## When to Use This Workflow

Use this workflow when:
- Need a domain-specific agent (QA Engineer, DevOps, Security, etc.)
- Want to create reusable skill for specific work type
- Extending BMAD with custom capabilities
- Creating standardized agent for team use

**Invoke:** `/create-agent` or `/create-agent {domain-name}`

---

## Pre-Flight

1. **Verify builder tools** - Ensure scripts are executable
2. **Check existing skills** - Avoid duplicating functionality
3. **Identify domain** - Clear understanding of agent's purpose
4. **Gather requirements** - Responsibilities, workflows, tools needed

---

## Workflow Steps

### Step 1: Gather Requirements

**Objective:** Understand what the agent needs to do.

1. **Identify Domain**

   Ask user to specify:
   - What domain/specialty? (QA, DevOps, Security, Data, etc.)
   - What problems does this agent solve?
   - What deliverables does it produce?

2. **Define Responsibilities**

   Identify 4-8 core responsibilities:
   ```
   Example for QA Engineer:
   - Create and execute test plans
   - Write automated tests
   - Perform exploratory testing
   - Report defects and track issues
   - Validate acceptance criteria
   - Measure test coverage
   ```

3. **Identify Workflows**

   Define 2-4 key workflows:
   ```
   Example for QA Engineer:
   - /create-test-plan - Generate test plan from requirements
   - /execute-tests - Run test suite and report results
   - /exploratory-testing - Guided exploratory testing session
   ```

4. **Determine Tools**

   Select allowed tools:
   ```
   Standard: Read, Write, Edit, Bash, Glob, Grep, TodoWrite
   Additional: WebSearch (for research), Task (for subagents)
   ```

5. **Present Requirements Summary**

   ```
   Agent Requirements Summary:

   Domain: {domain}
   Name: {skill-name}

   Responsibilities:
   1. {responsibility 1}
   2. {responsibility 2}
   ...

   Workflows:
   - /{workflow-1} - {description}
   - /{workflow-2} - {description}

   Tools: {tool list}

   [A] Approve and create skill
   [R] Revise requirements
   ```

---

### Step 2: Scaffold Skill Directory

**Objective:** Create the skill directory structure.

1. **Run Scaffold Script**

   ```bash
   ./bmad-skills/builder/scripts/scaffold-skill.sh {skill-name}
   ```

   Creates:
   ```
   bmad-skills/{skill-name}/
   ├── SKILL.md           # To be created
   ├── REFERENCE.md       # Optional reference material
   ├── scripts/           # Utility scripts
   ├── templates/         # Document templates
   ├── workflows/         # Workflow files
   └── resources/         # Reference materials
   ```

2. **Verify Structure**

   ```bash
   ls -la bmad-skills/{skill-name}/
   ```

---

### Step 3: Create SKILL.md

**Objective:** Write the main skill definition file.

**SKILL.md Structure:**

```markdown
---
name: {skill-name}
description: {description with trigger keywords}
allowed-tools: {tool list}
---

# [Builder] {Skill Display Name}

**Role:** {domain} specialist

**Function:** {what this skill does}

## Responsibilities

- {responsibility 1}
- {responsibility 2}
- {responsibility 3}
- {responsibility 4}

## Core Principles

1. **{Principle 1}** - {description}
2. **{Principle 2}** - {description}
3. **{Principle 3}** - {description}
4. **{Principle 4}** - {description}

## When to Use This Skill

Activate this skill when you need to:
- {use case 1}
- {use case 2}
- {use case 3}

## Key Workflows

### {Workflow 1}

**Trigger:** {when to invoke}

**Steps:**
1. {step 1}
2. {step 2}
3. {step 3}

**Output:** {what it produces}

See [workflows/{workflow-1}.md](workflows/{workflow-1}.md) for details.

### {Workflow 2}

**Trigger:** {when to invoke}

**Steps:**
1. {step 1}
2. {step 2}
3. {step 3}

**Output:** {what it produces}

See [workflows/{workflow-2}.md](workflows/{workflow-2}.md) for details.

## Available Scripts

- **{script-1}.sh** - {description}
- **{script-2}.sh** - {description}

## Templates

- **{template-1}.template.md** - {description}
- **{template-2}.template.md** - {description}

## Integration Points

**Works After:**
- {skill that provides input}

**Works Before:**
- {skill that consumes output}

## Notes for Claude

- {important guidance 1}
- {important guidance 2}
- {important guidance 3}
- Use TodoWrite to track workflow tasks

## Example Interaction

```
User: {typical user request}

{Skill Name}:
{typical response and workflow execution}
```
```

**Token Optimization:**
- Keep SKILL.md under 5K tokens
- Reference REFERENCE.md for details
- Use progressive disclosure

---

### Step 4: Create Workflows

**Objective:** Create workflow files for each command.

**For Each Workflow:**

1. **Create Workflow File**

   `workflows/{workflow-name}.md`:

   ```markdown
   # {Workflow Name}

   **Goal:** {what this workflow achieves}

   **Phase:** {phase or domain}

   **Agent:** {skill name}

   **Trigger keywords:** {keywords}

   **Inputs:** {required inputs}

   **Output:** {what it produces}

   **Duration:** {estimated time}

   ---

   ## When to Use

   Use this workflow when:
   - {scenario 1}
   - {scenario 2}

   **Invoke:** /{command-name}

   ---

   ## Workflow Steps

   ### Step 1: {Step Name}

   **Objective:** {what this step does}

   1. {action 1}
   2. {action 2}
   3. {action 3}

   ### Step 2: {Step Name}

   ...

   ---

   ## Notes for Claude

   - {guidance 1}
   - {guidance 2}
   ```

2. **Validate Workflow Structure**

   - Clear goal and trigger
   - Step-by-step process
   - Output defined
   - Notes for LLM execution

---

### Step 5: Create Templates

**Objective:** Create document templates for skill outputs.

**For Each Template:**

1. **Define Template Structure**

   ```markdown
   # {Document Title}

   **Project:** {{project_name}}
   **Date:** {{date}}
   **Author:** {{author}}

   ## Section 1: {Section Name}

   {{section_1_content}}

   ## Section 2: {Section Name}

   {{section_2_content}}

   ...
   ```

2. **Document Variables**

   | Variable | Description | Source |
   |----------|-------------|--------|
   | `{{project_name}}` | Project name | config |
   | `{{date}}` | Current date | auto |
   | ... | ... | ... |

3. **Save Template**

   `templates/{template-name}.template.md`

---

### Step 6: Create Scripts (Optional)

**Objective:** Create utility scripts for the skill.

**Common Script Types:**

1. **Validation Script**

   ```bash
   #!/bin/bash
   # validate-{domain}.sh
   # Validates {domain} artifacts

   FILE=$1
   if [ -z "$FILE" ]; then
       echo "Usage: validate-{domain}.sh <file>"
       exit 1
   fi

   # Validation logic
   ...
   ```

2. **Generation Script**

   ```bash
   #!/bin/bash
   # generate-{artifact}.sh
   # Generates {artifact} from inputs

   # Generation logic
   ...
   ```

3. **Make Executable**

   ```bash
   chmod +x scripts/*.sh
   ```

---

### Step 7: Create Resources (Optional)

**Objective:** Add reference materials for the skill.

**Common Resources:**

1. **Patterns/Guidelines**

   `resources/{domain}-patterns.md`:
   - Best practices
   - Common patterns
   - Anti-patterns to avoid

2. **Checklists**

   `resources/{domain}-checklist.md`:
   - Quality checklist
   - Review checklist

3. **Examples**

   `resources/{domain}-examples.md`:
   - Example outputs
   - Sample workflows

---

### Step 8: Validate Skill

**Objective:** Ensure skill meets quality standards.

1. **Run Validation Script**

   ```bash
   ./bmad-skills/builder/scripts/validate-skill.sh bmad-skills/{skill-name}/SKILL.md
   ```

2. **Validation Checklist**

   ```
   YAML Frontmatter:
   [ ] name field present and valid (lowercase, hyphens)
   [ ] description field present with trigger keywords
   [ ] allowed-tools field specified

   Content:
   [ ] SKILL.md under 5K tokens
   [ ] Role and function clearly defined
   [ ] Responsibilities listed (4-8 items)
   [ ] Core principles defined (4-5 items)
   [ ] Workflows documented
   [ ] Notes for LLMs section present

   Files:
   [ ] All referenced files exist
   [ ] Scripts are executable
   [ ] Templates have {{placeholders}}
   [ ] No hardcoded paths

   Integration:
   [ ] Integration points documented
   [ ] Example interaction included
   ```

3. **Fix Issues**

   If validation fails, fix issues before proceeding.

---

### Step 9: Test Skill

**Objective:** Verify skill works as expected.

1. **Manual Testing**

   - Load skill and test trigger keywords
   - Execute each workflow
   - Verify outputs are correct

2. **Integration Testing**

   - Test with other BMAD skills
   - Verify handoffs work correctly

---

### Step 10: Present Completion

**Objective:** Summarize created skill.

```
Skill Created Successfully!

Skill: {skill-name}
Location: bmad-skills/{skill-name}/

Files Created:
- SKILL.md (main skill definition)
- REFERENCE.md (detailed reference)
- workflows/{workflow-1}.md
- workflows/{workflow-2}.md
- templates/{template-1}.template.md
- scripts/{script-1}.sh
- resources/{resource-1}.md

Validation: PASSED

To use this skill:
1. Trigger with: "{trigger keywords}"
2. Available commands:
   - /{workflow-1} - {description}
   - /{workflow-2} - {description}

Next Steps:
[T] Test the skill with a sample project
[D] Create documentation
[E] Extend with additional workflows
```

---

## Subagent Strategy

For complex skills with many components:

**Pattern:** Parallel Component Creation
**Agents:** 4 parallel agents

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Create SKILL.md | `{skill}/SKILL.md` |
| Agent 2 | Create workflows | `{skill}/workflows/*.md` |
| Agent 3 | Create templates | `{skill}/templates/*.md` |
| Agent 4 | Create scripts/resources | `{skill}/scripts/`, `{skill}/resources/` |

**Coordination:**
1. Gather requirements (main context)
2. Write spec to `accbmad/context/skill-spec.md`
3. Launch parallel agents
4. Validate all outputs
5. Assemble complete skill

---

## Notes for Claude

**Tool Usage:**
- Use Bash to run scaffold-skill.sh and validate-skill.sh
- Use Write to create SKILL.md and other files
- Use Read to check existing skills
- Use TodoWrite to track creation tasks

**Key Principles:**
- Follow Anthropic skill specification strictly
- Keep SKILL.md under 5K tokens
- Include trigger keywords in description
- Document all integration points
- Test before delivering

**Quality Checklist:**
- [ ] YAML frontmatter valid
- [ ] Trigger keywords included
- [ ] Under 5K tokens
- [ ] All workflows documented
- [ ] Scripts executable
- [ ] Templates use {{placeholders}}
- [ ] Example interaction included

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No domain specified | "Cannot create agent without defining domain/purpose." | Specify agent domain |
| Duplicate skill name | "Skill with name '{name}' already exists." | Choose different name |
| Invalid YAML frontmatter | "YAML frontmatter validation failed." | Fix YAML syntax |
| SKILL.md exceeds 5K tokens | "SKILL.md too large. Move details to REFERENCE.md." | Refactor to reduce size |
| Missing required workflows | "Agent needs at least one workflow defined." | Create at least one workflow |
