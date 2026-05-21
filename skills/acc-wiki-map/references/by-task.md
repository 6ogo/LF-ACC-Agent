# ACC Wiki — Task-to-File Index

Use this list to find the right resources for common development tasks.

## Web application tasks

- Scaffold new web app → `acc-scaffold` skill + examples 05-08
- Build a JSP page → `03-JSP-DEVELOPMENT.md`
- Build a JSSP JSON endpoint → `04-JSSP-API.md` + `08-CODE-TEMPLATES.md`
- Query ACC data with QueryDef → `05-DATABASE-QUERIES.md`
- Add pagination to a query → `05-DATABASE-QUERIES.md`
- Join two schemas in a QueryDef → `05-DATABASE-QUERIES.md`
- Implement file-based caching → example 06 + `07-SECURITY-PERFORMANCE.md#production-caching-patterns`
- Implement role-based access → example 07 + `10-ADVANCED-PATTERNS.md#context-variables`
- Build multi-JSSP app → `04-JSSP-API.md#advanced-patterns` + example 06
- Detect delivery anomalies → example 05 + `05-DATABASE-QUERIES.md#historical-baseline-aggregation`
- Predict KPI metrics → example 08 + `10-ADVANCED-PATTERNS.md`
- Parse ACC datetime strings → `10-ADVANCED-PATTERNS.md#b-acc-datetime-string-parsing`

## Workflow script tasks

- Write a workflow JS activity → `examples/Scripts/`
- ETL pipeline → `examples/Scripts/02-etl-processing.md`
- Delivery loading and management → `examples/Scripts/03-etl-processing.md`
- File I/O in a workflow → `examples/Scripts/`
- Persist state between workflow runs → `10-ADVANCED-PATTERNS.md` (xtk:option)
- Write to a custom schema → `10-ADVANCED-PATTERNS.md` (xtk.session.Write)

## Security and performance tasks

- Add authentication to a JSSP → `07-SECURITY-PERFORMANCE.md` + `04-JSSP-API.md`
- Prevent SQL injection in QueryDef → `07-SECURITY-PERFORMANCE.md`
- Cache expensive queries → `07-SECURITY-PERFORMANCE.md#production-caching-patterns`

## Tooling and plugin tasks

- Build a Claude Code plugin → `11-CLAUDE-CODE-PLUGIN.md`

## Debugging tasks

- Diagnose a runtime error → `09-TROUBLESHOOTING.md`
- Fix a QueryDef returning no rows → `09-TROUBLESHOOTING.md`
- Review code for security issues → `07-SECURITY-PERFORMANCE.md`
