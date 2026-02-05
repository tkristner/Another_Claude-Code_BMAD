# [Creative Intelligence] Research Workflow

**Purpose:** Conduct comprehensive research across market, competitive, technical, and user domains to provide actionable insights.

**Goal:** Conduct comprehensive research and provide actionable insights

**Phase:** Cross-phase (supports all BMAD phases)

**Agent:** Creative Intelligence

**Trigger keywords:** research, market research, competitive analysis, technical research, user research, industry analysis

**Inputs:** Research topic, research type, specific questions to answer, constraints/focus areas

**Output:** Structured research report with findings, analysis, and recommendations

**Duration:** 30-90 minutes

---

## When to Use This Workflow

Use this workflow when:
- Need market size, trends, and growth data
- Analyzing competitors (features, pricing, positioning)
- Evaluating technologies or frameworks
- Understanding user needs and pain points
- Supporting product decisions with data

**Invoke:** `/research` or `/research {topic}`

---

## Pre-Flight

1. Load project configuration if exists
2. Explain purpose:
   > "I'll conduct comprehensive research on your topic. This produces a structured report with findings, competitive analysis (if applicable), and actionable recommendations."

---

## Research Process

Use TodoWrite to track: Define Scope → Select Methods → Gather Data → Analyze → Create Matrix → Extract Insights → Generate Report

---

### Part 1: Define Research Scope

**Q1: Topic**
> "What are we researching?"
>
> Examples: Market size, competitors, best practices, user needs, technology options

**Q2: Research Type**
1. **Market Research** - Size, trends, growth, segments
2. **Competitive Research** - Competitors, features, positioning, gaps
3. **Technical Research** - Technologies, frameworks, patterns
4. **User Research** - Needs, pain points, behaviors
5. **Mixed** - Combination

**Q3: Specific Questions**
> "What specific questions should this answer?" (List 3-7 key questions)

**Q4: Constraints**
> "Any constraints or focus areas?" (Region, industry, budget, tech stack)

---

### Part 2: Select Research Methods

**Based on research type:**

| Type | Methods | Tools |
|------|---------|-------|
| Market | Industry reports, market analysis | WebSearch, WebFetch |
| Competitive | Competitor sites, reviews, comparisons | WebSearch, WebFetch |
| Technical | Documentation, tutorials, benchmarks | WebSearch, WebFetch, Explore agent |
| User | Forums, reviews, studies | WebSearch, WebFetch |

**Inform user:**
> "Research approach:
> - Method 1: {method}
> - Method 2: {method}
> - Method 3: {method}"

---

### Part 3: Gather Information

#### For Market Research

**Search for:**
- "{market} market size {current_year}"
- "{market} industry trends"
- "{market} growth projections"
- "{market} customer segments"

**Capture:**
- Market size (TAM, SAM, SOM)
- Growth rate (CAGR)
- Key trends
- Major players
- Customer segments

#### For Competitive Research

**For each competitor (3-7):**

**Search for:**
- "{competitor} features"
- "{competitor} pricing"
- "{competitor} reviews"
- "{competitor} vs alternatives"

**Capture per competitor:**
```markdown
### {Competitor Name}
**Overview:** {description}
**Target Market:** {target}
**Pricing:** {model}
**Key Features:** {list}
**Strengths:** {list}
**Weaknesses:** {list}
**Unique Differentiators:** {what makes them unique}
**Source:** {url}
```

#### For Technical Research

**For each technology:**

**Search for:**
- "{technology} documentation"
- "{technology} best practices"
- "{technology} vs {alternative}"
- "{technology} performance"

**Capture:**
```markdown
### {Technology}
**Purpose:** {what it does}
**Maturity:** {stable/beta/experimental}
**Community:** {size indicators}
**Pros:** {list}
**Cons:** {list}
**Best For:** {use cases}
**Source:** {url}
```

#### For User Research

**Search for:**
- "{user_type} pain points {domain}"
- "{user_type} needs {domain}"
- "user reviews {related_products}"
- "accessibility requirements {domain}"

**Capture:**
- User personas
- Pain points
- Needs and goals
- Behavior patterns

---

### Part 4: Analyze Findings

**For each research question:**
```markdown
### Q: {question}
**Answer:** {synthesis}
**Supporting Evidence:**
- {source_1}: {finding}
- {source_2}: {finding}
**Confidence:** High | Medium | Low
**Gaps:** {what we still don't know}
```

**Identify patterns:**
- Common themes across sources
- Conflicting information
- Gaps in available information
- Surprising findings

---

### Part 5: Create Competitive Matrix (if applicable)

**Feature comparison:**
```markdown
| Feature | Our Product | Competitor 1 | Competitor 2 |
|---------|-------------|--------------|--------------|
| Feature 1 | Planned | Yes | No |
| Feature 2 | Unique | No | No |
```

**Pricing comparison:**
```markdown
| Competitor | Entry | Mid | Enterprise |
|------------|-------|-----|------------|
| Comp 1 | $10/mo | $50/mo | Custom |
```

---

### Part 6: Extract Key Insights

**Identify 5-10 actionable insights.**

**Format:**
```markdown
### Insight {N}: {title}
**Finding:** {what research revealed}
**Implication:** {what this means}
**Recommendation:** {what to do}
**Priority:** High | Medium | Low
**Supporting Data:** {sources}
```

**Categorize:**
- Market insights
- Competitive insights
- Technical insights
- User insights
- Risk insights
- Opportunity insights

---

### Part 7: Generate Report

**Save to:** `docs/research-{topic}-{date}.md`

**Structure:**
```markdown
# [Creative Intelligence] Research Report: {topic}

**Date:** {date}
**Type:** {research_type}

## Executive Summary
{2-3 paragraph summary}

Key findings:
- Finding 1
- Finding 2
- Finding 3

## Research Questions
{from Part 1}

## Methodology
- Methods used
- Sources consulted: {count}

## Findings
{answers from Part 4}

## Detailed Analysis
{market/competitive/technical/user sections as applicable}

## Key Insights
{from Part 6}

## Recommendations

### Immediate (Next 2 weeks)
1. {action}

### Short-term (1-3 months)
1. {action}

### Long-term (3+ months)
1. {action}

## Research Gaps
{unanswered questions, recommended follow-up}

## Sources
{all sources with URLs}
```

---

## Recommend Next Steps

| Research Type | Next Workflow |
|---------------|---------------|
| Market Research | /product-brief or /prd |
| Competitive Research | /prd (feature prioritization) |
| Technical Research | /architecture |
| User Research | /prd or /create-ux-design |
| Gaps identified | /research (follow-up) |

---

## Definition of Done

Research is complete when all criteria below are satisfied:

### Coverage Metrics

- [ ] All stated research questions addressed (100%)
- [ ] Each question has ≥2 supporting sources
- [ ] Mix of primary and secondary sources used
- [ ] No critical questions left unanswered without explanation

### Confidence Level Requirements

For each finding, assign and document confidence level:

| Level | Confidence | Evidence Required | Action |
|-------|------------|-------------------|--------|
| **High** | 90%+ | 3+ independent sources agree | Ready for decisions |
| **Medium** | 70-89% | 2 sources agree, limited conflict | Ready with caveats |
| **Low** | 50-69% | 1 source or conflicting data | Flag for validation |
| **Insufficient** | <50% | Unable to answer reliably | Requires more research |

### Minimum Confidence Thresholds

- [ ] ≥70% of findings rated Medium or High confidence
- [ ] No critical decisions rely solely on Low confidence findings
- [ ] All Low/Insufficient findings flagged with follow-up plan
- [ ] Key recommendations based only on Medium+ confidence data

### Source Quality

- [ ] All sources cited with accessible URLs
- [ ] Source dates documented (prefer <2 years old for market data)
- [ ] Potential bias in sources acknowledged
- [ ] At least 1 authoritative source per major finding

### Deliverable Completeness

- [ ] Executive summary (≤5 bullet points)
- [ ] Detailed findings by research question
- [ ] Recommendations with priorities (High/Medium/Low)
- [ ] Research gaps and limitations documented
- [ ] Full source bibliography

### Exit Criteria

Research is actionable when:
1. All key questions answered at Medium+ confidence
2. Uncertainties documented with mitigation plans
3. Clear, prioritized recommendations provided
4. Limitations honestly stated

**Not ready if:**
- Critical questions at Low/Insufficient confidence
- Recommendations not tied to evidence
- Missing source citations

---

## Notes for LLMs

- Use TodoWrite to track 8 research steps
- Use appropriate tools: WebSearch, WebFetch, Task with Explore
- **Cite all sources with URLs**
- Quantify findings when possible
- Create competitive matrix for competitive research
- Note confidence level for each finding
- Identify gaps and recommend follow-up
- Extract actionable insights, not just raw data
- Provide specific recommendations with priorities
- Format for readability (tables, lists, sections)
- **Research should answer questions with evidence and recommendations**

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No research questions | "Cannot research without defined questions." | Define research scope with user |
| Critical questions unanswerable | "Unable to find reliable data for critical questions." | Flag gaps, recommend alternatives |
| All findings low confidence | "Findings lack reliable sources. Need additional research." | Identify better sources |
| No actionable recommendations | "Research complete but no clear recommendations." | Apply insight synthesis |
