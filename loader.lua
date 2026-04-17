-- 🌑 ECLIPSE - Public Bootstrapper with Retry
local HttpService = game:GetService("HttpService")
local SCRIPT_KEY = script_key or ""

local function getHWID()
    local success, result = pcall(function()
        if syn and syn.crypto then return syn.crypto.hash(syn.user_id() .. syn.hwid()) end
        if SW_HWID then return SW_HWID end
        if krnl and krnl.hwid then return krnl.hwid() end
        if fluxus and fluxus.hwid then return fluxus.hwid() end
    end)
    if success and result then return result end
    return HttpService:GenerateGUID(false)
end

local PORTAL_URL = "https://eclipse-portal-production.up.railway.app"
local hwid = getHWID()

-- Retry function
local function tryFetch()
    local url = PORTAL_URL .. "/api/claim?key=" .. HttpService:UrlEncode(SCRIPT_KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid)
    local response = game:HttpGet(url)
    local data = HttpService:JSONDecode(response)
    
    if data.success then
        local scriptUrl = PORTAL_URL .. "/api/script?key=" .. HttpService:UrlEncode(SCRIPT_KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid) .. "&gameId=loader"
        local scriptResponse = game:HttpGet(scriptUrl)
        local scriptData = HttpService:JSONDecode(scriptResponse)
        if scriptData.script then
            loadstring(scriptData.script)()
            return true
        end
    end
    return false
end

-- Try up to 3 times with delays
for attempt = 1, 3 do
    local success = pcall(tryFetch)
    if success then
        return
    end
    if attempt < 3 then
        wait(1) -- Wait 1 second between retries
    end
end

error("Eclipse: Failed to load UI after 3 attempts")
