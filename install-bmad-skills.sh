#!/usr/bin/env bash
###############################################################################
# BMAD Skills - Installation Script
#
# Installs the improved BMAD Skills package for Claude Code
# Source: bmad-skills/ (restructured, improved version)
#
# Usage: ./install-bmad-skills.sh
###############################################################################

set -euo pipefail

# Configuration
BMAD_VERSION="1.3.0"
CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills/accbmad"
COMMANDS_DIR="${CLAUDE_DIR}/commands/accbmad"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/bmad-skills"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

log_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

###############################################################################
# Pre-flight Checks
###############################################################################

check_source() {
    if [ ! -d "${SOURCE_DIR}" ]; then
        log_error "Source directory not found: ${SOURCE_DIR}"
        log_error "Please run this script from the repository root."
        exit 1
    fi

    # Validate all required skills exist
    local required_skills=(
        "bmad-orchestrator"
        "business-analyst"
        "product-manager"
        "system-architect"
        "scrum-master"
        "developer"
        "ux-designer"
        "creative-intelligence"
        "builder"
        "tech-writer"
    )

    local missing=0
    for skill in "${required_skills[@]}"; do
        if [ ! -f "${SOURCE_DIR}/${skill}/SKILL.md" ]; then
            log_error "Missing required skill: ${skill}"
            missing=$((missing + 1))
        fi
    done

    if [ $missing -gt 0 ]; then
        log_error "Found ${missing} missing skills. Please check source directory."
        exit 1
    fi

    log_success "Source directory verified: ${SOURCE_DIR} (all 10 skills found)"
}

check_existing_installation() {
    if [ -d "${SKILLS_DIR}" ] || [ -d "${COMMANDS_DIR}" ]; then
        log_warning "Existing BMAD installation detected."
        read -p "Do you want to backup and replace it? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            backup_existing
        else
            log_info "Installation cancelled."
            exit 0
        fi
    fi
}

backup_existing() {
    local backup_dir="${CLAUDE_DIR}/backups/accbmad-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "${backup_dir}"

    if [ -d "${SKILLS_DIR}" ]; then
        mv "${SKILLS_DIR}" "${backup_dir}/skills"
        log_info "Skills backed up to ${backup_dir}"
    fi

    if [ -d "${COMMANDS_DIR}" ]; then
        mv "${COMMANDS_DIR}" "${backup_dir}/commands"
        log_info "Commands backed up to ${backup_dir}"
    fi

    log_success "Backup completed: ${backup_dir}"
}

###############################################################################
# Installation Functions
###############################################################################

create_directories() {
    log_info "Creating directory structure..."

    mkdir -p "${SKILLS_DIR}"
    mkdir -p "${COMMANDS_DIR}"

    log_success "Directories created"
}

install_skills() {
    log_info "Installing BMAD Skills..."

    local skills=(
        "bmad-orchestrator"
        "business-analyst"
        "product-manager"
        "system-architect"
        "scrum-master"
        "developer"
        "ux-designer"
        "creative-intelligence"
        "builder"
        "tech-writer"
    )

    local installed=0

    for skill in "${skills[@]}"; do
        local src="${SOURCE_DIR}/${skill}"
        local dest="${SKILLS_DIR}/${skill}"

        if [ -d "${src}" ]; then
            # Copy entire skill directory (SKILL.md, REFERENCE.md, scripts/, templates/, etc.)
            cp -r "${src}" "${dest}"

            # Make scripts executable
            if [ -d "${dest}/scripts" ]; then
                chmod +x "${dest}/scripts"/*.sh 2>/dev/null || true
                chmod +x "${dest}/scripts"/*.py 2>/dev/null || true
            fi

            installed=$((installed + 1))
        else
            log_warning "Skill not found: ${skill}"
        fi
    done

    log_success "${installed} skills installed"
}

install_shared_resources() {
    log_info "Installing shared resources..."

    # Install shared directory (helpers, tasks)
    if [ -d "${SOURCE_DIR}/shared" ]; then
        cp -r "${SOURCE_DIR}/shared" "${SKILLS_DIR}/shared"
        log_success "Shared resources installed"
    fi

    # Install hooks
    if [ -d "${SOURCE_DIR}/hooks" ]; then
        mkdir -p "${CLAUDE_DIR}/hooks"
        cp "${SOURCE_DIR}/hooks"/*.sh "${CLAUDE_DIR}/hooks/" 2>/dev/null || true
        chmod +x "${CLAUDE_DIR}/hooks"/*.sh 2>/dev/null || true
        log_success "Hooks installed"
    fi

    # Install examples
    if [ -d "${SOURCE_DIR}/examples" ]; then
        cp -r "${SOURCE_DIR}/examples" "${SKILLS_DIR}/examples"
        log_success "Examples installed"
    fi
}

install_commands() {
    log_info "Installing workflow commands..."

    # Map skill workflows to commands
    local -A workflow_map=(
        # orchestrator workflows → commands
        ["bmad-orchestrator/workflows/workflow-init.md"]="workflow-init.md"
        ["bmad-orchestrator/workflows/workflow-status.md"]="workflow-status.md"
        ["bmad-orchestrator/workflows/generate-project-context.md"]="generate-project-context.md"
        ["bmad-orchestrator/workflows/solutioning-gate-check.md"]="solutioning-gate-check.md"

        # business-analyst workflows
        ["business-analyst/workflows/product-brief.md"]="product-brief.md"

        # product-manager workflows
        ["product-manager/workflows/prd.md"]="prd.md"
        ["product-manager/workflows/tech-spec.md"]="tech-spec.md"
        ["product-manager/workflows/quick-spec.md"]="quick-spec.md"
        ["product-manager/workflows/validate-prd.md"]="validate-prd.md"

        # system-architect workflows
        ["system-architect/workflows/architecture.md"]="architecture.md"

        # orchestrator gate workflows
        ["bmad-orchestrator/workflows/check-implementation-readiness.md"]="check-implementation-readiness.md"
        ["bmad-orchestrator/workflows/validate-phase-transition.md"]="validate-phase-transition.md"

        # scrum-master workflows
        ["scrum-master/workflows/sprint-planning.md"]="sprint-planning.md"
        ["scrum-master/workflows/create-story.md"]="create-story.md"
        ["scrum-master/workflows/create-epics-stories.md"]="create-epics-stories.md"
        ["scrum-master/workflows/retrospective.md"]="retrospective.md"

        # developer workflows
        ["developer/workflows/dev-story.md"]="dev-story.md"
        ["developer/workflows/dev-story-auto.md"]="dev-story-auto.md"
        ["developer/workflows/quick-dev.md"]="quick-dev.md"
        ["developer/workflows/code-review.md"]="code-review.md"
        ["developer/workflows/qa-automate.md"]="qa-automate.md"
        ["developer/workflows/expedited-fix.md"]="expedited-fix.md"

        # ux-designer workflows
        ["ux-designer/workflows/create-ux-design.md"]="create-ux-design.md"
        ["ux-designer/workflows/wcag-validate.md"]="wcag-validate.md"
        ["ux-designer/workflows/check-contrast.md"]="check-contrast.md"

        # creative-intelligence workflows
        ["creative-intelligence/workflows/brainstorm.md"]="brainstorm.md"
        ["creative-intelligence/workflows/research.md"]="research.md"

        # builder workflows
        ["builder/workflows/create-agent.md"]="create-agent.md"
        ["builder/workflows/create-workflow.md"]="create-workflow.md"

        # tech-writer workflows
        ["tech-writer/workflows/api-documentation.md"]="api-docs.md"
        ["tech-writer/workflows/readme-generator.md"]="readme.md"
        ["tech-writer/workflows/user-guide.md"]="user-guide.md"
        ["tech-writer/workflows/changelog.md"]="changelog.md"
        ["tech-writer/workflows/architecture-docs.md"]="architecture-docs.md"
    )

    local installed=0

    local missing=0
    for src_path in "${!workflow_map[@]}"; do
        local dest_name="${workflow_map[$src_path]}"
        local full_src="${SOURCE_DIR}/${src_path}"
        local full_dest="${COMMANDS_DIR}/${dest_name}"

        if [ -f "${full_src}" ]; then
            cp "${full_src}" "${full_dest}"
            installed=$((installed + 1))
        else
            log_warning "Workflow not found: ${src_path}"
            missing=$((missing + 1))
        fi
    done

    if [ $missing -gt 0 ]; then
        log_warning "${missing} workflow files not found (may be optional)"
    fi

    log_success "${installed} workflow commands installed"
}

install_documentation() {
    log_info "Installing documentation..."

    # Copy BMAD-GUIDE.md for project guidance
    if [ -f "${SOURCE_DIR}/BMAD-GUIDE.md" ]; then
        cp "${SOURCE_DIR}/BMAD-GUIDE.md" "${SKILLS_DIR}/GUIDE.md"
        log_success "Project guide installed"
    fi

    # Copy BMAD-SUBAGENT-PATTERNS.md
    if [ -f "${SOURCE_DIR}/BMAD-SUBAGENT-PATTERNS.md" ]; then
        cp "${SOURCE_DIR}/BMAD-SUBAGENT-PATTERNS.md" "${SKILLS_DIR}/SUBAGENT-PATTERNS.md"
        log_success "Subagent patterns installed"
    fi
}

###############################################################################
# Verification
###############################################################################

verify_installation() {
    log_info "Verifying installation..."

    local errors=0

    # Check skills
    for skill in bmad-orchestrator business-analyst product-manager developer; do
        if [ -f "${SKILLS_DIR}/${skill}/SKILL.md" ]; then
            log_success "Skill verified: ${skill}"
        else
            log_error "Missing skill: ${skill}"
            errors=$((errors + 1))
        fi
    done

    # Check commands
    for cmd in workflow-init workflow-status validate-phase-transition check-implementation-readiness solutioning-gate-check dev-story prd architecture; do
        if [ -f "${COMMANDS_DIR}/${cmd}.md" ]; then
            log_success "Command verified: ${cmd}"
        else
            log_error "Missing command: ${cmd}"
            errors=$((errors + 1))
        fi
    done

    if [ $errors -eq 0 ]; then
        log_success "Installation verified successfully"
        return 0
    else
        log_error "Installation verification failed: ${errors} error(s)"
        return 1
    fi
}

###############################################################################
# Post-installation
###############################################################################

print_success() {
    log_header "Installation Complete!"

    printf '%b\n' "$(cat << EOF
📦 BMAD Skills v${BMAD_VERSION} installed successfully!

Installation locations:
  Skills:   ${SKILLS_DIR}/
  Commands: ${COMMANDS_DIR}/

✓ 10 Enhanced Skills
  - bmad-orchestrator (workflow management)
  - business-analyst (Phase 1 - Analysis)
  - product-manager (Phase 2 - Planning)
  - system-architect (Phase 3 - Solutioning)
  - scrum-master (Phase 4 - Sprint Planning)
  - developer (Phase 4 - Implementation)
  - ux-designer (Cross-phase UX)
  - tech-writer (Documentation)
  - creative-intelligence (Research & Brainstorming)
  - builder (Create custom skills)

✓ 34 Workflow Commands
  - /workflow-init, /workflow-status, /generate-project-context
  - /product-brief, /prd, /tech-spec, /quick-spec, /validate-prd
  - /architecture, /solutioning-gate-check, /check-implementation-readiness
  - /sprint-planning, /create-story, /create-epics-stories, /retrospective
  - /dev-story, /dev-story-auto, /quick-dev, /expedited-fix
  - /code-review, /qa-automate
  - /brainstorm, /research
  - /create-ux-design, /wcag-validate, /check-contrast
  - /create-agent, /create-workflow
  - /readme, /api-docs, /user-guide, /changelog, /architecture-docs

✓ Each skill includes:
  - SKILL.md (activation & expertise)
  - REFERENCE.md (detailed documentation)
  - scripts/ (utility scripts)
  - templates/ (document templates)
  - workflows/ (step-by-step guides)

📋 Next Steps:

1️⃣  ${BLUE}Restart Claude Code${NC}
    Skills will be loaded in new sessions

2️⃣  ${BLUE}Navigate to your project${NC}
    cd /path/to/your/project

3️⃣  ${BLUE}Initialize BMAD${NC}
    /accbmad:workflow-init

4️⃣  ${BLUE}Check status anytime${NC}
    /accbmad:workflow-status

📚 Quick Start Commands:
   /accbmad:product-brief    # Start with discovery
   /accbmad:prd              # Create requirements
   /accbmad:architecture     # Design system
   /accbmad:sprint-planning  # Plan sprints
   /accbmad:dev-story        # Implement stories

${GREEN}✓ BMAD Skills v${BMAD_VERSION} is ready!${NC}
EOF
)"
}

###############################################################################
# Main
###############################################################################

main() {
    log_header "BMAD Skills v${BMAD_VERSION} Installer"

    # Pre-flight
    check_source
    check_existing_installation

    # Installation
    create_directories
    install_skills
    install_shared_resources
    install_commands
    install_documentation

    # Verification
    if verify_installation; then
        print_success
        exit 0
    else
        log_error "Installation failed"
        exit 1
    fi
}

main "$@"
