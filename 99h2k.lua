-- 99 Nights in the Forest H2K Mod Menu
-- Optimizado para KRNL Android - By H2K

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variables globales
local ModState = {
    isOpen = false,
    noclip = false,
    infiniteJump = false,
    killAura = false,
    bringWood = false,
    bringScrap = false,
    bringMedical = false,
    killAuraRange = 20
}

local Connections = {}
local gui = nil

-- Función para limpiar GUIs anteriores
pcall(function()
    if PlayerGui:FindFirstChild("H2K_99Nights") then
        PlayerGui:FindFirstChild("H2K_99Nights"):Destroy()
    end
end)

-- Función para encontrar objetos por nombres específicos del juego
local function findItemsByName(itemType)
    local items = {}
    local itemNames = {}
    
    -- Nombres específicos basados en la investigación del juego
    if itemType == "Wood" then
        itemNames = {
            "Log", "Wood", "TreeLog", "WoodLog", "Branch", "Stick", 
            "Plank", "WoodPlank", "Timber", "Lumber", "Oak", "Pine", "Tree"
        }
    elseif itemType == "Scrap" then
        itemNames = {
            "Scrap", "Metal", "Bolt", "Nut", "Can", "Pipe", "Wire",
            "Tool", "MetalScrap", "IronScrap", "Steel", "Copper", "Aluminum"
        }
    elseif itemType == "Medical" then
        itemNames = {
            "Medkit", "MedKit", "Bandage", "Bandages", "FirstAid", 
            "HealthPack", "Healing", "Medicine", "Antiseptic", "Gauze"
        }
    end
    
    -- Buscar en Workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            for _, name in pairs(itemNames) do
                if obj.Name:lower():find(name:lower()) then
                    -- Verificar que el objeto sea interactuable
                    if obj:FindFirstChild("ProximityPrompt") or obj:FindFirstChild("ClickDetector") or obj.CanCollide then
                        table.insert(items, obj)
                        break
                    end
                end
            end
        end
    end
    
    return items
end

-- Función para traer objetos al jugador
local function bringItems(itemType)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return 0 end
    
    local rootPart = character.HumanoidRootPart
    local items = findItemsByName(itemType)
    local broughtCount = 0
    
    for _, item in pairs(items) do
        if item and item.Parent then
            pcall(function()
                -- Método 1: Teletransportar directamente
                item.CFrame = rootPart.CFrame + Vector3.new(math.random(-5, 5), 2, math.random(-5, 5))
                
                -- Método 2: Si tiene BodyPosition/BodyVelocity
                if item:FindFirstChild("BodyPosition") then
                    item.BodyPosition.Position = rootPart.Position
                elseif item:FindFirstChild("BodyVelocity") then
                    item.BodyVelocity.Velocity = (rootPart.Position - item.Position).Unit * 50
                end
                
                -- Método 3: Anclar y desanclar
                item.Anchored = false
                item.CanCollide = false
                
                broughtCount = broughtCount + 1
            end)
        end
    end
    
    return broughtCount
end

-- Función Kill Aura con rango personalizable
local function performKillAura()
    if not ModState.killAura then return end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChild("Humanoid")
            
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (rootPart.Position - targetRoot.Position).Magnitude
                
                if distance <= ModState.killAuraRange then
                    pcall(function()
                        -- Múltiples métodos de kill
                        targetHumanoid.Health = 0
                        targetHumanoid:TakeDamage(math.huge)
                        
                        -- Buscar RemoteEvents relacionados con daño
                        for _, obj in pairs(game.ReplicatedStorage:GetDescendants()) do
                            if obj:IsA("RemoteEvent") then
                                local name = obj.Name:lower()
                                if name:find("damage") or name:find("hit") or name:find("attack") or name:find("kill") then
                                    obj:FireServer(player.Character, math.huge)
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
end

-- Función Noclip
local function toggleNoclip()
    ModState.noclip = not ModState.noclip
    
    if ModState.noclip then
        Connections.noclipConnection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if Connections.noclipConnection then
            Connections.noclipConnection:Disconnect()
            Connections.noclipConnection = nil
        end
        
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Función Infinite Jump
local function toggleInfiniteJump()
    ModState.infiniteJump = not ModState.infiniteJump
    
    if ModState.infiniteJump then
        Connections.infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if Connections.infiniteJumpConnection then
            Connections.infiniteJumpConnection:Disconnect()
            Connections.infiniteJumpConnection = nil
        end
    end
end

-- Crear icono H2K
local function createIcon()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "H2K_99Nights"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = PlayerGui
    
    -- Marco del icono con efecto glow
    local iconFrame = Instance.new("Frame")
    iconFrame.Name = "IconFrame"
    iconFrame.Size = UDim2.new(0, 70, 0, 70)
    iconFrame.Position = UDim2.new(0, 20, 0, 80)
    iconFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = screenGui
    
    -- Esquinas redondeadas
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 35)
    iconCorner.Parent = iconFrame
    
    -- Borde brillante
    local iconStroke = Instance.new("UIStroke")
    iconStroke.Color = Color3.fromRGB(0, 255, 127)
    iconStroke.Thickness = 3
    iconStroke.Parent = iconFrame
    
    -- Gradiente de fondo
    local iconGradient = Instance.new("UIGradient")
    iconGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 15, 25))
    }
    iconGradient.Rotation = 45
    iconGradient.Parent = iconFrame
    
    -- Texto H2K
    local iconText = Instance.new("TextLabel")
    iconText.Size = UDim2.new(1, 0, 1, 0)
    iconText.BackgroundTransparency = 1
    iconText.Text = "H2K"
    iconText.TextColor3 = Color3.fromRGB(0, 255, 127)
    iconText.TextScaled = true
    iconText.Font = Enum.Font.GothamBold
    iconText.TextStrokeTransparency = 0
    iconText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    iconText.Parent = iconFrame
    
    -- Botón clickeable
    local iconButton = Instance.new("TextButton")
    iconButton.Size = UDim2.new(1, 0, 1, 0)
    iconButton.BackgroundTransparency = 1
    iconButton.Text = ""
    iconButton.Active = true
    iconButton.Draggable = true
    iconButton.Parent = iconFrame
    
    -- Efecto de respiración
    spawn(function()
        while iconFrame.Parent do
            TweenService:Create(iconStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), 
                {Thickness = 5}):Play()
            wait(1.5)
        end
    end)
    
    return screenGui, iconButton
end

-- Crear menú principal
local function createMainMenu(parentGui)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainMenu"
    mainFrame.Size = UDim2.new(0, 380, 0, 520)
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Parent = parentGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = mainFrame
    
    -- Borde brillante
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 255, 127)
    mainStroke.Thickness = 2
    mainStroke.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Color3.fromRGB(0, 20, 10)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 20)
    headerCorner.Parent = header
    
    -- Gradiente header
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 127)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 75))
    }
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "99 NIGHTS FOREST"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextStrokeTransparency = 0.5
    title.Parent = header
    
    -- Logo H2K
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 80, 0, 40)
    logo.Position = UDim2.new(1, -90, 0, 10)
    logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    logo.Text = "H2K"
    logo.TextColor3 = Color3.fromRGB(0, 0, 0)
    logo.TextScaled = true
    logo.Font = Enum.Font.GothamBold
    logo.Parent = header
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = logo
    
    -- Botón cerrar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 15)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 15)
    closeBtnCorner.Parent = closeBtn
    
    -- Contenido
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -80)
    content.Position = UDim2.new(0, 10, 0, 70)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 8
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 127)
    content.CanvasSize = UDim2.new(0, 0, 0, 600)
    content.Parent = mainFrame
    
    -- Función para crear secciones
    local function createSection(name, yPos, height)
        local section = Instance.new("Frame")
        section.Name = name .. "Section"
        section.Size = UDim2.new(1, 0, 0, height or 80)
        section.Position = UDim2.new(0, 0, 0, yPos)
        section.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        section.BorderSizePixel = 0
        section.Parent = content
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 12)
        sectionCorner.Parent = section
        
        local sectionStroke = Instance.new("UIStroke")
        sectionStroke.Color = Color3.fromRGB(40, 40, 60)
        sectionStroke.Thickness = 1
        sectionStroke.Parent = section
        
        return section
    end
    
    -- Sección Bring Items
    local bringSection = createSection("Bring", 10, 100)
    
    local bringTitle = Instance.new("TextLabel")
    bringTitle.Size = UDim2.new(1, 0, 0, 25)
    bringTitle.Position = UDim2.new(0, 10, 0, 5)
    bringTitle.BackgroundTransparency = 1
    bringTitle.Text = "BRING ITEMS"
    bringTitle.TextColor3 = Color3.fromRGB(0, 255, 127)
    bringTitle.TextSize = 16
    bringTitle.Font = Enum.Font.GothamBold
    bringTitle.TextXAlignment = Enum.TextXAlignment.Left
    bringTitle.Parent = bringSection
    
    -- Botones Bring
    local function createBringButton(name, text, pos)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 100, 0, 40)
        btn.Position = pos
        btn.BackgroundColor3 = Color3.fromRGB(30, 80, 50)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.Parent = bringSection
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        return btn
    end
    
    local bringWoodBtn = createBringButton("BringWood", "WOOD", UDim2.new(0, 10, 0, 35))
    local bringScrapBtn = createBringButton("BringScrap", "SCRAP", UDim2.new(0, 125, 0, 35))
    local bringMedicalBtn = createBringButton("BringMedical", "MEDICAL", UDim2.new(0, 240, 0, 35))
    
    -- Sección Movement
    local movementSection = createSection("Movement", 120, 90)
    
    local movementTitle = Instance.new("TextLabel")
    movementTitle.Size = UDim2.new(1, 0, 0, 25)
    movementTitle.Position = UDim2.new(0, 10, 0, 5)
    movementTitle.BackgroundTransparency = 1
    movementTitle.Text = "MOVEMENT"
    movementTitle.TextColor3 = Color3.fromRGB(0, 255, 127)
    movementTitle.TextSize = 16
    movementTitle.Font = Enum.Font.GothamBold
    movementTitle.TextXAlignment = Enum.TextXAlignment.Left
    movementTitle.Parent = movementSection
    
    -- Función para crear toggles
    local function createToggle(name, text, pos, parent)
        local toggle = Instance.new("TextButton")
        toggle.Name = name
        toggle.Size = UDim2.new(0, 150, 0, 35)
        toggle.Position = pos
        toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        toggle.Text = text .. ": OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextScaled = true
        toggle.Font = Enum.Font.Gotham
        toggle.Parent = parent
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 8)
        toggleCorner.Parent = toggle
        
        return toggle
    end
    
    local noclipToggle = createToggle("NoclipToggle", "NOCLIP", UDim2.new(0, 10, 0, 35), movementSection)
    local infiniteJumpToggle = createToggle("InfiniteJumpToggle", "INF JUMP", UDim2.new(0, 180, 0, 35), movementSection)
    
    -- Sección Kill Aura
    local killAuraSection = createSection("KillAura", 220, 120)
    
    local killAuraTitle = Instance.new("TextLabel")
    killAuraTitle.Size = UDim2.new(1, 0, 0, 25)
    killAuraTitle.Position = UDim2.new(0, 10, 0, 5)
    killAuraTitle.BackgroundTransparency = 1
    killAuraTitle.Text = "KILL AURA"
    killAuraTitle.TextColor3 = Color3.fromRGB(0, 255, 127)
    killAuraTitle.TextSize = 16
    killAuraTitle.Font = Enum.Font.GothamBold
    killAuraTitle.TextXAlignment = Enum.TextXAlignment.Left
    killAuraTitle.Parent = killAuraSection
    
    local killAuraToggle = createToggle("KillAuraToggle", "KILL AURA", UDim2.new(0, 10, 0, 35), killAuraSection)
    
    -- Controles de rango
    local rangeLabel = Instance.new("TextLabel")
    rangeLabel.Size = UDim2.new(0, 100, 0, 30)
    rangeLabel.Position = UDim2.new(0, 10, 0, 80)
    rangeLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    rangeLabel.Text = "Range: " .. ModState.killAuraRange
    rangeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    rangeLabel.TextScaled = true
    rangeLabel.Font = Enum.Font.Gotham
    rangeLabel.Parent = killAuraSection
    
    local rangeLabelCorner = Instance.new("UICorner")
    rangeLabelCorner.CornerRadius = UDim.new(0, 6)
    rangeLabelCorner.Parent = rangeLabel
    
    -- Botones de rango
    local rangeMinus = Instance.new("TextButton")
    rangeMinus.Size = UDim2.new(0, 40, 0, 30)
    rangeMinus.Position = UDim2.new(0, 120, 0, 80)
    rangeMinus.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    rangeMinus.Text = "-"
    rangeMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
    rangeMinus.TextScaled = true
    rangeMinus.Font = Enum.Font.GothamBold
    rangeMinus.Parent = killAuraSection
    
    local rangeMinusCorner = Instance.new("UICorner")
    rangeMinusCorner.CornerRadius = UDim.new(0, 6)
    rangeMinusCorner.Parent = rangeMinus
    
    local rangePlus = Instance.new("TextButton")
    rangePlus.Size = UDim2.new(0, 40, 0, 30)
    rangePlus.Position = UDim2.new(0, 170, 0, 80)
    rangePlus.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    rangePlus.Text = "+"
    rangePlus.TextColor3 = Color3.fromRGB(255, 255, 255)
    rangePlus.TextScaled = true
    rangePlus.Font = Enum.Font.GothamBold
    rangePlus.Parent = killAuraSection
    
    local rangePlusCorner = Instance.new("UICorner")
    rangePlusCorner.CornerRadius = UDim.new(0, 6)
    rangePlusCorner.Parent = rangePlus
    
    -- Créditos
    local credits = Instance.new("TextLabel")
    credits.Size = UDim2.new(1, 0, 0, 30)
    credits.Position = UDim2.new(0, 0, 0, 350)
    credits.BackgroundTransparency = 1
    credits.Text = "by h2k"
    credits.TextColor3 = Color3.fromRGB(0, 255, 127)
    credits.TextScaled = true
    credits.Font = Enum.Font.GothamBold
    credits.Parent = content
    
    return {
        mainFrame = mainFrame,
        closeBtn = closeBtn,
        bringWoodBtn = bringWoodBtn,
        bringScrapBtn = bringScrapBtn,
        bringMedicalBtn = bringMedicalBtn,
        noclipToggle = noclipToggle,
        infiniteJumpToggle = infiniteJumpToggle,
        killAuraToggle = killAuraToggle,
        rangeMinus = rangeMinus,
        rangePlus = rangePlus,
        rangeLabel = rangeLabel,
        header = header
    }
end

-- Reconectar después del respawn
local function reconnectAfterSpawn()
    LocalPlayer.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid")
        wait(1)
        
        -- Reconectar funciones activas
        if ModState.noclip and not Connections.noclipConnection then
            toggleNoclip()
            toggleNoclip()
        end
        
        if ModState.infiniteJump and not Connections.infiniteJumpConnection then
            toggleInfiniteJump()
            toggleInfiniteJump()
        end
    end)
end

-- Inicializar GUI
local screenGui, iconButton = createIcon()
local menu = createMainMenu(screenGui)
gui = screenGui

-- Kill Aura loop continuo
spawn(function()
    while wait(0.1) do
        performKillAura()
    end
end)

-- Eventos del icono
iconButton.MouseButton1Click:Connect(function()
    ModState.isOpen = not ModState.isOpen
    menu.mainFrame.Visible = ModState.isOpen
    
    -- Animación del icono
    TweenService:Create(iconButton.Parent, TweenInfo.new(0.1, Enum.EasingStyle.Back), 
        {Size = UDim2.new(0, 60, 0, 60)}):Play()
    wait(0.1)
    TweenService:Create(iconButton.Parent, TweenInfo.new(0.1, Enum.EasingStyle.Back), 
        {Size = UDim2.new(0, 70, 0, 70)}):Play()
end)

-- Eventos del menú
menu.closeBtn.MouseButton1Click:Connect(function()
    ModState.isOpen = false
    menu.mainFrame.Visible = false
end)

-- Bring Items con feedback visual
menu.bringWoodBtn.MouseButton1Click:Connect(function()
    local originalColor = menu.bringWoodBtn.BackgroundColor3
    menu.bringWoodBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    local count = bringItems("Wood")
    menu.bringWoodBtn.Text = count .. " WOOD"
    wait(1)
    menu.bringWoodBtn.Text = "WOOD"
    menu.bringWoodBtn.BackgroundColor3 = originalColor
end)

menu.bringScrapBtn.MouseButton1Click:Connect(function()
    local originalColor = menu.bringScrapBtn.BackgroundColor3
    menu.bringScrapBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    local count = bringItems("Scrap")
    menu.bringScrapBtn.Text = count .. " SCRAP"
    wait(1)
    menu.bringScrapBtn.Text = "SCRAP"
    menu.bringScrapBtn.BackgroundColor3 = originalColor
end)

menu.bringMedicalBtn.MouseButton1Click:Connect(function()
    local originalColor = menu.bringMedicalBtn.BackgroundColor3
    menu.bringMedicalBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    local count = bringItems("Medical")
    menu.bringMedicalBtn.Text = count .. " MED"
    wait(1)
    menu.bringMedicalBtn.Text = "MEDICAL"
    menu.bringMedicalBtn.BackgroundColor3 = originalColor
end)

-- Movement toggles
menu.noclipToggle.MouseButton1Click:Connect(function()
    toggleNoclip()
    menu.noclipToggle.Text = ModState.noclip and "NOCLIP: ON" or "NOCLIP: OFF"
    menu.noclipToggle.BackgroundColor3 = ModState.noclip and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 80)
end)

menu.infiniteJumpToggle.MouseButton1Click:Connect(function()
    toggleInfiniteJump()
    menu.infiniteJumpToggle.Text = ModState.infiniteJump and "INF JUMP: ON" or "INF JUMP: OFF"
    menu.infiniteJumpToggle.BackgroundColor3 = ModState.infiniteJump and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 80)
end)

-- Kill Aura toggle
menu.killAuraToggle.MouseButton1Click:Connect(function()
    ModState.killAura = not ModState.killAura
    menu.killAuraToggle.Text = ModState.killAura and "KILL AURA: ON" or "KILL AURA: OFF"
    menu.killAuraToggle.BackgroundColor3 = ModState.killAura and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(60, 60, 80)
end)

-- Controles de rango
menu.rangeMinus.MouseButton1Click:Connect(function()
    if ModState.killAuraRange > 5 then
        ModState.killAuraRange = ModState.killAuraRange - 5
        menu.rangeLabel.Text = "Range: " .. ModState.killAuraRange
    end
end)

menu.rangePlus.MouseButton1Click:Connect(function()
    if ModState.killAuraRange < 100 then
        ModState.killAuraRange = ModState.killAuraRange + 5
        menu.rangeLabel.Text = "Range: " .. ModState.killAuraRange
    end
end)

-- Hacer draggable
local dragging = false
local dragStart = nil
local startPos = nil

menu.header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = menu.mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        menu.mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Configurar reconexión después de respawn
reconnectAfterSpawn()

-- Limpiar conexiones al cerrar
game:BindToClose(function()
    for _, connection in pairs(Connections) do
        if connection then
            connection:Disconnect()
        end
    end
end)

print("H2K 99 Nights in the Forest Mod Menu cargado!")
print("Funciones disponibles:")
print("- Bring Wood/Scrap/Medical")
print("- Noclip & Infinite Jump")
print("- Kill Aura con rango ajustable")
print("- Compatible Android KRNL")
print("- by h2k")