# BMAD Template Style Guide

**Version:** 1.0
**Last Updated:** 2026-02-04
**Author:** BMAD Team

---

## Purpose

This guide ensures consistency across all BMAD templates. Follow these standards when creating or modifying templates.

**Why consistency matters:**
- Templates are filled by AI agents and humans
- Inconsistent syntax causes parsing errors
- Clear patterns reduce cognitive load
- Standardization enables automated validation

---

## 1. Variable Syntax

### Standard Format

Use double curly braces with lowercase and underscores:

```
{{variable_name}}
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Simple values | lowercase_underscore | `{{project_name}}` |
| Dates | descriptive | `{{creation_date}}`, `{{last_updated}}` |
| Lists | plural | `{{requirements}}`, `{{stories}}` |
| Booleans | is_/has_ prefix | `{{is_complete}}`, `{{has_dependencies}}` |
| IDs | suffix with _id | `{{story_id}}`, `{{epic_id}}` |
| Counts | suffix with _count | `{{story_count}}`, `{{point_total}}` |

### DO NOT USE

| Format | Problem | Correct |
|--------|---------|---------|
| `[Variable]` | Square brackets are markdown links | `{{variable}}` |
| `{{VARIABLE}}` | All caps is inconsistent | `{{variable}}` |
| `{{variableName}}` | camelCase not standard | `{{variable_name}}` |
| `{variable}` | Single braces ambiguous | `{{variable}}` |
| `<variable>` | Angle brackets are HTML | `{{variable}}` |
| `{{{{variable}}}}` | Double braces are errors | `{{variable}}` |

### Variable Documentation

Always document complex variables inline:

```markdown
**Priority:** {{priority}}
<!-- Values: must_have | should_have | could_have | wont_have -->

**Status:** {{status}}
<!-- Values: not_started | in_progress | completed | blocked -->

**Confidence Level:** {{confidence_level}}
<!-- Values: high | medium | low | insufficient -->
```

---

## 2. Required Metadata Header

Every template MUST start with a standardized header.

### Minimum Required Fields

```markdown
# {{document_title}}

**Version:** {{version}}
**Date:** {{date}}
**Author:** {{author}}
**Status:** {{status}}
```

### Recommended Additional Fields

```markdown
**Last Updated:** {{last_updated}}
**Reviewers:** {{reviewers}}
**Project:** {{project_name}}
**Project Level:** {{project_level}}
```

### Field Descriptions

| Field | Purpose | Example Values |
|-------|---------|----------------|
| Version | Document iteration | `1.0`, `1.1`, `2.0` |
| Date | Creation date | `2026-02-04` |
| Author | Creator | `Product Manager`, `System Architect` |
| Status | Document state | `draft`, `review`, `approved`, `superseded` |
| Last Updated | Most recent edit | `2026-02-04` |

---

## 3. Version Tracking

### Version Field Format

Always include version in header:

```markdown
**Version:** {{version}}
```

### Semantic Versioning

Use semantic-style versioning for documents:

| Version | When to Use |
|---------|-------------|
| `1.0` | Initial version |
| `1.1` | Minor updates (typos, clarifications) |
| `1.2` | Small additions (new subsection) |
| `2.0` | Major changes (structure, new sections) |

### Revision History Section

Include before the final section of every template:

```markdown
---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | {{date}} | {{author}} | Initial version |
| {{version}} | {{last_updated}} | {{author}} | {{change_description}} |
```

**Placement:** Second-to-last section (before Related Documents or Appendix).

---

## 4. Section Structure

### Heading Hierarchy

```markdown
# Document Title (H1 - only ONE per document)

## Major Section (H2)

### Subsection (H3)

#### Minor Subsection (H4 - use sparingly)
```

**Rules:**
- Only one H1 per document (the title)
- H2 for main sections
- H3 for subsections within H2
- H4 only when truly necessary (prefer restructuring)

### Standard Section Order

1. **Title and Metadata Header**
2. **Executive Summary / Overview** (optional for small templates)
3. **Main Content Sections** (varies by template type)
4. **Revision History**
5. **Related Documents / References**

### Optional Sections

- Appendices (for large supporting data)
- Glossary (for domain-specific terms)
- Approval / Sign-off (for formal documents)

---

## 5. Placeholder Instructions

### Simple Placeholders

For self-explanatory fields, the variable name is sufficient:

```markdown
**Project Name:** {{project_name}}
**Date:** {{date}}
```

### Complex Placeholders

Add inline guidance using HTML comments:

```markdown
**Success Metrics:** {{success_metrics}}
<!-- List 3-5 measurable KPIs with targets. Example:
- User registration: 1000 users in first month
- Page load time: <2 seconds
- Error rate: <0.1%
-->
```

### Enumerated Values

Document allowed values inline:

```markdown
**Priority:** {{priority}}
<!-- Values: must_have | should_have | could_have | wont_have -->

**Story Points:** {{story_points}}
<!-- Fibonacci scale: 1, 2, 3, 5, 8. Stories >8 should be split -->
```

### Conditional Sections

Mark optional sections clearly:

```markdown
## Security Considerations
<!-- Include this section for Level 2+ projects or if handling sensitive data -->

{{security_considerations}}
```

### Multi-line Placeholders

For long-form content:

```markdown
## Executive Summary

{{executive_summary}}
<!-- 2-3 paragraphs covering:
1. What problem this solves
2. Who benefits and how
3. Key features and approach
-->
```

---

## 6. Cross-References

### Internal References (Same Project)

Reference other project documents using relative paths:

```markdown
See [Product Brief](accbmad/1-analysis/product-brief-{{project_name}}.md)
Reference: `accbmad/2-planning/prd-{{project_name}}.md`
```

### External References (BMAD Resources)

Reference BMAD shared resources:

```markdown
See [Workflow Selection Guide](shared/resources/workflow-selection-guide.md)
Template: `templates/adr.template.md`
```

### Related Documents Section

Include at the end of templates that reference other documents:

```markdown
---

## Related Documents

| Document | Path | Relationship |
|----------|------|--------------|
| Product Brief | `accbmad/1-analysis/product-brief.md` | Input |
| Architecture | `accbmad/3-solutioning/architecture.md` | Output feeds into |
| Sprint Plan | `docs/sprint-plan.md` | Uses this document |
```

### Link Validation

- Use relative paths from the document location
- Test links render correctly in markdown preview
- Update links when moving documents

---

## 7. Tables

### Standard Table Format

```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| {{value}} | {{value}} | {{value}} |
```

### Table Guidelines

| Guideline | Recommendation |
|-----------|----------------|
| Width | Keep under 100 characters total |
| Columns | Maximum 7 columns |
| Nesting | Never nest tables |
| Alignment | Left-align text, right-align numbers |

### Expandable Tables

For tables with variable rows:

```markdown
| Story ID | Title | Points |
|----------|-------|--------|
| {{story_id}} | {{title}} | {{points}} |
<!-- Add additional rows as needed -->
```

---

## 8. Lists and Repetitive Content

### For Repetitive Items

**DO use tables:**

```markdown
| Story ID | Title | Points |
|----------|-------|--------|
| {{story_id}} | {{title}} | {{points}} |
<!-- Repeat for each story -->
```

**DON'T use Handlebars iteration:**

```markdown
{{#each stories}}
- {{story_id}}: {{title}}
{{/each}}
```

**Why:** BMAD templates are filled manually or by AI, not rendered by a templating engine.

### Checklist Format

```markdown
- [ ] {{checklist_item}}
- [ ] {{checklist_item}}
```

### Numbered Lists

```markdown
1. {{step_1}}
2. {{step_2}}
3. {{step_3}}
```

---

## 9. YAML Templates

### Document Markers

Always start YAML templates with the document marker:

```yaml
---
version: "6.0.0"
project_name: "{{project_name}}"
```

### String Quoting Rules

| Content Type | Quote? | Example |
|--------------|--------|---------|
| Variables (may contain special chars) | Yes | `"{{project_name}}"` |
| Numbers | No | `project_level: {{project_level}}` |
| Booleans | No | `is_complete: {{is_complete}}` |
| Dates | Yes | `"{{date}}"` |
| Enums | Yes | `"{{status}}"` |

### YAML Example

```yaml
---
version: "6.0.0"
project_name: "{{project_name}}"
project_level: {{project_level}}
current_sprint: {{current_sprint}}

sprints:
  - sprint_number: {{sprint_number}}
    name: "{{sprint_name}}"
    start_date: "{{start_date}}"
    end_date: "{{end_date}}"
    status: "{{status}}"
```

---

## 10. Template Checklist

Before submitting a new template, verify all items:

### Required Elements

- [ ] Uses `{{variable_name}}` syntax consistently (lowercase with underscores)
- [ ] Has metadata header (Version, Date, Author, Status)
- [ ] Has revision history section
- [ ] Has related documents section (if references other docs)
- [ ] Only one H1 heading (document title)

### Quality Checks

- [ ] All variables documented (inline comments or appendix)
- [ ] Complex placeholders have guidance comments
- [ ] Conditional sections clearly marked
- [ ] No Handlebars syntax (`{{#each}}`, `{{#if}}`)
- [ ] Tables used for repetitive structures (not lists)
- [ ] YAML templates have `---` document marker

### Testing

- [ ] Template can be filled out manually
- [ ] All sections have clear purpose
- [ ] Cross-references are valid relative paths
- [ ] Renders correctly in Markdown preview
- [ ] No broken table formatting

---

## Examples

### Good Template Header

```markdown
# Product Requirements Document

**Version:** 1.0
**Date:** {{date}}
**Author:** {{author}}
**Status:** {{status}}
**Project:** {{project_name}}

---

## Executive Summary

{{executive_summary}}
<!-- 2-3 paragraphs summarizing the product vision, target users, and key features -->
```

### Good Variable Documentation

```markdown
## Story Details

**Story ID:** {{story_id}}
<!-- Format: STORY-XXX where XXX is a 3-digit number -->

**Priority:** {{priority}}
<!-- Values: must_have | should_have | could_have -->

**Story Points:** {{story_points}}
<!-- Fibonacci scale: 1, 2, 3, 5, 8. Stories >8 should be split -->

**Status:** {{status}}
<!-- Values: not_started | in_progress | completed | blocked -->
```

### Good Conditional Section

```markdown
## Security Considerations
<!-- Required for Level 2+ projects. Delete this section for Level 0-1 -->

### Authentication
{{authentication_approach}}

### Authorization
{{authorization_approach}}

### Data Protection
{{data_protection_measures}}
```

---

## Reference Templates

These templates exemplify best practices:

| Template | Location | Best Practice Shown |
|----------|----------|---------------------|
| User Story | `scrum-master/templates/user-story.template.md` | Variable documentation, checklists |
| PRD | `product-manager/templates/prd.template.md` | Comprehensive metadata, versioning |
| Architecture | `system-architect/templates/architecture.template.md` | Cross-references, section structure |
| Sprint Status | `scrum-master/templates/sprint-status.template.yaml` | YAML formatting, quoting |

---

## Migration Guide

If updating existing templates to follow this guide:

1. **Variable Syntax**
   - Replace `{{VARIABLE}}` with `{{variable_name}}`
   - Replace `{{variableName}}` with `{{variable_name}}`
   - Replace `{{{{variable}}}}` with `{{variable}}`

2. **Metadata Header**
   - Add Version, Date, Author, Status fields
   - Ensure only one H1 heading

3. **Revision History**
   - Add section before Related Documents
   - Include initial version entry

4. **Validation**
   - Run template checklist
   - Test in Markdown preview

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-04 | BMAD Team | Initial version |

---

## Related Documents

| Document | Path | Relationship |
|----------|------|--------------|
| Workflow Selection Guide | `shared/resources/workflow-selection-guide.md` | Companion guide |
| Builder Skill | `builder/SKILL.md` | Uses these guidelines |
| SUBAGENT-PATTERNS | `BMAD-SUBAGENT-PATTERNS.md` | Architecture reference |
