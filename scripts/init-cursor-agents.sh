#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# 🤖 Cursor Multi-Agent System Initializer
# ═══════════════════════════════════════════════════════════════════════════════
#
# This script sets up the multi-agent development system for your project.
# Run it in your project root directory.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/YOUR_REPO/main/scripts/init-cursor-agents.sh | bash
#   OR
#   ./scripts/init-cursor-agents.sh
#
# ═══════════════════════════════════════════════════════════════════════════════

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ─────────────────────────────────────────────────────────────────────────────
# Helper Functions
# ─────────────────────────────────────────────────────────────────────────────

print_header() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  🤖 Cursor Multi-Agent System Initializer${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# ─────────────────────────────────────────────────────────────────────────────
# Configuration Prompts
# ─────────────────────────────────────────────────────────────────────────────

get_config() {
    print_header
    
    # Project name
    echo -e "${YELLOW}What is your project name?${NC}"
    echo -e "(This will be used for Memory Bank organization)"
    read -p "> " PROJECT_NAME
    PROJECT_NAME=${PROJECT_NAME:-"my-app"}
    
    echo ""
    
    # Tech stack
    echo -e "${YELLOW}Select your tech stack:${NC}"
    echo "  1) React Native + Expo + Node.js (default)"
    echo "  2) React Native + Expo + Supabase"
    echo "  3) React Native CLI + Node.js"
    echo "  4) Next.js + Node.js"
    echo "  5) Custom (minimal setup)"
    read -p "> " STACK_CHOICE
    STACK_CHOICE=${STACK_CHOICE:-1}
    
    echo ""
    
    # Memory Bank MCP
    echo -e "${YELLOW}Do you have Memory Bank MCP installed?${NC}"
    echo "  (Required for persistent project memory)"
    echo "  y) Yes, it's configured"
    echo "  n) No, skip Memory Bank setup"
    read -p "> " HAS_MEMORY_BANK
    HAS_MEMORY_BANK=${HAS_MEMORY_BANK:-"y"}
    
    echo ""
    
    # Context7 MCP
    echo -e "${YELLOW}Do you have Context7 MCP installed?${NC}"
    echo "  (Used for real-time library documentation)"
    echo "  y) Yes, it's configured"
    echo "  n) No, I'll use manual docs"
    read -p "> " HAS_CONTEXT7
    HAS_CONTEXT7=${HAS_CONTEXT7:-"y"}
    
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Directory Structure Creation
# ─────────────────────────────────────────────────────────────────────────────

create_directories() {
    print_step "Creating directory structure..."
    
    mkdir -p .cursor/rules
    mkdir -p .cursor/skills
    mkdir -p scripts
    mkdir -p tests/e2e
    mkdir -p tests/integration
    
    print_success "Directories created"
}

# ─────────────────────────────────────────────────────────────────────────────
# Agent Rules Creation
# ─────────────────────────────────────────────────────────────────────────────

create_orchestrator_rule() {
    print_step "Creating Orchestrator agent rule..."
    
    cat > .cursor/rules/orchestrator.mdc << 'ORCHESTRATOR_EOF'
---
description: ORCHESTRATOR AGENT - Task Delegation & Workflow Manager
globs: 
alwaysApply: false
---
# Identity: The Orchestrator
You are the **Workflow Manager and Task Delegator**.
- **Role:** You analyze requests, maintain the Memory Bank, and **EXECUTE** work via sub-agents.
- **Restriction:** You **DO NOT** edit source code directly. Delegate all coding tasks.
- **Restriction:** You **DO NOT** modify `systemPatterns.md`. That is the System Architect's domain.

---

# 🎛️ MODE DETECTION: Interactive vs Automated

## Interactive Mode Triggers (Hand off to User + Architect)
- ❓ New Feature: No existing contract in `systemPatterns.md`
- 🏗️ Architectural Decision: New services, major refactoring
- 🔐 Security-Sensitive: Auth, payments, user data
- ⚠️ Ambiguous Requirements

**Action:** Tell user to invoke `@system-architect` for design session.

## Automated Mode Triggers (Use call_agent.sh)
- ✅ Contract EXISTS in `systemPatterns.md`
- ✅ Requirements are SPECIFIC
- ✅ No architectural decisions needed

---

# Agent Registry

| Agent | Domain | Mode |
|-------|--------|------|
| `system-architect` | systemPatterns.md, Specs | Interactive/Automated |
| `frontend` | app/, src/components/ | Automated |
| `backend` | backend/ | Automated |
| `e2e` | tests/ | Automated |

---

# Execution Workflow

## Phase 0: Mode Detection
```
1. memory_bank_read(projectName, 'systemPatterns.md')
2. Check: Does contract exist? Is request clear?
3. Decision: Interactive or Automated
```

## Phase 1: Delegation
- Interactive: Hand off to `@system-architect`
- Automated: Use `./scripts/call_agent.sh <agent> "<task>"`

## Phase 2: Verification
- Parse `[STATUS]` from agent output
- Audit files listed in `[FILES]`
- Update `activeContext.md`

---

# Delegation Template
```bash
./scripts/call_agent.sh <agent> "
[OBJECTIVE] What to build
[CONTEXT] Reference systemPatterns.md section
[CONSTRAINTS] Limitations
[CRITERIA] Success conditions
"
```
ORCHESTRATOR_EOF
    
    print_success "Orchestrator rule created"
}

create_architect_rule() {
    print_step "Creating System Architect agent rule..."
    
    cat > .cursor/rules/system-architect.mdc << 'ARCHITECT_EOF'
---
description: SYSTEM ARCHITECT AGENT - System Design & Technical Specifications
globs: src/types/**/*
alwaysApply: false
---
# Identity: The Systems Architect
You are the **Technical Authority** of this project.
- **Role:** Turn vague requirements into rigid, actionable specifications.
- **Goal:** Produce "Ready-to-Code" blueprints in `systemPatterns.md`.
- **Restriction:** You DO NOT write feature code. Only definitions.

---

# 🎛️ INTERACTION MODES

## Mode 1: 🗣️ INTERACTIVE (Design Session)
**When:** User invokes directly via `@system-architect`

**Flow:** DISCOVERY → PROPOSAL → APPROVAL → FINALIZE
- Ask clarifying questions
- Present draft design
- Iterate on feedback
- Write spec only after approval

**Exit Statuses:**
- `[STATUS] ⏸️ AWAITING INPUT` - Questions asked
- `[STATUS] ⏸️ AWAITING APPROVAL` - Proposal ready
- `[STATUS] ✅ BLUEPRINT READY` - Finalized

## Mode 2: ⚡ AUTOMATED
**When:** Called via `call_agent.sh` with complete requirements

**Detection:** Prompt has `[OBJECTIVE]`, `[CONTEXT]`, `[CRITERIA]`

**Flow:** READ → DESIGN → WRITE → EXIT

---

# Memory Bank Files You Manage

| File | Purpose |
|------|---------|
| `systemPatterns.md` | API contracts, interfaces, schemas |
| `productContext.md` | Product purpose, user stories |
| `techContext.md` | Tech stack, constraints |

---

# Design Standards

- **Database:** Prefer additive changes
- **API:** RESTful, JSON responses
- **Security:** Secure by default
- **Scalability:** Avoid God Functions
ARCHITECT_EOF
    
    print_success "System Architect rule created"
}

create_frontend_rule() {
    print_step "Creating Frontend agent rule..."
    
    # Adjust based on stack choice
    local GLOBS="app/**/*,src/components/**/*,src/hooks/**/*"
    local FRAMEWORK="React Native + Expo Router"
    
    if [ "$STACK_CHOICE" = "4" ]; then
        GLOBS="app/**/*,src/components/**/*,pages/**/*"
        FRAMEWORK="Next.js"
    fi
    
    cat > .cursor/rules/frontend.mdc << FRONTEND_EOF
---
description: FRONTEND AGENT - UI/UX Specialist (${FRAMEWORK})
globs: ${GLOBS}
alwaysApply: false
---
# Identity: The Frontend Specialist
You are the **${FRAMEWORK} UI/UX Expert**.
- **Role:** Build screens, components, and navigation logic.
- **Authority:** Own the UI directories.
- **Constraint:** NEVER mock data. Implement against \`systemPatterns.md\`.

---

# Execution Workflow

## Phase 1: Context & Contract
1. Read \`systemPatterns.md\` for interfaces
2. Check design tokens in \`src/theme/\`
3. Load skills if needed

## Phase 2: Implementation
- Functional Components + TypeScript
- State: React Query (server), Zustand (client)
- No hardcoded API URLs or colors

## Phase 3: Verification
- \`tsc --noEmit\`
- Accessibility labels on all touchables

---

# Exit Protocol
\`\`\`
[STATUS] ✅ SUCCESS
[FILES] app/screen.tsx, src/components/Component.tsx
[SUMMARY] What was created
[VERIFIED] Matches systemPatterns.md#Section
\`\`\`
FRONTEND_EOF
    
    print_success "Frontend rule created"
}

create_backend_rule() {
    print_step "Creating Backend agent rule..."
    
    cat > .cursor/rules/backend.mdc << 'BACKEND_EOF'
---
description: BACKEND AGENT - API & Logic Specialist (Node.js)
globs: backend/**/*
alwaysApply: false
---
# Identity: The Backend Specialist
You are the **Node.js API & Database Expert**.
- **Role:** Implement REST APIs, database models, business logic.
- **Authority:** Own the `backend/` directory.
- **Critical Rule:** NEVER invent API responses. Match `systemPatterns.md` exactly.

---

# Execution Workflow

## Phase 1: Schema & Contract
1. Read `systemPatterns.md` for endpoint definitions
2. Verify Database Model supports required fields
3. Load skills if needed

## Phase 2: Implementation
- **Controllers:** `backend/src/controllers/`
- **Services:** `backend/src/services/`
- **Models:** `backend/src/models/`
- **Routes:** `backend/src/routes/`

## Phase 3: Security
- Validate all inputs (Zod/Joi)
- Never log sensitive data
- Use parameterized queries

---

# Exit Protocol
```
[STATUS] ✅ SUCCESS
[FILES] backend/src/routes/auth.ts
[SUMMARY] What was implemented
[VERIFIED] Matches systemPatterns.md#Section
```
BACKEND_EOF
    
    print_success "Backend rule created"
}

create_e2e_rule() {
    print_step "Creating E2E agent rule..."
    
    cat > .cursor/rules/e2e.mdc << 'E2E_EOF'
---
description: E2E AGENT - QA & Testing Specialist (Playwright/Detox)
globs: tests/**/*
alwaysApply: false
---
# Identity: The QA Specialist
You are the **Automated Testing Expert**.
- **Role:** Write E2E and Integration tests.
- **Authority:** Own the `tests/` directory.
- **Mission:** You are the Gatekeeper. If tests fail, feature is NOT done.

---

# Test Strategy

- **API Tests:** supertest or Playwright request context
- **Mobile UI:** Detox for React Native
- **Web UI:** Playwright

---

# Standards

| Category | Standard |
|----------|----------|
| **Isolation** | Tests clean up their data |
| **Speed** | Under 30s, mock heavy APIs |
| **Coverage** | Happy path AND sad paths |

---

# Anti-Patterns
- ❌ Fixed `wait(5000)` - use polling assertions
- ❌ Fragile selectors - use `data-testid`
- ❌ Testing implementation details

---

# Exit Protocol
```
[STATUS] ✅ TESTS PASSED
[FILES] tests/e2e/feature.spec.ts
[SUMMARY] What was tested
[COVERAGE] Happy path, error cases
```
E2E_EOF
    
    print_success "E2E rule created"
}

# ─────────────────────────────────────────────────────────────────────────────
# Skills Creation
# ─────────────────────────────────────────────────────────────────────────────

create_skills() {
    print_step "Creating skill files..."
    
    # Frontend Development Skill
    cat > .cursor/skills/frontend-development.md << 'SKILL_EOF'
# Frontend Development Skill

## Component Architecture
- Functional components with TypeScript interfaces
- Props interfaces defined above component
- Default exports for screens, named exports for components

## State Management
- **Server State:** TanStack Query (useQuery, useMutation)
- **Client State:** Zustand with persist middleware
- **Form State:** React Hook Form + Zod validation

## Expo Router Patterns
```typescript
// File-based routing: app/(tabs)/home.tsx
import { useRouter } from 'expo-router'

export default function HomeScreen() {
  const router = useRouter()
  // router.push('/profile')
  // router.replace('/login')
}
```

## API Integration
```typescript
// Use custom hook pattern
const useUser = (id: string) => {
  return useQuery({
    queryKey: ['user', id],
    queryFn: () => api.getUser(id),
  })
}
```
SKILL_EOF

    # Backend Development Skill
    cat > .cursor/skills/backend-development.md << 'SKILL_EOF'
# Backend Development Skill

## Architecture Pattern
```
backend/src/
├── controllers/    # Request/Response handling
├── services/       # Business logic (reusable)
├── models/         # Database schemas
├── routes/         # Endpoint definitions
├── middleware/     # Auth, validation, errors
└── utils/          # Helpers
```

## Error Handling
```typescript
// Centralized error class
class AppError extends Error {
  constructor(
    public statusCode: number,
    public message: string,
    public isOperational = true
  ) {
    super(message)
  }
}

// Usage
throw new AppError(404, 'User not found')
```

## Validation Pattern (Zod)
```typescript
import { z } from 'zod'

const createUserSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
})

// In route
const validated = createUserSchema.parse(req.body)
```
SKILL_EOF

    # Security Compliance Skill
    cat > .cursor/skills/security-compliance.md << 'SKILL_EOF'
# Security Compliance Skill

## Authentication Patterns
- **JWT:** Short-lived access (15min), long-lived refresh (7d)
- **Storage:** SecureStore (mobile), httpOnly cookies (web)
- **OAuth:** Always use PKCE flow for mobile

## Password Requirements
- Minimum 8 characters
- Hash with bcrypt (cost factor 12)
- Never log passwords

## Input Validation
- Validate ALL user input
- Use parameterized queries (prevent SQL injection)
- Sanitize HTML output (prevent XSS)

## HTTPS
- All API calls over HTTPS
- Certificate pinning for sensitive apps
SKILL_EOF

    # Database Design Skill
    cat > .cursor/skills/database-design.md << 'SKILL_EOF'
# Database Design Skill

## Schema Design Principles
- Prefer additive migrations over destructive
- Use UUIDs for public-facing IDs
- Include `createdAt`, `updatedAt` timestamps

## Relationships
- **1:1** - Embed or reference based on access patterns
- **1:N** - Reference with foreign key
- **N:M** - Junction table with indexes

## Indexing
- Index foreign keys
- Index frequently queried fields
- Compound indexes for common query patterns

## Migrations
```typescript
// Always have up and down
export async function up(db) {
  await db.schema.addColumn('users', 'avatarUrl', 'string')
}

export async function down(db) {
  await db.schema.dropColumn('users', 'avatarUrl')
}
```
SKILL_EOF

    print_success "Skill files created"
}

# ─────────────────────────────────────────────────────────────────────────────
# Scripts Creation
# ─────────────────────────────────────────────────────────────────────────────

create_call_agent_script() {
    print_step "Creating call_agent.sh script..."
    
    cat > scripts/call_agent.sh << 'SCRIPT_EOF'
#!/bin/bash

# Usage: ./scripts/call_agent.sh <agent_name> <task_description>
AGENT_NAME=$1
TASK=$2

echo "🤖 Orchestrator delegating to: $AGENT_NAME..."

# 1. Define the Persona File
RULE_FILE=".cursor/rules/$AGENT_NAME.mdc"

# 2. Check if rule file exists
if [ ! -f "$RULE_FILE" ]; then
    echo "❌ Error: Agent rule file $RULE_FILE not found."
    echo "Available agents:"
    ls -1 .cursor/rules/*.mdc 2>/dev/null | xargs -n1 basename | sed 's/.mdc//'
    exit 1
fi

# 3. Execute Cursor Agent
# Note: This is a placeholder. Actual execution depends on your setup.
# Options:
#   - cursor-agent CLI (if available)
#   - Cursor's built-in agent mode
#   - Manual invocation with @agent-name

echo "📋 Task: $TASK"
echo "📄 Rule: $RULE_FILE"
echo ""
echo "To execute, invoke in Cursor:"
echo "  @$AGENT_NAME $TASK"
echo ""
echo "✅ $AGENT_NAME task prepared."
SCRIPT_EOF

    chmod +x scripts/call_agent.sh
    
    print_success "call_agent.sh created"
}

# ─────────────────────────────────────────────────────────────────────────────
# Memory Bank Templates
# ─────────────────────────────────────────────────────────────────────────────

create_memory_bank_templates() {
    if [ "$HAS_MEMORY_BANK" != "y" ]; then
        print_warning "Skipping Memory Bank templates (MCP not configured)"
        return
    fi
    
    print_step "Creating Memory Bank template files..."
    
    mkdir -p .cursor/memory-bank-templates
    
    # Project Brief Template
    cat > .cursor/memory-bank-templates/projectBrief.md << BRIEF_EOF
# Project Brief: ${PROJECT_NAME}

## Overview
<!-- What is this project? One paragraph summary -->

## Core Requirements
<!-- Must-have features for MVP -->
- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3

## Target Users
<!-- Who is this for? -->

## Success Metrics
<!-- How do we know it's working? -->
BRIEF_EOF

    # Product Context Template
    cat > .cursor/memory-bank-templates/productContext.md << PRODUCT_EOF
# Product Context: ${PROJECT_NAME}

## Problem Statement
<!-- What problem does this solve? -->

## User Stories
<!-- As a [user], I want [goal] so that [benefit] -->

### Core User Flows
1. **Onboarding Flow**
   - User signs up
   - User completes profile
   
2. **Main Feature Flow**
   - User performs action
   - System responds

## Business Logic
<!-- Key business rules -->
PRODUCT_EOF

    # System Patterns Template
    cat > .cursor/memory-bank-templates/systemPatterns.md << PATTERNS_EOF
# System Patterns: ${PROJECT_NAME}

## API Contracts

### Authentication
\`\`\`typescript
// POST /api/auth/login
interface ILoginRequest {
  email: string
  password: string
}

interface ILoginResponse {
  accessToken: string
  refreshToken: string
  user: IUser
}
\`\`\`

### User
\`\`\`typescript
interface IUser {
  id: string
  email: string
  name: string
  avatarUrl: string | null
  createdAt: string
}
\`\`\`

## Database Schema

### User Model
| Field | Type | Constraints |
|-------|------|-------------|
| id | UUID | Primary Key |
| email | string | Unique, Required |
| passwordHash | string | Required |
| name | string | Required |
| avatarUrl | string | Nullable |
| createdAt | timestamp | Default: now() |

## Frontend Contracts

### Auth Store (Zustand)
\`\`\`typescript
interface AuthState {
  user: IUser | null
  isAuthenticated: boolean
  login: (email: string, password: string) => Promise<void>
  logout: () => void
}
\`\`\`
PATTERNS_EOF

    # Tech Context Template
    cat > .cursor/memory-bank-templates/techContext.md << TECH_EOF
# Tech Context: ${PROJECT_NAME}

## Stack

### Frontend
- React Native + Expo SDK 51
- Expo Router v3
- TypeScript 5.x
- TanStack Query v5
- Zustand v4

### Backend
- Node.js 20 LTS
- Express 4.x
- TypeScript 5.x
- Zod validation

### Database
- PostgreSQL 15 / MongoDB 7

### Infrastructure
- Hosting: TBD
- CI/CD: GitHub Actions

## Development Setup
\`\`\`bash
# Install dependencies
pnpm install

# Start frontend
cd app && npx expo start

# Start backend
cd backend && npm run dev
\`\`\`

## Constraints
- Must work offline (PWA/offline-first)
- Must support iOS 15+ and Android 10+
TECH_EOF

    # Active Context Template
    cat > .cursor/memory-bank-templates/activeContext.md << ACTIVE_EOF
# Active Context: ${PROJECT_NAME}

## Current Sprint
<!-- What are we working on right now? -->

## In Progress
- [ ] Task 1
- [ ] Task 2

## Recently Completed
- [x] Initial project setup

## Blocked
<!-- What's stuck and why? -->

## Next Up
<!-- What's coming after current tasks? -->
ACTIVE_EOF

    # Progress Template
    cat > .cursor/memory-bank-templates/progress.md << PROGRESS_EOF
# Progress: ${PROJECT_NAME}

## Changelog

### $(date +%Y-%m-%d) - Project Initialization
- Set up Cursor multi-agent system
- Created Memory Bank templates
- Configured agent rules

---

## Milestones

### MVP (Target: TBD)
- [ ] User authentication
- [ ] Core feature 1
- [ ] Core feature 2

### v1.0 (Target: TBD)
- [ ] Additional features
- [ ] Polish and testing
PROGRESS_EOF

    print_success "Memory Bank templates created in .cursor/memory-bank-templates/"
    echo ""
    print_warning "To use these templates, create a project in Memory Bank MCP:"
    echo "   memory_bank_write('${PROJECT_NAME}', 'projectBrief.md', <content>)"
}

# ─────────────────────────────────────────────────────────────────────────────
# Cursor Rules File
# ─────────────────────────────────────────────────────────────────────────────

create_cursorrules() {
    print_step "Creating .cursorrules file..."
    
    cat > .cursorrules << 'RULES_EOF'
# Project-Wide Cursor Rules

## Code Style
- Omit semicolons at end of lines
- Use const/let instead of var
- Prefer arrow functions for inline functions
- Always use strict TypeScript typing
- Comments in English only

## Architecture
- Follow DRY, KISS, and YAGNI principles
- Check if logic already exists before writing new code
- Never use default parameter values - make all parameters explicit
- Prefer functional programming over OOP

## Error Handling
- Always raise errors explicitly, never silently ignore
- Use specific error types
- NO FALLBACKS: Never mask errors with fallback mechanisms
- Fix root causes, not symptoms

## Multi-Agent System
- This project uses a multi-agent development system
- Agent rules are in `.cursor/rules/`
- Skills (specialized knowledge) are in `.cursor/skills/`
- Use `@orchestrator` for task coordination
- Use `@system-architect` for design decisions
RULES_EOF

    print_success ".cursorrules created"
}

# ─────────────────────────────────────────────────────────────────────────────
# README Creation
# ─────────────────────────────────────────────────────────────────────────────

create_readme() {
    print_step "Creating AGENTS.md documentation..."
    
    cat > AGENTS.md << 'README_EOF'
# 🤖 Cursor Multi-Agent Development System

This project uses a multi-agent system for AI-assisted development. Each agent has specialized knowledge and responsibilities.

## Quick Start

```bash
# For new features requiring design:
@system-architect I want to add [feature description]

# After blueprint is ready:
@orchestrator Implement [feature] per systemPatterns.md#Section

# For direct implementation (when contract exists):
@frontend Create the login screen per systemPatterns.md#Auth
@backend Implement POST /api/auth/login per systemPatterns.md#Auth
```

## Agent Directory

| Agent | Invoke With | Responsibility |
|-------|-------------|----------------|
| 🎯 Orchestrator | `@orchestrator` | Task coordination, delegation |
| 🏛️ System Architect | `@system-architect` | Design, specifications, contracts |
| 📱 Frontend | `@frontend` | UI components, screens, navigation |
| ⚙️ Backend | `@backend` | APIs, database, business logic |
| 🧪 E2E | `@e2e` | End-to-end testing |

## Flow Diagram

```
User Request
     │
     ▼
┌─────────────┐
│ Orchestrator │──── Contract exists? ────┐
└─────────────┘                           │
     │ NO                                 │ YES
     ▼                                    ▼
┌─────────────┐                    ┌─────────────┐
│  Architect  │                    │ Delegate to │
│  (Design)   │                    │ Impl Agents │
└─────────────┘                    └─────────────┘
     │                                    │
     ▼                                    ▼
  Blueprint                          Implementation
     │                                    │
     └────────────────┬───────────────────┘
                      ▼
                   E2E Tests
```

## File Structure

```
.cursor/
├── rules/              # Agent definitions
│   ├── orchestrator.mdc
│   ├── system-architect.mdc
│   ├── frontend.mdc
│   ├── backend.mdc
│   └── e2e.mdc
├── skills/             # Specialized knowledge
│   ├── frontend-development.md
│   ├── backend-development.md
│   ├── security-compliance.md
│   └── database-design.md
└── memory-bank-templates/  # Memory Bank file templates
```

## Memory Bank (Optional)

If you have Memory Bank MCP configured, initialize your project:

```typescript
// Create project files
memory_bank_write('my-project', 'projectBrief.md', '...')
memory_bank_write('my-project', 'systemPatterns.md', '...')
memory_bank_write('my-project', 'activeContext.md', '...')
```

Template files are in `.cursor/memory-bank-templates/`.

## Mode Detection

The Orchestrator automatically detects when to use Interactive vs Automated mode:

**Interactive Mode** (Design Session):
- New features without contracts
- Architectural decisions
- Security-sensitive features
- Ambiguous requirements

**Automated Mode** (Direct Delegation):
- Contract exists in `systemPatterns.md`
- Clear, specific requirements
- Implementation only (no design needed)
README_EOF

    print_success "AGENTS.md documentation created"
}

# ─────────────────────────────────────────────────────────────────────────────
# Main Execution
# ─────────────────────────────────────────────────────────────────────────────

main() {
    get_config
    
    echo ""
    print_step "Setting up Cursor Multi-Agent System for: $PROJECT_NAME"
    echo ""
    
    create_directories
    create_orchestrator_rule
    create_architect_rule
    create_frontend_rule
    create_backend_rule
    create_e2e_rule
    create_skills
    create_call_agent_script
    create_memory_bank_templates
    create_cursorrules
    create_readme
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✅ Setup Complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Review the generated files in .cursor/"
    echo "  2. Customize rules for your specific needs"
    echo "  3. If using Memory Bank, create your project files"
    echo "  4. Start with: @orchestrator [your first task]"
    echo ""
    echo "Documentation: See AGENTS.md for usage guide"
    echo ""
}

# Run main function
main

