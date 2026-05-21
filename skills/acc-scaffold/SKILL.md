---
name: acc-scaffold
description: |
  Use this skill when the user wants to scaffold, create, bootstrap, or generate
  a new ACC web application. Triggered by phrases like:
  "scaffold a new app", "create a new webapp", "bootstrap an ACC application",
  "generate the files for a new ACC webapp", "create a monitoring app",
  "build a dashboard", "start a new ACC project"
version: 1.0.0
---

## Scaffold a New ACC Web Application

Follow these steps precisely (rigid skill — do not skip steps).

### Step 1: Gather Requirements

Ask the user for the following before generating any code:

1. **App name** — short PascalCase name for file naming (e.g., `MyMonitor`, `DialogStats`)
2. **Purpose** — one sentence describing what it displays or does
3. **Data source** — which ACC schema(s) does it query? (e.g., `nms:delivery`, `nms:recipient`)
4. **User type** — all authenticated users, or role-gated (admin vs regular)?
5. **Caching** — is the data slow/expensive to query? (yes → use file cache pattern; no → live query)
6. **Planned send date field** — does the app need KPI prediction? (yes → Pattern E)

If the user's initial message already answers these questions, proceed directly to Step 2.

### Step 2: Select the Base Pattern

Based on requirements, select one pattern from `skills/acc-scaffold/references/scaffold-templates.md`:

| Pattern | When to use |
|---------|-------------|
| A: Monitoring | Live delivery metrics, polling, status badges, anomaly detection |
| B: Analytics | Aggregated historical data, file cache, multiple tabs, enum labels |
| C: Role-Gated | Different content per user role, admin impersonation, audit trail |
| D: Data Viewer | Simple queryable table, server-side JSP rendering, filter bar |
| E: Prediction | Statistical KPI output, filter dropdowns, confidence intervals |

### Step 3: Generate Files

Read the selected pattern skeleton from `scaffold-templates.md`. Then generate:

1. **`[AppName].jssp`** — JSON API backend
   - First line: `logonEscalation("webapp");`
   - Second line: `response.contentType = "application/json; charset=UTF-8";`
   - Result envelope: `{ success: false, error: "", data: {} }`
   - Final line: `write(JSON.stringify(result));`
   - Never use `document.write()`, never use `response.addHeader`

2. **`[AppName].jsp`** — JSP frontend
   - Pure HTML shell; fetch from JSSP via browser JavaScript
   - Use CSS custom properties from `06-FRONTEND-PATTERNS.md` (LF design tokens)
   - No server-side HTML generation of data — all data comes from JSSP via fetch()

Output each file as a fenced code block with the filename as a comment on the first line.

### Step 4: Post-Generation Checklist

After generating the files, output this checklist:

```
Post-generation steps:
- [ ] Replace `/jssp/lf/[AppName].jssp` with the correct JSSP URL for your environment
- [ ] Register the web application in ACC: Administration > Web Applications
- [ ] Grant the `webapp` operator read access to the queried schemas
- [ ] If using file cache (Pattern B): create the CACHE_DIR on the ACC server
- [ ] Test with: logonEscalation("webapp") in ACC debug console first
```

### Known Gaps

This skill generates minimal working skeletons. For full implementations, see:
- Example 05 (monitoring): `../LF-ACC-Wiki/examples/Webapplications/05-real-time-monitoring.md`
- Example 06 (analytics): `../LF-ACC-Wiki/examples/Webapplications/06-caching-dashboard.md`
- Example 07 (role-gated): `../LF-ACC-Wiki/examples/Webapplications/07-role-based-access.md`
- Example 08 (prediction): `../LF-ACC-Wiki/examples/Webapplications/08-statistical-prediction.md`
