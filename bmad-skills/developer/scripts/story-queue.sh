#!/bin/bash
###############################################################################
# Story Queue Manager for dev-story-auto
#
# This script manages the story queue and forces Claude to continue processing
# by always returning the next action to take.
#
# Usage:
#   story-queue.sh next          # Get next pending story
#   story-queue.sh complete ID   # Mark story as done, get next
#   story-queue.sh status        # Show queue status
###############################################################################

set -euo pipefail

# Find sprint status file
find_status_file() {
    local locations=(
        "accbmad/4-implementation/sprint.yaml"
        "bmad/sprint-status.yaml"
        ".bmad/sprint-status.yaml"
    )

    for loc in "${locations[@]}"; do
        if [[ -f "$loc" ]]; then
            echo "$loc"
            return 0
        fi
    done

    echo ""
    return 1
}

# Get pending stories from YAML (simple grep-based parsing)
get_pending_stories() {
    local status_file="$1"

    # Extract story IDs that have status: pending or status: ready-for-dev
    # This is a simplified parser - works for standard sprint-status format
    awk '
        /^[[:space:]]*- id:/ {
            gsub(/.*id:[[:space:]]*/, "");
            gsub(/[[:space:]]*$/, "");
            gsub(/"/, "");
            current_id = $0
        }
        /status:[[:space:]]*(pending|ready-for-dev)/ {
            if (current_id != "") print current_id
        }
        /status:[[:space:]]*(done|completed|in-progress)/ {
            current_id = ""
        }
    ' "$status_file"
}

# Get next pending story
cmd_next() {
    local status_file
    status_file=$(find_status_file) || {
        echo "ERROR: No sprint-status.yaml found"
        echo "ACTION: HALT"
        exit 1
    }

    local next_story
    next_story=$(get_pending_stories "$status_file" | head -1)

    if [[ -z "$next_story" ]]; then
        echo "STATUS: ALL_COMPLETE"
        echo "ACTION: STOP"
        echo "MESSAGE: All stories have been completed. Sprint is done."
    else
        local pending_count
        pending_count=$(get_pending_stories "$status_file" | wc -l)

        echo "STATUS: PENDING"
        echo "NEXT_STORY: $next_story"
        echo "REMAINING: $pending_count"
        echo "ACTION: IMPLEMENT"
        echo ""
        echo "╔══════════════════════════════════════════════════════════════════╗"
        echo "║  MANDATORY STEPS - EXECUTE ALL IN ORDER                          ║"
        echo "╠══════════════════════════════════════════════════════════════════╣"
        echo "║  STEP 1: Create branch                                           ║"
        echo "║    git checkout -b story/$next_story"
        echo "║                                                                  ║"
        echo "║  STEP 2: Implement story $next_story"
        echo "║    - Read story file from accbmad/4-implementation/stories/                          ║"
        echo "║    - Implement all acceptance criteria                           ║"
        echo "║    - Write tests                                                 ║"
        echo "║                                                                  ║"
        echo "║  STEP 3: ▶▶▶ CODE REVIEW (MANDATORY) ◀◀◀                         ║"
        echo "║    Run: ./scripts/story-queue.sh review $next_story"
        echo "║    - Follow the checklist                                        ║"
        echo "║    - Review ALL files you created/modified                       ║"
        echo "║    - AUTO-FIX all issues (no user prompt)                        ║"
        echo "║    ⚠️  DO NOT SKIP THIS STEP                                      ║"
        echo "║                                                                  ║"
        echo "║  STEP 4: Commit                                                  ║"
        echo "║    git add -A && git commit                                      ║"
        echo "║                                                                  ║"
        echo "║  STEP 5: ▶▶▶ VERIFICATION REVIEW (MANDATORY) ◀◀◀                 ║"
        echo "║    - Run code review AGAIN after commit                          ║"
        echo "║    - If issues found: fix and amend commit                       ║"
        echo "║    ⚠️  DO NOT SKIP THIS STEP                                      ║"
        echo "║                                                                  ║"
        echo "║  STEP 6: Merge and push                                          ║"
        echo "║    git checkout develop && git merge story/$next_story --no-ff"
        echo "║    git push origin develop"
        echo "║                                                                  ║"
        echo "║  STEP 7: Update sprint-status.yaml                               ║"
        echo "║    Set $next_story status: done"
        echo "║                                                                  ║"
        echo "║  STEP 8: GET NEXT STORY                                          ║"
        echo "║    Run: ./scripts/story-queue.sh next                            ║"
        echo "║    Then follow the new ACTION                                    ║"
        echo "╚══════════════════════════════════════════════════════════════════╝"
    fi
}

# Mark story complete and get next
cmd_complete() {
    local story_id="$1"
    local status_file
    status_file=$(find_status_file) || {
        echo "ERROR: No sprint-status.yaml found"
        exit 1
    }

    echo "COMPLETED: $story_id"
    echo ""

    # Now get next story
    cmd_next
}

# Show queue status
cmd_status() {
    local status_file
    status_file=$(find_status_file) || {
        echo "ERROR: No sprint-status.yaml found"
        exit 1
    }

    echo "Sprint Status File: $status_file"
    echo ""
    echo "Pending Stories:"
    get_pending_stories "$status_file" | while read -r story; do
        echo "  - $story"
    done

    local count
    count=$(get_pending_stories "$status_file" | wc -l)
    echo ""
    echo "Total pending: $count"
}

# Run code review checklist
cmd_review_checklist() {
    local story_id="${1:-current}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  ⚠️  ADVERSARIAL CODE REVIEW - Story: $story_id"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║                                                                  ║"
    echo "║  🚨 YOU MUST FIND AT LEAST 3 ISSUES 🚨                           ║"
    echo "║                                                                  ║"
    echo "║  If you find 0 issues, you are NOT reviewing properly.           ║"
    echo "║  Be your own WORST critic. Assume there ARE bugs.                ║"
    echo "║                                                                  ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║  CHECKLIST - Actively search for problems:                       ║"
    echo "║                                                                  ║"
    echo "║  □ SECURITY: Injection? Secrets exposed? Auth bypass?            ║"
    echo "║  □ ERRORS: What if network fails? File missing? Null value?      ║"
    echo "║  □ VALIDATION: Is input from user/API validated?                 ║"
    echo "║  □ TESTS: Do tests actually test behavior? Edge cases?           ║"
    echo "║  □ EDGE CASES: Empty list? Max int? Unicode? Concurrent access?  ║"
    echo "║  □ CODE QUALITY: Duplicated code? Functions too long?            ║"
    echo "║  □ LOGGING: Can you debug in production with these logs?         ║"
    echo "║  □ TYPES: Are types correct? Any 'Any' that should be specific?  ║"
    echo "║                                                                  ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║  REQUIRED OUTPUT FORMAT:                                         ║"
    echo "║                                                                  ║"
    echo "║  | # | Severity | File:Line | Issue | Fix |                      ║"
    echo "║  |---|----------|-----------|-------|-----|                      ║"
    echo "║  | 1 | HIGH     | foo.py:42 | ...   | ... |                      ║"
    echo "║  | 2 | MEDIUM   | bar.py:10 | ...   | ... |                      ║"
    echo "║  | 3 | LOW      | baz.py:5  | ...   | ... |                      ║"
    echo "║                                                                  ║"
    echo "║  Then: Apply ALL fixes, re-run tests, verify fixes worked.       ║"
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "⚠️  'Code looks clean' is NOT an acceptable review result."
    echo "⚠️  You MUST list specific issues found and fixes applied."
}

# Main
case "${1:-next}" in
    next)
        cmd_next
        ;;
    complete)
        if [[ -z "${2:-}" ]]; then
            echo "ERROR: story ID required"
            echo "Usage: $0 complete STORY-ID"
            exit 1
        fi
        cmd_complete "$2"
        ;;
    status)
        cmd_status
        ;;
    review|checklist)
        cmd_review_checklist "${2:-}"
        ;;
    *)
        echo "Usage: $0 {next|complete|status|review}"
        echo ""
        echo "Commands:"
        echo "  next           Get the next pending story"
        echo "  complete ID    Mark story done and get next"
        echo "  status         Show queue status"
        echo "  review [ID]    Show code review checklist"
        exit 1
        ;;
esac
