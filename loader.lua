-- 🌑 ECLIPSE - Public Bootstrapper
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

-- Try to claim key
local claimUrl = PORTAL_URL .. "/api/claim?key=" .. HttpService:UrlEncode(SCRIPT_KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid)
local claimResponse = game:HttpGet(claimUrl)
local claimData = HttpService:JSONDecode(claimResponse)

if not claimData.success then
    error("Eclipse: " .. (claimData.message or "Access denied"))
end

-- Fetch loader with retry
local scriptUrl = PORTAL_URL .. "/api/script?key=" .. HttpService:UrlEncode(SCRIPT_KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid) .. "&gameId=loader"
local loaderScript = nil

for attempt = 1, 3 do
    local success, response = pcall(function() return game:HttpGet(scriptUrl) end)
    if success then
        local data = HttpService:JSONDecode(response)
        if data.script then
            loaderScript = data.script
            break
        end
    end
    if attempt < 3 then wait(1) end
end

if loaderScript then
    loadstring(loaderScript)()
else
    error("Eclipse: Failed to load UI")
end
