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
local url = PORTAL_URL .. "/api/loader?key=" .. HttpService:UrlEncode(SCRIPT_KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid)

local response = game:HttpGet(url)
local data = HttpService:JSONDecode(response)

if data.success then
    local fn = loadstring(data.loader)
    if fn then fn() else error("Eclipse: Failed to load") end
else
    error("Eclipse: " .. (data.message or "Access denied"))
end
