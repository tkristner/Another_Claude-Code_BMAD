# [UX Designer] WCAG Validation Workflow

**Purpose:** Validate design or implementation against WCAG 2.1 AA accessibility standards.

**Goal:** Run comprehensive WCAG 2.1 AA compliance check and generate actionable report.

**Phase:** 2-3 (Planning/Solutioning) or 4 (Implementation verification)

**Agent:** UX Designer

**Trigger keywords:** wcag validate, accessibility check, a11y audit, wcag compliance, accessibility validation, accessibility test

**Inputs:** UX Design document, implemented UI components, or component specifications

**Output:** WCAG compliance report with pass/fail status and remediation recommendations

**Duration:** 15-30 minutes

---

## When to Use This Workflow

Use `/wcag-validate` when:
- Before finalizing UX designs (Phase 2-3)
- After implementing UI components (Phase 4)
- During accessibility audits
- Before release/deployment
- Reviewing existing designs for compliance
- Validating third-party components

**Do not use** for:
- Quick color contrast check only → use `/check-contrast`
- General UX design work → use `/create-ux-design`

---

## Workflow Steps

### Step 1: Identify Validation Scope

**Objective:** Determine what will be validated.

**Options:**
1. **Design Document** - UX design files in `docs/`
2. **Component List** - Specific UI components to validate
3. **Screen/Flow** - Specific screens or user flows
4. **Full Audit** - Complete application accessibility review

**Ask user:**
```
What would you like to validate for WCAG 2.1 AA compliance?

[D] Design document - Path to UX design file
[C] Components - List of components to check
[S] Screen/Flow - Specific screens or user flows
[F] Full audit - Complete application review
```

---

### Step 2: Load Context

**Objective:** Gather design specifications for validation.

1. **Load design document** (if specified)
   - Read color specifications
   - Extract component definitions
   - Identify interactive elements

2. **Load design tokens** (if available)
   - Read `resources/design-tokens.md`
   - Extract color palette
   - Note typography scale

3. **Identify testable elements:**
   - Text elements (headings, body, captions)
   - Interactive controls (buttons, links, inputs)
   - Images and media
   - Forms and validation
   - Navigation structures
   - Dynamic content

---

### Step 3: Run WCAG Checklist

**Objective:** Systematically check each WCAG 2.1 AA criterion.

Execute the WCAG checklist script:
```bash
bash scripts/wcag-checklist.sh
```

**WCAG 2.1 Level AA Criteria:**

#### Perceivable (P)

| Criterion | Description | Check |
|-----------|-------------|-------|
| 1.1.1 | Non-text Content - Alt text for images | [ ] |
| 1.2.1 | Audio-only and Video-only - Alternatives | [ ] |
| 1.2.2 | Captions - For audio content | [ ] |
| 1.2.3 | Audio Description - For video content | [ ] |
| 1.2.5 | Audio Description (Prerecorded) | [ ] |
| 1.3.1 | Info and Relationships - Semantic structure | [ ] |
| 1.3.2 | Meaningful Sequence - Logical order | [ ] |
| 1.3.3 | Sensory Characteristics - Not just color/shape | [ ] |
| 1.3.4 | Orientation - Both portrait and landscape | [ ] |
| 1.3.5 | Identify Input Purpose - Autocomplete support | [ ] |
| 1.4.1 | Use of Color - Not sole indicator | [ ] |
| 1.4.2 | Audio Control - Pause/stop/mute | [ ] |
| 1.4.3 | Contrast (Minimum) - 4.5:1 text, 3:1 large | [ ] |
| 1.4.4 | Resize Text - Up to 200% | [ ] |
| 1.4.5 | Images of Text - Avoid when possible | [ ] |
| 1.4.10 | Reflow - No horizontal scroll at 320px | [ ] |
| 1.4.11 | Non-text Contrast - 3:1 for UI components | [ ] |
| 1.4.12 | Text Spacing - Customizable without loss | [ ] |
| 1.4.13 | Content on Hover or Focus - Dismissible | [ ] |

#### Operable (O)

| Criterion | Description | Check |
|-----------|-------------|-------|
| 2.1.1 | Keyboard - All functionality accessible | [ ] |
| 2.1.2 | No Keyboard Trap - Can navigate away | [ ] |
| 2.1.4 | Character Key Shortcuts - Can disable/remap | [ ] |
| 2.2.1 | Timing Adjustable - Extended or disabled | [ ] |
| 2.2.2 | Pause, Stop, Hide - For moving content | [ ] |
| 2.3.1 | Three Flashes - No content flashes 3x/sec | [ ] |
| 2.4.1 | Bypass Blocks - Skip navigation | [ ] |
| 2.4.2 | Page Titled - Descriptive titles | [ ] |
| 2.4.3 | Focus Order - Logical sequence | [ ] |
| 2.4.4 | Link Purpose (In Context) - Clear destination | [ ] |
| 2.4.5 | Multiple Ways - To find pages | [ ] |
| 2.4.6 | Headings and Labels - Descriptive | [ ] |
| 2.4.7 | Focus Visible - Clear focus indicator | [ ] |
| 2.5.1 | Pointer Gestures - Single pointer alternative | [ ] |
| 2.5.2 | Pointer Cancellation - Can undo/abort | [ ] |
| 2.5.3 | Label in Name - Visible matches accessible | [ ] |
| 2.5.4 | Motion Actuation - Alternative available | [ ] |

#### Understandable (U)

| Criterion | Description | Check |
|-----------|-------------|-------|
| 3.1.1 | Language of Page - Defined in HTML | [ ] |
| 3.1.2 | Language of Parts - For different languages | [ ] |
| 3.2.1 | On Focus - No unexpected changes | [ ] |
| 3.2.2 | On Input - No unexpected changes | [ ] |
| 3.2.3 | Consistent Navigation - Same order | [ ] |
| 3.2.4 | Consistent Identification - Same functions | [ ] |
| 3.3.1 | Error Identification - Clear error indication | [ ] |
| 3.3.2 | Labels or Instructions - Provided for inputs | [ ] |
| 3.3.3 | Error Suggestion - Correction provided | [ ] |
| 3.3.4 | Error Prevention (Legal, Financial) - Reversible | [ ] |

#### Robust (R)

| Criterion | Description | Check |
|-----------|-------------|-------|
| 4.1.1 | Parsing - Valid HTML | [ ] |
| 4.1.2 | Name, Role, Value - For all UI components | [ ] |
| 4.1.3 | Status Messages - Announced by assistive tech | [ ] |

---

### Step 4: Check Color Contrast

**Objective:** Validate all color combinations meet contrast requirements.

For each color pair in the design:

```bash
python scripts/contrast-check.py <foreground> <background>
```

**Minimum Ratios:**
- Normal text (< 18pt): **4.5:1**
- Large text (≥ 18pt or 14pt bold): **3:1**
- UI components and graphics: **3:1**

**Document findings:**
```
Color Contrast Results:

| Element | FG Color | BG Color | Ratio | Required | Status |
|---------|----------|----------|-------|----------|--------|
| Body text | #333333 | #FFFFFF | 12.6:1 | 4.5:1 | ✓ Pass |
| Button | #FFFFFF | #0066CC | 5.1:1 | 4.5:1 | ✓ Pass |
| Error msg | #CC0000 | #FFFFFF | 5.4:1 | 4.5:1 | ✓ Pass |
| Disabled | #999999 | #FFFFFF | 2.8:1 | 3:1 | ✗ Fail |
```

---

### Step 5: Validate Keyboard Navigation

**Objective:** Ensure all functionality is keyboard accessible.

**Checklist:**
- [ ] All interactive elements focusable via Tab
- [ ] Focus order matches visual layout
- [ ] No keyboard traps (can Tab away from all elements)
- [ ] Focus indicator is visible (min 2px, contrasting)
- [ ] Skip links available for navigation
- [ ] Modals trap focus appropriately
- [ ] Dropdown menus navigable with arrow keys
- [ ] Custom widgets have appropriate keyboard patterns

---

### Step 6: Generate Compliance Report

**Objective:** Create actionable report with findings.

**Report Format:**

```markdown
# [UX Designer] WCAG 2.1 AA Compliance Report

**Scope:** [Design/Component/Application name]
**Date:** [Date]
**Validator:** UX Designer (BMAD)

## Summary

| Category | Pass | Fail | N/A | Total |
|----------|------|------|-----|-------|
| Perceivable | X | X | X | 19 |
| Operable | X | X | X | 17 |
| Understandable | X | X | X | 10 |
| Robust | X | X | X | 3 |
| **Total** | **X** | **X** | **X** | **49** |

**Overall Compliance:** [Compliant / Partially Compliant / Non-Compliant]

## Critical Failures (Must Fix)

| ID | Criterion | Issue | Impact | Remediation |
|----|-----------|-------|--------|-------------|
| F1 | 1.4.3 | Disabled text contrast 2.8:1 | Low vision users | Use #767676 minimum |
| F2 | 2.4.7 | No focus indicator on cards | Keyboard users | Add 2px outline |

## Warnings (Should Fix)

| ID | Criterion | Issue | Impact | Recommendation |
|----|-----------|-------|--------|----------------|
| W1 | 1.4.11 | Icon-only buttons | Cognitive | Add aria-label |

## Recommendations

1. **High Priority:** [List critical fixes]
2. **Medium Priority:** [List important improvements]
3. **Enhancement:** [List nice-to-have improvements]

## Next Steps

- [ ] Fix critical failures before release
- [ ] Address warnings in next sprint
- [ ] Re-validate after fixes
```

---

## Integration with Other Workflows

**Use with:**
- `/create-ux-design` - Validate designs before handoff
- `/code-review` - Include accessibility in code reviews
- `/dev-story` - Validate during implementation
- `/check-contrast` - Quick contrast checks during design

**Sequence:**
1. `/create-ux-design` - Create the design
2. `/wcag-validate` - Validate accessibility
3. Fix issues found
4. `/dev-story` - Implement with accessibility
5. `/wcag-validate` - Verify implementation

---

## Success Criteria

This workflow is complete when:
- [ ] All WCAG 2.1 AA criteria have been evaluated
- [ ] Color contrast checked for all text and UI elements
- [ ] Keyboard navigation validated
- [ ] Compliance report generated
- [ ] Critical failures documented with remediation steps
- [ ] Report saved to project documentation

---

## Notes for Claude

- Always run the full WCAG checklist, don't skip criteria
- Check contrast for ALL color combinations, not just obvious ones
- Include disabled states, hover states, and error states
- Document N/A criteria with reason
- Provide specific, actionable remediation for all failures
- Reference WCAG documentation for ambiguous cases

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No design to validate | "Cannot validate WCAG without design document or implementation." | Provide design or code path |
| No color palette defined | "Cannot check contrast without color information." | Define color palette |
| Critical failures detected | "Design has {N} critical accessibility failures requiring remediation." | Fix failures before proceeding |

---

*Generated by BMAD Method - UX Designer Skill*
