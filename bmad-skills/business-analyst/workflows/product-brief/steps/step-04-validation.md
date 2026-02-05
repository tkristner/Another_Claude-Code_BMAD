# Step 4: Review & Finalization

**Step:** 4 of 4
**Purpose:** Validate the complete brief and generate final document
**Duration:** 10-15 minutes
**Entry Criteria:** All previous steps complete

---

## Objectives

- [ ] Review all captured information
- [ ] Fill any gaps identified
- [ ] Generate final product brief document
- [ ] Get user approval

---

## Review Checklist

| Section | Status | Content |
|---------|--------|---------|
| Project Name | {{status}} | {{project_name}} |
| Problem Statement | {{status}} | {{problem_statement}} |
| User Segments | {{status}} | {{user_count}} defined |
| Primary Persona | {{status}} | {{persona_name}} |
| Value Proposition | {{status}} | {{value_proposition}} |
| In Scope | {{status}} | {{in_scope_count}} items |
| Out of Scope | {{status}} | {{out_of_scope_count}} items |
| Success Metrics | {{status}} | {{metrics_count}} KPIs |

**Quality Check:**
- [ ] Problem statement is specific, not vague
- [ ] User personas are realistic and detailed
- [ ] Value proposition is compelling
- [ ] Success metrics have targets

---

## Gap Resolution

If any section is incomplete, ask targeted questions to fill it.

**Common Gaps:** Metrics without targets, vague scope, generic value prop

---

## Document Generation

Generate brief using:
- Template: `templates/product-brief.template.md`
- State data: `accbmad/tmp/workflow-state.yaml`
- Output: `accbmad/1-analysis/product-brief-{{project_name_slug}}.md`

### Approval Prompt

```
Here's your complete Product Brief:

[Preview document]

How would you like to proceed?
[A] Approve and complete
[E] Edit specific section
[R] Regenerate
```

---

## Step Completion

### Exit Criteria

- [ ] All sections complete and validated
- [ ] Document generated and saved
- [ ] User approves final brief

### On Completion

1. Save document to `accbmad/1-analysis/`
2. Update `accbmad/status.yaml`
3. Clear workflow state
4. Show completion message with next steps

```
Product Brief Complete!
Document: accbmad/1-analysis/product-brief-{{project_name}}.md

Next Steps:
1. Share with stakeholders
2. Run /research for validation
3. Run /prd for requirements
```
