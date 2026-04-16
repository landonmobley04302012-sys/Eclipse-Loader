-- 🌑 ECLIPSE - Public Bootstrapper (Universal HWID)
local HttpService = game:GetService("HttpService")
local SCRIPT_KEY = script_key or ""

local function getHWID()
    -- Try multiple methods, fallback to simple GUID
    local hwid = nil
    
    pcall(function()
        if syn and syn.crypto then 
            hwid = syn.crypto.hash(syn.user_id() .. syn.hwid()) 
        end
    end)
    
    if not hwid then
        pcall(function()
            if SW_HWID then hwid = SW_HWID end
        end)
    end
    
    if not hwid then
        pcall(function()
            if krnl and krnl.hwid then hwid = krnl.hwid() end
        end)
    end
    
    if not hwid then
        pcall(function()
            if fluxus and fluxus.hwid then hwid = fluxus.hwid() end
        end)
    end
    
    if not hwid then
        pcall(function()
            if Vega and Vega.HWID then hwid = Vega.HWID() end
        end)
    end
    
    -- Ultimate fallback
    if not hwid or hwid == "" then
        hwid = HttpService:GenerateGUID(false)
    end
    
    return tostring(hwid)
end

local PORTAL_URL = "https://eclipse-portal-production.up.railway.app"
local hwid = getHWID()
local url = PORTAL_URL .. "/api/loader?key=" .. HttpService:UrlEncode(SCRIPT_KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid)

local success, response = pcall(function()
    return game:HttpGet(url)
end)

if not success then
    error("Eclipse: Connection failed")
end

local data = HttpService:JSONDecode(response)

if data.success then
    local fn = loadstring(data.loader)
    if fn then
        fn()
    else
        error("Eclipse: Failed to load UI")
    end
else
    error("Eclipse: " .. (data.message or "Access denied"))
end
