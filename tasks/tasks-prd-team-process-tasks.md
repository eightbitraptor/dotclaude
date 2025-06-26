## Relevant Files

- `commands/team-process-tasks.md` - ✅ **COMPLETED**: Comprehensive AI instruction file for coordinating agent teams during task processing. Contains complete guidelines for agent coordination, task assignment, communication protocols, enhanced task list formats, and integration with existing quality controls.

### Notes

- This is a single markdown file containing AI behavioral instructions, not a software implementation.
- The file should follow the same format and structure as `commands/process-task-list.md`.
- Focus on clear, actionable instructions that teach an AI how to coordinate agents effectively.
- Include examples of agent assignment, coordination protocols, and task delegation patterns.
- Reference the existing `process-task-list.md` as the foundation to build upon.

## Tasks

- [x] 1.0 Create the command file structure and foundation
  - [x] 1.1 Create `commands/team-process-tasks.md` with proper YAML frontmatter matching existing command format
  - [x] 1.2 Add command description and basic overview section explaining team coordination concept
  - [x] 1.3 Include reference to `claude-swarm.yml` file and its role in agent definitions
  - [x] 1.4 Establish the lead AI role and responsibilities in the instruction set
- [x] 2.0 Define agent coordination and assignment instructions
  - [x] 2.1 Write clear instructions for reading and understanding `claude-swarm.yml` agent configurations
  - [x] 2.2 Create guidelines for matching task descriptions to agent specializations using keyword analysis
  - [x] 2.3 Define protocols for automatic agent activation based on task list requirements
  - [x] 2.4 Establish rules for sub-task delegation to appropriate specialized agents
  - [x] 2.5 Include instructions for handling agent escalation when tasks are outside their expertise
- [x] 3.0 Establish task processing and coordination protocols
  - [x] 3.1 Adapt the sequential top-level task processing rule from `process-task-list.md`
  - [x] 3.2 Define how parallel sub-task execution should work under lead AI coordination
  - [x] 3.3 Create instructions for monitoring agent progress and coordinating their work
  - [x] 3.4 Establish communication protocols between lead AI and agents through task list updates
  - [x] 3.5 Define error handling procedures for agent failures or communication issues
- [x] 4.0 Create enhanced task list format instructions
  - [x] 4.1 Define how to add agent assignment metadata using HTML comments (<!-- Agent: name -->)
  - [x] 4.2 Create examples of enhanced task lists with agent assignments and progress tracking
  - [x] 4.3 Ensure instructions maintain compatibility with existing markdown task list format
  - [x] 4.4 Include guidelines for updating task lists with agent progress and status
- [x] 5.0 Integrate team protocols with existing quality controls
  - [x] 5.1 Adapt the existing completion protocol (test → stage → commit) for team coordination
  - [x] 5.2 Establish that only the lead AI performs git operations, never individual agents
  - [x] 5.3 Define testing coordination where lead AI runs tests after all agent sub-tasks complete
  - [x] 5.4 Include conventional commit format guidelines with team context information
  - [x] 5.5 Add examples of successful team task completion workflows