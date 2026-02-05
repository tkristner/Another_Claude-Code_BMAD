# [UX Designer] Create UX Design Workflow

**Purpose:** Create comprehensive UX design documents including user flows, wireframes, accessibility annotations, and developer handoff specifications.

**Goal:** Create comprehensive UX design with wireframes, user flows, and accessibility

**Phase:** Phase 2 (Planning) or Phase 3 (Solutioning)

**Agent:** UX Designer

**Trigger keywords:** create UX design, wireframes, user flows, accessibility design, UI design, interface design

**Inputs:** PRD or tech-spec with user stories and acceptance criteria

**Output:** `accbmad/2-planning/ux-design-{project-name}.md`

**Duration:** 60-120 minutes

---

## When to Use This Workflow

Use this workflow when:
- Requirements are defined and need UX/UI design
- Creating wireframes for a new feature or product
- Need to document user flows and interactions
- Ensuring WCAG accessibility compliance
- Preparing design specifications for developers

**Invoke:** `/create-ux-design` or `/create-ux-design {feature}`

---

## Pre-Flight

1. Load project configuration
2. Load requirements (PRD or tech-spec)
3. Extract user stories, acceptance criteria, NFRs
4. Explain purpose:
   > "I'll create a comprehensive UX design including user flows, wireframes, accessibility annotations, and developer handoff documentation."

---

## UX Design Process

Use TodoWrite to track: Load Requirements → Define Scope → User Flows → Wireframes → Accessibility → Components → Design Tokens → Handoff → Generate

---

### Part 1: Analyze Requirements

**Load PRD or tech-spec:**
- Extract all user stories
- Extract UX-related NFRs (performance, usability, accessibility, compatibility)

**Ask additional context:**

**Q1: Target Platforms**
- [ ] Web (desktop)
- [ ] Web (mobile)
- [ ] Web (tablet)
- [ ] iOS/Android native
- [ ] PWA

**Q2: Design Detail Level**
1. **High-level** - User flows + basic wireframes
2. **Detailed** - Full wireframes with interactions
3. **Comprehensive** - Wireframes, components, design system

**Q3: Accessibility Requirements**
1. WCAG 2.1 Level A (minimum)
2. WCAG 2.1 Level AA (recommended)
3. WCAG 2.1 Level AAA (highest)

**Q4: Existing Design System**
> "Do you have existing brand guidelines or design system?"

---

### Part 2: Identify Design Scope

**Group user stories by screen/flow:**
```
Flow 1: User Authentication
- US-001: User can sign up
- US-002: User can log in
Screens needed: Sign up, Login, Forgot password

Flow 2: Dashboard
- US-004: User can view dashboard
Screens needed: Dashboard (empty), Dashboard (with data)
```

**Report:** "I've identified {screen_count} screens across {flow_count} user flows."

---

### Part 3: Create User Flows

**For each major flow:**

```markdown
### Flow: {name}

**Entry Point:** {how user starts}

**Happy Path:**
1. {screen_1} → User {action} → {screen_2}
2. {screen_2} → User {action} → {screen_3}

**Decision Points:**
- At {screen}: If {condition} → {alternative_path}

**Error Cases:**
- {error} → Show {message} → {recovery}

**Exit Points:**
- Success: {screen}
- Cancel: {destination}
- Error: {screen}

**Diagram:**
[Start]
   ↓
[Screen 1]
   ↓ {action}
[Screen 2]
   ├─→ [Success]
   └─→ [Error]
```

**Create flows for:** Authentication, core features, settings, error handling

---

### Part 4: Design Wireframes

**For each screen, choose approach:**

#### Option 1: ASCII Art (quick)
```
┌─────────────────────────┐
│ ☰  Logo        [?]      │ ← Header
├─────────────────────────┤
│                         │
│  Page Title             │
│  Subtitle               │
│                         │
│  ┌─────────────────┐    │
│  │ Card            │    │
│  │ [Button]        │    │
│  └─────────────────┘    │
│                         │
│  [Primary CTA]          │
│                         │
└─────────────────────────┘
```

#### Option 2: Structured Description (detailed)
```markdown
### Screen: {name}

**Purpose:** {what user does here}

**Header (60px):**
- Logo (left, 40px)
- Navigation (center)
- Help icon (right)

**Main Content:**

**Hero Section (400px):**
- Headline (H1, 48px, center)
- Subheadline (H2, 24px)

**Card Grid (responsive):**
- 2 columns (desktop), 1 column (mobile)
- Gap: 24px

**Interactions:**
- Card hover → elevation
- Button click → {action}

**States:**
- Default, Hover, Focus, Active, Disabled, Loading

**Responsive:**
- Mobile: Single column, hamburger menu
- Tablet: 2 columns
- Desktop: 3 columns, max-width 1200px
```

---

### Part 5: Ensure Accessibility

**For each screen:**

```markdown
### Accessibility: {screen}

**WCAG {level} Compliance:**

**Perceivable:**
- [ ] All images have alt text
- [ ] Color contrast ≥4.5:1 (text), ≥3:1 (UI)
- [ ] Information not conveyed by color alone
- [ ] Text resizable to 200%

**Operable:**
- [ ] Tab order: {sequence}
- [ ] Focus indicators visible (2px outline)
- [ ] No keyboard traps
- [ ] Touch targets ≥44px
- [ ] Respects prefers-reduced-motion

**Understandable:**
- [ ] Page language set
- [ ] Form labels for all inputs
- [ ] Error messages clear and actionable
- [ ] Consistent navigation

**Robust:**
- [ ] Semantic HTML: header, nav, main, footer
- [ ] ARIA labels where needed
- [ ] Form validation: aria-invalid, aria-describedby

**Keyboard Navigation:**
Tab → next element
Shift+Tab → previous
Enter → activate
Escape → close modal
Arrow keys → within component
```

---

### Part 6: Define Components

**Extract reusable components:**

```markdown
## Component Library

### Button
**Variants:** Primary, Secondary, Tertiary
**States:** Default, Hover (darken 10%), Focus (2px outline), Active, Disabled (50% opacity)
**Sizes:** Small (32px), Medium (40px), Large (48px)
**Accessibility:** Min 44x44px, focus indicator, aria-disabled

### Card
**Structure:** Image (16:9), Title (H3), Description, Action
**States:** Default (elevation 1), Hover (elevation 2)
**Responsive:** Full-width (mobile), 48% (tablet), 32% (desktop)

### Form Input
**Structure:** Label (above), Input, Help text, Error message
**States:** Default, Focus (primary border), Error (error border), Disabled
**Accessibility:** label for={id}, aria-required, aria-invalid
```

---

### Part 7: Define Design Tokens

```markdown
## Design Tokens

### Colors
**Primary:** #0066CC (contrast 4.57:1)
**Primary-dark:** #004C99
**Success:** #00AA44
**Error:** #DD0000
**Neutral-700:** #555555 (primary text)
**Neutral-300:** #CCCCCC (borders)

### Typography
**Font:** -apple-system, BlinkMacSystemFont, sans-serif
**H1:** 48px / 600 / 1.2
**H2:** 36px / 600 / 1.3
**Body:** 16px / 400 / 1.6

### Spacing (8px base)
xs: 4px, sm: 8px, md: 16px, lg: 24px, xl: 32px

### Breakpoints
Mobile: 320-767px
Tablet: 768-1023px
Desktop: 1024px+
```

---

### Part 8: Developer Handoff

```markdown
## Developer Handoff

### Implementation Priorities
**Phase 1:** Design tokens, base components, responsive grid
**Phase 2:** {priority_screens}
**Phase 3:** Animations, loading states, edge cases

### Component Notes
- Use CSS custom properties for design tokens
- Mobile-first responsive approach
- All interactive elements need focus states

### Accessibility Checklist
- [ ] All images have alt text
- [ ] Keyboard navigation works
- [ ] Screen reader tested
- [ ] Color contrast verified
- [ ] Zoom to 200% tested

### Assets Needed
- Logo (SVG)
- Icons (SVG, 24px)
- Placeholder images (16:9)
```

---

### Part 9: Generate Document

**Save to:** `accbmad/2-planning/ux-design-{project-name}.md`

**Structure:**
```markdown
# [UX Designer] UX Design: {project}

**Date:** {date}
**Platforms:** {list}
**Accessibility:** WCAG {level}

## Design Scope
Screens: {count}, Flows: {count}, Components: {count}

## User Flows
{Part 3}

## Wireframes
{Part 4}

## Accessibility
{Part 5}

## Component Library
{Part 6}

## Design Tokens
{Part 7}

## Developer Handoff
{Part 8}

## Validation
- [ ] All user stories mapped to screens
- [ ] WCAG compliance verified
- [ ] Responsive on all platforms
- [ ] Ready for implementation
```

---

## Update Status

Update `accbmad/status.yaml`:
```yaml
ux_design: "accbmad/2-planning/ux-design-{project}.md"
ux_design_date: {date}
screens_designed: {count}
accessibility_level: {level}
```

---

## Recommend Next Steps

```
UX Design Complete!

Next Steps:

1. **Review with PM** - Validate designs meet requirements
2. **Architecture Review** - Run /architecture
3. **Sprint Planning** - Run /sprint-planning
4. **Begin Development** - Run /dev-story
```

---

## Notes for LLMs

- Use TodoWrite to track 9 UX design steps
- Load requirements before starting
- Create user flows for all major features
- Use ASCII art for quick wireframes, structured descriptions for detail
- **Always include accessibility annotations**
- Define design tokens for consistency
- Extract reusable components
- Provide detailed developer handoff
- Map all user stories to screens
- Design mobile-first, then scale up
- Check color contrast ratios
- Specify all interaction states
- **User-centered, accessible design ensures products work for everyone**

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No requirements | "Cannot design UX without requirements. Run `/prd` or `/tech-spec` first." | Create requirements |
| WCAG failures | "Design has critical accessibility failures." | Fix accessibility issues |
| Missing user flows | "Cannot proceed without defined user flows." | Define user journeys |
| No target users | "Cannot design without knowing target user personas." | Define user personas |
