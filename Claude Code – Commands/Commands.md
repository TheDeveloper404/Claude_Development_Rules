## 📁 Project Management
```
/init - Auto-generate a CLAUDE.md for your project
/memory - Edit the CLAUDE.md memory file
/context - See what is consuming your context window
/compact - Compress context to free up space
/clear - Reset conversation history
/resume - Resume a past session
/fork - Branch conversation into a new session
/rename - Rename the current session
/add-dir - Add an extra directory to context
/copy - Select and copy code blocks
/diff - View all changes in an interactive viewer
/export - Export conversation to file or clipboard
``` 

## 📊 Information & Status
```
/usage - Check token usage against plan limits
/cost - Show current session cost
/help - List all available commands
/tasks - Check background tasks
/doctor - Run environment diagnostics
/stats - Generate usage statistics as HTML report
/debug - Display troubleshooting info
/effort - Switch thinking level (low/medium/high/auto)
/extra-usage - Enable additional usage capacity
```

## ⚙️ Mode & Model Control
```
/model - Switch between Opus, Sonnet, and Haiku
/fast - Toggle Fast Mode (Opus 2.5x speed)
/plan - Toggle Plan Mode (read-only planning)
/vim - Toggle Vim-style editing
/output-style - Change output style
/voice - Enable voice prompting
```

## 🧩 Feature Management
```
/hooks - Configure lifecycle hooks
/agents - Create and manage sub-agents
/permissions - Change permission settings
/sandbox - Enable sandbox mode
/config - Open settings interface
/rewind - Rewind conversation and/or code changes
/login - Re-authenticate
/logout - Log out
```

## 🖥️ Environment Settings
```
/terminal-setup - Set up Shift+Enter keybinding
/keybindings - Open keybindings config
/status-line - Set up terminal status line
/theme - Change syntax highlighting theme
/upgrade - Upgrade your Claude plan
```

## 🔌 Integrations & Extensions
```
/install-github-app - Set up GitHub PR auto-review
/plugin - Plugin management (add/remove/marketplace)
/mcp - Check MCP status and authentication
/vcs - Switch to Remote Control (Pioneer/Rebase)
/review - Code review of a specified PR
/pr-comments - Show PR comments for current branch
/security-review - Security audit of uncommitted changes
/skills - Skill management menu
/find-skills - Browse and install skills
/agents - Control your browser Claude Code
/ide - Manage IDE integrations
/vib - Ask a side question without interrupting
/loop - Run a prompt on a recurring schedule
```

## 📦 Bundle Commands
```
/simplify - 3-agent review (architecture, duplicates, performance)
/batch - Large-scale parallel changes across worktrees
```

## 💻 CLI Commands
```
claude - Start an interactive session
claude "question" - Start with an initial prompt
claude -p "question" - Non-interactive mode, then exit
claude -c - Resume most recent session
claude -r "ID" - Resume a session by ID
claude --from-pr - Resume session linked to a PR
claude update - Update to latest version
claude mcp add - Add an MCP server
claude mcp list - List configured MCP servers
claude mcp remove - Remove an MCP server
claude mcp serve - Run Claude Code as MCP server
claude auth login - Authenticate
claude auth status - Check auth status
claude auth logout - Log out
claude agents - List configured agents
claude re - Start Remote Control session
claude plugin - Plugin management
claude config list - Display all settings
claude config set - Update a setting
claude --dangerously-skip-permissions - No permission prompts
claude --worktree - Isolated git worktree for parallel work
claude --model opus - Specify model at launch
claude --agents "{json}" - Define sub-agents at launch
claude --append-system-prompt - Add to system prompt
claude --max-turns N - Set turn limit
```

## ⌨️ Shortcuts & Notation
```
Esc - Stop processing
Esc x2 - Open rewind menu
Shift+Tab - Cycle modes (normal/auto/accept/plan)
Tab - Toggle extended thinking
Ctrl+F - Stop all background agents
Ctrl+V - Paste image from clipboard
Ctrl+R - Reverse search command history
@filename - Reference a file or directory
#content - Add content to CLAUDE.md
!command - Execute a shell command directly
/task - Run a task in the background
"Think harder" - Force high effort for one turn
"Ultra think" - Force maximum reasoning depth
```