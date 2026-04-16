-- 🌑 ECLIPSE LOADER - Full Key System
-- Version: 2.2.0

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
-- MAIN UI CREATION
-- ============================================
local function createMainUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EclipseLoader"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -210)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(212, 175, 55)
    UIStroke.Thickness = 1.5
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
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    CloseButton.BackgroundTransparency = 0.3
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    Title.TextColor3 = Color3.fromRGB(212, 175, 55)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Logo
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Size = UDim2.new(0, 60, 0, 60)
    LogoFrame.Position = UDim2.new(0.5, -30, 0, 55)
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
    StatusLabel.Position = UDim2.new(0.05, 0, 0, 125)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Enter your key or choose an option below"
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
    StatusLabel.TextSize = 13
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = MainFrame
    
    -- Key Input Box
    local KeyBox = Instance.new("Frame")
    KeyBox.Size = UDim2.new(0.9, 0, 0, 40)
    KeyBox.Position = UDim2.new(0.05, 0, 0, 160)
    KeyBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    KeyBox.BackgroundTransparency = 0.4
    KeyBox.BorderSizePixel = 0
    KeyBox.Parent = MainFrame
    
    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 8)
    KeyBoxCorner.Parent = KeyBox
    
    local KeyBoxStroke = Instance.new("UIStroke")
    KeyBoxStroke.Color = Color3.fromRGB(212, 175, 55)
    KeyBoxStroke.Thickness = 1
    KeyBoxStroke.Transparency = 0.5
    KeyBoxStroke.Parent = KeyBox
    
    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -16, 1, 0)
    KeyInput.Position = UDim2.new(0, 8, 0, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.PlaceholderText = "ECLIPSE-XXXX-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 140)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 14
    KeyInput.Font = Enum.Font.Code
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = KeyBox
    
    -- Error/Success Message
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Size = UDim2.new(0.9, 0, 0, 20)
    MessageLabel.Position = UDim2.new(0.05, 0, 0, 205)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Text = ""
    MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MessageLabel.TextSize = 12
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Parent = MainFrame
    
    -- Redeem Button
    local RedeemButton = Instance.new("TextButton")
    RedeemButton.Size = UDim2.new(0.9, 0, 0, 40)
    RedeemButton.Position = UDim2.new(0.05, 0, 0, 235)
    RedeemButton.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
    RedeemButton.Text = "🔑 REDEEM KEY"
    RedeemButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    RedeemButton.TextSize = 16
    RedeemButton.Font = Enum.Font.GothamBold
    RedeemButton.Parent = MainFrame
    
    local RedeemCorner = Instance.new("UICorner")
    RedeemCorner.CornerRadius = UDim.new(0, 8)
    RedeemCorner.Parent = RedeemButton
    
    -- Button Row (Linkvertise / LootLabs)
    local ButtonRow = Instance.new("Frame")
    ButtonRow.Size = UDim2.new(0.9, 0, 0, 40)
    ButtonRow.Position = UDim2.new(0.05, 0, 0, 290)
    ButtonRow.BackgroundTransparency = 1
    ButtonRow.Parent = MainFrame
    
    local LinkvertiseButton = Instance.new("TextButton")
    LinkvertiseButton.Size = UDim2.new(0.48, 0, 1, 0)
    LinkvertiseButton.Position = UDim2.new(0, 0, 0, 0)
    LinkvertiseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    LinkvertiseButton.Text = "🔗 Linkvertise"
    LinkvertiseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LinkvertiseButton.TextSize = 13
    LinkvertiseButton.Font = Enum.Font.GothamBold
    LinkvertiseButton.Parent = ButtonRow
    
    local LinkCorner = Instance.new("UICorner")
    LinkCorner.CornerRadius = UDim.new(0, 8)
    LinkCorner.Parent = LinkvertiseButton
    
    local LootLabsButton = Instance.new("TextButton")
    LootLabsButton.Size = UDim2.new(0.48, 0, 1, 0)
    LootLabsButton.Position = UDim2.new(0.52, 0, 0, 0)
    LootLabsButton.BackgroundColor3 = Color3.fromRGB(60, 30, 60)
    LootLabsButton.Text = "🎁 LootLabs"
    LootLabsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LootLabsButton.TextSize = 13
    LootLabsButton.Font = Enum.Font.GothamBold
    LootLabsButton.Parent = ButtonRow
    
    local LootCorner = Instance.new("UICorner")
    LootCorner.CornerRadius = UDim.new(0, 8)
    LootCorner.Parent = LootLabsButton
    
    -- Watermark
    local Watermark = Instance.new("TextLabel")
    Watermark.Size = UDim2.new(1, 0, 0, 20)
    Watermark.Position = UDim2.new(0, 0, 1, -25)
    Watermark.BackgroundTransparency = 1
    Watermark.Text = "Eclipse v2.2 | " .. player.Name
    Watermark.TextColor3 = Color3.fromRGB(80, 80, 120)
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
-- LOADING UI (Shown during validation)
-- ============================================
local function createLoadingUI(parent)
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LoadingFrame.BackgroundTransparency = 0.5
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Parent = parent
    
    local Spinner = Instance.new("Frame")
    Spinner.Size = UDim2.new(0, 40, 0, 40)
    Spinner.Position = UDim2.new(0.5, -20, 0.5, -20)
    Spinner.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
    Spinner.BorderSizePixel = 0
    Spinner.Parent = LoadingFrame
    
    local SpinnerCorner = Instance.new("UICorner")
    SpinnerCorner.CornerRadius = UDim.new(0, 20)
    SpinnerCorner.Parent = Spinner
    
    local LoadingText = Instance.new("TextLabel")
    LoadingText.Size = UDim2.new(1, 0, 0, 20)
    LoadingText.Position = UDim2.new(0, 0, 0.5, 30)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Text = "Validating..."
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
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
                ui.messageLabel.Text = "Game ID: " .. tostring(gameId)
                ui.messageLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        else
            loadingFrame:Destroy()
            ui.statusLabel.Text = "❌ " .. (validation.message or "Invalid key")
            ui.messageLabel.Text = "Get a new key using the buttons below"
            ui.messageLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
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
            ui.messageLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            return
        end
        attemptLoad(key)
    end)
    
    ui.linkvertiseButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(LINKVERTISE_URL)
            ui.messageLabel.Text = "✅ Link copied! Paste in browser"
            ui.messageLabel.TextColor3 = Color3.fromRGB(80, 200, 80)
        else
            ui.messageLabel.Text = "Link: " .. LINKVERTISE_URL
            ui.messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
    
    ui.lootLabsButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(LOOTLABS_URL)
            ui.messageLabel.Text = "✅ Link copied! Paste in browser"
            ui.messageLabel.TextColor3 = Color3.fromRGB(80, 200, 80)
        else
            ui.messageLabel.Text = "Link: " .. LOOTLABS_URL
            ui.messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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
