# PRD: Team Process Tasks Command

## Introduction/Overview

The `team-process-tasks` command is an AI instruction file that extends the existing `process-task-list` functionality to work with multiple AI agents defined in a `claude-swarm.yml` configuration. This command file provides behavioral guidelines for an AI to coordinate a team of specialized agents when processing task lists.

The primary goal is to create AI instructions that enable intelligent task delegation, parallel sub-task execution, and centralized coordination while maintaining the same quality protocols as single-agent workflows.

## Goals

1. **Accelerate Development**: Enable parallel processing of sub-tasks to reduce overall completion time
2. **Maintain Quality**: Preserve the existing testing and commit protocols from `process-task-list`
3. **Intelligent Assignment**: Automatically assign sub-tasks to agents based on their specializations
4. **Centralized Coordination**: Use a lead agent to coordinate team activities and handle all commits
5. **Seamless Integration**: Work with existing task list markdown format and `claude-swarm.yml` configurations

## User Stories

1. **As a project manager**, I want to process complex task lists faster by leveraging a team of specialized agents, so that I can deliver features more quickly.

2. **As a lead developer**, I want agents to automatically handle sub-tasks in their areas of expertise while I coordinate and commit changes, so that I can focus on high-level decisions and quality control.

3. **As a team coordinator**, I want the system to prevent conflicts by processing top-level tasks sequentially while allowing parallel sub-task execution, so that dependencies are respected.

4. **As a quality manager**, I want all commits to go through a single lead agent after testing, so that code quality and consistency are maintained.

## Functional Requirements

1. **Command File Structure**: The `commands/team-process-tasks.md` file must follow the same format as existing command files with YAML frontmatter and clear AI instructions.

2. **Agent Awareness Instructions**: The AI must be instructed to read and understand the `claude-swarm.yml` file to identify available agents and their specializations.

3. **Lead Agent Role Definition**: The AI instructions must establish that the reading AI acts as the lead coordinator, managing other agents and handling all git operations.

4. **Task Assignment Guidelines**: The AI must be given clear rules for assigning sub-tasks to appropriate agents based on specializations and task content.

5. **Sequential Processing Protocol**: The instructions must maintain the same sequential top-level task constraint as `process-task-list` while enabling parallel sub-task delegation.

6. **Agent Coordination Instructions**: The AI must be taught how to delegate sub-tasks to agents, monitor their progress, and coordinate their work.

7. **Communication Protocol**: The instructions must define how the lead AI communicates with agents and receives status updates through task list modifications.

8. **Escalation Handling Guidelines**: The AI must be instructed on how to handle situations when agents encounter tasks outside their expertise.

9. **Task List Enhancement Rules**: The AI must be taught to add agent assignment metadata to task lists while maintaining markdown compatibility.

10. **Testing Coordination**: The instructions must specify that only the lead AI runs tests after all sub-tasks are completed by agents.

11. **Commit Protocol**: The AI must be instructed that only it (as lead) performs git operations, never the individual agents.

12. **Progress Tracking Instructions**: The AI must be taught to maintain visibility of agent assignments and progress through task list updates.

## Non-Goals (Out of Scope)

1. **Swarm Configuration Management**: This command will not create, edit, or modify `claude-swarm.yml` files
2. **Cross-Top-Level Parallelism**: Multiple top-level tasks will not run in parallel
3. **Individual Sub-Task Commits**: Sub-tasks will not generate separate commits
4. **External Tool Integration**: No integration with external project management tools (Jira, Trello, etc.)
5. **Agent Communication Channels**: No direct agent-to-agent messaging beyond task list updates
6. **Manual Agent Override**: No ability to manually assign specific agents to specific tasks
7. **Partial Team Management**: No ability to selectively exclude available agents from the swarm

## Design Considerations

**Instruction Format**: Follow the same structure as `process-task-list.md` with clear sections for AI behavioral guidelines, protocols, and examples.

**Task List Enhancement**: Provide instructions for adding agent assignment metadata to markdown task lists:
- Agent assignments (`<!-- Agent: frontend-specialist -->`)
- Task status with agent attribution
- Progress tracking through comments

**Agent Specialization Matching**: Include guidelines for matching task descriptions to agent specializations through keyword analysis.

**Coordination Protocol**: Define clear instructions for how the lead AI should delegate tasks, monitor progress, and coordinate team activities through task list updates.

## Technical Considerations

1. **Instruction Clarity**: The command file must provide unambiguous instructions that any AI can follow to coordinate agents effectively
2. **Markdown Compatibility**: Agent assignment metadata must not break existing markdown parsers or task list readers
3. **Command File Format**: Must follow the existing pattern established by `process-task-list.md` with proper YAML frontmatter
4. **Error Handling Instructions**: Must include guidance for the AI on handling agent failures, communication issues, and task conflicts
5. **Integration Requirements**: Must work seamlessly with existing testing frameworks, git workflows, and markdown task formats

## Success Metrics

1. **Performance Improvement**: Reduce total task completion time by 40-60% compared to single-agent processing
2. **Code Quality Maintenance**: Maintain the same test pass rate and code quality standards as single-agent workflows
3. **Agent Utilization**: Achieve 70%+ utilization rate of activated specialized agents
4. **Error Reduction**: Reduce task assignment errors through intelligent specialization matching
5. **User Adoption**: Successfully process complex multi-domain task lists without manual intervention

## Open Questions

1. **Agent Failure Recovery**: What happens if an agent becomes unavailable mid-task? Should the lead reassign or wait?
2. **Specialization Granularity**: How specific should agent specializations be? (e.g., "React" vs "Frontend" vs "JavaScript")
3. **Load Balancing**: If multiple agents have the same specialization, how should tasks be distributed among them?
4. **Progress Reporting**: Should there be real-time progress updates to the user, or only final completion notifications?
5. **Task Complexity Estimation**: Should the system consider task complexity when making assignments?
6. **Rollback Strategy**: If a top-level task fails after some sub-tasks are completed, what is the rollback procedure?