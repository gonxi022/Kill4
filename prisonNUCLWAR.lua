-- Prison Life - EXPLOIT EXTREMO PARA ANDROID
-- 70 meleeEvent por jugador + TP ULTRA RÁPIDO
-- God Mode inmortal + Botones arrastrables

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variables
local godModeEnabled = false
local godConnection = nil
local killAllEnabled = false
local killAllConnection = nil
local currentTargetIndex = 1

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PrisonLifeHackGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- Función para hacer botones arrastrables (SOLO TOUCH o clic)
local function makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
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

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

-- Botón Kill All
local killButton = Instance.new("TextButton")
killButton.Name = "KillAllButton"
killButton.Size = UDim2.new(0, 220, 0, 70)
killButton.Position = UDim2.new(0, 20, 0, 60)
killButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
killButton.BorderSizePixel = 0
killButton.Text = "🔫 Kill All: OFF"
killButton.TextColor3 = Color3.new(1, 1, 1)
killButton.TextScaled = true
killButton.Font = Enum.Font.GothamBold
killButton.Parent = gui

local killCorner = Instance.new("UICorner")
killCorner.CornerRadius = UDim.new(0, 12)
killCorner.Parent = killButton

-- Botón God Mode
local godButton = Instance.new("TextButton")
godButton.Name = "GodModeButton"
godButton.Size = UDim2.new(0, 220, 0, 70)
godButton.Position = UDim2.new(0, 20, 0, 150)
godButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
godButton.BorderSizePixel = 0
godButton.Text = "🛡️ God Mode: OFF"
godButton.TextColor3 = Color3.new(1, 1, 1)
godButton.TextScaled = true
godButton.Font = Enum.Font.GothamBold
godButton.Parent = gui

local godCorner = Instance.new("UICorner")
godCorner.CornerRadius = UDim.new(0, 12)
godCorner.Parent = godButton

-- Hacer botones móviles
makeDraggable(killButton)
makeDraggable(godButton)

-- Función para obtener jugadores enemigos
local function getTargets()
    local targets = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                table.insert(targets, player)
            end
        end
    end
    return targets
end

-- Teletransporte ULTRA RÁPIDO (sin delays)
local function teleportTo(targetPlayer)
    local myChar = LocalPlayer.Character
    local targetChar = targetPlayer.Character
    if myChar and targetChar and myChar:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
        -- TP instantáneo sin delays
        myChar.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 2, 1)
        return true
    end
    return false
end

-- Kill All EXTREMO - 70 hits + TP ultra rápido
local function toggleKillAll()
    if killAllEnabled then
        killAllEnabled = false
        killButton.Text = "🔫 Kill All: OFF"
        killButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        if killAllConnection then
            task.cancel(killAllConnection)
            killAllConnection = nil
        end
        return
    end

    killAllEnabled = true
    killButton.Text = "💀 Kill All: ON (x70)"
    killButton.BackgroundColor3 = Color3.fromRGB(255, 20, 20)

    -- Buscar meleeEvent
    local meleeEvent = ReplicatedStorage:FindFirstChild("meleeEvent")
    if not meleeEvent then
        for _, name in ipairs({"RemoteEvent", "hitEvent", "damageEvent", "attackEvent"}) do
            local alt = ReplicatedStorage:FindFirstChild(name)
            if alt then
                meleeEvent = alt
                break
            end
        end
    end

    if not meleeEvent then
        warn("⚠️ No se encontró meleeEvent!")
        killAllEnabled = false
        killButton.Text = "🔫 Kill All: OFF"
        killButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        return
    end

    print("🚀 EXPLOIT ACTIVADO - meleeEvent:", meleeEvent.Name)

    killAllConnection = task.spawn(function()
        while killAllEnabled do
            local targets = getTargets()
            if #targets == 0 then 
                task.wait(0.1) 
                continue 
            end

            -- Resetear índice si es necesario
            if currentTargetIndex > #targets then 
                currentTargetIndex = 1 
            end
            
            local target = targets[currentTargetIndex]

            -- TP ULTRA RÁPIDO (sin espera)
            if teleportTo(target) then
                -- 70 HITS AGRESIVOS Y RÁPIDOS
                for i = 1, 70 do
                    -- Método 1: Basic meleeEvent
                    pcall(function() 
                        meleeEvent:FireServer(target) 
                    end)
                    
                    -- Método 2: Con parámetros extra
                    pcall(function() 
                        meleeEvent:FireServer(target, "Hit", 100) 
                    end)
                    
                    -- Método 3: Directo al Humanoid
                    pcall(function() 
                        meleeEvent:FireServer(target.Character.Humanoid) 
                    end)
                    
                    -- SIN DELAYS - máxima velocidad
                end
                
                print("💀 70 hits enviados a:", target.Name)
            end
            
            -- Pasar al siguiente objetivo MUY RÁPIDO
            currentTargetIndex = currentTargetIndex + 1
            task.wait(0.05) -- Delay mínimo entre jugadores
        end
    end)
end

-- God Mode INMORTAL
local function toggleGodMode()
    if godModeEnabled then
        godModeEnabled = false
        godButton.Text = "🛡️ God Mode: OFF"
        godButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        if godConnection then
            godConnection:Disconnect()
            godConnection = nil
        end
        -- Restaurar salud normal
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.MaxHealth = 100
            LocalPlayer.Character.Humanoid.Health = 100
        end
        return
    end

    godModeEnabled = true
    godButton.Text = "⚡ God Mode: ON"
    godButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)

    -- God Mode EXTREMO
    godConnection = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            -- Salud infinita
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            
            -- Anti-knockback y anti-caída
            if char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                if root.Velocity.Magnitude > 50 then
                    root.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
    
    print("⚡ God Mode ACTIVADO - Inmortal total!")
end

-- Auto-reaplicar hacks al reaparecer
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)
    
    -- Reactivar God Mode si estaba activado
    if godModeEnabled then 
        local wasEnabled = godModeEnabled
        godModeEnabled = false
        if godConnection then godConnection:Disconnect() end
        task.wait(0.3)
        if wasEnabled then toggleGodMode() end
    end
    
    -- Reactivar Kill All si estaba activado
    if killAllEnabled then 
        local wasEnabled = killAllEnabled
        killAllEnabled = false
        if killAllConnection then task.cancel(killAllConnection) end
        task.wait(0.3)
        if wasEnabled then toggleKillAll() end
    end
end)

-- Conectar botones
killButton.MouseButton1Click:Connect(toggleKillAll)
godButton.MouseButton1Click:Connect(toggleGodMode)

-- Información del exploit
print("🚀 PRISON LIFE EXPLOIT EXTREMO CARGADO!")
print("💀 Kill All: 70 hits por jugador + TP ultra rápido")
print("⚡ God Mode: Salud infinita + Anti-knockback")
print("📱 Optimizado para Android/KRNL")
print("🔥 MODO EXTREMO ACTIVADO!")