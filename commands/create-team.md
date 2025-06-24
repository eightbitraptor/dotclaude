---
description:
globs:
alwaysApply: false
---
# Rule: Creating a Claude Swarm team

## Goal

To guide an AI assistant in creating an optimal team of AI agents who are optimised for working in the current project structure, each with their own distinct experiences and expertise. The final team should provide a group of experts with thorough knowledge of the domain required to solve general problems inside the project and should be able to efficiently work together to quickly and thoroughly fix bugs, design and implement features and solve problems.

## Process

**Receive initial prompt:** The user provides a list of files or directories within the project that contain important context.
**Analyze the project:** Explore the project to determine what kind of project it is, what the distinct parts are and how they interact. Determine what languages are used, different focus areas (eg. frontend, backend, Ruby gem, native extension). Pay particular attention to markdown files inside `context` directories at any level of the project as these provide important local context for agents working in the project at the same level as the `context` directory.
**Generate Claude Swarm:** Based on the users prompt and the results of the analysis in the previous step generate a Claude Swarm configuration using the structured outline below.
**Ask Clarifying Qeuestions:** Based on the initial claude swarm configuration, the AI *must* ask some clarifying questions to gather feedback. The goal is to ascertain whether the coverage is appropriate and that the team has the correct expertise for the task that the user wishes to carry out in this repository. Update the Claude swarm config according to the users answers. Repeat this step until the users is happy with the configuration and instructs you to move on.
**Save Claude Swarm:** Save the generated document as `claude-swarm.yml` in the root of the current project.

## claude-swarm.yml structure

### Overview
Claude Swarm configurations define multi-agent AI systems where specialized agents collaborate on complex software development tasks. This document describes the YAML format for creating these configurations.

### Structure
```yaml
version: 1
swarm:
  name: "Team Name"
  main: <coordinator_agent_id>
  instances:
    <agent_id>:
      description: "Brief role description"
      directory: <working_path>      # Optional, defaults to .
      model: opus|sonnet|haiku       # Optional
      prompt: >
        Detailed expertise and behavior definition
      allowed_tools: [Read, Edit, Write, Bash, WebSearch, WebFetch]
      connections: [<other_agent_ids>]  # Optional
```

### Key Concepts

**Agents**: Specialized AI instances with specific expertise  
**Main**: Entry point agent that typically coordinates others  
**Connections**: Defines which agents can communicate directly  
**Directory**: Scopes agent's primary working area  
**Tools**: Restricts agent capabilities based on role  

### Field Descriptions

#### Top Level
- **version**: Format version (currently 1)
- **swarm**: Container for all swarm configuration

#### Swarm Fields
- **name**: Human-readable team name
- **main**: Coordinator agent ID - the primary entry point
- **instances**: Dictionary of agent definitions

#### Agent Fields
- **description**: One-line role summary for agent selection
- **directory**: Working directory path (optional, defaults to `.`)
- **model**: AI model to use - `opus`, `sonnet`, or `haiku` (optional)
- **prompt**: Multi-line expertise definition using `>` (required)
- **allowed_tools**: Array of permitted tools (required)
- **connections**: Array of other agent IDs this agent can communicate with (optional)

### Available Tools
- **Read**: Read files
- **Edit**: Modify existing files
- **Write**: Create new files
- **Bash**: Execute shell commands
- **WebSearch**: Search the internet
- **WebFetch**: Fetch web content

### Agent Design Rules

1. **Specialization**: Each agent has focused expertise (except coordinators)
2. **Connections**: Use hub-and-spoke pattern; avoid full mesh
3. **Tools**: Grant only necessary tools for the role
4. **Prompts**: Write in second person, emphasize specific technical skills
5. **Directories**: Assign based on code area responsibility

### Example Configuration

```yaml
version: 1
swarm:
  name: "Web Development Team"
  main: lead_developer
  instances:
    lead_developer:
      description: "Team coordinator and architect"
      prompt: >
        You are a lead developer who coordinates the team and makes
        architectural decisions. You have broad technical knowledge
        and strong communication skills.
      allowed_tools: [Read, Edit, Write, Bash, WebSearch]
      connections: [backend_dev, frontend_dev, db_expert]
    
    backend_dev:
      description: "API developer specializing in microservices"
      directory: src/api
      model: opus
      connections: [db_expert, frontend_dev]
      prompt: >
        You are an expert backend developer skilled in REST APIs,
        Node.js, and microservices architecture. You focus on
        scalability, security, and clean API design.
      allowed_tools: [Read, Edit, Write, Bash]
    
    frontend_dev:
      description: "UI/UX developer for web applications"
      directory: src/frontend
      connections: [backend_dev]
      prompt: >
        You are a frontend specialist with expertise in React,
        TypeScript, and responsive design. You create intuitive
        user interfaces and optimize web performance.
      allowed_tools: [Read, Edit, Write, Bash, WebSearch]
    
    db_expert:
      description: "Database architect and optimization specialist"
      directory: src/database
      connections: [backend_dev]
      prompt: >
        You are a database expert skilled in SQL and NoSQL systems,
        query optimization, and data modeling. You design efficient
        schemas and ensure data integrity.
      allowed_tools: [Read, Edit, Bash]
```

### Best Practices

#### Connection Topology
- Use a coordinator (main) agent for complex teams
- Connect agents that need direct collaboration
- Avoid connecting every agent to every other agent

#### Directory Assignment
- Assign specific directories to focus agent work
- Coordinators typically use root directory (`.`)
- Use subdirectories for specialized components

#### Tool Selection
- Read-only agents: `[Read]`
- Code writers: `[Read, Edit, Write]`
- System operators: `[Read, Bash]`
- Researchers: `[Read, WebSearch, WebFetch]`

#### Prompt Writing
- Start with "You are..."
- List specific technologies and frameworks
- Define working style and approach
- Keep focused on the agent's specialty
- Use clear, technical language

### Common Patterns

#### Hub and Spoke
```yaml
main: coordinator
instances:
  coordinator:
    connections: [agent1, agent2, agent3]
  agent1:
    connections: [coordinator]
  agent2:
    connections: [coordinator]
  agent3:
    connections: [coordinator]
```

#### Pipeline
```yaml
instances:
  analyzer:
    connections: [designer]
  designer:
    connections: [analyzer, implementer]
  implementer:
    connections: [designer, tester]
  tester:
    connections: [implementer]
```

#### Specialist Teams
```yaml
instances:
  frontend_lead:
    connections: [ui_dev, ux_designer, css_expert]
  backend_lead:
    connections: [api_dev, db_admin, security_expert]
  devops_lead:
    connections: [ci_engineer, cloud_architect]
```

## Output

- **Format:** Yaml (`.yml`)
- **Location:** `/`
- **Filename:** `claude-swarm.yml`
