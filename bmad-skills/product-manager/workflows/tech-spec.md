# Tech Spec Workflow

**Goal:** Create focused technical specification for small projects

**Phase:** 2 - Planning

**Agent:** Product Manager

**Trigger keywords:** tech spec, technical specification, small project spec, level 0 spec, level 1 spec, simple requirements

**Duration:** 20-40 minutes

**Best for:** Level 0-1 projects (1-10 stories)

**Output:** `accbmad/2-planning/tech-spec-{project-name}-{date}.md`

---

## Pre-Flight

1. Load project configuration
2. Check workflow status
3. Load product brief if exists
4. Load template `templates/tech-spec.template.md` if available

---

## Streamlined Requirements Process

Use TodoWrite to track: Pre-flight → Requirements → Technical → Plan → Generate → Validate

**Approach:** Pragmatic and efficient for smaller scope.

---

### Section 1: Problem & Solution

**If product brief exists:**
- Extract problem statement, proposed solution

**If NO brief:**
> "In 2-3 sentences:
> 1. What problem are you solving?
> 2. What's your solution?"

---

### Section 2: Requirements List

**Explain:**
> "For small projects, we keep requirements simple and actionable."

**Ask:** "What needs to be built? List the key features."

**Format as bulleted list:**
```
- Feature 1: Description with acceptance criteria
- Feature 2: Description with acceptance criteria
```

**Typical count:** 3-8 requirements

**Also ask:** "What is explicitly OUT of scope?"

---

### Section 3: Technical Approach

**Technology Stack:**
> "What technologies will you use?"

Format:
```
- **Language/Framework:** Python 3.11 + FastAPI
- **Database:** PostgreSQL 15
- **Hosting:** AWS (ECS + RDS)
- **Key Libraries:** SQLAlchemy, Pydantic, pytest
```

**Architecture Overview:**
> "At a high level, how does the system work?"

- Main components
- Data flow
- Key interactions

**Data Model (if applicable):**
> "What are the main data entities and relationships?"

**API Design (if applicable):**
> "What are the key API endpoints?"

Format:
```
- GET /api/users - List users
- POST /api/users - Create user
- GET /api/users/{id} - Get user
```

---

### Section 4: Implementation Plan

**Stories:**
> "Let's break this into implementable pieces. What are the 1-10 stories?"

**Level 0:** Single story encompassing everything

**Level 1:** Break into logical chunks (1-3 days each)

**Format:**
```
1. **Story Name** - What it delivers
2. **Story Name** - What it delivers
```

**Development Phases (optional for Level 1):**
> "What's the logical implementation order?"

---

### Section 5: Acceptance Criteria

> "How will you know it's complete? What must work?"

**Format as checklist:**
```
- [ ] Feature X works as described
- [ ] All tests pass
- [ ] Deployed to {environment}
- [ ] User can successfully {key action}
```

---

### Section 6: Non-Functional Requirements (Brief)

**Performance:**
> "Any performance requirements?"

**Security:**
> "Any security requirements?"

**Other:**
> "Anything else? (accessibility, browser support)"

---

### Section 7: Dependencies, Risks, Timeline

**Dependencies:**
> "What does this depend on?"

**Risks:**
> "What could go wrong? How to mitigate?"

Format:
```
- **Risk:** Description
  - **Mitigation:** Strategy
```

**Timeline:**
> "When do you want this done?"
> "Key milestones?"

---

## Generate Document

1. Load template if available
2. Substitute all variables
3. Save to `accbmad/2-planning/tech-spec-{project-name}-{date}.md`
4. Display summary:
   ```
   Tech Spec Created!

   - Requirements: {count}
   - Stories: {count}
   - Tech Stack: {stack}
   - Target: {date}
   ```

---

## Validation Checklist

```
[ ] Problem and solution clear
[ ] Requirements specific and testable
[ ] Tech stack defined
[ ] Stories broken down (if Level 1)
[ ] Acceptance criteria clear
[ ] Out of scope stated
```

**Ask:** "Please review. Is the tech spec complete?"

---

## Update Status

Update `accbmad/status.yaml`:
```yaml
tech_spec: "accbmad/2-planning/tech-spec-{project-name}-{date}.md"
last_updated: {date}
```

---

## Recommend Next Steps

**Level 0:**
```
Tech Spec complete!

Next: Create your story
Run /create-story for the single story.
Then: /dev-story to implement.
```

**Level 1:**
```
Tech Spec complete!

Next: Sprint Planning
Run /sprint-planning to organize stories.

Note: Level 1 can skip architecture and go straight to implementation.
```

---

## Tips

**Keep it lightweight:**
- Don't over-plan for small projects
- Focus on what's essential
- Get to implementation faster

**But be clear:**
- Requirements should still be testable
- Tech decisions documented
- Success criteria explicit

**Right-size:**
- Level 0: 1 page is fine
- Level 1: 2-3 pages maximum
- If you need more, use /prd instead

---

## Notes for LLMs

- Maintain pragmatic persona for small projects
- Move faster than PRD - less ceremony
- Still ensure clarity and testability
- Don't skip critical elements
- For Level 0, keep very simple (single story focus)
- For Level 1, provide just enough structure
- **Tech specs are for speed on small projects - don't over-engineer**

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| Project level > 1 | "Project level suggests PRD instead of tech-spec. Use `/prd`." | Switch to PRD workflow |
| No clear problem statement | "Cannot create tech spec without problem definition." | Clarify problem with user |
| Scope too large | "Scope exceeds tech-spec capacity (>10 stories). Use `/prd`." | Escalate to PRD |
| Missing success criteria | "Cannot complete without measurable success criteria." | Define criteria with user |
