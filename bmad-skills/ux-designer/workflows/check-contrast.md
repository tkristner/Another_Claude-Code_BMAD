# [UX Designer] Contrast Check Workflow

**Purpose:** Validate color contrast ratios meet WCAG accessibility requirements.

**Goal:** Check color pairs for WCAG 2.1 AA/AAA compliance and suggest alternatives if needed.

**Phase:** 2-3 (Planning/Solutioning)

**Agent:** UX Designer

**Trigger keywords:** contrast check, color contrast, contrast ratio, wcag contrast, accessibility colors, check colors

**Inputs:** Color pairs (foreground/background) in hex, RGB, or color names

**Output:** Contrast ratio report with pass/fail status per WCAG level

**Duration:** 5-15 minutes

---

## When to Use This Workflow

Use `/check-contrast` when:
- Defining color palette for a new project
- Reviewing design mockups for accessibility
- Implementing themed components
- Updating brand colors
- Quick validation of specific color combinations
- Checking text readability

**Do not use** for:
- Full WCAG accessibility audit → use `/wcag-validate`
- Complete UX design → use `/create-ux-design`

---

## Workflow Steps

### Step 1: Collect Color Pairs

**Objective:** Get the colors to check.

**Input formats accepted:**
- **Hex:** `#FFFFFF` or `#FFF`
- **RGB:** `rgb(255, 255, 255)`
- **Named:** `white`, `black`, `red` (common web colors)

**Ask user:**
```
What colors would you like to check?

Format: foreground color on background color
Examples:
  - #333333 on #FFFFFF
  - rgb(0,0,0) on rgb(255,255,255)
  - white on blue

You can provide multiple pairs, one per line.
```

---

### Step 2: Run Contrast Check

**Objective:** Calculate contrast ratios for each pair.

For each color pair, execute:
```bash
python scripts/contrast-check.py <foreground> <background>
```

**Contrast Formula (WCAG 2.1):**
```
Contrast Ratio = (L1 + 0.05) / (L2 + 0.05)

Where L1 = relative luminance of lighter color
      L2 = relative luminance of darker color
```

---

### Step 3: Evaluate Results

**Objective:** Determine pass/fail status for each use case.

**WCAG 2.1 Contrast Requirements:**

| Ratio | Normal Text | Large Text* | UI Components | Graphics |
|-------|-------------|-------------|---------------|----------|
| ≥ 7:1 | AAA ✓ | AAA ✓ | AAA ✓ | AAA ✓ |
| ≥ 4.5:1 | AA ✓ | AAA ✓ | AA ✓ | AA ✓ |
| ≥ 3:1 | ✗ Fail | AA ✓ | AA ✓ | AA ✓ |
| < 3:1 | ✗ Fail | ✗ Fail | ✗ Fail | ✗ Fail |

*Large text = 18pt (24px) or 14pt (18.66px) bold

**Result Categories:**
- **Pass (AAA):** Excellent - meets highest standard
- **Pass (AA):** Good - meets minimum requirement
- **Fail:** Does not meet accessibility requirements

---

### Step 4: Generate Report

**Objective:** Create clear, actionable report.

**Report Format:**

```markdown
# [UX Designer] Color Contrast Report

**Date:** [Date]
**Checked by:** UX Designer (BMAD)

## Results Summary

| # | Foreground | Background | Ratio | Normal Text | Large Text | UI/Graphics |
|---|------------|------------|-------|-------------|------------|-------------|
| 1 | #333333 | #FFFFFF | 12.63:1 | AAA ✓ | AAA ✓ | AAA ✓ |
| 2 | #0066CC | #FFFFFF | 5.08:1 | AA ✓ | AAA ✓ | AA ✓ |
| 3 | #FF6600 | #FFFFFF | 3.04:1 | ✗ Fail | AA ✓ | AA ✓ |
| 4 | #CCCCCC | #FFFFFF | 1.61:1 | ✗ Fail | ✗ Fail | ✗ Fail |

## Detailed Analysis

### Pair 1: #333333 on #FFFFFF
- **Ratio:** 12.63:1
- **Status:** Excellent (AAA)
- **Use for:** Any text, UI components, graphics
- **Notes:** High contrast, safe for all uses

### Pair 3: #FF6600 on #FFFFFF
- **Ratio:** 3.04:1
- **Status:** Partial (AA for large text/UI only)
- **Use for:** Large headings (18pt+), icons, borders
- **Not for:** Body text, small text, captions
- **Suggestion:** For normal text, darken to #CC5200 (4.56:1)

### Pair 4: #CCCCCC on #FFFFFF
- **Ratio:** 1.61:1
- **Status:** Fail
- **Use for:** Nothing - accessibility barrier
- **Suggestion:** Use #767676 minimum (4.54:1) or #595959 (7.01:1)

## Recommended Alternatives

For failing pairs, consider these accessible alternatives:

| Original | Suggested | New Ratio | Notes |
|----------|-----------|-----------|-------|
| #CCCCCC | #767676 | 4.54:1 | Minimum AA for text |
| #CCCCCC | #595959 | 7.01:1 | AAA compliant |
| #FF6600 | #CC5200 | 4.56:1 | AA for text |
| #FF6600 | #B34700 | 5.74:1 | Better contrast |
```

---

### Step 5: Provide Remediation

**Objective:** Suggest fixes for failing colors.

For each failing color pair:

1. **Darken foreground** - Calculate minimum darkness for AA
2. **Lighten background** - Calculate minimum lightness for AA
3. **Suggest alternatives** - Provide 2-3 accessible alternatives
4. **Show impact** - Explain what the color can/cannot be used for

**Quick Fix Reference:**

| Minimum Ratio | Foreground on White | White on Background |
|---------------|---------------------|---------------------|
| 4.5:1 (AA text) | #767676 or darker | #0073B5 or darker |
| 3:1 (AA UI) | #949494 or darker | #0094EB or darker |
| 7:1 (AAA) | #595959 or darker | #005586 or darker |

---

## Color Accessibility Quick Reference

### Safe Color Combinations (Always Pass AA)

**On White (#FFFFFF):**
- Black (#000000) - 21:1
- Dark gray (#333333) - 12.6:1
- Navy (#000080) - 8.6:1
- Dark green (#006400) - 7.1:1
- Dark red (#8B0000) - 7.0:1

**On Black (#000000):**
- White (#FFFFFF) - 21:1
- Yellow (#FFFF00) - 19.6:1
- Cyan (#00FFFF) - 16.7:1
- Light gray (#CCCCCC) - 13.1:1

### Common Problematic Colors

These often fail contrast when used as text:
- Light gray on white
- Yellow on white
- Light blue on white
- Pastel colors on light backgrounds
- Neon colors on dark backgrounds

---

## Integration with Other Workflows

**Use with:**
- `/create-ux-design` - Validate color choices during design
- `/wcag-validate` - Part of full accessibility audit

**Sequence:**
1. Define color palette
2. `/check-contrast` - Validate all combinations
3. Adjust failing colors
4. Continue with design
5. Re-check if colors change

---

## Success Criteria

This workflow is complete when:
- [ ] All requested color pairs checked
- [ ] Contrast ratios calculated correctly
- [ ] Pass/fail status determined for each use case
- [ ] Failing pairs have suggested alternatives
- [ ] Report generated with clear guidance

---

## Script Usage

**Direct script execution:**
```bash
# [UX Designer] Check single pair
python scripts/contrast-check.py "#333333" "#FFFFFF"

# [UX Designer] Output format:
# [UX Designer] Foreground: #333333
# [UX Designer] Background: #FFFFFF
# [UX Designer] Contrast Ratio: 12.63:1
# [UX Designer] Normal Text (4.5:1): PASS (AAA)
# [UX Designer] Large Text (3:1): PASS (AAA)
# [UX Designer] UI Components (3:1): PASS (AAA)
```

**Batch checking:**
```bash
# [UX Designer] Create a file with color pairs (colors.txt):
# [UX Designer] #333333 #FFFFFF
# [UX Designer] #0066CC #FFFFFF
# [UX Designer] #CCCCCC #FFFFFF

# [UX Designer] Run batch check
while read fg bg; do
  python scripts/contrast-check.py "$fg" "$bg"
done < colors.txt
```

---

## Notes for Claude

- Always provide the calculated ratio, not just pass/fail
- Suggest at least one accessible alternative for failing pairs
- Explain what the color CAN be used for (large text, UI) even if it fails for normal text
- Consider the context: brand colors may need careful adjustment
- Reference the original color when suggesting alternatives
- Check both directions if colors might be swapped

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No colors provided | "Cannot check contrast without color values." | Provide foreground and background colors |
| Invalid color format | "Color value '{color}' is not valid hex format." | Use valid hex colors (#RRGGBB) |

---

*Generated by BMAD Method - UX Designer Skill*
