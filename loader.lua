-- 🌑 ECLIPSE - Ultra Compatible Bootstrapper
local HttpService = game:GetService("HttpService")
local SCRIPT_KEY = script_key or ""

-- Simple HWID - works on ALL executors
local function getHWID()
    -- Just use a random GUID - Xeno doesn't need complex HWID
    return HttpService:GenerateGUID(false)
end

local PORTAL_URL = "https://eclipse-portal-production.up.railway.app"
local hwid = getHWID()
local url = PORTAL_URL .. "/api/loader?key=" .. HttpService:UrlEncode(SCRIPT_KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid)

local response = game:HttpGet(url)
local data = HttpService:JSONDecode(response)

if data.success then
    loadstring(data.loader)()
else
    error("Eclipse: " .. (data.message or "Access denied"))
end
