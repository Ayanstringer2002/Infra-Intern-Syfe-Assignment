local metric_requests = ngx.shared.metric_requests

if not metric_requests then
    metric_requests = {}
end

-- Increment request counter
local function increment_counter(key)
    local value = metric_requests:get(key) or 0
    metric_requests:set(key, value + 1)
end

-- Get metrics in Prometheus format
local function get_metrics()
    local metrics = {}
    
    -- Total requests
    local total = metric_requests:get("total_requests") or 0
    table.insert(metrics, string.format('nginx_http_requests_total %d', total))
    
    -- 5xx errors
    local errors_5xx = metric_requests:get("5xx_errors") or 0
    table.insert(metrics, string.format('nginx_http_requests_5xx_total %d', errors_5xx))
    
    return table.concat(metrics, "\n")
end

local method = ngx.req.get_method()
local path = ngx.var.request_uri

-- Count all requests
increment_counter("total_requests")

-- For demonstration, count some paths as 5xx errors
if path:match("/error") then
    increment_counter("5xx_errors")
end

if path == "/lua_metrics" then
    ngx.header["Content-Type"] = "text/plain"
    ngx.print(get_metrics())
    ngx.exit(200)
end