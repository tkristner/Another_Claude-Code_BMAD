#!/bin/bash
# BMAD Legacy Migration Script
# Detects and migrates artifacts from legacy BMAD directories (docs/, bmad/, .bmad/)
# into the current accbmad/ structure.

set -euo pipefail

# Color output (matches init-project.sh conventions)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

BMAD_FOLDER="accbmad"
MODE=""
MANIFEST_FILE=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --detect)
      MODE="detect"
      shift
      ;;
    --execute)
      MODE="execute"
      shift
      ;;
    --manifest)
      MANIFEST_FILE="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 --detect | --execute --manifest <file>"
      echo ""
      echo "Modes:"
      echo "  --detect              Scan legacy directories and report found artifacts"
      echo "  --execute --manifest  Copy files listed in manifest to accbmad/"
      echo ""
      echo "Legacy directories scanned: docs/, bmad/, .bmad/"
      echo ""
      echo "Manifest format (one per line):"
      echo "  source_path|destination_path"
      echo ""
      echo "Examples:"
      echo "  $0 --detect"
      echo "  $0 --execute --manifest accbmad/tmp/migration-manifest.txt"
      exit 0
      ;;
    *)
      echo -e "${RED}Error: Unknown option $1${NC}"
      echo "Run with --help for usage information."
      exit 1
      ;;
  esac
done

if [ -z "$MODE" ]; then
  echo -e "${RED}Error: Must specify --detect or --execute${NC}"
  echo "Run with --help for usage information."
  exit 1
fi

# ─── Safety checks ──────────────────────────────────────────────────────────────

# Reject path traversal in a given path
check_path_safety() {
  local path="$1"
  if [[ "$path" == *".."* ]]; then
    echo -e "${RED}Error: Path traversal detected in: ${path}${NC}"
    exit 1
  fi
}

# ─── Pattern classification ─────────────────────────────────────────────────────

# Classify a file into a category and destination.
# Accepts a relative path within the legacy dir (e.g., "architecture/adrs/0001-foo.md").
# Prints: category|destination
#   - If destination ends with "/", caller appends the basename
#   - If destination is a full path (no trailing "/"), use as-is
# Returns 1 if no match.
classify_file() {
  local filepath="$1"
  local filename
  filename=$(basename "$filepath")
  local lower
  lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
  local lower_path
  lower_path=$(echo "$filepath" | tr '[:upper:]' '[:lower:]')

  # ── Exclude non-BMAD directories ──────────────────────────────────────────────
  # Skip scraped vendor docs, confidential files, screenshots, and other non-BMAD content
  if [[ "$lower_path" =~ ^(docs_|keygen_|confidential/|screenshots/|reports/) ]] \
     || [[ "$lower_path" =~ _docs_md/ ]]; then
    return 1
  fi

  # Status files (YAML) — check before .md filter
  if [[ "$lower" == *workflow-status.yaml || "$lower" == "status.yaml" \
     || "$lower" == "sprint-status.yaml" || "$lower" == *-status.yaml \
     || "$lower" == "sprint-docs.yaml" ]]; then
    echo "status|needs_transform"
    return 0
  fi

  # Only process markdown and yaml files beyond this point
  if [[ "$lower" != *.md && "$lower" != *.yaml && "$lower" != *.yml ]]; then
    return 1
  fi

  # Skip generic READMEs, .gitkeep, and PDFs
  if [[ "$lower" == "readme.md" || "$lower" == ".gitkeep" ]]; then
    return 1
  fi

  # ── Subdirectory-aware patterns (preserve relative subpath) ──────────────────

  # ADRs in any subdirectory (adr/, adrs/, archive/) → preserve under solutioning/adrs/
  if [[ "$lower_path" == */adrs/*.md || "$lower_path" == */adr/*.md \
     || "$lower_path" == adrs/*.md || "$lower_path" == adr/*.md ]]; then
    echo "adr|${BMAD_FOLDER}/3-solutioning/adrs/${filename}"
    return 0
  fi

  # Archived ADRs and architecture docs
  if [[ "$lower_path" == */archive/adr-*.md || "$lower_path" == archive/adr-*.md ]]; then
    echo "adr|${BMAD_FOLDER}/3-solutioning/adrs/archive/${filename}"
    return 0
  fi
  if [[ "$lower_path" == */archive/*architecture*.md || "$lower_path" == archive/*architecture*.md ]]; then
    echo "architecture|${BMAD_FOLDER}/3-solutioning/archive/${filename}"
    return 0
  fi

  # Operations docs
  if [[ "$lower_path" == */operations/*.md || "$lower_path" == operations/*.md ]]; then
    echo "operations|${BMAD_FOLDER}/outputs/operations/"
    return 0
  fi

  # Guides
  if [[ "$lower_path" == */guides/*.md || "$lower_path" == guides/*.md ]]; then
    echo "guide|${BMAD_FOLDER}/outputs/guides/"
    return 0
  fi

  # Reference docs
  if [[ "$lower_path" == */reference/*.md || "$lower_path" == reference/*.md ]]; then
    echo "reference|${BMAD_FOLDER}/context/"
    return 0
  fi

  # API docs
  if [[ "$lower_path" == */api/*.md || "$lower_path" == api/*.md \
     || "$lower_path" == */api/*.yaml || "$lower_path" == api/*.yaml ]]; then
    echo "api-docs|${BMAD_FOLDER}/outputs/"
    return 0
  fi

  # Integrations docs
  if [[ "$lower_path" == */integrations/*.md || "$lower_path" == integrations/*.md ]]; then
    echo "reference|${BMAD_FOLDER}/context/"
    return 0
  fi

  # Architecture subdirectory files (components/, data-flow, overview)
  # Extracts the subpath under architecture/ and preserves it
  if [[ "$lower_path" =~ (^|/)architecture/(.+\.md)$ ]]; then
    local arch_subpath="${BASH_REMATCH[2]}"
    echo "architecture|${BMAD_FOLDER}/3-solutioning/architecture/${arch_subpath}"
    return 0
  fi

  # Stories in subdirectory
  if [[ "$lower_path" == */stories/*.md || "$lower_path" == stories/*.md ]]; then
    echo "story|${BMAD_FOLDER}/4-implementation/stories/"
    return 0
  fi

  # Testing docs in subdirectory
  if [[ "$lower_path" == */testing/*.md || "$lower_path" == */tests/*.md \
     || "$lower_path" == testing/*.md || "$lower_path" == tests/*.md ]]; then
    echo "test-plan|${BMAD_FOLDER}/outputs/"
    return 0
  fi

  # ── Filename patterns (priority order) ───────────────────────────────────────

  # Stories (highest priority - specific pattern)
  if [[ "$lower" == story-*.md || "$lower" == story_*.md ]]; then
    echo "story|${BMAD_FOLDER}/4-implementation/stories/"
    return 0
  fi

  # Sprint plan
  if [[ "$lower" == sprint-plan*.md || "$lower" == sprint_plan*.md ]]; then
    echo "sprint-plan|${BMAD_FOLDER}/4-implementation/"
    return 0
  fi

  # PRD (check before generic spec)
  if [[ "$lower" == *prd*.md || "$lower" == *product-requirements*.md || "$lower" == *product_requirements*.md ]]; then
    echo "prd|${BMAD_FOLDER}/2-planning/"
    return 0
  fi

  # Architecture (top-level file)
  if [[ "$lower" == *architecture*.md ]]; then
    echo "architecture|${BMAD_FOLDER}/3-solutioning/"
    return 0
  fi

  # Implementation readiness report
  if [[ "$lower" == *implementation-readiness*.md || "$lower" == *readiness-report*.md ]]; then
    echo "readiness-report|${BMAD_FOLDER}/3-solutioning/"
    return 0
  fi

  # Solutioning gate check
  if [[ "$lower" == solutioning-gate-check*.md || "$lower" == *gate-check*.md ]]; then
    echo "readiness-report|${BMAD_FOLDER}/3-solutioning/"
    return 0
  fi

  # E2E test plans
  if [[ "$lower" == e2e-test*.md ]]; then
    echo "test-plan|${BMAD_FOLDER}/outputs/"
    return 0
  fi

  # Development guardrails — now part of BMAD package (installed to ~/.claude/)
  # Flag as package_managed so Claude can inform the user
  if [[ "$lower" == *guardrails*.md || "$lower" == *development-rules*.md ]]; then
    echo "package_managed|~/.claude/"
    return 0
  fi

  # UI/UX optimization analysis
  if [[ "$lower" == *optimization-analysis*.md ]]; then
    echo "research|${BMAD_FOLDER}/1-analysis/"
    return 0
  fi

  # Epics
  if [[ "$lower" == epics*.md || "$lower" == epic-*.md || "$lower" == epic_*.md ]]; then
    echo "epics|${BMAD_FOLDER}/2-planning/"
    return 0
  fi

  # Product brief / vision
  if [[ "$lower" == brief*.md || "$lower" == product-brief*.md || "$lower" == product_brief*.md \
     || "$lower" == product-vision*.md || "$lower" == product_vision*.md ]]; then
    echo "product-brief|${BMAD_FOLDER}/1-analysis/"
    return 0
  fi

  # UX / Design
  if [[ "$lower" == ux-*.md || "$lower" == ux_*.md || "$lower" == design-*.md || "$lower" == design_*.md ]]; then
    echo "ux-design|${BMAD_FOLDER}/2-planning/"
    return 0
  fi

  # Tech spec (after PRD check to avoid false matches)
  if [[ "$lower" == tech-spec*.md || "$lower" == tech_spec*.md || "$lower" == *spec*.md ]]; then
    echo "tech-spec|${BMAD_FOLDER}/2-planning/"
    return 0
  fi

  # Research
  if [[ "$lower" == research*.md ]]; then
    echo "research|${BMAD_FOLDER}/1-analysis/"
    return 0
  fi

  # Brainstorm
  if [[ "$lower" == brainstorm*.md ]]; then
    echo "brainstorm|${BMAD_FOLDER}/1-analysis/"
    return 0
  fi

  # Project context
  if [[ "$lower" == project-context*.md || "$lower" == project_context*.md ]]; then
    echo "project-context|${BMAD_FOLDER}/3-solutioning/"
    return 0
  fi

  # Review
  if [[ "$lower" == review-*.md || "$lower" == review_*.md ]]; then
    echo "review|${BMAD_FOLDER}/3-solutioning/"
    return 0
  fi

  # User guide
  if [[ "$lower" == user-guide*.md || "$lower" == user_guide*.md || "$lower" == userguide*.md ]]; then
    echo "user-guide|${BMAD_FOLDER}/outputs/"
    return 0
  fi

  # Test plan (top-level)
  if [[ "$lower" == *test-plan*.md || "$lower" == *test_plan*.md ]]; then
    echo "test-plan|${BMAD_FOLDER}/outputs/"
    return 0
  fi

  # Changelog
  if [[ "$lower" == changelog*.md ]]; then
    echo "changelog|${BMAD_FOLDER}/outputs/"
    return 0
  fi

  # No match
  return 1
}

# Map category to phase name for grouping
category_to_phase() {
  local category="$1"
  case "$category" in
    product-brief|research|brainstorm)
      echo "Phase 1 - Analysis"
      ;;
    prd|epics|ux-design|tech-spec)
      echo "Phase 2 - Planning"
      ;;
    architecture|adr|project-context|review|readiness-report)
      echo "Phase 3 - Solutioning"
      ;;
    story|sprint-plan)
      echo "Phase 4 - Implementation"
      ;;
    changelog|user-guide|test-plan|operations|guide|api-docs)
      echo "Outputs"
      ;;
    reference)
      echo "Context"
      ;;
    status)
      echo "Status Files"
      ;;
    package_managed)
      echo "Package Managed (installed globally by BMAD)"
      ;;
    *)
      echo "Other"
      ;;
  esac
}

# ─── Detect mode ─────────────────────────────────────────────────────────────────

run_detect() {
  local legacy_dirs=("docs" "bmad" ".bmad")
  local found_count=0
  local skipped_count=0

  # Temporary file for collecting results (grouped by phase)
  local tmpfile
  tmpfile=$(mktemp)
  # Use global var for trap since piped subshells inherit trap context
  _MIGRATE_TMPFILE="$tmpfile"
  trap 'rm -f "$_MIGRATE_TMPFILE"' EXIT

  for dir in "${legacy_dirs[@]}"; do
    # Skip if directory doesn't exist or is a symlink
    if [ ! -d "$dir" ] || [ -L "$dir" ]; then
      continue
    fi

    # Scan for files (up to 3 levels deep for subdirs like architecture/adrs/)
    while IFS= read -r -d '' filepath; do
      local filename relpath
      filename=$(basename "$filepath")
      # Relative path within the legacy dir (e.g., "architecture/adrs/0001-foo.md")
      relpath="${filepath#"$dir"/}"

      check_path_safety "$filepath"

      local classification
      if ! classification=$(classify_file "$relpath"); then
        continue
      fi

      local category dest_dir
      category=$(echo "$classification" | cut -d'|' -f1)
      dest_dir=$(echo "$classification" | cut -d'|' -f2)

      local phase
      phase=$(category_to_phase "$category")

      local dest_path status_label

      if [ "$dest_dir" = "needs_transform" ]; then
        dest_path="needs_transform"
        status_label="needs_transform"
      else
        # If dest_dir ends with /, append filename; otherwise it's a full path
        if [[ "$dest_dir" == */ ]]; then
          dest_path="${dest_dir}${filename}"
        else
          dest_path="${dest_dir}"
        fi

        if [ -f "$dest_path" ]; then
          status_label="already_exists"
          skipped_count=$((skipped_count + 1))
        else
          status_label="ready"
          found_count=$((found_count + 1))
        fi
      fi

      # Write to tmp: phase|category|source|destination|status
      echo "${phase}|${category}|${filepath}|${dest_path}|${status_label}" >> "$tmpfile"

    done < <(find "$dir" -maxdepth 3 -type f -not -type l -print0 2>/dev/null)
  done

  # Note: YAML status files are now detected by classify_file() in the find loop above.
  # No separate scan needed.

  # Output report
  local total_lines
  total_lines=$(wc -l < "$tmpfile" 2>/dev/null || echo "0")
  total_lines=$(echo "$total_lines" | tr -d ' ')

  if [ "$total_lines" -eq 0 ]; then
    echo "NO_LEGACY_ARTIFACTS_FOUND"
    return 0
  fi

  # Count from file (reliable across subshells)
  # Note: grep -c returns exit 1 when no match, so we use || true to avoid set -e
  local ready_count skip_count transform_count
  ready_count=$(grep -c '|ready$' "$tmpfile" || true)
  skip_count=$(grep -c '|already_exists$' "$tmpfile" || true)
  transform_count=$(grep -c '|needs_transform$' "$tmpfile" || true)

  echo "LEGACY_ARTIFACTS_DETECTED"
  echo "total_migratable: ${ready_count}"
  echo "total_already_exists: ${skip_count}"
  echo "total_needs_transform: ${transform_count}"
  echo ""

  # Group and print by phase (read sorted file without piping into while)
  local sorted_file
  sorted_file=$(mktemp)
  sort -t'|' -k1,1 "$tmpfile" > "$sorted_file"

  local current_phase=""
  local phase_count=0

  while IFS='|' read -r phase category source dest status; do
    if [ "$phase" != "$current_phase" ]; then
      if [ -n "$current_phase" ]; then
        echo ""
      fi
      # Count items in this phase
      phase_count=$(grep -c "^${phase}|" "$tmpfile" || true)
      echo "### ${phase} (${phase_count} files)"
      current_phase="$phase"
    fi

    case "$status" in
      ready)
        echo "  [READY] ${source} -> ${dest}"
        ;;
      already_exists)
        echo "  [SKIP]  ${source} -> ${dest} (already exists)"
        ;;
      needs_transform)
        echo "  [INFO]  ${source} (status file - needs manual review)"
        ;;
    esac
  done < "$sorted_file"

  rm -f "$sorted_file"

  echo ""
  echo "END_REPORT"
}

# ─── Execute mode ────────────────────────────────────────────────────────────────

run_execute() {
  if [ -z "$MANIFEST_FILE" ]; then
    echo -e "${RED}Error: --manifest <file> is required for --execute mode${NC}"
    exit 1
  fi

  if [ ! -f "$MANIFEST_FILE" ]; then
    echo -e "${RED}Error: Manifest file not found: ${MANIFEST_FILE}${NC}"
    exit 1
  fi

  check_path_safety "$MANIFEST_FILE"

  local copied=0
  local skipped=0
  local errors=0

  echo -e "${BLUE}Starting legacy migration...${NC}"
  echo ""

  while IFS='|' read -r source dest; do
    # Skip empty lines and comments
    if [ -z "$source" ] || [[ "$source" == \#* ]]; then
      continue
    fi

    check_path_safety "$source"
    check_path_safety "$dest"

    # Skip needs_transform entries
    if [ "$dest" = "needs_transform" ]; then
      echo -e "  ${YELLOW}[INFO]${NC}  ${source} (status file - skipping, needs manual review)"
      continue
    fi

    # Check source exists
    if [ ! -f "$source" ]; then
      echo -e "  ${RED}[ERR]${NC}   ${source} (source not found)"
      errors=$((errors + 1))
      continue
    fi

    # Never overwrite existing files
    if [ -f "$dest" ]; then
      echo -e "  ${YELLOW}[SKIP]${NC}  ${source} -> ${dest} (already exists)"
      skipped=$((skipped + 1))
      continue
    fi

    # Create parent directory if needed
    local dest_dir
    dest_dir=$(dirname "$dest")
    if [ ! -d "$dest_dir" ]; then
      mkdir -p "$dest_dir"
    fi

    # Copy file (never move)
    if cp "$source" "$dest"; then
      echo -e "  ${GREEN}[OK]${NC}    ${source} -> ${dest}"
      copied=$((copied + 1))
    else
      echo -e "  ${RED}[ERR]${NC}   Failed to copy: ${source}"
      errors=$((errors + 1))
    fi

  done < "$MANIFEST_FILE"

  echo ""
  echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║   Legacy Migration Complete                    ║${NC}"
  echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
  echo ""
  echo -e "  ${GREEN}Copied:${NC}  ${copied} files"
  echo -e "  ${YELLOW}Skipped:${NC} ${skipped} files (already existed)"
  if [ "$errors" -gt 0 ]; then
    echo -e "  ${RED}Errors:${NC}  ${errors} files"
  fi
  echo ""
  echo -e "${BLUE}Note:${NC} Original files in legacy directories were NOT modified."
  echo -e "Delete them manually when you're satisfied with the migration."
  echo ""
}

# ─── Main ────────────────────────────────────────────────────────────────────────

case "$MODE" in
  detect)
    run_detect
    ;;
  execute)
    run_execute
    ;;
esac
