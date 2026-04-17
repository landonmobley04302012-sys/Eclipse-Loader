-- 🌑 ECLIPSE - Public Bootstrapper with Debug
local HttpService = game:GetService("HttpService")
local SCRIPT_KEY = script_key or ""

print("🚀 Eclipse Bootstrapper Starting...")
print("📝 Key: " .. (SCRIPT_KEY ~= "" and SCRIPT_KEY:sub(1,10).."..." or "No key provided"))

local function getHWID()
    local success, result = pcall(function()
        if syn and syn.crypto then return syn.crypto.hash(syn.user_id() .. syn.hwid()) end
        if SW_HWID then return SW_HWID end
        if krnl and krnl.hwid then return krnl.hwid() end
        if fluxus and fluxus.hwid then return fluxus.hwid() end
    end)
    if success and result then 
        print("✅ HWID generated: " .. result:sub(1,20).."...")
        return result 
    end
    local fallback = HttpService:GenerateGUID(false)
    print("⚠️ Using fallback HWID: " .. fallback:sub(1,20).."...")
    return fallback
end

local PORTAL_URL = "https://eclipse-portal-production.up.railway.app"
local hwid = getHWID()

print("🌐 Calling portal: " .. PORTAL_URL .. "/api/claim?...")

local url = PORTAL_URL .. "/api/claim?key=" .. HttpService:UrlEncode(SCRIPT_KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid)

local success, response = pcall(function() return game:HttpGet(url) end)

if not success then
    print("❌ Failed to reach portal: " .. tostring(response))
    error("Eclipse: Connection failed")
end

print("📥 Portal response received")

local data = HttpService:JSONDecode(response)
print("📊 Portal response success: " .. tostring(data.success))
if data.message then print("💬 Portal message: " .. data.message) end

if data.success then
    print("🔑 Key validated! Fetching loader...")
    
    local scriptUrl = PORTAL_URL .. "/api/script?key=" .. HttpService:UrlEncode(SCRIPT_KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid) .. "&gameId=loader"
    
    local scriptSuccess, scriptResponse = pcall(function() return game:HttpGet(scriptUrl) end)
    
    if not scriptSuccess then
        print("❌ Failed to fetch loader: " .. tostring(scriptResponse))
        error("Eclipse: Failed to fetch loader")
    end
    
    print("📥 Loader response received")
    local scriptData = HttpService:JSONDecode(scriptResponse)
    
    if scriptData.script then
        print("✅ Loader found! Executing...")
        loadstring(scriptData.script)()
    else
        print("❌ No loader in response")
        error("Eclipse: Failed to load UI")
    end
else
    print("❌ Portal rejected key: " .. (data.message or "Access denied"))
    error("Eclipse: " .. (data.message or "Access denied"))
end
