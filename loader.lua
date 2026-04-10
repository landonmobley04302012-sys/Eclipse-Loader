-- 🌑 ECLIPSE LOADER
-- Version: 1.0.0
-- Game-specific loader template

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

-- Configuration
local API_URL = "https://eclipse-backend.onrender.com/api/validate"
local SCRIPT_KEY = script_key or ""

-- ============================================
-- GAME CONFIGURATION - ADD YOUR GAMES HERE
-- ============================================
local SUPPORTED_GAMES = {
    -- [Game ID] = {
    --     name = "Game Name",
    --     loadstring = "LOADSTRING_HERE"
    -- }
    
    -- EXAMPLE (replace with your actual games):
    [13822889] = {  -- Lumber Tycoon 2
        name = "Lumber Tycoon 2",
        loadstring = "PUT_YOUR_LOADSTRING_HERE"
    },
    
    [286090429] = {  -- Arsenal
        name = "Arsenal",
        loadstring = "PUT_YOUR_LOADSTRING_HERE"
    },
    
    [2753915549] = {  -- Blox Fruits
        name = "Blox Fruits",
        loadstring = "PUT_YOUR_LOADSTRING_HERE"
    },
    
    [6284583030] = {  -- Pet Simulator X
        name = "Pet Simulator X",
        loadstring = "PUT_YOUR_LOADSTRING_HERE"
    },
}
-- ============================================

-- HWID Generation (multi-executor support)
local function getHWID()
    local success, result = pcall(function()
        -- Synapse X
        if syn and syn.crypto and syn.crypto.hash then
            return syn.crypto.hash(syn.user_id() .. syn.hwid())
        end
        
        -- Script-Ware
        if SW_HWID then
            return SW_HWID
        end
        
        -- Krnl
        if krnl and krnl.hwid then
            return krnl.hwid()
        end
        
        -- Fluxus
        if fluxus and fluxus.hwid then
            return fluxus.hwid()
        end
        
        -- Vega X
        if Vega and Vega.HWID then
            return Vega.HWID()
        end
        
        -- Generic fallback
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

-- Get current game info
local function getCurrentGame()
    local gameId = game.GameId
    local placeId = game.PlaceId
    
    if SUPPORTED_GAMES[gameId] then
        return gameId, SUPPORTED_GAMES[gameId]
    elseif SUPPORTED_GAMES[placeId] then
        return placeId, SUPPORTED_GAMES[placeId]
    else
        return nil, nil
    end
end

-- UI Creation
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
    Watermark.Text = "Eclipse v1.0 | " .. player.Name
    Watermark.TextColor3 = Color3.fromRGB(100, 100, 140)
    Watermark.TextSize = 11
    Watermark.Font = Enum.Font.Gotham
    Watermark.Parent = MainFrame
    
    return {
        gui = ScreenGui,
        title = Title,
        subtitle = Subtitle,
        statusFill = StatusFill,
        statusText = StatusText,
        gameInfo = GameInfo,
        watermark = Watermark
    }
end

-- Main validation and loading function
local function validateAndLoad()
    local ui = createUI()
    local hwid = getHWID()
    
    -- Check if game is supported
    local gameId, gameData = getCurrentGame()
    
    ui.statusText.Text = "Checking game support..."
    ui.statusFill:TweenSize(UDim2.new(0.2, 0, 1, 0), "Out", "Quad", 0.3)
    
    if not gameData then
        ui.subtitle.Text = "❌ Game Not Supported"
        ui.statusText.Text = "This game is not supported by Eclipse"
        ui.gameInfo.Text = "Game ID: " .. tostring(game.GameId)
        ui.statusFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        ui.statusFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.3)
        return
    end
    
    ui.gameInfo.Text = "Game: " .. gameData.name
    ui.statusText.Text = "Validating key..."
    ui.statusFill:TweenSize(UDim2.new(0.4, 0, 1, 0), "Out", "Quad", 0.3)
    
    -- Validate with backend
    local requestBody = HttpService:JSONEncode({
        key = SCRIPT_KEY,
        hwid = hwid
    })
    
    local success, response = pcall(function()
        return HttpService:PostAsync(API_URL, requestBody)
    end)
    
    if not success then
        ui.subtitle.Text = "❌ Connection Failed"
        ui.statusText.Text = "Could not connect to server"
        ui.statusFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        ui.statusFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.3)
        return
    end
    
    ui.statusFill:TweenSize(UDim2.new(0.7, 0, 1, 0), "Out", "Quad", 0.3)
    
    local result = HttpService:JSONDecode(response)
    
    if result.code == "KEY_VALID" then
        ui.subtitle.Text = "✅ Key Validated"
        ui.statusText.Text = "Loading " .. gameData.name .. "..."
        ui.statusFill.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
        ui.statusFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.5)
        
        wait(1)
        
        -- Load the game-specific script
        local loadSuccess, loadError = pcall(function()
            loadstring(gameData.loadstring)()
        end)
        
        if loadSuccess then
            ui.gui:Destroy()
        else
            ui.subtitle.Text = "❌ Load Failed"
            ui.statusText.Text = "Script error: " .. tostring(loadError):sub(1, 30)
            ui.statusFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        end
        
    elseif result.code == "HWID_MISMATCH" then
        ui.subtitle.Text = "❌ HWID Mismatch"
        ui.statusText.Text = "This key is bound to another device"
        ui.statusFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        ui.statusFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.3)
        
    elseif result.code == "KEY_EXPIRED" then
        ui.subtitle.Text = "❌ Key Expired"
        ui.statusText.Text = "Your key has expired"
        ui.statusFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        ui.statusFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.3)
        
    elseif result.code == "USER_BLACKLISTED" then
        ui.subtitle.Text = "❌ Blacklisted"
        ui.statusText.Text = "You are blacklisted from Eclipse"
        ui.statusFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        ui.statusFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.3)
        
    else
        ui.subtitle.Text = "❌ Invalid Key"
        ui.statusText.Text = result.message or "Key validation failed"
        ui.statusFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        ui.statusFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.3)
    end
end

-- Start validation
validateAndLoad()
