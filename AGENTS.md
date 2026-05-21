# LF-ACC Agent — Shared Rules

This repo provides Adobe Campaign Classic (ACC) specialist AI agents for VS Code. All agents are grounded in the LF-ACC-Wiki knowledge base located at `../LF-ACC-Wiki` (sibling directory).

## Scope

These agents cover: ACC web application development (JSP, JSSP, QueryDef), workflow scripting (ETL, delivery management, file operations), security, performance, and troubleshooting. Real-world webapp examples are in `../LF-ACC-Wiki/examples/Webapplications/` (01–08), including real-time monitoring (05), caching dashboards (06), role-based access (07), and KPI prediction (08). A plugin authoring guide is at `../LF-ACC-Wiki/11-CLAUDE-CODE-PLUGIN.md`.

**Out of scope:** SOAP API internals, server installation/upgrade, marketing campaign UI, and anything not documented in the LF-ACC-Wiki. If asked about these topics, say the wiki does not cover them and recommend [Adobe Experience League](https://experienceleague.adobe.com/docs/campaign-classic.html).

## Citation rule

Whenever a recommendation originates from the wiki, cite the source file and section heading. Example: "per `04-JSSP-API.md § Error Handling`".

## Code style

- Server-side ACC JavaScript is **ES5 + E4X** (no ES6+, no arrow functions, no template literals, no `const`/`let` — use `var`)
- Follow the templates and patterns in `../LF-ACC-Wiki/08-CODE-TEMPLATES.md`
- Use `logonEscalation("webapp")` for webapp authentication (never roll your own auth)
- All QueryDef operations follow `../LF-ACC-Wiki/05-DATABASE-QUERIES.md`

## Wiki location

The full knowledge base lives at `../LF-ACC-Wiki/` (relative to this repo root). Agent files sit two directories below the repo root (inside `.github/agents/` or `.claude/agents/`), so three `..` segments are needed to reach the sibling `LF-ACC-Wiki/` directory. Example: `../../../LF-ACC-Wiki/04-JSSP-API.md`.
