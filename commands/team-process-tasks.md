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

## Task Processing and Coordination Protocols

### Sequential Top-Level Task Processing

**Critical Rule**: Maintain the same sequential constraint as `process-task-list` for top-level tasks:

#### Sequential Processing Requirements:
- **One top-level task at a time**: Never work on multiple parent tasks simultaneously
- **Complete before advancing**: All sub-tasks of a parent task must be completed before starting the next parent task
- **Lead coordination**: You (as lead) are responsible for enforcing this sequence
- **Agent coordination**: Agents may work in parallel on sub-tasks within the same parent task, but never across different parent tasks

#### Adapted Process:
1. **Select current parent task**: Choose the next uncompleted top-level task in sequence
2. **Delegate sub-tasks**: Assign all sub-tasks of the current parent task to appropriate agents
3. **Monitor parallel progress**: Track agent work on their assigned sub-tasks within this parent task
4. **Wait for completion**: Do not advance to the next parent task until ALL sub-tasks are marked `[x]`
5. **Run completion protocol**: Execute testing, staging, and commit sequence for the parent task
6. **Advance to next**: Only then move to the next parent task in the sequence

#### Example Sequential Flow:
```
Parent Task 1.0: ✅ All sub-tasks completed → Test → Commit → ADVANCE
Parent Task 2.0: 🔄 Sub-tasks 2.1, 2.2, 2.3 being worked on in parallel by agents
Parent Task 3.0: ⏸️ Waiting (do not start until 2.0 is fully complete)
```

### Parallel Sub-Task Execution Coordination

Within a single parent task, agents can work on sub-tasks simultaneously under lead coordination:

#### Parallel Execution Rules:
- **Same parent task only**: Agents can only work in parallel on sub-tasks within the current parent task
- **Independent sub-tasks**: Sub-tasks that don't depend on each other can run simultaneously
- **Dependency respect**: Sub-tasks with dependencies must wait for prerequisite completion
- **Lead oversight**: Lead coordinator monitors all parallel work and resolves conflicts

#### Coordination Process:
1. **Analyze dependencies**: Review sub-tasks for any interdependencies before assignment
2. **Create assignment plan**: Determine which sub-tasks can run in parallel vs. sequentially
3. **Delegate simultaneously**: Assign multiple sub-tasks to different agents at once
4. **Monitor progress**: Track each agent's progress independently
5. **Coordinate integration**: Ensure parallel work integrates properly

#### Dependency Management:
- **Identify dependencies**: Look for sub-tasks that require outputs from other sub-tasks
- **Sequential within parallel**: Some sub-tasks may need to run in sequence even within parallel execution
- **Clear communication**: Inform agents about dependencies that affect their work
- **Coordination points**: Define checkpoints where agents must sync their work

#### Example Parallel Coordination:
```markdown
- [ ] 2.0 Build API integration system
  - [ ] 2.1 Design API schema <!-- Agent: backend-developer --> (Independent)
  - [ ] 2.2 Create frontend API service <!-- Agent: frontend-specialist --> (Independent) 
  - [ ] 2.3 Implement API endpoints <!-- Agent: backend-developer --> (Depends on 2.1)
  - [ ] 2.4 Write integration tests <!-- Agent: testing-specialist --> (Depends on 2.2, 2.3)
```

**Execution Flow**:
- **Phase 1**: 2.1 and 2.2 run in parallel (independent)
- **Phase 2**: 2.3 starts after 2.1 completes
- **Phase 3**: 2.4 starts after both 2.2 and 2.3 complete

### Agent Progress Monitoring and Work Coordination

As lead coordinator, actively monitor and coordinate all agent work:

#### Monitoring Responsibilities:
- **Track individual progress**: Monitor each agent's assigned sub-tasks for completion status
- **Identify bottlenecks**: Spot agents who are stuck or taking longer than expected
- **Coordinate handoffs**: Manage transitions when one sub-task's output feeds into another
- **Ensure quality**: Review agent work for consistency and integration compatibility
- **Maintain timeline**: Keep the overall parent task moving toward completion

#### Progress Tracking Methods:
1. **Task list updates**: Agents mark their sub-tasks as `[x]` when complete
2. **Status check-ins**: Periodically ask agents for progress updates
3. **Integration reviews**: Check that completed sub-tasks work together properly
4. **Quality checkpoints**: Verify agent work meets project standards

#### Coordination Techniques:
- **Regular synchronization**: Schedule coordination points where all agents sync up
- **Conflict resolution**: Resolve overlapping work or inconsistent approaches between agents  
- **Resource sharing**: Facilitate agents sharing information, code, or outputs
- **Timeline management**: Adjust agent assignments if some are ahead/behind schedule

#### Progress Communication:
```markdown
<!-- Lead coordination status -->
Parent Task 2.0 Progress Summary:
- 2.1 ✅ Completed by backend-developer (API schema ready)
- 2.2 🔄 In progress by frontend-specialist (60% complete)
- 2.3 ⏸️ Waiting for 2.1 handoff to backend-developer
- 2.4 ⏸️ Pending completion of 2.2 and 2.3

Next Action: Coordinate 2.1 → 2.3 handoff, check frontend-specialist progress
```

#### Coordination Interventions:
- **Reassignment**: Move sub-tasks between agents if needed
- **Additional support**: Provide extra context or resources to struggling agents
- **Work breakdown**: Split complex sub-tasks into smaller pieces
- **Direct handling**: Take over sub-tasks that prove too challenging for agents

### Communication Protocols Through Task List Updates

All communication between lead coordinator and agents happens through the shared task list file:

#### Communication Channels:
- **Primary channel**: Task list markdown file with HTML comments
- **Status updates**: Agents update task completion status (`[ ]` → `[x]`)
- **Coordination notes**: Lead adds instructions and status via HTML comments
- **Progress tracking**: Real-time visibility through task list modifications

#### Communication Format Standards:

**Agent Assignment**:
```markdown
- [ ] 2.1 Create user authentication API <!-- Agent: backend-developer -->
```

**Lead Instructions to Agents**:
```markdown
- [ ] 2.2 Build login form <!-- Agent: frontend-specialist -->
<!-- INSTRUCTION: Use the API schema from task 2.1, focus on responsive design -->
```

**Agent Status Updates**:
```markdown
- [x] 2.3 Write authentication tests <!-- Agent: testing-specialist -->
<!-- COMPLETED: All tests passing, coverage at 95% -->
```

**Lead Coordination Notes**:
```markdown
- [ ] 2.4 Integrate auth system <!-- Agent: backend-developer -->
<!-- STATUS: Waiting for frontend completion, estimated start time 2PM -->
```

#### Communication Protocols:
1. **Assignment communication**: Lead adds agent assignments with clear instructions
2. **Progress updates**: Agents mark completion and add status notes
3. **Coordination updates**: Lead provides status, timeline, and coordination information
4. **Issue communication**: Use escalation format for problems requiring attention

#### Update Frequency:
- **Agents**: Update task status immediately upon completion
- **Lead**: Review and update coordination status every 30 minutes or after major milestones
- **Status checks**: Lead requests progress updates when tasks seem stalled

#### Visibility Rules:
- **All updates visible**: Every team member can see all task list updates
- **Clear attribution**: All comments clearly identify who added them
- **Timestamp awareness**: Include timing information for critical coordination points
- **Persistent history**: Keep communication history in comments for reference

### Error Handling Procedures for Agent Failures

Define clear procedures for handling various types of agent and communication failures:

#### Types of Failures:
1. **Agent becomes unresponsive**: Agent stops updating task status or responding to communication
2. **Task completion failure**: Agent unable to complete assigned sub-task despite multiple attempts
3. **Quality issues**: Agent's work doesn't meet standards or integrate properly
4. **Communication breakdown**: Misunderstanding of requirements leading to incorrect implementation
5. **Technical blockers**: Agent encounters technical issues beyond their capability

#### Error Detection:
- **Timeout detection**: Sub-task taking significantly longer than expected
- **Status stagnation**: No task list updates from agent for extended period  
- **Quality review failure**: Completed work doesn't pass integration or quality checks
- **Escalation signals**: Agent explicitly requests help via escalation protocol
- **Integration conflicts**: Agent's work conflicts with other agents' contributions

#### Error Response Procedures:

**For Agent Unresponsiveness**:
1. **Status check**: Request immediate status update via task list comment
2. **Deadline warning**: Set clear deadline for response
3. **Reassignment**: If no response, reassign sub-task to different agent
4. **Documentation**: Record the failure for future reference

**For Task Completion Failure**:
1. **Root cause analysis**: Understand why the agent cannot complete the task
2. **Provide assistance**: Offer additional guidance, context, or resources
3. **Task breakdown**: Split complex sub-task into smaller, manageable pieces
4. **Alternative assignment**: Reassign to agent with more relevant specialization
5. **Direct intervention**: Lead coordinator completes the task personally

**For Quality Issues**:
1. **Specific feedback**: Provide clear, actionable feedback on quality problems
2. **Standards clarification**: Ensure agent understands quality requirements
3. **Iteration support**: Guide agent through improvement process
4. **Quality checkpoint**: Add additional review steps for this agent's future work

**For Communication Breakdown**:
1. **Clarification session**: Provide detailed explanation of requirements
2. **Example provision**: Give concrete examples of expected outcomes
3. **Check understanding**: Verify agent comprehends the requirements
4. **Enhanced monitoring**: Increase oversight for this agent's subsequent tasks

#### Error Recovery Actions:
- **Task list updates**: Document all error handling actions in task list comments
- **Timeline adjustment**: Revise project timeline if errors cause significant delays  
- **Team communication**: Inform other agents of any changes affecting their work
- **Process improvement**: Learn from errors to prevent similar issues in future tasks

## Enhanced Task List Format Instructions

### Agent Assignment Metadata Format

Enhance the standard markdown task list format by adding agent assignment metadata using HTML comments:

#### Basic Assignment Format:
```markdown
- [ ] 1.1 Create user registration form <!-- Agent: frontend-specialist -->
- [ ] 1.2 Implement user authentication API <!-- Agent: backend-developer -->
- [ ] 1.3 Write unit tests for auth system <!-- Agent: testing-specialist -->
```

#### HTML Comment Rules:
- **Placement**: Add `<!-- Agent: agent-name -->` immediately after the sub-task description
- **Naming**: Use exact agent names from `claude-swarm.yml` configuration
- **Visibility**: Comments are visible in source but don't affect markdown rendering
- **Persistence**: Keep agent assignments in place throughout task lifecycle

#### Extended Metadata Format:
```markdown
- [ ] 2.1 Build payment processing <!-- Agent: backend-developer -->
<!-- PRIORITY: High | DEPENDS: Task 1.2 | EST: 4 hours -->
<!-- INSTRUCTION: Use Stripe API, implement webhook handling -->
```

#### Assignment Status Indicators:
```markdown
- [ ] 3.1 Design landing page <!-- Agent: frontend-specialist -->
<!-- STATUS: In Progress (started 2PM) -->

- [x] 3.2 Create database schema <!-- Agent: backend-developer -->
<!-- COMPLETED: All migrations ready, foreign keys validated -->
```

#### Lead Coordination Metadata:
```markdown
- [ ] 4.1 Integration testing <!-- Agent: testing-specialist -->
<!-- COORDINATION: Waiting for tasks 4.2 and 4.3 completion -->
<!-- NEXT: Will notify agent when dependencies are ready -->
```

#### Metadata Guidelines:
- **Clarity**: Make all metadata human-readable and clear
- **Consistency**: Use standardized keywords (STATUS, INSTRUCTION, COMPLETED, etc.)
- **Non-breaking**: Ensure metadata doesn't interfere with existing markdown parsers
- **Searchable**: Use consistent formatting for easy searching and filtering

### Enhanced Task List Examples

#### Example 1: E-commerce Checkout System
```markdown
## Tasks

- [x] 1.0 Build user authentication system
  - [x] 1.1 Create login form component <!-- Agent: frontend-specialist -->
  <!-- COMPLETED: Responsive design, form validation included -->
  - [x] 1.2 Implement JWT authentication API <!-- Agent: backend-developer -->
  <!-- COMPLETED: JWT tokens, refresh logic, rate limiting -->
  - [x] 1.3 Add user session management <!-- Agent: backend-developer -->
  <!-- COMPLETED: Redis session store, automatic cleanup -->
  - [x] 1.4 Write authentication tests <!-- Agent: testing-specialist -->
  <!-- COMPLETED: Unit tests (98% coverage), integration tests -->

- [ ] 2.0 Develop payment processing system
  - [ ] 2.1 Design payment UI components <!-- Agent: frontend-specialist -->
  <!-- STATUS: In Progress - wireframes done, coding started -->
  <!-- INSTRUCTION: Support credit cards and PayPal, mobile-first design -->
  
  - [ ] 2.2 Create payment API endpoints <!-- Agent: backend-developer -->
  <!-- STATUS: Pending - waiting for 2.1 design specs -->
  <!-- DEPENDS: Task 2.1 for UI requirements -->
  
  - [ ] 2.3 Integrate Stripe payment gateway <!-- Agent: backend-developer -->
  <!-- STATUS: Ready to start -->
  <!-- INSTRUCTION: Implement webhooks, handle async payment confirmations -->
  
  - [ ] 2.4 Add payment validation and error handling <!-- Agent: backend-developer -->
  <!-- STATUS: Waiting -->
  <!-- DEPENDS: Tasks 2.2 and 2.3 -->
  
  - [ ] 2.5 Write payment system tests <!-- Agent: testing-specialist -->
  <!-- STATUS: Test cases prepared, waiting for implementation -->
  <!-- INSTRUCTION: Include mock payment scenarios, error cases -->

- [ ] 3.0 Implement order management
  <!-- COORDINATION: Will start after 2.0 completion -->
```

#### Example 2: Real-time Progress Tracking
```markdown
<!-- LEAD STATUS UPDATE (3:30 PM) -->
<!-- Current Focus: Parent Task 2.0 - Payment Processing -->
<!-- Active Agents: frontend-specialist (2.1), backend-developer (2.3) -->
<!-- Blocked: 2.2 waiting for 2.1, 2.4 waiting for 2.2+2.3 -->
<!-- Next Actions: Check frontend progress, start 2.2 when ready -->

## Tasks

- [ ] 2.0 Develop payment processing system
  - [ ] 2.1 Design payment UI components <!-- Agent: frontend-specialist -->
  <!-- STATUS: 75% complete - final mobile styling in progress -->
  <!-- ESTIMATED COMPLETION: 4:00 PM today -->
  
  - [ ] 2.2 Create payment API endpoints <!-- Agent: backend-developer -->
  <!-- STATUS: Ready to start once 2.1 provides specs -->
  <!-- COORDINATION: Will assign to backend-developer at 4:00 PM -->
  
  - [ ] 2.3 Integrate Stripe payment gateway <!-- Agent: backend-developer -->
  <!-- STATUS: In Progress - API integration 60% complete -->
  <!-- NEXT: Webhook implementation this evening -->
```

#### Example 3: Cross-Agent Dependencies
```markdown
- [ ] 3.0 Build real-time notification system
  - [ ] 3.1 Design notification UI components <!-- Agent: frontend-specialist -->
  <!-- STATUS: Completed - components ready for integration -->
  
  - [ ] 3.2 Implement WebSocket server <!-- Agent: backend-developer -->
  <!-- STATUS: In Progress - server setup done, need client protocol -->
  <!-- COORDINATION: Working with frontend-specialist on message format -->
  
  - [ ] 3.3 Create notification API <!-- Agent: backend-developer -->
  <!-- STATUS: Waiting - will start after 3.2 WebSocket completion -->
  
  - [ ] 3.4 Integrate frontend notifications <!-- Agent: frontend-specialist -->
  <!-- STATUS: Ready to start once 3.2 provides WebSocket protocol -->
  <!-- DEPENDS: Task 3.2 for connection protocol -->
  
  - [ ] 3.5 Test notification delivery <!-- Agent: testing-specialist -->
  <!-- STATUS: Test scenarios prepared -->
  <!-- DEPENDS: Tasks 3.2, 3.3, 3.4 for complete system -->
```

### Compatibility with Existing Markdown Task Lists

**Critical Requirement**: Enhanced task lists must remain fully compatible with existing `process-task-list` workflows:

#### Compatibility Principles:
- **Standard markdown preserved**: Core task list structure remains unchanged
- **HTML comments only**: All enhancements use HTML comments that don't affect rendering
- **Optional metadata**: Enhanced features are additive, not required for basic functionality
- **Tool compatibility**: Works with existing markdown parsers, editors, and viewers

#### Backward Compatibility:
```markdown
<!-- This works with both team-process-tasks AND process-task-list -->
- [ ] 1.0 Build authentication system
  - [ ] 1.1 Create login form
  - [ ] 1.2 Implement authentication API
  - [ ] 1.3 Write unit tests

<!-- Enhanced version - additional metadata ignored by process-task-list -->
- [ ] 1.0 Build authentication system
  - [ ] 1.1 Create login form <!-- Agent: frontend-specialist -->
  - [ ] 1.2 Implement authentication API <!-- Agent: backend-developer -->
  - [ ] 1.3 Write unit tests <!-- Agent: testing-specialist -->
```

#### Migration Path:
1. **Existing task lists work unchanged**: No modifications required for current workflows
2. **Gradual enhancement**: Add agent assignments only when using team coordination
3. **Fallback behavior**: If team coordination isn't used, functions like normal process-task-list
4. **No breaking changes**: Enhanced metadata never interferes with standard markdown parsing

#### Compatibility Rules:
- **Never modify standard syntax**: Keep `- [ ]` and `- [x]` format unchanged
- **HTML comments only**: All enhancements must use `<!-- -->` comment format
- **Preserve indentation**: Maintain existing indentation and nesting structure
- **Optional features**: All team features work as optional enhancements to base functionality

#### Testing Compatibility:
- **Standard parsers**: Task lists render correctly in GitHub, GitLab, and other markdown viewers
- **Existing tools**: Work with current task list management tools and scripts
- **Single-agent mode**: Function perfectly when used without team coordination
- **Incremental adoption**: Teams can gradually adopt enhanced features without disrupting workflows

### Guidelines for Task List Updates with Agent Progress

Establish clear protocols for maintaining task list updates as agents work:

#### Update Responsibilities:

**Lead Coordinator (You)**:
- Add initial agent assignments when delegating tasks
- Provide coordination status and timeline updates
- Document dependency information and blockers
- Update overall project status and next actions

**Individual Agents**:
- Mark sub-tasks complete (`[ ]` → `[x]`) when finished
- Add completion notes with key accomplishments
- Report status updates for long-running tasks
- Communicate blockers or escalation needs

#### Update Timing:
- **Immediate**: Mark task completion as soon as work is done
- **Regular intervals**: Status updates every 2-3 hours for active tasks
- **Milestone points**: Updates when reaching significant progress markers
- **Before blockers**: Immediate updates when encountering issues

#### Update Format Standards:

**Task Completion Updates**:
```markdown
- [x] 2.1 Create user dashboard <!-- Agent: frontend-specialist -->
<!-- COMPLETED: Responsive design implemented, includes dark mode toggle -->
<!-- FILES: src/components/Dashboard.tsx, src/styles/dashboard.css -->
```

**Progress Status Updates**:
```markdown
- [ ] 2.2 Implement search functionality <!-- Agent: backend-developer -->
<!-- STATUS: 60% complete - basic search done, working on filters -->
<!-- ESTIMATED COMPLETION: Tomorrow 2PM -->
```

**Blocker Reports**:
```markdown
- [ ] 2.3 Add payment integration <!-- Agent: backend-developer -->
<!-- BLOCKED: Need Stripe API credentials from project admin -->
<!-- ESCALATION: Waiting for admin response, alternative: use test keys -->
```

**Lead Coordination Updates**:
```markdown
<!-- COORDINATION UPDATE (4:15 PM) -->
<!-- Parent Task 2.0 Status: 3 of 5 sub-tasks completed -->
<!-- Active: frontend-specialist (2.4), backend-developer (2.5) -->
<!-- Next: Begin task 3.0 when 2.4 and 2.5 complete (estimated 6PM) -->
```

#### Quality Guidelines:
- **Be specific**: Include concrete details about what was accomplished
- **Reference files**: List key files created or modified
- **Estimate timing**: Provide realistic completion estimates for in-progress work
- **Clear blockers**: Explicitly state what is preventing progress
- **Actionable updates**: Include information that helps coordination decisions

#### Maintenance Protocol:
1. **Clean old status**: Remove outdated progress comments when tasks complete
2. **Preserve completion**: Keep final completion notes for project history
3. **Update dependencies**: Modify dependent task status when blockers resolve
4. **Consolidate updates**: Merge multiple small updates into comprehensive status comments
