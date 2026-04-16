-- 🌑 ECLIPSE LOADER - Black, White & Purple Theme
-- Version: 2.3.0

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ============================================
-- CONFIGURATION
-- ============================================
local API_URL = "https://eclipse-discordbot-production.up.railway.app"
local WEBSITE_URL = "https://landonmobley04302012-sys.github.io/Eclipse-Website/"
local LINKVERTISE_URL = "https://link-target.net/4622724/kljd4wJBl8Ep"
local LOOTLABS_URL = "https://loot-link.com/s?8ms2wS8y&data=Nzr3Cg0gQKzlaRZEcKCWkamdbgPY/M7nOFBZppxg/dwNEpR6v6T3RysnZmPJD5vVfN9yyZJs3Cw3BCTQ6knUmg%3D%3D"
local SCRIPT_KEY = script_key or ""

-- ============================================
-- COLORS (Black, White, Purple Theme)
-- ============================================
local COLORS = {
    BACKGROUND = Color3.fromRGB(0, 0, 0),           -- Pure Black
    SECONDARY_BG = Color3.fromRGB(15, 15, 15),      -- Dark Gray
    ACCENT = Color3.fromRGB(147, 112, 219),         -- Purple
    ACCENT_DARK = Color3.fromRGB(106, 78, 167),     -- Dark Purple
    ACCENT_LIGHT = Color3.fromRGB(188, 156, 255),   -- Light Purple
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),   -- White
    TEXT_SECONDARY = Color3.fromRGB(180, 180, 180), -- Light Gray
    ERROR = Color3.fromRGB(255, 80, 80),            -- Red (for errors)
    SUCCESS = Color3.fromRGB(80, 200, 80)           -- Green (for success)
}

-- ============================================
-- KEY STORAGE
-- ============================================
local function saveKey(key)
    if writefile then
        pcall(function() writefile("eclipse_key.txt", key) end)
    end
end

local function loadSavedKey()
    if readfile then
        local success, key = pcall(function() return readfile("eclipse_key.txt") end)
        if success and key and key ~= "" then
            return key
        end
    end
    return nil
end

-- ============================================
-- HWID GENERATION
-- ============================================
local function getHWID()
    local success, result = pcall(function()
        if syn and syn.crypto and syn.crypto.hash then
            return syn.crypto.hash(syn.user_id() .. syn.hwid())
        end
        if SW_HWID then return SW_HWID end
        if krnl and krnl.hwid then return krnl.hwid() end
        if fluxus and fluxus.hwid then return fluxus.hwid() end
        if Vega and Vega.HWID then return Vega.HWID() end
        return HttpService:GenerateGUID(false)
    end)
    return success and result or HttpService:GenerateGUID(false)
end

-- ============================================
-- VALIDATE KEY
-- ============================================
local function validateKey(key, hwid)
    local requestBody = HttpService:JSONEncode({
        key = key,
        hwid = hwid
    })
    
    local success, response = pcall(function()
        return HttpService:PostAsync(API_URL .. "/api/validate", requestBody)
    end)
    
    if not success then
        return { code = "CONNECTION_FAILED", message = "Could not connect to server" }
    end
    
    return HttpService:JSONDecode(response)
end

-- ============================================
-- FETCH SCRIPT
-- ============================================
local function fetchScript(key, gameId, hwid)
    local requestBody = HttpService:JSONEncode({
        key = key,
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
-- DRAGGABLE UI
-- ============================================
local function makeDraggable(frame, titleBar)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================
-- MAIN UI CREATION (Black, White & Purple)
-- ============================================
local function createMainUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EclipseLoader"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 460, 0, 440)
    MainFrame.Position = UDim2.new(0.5, -230, 0.5, -220)
    MainFrame.BackgroundColor3 = COLORS.BACKGROUND
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = COLORS.ACCENT
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0.3
    UIStroke.Parent = MainFrame
    
    -- Title Bar (Draggable)
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, -10, 0, 40)
    TitleBar.Position = UDim2.new(0, 5, 0, 5)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = MainFrame
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = COLORS.ERROR
    CloseButton.BackgroundTransparency = 0.5
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = COLORS.TEXT_PRIMARY
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "ECLIPSE"
    Title.TextColor3 = COLORS.TEXT_PRIMARY
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Logo
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Size = UDim2.new(0, 70, 0, 70)
    LogoFrame.Position = UDim2.new(0.5, -35, 0, 55)
    LogoFrame.BackgroundTransparency = 1
    LogoFrame.Parent = MainFrame
    
    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(1, 0, 1, 0)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://113495616595439"
    Logo.Parent = LogoFrame
    
    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0.05, 0, 0, 135)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Enter your key or choose an option below"
    StatusLabel.TextColor3 = COLORS.TEXT_SECONDARY
    StatusLabel.TextSize = 13
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = MainFrame
    
    -- Key Input Box
    local KeyBox = Instance.new("Frame")
    KeyBox.Size = UDim2.new(0.9, 0, 0, 45)
    KeyBox.Position = UDim2.new(0.05, 0, 0, 170)
    KeyBox.BackgroundColor3 = COLORS.SECONDARY_BG
    KeyBox.BorderSizePixel = 0
    KeyBox.Parent = MainFrame
    
    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 8)
    KeyBoxCorner.Parent = KeyBox
    
    local KeyBoxStroke = Instance.new("UIStroke")
    KeyBoxStroke.Color = COLORS.ACCENT
    KeyBoxStroke.Thickness = 1.5
    KeyBoxStroke.Transparency = 0.4
    KeyBoxStroke.Parent = KeyBox
    
    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -16, 1, 0)
    KeyInput.Position = UDim2.new(0, 8, 0, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.PlaceholderText = "ECLIPSE-XXXX-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    KeyInput.Text = ""
    KeyInput.TextColor3 = COLORS.TEXT_PRIMARY
    KeyInput.TextSize = 14
    KeyInput.Font = Enum.Font.Code
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = KeyBox
    
    -- Message Label
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Size = UDim2.new(0.9, 0, 0, 20)
    MessageLabel.Position = UDim2.new(0.05, 0, 0, 222)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Text = ""
    MessageLabel.TextColor3 = COLORS.TEXT_PRIMARY
    MessageLabel.TextSize = 12
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Parent = MainFrame
    
    -- Redeem Button
    local RedeemButton = Instance.new("TextButton")
    RedeemButton.Size = UDim2.new(0.9, 0, 0, 45)
    RedeemButton.Position = UDim2.new(0.05, 0, 0, 255)
    RedeemButton.BackgroundColor3 = COLORS.ACCENT
    RedeemButton.Text = "🔑 REDEEM KEY"
    RedeemButton.TextColor3 = COLORS.TEXT_PRIMARY
    RedeemButton.TextSize = 16
    RedeemButton.Font = Enum.Font.GothamBold
    RedeemButton.Parent = MainFrame
    
    local RedeemCorner = Instance.new("UICorner")
    RedeemCorner.CornerRadius = UDim.new(0, 8)
    RedeemCorner.Parent = RedeemButton
    
    -- Button Row (Linkvertise / LootLabs)
    local ButtonRow = Instance.new("Frame")
    ButtonRow.Size = UDim2.new(0.9, 0, 0, 45)
    ButtonRow.Position = UDim2.new(0.05, 0, 0, 315)
    ButtonRow.BackgroundTransparency = 1
    ButtonRow.Parent = MainFrame
    
    local LinkvertiseButton = Instance.new("TextButton")
    LinkvertiseButton.Size = UDim2.new(0.48, 0, 1, 0)
    LinkvertiseButton.Position = UDim2.new(0, 0, 0, 0)
    LinkvertiseButton.BackgroundColor3 = COLORS.SECONDARY_BG
    LinkvertiseButton.Text = "🔗 Linkvertise"
    LinkvertiseButton.TextColor3 = COLORS.TEXT_PRIMARY
    LinkvertiseButton.TextSize = 14
    LinkvertiseButton.Font = Enum.Font.GothamBold
    LinkvertiseButton.Parent = ButtonRow
    
    local LinkCorner = Instance.new("UICorner")
    LinkCorner.CornerRadius = UDim.new(0, 8)
    LinkCorner.Parent = LinkvertiseButton
    
    local LinkStroke = Instance.new("UIStroke")
    LinkStroke.Color = COLORS.ACCENT
    LinkStroke.Thickness = 1
    LinkStroke.Transparency = 0.5
    LinkStroke.Parent = LinkvertiseButton
    
    local LootLabsButton = Instance.new("TextButton")
    LootLabsButton.Size = UDim2.new(0.48, 0, 1, 0)
    LootLabsButton.Position = UDim2.new(0.52, 0, 0, 0)
    LootLabsButton.BackgroundColor3 = COLORS.ACCENT_DARK
    LootLabsButton.Text = "🎁 LootLabs"
    LootLabsButton.TextColor3 = COLORS.TEXT_PRIMARY
    LootLabsButton.TextSize = 14
    LootLabsButton.Font = Enum.Font.GothamBold
    LootLabsButton.Parent = ButtonRow
    
    local LootCorner = Instance.new("UICorner")
    LootCorner.CornerRadius = UDim.new(0, 8)
    LootCorner.Parent = LootLabsButton
    
    -- Info Text
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(0.9, 0, 0, 20)
    InfoLabel.Position = UDim2.new(0.05, 0, 0, 375)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "Key is saved locally after successful validation"
    InfoLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
    InfoLabel.TextSize = 11
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.Parent = MainFrame
    
    -- Watermark
    local Watermark = Instance.new("TextLabel")
    Watermark.Size = UDim2.new(1, 0, 0, 20)
    Watermark.Position = UDim2.new(0, 0, 1, -25)
    Watermark.BackgroundTransparency = 1
    Watermark.Text = "Eclipse v2.3 | " .. player.Name
    Watermark.TextColor3 = Color3.fromRGB(80, 80, 100)
    Watermark.TextSize = 11
    Watermark.Font = Enum.Font.Gotham
    Watermark.Parent = MainFrame
    
    -- Make draggable
    makeDraggable(MainFrame, TitleBar)
    
    return {
        gui = ScreenGui,
        mainFrame = MainFrame,
        keyInput = KeyInput,
        messageLabel = MessageLabel,
        statusLabel = StatusLabel,
        redeemButton = RedeemButton,
        linkvertiseButton = LinkvertiseButton,
        lootLabsButton = LootLabsButton,
        closeButton = CloseButton
    }
end

-- ============================================
-- LOADING OVERLAY
-- ============================================
local function createLoadingUI(parent)
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.BackgroundColor3 = COLORS.BACKGROUND
    LoadingFrame.BackgroundTransparency = 0.3
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Parent = parent
    
    local Spinner = Instance.new("Frame")
    Spinner.Size = UDim2.new(0, 50, 0, 50)
    Spinner.Position = UDim2.new(0.5, -25, 0.5, -25)
    Spinner.BackgroundColor3 = COLORS.ACCENT
    Spinner.BorderSizePixel = 0
    Spinner.Parent = LoadingFrame
    
    local SpinnerCorner = Instance.new("UICorner")
    SpinnerCorner.CornerRadius = UDim.new(0, 8)
    SpinnerCorner.Parent = Spinner
    
    local LoadingText = Instance.new("TextLabel")
    LoadingText.Size = UDim2.new(1, 0, 0, 20)
    LoadingText.Position = UDim2.new(0, 0, 0.5, 35)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Text = "Validating..."
    LoadingText.TextColor3 = COLORS.TEXT_PRIMARY
    LoadingText.TextSize = 14
    LoadingText.Font = Enum.Font.Gotham
    LoadingText.Parent = LoadingFrame
    
    -- Spin animation
    local spinTween = TweenService:Create(Spinner, 
        TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        { Rotation = 360 }
    )
    spinTween:Play()
    
    return LoadingFrame
end

-- ============================================
-- MAIN EXECUTION
-- ============================================
local function main()
    local ui = createMainUI()
    local hwid = getHWID()
    local currentKey = SCRIPT_KEY
    local gameId = game.GameId
    if gameId == 0 or gameId == nil then
        gameId = game.PlaceId
    end
    
    -- Check for saved key
    local savedKey = loadSavedKey()
    if savedKey and currentKey == "" then
        currentKey = savedKey
        ui.keyInput.Text = currentKey
    elseif currentKey ~= "" then
        ui.keyInput.Text = currentKey
    end
    
    -- Function to attempt validation and loading
    local function attemptLoad(key)
        local loadingFrame = createLoadingUI(ui.mainFrame)
        ui.messageLabel.Text = ""
        
        -- Validate key
        local validation = validateKey(key, hwid)
        
        if validation.code == "KEY_VALID" then
            ui.statusLabel.Text = "✅ Key valid! Loading script..."
            ui.statusLabel.TextColor3 = COLORS.SUCCESS
            saveKey(key)
            
            -- Fetch and execute script
            local success, scriptContent = fetchScript(key, gameId, hwid)
            
            -- Try PlaceId if GameId fails
            if not success and gameId ~= game.PlaceId then
                success, scriptContent = fetchScript(key, game.PlaceId, hwid)
            end
            
            if success then
                ui.gui:Destroy()
                local loadSuccess, loadError = pcall(function()
                    loadstring(scriptContent)()
                end)
                if not loadSuccess then
                    warn("Script load failed: " .. tostring(loadError))
                end
            else
                loadingFrame:Destroy()
                ui.statusLabel.Text = "❌ Script not found for this game"
                ui.statusLabel.TextColor3 = COLORS.ERROR
                ui.messageLabel.Text = "Game ID: " .. tostring(gameId)
                ui.messageLabel.TextColor3 = COLORS.ERROR
            end
        else
            loadingFrame:Destroy()
            ui.statusLabel.Text = "❌ " .. (validation.message or "Invalid key")
            ui.statusLabel.TextColor3 = COLORS.ERROR
            ui.messageLabel.Text = "Get a new key using the buttons below"
            ui.messageLabel.TextColor3 = COLORS.ERROR
        end
    end
    
    -- If default key exists, auto-validate
    if currentKey ~= "" then
        attemptLoad(currentKey)
    end
    
    -- Button handlers
    ui.redeemButton.MouseButton1Click:Connect(function()
        local key = ui.keyInput.Text
        if key == "" then
            ui.messageLabel.Text = "Please enter a key"
            ui.messageLabel.TextColor3 = COLORS.ERROR
            return
        end
        attemptLoad(key)
    end)
    
    ui.linkvertiseButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(LINKVERTISE_URL)
            ui.messageLabel.Text = "✅ Link copied! Paste in browser"
            ui.messageLabel.TextColor3 = COLORS.SUCCESS
        else
            ui.messageLabel.Text = "Link: " .. LINKVERTISE_URL
            ui.messageLabel.TextColor3 = COLORS.TEXT_PRIMARY
        end
    end)
    
    ui.lootLabsButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(LOOTLABS_URL)
            ui.messageLabel.Text = "✅ Link copied! Paste in browser"
            ui.messageLabel.TextColor3 = COLORS.SUCCESS
        else
            ui.messageLabel.Text = "Link: " .. LOOTLABS_URL
            ui.messageLabel.TextColor3 = COLORS.TEXT_PRIMARY
        end
    end)
    
    -- Enter key in input box
    ui.keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local key = ui.keyInput.Text
            if key ~= "" then
                attemptLoad(key)
            end
        end
    end)
end

-- Start everything
main()
