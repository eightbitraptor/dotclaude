---
description: Create an optimal Claude Swarm team configuration for the current project
globs: ["**/*"]
alwaysApply: false
---
# Create Claude Swarm Team

## Quick Start
When invoked with `@commands/create-team`, immediately:
1. Analyze the project structure and technology stack
2. Generate an initial team configuration
3. Ask clarifying questions about coverage and expertise
4. Save as `claude-swarm.yml` in project root

## Project Analysis Checklist
- [ ] Identify primary languages and frameworks
- [ ] Detect project type (web app, library, CLI tool, etc.)
- [ ] Find distinct components (frontend/backend/database/infra)
- [ ] Check for `context/` directories at any level
- [ ] Review README and documentation files
- [ ] Identify test frameworks and CI/CD setup

## Team Configuration Template
```yaml
version: 1
swarm:
  name: "[Project Name] Development Team"
  main: coordinator
  instances:
    coordinator:
      description: "Technical lead and team coordinator"
      prompt: >
        You are the technical lead who coordinates team efforts,
        makes architectural decisions, and ensures code quality.
        You have broad knowledge of [main technologies] and
        strong communication skills.
      allowed_tools: [Read, Edit, Write, Bash, WebSearch]
      connections: [all_specialist_agents]
    
    # Add 3-6 specialist agents based on project needs
```

## Agent Archetypes

### For Web Applications
- **coordinator**: Architect and team lead
- **frontend_dev**: UI/UX specialist (React/Vue/Angular)
- **backend_dev**: API and business logic expert
- **database_expert**: Data modeling and optimization
- **devops_engineer**: CI/CD and deployment

### For Libraries/Packages
- **coordinator**: API design and architecture
- **core_developer**: Main implementation
- **test_engineer**: Testing and quality assurance
- **docs_writer**: Documentation and examples

### For CLI Tools
- **coordinator**: Command structure and UX
- **cli_developer**: Core CLI implementation
- **integration_expert**: External service integration

## Tool Assignment Rules
```yaml
# Minimal (read-only analysis)
allowed_tools: [Read]

# Standard development
allowed_tools: [Read, Edit, Write]

# Full development
allowed_tools: [Read, Edit, Write, Bash]

# Research & coordination
allowed_tools: [Read, Edit, Write, Bash, WebSearch, WebFetch]
```

## Connection Patterns

Connections are represented as a directed acyclic graph. There must be no circular dependencies between agents. Start from the lead developer as a root node and then work down from there.

```yaml
# Hub-and-spoke (default for 4+ agents)
coordinator:
  connections: [agent1, agent2, agent3]
agent1:
  connections: [coordinator]

# Direct collaboration (for tightly coupled components)
frontend_dev:
  connections: [coordinator, backend_dev]
backend_dev:
  connections: [coordinator, frontend_dev, db_expert]
```

## Prompt Formula
```
You are a [role] specializing in [technologies].
Your expertise includes [specific skills].
You focus on [key responsibilities].
You work closely with [connected agents] to [collaboration goals].
```

## Required Questions to Ask
1. "What is the primary purpose of this project?"
2. "What are the main technical challenges you're facing?"
3. "Are there any specific areas requiring deep expertise?"
4. "What's the team size preference (3-7 agents)?"
5. "Any specific tools or integrations needed?"

## Directory Assignment
- **Root (.)**: Coordinators and architects
- **Component dirs**: Specialist agents (e.g., `src/api` for backend_dev)
- **Shared dirs**: Multiple agents with overlapping concerns

## Model Selection
- **opus**: Complex reasoning, architecture, coordination
- **sonnet**: Standard development, balanced tasks
- **haiku**: Simple tasks, documentation, testing

## Validation Checklist
Before saving:
- [ ] Main agent is defined and has coordinator role
- [ ] All agents have unique IDs
- [ ] Connections form logical collaboration paths
- [ ] No isolated agents (except pure analysts)
- [ ] Tool permissions match agent responsibilities
- [ ] Prompts are specific and actionable
- [ ] 3-7 agents total (optimal team size)

## Example: Full-Stack Web App
```yaml
version: 1
swarm:
  name: "E-Commerce Platform Team"
  main: lead_architect
  instances:
    lead_architect:
      description: "System architect and team coordinator"
      prompt: >
        You are the lead architect coordinating a full-stack
        e-commerce platform. You make architectural decisions,
        review code quality, and ensure system coherence.
      allowed_tools: [Read, Edit, Write, Bash, WebSearch]
      connections: [frontend_dev, backend_dev, db_admin, devops]
    
    frontend_dev:
      description: "React/TypeScript UI developer"
      directory: src/frontend
      prompt: >
        You are a frontend expert specializing in React,
        TypeScript, and responsive design. You create
        intuitive user interfaces and optimize performance.
      allowed_tools: [Read, Edit, Write, Bash]
      connections: [lead_architect, backend_dev]
    
    backend_dev:
      description: "Node.js API developer"
      directory: src/api
      model: opus
      prompt: >
        You are a backend developer expert in Node.js,
        Express, and RESTful APIs. You implement business
        logic, handle authentication, and ensure security.
      allowed_tools: [Read, Edit, Write, Bash]
      connections: [lead_architect, frontend_dev, db_admin]
    
    db_admin:
      description: "PostgreSQL database specialist"
      directory: src/database
      prompt: >
        You are a database expert specializing in PostgreSQL,
        query optimization, and data modeling. You design
        efficient schemas and manage migrations.
      allowed_tools: [Read, Edit, Bash]
      connections: [lead_architect, backend_dev]
    
    devops:
      description: "CI/CD and deployment specialist"
      directory: .github
      prompt: >
        You are a DevOps engineer expert in Docker,
        Kubernetes, and GitHub Actions. You manage
        deployments and ensure system reliability.
      allowed_tools: [Read, Edit, Write, Bash]
      connections: [lead_architect]
```

## Output
Save the final configuration as `claude-swarm.yml` in the project root.
