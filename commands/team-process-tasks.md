---
description: 
globs: 
alwaysApply: false
---
# Team Task List Management

Guidelines for coordinating multiple AI agents when managing task lists in markdown files to track progress on completing a PRD

## Overview

This command extends the single-agent `process-task-list` functionality to coordinate a team of specialized AI agents. While maintaining the same sequential top-level task processing and quality controls, this approach enables parallel execution of sub-tasks by different agents based on their specializations.

**Key Concept**: The AI reading this command acts as the **lead coordinator**, delegating sub-tasks to appropriate specialist agents while maintaining overall project control, testing, and git operations.

## Agent Team Configuration

The team of available agents is defined in a `claude-swarm.yml` file in the project root. This file contains:

- **Agent names and identities**: Each agent has a unique name and role description
- **Specializations**: Technical skills and areas of expertise for each agent (e.g., frontend, backend, testing, DevOps)
- **Agent capabilities**: What types of tasks each agent is best suited for

**Important**: As the lead coordinator, you must read and understand the `claude-swarm.yml` configuration before beginning task processing to know which agents are available and their capabilities.

## Lead AI Responsibilities

As the lead coordinator reading this command, you are responsible for:

### Project Management
- **Sequential task processing**: Ensure top-level tasks are completed one at a time in order
- **Sub-task delegation**: Assign sub-tasks to the most appropriate specialist agents
- **Progress monitoring**: Track the status of all agent assignments and sub-task completion
- **Quality coordination**: Coordinate agent work to maintain consistency and avoid conflicts

### Technical Operations
- **Testing**: Run all test suites after agent sub-tasks are completed
- **Git operations**: Handle all staging, committing, and repository management (agents never commit directly)
- **Integration**: Ensure all agent contributions integrate properly before committing
- **Error handling**: Manage situations where agents encounter problems or need reassignment

### Agent Management  
- **Agent activation**: Only activate agents whose specializations match the current task requirements
- **Task assignment**: Match sub-tasks to agent capabilities using specialization keywords
- **Escalation handling**: Assist agents when they encounter tasks outside their expertise
- **Communication**: Coordinate all agent activities through task list updates and clear instructions

## Agent Coordination and Assignment Instructions

### Reading the Agent Configuration

Before starting any task processing, you must:

1. **Locate and read** the `claude-swarm.yml` file in the project root directory
2. **Parse agent definitions** to understand each agent's:
   - **Name/ID**: How to reference the agent in assignments
   - **Role description**: What the agent's primary function is
   - **Specializations**: Technical skills (e.g., "React", "Python", "testing", "DevOps", "database")
   - **Capabilities**: Types of work the agent excels at

3. **Create a mental map** of available agents and their strengths before beginning task delegation

**Example agent configuration understanding**:
```yaml
agents:
  - name: frontend-specialist
    specializations: ["React", "TypeScript", "CSS", "JavaScript"]
    role: "Frontend development and UI implementation"
  - name: backend-developer  
    specializations: ["Python", "API", "database", "Django"]
    role: "Server-side logic and data management"
```

### Task-to-Agent Matching Guidelines

Use **keyword analysis** to match sub-tasks to the most appropriate agents:

#### Matching Process:
1. **Extract keywords** from the sub-task description
2. **Compare keywords** against agent specializations 
3. **Calculate match strength** based on keyword overlap
4. **Assign to the agent** with the highest match score

#### Keyword Matching Rules:
- **Direct matches**: Task contains exact specialization terms (e.g., "React component" → frontend-specialist)
- **Related matches**: Task contains related technologies (e.g., "API endpoint" → backend-developer)
- **Domain matches**: Task fits agent's general domain (e.g., "unit tests" → testing-specialist)

#### Matching Examples:
| Sub-task Description | Keywords Extracted | Best Agent Match | Reasoning |
|---------------------|-------------------|------------------|-----------|
| "Create React login form" | React, form, frontend | frontend-specialist | Direct "React" match |
| "Add database migration" | database, migration, schema | backend-developer | Database specialization |
| "Write unit tests for API" | tests, testing, API | testing-specialist | Testing + API coverage |
| "Deploy to production" | deploy, production, DevOps | devops-engineer | Deployment specialization |

#### Fallback Rules:
- **No clear match**: Assign to the most generalist agent or ask for clarification
- **Multiple matches**: Choose the agent with more specific/relevant specializations
- **Outside all specializations**: Assign to lead AI (yourself) to handle directly

### Automatic Agent Activation Protocol

**Only activate agents whose specializations are needed** for the current task list to avoid unnecessary resource usage:

#### Activation Process:
1. **Pre-scan the task list**: Read through all top-level tasks and sub-tasks
2. **Identify required specializations**: Extract all technology keywords and skill requirements
3. **Match to available agents**: Determine which agents have relevant specializations
4. **Activate selective team**: Only bring online agents whose skills will be used

#### Activation Rules:
- **Relevance requirement**: Agent must have at least one specialization that matches task list content
- **Efficiency principle**: Don't activate agents who won't have work assigned to them
- **Lead always active**: The lead coordinator (you) is always active regardless of task content

#### Example Activation Decision:
**Task List Contains**: React components, API integration, database setup, unit testing

**Available Agents**: frontend-specialist (React), backend-developer (API/database), testing-specialist (testing), devops-engineer (deployment)

**Activation Decision**: 
- ✅ **Activate**: frontend-specialist, backend-developer, testing-specialist
- ❌ **Do not activate**: devops-engineer (no deployment tasks present)

#### Activation Communication:
When activating agents, clearly communicate:
- Which agents are being activated
- Why each agent was selected
- What types of tasks they should expect to receive

### Sub-Task Delegation Rules

Once agents are activated, delegate sub-tasks using these protocols:

#### Delegation Process:
1. **Analyze each sub-task** within the current top-level task
2. **Apply keyword matching** to determine the best agent fit  
3. **Add agent assignment metadata** to the task list using HTML comments
4. **Communicate the assignment** clearly to the designated agent
5. **Monitor progress** through task list updates

#### Delegation Format:
Enhance the task list by adding agent assignments as HTML comments:

```markdown
- [ ] 1.0 Build user authentication system
  - [ ] 1.1 Create login form component <!-- Agent: frontend-specialist -->
  - [ ] 1.2 Implement JWT authentication API <!-- Agent: backend-developer -->
  - [ ] 1.3 Add user session management <!-- Agent: backend-developer -->
  - [ ] 1.4 Write authentication tests <!-- Agent: testing-specialist -->
```

#### Delegation Guidelines:
- **One agent per sub-task**: Each sub-task should have a single responsible agent
- **Clear assignment**: Use `<!-- Agent: agent-name -->` format for visibility
- **Logical grouping**: Related sub-tasks can go to the same agent for consistency
- **Load balancing**: Distribute work evenly when multiple agents have similar capabilities
- **Preserve metadata**: Keep agent assignments visible in the markdown for tracking

#### Assignment Communication:
When delegating, provide each agent with:
- **Specific sub-task description**: What exactly needs to be accomplished
- **Context**: How their task fits into the overall parent task
- **Dependencies**: Any other sub-tasks that must be completed first
- **Acceptance criteria**: How to know the sub-task is complete

### Agent Escalation Handling

When agents encounter tasks outside their expertise, follow this escalation protocol:

#### Escalation Triggers:
Agents should escalate when they:
- **Lack required knowledge**: Task requires skills not in their specialization
- **Encounter blockers**: Technical issues beyond their expertise
- **Need clarification**: Task requirements are unclear or ambiguous
- **Require coordination**: Task depends on work from other agents

#### Escalation Process:
1. **Agent identifies issue**: Agent recognizes they cannot complete the task effectively
2. **Agent reports to lead**: Agent communicates the specific problem to you (lead coordinator)
3. **Lead assesses situation**: You evaluate the issue and determine the best response
4. **Lead takes action**: Reassign task, provide guidance, or handle directly

#### Escalation Responses:
- **Reassignment**: Move the task to a more appropriate agent
- **Direct handling**: Lead coordinator completes the task personally
- **Guidance provision**: Give the agent additional context or resources to proceed
- **Task modification**: Break down the task into smaller, more manageable pieces

#### Escalation Communication Format:
Agents should escalate using this format:
```
ESCALATION: [Agent Name] - [Sub-task ID]
ISSUE: [Brief description of the problem]
ATTEMPTED: [What the agent tried to do]
NEEDED: [What type of help or reassignment is needed]
```

#### Lead Response Protocol:
1. **Acknowledge escalation** immediately
2. **Analyze the situation** and determine root cause
3. **Provide clear resolution** (reassignment, guidance, or direct handling)
4. **Update task list** with any changes to agent assignments
5. **Communicate resolution** to all affected agents
