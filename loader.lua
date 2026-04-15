-- ============================================
-- MAIN EXECUTION
-- ============================================
local function main()
    local ui = createUI()
    local hwid = getHWID()
    
    -- Try both Game ID and Place ID
    local gameId = game.GameId
    if gameId == 0 or gameId == nil or gameId == "" then
        gameId = game.PlaceId
    end
    
    -- Also check PlaceId as fallback for script lookup
    local placeId = game.PlaceId
    
    ui.statusText.Text = "Checking game support..."
    ui.statusFill:TweenSize(UDim2.new(0.2, 0, 1, 0), "Out", "Quad", 0.3)
    ui.gameInfo.Text = "ID: " .. tostring(gameId)
    
    ui.statusText.Text = "Validating key..."
    ui.statusFill:TweenSize(UDim2.new(0.5, 0, 1, 0), "Out", "Quad", 0.3)
    
    -- Try GameId first, then PlaceId
    local success, scriptContent = fetchScript(gameId, hwid)
    
    if not success and gameId ~= placeId then
        -- If GameId fails, try PlaceId
        ui.gameInfo.Text = "Trying Place ID: " .. tostring(placeId)
        success, scriptContent = fetchScript(placeId, hwid)
    end
    
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
