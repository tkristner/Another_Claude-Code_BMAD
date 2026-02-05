# [Developer] QA Automate Workflow

**Goal:** Generate automated API and E2E tests for implemented code.

**Phase:** 4 - Implementation (Quality Assurance)

**Agent:** Developer

**Trigger keywords:** qa automate, generate tests, add tests, test coverage, write tests, automated tests

**Inputs:** Component path or directory to test

**Output:** Test files that pass, plus coverage summary

**Duration:** 15-45 minutes depending on scope

---

## Scope

This workflow generates tests ONLY. It does NOT:
- Perform code review (use `/code-review` for that)
- Validate story completion
- Fix implementation bugs

**Invoke:** `/qa-automate` or `/qa-automate path/to/component`

---

## When to Use This Workflow

Use this workflow when:
- Implementation is complete and needs test coverage
- Existing code lacks tests
- Adding tests to legacy code
- Preparing for CI/CD pipeline

---

## Workflow Steps

### Step 0: Detect Test Framework

**Objective:** Understand the project's test ecosystem.

1. **Check Package Manager**

   Look for dependencies in:
   - `package.json` (Node.js)
   - `requirements.txt` / `pyproject.toml` (Python)
   - `go.mod` (Go)
   - `Cargo.toml` (Rust)
   - `pom.xml` / `build.gradle` (Java)

2. **Identify Test Framework**

   | Stack | Common Frameworks |
   |-------|-------------------|
   | Node.js | Jest, Vitest, Mocha, Ava |
   | React/Vue | Jest, Vitest, Testing Library |
   | E2E | Playwright, Cypress, Puppeteer |
   | Python | Pytest, unittest |
   | Go | testing, testify |
   | Rust | cargo test |
   | Java | JUnit, TestNG |

3. **Check Existing Test Patterns**

   - Search for existing test files (`*.test.ts`, `*.spec.js`, `*_test.go`)
   - Study patterns used (describe/it, test(), etc.)
   - Note assertion libraries (expect, assert, chai)
   - Identify fixtures/mocks approach

4. **If No Framework Exists**

   - Analyze source code type (React, API, CLI, etc.)
   - Recommend appropriate framework
   - Ask user to confirm before proceeding
   - Install framework if approved

---

### Step 1: Identify Test Targets

**Objective:** Determine what to test.

**Options:**

1. **Specific Component**
   - User provides component/feature name
   - Focus test generation on that area

2. **Directory Scan**
   - User provides directory (e.g., `src/services/`)
   - Discover all testable units

3. **Auto-Discovery**
   - Scan codebase for:
     - API endpoints/routes
     - Service classes
     - Utility functions
     - UI components
   - Prioritize by coverage gaps

**Output:** List of targets with type:
```
Test Targets:
- api/auth.ts (API endpoints)
- services/UserService.ts (Business logic)
- components/LoginForm.tsx (UI component)
- utils/validation.ts (Utility functions)
```

---

### Step 2: Generate API Tests

**Objective:** Create comprehensive API tests.

**For each API endpoint:**

1. **Happy Path**
   - Valid request with expected response
   - Status code verification (200, 201, etc.)
   - Response structure validation

2. **Error Cases**
   - Invalid input (400)
   - Authentication failure (401)
   - Authorization failure (403)
   - Not found (404)
   - Server error handling (500)

3. **Edge Cases**
   - Empty request body
   - Missing required fields
   - Invalid data types
   - Boundary values

**Test Template (Example - Jest/Supertest):**

```typescript
describe('POST /api/users', () => {
  it('creates user with valid data', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Test' });

    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty('id');
    expect(response.body.email).toBe('test@example.com');
  });

  it('returns 400 for invalid email', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'invalid', name: 'Test' });

    expect(response.status).toBe(400);
    expect(response.body.error).toContain('email');
  });

  it('returns 401 without authentication', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Test' });

    expect(response.status).toBe(401);
  });
});
```

---

### Step 3: Generate E2E Tests

**Objective:** Test user workflows end-to-end.

**For each UI feature:**

1. **User Flow Focus**
   - Test complete user journeys
   - Not individual component behavior

2. **Semantic Locators**
   - Use roles: `getByRole('button', { name: 'Submit' })`
   - Use labels: `getByLabelText('Email')`
   - Use text: `getByText('Welcome')`
   - Avoid selectors: NO `.class` or `#id`

3. **User Interactions**
   - Click events
   - Form fills
   - Navigation
   - Keyboard input

4. **Visible Outcomes**
   - Assert what user sees
   - Check text content
   - Verify navigation occurred
   - Confirm feedback messages

**Test Template (Example - Playwright):**

```typescript
test('user can log in successfully', async ({ page }) => {
  await page.goto('/login');

  await page.getByLabel('Email').fill('user@example.com');
  await page.getByLabel('Password').fill('password123');
  await page.getByRole('button', { name: 'Sign In' }).click();

  await expect(page.getByText('Welcome back')).toBeVisible();
  await expect(page).toHaveURL('/dashboard');
});

test('shows error for invalid credentials', async ({ page }) => {
  await page.goto('/login');

  await page.getByLabel('Email').fill('user@example.com');
  await page.getByLabel('Password').fill('wrong');
  await page.getByRole('button', { name: 'Sign In' }).click();

  await expect(page.getByText('Invalid credentials')).toBeVisible();
});
```

---

### Step 4: Generate Unit Tests

**Objective:** Test individual functions and components.

**For utility functions:**
- Test pure function behavior
- Cover input variations
- Test edge cases (null, empty, boundary)
- Test error conditions

**For components:**
- Test rendering
- Test user interactions
- Test state changes
- Mock external dependencies

**Test Template (Example - Component):**

```typescript
describe('LoginForm', () => {
  it('renders email and password fields', () => {
    render(<LoginForm />);

    expect(screen.getByLabelText('Email')).toBeInTheDocument();
    expect(screen.getByLabelText('Password')).toBeInTheDocument();
  });

  it('calls onSubmit with form data', async () => {
    const handleSubmit = vi.fn();
    render(<LoginForm onSubmit={handleSubmit} />);

    await userEvent.type(screen.getByLabelText('Email'), 'test@example.com');
    await userEvent.type(screen.getByLabelText('Password'), 'password');
    await userEvent.click(screen.getByRole('button', { name: 'Submit' }));

    expect(handleSubmit).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password'
    });
  });

  it('shows validation error for empty email', async () => {
    render(<LoginForm />);

    await userEvent.click(screen.getByRole('button', { name: 'Submit' }));

    expect(screen.getByText('Email is required')).toBeInTheDocument();
  });
});
```

---

### Step 5: Run and Verify Tests

**Objective:** Ensure generated tests actually pass.

1. **Run Test Suite**

   ```bash
   npm test                    # Node.js
   pytest                      # Python
   go test ./...               # Go
   cargo test                  # Rust
   ```

2. **Handle Failures**

   For each failing test:
   - Analyze failure reason
   - Fix test if test is wrong
   - Report if implementation is wrong

3. **Check Coverage**

   ```bash
   npm test -- --coverage      # Jest
   pytest --cov                # Pytest
   go test -cover              # Go
   ```

4. **Iterate Until Green**

   All generated tests must pass before completion.

---

### Step 6: Create Summary

**Objective:** Document what was generated.

**Output Format:**

```markdown
# [Developer] Test Automation Summary

## Framework Detected
- Unit Tests: Vitest
- E2E Tests: Playwright
- Assertion: expect

## Generated Tests

### API Tests
| Endpoint | Test File | Tests | Status |
|----------|-----------|-------|--------|
| POST /api/users | tests/api/users.spec.ts | 5 | Passing |
| GET /api/users/:id | tests/api/users.spec.ts | 3 | Passing |

### E2E Tests
| Flow | Test File | Tests | Status |
|------|-----------|-------|--------|
| User Login | tests/e2e/login.spec.ts | 4 | Passing |
| User Registration | tests/e2e/register.spec.ts | 3 | Passing |

### Unit Tests
| Component | Test File | Tests | Status |
|-----------|-----------|-------|--------|
| LoginForm | tests/components/LoginForm.spec.tsx | 6 | Passing |
| validation utils | tests/utils/validation.spec.ts | 8 | Passing |

## Coverage Summary
- Statements: 82%
- Branches: 75%
- Functions: 88%
- Lines: 81%

## Files Created
- tests/api/users.spec.ts
- tests/e2e/login.spec.ts
- tests/e2e/register.spec.ts
- tests/components/LoginForm.spec.tsx
- tests/utils/validation.spec.ts

## Next Steps
- Run tests in CI pipeline
- Add more edge case coverage
- Consider integration tests for complex flows
```

---

## Best Practices

**Do:**
- Use standard test framework APIs
- Focus on happy path + critical errors
- Write readable, maintainable tests
- Run tests to verify they pass
- Match existing test patterns in project
- Use semantic locators for UI tests
- Mock external dependencies

**Avoid:**
- Complex fixture composition
- Over-engineering test utilities
- Unnecessary abstractions
- Testing implementation details
- Brittle selectors (classes, IDs)
- Tests that depend on each other

---

## Example Session

```
User: /qa-automate src/services/

QA Automate: Detecting test framework...

Found:
- Framework: Vitest + Testing Library
- E2E: Playwright
- Pattern: describe/it with expect assertions

Scanning src/services/ for test targets...

Test Targets:
1. AuthService.ts - Authentication logic
2. UserService.ts - User CRUD operations
3. EmailService.ts - Email sending

Generating tests...

[1/3] AuthService tests...
- login() - 4 tests
- logout() - 2 tests
- validateToken() - 3 tests
Created: tests/services/AuthService.spec.ts

[2/3] UserService tests...
- createUser() - 5 tests
- getUser() - 3 tests
- updateUser() - 4 tests
- deleteUser() - 3 tests
Created: tests/services/UserService.spec.ts

[3/3] EmailService tests...
- sendEmail() - 3 tests
- validateEmail() - 4 tests
Created: tests/services/EmailService.spec.ts

Running tests...

✓ tests/services/AuthService.spec.ts (9 tests)
✓ tests/services/UserService.spec.ts (15 tests)
✓ tests/services/EmailService.spec.ts (7 tests)

All 31 tests passing!

Coverage: 84% statements, 78% branches

# [Developer] Test Automation Summary

## Generated Tests
- 3 test files created
- 31 tests total
- 100% passing

## Coverage Impact
- Before: 52%
- After: 84%
- Improvement: +32%

Done! Tests generated and verified.
```

---

## Integration Points

- **dev-story workflow:** Called after implementation
- **quick-dev workflow:** Can generate tests for changes
- **CI/CD:** Run generated tests in pipeline
- **Coverage tools:** Verify coverage thresholds

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No test framework detected | "Cannot detect test framework. Please specify." | Configure test framework |
| No source files found | "No source files found in specified path." | Check path |
| Tests consistently fail | "Generated tests failing. May indicate bugs." | Review implementation |
| No package.json or config | "Cannot determine project structure." | Initialize project |

---

## Tips for LLMs

- ALWAYS detect existing framework first - don't assume
- Match existing test patterns in the project
- Run tests before marking complete - they must pass
- Use semantic locators for UI tests, never CSS selectors
- Mock external dependencies (APIs, databases)
- Test error paths, not just happy path
- Keep tests simple and readable
- One assertion focus per test when possible
- Group related tests with describe blocks
