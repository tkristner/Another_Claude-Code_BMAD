# [Creative Intelligence] Brainstorm Workflow

**Purpose:** Facilitate structured brainstorming sessions using proven creative techniques to generate ideas and actionable insights.

**Goal:** Generate creative ideas and solutions using structured brainstorming techniques

**Phase:** Cross-phase (supports all BMAD phases)

**Agent:** Creative Intelligence

**Trigger keywords:** brainstorm, ideate, SCAMPER, SWOT, mind map, creative ideas, feature generation, problem exploration

**Inputs:** Topic/problem to brainstorm, context/constraints, desired outcome

**Output:** Structured brainstorming document with ideas, insights, and recommendations

**Duration:** 15-45 minutes

---

## When to Use This Workflow

Use this workflow when:
- Need to generate feature ideas for a product
- Exploring solutions to a complex problem
- Conducting risk identification or analysis
- Strategic planning requiring creative input
- Early-stage ideation for any BMAD phase

**Invoke:** `/brainstorm` or `/brainstorm {topic}`

---

## Pre-Flight

1. Load project configuration if exists
2. Explain purpose:
   > "I'll facilitate a structured brainstorming session using proven creative techniques. This generates comprehensive ideas and actionable insights."

---

## Brainstorming Process

Use TodoWrite to track: Define Objective → Select Techniques → Execute → Organize → Extract Insights → Generate Output

---

### Part 1: Define Objective

**Q1: Topic**
> "What are we brainstorming?"
>
> Examples: Feature ideas, solutions to problems, architecture alternatives, process improvements, risk mitigation

**Q2: Context**
> "What's the context? (constraints, what's been tried, success criteria)"

**Q3: Desired Outcome**
> "What outcome do you want? (e.g., 20+ ideas, 3-5 viable solutions, risk identification)"

---

### Part 2: Select Techniques

**Based on objective, select 2-3 complementary techniques:**

| Objective | Recommended Techniques |
|-----------|----------------------|
| Problem exploration | 5 Whys, Starbursting, Six Thinking Hats |
| Solution generation | SCAMPER, Mind Mapping, Brainwriting |
| Risk analysis | Reverse Brainstorming, Six Thinking Hats (Black Hat), SWOT |
| Strategic planning | SWOT Analysis, Mind Mapping, Starbursting |

**Inform user:**
> "I'll use these techniques:
> 1. {technique_1} - {reason}
> 2. {technique_2} - {reason}
> 3. {technique_3} - {reason}"

---

### Part 3-5: Execute Techniques

**Apply each technique systematically:**

#### 5 Whys
Ask "Why?" 5 times to find root cause.

#### SCAMPER
- **S**ubstitute: What can we replace?
- **C**ombine: What can we merge?
- **A**dapt: What can we adjust?
- **M**odify: What can we change?
- **P**ut to other uses: What else can this do?
- **E**liminate: What can we remove?
- **R**everse: What if we did the opposite?

#### Mind Mapping
Create hierarchical structure from central topic with branches and sub-ideas.

#### Reverse Brainstorming
Ask: "How could we make this fail?" then invert insights.

#### Six Thinking Hats
- **White** (Facts): What do we know?
- **Red** (Emotions): How do we feel?
- **Black** (Caution): What are the risks?
- **Yellow** (Benefits): What are the positives?
- **Green** (Creativity): What new ideas?
- **Blue** (Process): What's next?

#### Starbursting
Ask 6 question types: Who, What, Where, When, Why, How

#### SWOT Analysis
- **Strengths:** Internal positives
- **Weaknesses:** Internal negatives
- **Opportunities:** External positives
- **Threats:** External negatives

**Document ALL ideas generated.**

---

### Part 6: Organize Ideas

1. **Group by category** - Create logical groupings
2. **Remove duplicates** - Merge similar ideas
3. **Count total ideas** - Report to user

Format:
```markdown
## Category 1: {name}
- Idea 1: {description}
- Idea 2: {description}

## Category 2: {name}
...
```

---

### Part 7: Extract Insights

**Identify top 3-7 actionable insights.**

**Criteria:**
- High impact potential
- Feasible given constraints
- Novel or unexpected
- Addresses core objective
- Supported by multiple techniques

**Format each insight:**
```markdown
### Insight 1: {title}
**Description:** {explanation}
**Source:** {techniques that surfaced this}
**Impact:** High | Medium | Low
**Effort:** High | Medium | Low
**Why it matters:** {rationale}
```

---

### Part 8: Generate Output

**Save to:** `docs/brainstorming-{topic}-{date}.md`

**Document structure:**
```markdown
# [Creative Intelligence] Brainstorming Session: {objective}

**Date:** {date}
**Objective:** {objective}
**Context:** {context}

## Techniques Used
1. {technique_1}
2. {technique_2}
3. {technique_3}

## Ideas Generated

### Category 1: {category}
{ideas}

[All categories...]

## Key Insights

{insights from Part 7}

## Statistics
- Total ideas: {count}
- Categories: {count}
- Key insights: {count}

## Recommended Next Steps

{context-appropriate recommendations}
```

---

## Recommend Next Steps

**Based on brainstorming objective:**

| If brainstorming for... | Next workflow |
|------------------------|---------------|
| Feature ideas | /prd or /tech-spec |
| Problem solutions | /architecture |
| Risk identification | /sprint-planning |
| Research questions | /research |

---

## Definition of Done

A brainstorm session is complete when all criteria below are satisfied:

### Quantity Metrics by Project Level

| Project Level | Minimum Ideas | Minimum Insights | Minimum Categories |
|---------------|---------------|------------------|-------------------|
| Level 0-1 | 5 ideas | 2 insights | 2 categories |
| Level 2 | 15 ideas | 5 insights | 3 categories |
| Level 3-4 | 30 ideas | 10 insights | 4 categories |

### Quality Checks

- [ ] Ideas span at least 3 different themes/categories
- [ ] At least 2 "wild" or unconventional ideas explored (stretch thinking)
- [ ] Each insight has supporting reasoning documented
- [ ] Top 3-5 ideas prioritized with rationale
- [ ] No single-word ideas (each has ≥1 sentence description)

### Technique Completion

- [ ] All planned techniques executed fully (SCAMPER, Mind Map, etc.)
- [ ] Each technique generated at least 3 ideas
- [ ] Cross-technique patterns identified
- [ ] Technique effectiveness noted for future sessions

### Session Documentation

- [ ] Session summary with statistics (idea count, insight count)
- [ ] Ideas organized by category/theme
- [ ] Priority ranking with criteria used
- [ ] Follow-up actions defined for top ideas

### Exit Criteria

Brainstorm is ready for next phase when:
1. Minimum idea/insight counts met for project level
2. Prioritized shortlist of 3-5 actionable ideas created
3. Follow-up actions assigned with owners (if applicable)
4. Session document saved to project documentation

**Not ready if:**
- Below minimum thresholds for project level
- No prioritization or all ideas marked "equal"
- Missing actionable next steps

---

## Notes for LLMs

- Use TodoWrite to track 8 brainstorming steps
- Apply ALL selected techniques thoroughly - no shortcuts
- Document EVERY idea, even weak ones
- Look for patterns across techniques
- Quantify results (idea counts, categories)
- Extract actionable insights, not just raw ideas
- Use structured frameworks - avoid free-form thinking
- Focus on quality insights over quantity of ideas
- **Structured brainstorming > single-method approaches**

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No clear objective | "Cannot brainstorm without a defined objective." | Define objective with user |
| Insufficient context | "Need more context about the problem domain." | Gather context first |
| Below minimum ideas | "Session didn't generate minimum ideas for project level." | Continue with additional techniques |
| No actionable insights | "Ideas generated but no actionable insights extracted." | Apply insight synthesis framework |
