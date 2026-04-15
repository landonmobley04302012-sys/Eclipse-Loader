-- 🌑 ECLIPSE LOADER - Secure Dynamic Loader
-- Version: 2.0.0
-- Fetches scripts securely from Railway API

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ============================================
-- CONFIGURATION
-- ============================================
local API_URL = "https://eclipse-discordbot-production.up.railway.app"
local SCRIPT_KEY = script_key or ""

-- ============================================
-- HWID GENERATION (Multi-Executor Support)
-- ============================================
local function getHWID()
    local success, result = pcall(function()
        if syn and syn.crypto and syn.crypto.hash then
            return syn.crypto.hash(syn.user_id() .. syn.hwid())
        end
        
        if SW_HWID then
            return SW_HWID
        end
        
        if krnl and krnl.hwid then
            return krnl.hwid()
        end
        
        if fluxus and fluxus.hwid then
            return fluxus.hwid()
        end
        
        if Vega and Vega.HWID then
            return Vega.HWID()
        end
        
        local ids = {}
        for _, v in pairs({identifyexecutor(), getexecutorname()}) do
            table.insert(ids, tostring(v))
        end
        return HttpService:GenerateGUID(false)
    end)
    
    if success then
        return result
    else
        return HttpService:GenerateGUID(false)
    end
end

-- ============================================
-- UI CREATION
-- ============================================
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EclipseLoader"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 420, 0, 320)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundTransparency = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(212, 175, 55)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.3
    UIStroke.Parent = MainFrame
    
    -- Logo
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Name = "LogoFrame"
    LogoFrame.Size = UDim2.new(0, 80, 0, 80)
    LogoFrame.Position = UDim2.new(0.5, -40, 0, 25)
    LogoFrame.BackgroundTransparency = 1
    LogoFrame.Parent = MainFrame
    
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(1, 0, 1, 0)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://113495616595439"
    Logo.Parent = LogoFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 115)
    Title.BackgroundTransparency = 1
    Title.Text = "ECLIPSE"
    Title.TextColor3 = Color3.fromRGB(212, 175, 55)
    Title.TextSize = 28
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Position = UDim2.new(0, 0, 0, 145)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Initializing..."
    Subtitle.TextColor3 = Color3.fromRGB(200, 200, 240)
    Subtitle.TextSize = 14
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Parent = MainFrame
    
    local StatusBar = Instance.new("Frame")
    StatusBar.Name = "StatusBar"
    StatusBar.Size = UDim2.new(0.8, 0, 0, 6)
    StatusBar.Position = UDim2.new(0.1, 0, 0, 185)
    StatusBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    StatusBar.BorderSizePixel = 0
    StatusBar.Parent = MainFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 3)
    UICorner2.Parent = StatusBar
    
    local StatusFill = Instance.new("Frame")
    StatusFill.Name = "StatusFill"
    StatusFill.Size = UDim2.new(0, 0, 1, 0)
    StatusFill.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
    StatusFill.BorderSizePixel = 0
    StatusFill.Parent = StatusBar
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 3)
    UICorner3.Parent = StatusFill
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "StatusText"
    StatusText.Size = UDim2.new(1, 0, 0, 20)
    StatusText.Position = UDim2.new(0, 0, 0, 200)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Connecting..."
    StatusText.TextColor3 = Color3.fromRGB(180, 180, 220)
    StatusText.TextSize = 12
    StatusText.Font = Enum.Font.Gotham
    StatusText.Parent = MainFrame
    
    local GameInfo = Instance.new("TextLabel")
    GameInfo.Name = "GameInfo"
    GameInfo.Size = UDim2.new(0.9, 0, 0, 25)
    GameInfo.Position = UDim2.new(0.05, 0, 0, 235)
    GameInfo.BackgroundTransparency = 1
    GameInfo.Text = ""
    GameInfo.TextColor3 = Color3.fromRGB(140, 140, 180)
    GameInfo.TextSize = 12
    GameInfo.Font = Enum.Font.Gotham
    GameInfo.Parent = MainFrame
    
    local Watermark = Instance.new("TextLabel")
    Watermark.Name = "Watermark"
    Watermark.Size = UDim2.new(1, 0, 0, 20)
    Watermark.Position = UDim2.new(0, 0, 0, 290)
    Watermark.BackgroundTransparency = 1
    Watermark.Text = "Eclipse v2.0 | " .. player.Name
    Watermark.TextColor3 = Color3.fromRGB(100, 100, 140)
    Watermark.TextSize = 11
    Watermark.Font = Enum.Font.Gotham
    Watermark.Parent = MainFrame
    
    return {
        gui = ScreenGui,
        subtitle = Subtitle,
        statusFill = StatusFill,
        statusText = StatusText,
        gameInfo = GameInfo,
        watermark = Watermark
    }
end

-- ============================================
-- FETCH SCRIPT FROM SECURE API
-- ============================================
local function fetchScript(gameId, hwid)
    local requestBody = HttpService:JSONEncode({
        key = SCRIPT_KEY,
        hwid = hwid,
        gameId = tostring(gameId)
    })
    
    local success, response = pcall(function()
        return HttpService:PostAsync(API_URL .. "/api/script", requestBody)
    end)
    
    if not success then
        return false, "Connection failed"
    end
    
    local data = HttpService:JSONDecode(response)
    
    if data.error then
        return false, data.error
    end
    
    return true, data.script
end

-- ============================================
-- MAIN EXECUTION
-- ============================================
local function main()
    local ui = createUI()
    local hwid = getHWID()
    local gameId = game.GameId
    
    ui.statusText.Text = "Checking game support..."
    ui.statusFill:TweenSize(UDim2.new(0.2, 0, 1, 0), "Out", "Quad", 0.3)
    ui.gameInfo.Text = "Game ID: " .. tostring(gameId)
    
    ui.statusText.Text = "Validating key..."
    ui.statusFill:TweenSize(UDim2.new(0.5, 0, 1, 0), "Out", "Quad", 0.3)
    
    local success, scriptContent = fetchScript(gameId, hwid)
    
    if not success then
        ui.subtitle.Text = "❌ Access Denied"
        ui.statusText.Text = scriptContent or "Could not load script"
        ui.statusFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        ui.statusFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.3)
        return
    end
    
    ui.subtitle.Text = "✅ Key Validated"
    ui.statusText.Text = "Loading script..."
    ui.statusFill.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    ui.statusFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.5)
    
    wait(1)
    
    local loadSuccess, loadError = pcall(function()
        loadstring(scriptContent)()
    end)
    
    if loadSuccess then
        ui.gui:Destroy()
    else
        ui.subtitle.Text = "❌ Load Failed"
        ui.statusText.Text = "Script error: " .. tostring(loadError):sub(1, 30)
        ui.statusFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    end
end

-- Start everything
main()
