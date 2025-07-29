-- Prison Life Mod Menu - Botones Flotantes Android
-- Optimizado para Android (solo táctil)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variables globales
local remoteKillActive = false
local buttonsVisible = true

-- Función para teletransportarse a un jugador (INSTANTÁNEO)
local function teleportToPlayer(targetPlayer)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
           targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- TP instantáneo sin animación
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
            wait()
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    end)
end

-- Función para crear botones flotantes
local function createFloatingButtons()
    -- Crear ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FloatingButtonsGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Botón 1: Instant Kill (Flotante)
    local killBtn = Instance.new("TextButton")
    killBtn.Name = "KillButton"
    killBtn.Size = UDim2.new(0, 80, 0, 80)
    killBtn.Position = UDim2.new(0, 20, 0.5, -100)
    killBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    killBtn.BorderSizePixel = 0
    killBtn.Text = "💀\nKILL"
    killBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    killBtn.TextScaled = true
    killBtn.Font = Enum.Font.SourceSansBold
    killBtn.Active = true
    killBtn.Draggable = true
    killBtn.Parent = screenGui
    
    -- Efecto visual para kill button
    local killCorner = Instance.new("UICorner")
    killCorner.CornerRadius = UDim.new(0, 15)
    killCorner.Parent = killBtn
    
    -- Botón 2: Auto Kill Toggle (Flotante)
    local autoBtn = Instance.new("TextButton")
    autoBtn.Name = "AutoButton"
    autoBtn.Size = UDim2.new(0, 80, 0, 80)
    autoBtn.Position = UDim2.new(0, 20, 0.5, -10)
    autoBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    autoBtn.BorderSizePixel = 0
    autoBtn.Text = "⚡\nAUTO"
    autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoBtn.TextScaled = true
    autoBtn.Font = Enum.Font.SourceSansBold
    autoBtn.Active = true
    autoBtn.Draggable = true
    autoBtn.Parent = screenGui
    
    -- Efecto visual para auto button
    local autoCorner = Instance.new("UICorner")
    autoCorner.CornerRadius = UDim.new(0, 15)
    autoCorner.Parent = autoBtn
    
    -- Botón 3: Speed Kill (Flotante)
    local speedBtn = Instance.new("TextButton")
    speedBtn.Name = "SpeedButton"
    speedBtn.Size = UDim2.new(0, 80, 0, 80)
    speedBtn.Position = UDim2.new(0, 20, 0.5, 80)
    speedBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
    speedBtn.BorderSizePixel = 0
    speedBtn.Text = "🚀\nSPEED"
    speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBtn.TextScaled = true
    speedBtn.Font = Enum.Font.SourceSansBold
    speedBtn.Active = true
    speedBtn.Draggable = true
    speedBtn.Parent = screenGui
    
    -- Efecto visual para speed button
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 15)
    speedCorner.Parent = speedBtn
    
    -- Botón 4: Nuclear Kill (Flotante)
    local nuclearBtn = Instance.new("TextButton")
    nuclearBtn.Name = "NuclearButton"
    nuclearBtn.Size = UDim2.new(0, 80, 0, 80)
    nuclearBtn.Position = UDim2.new(0, 20, 0.5, 170)
    nuclearBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    nuclearBtn.BorderSizePixel = 0
    nuclearBtn.Text = "☢️\nNUKE"
    nuclearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    nuclearBtn.TextScaled = true
    nuclearBtn.Font = Enum.Font.SourceSansBold
    nuclearBtn.Active = true
    nuclearBtn.Draggable = true
    nuclearBtn.Parent = screenGui
    
    -- Efecto visual para nuclear button
    local nuclearCorner = Instance.new("UICorner")
    nuclearCorner.CornerRadius = UDim.new(0, 15)
    nuclearCorner.Parent = nuclearBtn
    
    -- Botón 5: Hide/Show Toggle (Flotante)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Size = UDim2.new(0, 60, 0, 60)
    toggleBtn.Position = UDim2.new(1, -80, 0, 20)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "👁️\nHIDE"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.SourceSansBold
    toggleBtn.Active = true
    toggleBtn.Draggable = true
    toggleBtn.Parent = screenGui
    
    -- Efecto visual para toggle button
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggleBtn
    
    return screenGui, killBtn, autoBtn, speedBtn, nuclearBtn, toggleBtn
end

-- Método de Remote Kill Ultra (MUERTE INSTANTÁNEA)
local function ultraRemoteKill()
    spawn(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                pcall(function()
                    -- TP instantáneo
                    teleportToPlayer(player)
                    
                    -- BOMBARDEO MASIVO DE REMOTES (SIN ESPERAS)
                    for i = 1, 50 do
                        spawn(function()
                            if player.Character and player.Character:FindFirstChild("Humanoid") then
                                -- Spam masivo de meleeEvent
                                if ReplicatedStorage:FindFirstChild("meleeEvent") then
                                    ReplicatedStorage.meleeEvent:FireServer(player)
                                    ReplicatedStorage.meleeEvent:FireServer(player.Character)
                                    ReplicatedStorage.meleeEvent:FireServer(player.Character.Humanoid)
                                    ReplicatedStorage.meleeEvent:FireServer(player.Character.Head)
                                    ReplicatedStorage.meleeEvent:FireServer(player.Character.HumanoidRootPart)
                                end
                                
                                -- Daño nuclear
                                if ReplicatedStorage:FindFirstChild("DamageEvent") then
                                    ReplicatedStorage.DamageEvent:FireServer(player.Character.Humanoid, 999999)
                                    ReplicatedStorage.DamageEvent:FireServer(player.Character.Humanoid, 999999)
                                    ReplicatedStorage.DamageEvent:FireServer(player.Character.Humanoid, 999999)
                                end
                                
                                -- Múltiples RemoteEvents adicionales
                                if ReplicatedStorage:FindFirstChild("RemoteEvent") then
                                    ReplicatedStorage.RemoteEvent:FireServer("Damage", player, 999999)
                                    ReplicatedStorage.RemoteEvent:FireServer("Kill", player, 999999)
                                    ReplicatedStorage.RemoteEvent:FireServer("Death", player.Character)
                                end
                                
                                -- Más eventos de muerte
                                if ReplicatedStorage:FindFirstChild("UpdateEvent") then
                                    ReplicatedStorage.UpdateEvent:FireServer(player.Character.Humanoid, "Health", 0)
                                end
                                
                                if ReplicatedStorage:FindFirstChild("ReplicateEvent") then
                                    ReplicatedStorage.ReplicateEvent:FireServer(player, "Death")
                                end
                            end
                        end)
                    end
                    wait(0.05) -- Mínima espera entre jugadores
                end)
            end
        end
    end)
end

-- Speed Kill (Ultra rápido)
local function speedKill()
    spawn(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                spawn(function()
                    pcall(function()
                        teleportToPlayer(player)
                        -- Kill ultra rápido
                        for i = 1, 20 do
                            spawn(function()
                                if ReplicatedStorage:FindFirstChild("meleeEvent") then
                                    ReplicatedStorage.meleeEvent:FireServer(player)
                                end
                                if ReplicatedStorage:FindFirstChild("DamageEvent") then
                                    ReplicatedStorage.DamageEvent:FireServer(player.Character.Humanoid, 999999)
                                end
                            end)
                        end
                    end)
                end)
            end
        end
    end)
end

-- Nuclear Kill (Bombardeo masivo)
local function nuclearKill()
    spawn(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                spawn(function()
                    pcall(function()
                        teleportToPlayer(player)
                        -- Bombardeo nuclear
                        for i = 1, 100 do
                            spawn(function()
                                if ReplicatedStorage:FindFirstChild("meleeEvent") then
                                    ReplicatedStorage.meleeEvent:FireServer(player)
                                    ReplicatedStorage.meleeEvent:FireServer(player.Character)
                                    ReplicatedStorage.meleeEvent:FireServer(player.Character.Humanoid)
                                end
                                if ReplicatedStorage:FindFirstChild("DamageEvent") then
                                    ReplicatedStorage.DamageEvent:FireServer(player.Character.Humanoid, 999999)
                                end
                            end)
                        end
                    end)
                end)
            end
        end
    end)
end

-- Auto kill loop continuo (ULTRA AGRESIVO)
local function continuousRemoteKill()
    spawn(function()
        while remoteKillActive do
            -- Ejecutar kill ultra cada 0.2 segundos (MÁS RÁPIDO)
            ultraRemoteKill()
            wait(0.2)
            
            -- Verificar jugadores vivos y atacar inmediatamente
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    -- Kill instantáneo individual
                    spawn(function()
                        pcall(function()
                            teleportToPlayer(player)
                            -- Bombardeo instantáneo
                            for i = 1, 30 do
                                spawn(function()
                                    if ReplicatedStorage:FindFirstChild("meleeEvent") then
                                        ReplicatedStorage.meleeEvent:FireServer(player)
                                        ReplicatedStorage.meleeEvent:FireServer(player.Character)
                                    end
                                    if ReplicatedStorage:FindFirstChild("DamageEvent") then
                                        ReplicatedStorage.DamageEvent:FireServer(player.Character.Humanoid, 999999)
                                    end
                                end)
                            end
                        end)
                    end)
                end
            end
            
            wait(0.1) -- Ciclo ultra rápido
        end
    end)
end

-- Función principal
local function initFloatingButtons()
    -- Eliminar GUI anterior si existe
    if PlayerGui:FindFirstChild("FloatingButtonsGUI") then
        PlayerGui.FloatingButtonsGUI:Destroy()
    end
    
    -- Crear botones flotantes
    local screenGui, killBtn, autoBtn, speedBtn, nuclearBtn, toggleBtn = createFloatingButtons()
    
    -- Eventos de botones
    killBtn.MouseButton1Click:Connect(function()
        ultraRemoteKill()
        -- Efecto visual
        killBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        wait(0.1)
        killBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("💀 INSTANT DEATH EJECUTADO 💀")
    end)
    
    autoBtn.MouseButton1Click:Connect(function()
        remoteKillActive = not remoteKillActive
        if remoteKillActive then
            autoBtn.Text = "⚡\nON"
            autoBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            continuousRemoteKill()
            print("⚡ AUTO DEATH ACTIVADO ⚡")
        else
            autoBtn.Text = "⚡\nAUTO"
            autoBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            print("❌ AUTO DEATH DESACTIVADO")
        end
    end)
    
    speedBtn.MouseButton1Click:Connect(function()
        speedKill()
        -- Efecto visual
        speedBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
        wait(0.1)
        speedBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
        print("🚀 SPEED KILL EJECUTADO 🚀")
    end)
    
    nuclearBtn.MouseButton1Click:Connect(function()
        nuclearKill()
        -- Efecto visual
        nuclearBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        wait(0.1)
        nuclearBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        print("☢️ NUCLEAR KILL EJECUTADO ☢️")
    end)
    
    toggleBtn.MouseButton1Click:Connect(function()
        buttonsVisible = not buttonsVisible
        killBtn.Visible = buttonsVisible
        autoBtn.Visible = buttonsVisible
        speedBtn.Visible = buttonsVisible
        nuclearBtn.Visible = buttonsVisible
        
        if buttonsVisible then
            toggleBtn.Text = "👁️\nHIDE"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        else
            toggleBtn.Text = "👁️\nSHOW"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)
    
    print("🔥 BOTONES FLOTANTES CARGADOS 🔥")
    print("💀 Botón rojo: Kill instantáneo")
    print("⚡ Botón verde: Auto-kill toggle")
    print("🚀 Botón morado: Speed kill")
    print("☢️ Botón naranja: Nuclear kill")
    print("👁️ Botón gris: Hide/Show botones")
end

-- Inicializar botones flotantes
initFloatingButtons()