# Claude Code Configuration Context

## Key Concepts

- **Settings Hierarchy**: Configuration precedence from enterprise policies → user settings → project settings
- **CLAUDE.md**: Global instructions file that overrides default behavior for all projects
- **MCP (Model Context Protocol)**: Open protocol for integrating external tools and data sources
- **Permission System**: Fine-grained control over tool usage via allow/deny lists
- **Configuration Scopes**: Enterprise, user, project, and local settings with specific precedence
- **Runtime Configuration**: Dynamic configuration merged from multiple sources
- **API Key Helper**: External command for dynamic API key generation
- **Environment Variables**: System-level configuration overrides

## Common Patterns

### Basic Settings Configuration
```json
{
  "model": "opus",
  "theme": "dark-daltonized",
  "includeCoAuthoredBy": true,
  "cleanupPeriodDays": 30
}
```
**When to use**: Initial Claude Code setup for personal use
**Expected output**: Claude uses specified model and theme preferences

### Enterprise/Corporate Configuration
```json
{
  "apiKeyHelper": "/opt/dev/bin/dev llm-gateway print-token --key",
  "env": {
    "ANTHROPIC_BASE_URL": "https://proxy.company.com/vendors/anthropic",
    "HTTPS_PROXY": "http://proxy.company.com:8080",
    "NO_PROXY": "localhost,127.0.0.1,.company.com"
  }
}
```
**When to use**: Corporate environments with API proxies and custom authentication
**Expected output**: Claude routes through corporate proxy with dynamic tokens

### MCP Server Configuration
```json
{
  "mcpServers": {
    "postgres": {
      "type": "stdio",
      "command": "/usr/local/bin/postgres-mcp",
      "args": ["--connection", "postgresql://user:pass@localhost/db"],
      "env": {
        "POSTGRES_SSL": "require"
      }
    },
    "github": {
      "type": "sse",
      "url": "https://github-mcp.example.com/sse",
      "headers": {
        "Authorization": "Bearer ${GITHUB_TOKEN}"
      }
    }
  }
}
```
**When to use**: Integrating external data sources and tools
**Expected output**: Claude can query databases and access GitHub directly

### Permission Configuration Pattern
```json
{
  "permissions": {
    "defaultMode": "allowEdits",
    "allow": [
      "Bash(npm test)",
      "Bash(npm run lint)",
      "Read",
      "Edit",
      "TodoWrite"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(curl:*)",
      "Write(/etc/*)",
      "WebFetch"
    ],
    "additionalDirectories": [
      "../shared-libs/",
      "/Users/username/reference-docs/"
    ]
  }
}
```
**When to use**: Restricting tool usage for security or workflow control
**Expected output**: Claude only executes allowed commands and accesses permitted directories

### CLAUDE.md Global Instructions
```markdown
For maximum efficiency, whenever you need to perform multiple independent operations, invoke all relevant tools simultaneously rather than sequentially.

Please write high quality, general purpose solutions. Implement solutions that work correctly for all valid inputs, not just the test cases.

Your output will be viewed in graphical diff applications, so please use whitespace sparingly to lay out the code in a readable way, but that doesn't add unnecessary diff noise.
```
**When to use**: Setting consistent behavior across all projects
**Expected output**: Claude follows these instructions in every conversation

## Implementation Details

### Configuration File Locations (macOS)

1. **Enterprise Policies** (Highest Priority)
   ```bash
   /Library/Application Support/ClaudeCode/policies.json
   ```

2. **User Settings**
   ```bash
   ~/.claude/settings.json
   ~/.claude/CLAUDE.md
   ~/.claude.json  # Runtime configuration
   ```

3. **Project Settings**
   ```bash
   .claude/settings.json       # Version controlled
   .claude/settings.local.json # Git ignored
   .claude/CLAUDE.md          # Project-specific instructions
   ```

### Configuration Merge Strategy
```bash
#!/bin/bash
# Runtime config is merged from multiple sources
jq -s '.[0] * .[1]' "$HOME/.claude.json" "./claude-config.json" > merged.json
```
**Validation**: `claude config list` shows merged configuration
**Common errors**: `jq: command not found` = Install jq via `brew install jq`

### Dynamic API Key Configuration
```bash
# Set API key helper in settings.json
{
  "apiKeyHelper": "/usr/local/bin/get-api-key.sh"
}

# Helper script must output API key to stdout
#!/bin/bash
# get-api-key.sh
vault read -field=key secret/anthropic/api-key
```
**Validation**: `claude config get apiKeyHelper` shows configured helper
**Common errors**: Script not executable = `chmod +x /usr/local/bin/get-api-key.sh`

### MCP Server Management
```bash
# Add MCP server interactively
claude mcp add postgres "npx -y @anthropic/postgres-mcp" \
  --env DATABASE_URL=postgresql://localhost/mydb

# Add MCP server via config file
echo '{
  "mcpServers": {
    "myserver": {
      "type": "stdio",
      "command": "/path/to/server",
      "args": ["--port", "3000"]
    }
  }
}' > ~/.claude/settings.json

# List active MCP servers
claude mcp list
```
**Validation**: `/mcp` in Claude shows available servers
**Common errors**: Server startup timeout = Increase timeout in server config

### Environment Variable Configuration
```bash
# Set via shell profile
export ANTHROPIC_API_KEY="sk-ant-..."
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=8192
export DISABLE_TELEMETRY=1
export BASH_DEFAULT_TIMEOUT_MS=300000

# Set via settings.json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://custom-endpoint.com",
    "NODE_ENV": "production"
  }
}
```
**Validation**: `claude config list` shows environment overrides
**Common errors**: Variable not set = Check shell profile sourcing

### Permission Management
```bash
# Allow specific commands globally
claude config set -g permissions.allow '["Bash(npm test)", "Bash(pytest)"]'

# Deny dangerous operations
claude config set -g permissions.deny '["Bash(rm -rf /)", "Write(/etc/*)"]'

# Set default permission mode
claude config set -g permissions.defaultMode "askEveryTime"
```
**Validation**: Attempting denied operation shows permission error
**Common errors**: Invalid JSON = Use proper escaping in shell

## Troubleshooting

### Configuration Not Loading
**Symptoms**: Settings changes don't take effect
**Cause**: Wrong file location or syntax error
**Fix**: 
```bash
# Validate JSON syntax
jq . ~/.claude/settings.json

# Check configuration precedence
claude config list --verbose

# Verify file permissions
ls -la ~/.claude/
```

### MCP Server Connection Failures
**Symptoms**: `/mcp` shows server as disconnected
**Cause**: Server command invalid or environment issues
**Fix**:
```bash
# Test server command directly
/path/to/mcp-server --test

# Check server logs
claude mcp logs servername

# Verify environment variables
claude mcp env servername
```

### API Key Authentication Errors
**Symptoms**: "Invalid API key" or authentication failures
**Cause**: API key not set or helper script failing
**Fix**:
```bash
# Test API key helper
$(/path/to/api-key-helper)

# Set API key directly (temporary)
export ANTHROPIC_API_KEY="sk-ant-..."

# Verify helper permissions
ls -la /path/to/api-key-helper
```

### Corporate Proxy Issues
**Symptoms**: Network timeouts or connection refused
**Cause**: Proxy configuration missing or incorrect
**Fix**:
```json
{
  "env": {
    "HTTPS_PROXY": "http://proxy.company.com:8080",
    "HTTP_PROXY": "http://proxy.company.com:8080",
    "NO_PROXY": "localhost,127.0.0.1,.company.com"
  }
}
```

### Permission Denied Errors
**Symptoms**: Tool usage blocked unexpectedly
**Cause**: Restrictive permission configuration
**Fix**:
```bash
# Check current permissions
claude config get permissions

# Temporarily bypass (development only)
claude --dangerously-skip-permissions

# Update permission lists
claude config set permissions.allow '["Bash", "Write", "Edit"]'
```

## Authoritative References
- [Claude Code Settings Documentation](https://docs.anthropic.com/en/docs/claude-code/settings)
- [Claude Code CLI Reference](https://docs.anthropic.com/en/docs/claude-code/cli-reference)
- [Model Context Protocol Specification](https://docs.anthropic.com/en/docs/claude-code/mcp)
- [Claude Code GitHub Repository](https://github.com/anthropics/claude-code)
- [Enterprise Configuration Guide](https://docs.anthropic.com/en/docs/claude-code/iam)