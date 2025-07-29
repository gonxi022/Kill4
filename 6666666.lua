-- Prison Life Mod Menu - Remote Kill Only
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
local gui = nil
local isMinimized = false

-- Función para teletransportarse a un jugador
local function teleportToPlayer(targetPlayer)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
           targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        end
    end)
end

-- Función para crear la GUI
local function createGUI()
    -- Crear ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModMenuGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Frame principal (draggable)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 220, 0, 180)
    mainFrame.Position = UDim2.new(0, 50, 0, 50)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.8, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "Prison Menu"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = mainFrame
    
    -- Botón minimizar
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
    minimizeBtn.Position = UDim2.new(1, -50, 0, 2.5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 50)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextScaled = true
    minimizeBtn.Font = Enum.Font.SourceSansBold
    minimizeBtn.Parent = mainFrame
    
    -- Botón cerrar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -25, 0, 2.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.Parent = mainFrame
    
    -- Container para botones (para poder ocultar)
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, 0, 1, -30)
    buttonContainer.Position = UDim2.new(0, 0, 0, 30)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = mainFrame
    
    -- Botón 1: Remote Kill Ultra
    local btn1 = Instance.new("TextButton")
    btn1.Name = "RemoteKill"
    btn1.Size = UDim2.new(0.9, 0, 0, 50)
    btn1.Position = UDim2.new(0.05, 0, 0, 20)
    btn1.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
    btn1.BorderSizePixel = 0
    btn1.Text = "🔥 ULTRA KILL 🔥"
    btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn1.TextScaled = true
    btn1.Font = Enum.Font.SourceSansBold
    btn1.Parent = buttonContainer
    
    -- Botón 2: Auto Remote Kill Toggle
    local btn2 = Instance.new("TextButton")
    btn2.Name = "AutoRemoteKill"
    btn2.Size = UDim2.new(0.9, 0, 0, 50)
    btn2.Position = UDim2.new(0.05, 0, 0, 80)
    btn2.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
    btn2.BorderSizePixel = 0
    btn2.Text = "AUTO KILL: OFF"
    btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn2.TextScaled = true
    btn2.Font = Enum.Font.SourceSansBold
    btn2.Parent = buttonContainer
    
    return screenGui, btn1, btn2, closeBtn, minimizeBtn, buttonContainer, mainFrame
end

-- Método de Remote Kill Ultra (más roto y letal)
local function ultraRemoteKill()
    spawn(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                pcall(function()
                    -- TP al jugador
                    teleportToPlayer(player)
                    wait(0.05)
                    
                    -- Ataques masivos ultra rápidos
                    for i = 1, 25 do
                        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                            -- Múltiples RemoteEvents
                            if ReplicatedStorage:FindFirstChild("meleeEvent") then
                                ReplicatedStorage.meleeEvent:FireServer(player)
                                ReplicatedStorage.meleeEvent:FireServer(player.Character)
                                ReplicatedStorage.meleeEvent:FireServer(player.Character.Humanoid)
                            end
                            -- Daño directo masivo
                            if ReplicatedStorage:FindFirstChild("DamageEvent") then
                                ReplicatedStorage.DamageEvent:FireServer(player.Character.Humanoid, 500)
                            end
                            -- Más eventos de daño
                            if ReplicatedStorage:FindFirstChild("RemoteEvent") then
                                ReplicatedStorage.RemoteEvent:FireServer("Damage", player, 300)
                            end
                        end
                        wait(0.01) -- Ultra rápido
                    end
                    wait(0.1)
                end)
            end
        end
    end)
end

-- Auto kill loop continuo (no para hasta desactivar)
local function continuousRemoteKill()
    spawn(function()
        while remoteKillActive do
            -- Ejecutar kill ultra cada 0.5 segundos
            ultraRemoteKill()
            wait(0.5)
            
            -- Verificar si hay jugadores vivos y seguir matando
            local playersAlive = false
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    playersAlive = true
                    break
                end
            end
            
            -- Si hay jugadores vivos, seguir matando inmediatamente
            if playersAlive then
                wait(0.1)
            else
                wait(1) -- Esperar un poco si no hay jugadores
            end
        end
    end)
end

-- Función principal
local function initModMenu()
    -- Eliminar GUI anterior si existe
    if PlayerGui:FindFirstChild("ModMenuGUI") then
        PlayerGui.ModMenuGUI:Destroy()
    end
    
    -- Crear nueva GUI
    local screenGui, btn1, btn2, closeBtn, minimizeBtn, buttonContainer, mainFrame = createGUI()
    gui = screenGui
    
    -- Función de minimizar
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            buttonContainer.Visible = false
            mainFrame.Size = UDim2.new(0, 220, 0, 30)
            minimizeBtn.Text = "+"
        else
            buttonContainer.Visible = true
            mainFrame.Size = UDim2.new(0, 220, 0, 180)
            minimizeBtn.Text = "-"
        end
    end)
    
    -- Conectar eventos de botones
    btn1.MouseButton1Click:Connect(function()
        ultraRemoteKill()
        print("🔥 ULTRA REMOTE KILL EJECUTADO 🔥")
    end)
    
    btn2.MouseButton1Click:Connect(function()
        remoteKillActive = not remoteKillActive
        if remoteKillActive then
            btn2.Text = "AUTO KILL: ON 🔥"
            btn2.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
            continuousRemoteKill()
            print("🔥 AUTO REMOTE KILL ACTIVADO - NO PARA HASTA DESACTIVAR 🔥")
        else
            btn2.Text = "AUTO KILL: OFF"
            btn2.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
            print("❌ AUTO REMOTE KILL DESACTIVADO")
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        remoteKillActive = false
        screenGui:Destroy()
        print("Mod Menu cerrado")
    end)
    
    print("🔥 ULTRA REMOTE KILL MENU CARGADO 🔥")
    print("- Botón 1: Kill instantáneo ultra roto")
    print("- Botón 2: Auto-kill continuo (no para hasta desactivar)")
end

-- Inicializar el mod menu
initModMenu()

-- Función para reabrir el menú (opcional)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        if gui and gui.Parent then
            gui:Destroy()
        else
            initModMenu()
        end
    end
end)