# LF-ACC-Agent

Shareable VS Code AI agents for Adobe Campaign Classic (ACC) development, grounded in the [LF-ACC-Wiki](../LF-ACC-Wiki) knowledge base.

## Agents

| Agent | Purpose | Tools |
|---|---|---|
| **ACC-Architect** | Plan webapps, workflows, schemas. Read-only — no code edits. | Search, web |
| **ACC-Webapp-Dev** | Build JSP pages, JSSP APIs, QueryDef, frontend. | Edit, search |
| **ACC-Workflow-Dev** | Build workflow scripts, ETL, delivery management. | Edit, search |
| **ACC-Debugger** | Diagnose bugs, performance, security issues. | Search, edit |

### Workflow (with handoffs)

```
ACC-Architect (plan)
      ↓ handoff
ACC-Webapp-Dev     ACC-Workflow-Dev
(build webapp)     (build workflow)
      ↓ handoff           ↓ handoff
         ACC-Debugger
         (debug + review)
```

## Installation

### Prerequisites

- **VS Code** (any recent version)
- **GitHub Copilot Chat** extension — `GitHub.copilot-chat` (requires an active GitHub Copilot subscription), **and/or**
- **Claude Code** extension — `anthropic.claude-code` (requires an Anthropic/Claude account)

### Step 1 — Clone both repos as siblings

Both repos must live side-by-side in the same parent directory. The agents reference the wiki via relative paths (`../LF-ACC-Wiki/`), so the sibling layout is required.

```bash
# Clone into the same parent directory
git clone https://github.com/6ogo/LF-ACC-Wiki.git
git clone https://github.com/6ogo/LF-ACC-Agent.git
```

Result:
```
parent-folder/
├── LF-ACC-Wiki/    ← knowledge base (source of truth, do not open this in VS Code)
└── LF-ACC-Agent/   ← open THIS in VS Code
```

> If you already have LF-ACC-Wiki cloned elsewhere, move or re-clone it so it is a direct sibling of LF-ACC-Agent.

### Step 2 — Open LF-ACC-Agent in VS Code

```bash
code LF-ACC-Agent
```

Or use **File → Open Folder** and select the `LF-ACC-Agent` directory.

### Step 3 — Install recommended extensions

VS Code will show a notification: *"This workspace has extension recommendations."* Click **Install All**.

To install manually:
- `Ctrl+Shift+X` → search `GitHub.copilot-chat` → Install
- `Ctrl+Shift+X` → search `anthropic.claude-code` → Install

Sign in to each extension with your GitHub / Anthropic account when prompted.

### Step 4 — Install agents globally (recommended)

Run the installer script from the repo root:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
./install.ps1
```

This copies ACC agent files into your VS Code user global storage so they are available across repositories.

### Step 5 — Uninstall (optional)

To remove globally installed ACC agents:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
./uninstall.ps1
```

### Step 6 — Open the agent in chat

**GitHub Copilot Chat:**
1. Open the Chat panel (`Ctrl+Alt+I` or click the chat icon in the sidebar)
2. Click the **agent picker** (the `@` or agent dropdown at the top of the chat input)
3. Select `ACC-Architect`, `ACC-Webapp-Dev`, `ACC-Workflow-Dev`, or `ACC-Debugger`

**Claude Code:**
1. Open the Claude Code panel from the sidebar or command palette
2. Switch to the relevant ACC agent from the agent menu

### Verifying the setup

Type `/agents` in the Copilot Chat input — all four `ACC-*` agents should appear in the list. If they don't, check:
- `LF-ACC-Wiki` is a direct sibling of `LF-ACC-Agent` (not nested or renamed)
- You opened `LF-ACC-Agent` as the workspace root (not a parent folder)
- The Copilot Chat extension is installed and signed in

## Usage

**GitHub Copilot Chat:** Open Chat panel → click the agent picker → choose an `ACC-*` agent.

**Claude Code:** Open the Claude Code panel → switch to the relevant ACC agent from the agent menu.

### Example prompts

- *ACC-Architect:* "Plan the architecture for a JSSP endpoint that lists recipients filtered by typology rule, with pagination — what schemas, query structure, and JSSP methods would you recommend?"
- *ACC-Webapp-Dev:* "Build a JSP page with a filterable recipient table and AJAX refresh."
- *ACC-Webapp-Dev (scaffold):* `/acc-scaffold MonitorDash — live delivery open/click rates with anomaly alerts`
- *ACC-Workflow-Dev:* "Write a workflow script that loads deliveries modified today and updates their sender info."
- *ACC-Debugger:* "My QueryDef returns no rows but the same filter works in the GUI — what's wrong?"

## Skills and commands

| Name | Type | Purpose |
|------|------|---------|
| `acc-scaffold` | Command + Skill | Scaffold a new ACC webapp (JSP + JSSP) from one of 5 production patterns |
| `acc-wiki-map` | Skill | Map any topic or task to the right wiki file |

**`/acc-scaffold <description>`** — describe your app and get a working JSSP + JSP skeleton. Picks from five patterns: Monitoring, Analytics, Role-Gated, Data Viewer, or Prediction.

## Knowledge base scope

The wiki (and therefore these agents) covers:
- JSP page development
- JSSP API development
- QueryDef / database queries
- Frontend patterns (CSS, charts, forms)
- Security and performance
- Code templates
- Troubleshooting and debugging
- Advanced patterns (E4X, sessions, custom schemas)
- Workflow scripting (ETL, delivery management)
- Advanced webapp examples (real-time monitoring, caching dashboards, role-based access, KPI prediction)
- Building a Claude Code plugin for ACC development

**Not covered:** SOAP API internals, ACC server installation/upgrade, marketing campaign UI. For those, see [Adobe Experience League](https://experienceleague.adobe.com/docs/campaign-classic.html).

## Updating the knowledge base

The agents reference `../LF-ACC-Wiki` via relative paths — no copying needed. Pull the latest wiki and restart your chat session to pick up new content:

```bash
cd ../LF-ACC-Wiki && git pull
```

## File layout

```
LF-ACC-Agent/
├── AGENTS.md                        # shared rules for all agents
├── CLAUDE.md                        # Claude Code entry point → AGENTS.md
├── README.md                        # this file
├── commands/
│   └── acc-scaffold.md              # /acc-scaffold slash command
├── skills/
│   ├── acc-scaffold/
│   │   ├── SKILL.md                 # 5-pattern scaffold procedure
│   │   └── references/
│   │       └── scaffold-templates.md  # ES5+E4X skeleton code per pattern
│   └── acc-wiki-map/
│       ├── SKILL.md                 # topic-to-file routing table
│       └── references/
│           ├── by-task.md           # task-to-file index
│           └── gaps.md              # known wiki gaps
├── .github/
│   ├── copilot-instructions.md      # Copilot repo-level instructions
│   └── agents/
│       ├── acc-architect.agent.md   # Copilot format
│       ├── acc-webapp-dev.agent.md
│       ├── acc-workflow-dev.agent.md
│       └── acc-debugger.agent.md
├── .claude/
│   └── agents/
│       ├── acc-architect.md         # Claude Code format
│       ├── acc-webapp-dev.md
│       ├── acc-workflow-dev.md
│       └── acc-debugger.md
└── .vscode/
    └── extensions.json              # recommends Copilot + Claude Code
```
