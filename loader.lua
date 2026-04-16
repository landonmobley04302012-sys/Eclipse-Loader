-- 🌑 ECLIPSE - Public Bootstrapper (Simplified)
local HttpService = game:GetService("HttpService")
local SCRIPT_KEY = script_key or ""

local function getHWID()
    local success, result = pcall(function()
        if syn and syn.crypto then 
            return syn.crypto.hash(syn.user_id() .. syn.hwid()) 
        end
        if SW_HWID then return SW_HWID end
        if krnl and krnl.hwid then return krnl.hwid() end
        if fluxus and fluxus.hwid then return fluxus.hwid() end
    end)
    if success and result then return result end
    return HttpService:GenerateGUID(false)
end

local PORTAL_URL = "https://eclipse-portal-production.up.railway.app"

-- Build URL without UrlEncode (just in case)
local hwid = getHWID()
local url = PORTAL_URL .. "/api/loader?key=" .. SCRIPT_KEY .. "&hwid=" .. hwid

local success, response = pcall(function()
    return game:HttpGet(url)
end)

if not success then
    error("Eclipse: Connection failed")
end

local data = HttpService:JSONDecode(response)

if data.success then
    loadstring(data.loader)()
else
    error("Eclipse: " .. (data.message or "Access denied"))
end
