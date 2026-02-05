# [Tech Writer] API Documentation Workflow

**Goal:** Generate comprehensive API reference documentation

**Phase:** Cross-phase (Documentation)

**Agent:** Tech Writer

**Trigger keywords:** api docs, api documentation, document api, api reference, endpoint docs

**Inputs:** Codebase with API endpoints, OpenAPI spec (optional)

**Output:** Complete API documentation

**Duration:** 30-60 minutes

---

## When to Use

- After implementing API endpoints
- When onboarding new developers
- Before releasing public API
- When API changes significantly

**Invoke:** `/api-docs` or `/api-documentation`

---

## Pre-Flight

1. **Identify API source** - Routes files, controllers, OpenAPI spec
2. **Check existing docs** - Don't duplicate existing documentation
3. **Determine output format** - Markdown, OpenAPI, both
4. **Identify audience** - Internal developers vs external consumers

---

## Workflow Steps

### Step 1: Discover Endpoints

Scan codebase for API routes:

```
Locations to check:
- routes/*.js, routes/*.ts
- controllers/*
- app.js, server.js, index.js
- openapi.yaml, swagger.json
```

Extract for each endpoint:
- HTTP method (GET, POST, PUT, DELETE)
- Path with parameters
- Handler function
- Middleware (auth, validation)

### Step 2: Document Each Endpoint

For each endpoint, capture:

**Basic Info:**
- Method and path
- Description of purpose
- Authentication requirements

**Request:**
- Path parameters
- Query parameters
- Request body schema
- Headers required

**Response:**
- Success response (status, body)
- Error responses
- Example responses

### Step 3: Generate Documentation

Use template: [api-reference.template.md](../templates/api-reference.template.md)

**Structure:**
```markdown
# [Tech Writer] API Reference

## Authentication
[How to authenticate]

## Base URL
[API base URL]

## Endpoints

### [Resource Name]

#### GET /resource
[Description]

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|

**Response:**
```json
{example}
```
```

### Step 4: Validate Documentation

- [ ] All endpoints documented
- [ ] Examples are valid JSON
- [ ] Authentication explained
- [ ] Error codes listed
- [ ] No placeholder content

---

## Output

Save to: `docs/api-reference.md` or `docs/api/`

---

## Definition of Done

- [ ] All endpoints discovered and documented
- [ ] Request/response examples provided

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No API found | "Cannot find API endpoints to document." | Verify API exists |
| No authentication info | "API authentication not documented." | Define auth method |
| Invalid examples | "API examples contain syntax errors." | Fix example syntax |
- [ ] Authentication section complete
- [ ] Error handling documented
- [ ] Documentation renders correctly
