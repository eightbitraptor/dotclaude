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
