# LF-ACC-Agent

LF-ACC-Agent is a shareable agent pack for Adobe Campaign Classic development in VS Code.

It provides specialized AI agents for:
- ACC web application work (JSP, JSSP, QueryDef, frontend)
- ACC workflow scripting (ETL, delivery operations, file handling)
- Debugging, performance checks, and security-focused reviews

All agent guidance is grounded in LF-ACC-Wiki, which must exist as a sibling folder next to this repository.

## Quick Start

1. Clone both repositories as siblings.
2. Open LF-ACC-Agent in VS Code.
3. Install recommended extensions.
4. Run the installer script.
5. Select an ACC agent in chat and start prompting.

## What You Get

| Agent | Main job |
|---|---|
| ACC-Architect | Plan schemas, webapps, workflows, and implementation approach (read-only planning) |
| ACC-Webapp-Dev | Build and update JSP, JSSP, QueryDef, and frontend logic |
| ACC-Workflow-Dev | Build and update workflow scripts and automation logic |
| ACC-Debugger | Diagnose and fix ACC webapp/workflow issues |

Typical flow:

ACC-Architect plans first, then handoff to ACC-Webapp-Dev or ACC-Workflow-Dev, and finally ACC-Debugger for validation and fixes.

## Installation

### Prerequisites

- VS Code (recent version)
- One of these chat runtimes:
      - GitHub Copilot Chat extension: GitHub.copilot-chat
      - Claude Code extension: anthropic.claude-code

### 1) Clone as sibling folders

From the same parent directory:

```bash
git clone https://github.com/6ogo/LF-ACC-Wiki.git
git clone https://github.com/6ogo/LF-ACC-Agent.git
```

Expected layout:

```text
parent-folder/
      LF-ACC-Wiki/
      LF-ACC-Agent/
```

Important: LF-ACC-Wiki must be a direct sibling of LF-ACC-Agent, not nested elsewhere.

### 2) Open LF-ACC-Agent in VS Code

```bash
code LF-ACC-Agent
```

### 3) Install workspace extension recommendations

When VS Code prompts, install all recommended extensions.
If needed, install manually from the Extensions panel:
- GitHub.copilot-chat
- anthropic.claude-code

Sign in to the extension(s) you installed.

### 4) Install agents globally

Run from the LF-ACC-Agent repo root:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
./install.ps1
```

This installs the ACC agent definitions into your VS Code user global storage so they can be used across projects.

### 5) Optional uninstall

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
./uninstall.ps1
```

## Start Using The Agents

### In GitHub Copilot Chat

1. Open Chat.
2. Open the agent picker at the top of the input.
3. Select one of: ACC-Architect, ACC-Webapp-Dev, ACC-Workflow-Dev, ACC-Debugger.
4. Enter your task with ACC context and desired outcome.

### In Claude Code

1. Open Claude Code in VS Code.
2. Pick the ACC agent from the agent list.
3. Enter your task with ACC context and desired outcome.

### Verify Setup

In chat, run:

```text
/agents
```

You should see all ACC agents listed.

If not:
- Confirm LF-ACC-Wiki and LF-ACC-Agent are siblings.
- Confirm LF-ACC-Agent is the opened workspace root.
- Restart VS Code after running install.ps1.

## First Prompts To Try

- ACC-Architect: Plan a recipient search JSSP endpoint with pagination and role checks.
- ACC-Webapp-Dev: Build a JSP dashboard with AJAX filters and QueryDef-backed data table.
- ACC-Workflow-Dev: Create a workflow script that updates sender metadata for today modified deliveries.
- ACC-Debugger: Investigate why a QueryDef returns no rows although GUI filtering works.

Scaffolding shortcut:

```text
/acc-scaffold MonitorDash live delivery open and click rates with anomaly alerts
```

## Scope

Covered topics include:
- JSP and JSSP development
- QueryDef and ACC data access patterns
- Workflow scripting and ETL patterns
- Security, performance, troubleshooting
- Advanced webapp examples and templates

Out of scope:
- SOAP API internals
- ACC server installation and upgrade
- Marketing campaign UI operations

For out-of-scope areas, use Adobe Experience League:
https://experienceleague.adobe.com/docs/campaign-classic.html

## Keep Knowledge Current

Update the wiki and restart chat sessions when needed:

```bash
cd ../LF-ACC-Wiki
git pull
```
