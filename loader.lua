local HttpService = game:GetService("HttpService")
local SCRIPT_KEY = script_key or ""

local function getHWID()
    pcall(function()
        if syn and syn.crypto then return syn.crypto.hash(syn.user_id() .. syn.hwid()) end
        if SW_HWID then return SW_HWID end
        if krnl and krnl.hwid then return krnl.hwid() end
    end)
    return HttpService:GenerateGUID(false)
end

local PORTAL_URL = "https://eclipse-portal-production.up.railway.app"

local response = game:HttpGet(PORTAL_URL .. "/api/loader?key=" .. HttpService:UrlEncode(SCRIPT_KEY) .. "&hwid=" .. HttpService:UrlEncode(getHWID()))
local data = HttpService:JSONDecode(response)

if data.success then
    loadstring(data.loader)()
else
    error("Eclipse: " .. (data.message or "Access denied"))
end
