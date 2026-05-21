# ACC Scaffold Pattern Templates

Five minimal skeleton templates. Select the appropriate pattern and fill in the business logic.

---

## Pattern A: Monitoring (AlertSystem base)

**Use when:** Real-time delivery monitoring, polling frontend, status badges, anomaly detection.

### A.jssp — Monitoring API skeleton

```jsp
<%
logonEscalation("webapp");
response.contentType = "application/json; charset=UTF-8";

var CONFIG = {
  MONITORING_WINDOW_HOURS: 168,
  MIN_SENT_FOR_ALERTS: 100
};

var result = {
  success: false,
  error: "",
  data: {
    deliveries: [],
    historicalAverages: {},
    stats: { criticalCount: 0, warningCount: 0, okCount: 0 }
  }
};

try {
  // TODO: Step 1 — Build historical baseline (last 90 days, excluding monitoring window)
  // Query nms:delivery with SubDays(GetDate(), 90) to SubHours(GetDate(), MONITORING_WINDOW_HOURS)
  // Group by @dialog, compute avgOpenRate and avgOptoutRate, require count >= 3

  // TODO: Step 2 — Query current monitoring window
  // Query nms:delivery with SubHours(GetDate(), MONITORING_WINDOW_HOURS)

  // TODO: Step 3 — Classify each delivery
  // Call determineDeliveryStatus(openRate, optoutRate, hoursSinceSend, totalSent, historicalAvg)
  // Push { id, label, dialog, openRate, optoutRate, status, reason } to result.data.deliveries

  result.success = true;
} catch (e) {
  result.error = e.message || e.toString();
}

write(JSON.stringify(result));
%>
```

### A.jsp — Monitoring dashboard skeleton

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Delivery Monitor</title>
  <style>
    :root { --primary: #005aa0; --primary-light: #4495d1; }
    .status-badge { display: inline-block; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; }
    .status-badge.critical { background: #fde8e8; color: #c0392b; }
    .status-badge.warning  { background: #fef9e7; color: #d68910; }
    .status-badge.ok       { background: #e8f5e9; color: #1e8449; }
  </style>
</head>
<body>
  <div id="stats"></div>
  <table><thead><tr><th>Status</th><th>Delivery</th><th>Open Rate</th><th>Opt-out</th></tr></thead>
  <tbody id="deliveriesBody"></tbody></table>
  <p id="lastUpdate"></p>

  <script>
    function loadData() {
      fetch('/jssp/lf/[AppName].jssp')
        .then(function(r) { return r.json(); })
        .then(function(json) {
          if (!json.success) return;
          renderDeliveries(json.data.deliveries);
          document.getElementById('lastUpdate').textContent = 'Updated: ' + new Date().toLocaleTimeString();
        });
    }
    function renderDeliveries(items) {
      var tbody = document.getElementById('deliveriesBody');
      tbody.innerHTML = '';
      for (var i = 0; i < items.length; i++) {
        var d = items[i];
        var row = document.createElement('tr');
        row.innerHTML = '<td><span class="status-badge ' + d.status + '">' + d.status + '</span></td>' +
          '<td>' + d.label + '</td><td>' + d.openRate.toFixed(1) + '%</td><td>' + d.optoutRate.toFixed(2) + '%</td>';
        tbody.appendChild(row);
      }
    }
    loadData();
    setInterval(loadData, 30000);
  </script>
</body>
</html>
```

---

## Pattern B: Analytics (SendoutAnalytics base)

**Use when:** Aggregated historical data, file-based caching, tab navigation, enum label lookup.

### B.jssp — Analytics API skeleton (reader)

```jsp
<%
logonEscalation("webapp");
response.contentType = "application/json; charset=UTF-8";

var CACHE_DIR = "D:/GIS/FT/MA_PROD/Outbox/[AppName]Cache/";
var result = { success: false, error: "", data: null };

try {
  var dateFrom = request.getParameter('dateFrom') || '2024-01-01';
  var dateTo   = request.getParameter('dateTo')   || '2024-12-31';
  var useCache = (request.getParameter('useCache') !== 'false');

  var data = null;
  if (useCache) {
    // TODO: implement readCacheFile(dateFrom, dateTo) using java.io.File
    data = readCacheFile(dateFrom, dateTo);
  }
  if (!data) {
    // TODO: implement runLiveQuery(dateFrom, dateTo)
    data = runLiveQuery(dateFrom, dateTo);
  }

  result.data    = data;
  result.success = (data !== null);
  if (!result.success) result.error = "No data available";
} catch (e) {
  result.error = e.message || e.toString();
}

write(JSON.stringify(result));
%>
```

### B.jsp — Analytics dashboard skeleton (tab nav)

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Analytics Dashboard</title>
  <style>
    :root { --primary: #005aa0; }
    .nav-tabs { display: flex; gap: 4px; border-bottom: 2px solid var(--primary); margin-bottom: 20px; }
    .nav-tab { padding: 8px 18px; border: none; background: #e8f0f8; color: var(--primary); cursor: pointer; border-radius: 4px 4px 0 0; }
    .nav-tab.active { background: var(--primary); color: #fff; }
    .tab-content { display: none; }
    .tab-content.active { display: block; }
  </style>
</head>
<body>
  <div class="nav-tabs">
    <button class="nav-tab active" onclick="switchTab('overview')">Overview</button>
    <button class="nav-tab" onclick="switchTab('details')">Details</button>
  </div>
  <div id="tab-overview" class="tab-content active"><!-- TODO: KPI cards --></div>
  <div id="tab-details"  class="tab-content"><!-- TODO: Data table --></div>
  <script>
    function switchTab(id) {
      document.querySelectorAll('.nav-tab').forEach(function(t, i) {
        t.classList.toggle('active', ['overview','details'][i] === id);
      });
      document.querySelectorAll('.tab-content').forEach(function(p) {
        p.classList.toggle('active', p.id === 'tab-' + id);
      });
    }
    // TODO: fetch from [AppName].jssp and render data
  </script>
</body>
</html>
```

---

## Pattern C: Role-Gated (DialogOptOutIN base)

**Use when:** Different content per user role, admin impersonation, mutation with audit trail.

### C.jssp — Mutation handler skeleton

```jsp
<%
logonEscalation("webapp");
response.contentType = "application/json; charset=UTF-8";

var result = { success: false, error: "" };

try {
  var entityId  = request.getParameter('entityId')  || '';
  var action    = request.getParameter('action')    || '';
  var userLogin = request.getParameter('userLogin') || '';

  if (!entityId || !action) {
    result.error = "Missing required parameters";
    write(JSON.stringify(result));
    return; // halt processing
  }

  // TODO: validate action is in allowed set (e.g., 'include' or 'exclude')
  // TODO: perform update via xtk.session.Write
  // TODO: write audit record via xtk.session.Write to lf:auditLog schema

  logInfo("[AppName] action=" + action + " entityId=" + entityId + " by=" + userLogin);
  result.success = true;
} catch (e) {
  result.error = e.message || e.toString();
}

write(JSON.stringify(result));
%>
```

### C.jsp — Role-gated page skeleton

```jsp
<%
// Read role from ctx.vars — always String(), never Boolean()
var isAdmin  = (String(ctx.vars.isLFABAdmin || "false") === "true");
var entityId = String(ctx.vars.entityId || "");
var userLogin = ctx.userInfo.@login.toString();

// Admin impersonation
if (isAdmin && request.getParameter('adminEntity')) {
  entityId = request.getParameter('adminEntity');
}
%>
<!DOCTYPE html>
<html>
<body>
<% if (isAdmin) { %>
  <div class="admin-panel"><!-- TODO: admin org selector --></div>
<% } %>
<h1>Welcome, <%= userLogin %></h1>
<% if (entityId) { %>
  <button onclick="doAction('[AppName]', '<%= entityId %>')">Submit</button>
<% } else { %>
  <p>No entity selected.</p>
<% } %>
</body>
</html>
```

---

## Pattern D: Data Viewer (DialogOverview base)

**Use when:** Simple queryable table rendered server-side, filter bar, client-side filter/sort.

### D.jsp — Server-side rendered data viewer

```jsp
<%
logonEscalation("webapp");

var nameFilter = request.getParameter('nameFilter') || '';
var statusFilter = request.getParameter('statusFilter') || '';

var q = <queryDef schema="nms:delivery" operation="select" lineCount="200">
  <select>
    <node expr="@id"/>
    <node expr="@label"/>
    <node expr="@internalName"/>
    <node expr="[scheduling/@contactDate]"/>
  </select>
  <where>
    <condition expr="@messageType=0"/>
  </where>
  <orderBy><node expr="[scheduling/@contactDate]" sortDesc="true"/></orderBy>
</queryDef>;

if (nameFilter) q.where.appendChild(<condition expr={"@label LIKE '%" + nameFilter.replace(/'/g, "\\'") + "%'"}/>);

var data = xtk.queryDef.create(q).ExecuteQuery();
%>
<!DOCTYPE html>
<html>
<body>
<form method="GET">
  <input name="nameFilter" value="<%= nameFilter %>" placeholder="Filter by name">
  <button type="submit">Filter</button>
</form>
<table>
  <thead><tr><th>Label</th><th>Internal Name</th><th>Date</th></tr></thead>
  <tbody>
  <% for each (var del in data.delivery) { %>
    <tr>
      <td><%= del.@label %></td>
      <td><%= del.@internalName %></td>
      <td><%= del.scheduling.@contactDate %></td>
    </tr>
  <% } %>
  </tbody>
</table>
</body>
</html>
```

---

## Pattern E: Prediction (KPIPredictor base)

**Use when:** Statistical KPI forecasting, filter dropdowns, confidence intervals, Chart.js.

### E.jssp — Prediction API skeleton

```jsp
<%
logonEscalation("webapp");
response.contentType = "application/json; charset=UTF-8";

var result = { success: false, error: "", data: {} };

try {
  var action = request.getParameter('action') || 'predict';

  function calculateStdDev(values, mean) {
    if (values.length < 2) return 0;
    var sumSq = 0;
    for (var i = 0; i < values.length; i++) { var d = values[i] - mean; sumSq += d * d; }
    return Math.sqrt(sumSq / (values.length - 1));
  }

  function formatDate(date) {
    return date.getFullYear() + '-' + ('0'+(date.getMonth()+1)).slice(-2) + '-' + ('0'+date.getDate()).slice(-2);
  }

  if (action === 'getFilters') {
    // TODO: implement getDistinctValues(fieldName) with exclusion list
    result.data = { dialogs: [], natures: [] };
    result.success = true;

  } else if (action === 'predict') {
    var pDialog  = request.getParameter('pDialog')  || '';
    var pNature  = request.getParameter('pNature')  || '';
    var dateFrom = formatDate(new Date(new Date().getFullYear(), new Date().getMonth() - 12, new Date().getDate()));

    // TODO: query nms:delivery for last 12 months with optional filters
    // TODO: compute meanOR, meanCTOR, meanOO and confidence intervals
    // TODO: return { openRate, ctor, optoutRate, openRateRange, ctorRange, sampleSize }
    result.success = true;
  }
} catch (e) {
  result.error = e.message || e.toString();
}

write(JSON.stringify(result));
%>
```
