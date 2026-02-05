# [Tech Writer] README Generator Workflow

**Goal:** Create comprehensive project README files

**Phase:** Cross-phase (Documentation)

**Agent:** Tech Writer

**Trigger keywords:** readme, create readme, project readme, readme generator

**Inputs:** Project codebase, package files

**Output:** README.md file

**Duration:** 15-30 minutes

---

## When to Use

- Starting a new project
- Open-sourcing internal project
- README is outdated or missing
- Improving project discoverability

**Invoke:** `/readme` or `/readme-generator`

---

## Pre-Flight

1. **Analyze project** - Read package.json, go.mod, Cargo.toml, etc.
2. **Check existing README** - Preserve good content
3. **Identify project type** - Library, CLI, API, application
4. **Determine audience** - Developers, end users, both

---

## Workflow Steps

### Step 1: Gather Project Information

Read from project files:

| Source | Information |
|--------|-------------|
| package.json / go.mod | Name, version, dependencies |
| Project structure | Components, architecture |
| Existing docs | Features, usage patterns |
| Tests | Usage examples |
| CI config | Build/test commands |

### Step 2: Determine README Sections

**Required sections:**
- Project title and description
- Installation
- Basic usage
- License

**Recommended sections:**
- Features list
- Prerequisites
- Configuration
- API overview (if applicable)
- Contributing
- Changelog link

**Optional sections:**
- Badges (build status, coverage)
- Screenshots/demos
- Roadmap
- Acknowledgments

### Step 3: Generate Content

Use template: [readme.template.md](../templates/readme.template.md)

**Writing guidelines:**
- Lead with value proposition
- Show, don't just tell (include examples)
- Keep installation simple (copy-paste ready)
- Link to detailed docs for complex topics

### Step 4: Review and Polish

- [ ] Title is clear and descriptive
- [ ] Description explains the "why"
- [ ] Installation works (test it!)
- [ ] Examples are runnable
- [ ] Links are valid
- [ ] No placeholder content

---

## Output

Save to: `README.md` (project root)

---

## README Sections Template

```markdown
# [Tech Writer] Project Name

Brief description (1-2 sentences)

## Features

- Feature 1
- Feature 2

## Installation

```bash
npm install project-name
```

## Quick Start

```javascript
// Minimal working example
```

## Documentation

Link to full docs

## Contributing

How to contribute

## License

MIT (or applicable license)
```

---

## Definition of Done

- [ ] Project name and description clear
- [ ] Installation instructions work
- [ ] At least one usage example
- [ ] License specified
- [ ] No broken links

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No project context | "Cannot generate README without understanding the project." | Explore codebase first |
| No package/config file | "Cannot determine installation steps without package file." | Add package.json/etc. |
| Unknown project type | "Cannot determine project type from codebase." | Specify project type |
