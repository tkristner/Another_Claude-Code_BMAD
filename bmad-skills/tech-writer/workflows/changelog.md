# [Tech Writer] Changelog Workflow

**Goal:** Maintain accurate changelog and release notes

**Phase:** Cross-phase (Documentation)

**Agent:** Tech Writer

**Trigger keywords:** changelog, release notes, version history, what's new

**Inputs:** Git commits, PRs, issues

**Output:** Updated CHANGELOG.md

**Duration:** 15-30 minutes

---

## When to Use

- Before releasing new version
- After significant changes merged
- Preparing release notes
- Documenting breaking changes

**Invoke:** `/changelog`

---

## Pre-Flight

1. **Check existing changelog** - Understand format in use
2. **Identify version** - What version is being released?
3. **Gather changes** - Commits since last release
4. **Categorize changes** - Added, Changed, Fixed, etc.

---

## Changelog Format

Follow [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
# [Tech Writer] Changelog

## [Unreleased]

## [1.3.0] - 2026-02-04

### Added
- New feature description (#123)

### Changed
- Updated behavior description (#124)

### Deprecated
- Feature that will be removed

### Removed
- Feature that was removed

### Fixed
- Bug fix description (#125)

### Security
- Security fix description (#126)
```

---

## Workflow Steps

### Step 1: Gather Changes

```bash
# [Tech Writer] Get commits since last tag
git log v1.1.0..HEAD --oneline

# [Tech Writer] Get merged PRs
gh pr list --state merged --base main
```

### Step 2: Categorize Changes

| Category | Description | Example |
|----------|-------------|---------|
| Added | New features | "Add user export feature" |
| Changed | Behavior changes | "Update rate limiting logic" |
| Deprecated | Soon-to-be-removed | "Deprecate v1 API" |
| Removed | Removed features | "Remove legacy auth" |
| Fixed | Bug fixes | "Fix login timeout" |
| Security | Security patches | "Fix XSS vulnerability" |

### Step 3: Write Entries

**Good changelog entry:**
```markdown
- Add user data export to CSV and JSON formats (#234)
```

**Bad changelog entry:**
```markdown
- Fixed stuff
- Updates
- Merged PR #234
```

**Guidelines:**
- Start with verb (Add, Fix, Update, Remove)
- Be specific about what changed
- Include issue/PR reference
- Explain impact for breaking changes

### Step 4: Update Changelog

Use template: [changelog.template.md](../templates/changelog.template.md)

1. Move [Unreleased] items to new version section
2. Add new version header with date
3. Update comparison links at bottom
4. Review for completeness

---

## Breaking Changes

For breaking changes, include migration guide:

```markdown
### Changed

- **BREAKING:** Renamed `oldFunction` to `newFunction`

  **Migration:** Replace all calls to `oldFunction()` with `newFunction()`.
  The parameters remain the same.
```

---

## Version Numbering

Follow [Semantic Versioning](https://semver.org/):

| Change Type | Version Bump | Example |
|-------------|--------------|---------|
| Breaking changes | Major (X.0.0) | 1.0.0 → 2.0.0 |
| New features | Minor (0.X.0) | 1.0.0 → 1.1.0 |
| Bug fixes | Patch (0.0.X) | 1.0.0 → 1.0.1 |

---

## Definition of Done

- [ ] All changes since last release captured
- [ ] Changes properly categorized
- [ ] Issue/PR references included
- [ ] Breaking changes clearly marked
- [ ] Version number correct
- [ ] Date is accurate

---

## HALT Conditions

Stop the workflow and notify user if:

| Condition | Message | Recovery |
|-----------|---------|----------|
| No git history | "Cannot gather changes without git history." | Initialize git or provide commits |
| No version specified | "Cannot update changelog without target version." | Specify version number |
| No changes found | "No changes found since last release." | Verify commits exist |
