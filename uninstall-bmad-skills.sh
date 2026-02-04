#!/bin/bash
###############################################################################
# BMAD Skills Uninstaller
# Removes BMAD Skills from Claude Code
###############################################################################

set -euo pipefail

# Version (should match install script)
BMAD_VERSION="1.3.0"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation paths
CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills/accbmad"
COMMANDS_DIR="${CLAUDE_DIR}/commands/accbmad"

###############################################################################
# Logging
###############################################################################

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  $1${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

###############################################################################
# Pre-flight checks
###############################################################################

check_installation() {
    local found=0

    # Check for skills folder
    if [[ -d "${SKILLS_DIR}" ]]; then
        found=1
    fi

    # Check for commands folder
    if [[ -d "${COMMANDS_DIR}" ]]; then
        found=1
    fi

    if [[ $found -eq 0 ]]; then
        log_warning "No BMAD installation found."
        echo ""
        echo "Checked locations:"
        echo "  Skills:   ${SKILLS_DIR}/"
        echo "  Commands: ${COMMANDS_DIR}/"
        echo ""
        exit 0
    fi
}

###############################################################################
# Uninstall functions
###############################################################################

remove_skills() {
    log_info "Removing BMAD skills..."

    if [[ -d "${SKILLS_DIR}" ]]; then
        local count=$(find "${SKILLS_DIR}" -maxdepth 1 -type d | wc -l)
        count=$((count - 1))  # Exclude parent directory
        rm -rf "${SKILLS_DIR}"
        log_success "Removed ${count} skill directories from ${SKILLS_DIR}"
    else
        log_warning "Skills directory not found: ${SKILLS_DIR}"
    fi
}

remove_commands() {
    log_info "Removing BMAD commands..."

    if [[ -d "${COMMANDS_DIR}" ]]; then
        local count=$(find "${COMMANDS_DIR}" -name "*.md" 2>/dev/null | wc -l)
        rm -rf "${COMMANDS_DIR}"
        log_success "Removed ${count} command files from ${COMMANDS_DIR}"
    else
        log_warning "Commands directory not found: ${COMMANDS_DIR}"
    fi
}

###############################################################################
# Project cleanup (optional)
###############################################################################

cleanup_project() {
    local project_dir="$1"

    log_info "Cleaning up BMAD files in project: ${project_dir}"

    # Remove accbmad/ directory (all BMAD project files)
    if [[ -d "${project_dir}/accbmad" ]]; then
        rm -rf "${project_dir}/accbmad"
        log_success "Removed: accbmad/"
    fi

    # Remove legacy bmad/ directory if exists
    if [[ -d "${project_dir}/bmad" ]]; then
        rm -rf "${project_dir}/bmad"
        log_success "Removed: bmad/ (legacy)"
    fi

    # Remove project-level commands
    local proj_commands="${project_dir}/.claude/commands/accbmad"
    if [[ -d "${proj_commands}" ]]; then
        rm -rf "${proj_commands}"
        log_success "Removed: .claude/commands/accbmad/"
    fi

    log_info "Project cleanup complete"
}

###############################################################################
# Main
###############################################################################

print_usage() {
    cat << EOF
BMAD Skills Uninstaller v${BMAD_VERSION}

Usage: $0 [OPTIONS]

Options:
    -h, --help              Show this help message
    -y, --yes               Skip confirmation prompt
    -p, --project <path>    Also clean up BMAD files in specified project
    --keep-commands         Keep workflow commands, only remove skills
    --keep-skills           Keep skills, only remove workflow commands

Examples:
    $0                      # Interactive uninstall
    $0 -y                   # Uninstall without confirmation
    $0 -p /path/to/project  # Also clean project BMAD files
    $0 --keep-commands      # Only remove skills

EOF
}

main() {
    local skip_confirm=false
    local project_path=""
    local keep_commands=false
    local keep_skills=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                print_usage
                exit 0
                ;;
            -y|--yes)
                skip_confirm=true
                shift
                ;;
            -p|--project)
                project_path="$2"
                shift 2
                ;;
            --keep-commands)
                keep_commands=true
                shift
                ;;
            --keep-skills)
                keep_skills=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done

    log_header "BMAD Skills Uninstaller v${BMAD_VERSION}"

    # Check if anything is installed
    check_installation

    # Show what will be removed
    echo "This will remove:"
    echo ""
    if [[ "$keep_skills" != true ]]; then
        echo "  📦 BMAD Skills: ${SKILLS_DIR}/"
    fi
    if [[ "$keep_commands" != true ]]; then
        echo "  📋 Workflow commands: ${COMMANDS_DIR}/"
    fi
    if [[ -n "$project_path" ]]; then
        echo "  🗂️  Project BMAD files: ${project_path}/"
    fi
    echo ""

    # Confirm
    if [[ "$skip_confirm" != true ]]; then
        read -p "Continue with uninstall? [y/N] " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Uninstall cancelled."
            exit 0
        fi
    fi

    echo ""

    # Perform uninstall
    if [[ "$keep_skills" != true ]]; then
        remove_skills
    fi

    if [[ "$keep_commands" != true ]]; then
        remove_commands
    fi

    # Project cleanup if specified
    if [[ -n "$project_path" ]]; then
        if [[ -d "$project_path" ]]; then
            cleanup_project "$project_path"
        else
            log_error "Project path not found: ${project_path}"
        fi
    fi

    # Success message
    log_header "Uninstall Complete"

    echo "BMAD Skills have been removed."
    echo ""
    echo "Note: Restart Claude Code for changes to take effect."
    echo ""

    if [[ -z "$project_path" ]]; then
        echo "To also clean up a specific project's BMAD files, run:"
        echo "  $0 -p /path/to/your/project"
        echo ""
    fi

    echo -e "${GREEN}✓ BMAD Skills uninstalled successfully${NC}"
}

main "$@"
