-- 🌑 ECLIPSE - Public Bootstrapper with Loader Retry
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

if data.success then
    print("🔑 Key validated! Fetching loader...")
    
    local scriptUrl = PORTAL_URL .. "/api/script?key=" .. HttpService:UrlEncode(SCRIPT_KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid) .. "&gameId=loader"
    
    -- RETRY LOADER FETCH UP TO 3 TIMES
    local loaderScript = nil
    for attempt = 1, 3 do
        print("🔄 Loader fetch attempt " .. attempt .. "/3")
        
        local scriptSuccess, scriptResponse = pcall(function() return game:HttpGet(scriptUrl) end)
        
        if scriptSuccess then
            local scriptData = HttpService:JSONDecode(scriptResponse)
            if scriptData.script then
                loaderScript = scriptData.script
                print("✅ Loader found on attempt " .. attempt)
                break
            else
                print("⚠️ No loader in response on attempt " .. attempt .. ": " .. (scriptData.error or "unknown"))
            end
        else
            print("⚠️ Fetch failed on attempt " .. attempt .. ": " .. tostring(scriptResponse))
        end
        
        if attempt < 3 then
            print("⏳ Waiting 1 second before retry...")
            wait(1)
        end
    end
    
    if loaderScript then
        print("✅ Executing loader...")
        loadstring(loaderScript)()
    else
        print("❌ Failed to fetch loader after 3 attempts")
        error("Eclipse: Failed to load UI after retries")
    end
else
    print("❌ Portal rejected key: " .. (data.message or "Access denied"))
    error("Eclipse: " .. (data.message or "Access denied"))
end
