# [Orchestrator] Generate Project Context Workflow

**Goal:** Analyze existing codebase and generate comprehensive context for AI agents, ensuring consistent code generation that follows established project patterns.

**Your Role:** You are a technical facilitator and codebase analyst who discovers patterns from existing code and translates them into actionable rules for AI agents.

**Phase:** Pre-Phase 1 (Brownfield Setup) or Phase 3 (Solutioning)

**Agent:** BMAD Orchestrator

**Trigger keywords:** generate project context, analyze codebase, brownfield setup, project context, ai rules, code conventions, understand codebase, reverse engineer, existing project, implementation rules, agent guidelines

**Inputs:** Existing codebase

**Output:** `docs/project-context.md`

**Duration:** 15-30 minutes

---

## When to Use This Workflow

**Primary Use Cases:**
- Starting BMAD on an existing (brownfield) project
- Onboarding AI agents to legacy code
- Creating documentation from existing code
- Understanding an unfamiliar codebase
- Ensuring AI-generated code matches project conventions

**Invoke:** `/generate-project-context` or `/analyze-codebase`

**Not needed when:**
- Greenfield project with no existing code
- Project already has comprehensive `project-context.md`
- Simple single-file changes

---

## Pre-Flight

1. **Check for existing context:**
   ```bash
   find . -name "project-context.md" -type f 2>/dev/null | head -5
   ```

   If found:
   > Found existing project context at `[path]`. Would you like to:
   > [U] Update existing file
   > [N] Create new file
   > [R] Review existing and decide

2. **Verify project exists:**
   Confirm there's actual code to analyze (not an empty directory).

---

## Workflow Steps

### Step 1: Technology Stack Detection

**Objective:** Identify the project's primary technology stack from package files and configurations.

**Auto-detect from files:**

| File | Indicates | Primary Language |
|------|-----------|------------------|
| `package.json` | Node.js project | JavaScript/TypeScript |
| `requirements.txt` / `pyproject.toml` / `setup.py` | Python project | Python |
| `go.mod` | Go project | Go |
| `Cargo.toml` | Rust project | Rust |
| `pom.xml` / `build.gradle` / `build.gradle.kts` | Java/Kotlin project | Java/Kotlin |
| `composer.json` | PHP project | PHP |
| `Gemfile` | Ruby project | Ruby |
| `*.csproj` / `*.sln` | .NET project | C# |
| `mix.exs` | Elixir project | Elixir |

**Scan commands:**
```bash
# [Orchestrator] List root files to identify project type
ls -la

# [Orchestrator] Check for multiple stacks (monorepo)
find . -maxdepth 3 \( -name "package.json" -o -name "requirements.txt" -o -name "go.mod" -o -name "Cargo.toml" -o -name "pom.xml" \) 2>/dev/null
```

**Extract for each detected stack:**
- Language version requirements
- Framework in use (React, Django, Gin, Actix, Spring, etc.)
- Key dependencies with versions
- Dev dependencies (testing, linting, formatting)

**Example extractions:**

**Node.js/TypeScript:**
```bash
# [Orchestrator] Get Node version if specified
grep -E '"node"|"engines"' package.json 2>/dev/null || true
cat .nvmrc 2>/dev/null || cat .node-version 2>/dev/null || true

# [Orchestrator] Get framework
grep -E '"next"|"react"|"vue"|"express"|"fastify"|"nest"' package.json 2>/dev/null || true

# [Orchestrator] Check for TypeScript
test -f tsconfig.json && echo "TypeScript project"
```

**Python:**
```bash
# [Orchestrator] Get Python version
grep -E "python|requires-python" pyproject.toml 2>/dev/null || true
cat .python-version 2>/dev/null || true

# [Orchestrator] Get framework
grep -iE "django|flask|fastapi|tornado|starlette" requirements.txt pyproject.toml 2>/dev/null || true
```

**Go:**
```bash
# [Orchestrator] Get Go version
head -5 go.mod 2>/dev/null || true

# [Orchestrator] Get key dependencies
grep -E "gin|echo|fiber|chi|gorilla" go.mod 2>/dev/null || true
```

**Rust:**
```bash
# [Orchestrator] Get Rust edition/version
grep -E "edition|rust-version" Cargo.toml 2>/dev/null || true

# [Orchestrator] Get framework
grep -E "actix|axum|rocket|warp|tokio" Cargo.toml 2>/dev/null || true
```

**Java:**
```bash
# [Orchestrator] Get Java version
grep -E "<java.version>|<maven.compiler" pom.xml 2>/dev/null || true
grep -E "sourceCompatibility|targetCompatibility" build.gradle* 2>/dev/null || true

# [Orchestrator] Get framework
grep -E "spring|quarkus|micronaut" pom.xml build.gradle* 2>/dev/null || true
```

**Present discovery:**
```
## Technology Stack Detected

**Primary Language:** [language] [version]
**Framework:** [framework] [version]
**Package Manager:** [npm/yarn/pnpm/pip/cargo/go/maven/gradle]

**Key Dependencies:**
- [dep1] - [purpose]
- [dep2] - [purpose]

Is this accurate? [C] Continue | [E] Edit
```

---

### Step 2: Project Structure Analysis

**Objective:** Understand how code is organized in this project.

**Directory patterns to detect:**
```
src/           -> Source code location
lib/           -> Library code
app/           -> Application code (Rails, Next.js)
pkg/           -> Go packages
internal/      -> Go internal packages
cmd/           -> Go entry points
tests/ or __tests__/ or test/ -> Test location
spec/          -> Test location (Ruby)
docs/          -> Documentation
config/ or conf/ -> Configuration
scripts/       -> Utility scripts
utils/ or helpers/ -> Utility modules
components/    -> UI components
pages/ or views/ -> Page/view components
api/ or routes/ -> API definitions
models/        -> Data models
services/      -> Business logic services
repositories/  -> Data access layer
```

**Scan commands:**
```bash
# [Orchestrator] List top-level structure
ls -la

# [Orchestrator] Find source directories
find . -maxdepth 2 -type d \( -name "src" -o -name "lib" -o -name "app" -o -name "pkg" -o -name "cmd" \) 2>/dev/null

# [Orchestrator] Count files by type
find . -type f -name "*.ts" 2>/dev/null | wc -l
find . -type f -name "*.tsx" 2>/dev/null | wc -l
find . -type f -name "*.js" 2>/dev/null | wc -l
find . -type f -name "*.py" 2>/dev/null | wc -l
find . -type f -name "*.go" 2>/dev/null | wc -l
find . -type f -name "*.rs" 2>/dev/null | wc -l
find . -type f -name "*.java" 2>/dev/null | wc -l
```

**Code organization patterns to identify:**
- **Flat vs. nested** - Are modules shallow or deeply nested?
- **Feature-based vs. layer-based** - Organized by feature (user/, product/) or layer (models/, services/)?
- **Monorepo vs. single-package** - Multiple packages in one repo?
- **Domain-driven design** - Bounded contexts, aggregates?

**Multi-Stack Project Detection:**

Many projects use multiple technologies (e.g., Python backend + TypeScript frontend, Go services + Python ML). Detect this pattern:

```bash
# [Orchestrator] Count files by language to identify multi-stack
echo "TypeScript/JavaScript: $(find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) 2>/dev/null | wc -l)"
echo "Python: $(find . -type f -name "*.py" 2>/dev/null | wc -l)"
echo "Go: $(find . -type f -name "*.go" 2>/dev/null | wc -l)"
echo "Rust: $(find . -type f -name "*.rs" 2>/dev/null | wc -l)"
echo "Java: $(find . -type f -name "*.java" 2>/dev/null | wc -l)"

# [Orchestrator] Check for multiple package managers
ls package.json requirements.txt pyproject.toml go.mod Cargo.toml pom.xml 2>/dev/null
```

**When multiple stacks detected:**

1. **Identify stack boundaries** - Which directories use which stack?
   ```bash
   # Find where each stack lives
   find . -name "package.json" -exec dirname {} \; 2>/dev/null
   find . -name "requirements.txt" -o -name "pyproject.toml" -exec dirname {} \; 2>/dev/null
   find . -name "go.mod" -exec dirname {} \; 2>/dev/null
   ```

2. **Present findings to user:**
   ```
   Multi-stack project detected:

   | Stack | Location | Files |
   |-------|----------|-------|
   | TypeScript/React | frontend/ | 47 |
   | Python/FastAPI | backend/ | 32 |
   | Go | services/auth/ | 15 |

   How would you like to proceed?
   [A] Generate unified context (all stacks in one file)
   [S] Generate separate context per stack
   [P] Focus on primary stack only (specify which)
   ```

3. **For unified context** - Create sections per stack in the output:
   - "## TypeScript/Frontend Conventions"
   - "## Python/Backend Conventions"
   - "## Go/Services Conventions"

4. **For separate contexts** - Generate:
   - `docs/project-context-frontend.md`
   - `docs/project-context-backend.md`
   - `docs/project-context.md` (index linking to others)

**Monorepo Detection:**

If multiple package files found at different depths, the project may be a monorepo:
```bash
# [Orchestrator] Check for monorepo tooling
find . -name "lerna.json" -o -name "pnpm-workspace.yaml" -o -name "nx.json" -o -name "turbo.json" 2>/dev/null

# [Orchestrator] Check for packages/apps directories
ls -d packages/ apps/ modules/ services/ 2>/dev/null
```

For monorepos, offer to generate context for each sub-project or focus on the primary application.

---

### Step 3: Coding Convention Detection

**Objective:** Extract naming and style conventions from existing code.

**Analyze for:**

| Convention | Detection Method |
|------------|------------------|
| File naming | Scan filenames (kebab-case, PascalCase, snake_case, camelCase) |
| Variable naming | Parse code samples |
| Indentation | Check whitespace (2 spaces, 4 spaces, tabs) |
| Quotes | Single vs. double quotes (JS/TS/Python) |
| Semicolons | With or without (JS/TS) |
| Import style | Named vs. default, absolute vs. relative, aliases |
| Line length | Check formatter config or measure existing lines |

**Detection commands:**

**File naming:**
```bash
# [Orchestrator] Sample filenames in src
ls src/ 2>/dev/null | head -20 || ls lib/ 2>/dev/null | head -20 || ls app/ 2>/dev/null | head -20
```

**Indentation (for JS/TS/Python):**
```bash
# [Orchestrator] Check .editorconfig if exists
cat .editorconfig 2>/dev/null | grep -E "indent_size|indent_style" || true

# [Orchestrator] Check prettier config
cat .prettierrc* 2>/dev/null | grep -E "tabWidth|useTabs" || true

# [Orchestrator] Sample actual files
head -50 src/**/*.ts 2>/dev/null | head -50 || head -50 src/**/*.py 2>/dev/null | head -50
```

**Quote style (JS/TS):**
```bash
cat .prettierrc* 2>/dev/null | grep -E "singleQuote" || true
cat .eslintrc* 2>/dev/null | grep -E "quotes" || true
```

**Import style:**
```bash
# [Orchestrator] Sample imports from source files
grep -h "^import" src/**/*.ts 2>/dev/null | head -20 || true
grep -h "^from" src/**/*.py 2>/dev/null | head -20 || true
```

---

### Step 4: Testing Framework Detection

**Objective:** Identify testing setup and conventions.

**Detect from config files:**

| Config File | Test Framework |
|-------------|----------------|
| `jest.config.*` | Jest |
| `vitest.config.*` | Vitest |
| `pytest.ini` / `pyproject.toml [tool.pytest]` | pytest |
| `*_test.go` pattern | Go testing |
| `Cargo.toml` with `[dev-dependencies]` | Rust testing |
| `*Test.java` / `*Spec.java` | JUnit/TestNG |
| `.rspec` | RSpec |

**Detection commands:**
```bash
# [Orchestrator] Check for test config files
ls jest.config.* vitest.config.* pytest.ini .rspec 2>/dev/null || true

# [Orchestrator] Check package.json for test script and dependencies
cat package.json 2>/dev/null | grep -E '"test"|jest|vitest|mocha|ava' || true

# [Orchestrator] Check pyproject.toml for pytest
cat pyproject.toml 2>/dev/null | grep -E "\[tool.pytest\]|pytest" || true

# [Orchestrator] Find test files to determine pattern
find . -type f \( -name "*.test.*" -o -name "*.spec.*" -o -name "*_test.*" -o -name "test_*" \) 2>/dev/null | head -10
```

**Extract:**
- Test framework name
- Test file naming convention (`*.test.ts`, `*_test.py`, `*Test.java`)
- Test directory structure (co-located, separate `/tests` folder)
- Coverage requirements (if configured)
- Mock/stub patterns

---

### Step 5: Quality Tool Detection

**Objective:** Identify linters, formatters, and type checkers.

**Detect from config files:**

**Linters:**
| Config File | Linter |
|-------------|--------|
| `.eslintrc*` / `eslint.config.*` | ESLint |
| `ruff.toml` / `pyproject.toml [tool.ruff]` | Ruff |
| `.flake8` | Flake8 |
| `pylint.rc` | Pylint |
| `.golangci.yml` | golangci-lint |
| `clippy.toml` | Clippy (Rust) |
| `checkstyle.xml` | Checkstyle (Java) |

**Formatters:**
| Config File | Formatter |
|-------------|-----------|
| `.prettierrc*` | Prettier |
| `pyproject.toml [tool.black]` | Black |
| `rustfmt.toml` | rustfmt |
| `.editorconfig` | EditorConfig |

**Type Checkers:**
| Config File | Type Checker |
|-------------|--------------|
| `tsconfig.json` | TypeScript |
| `mypy.ini` / `pyproject.toml [tool.mypy]` | mypy |
| `pyrightconfig.json` | Pyright |

**Detection commands:**
```bash
# [Orchestrator] List config files
ls .eslintrc* .prettierrc* tsconfig.json ruff.toml mypy.ini .golangci.yml rustfmt.toml 2>/dev/null || true

# [Orchestrator] Check package.json scripts
cat package.json 2>/dev/null | grep -E '"lint"|"format"|"typecheck"' || true

# [Orchestrator] Check pre-commit hooks
cat .pre-commit-config.yaml 2>/dev/null | head -30 || true
cat .husky/pre-commit 2>/dev/null || true
```

**Extract key rules from configs** (sample important settings).

---

### Step 6: Critical Pattern Extraction

**Objective:** Identify key patterns that AI agents must follow.

**Analyze code samples for:**

**Error Handling:**
```bash
# [Orchestrator] Find error handling patterns
grep -rh "catch\|except\|Error\|panic\|unwrap" --include="*.ts" --include="*.py" --include="*.go" --include="*.rs" . 2>/dev/null | head -20
```

**Logging:**
```bash
# [Orchestrator] Find logging patterns
grep -rh "console.log\|logger\|log\.\|logging\.\|slog\.\|tracing::" --include="*.ts" --include="*.py" --include="*.go" --include="*.rs" . 2>/dev/null | head -10
```

**Authentication patterns:**
```bash
# [Orchestrator] Find auth-related code
grep -rl "auth\|jwt\|session\|token" --include="*.ts" --include="*.py" --include="*.go" . 2>/dev/null | head -5
```

**Database access patterns:**
```bash
# [Orchestrator] Find ORM/database patterns
grep -rh "prisma\|typeorm\|sequelize\|sqlalchemy\|gorm\|diesel" --include="*.ts" --include="*.py" --include="*.go" --include="*.rs" . 2>/dev/null | head -10
```

**API patterns:**
```bash
# [Orchestrator] Find API route definitions
grep -rh "router\.\|app\.\|@Get\|@Post\|@app.route\|r\." --include="*.ts" --include="*.py" --include="*.go" --include="*.java" . 2>/dev/null | head -15
```

---

### Step 7: Code Sample Analysis

**Objective:** Read representative files to validate detected patterns.

1. **Find most-edited files** (indicates core code):
   ```bash
   # Git repos - find frequently modified files
   git log --pretty=format: --name-only --since="6 months ago" 2>/dev/null | sort | uniq -c | sort -rn | head -15

   # Non-git repos - find most recently modified files
   find . -type f \( -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.java" \) -mtime -30 2>/dev/null | head -15
   ```

2. **Sample 3-5 files** from different areas of the codebase.

3. **Extract actual patterns** from these files:
   - Confirm naming conventions
   - Identify common imports
   - Note error handling approach
   - Document logging patterns

---

### Step 8: User Validation

**Objective:** Present findings for confirmation and correction.

```
## Project Analysis Complete

### Technology Stack
- **Language:** TypeScript 5.3 (Node.js 20)
- **Framework:** Next.js 14 (App Router)
- **Database:** PostgreSQL with Prisma ORM
- **Testing:** Jest with React Testing Library

### Code Conventions
- **File naming:** kebab-case (e.g., user-profile.tsx)
- **Component naming:** PascalCase (e.g., UserProfile)
- **Function naming:** camelCase (e.g., getUserById)
- **Indentation:** 2 spaces
- **Quotes:** Single quotes
- **Semicolons:** No

### Testing
- **Location:** `__tests__/` folders co-located with source
- **Pattern:** `*.test.tsx`, `*.test.ts`
- **Coverage:** 80% threshold configured

### Quality Tools
- **Linter:** ESLint with strict TypeScript rules
- **Formatter:** Prettier (2 spaces, single quotes)
- **Type checking:** TypeScript strict mode

### Critical Patterns Detected
1. Error handling: Custom `AppError` class with typed error codes
2. Logging: Winston logger with structured JSON format
3. Auth: NextAuth.js with JWT strategy
4. Database: Prisma with soft deletes pattern

---

Are these findings accurate?
[Y] Yes, generate context file
[E] Edit findings (I'll make corrections)
[A] Add more rules manually
```

---

### Step 9: Generate Context Document

**Objective:** Assemble findings into structured document.

1. **Use template** from [templates/project-context.template.md](../templates/project-context.template.md)

2. **Fill in all detected values**

3. **Add AI-specific rules:**
   - MUST follow rules (critical for consistency)
   - MUST NOT do rules (anti-patterns to avoid)
   - Patterns to match (examples to emulate)

4. **Save file:**
   - Primary location: `docs/project-context.md`
   - Alternative: Project root if no `docs/` directory

---

### Step 10: Completion Summary

**Objective:** Present summary and integration guidance.

```
## Project Context Generated

**File:** docs/project-context.md

**Sections Included:**
- Technology Stack & Versions
- Code Conventions
- Testing Rules
- Quality Tools
- Critical Rules for AI Agents
- Project-Specific Notes

**Stats:**
- 15 conventions documented
- 8 critical AI rules defined
- 5 anti-patterns flagged

**Usage:**
AI agents should load this file at the start of implementation tasks
to understand project conventions.

**Integration:**
- Add reference to CLAUDE.md or .cursorrules
- Agents load automatically via /workflow-init detection

**Next Steps:**
[S] Start workflow-init (if BMAD not initialized)
[D] Start development with /quick-dev or /dev-story
[R] Review and refine context file
```

---

## Integration Points

### With `/workflow-init`

When initializing BMAD on existing project:

```
User: /workflow-init

Orchestrator: I detect this is an existing project with code.

Found:
- 47 TypeScript files
- package.json (Next.js 14)
- Existing tests in __tests__/

Would you like me to:
[A] Analyze codebase and generate project context first (recommended)
[S] Skip analysis and configure BMAD manually
[M] Manual configuration with guided questions
```

**If user selects [A]:**
1. Run full context generation workflow
2. Save to `docs/project-context.md`
3. Continue with BMAD initialization
4. Reference context in workflow recommendations

### With Developer Skill

Developer skill loads project-context.md before implementation:

```
Loading project context...
- Language: TypeScript 5.x
- Framework: Next.js 14
- Test framework: Jest
- Linting: ESLint with strict config

Following established patterns for implementation.
```

### With `/quick-dev` and `/dev-story`

Both workflows check for project context:
```bash
# [Orchestrator] Quick-dev pre-flight
test -f docs/project-context.md && cat docs/project-context.md
```

---

## Output Format

### project-context.md Structure

See [templates/project-context.template.md](../templates/project-context.template.md) for complete template.

Key sections:
1. **Technology Stack** - Runtime, framework, key dependencies
2. **Code Conventions** - Naming, style, imports
3. **Testing** - Framework, location, patterns
4. **Quality Tools** - Linters, formatters, type checkers
5. **Critical Rules for AI Agents** - MUST follow, MUST NOT, patterns
6. **Project-Specific Notes** - Unique considerations

---

## Subagent Strategy

> For comprehensive subagent patterns and examples, see [BMAD-SUBAGENT-PATTERNS.md](../BMAD-SUBAGENT-PATTERNS.md)

For large codebases, use parallel agents to analyze different aspects.

### Pattern: Parallel Analysis
**When:** Codebase has 50+ files or multiple languages
**Agents:** 3-4 parallel agents

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Analyze tech stack and dependencies | accbmad/outputs/tech-stack.md |
| Agent 2 | Analyze code conventions and patterns | accbmad/outputs/conventions.md |
| Agent 3 | Analyze testing and quality tools | accbmad/outputs/testing-quality.md |
| Agent 4 | Extract critical patterns from code samples | accbmad/outputs/critical-patterns.md |

**Coordination:**
1. Main context identifies project type and launches agents
2. Each agent writes findings to designated output file
3. Main context synthesizes results into unified project-context.md
4. User validates combined findings

### Example Subagent Prompt
```
Task: Analyze coding conventions in existing codebase
Context: This is a TypeScript/Next.js project

Objective: Extract naming conventions, code style, and import patterns

Steps:
1. Sample 5-10 source files from different directories
2. Identify file naming pattern (kebab-case, PascalCase, etc.)
3. Identify variable/function naming patterns
4. Check indentation and formatting
5. Document import style and organization

Output: Write findings to accbmad/outputs/conventions.md

Format findings as:
- File naming: [pattern] (examples: ...)
- Variables: [pattern] (examples: ...)
- Functions: [pattern] (examples: ...)
- Indentation: [spaces/tabs, count]
- Import style: [absolute/relative, aliases]
```

---

## Example Session

```
User: /generate-project-context

Orchestrator: I'll analyze your codebase to generate AI context.

## Step 1: Technology Stack Detection

Scanning project...
- Found: package.json (Node.js project)
- Found: tsconfig.json (TypeScript enabled)
- Found: next.config.js (Next.js framework)
- Found: prisma/schema.prisma (Prisma ORM)

Extracting versions...
- Node.js: 20.x (from .nvmrc)
- TypeScript: 5.3.3
- Next.js: 14.1.0
- Prisma: 5.8.0

## Step 2: Project Structure Analysis

Directory structure:
```
src/
├── app/           # Next.js App Router pages
├── components/    # React components
├── lib/           # Utility functions
├── services/      # Business logic
└── types/         # TypeScript types
prisma/
└── schema.prisma  # Database schema
```

Organization: Feature-based with layer separation

## Step 3: Coding Convention Detection

Analyzing 47 TypeScript files...
- File naming: kebab-case (user-profile.tsx, api-client.ts)
- Component naming: PascalCase (UserProfile, ApiClient)
- Function naming: camelCase (getUserById, formatDate)
- Indentation: 2 spaces
- Quotes: single quotes
- Semicolons: no
- Import style: absolute with @/ alias

## Step 4: Testing Framework Detection

Found: jest.config.ts
- Framework: Jest with React Testing Library
- Location: __tests__ folders (co-located)
- Pattern: *.test.ts, *.test.tsx
- Coverage: 80% threshold

## Step 5: Quality Tool Detection

- Linter: ESLint (eslint.config.mjs)
  - Strict TypeScript rules enabled
  - React hooks rules
- Formatter: Prettier
  - 2 spaces, single quotes, no semicolons
- Type checking: TypeScript strict mode

## Step 6: Critical Pattern Extraction

Error handling:
```typescript
// Custom AppError used throughout
throw new AppError('NOT_FOUND', 'User not found')
```

Logging:
```typescript
// Winston with structured logging
logger.info('User created', { userId, email })
```

Database:
```typescript
// Prisma with soft deletes
where: { deletedAt: null }
```

---

Do these findings look accurate?
[Y] Yes, generate context file
[E] Edit findings
[A] Add more rules manually

User: Y

## Step 9: Generating Context Document

Writing to docs/project-context.md...

---

## Project Context Generated

**File:** docs/project-context.md

**Summary:**
- Technology: TypeScript 5.3, Next.js 14, Prisma 5.8
- 12 coding conventions documented
- 8 critical AI rules defined
- 3 anti-patterns flagged

AI agents will now follow these patterns when implementing code.

**Next Steps:**
[S] Run /workflow-init to complete BMAD setup
[D] Start development with /quick-dev
[R] Review and refine context file
```

---

## Example: Multi-Stack Project

```
User: /generate-project-context

Orchestrator: I'll analyze your codebase to generate AI context.

## Step 1: Technology Stack Detection

Scanning project...

**Multi-stack project detected:**

| Stack | Location | Files | Package Manager |
|-------|----------|-------|-----------------|
| TypeScript/React | frontend/ | 47 | npm |
| Python/FastAPI | backend/ | 32 | poetry |
| Go | services/auth/ | 15 | go modules |

How would you like to proceed?
[A] Generate unified context (all stacks in one file) - recommended
[S] Generate separate context per stack
[P] Focus on primary stack only

User: A

## Analyzing Each Stack...

### Frontend (TypeScript/React)
- Framework: React 18 with Vite
- Testing: Vitest + Testing Library
- Linting: ESLint + Prettier
- Conventions: kebab-case files, PascalCase components

### Backend (Python/FastAPI)
- Framework: FastAPI 0.109
- Testing: pytest + httpx
- Linting: Ruff + Black
- Conventions: snake_case everywhere, type hints required

### Auth Service (Go)
- Framework: Chi router
- Testing: go test + testify
- Linting: golangci-lint
- Conventions: Go standard style

---

## Generated Unified Context

Writing to docs/project-context.md...

**File:** docs/project-context.md

**Sections:**
- Technology Stack (3 stacks documented)
- Frontend Conventions (TypeScript/React)
- Backend Conventions (Python/FastAPI)
- Services Conventions (Go)
- Shared Rules (API contracts, git workflow)

**Cross-Stack Rules Generated:**
1. API contracts defined in OpenAPI spec at `api/openapi.yaml`
2. All services log to stdout in JSON format
3. Environment variables prefixed by service name (FRONTEND_, BACKEND_, AUTH_)
4. Shared types generated from OpenAPI spec

AI agents will now follow stack-appropriate patterns based on working directory.
```

---

## Content Guidelines

**Keep it Lean:**
- Focus on unobvious rules
- Don't document what's obvious from code
- Prioritize rules that prevent mistakes

**Be Specific:**
- Include exact versions
- Use concrete examples
- Reference actual file paths

**Be Accurate:**
- Only document what's actually found
- Don't assume or invent patterns
- Allow user to correct misdetections

**Make it Actionable:**
- Every rule should guide AI behavior
- Include examples of correct usage
- Specify what to avoid

**Update Regularly:**
- Refresh when dependencies change
- Add rules when patterns emerge
- Remove outdated constraints

---

## HALT Conditions

**Stop and ask for guidance when:**

- Cannot determine primary language/framework
- Conflicting patterns detected (inconsistent codebase)
- No source files found (empty or config-only project)
- User indicates major inaccuracies in detection

**Never stop for:**

- Minor version misdetections (user can correct)
- Optional tool detection failures
- Missing test coverage configuration

---

## Notes for Claude

**Tool Usage:**
- Use Bash for file discovery and pattern extraction
- Use Glob to find specific file patterns
- Use Grep to search for code patterns
- Use Read to sample representative files
- Use Write to create project-context.md

**Key Principles:**
- This workflow is about **discovery, not creation**
- Never modify existing code
- Only document what's actually found
- Allow user to correct misdetections
- Output rules AI can follow

**Detection Priority:**
1. Package/manifest files (most reliable)
2. Config files (linters, formatters)
3. Actual code patterns (sampling)
4. Git history (most active files)

**Quality Checks:**
- All major sections populated
- Examples provided for conventions
- Critical rules are actionable
- User validated findings before saving

---

## Related Workflows

- `/workflow-init` - Initialize BMAD (may trigger this workflow)
- `/quick-spec` - May reference project context
- `/quick-dev` - Loads context before implementation
- `/dev-story` - Loads context before implementation
- `/architecture` - Architecture decisions complement context
