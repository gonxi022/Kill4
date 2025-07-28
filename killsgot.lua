-- Prison Life Police Hack - Android KRNL Optimizado
-- Funcional para dispositivos móviles táctiles

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local killAllActive1 = false
local killAllActive2 = false
local noclipEnabled = false
local speedEnabled = false
local flyEnabled = false
local normalSpeed = 16
local speedMultiplier = 5
local originalGravity = Workspace.Gravity

-- Referencias importantes
local shootEvent = nil
local damageEvent = nil

-- Buscar eventos importantes
for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") then
        if remote.Name == "ShootEvent" or remote.Name == "ShotEvent" or remote.Name == "FireEvent" then
            shootEvent = remote
        elseif remote.Name == "DamageEvent" or remote.Name == "HitEvent" or remote.Name == "DamageHumanoid" then
            damageEvent = remote
        end
    end
end

-- Si no encuentra, usar los remotes capturados
if not shootEvent then
    shootEvent = ReplicatedStorage:FindFirstChild("ReplicateEvent") or ReplicatedStorage:FindFirstChild("ShootEvent")
end

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PrisonLifePoliceGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleLabel.Text = "🚔 Prison Life Police Hack"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Botón Kill All Método 1 (TP + Shoot)
local killAll1Btn = Instance.new("TextButton")
killAll1Btn.Size = UDim2.new(0.45, 0, 0, 30)
killAll1Btn.Position = UDim2.new(0.05, 0, 0, 40)
killAll1Btn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
killAll1Btn.Text = "🎯 TP KILL"
killAll1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
killAll1Btn.TextScaled = true
killAll1Btn.Font = Enum.Font.Gotham
killAll1Btn.Parent = mainFrame

local btn1Corner = Instance.new("UICorner")
btn1Corner.CornerRadius = UDim.new(0, 6)
btn1Corner.Parent = killAll1Btn

-- Botón Kill All Método 2 (Damage Event)
local killAll2Btn = Instance.new("TextButton")
killAll2Btn.Size = UDim2.new(0.45, 0, 0, 30)
killAll2Btn.Position = UDim2.new(0.5, 0, 0, 40)
killAll2Btn.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
killAll2Btn.Text = "⚡ DMG KILL"
killAll2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
killAll2Btn.TextScaled = true
killAll2Btn.Font = Enum.Font.Gotham
killAll2Btn.Parent = mainFrame

local btn2Corner = Instance.new("UICorner")
btn2Corner.CornerRadius = UDim.new(0, 6)
btn2Corner.Parent = killAll2Btn

-- Botón Noclip
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.3, 0, 0, 25)
noclipBtn.Position = UDim2.new(0.05, 0, 0, 80)
noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
noclipBtn.Text = "👻 NOCLIP"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.TextScaled = true
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.Parent = mainFrame

local btn3Corner = Instance.new("UICorner")
btn3Corner.CornerRadius = UDim.new(0, 4)
btn3Corner.Parent = noclipBtn

-- Botón Speed
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.3, 0, 0, 25)
speedBtn.Position = UDim2.new(0.35, 0, 0, 80)
speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
speedBtn.Text = "💨 SPEED"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextScaled = true
speedBtn.Font = Enum.Font.Gotham
speedBtn.Parent = mainFrame

local btn4Corner = Instance.new("UICorner")
btn4Corner.CornerRadius = UDim.new(0, 4)
btn4Corner.Parent = speedBtn

-- Botón Fly
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.3, 0, 0, 25)
flyBtn.Position = UDim2.new(0.65, 0, 0, 80)
flyBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
flyBtn.Text = "🚁 FLY"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextScaled = true
flyBtn.Font = Enum.Font.Gotham
flyBtn.Parent = mainFrame

local btn5Corner = Instance.new("UICorner")
btn5Corner.CornerRadius = UDim.new(0, 4)
btn5Corner.Parent = flyBtn

-- Label de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 40)
statusLabel.Position = UDim2.new(0, 5, 0, 115)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔫 Listo para eliminar criminales\n👮 Modo: Policía Activo"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Funciones principales

-- Obtener todos los criminales
local function getCriminals()
    local criminals = {}
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
            local rootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                -- En Prison Life, los criminales suelen tener team "Criminals" o estar en ciertas áreas
                if targetPlayer.Team and (targetPlayer.Team.Name == "Criminals" or targetPlayer.Team.Name == "Inmates") then
                    table.insert(criminals, targetPlayer)
                elseif not targetPlayer.Team then -- Sin team = criminal
                    table.insert(criminals, targetPlayer)
                end
            end
        end
    end
    return criminals
end

-- Método 1: TP + Shoot (para Remington)
local function killAllMethod1()
    if not killAllActive1 then return end
    
    local criminals = getCriminals()
    
    for _, criminal in pairs(criminals) do
        if criminal.Character and criminal.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = criminal.Character.HumanoidRootPart.Position
            
            -- TP detrás del criminal
            rootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, -5), targetPos)
            wait(0.1)
            
            -- Disparar con Remington
            if shootEvent then
                -- Simular disparo a la cabeza
                local headPos = criminal.Character:FindFirstChild("Head")
                if headPos then
                    shootEvent:FireServer(headPos.Position, criminal.Character)
                end
            end
            
            wait(0.2) -- Delay entre kills
        end
    end
end

-- Método 2: Damage Event directo
local function killAllMethod2()
    if not killAllActive2 then return end
    
    local criminals = getCriminals()
    
    for _, criminal in pairs(criminals) do
        if criminal.Character and criminal.Character:FindFirstChild("Humanoid") then
            -- Método directo de daño
            if damageEvent then
                damageEvent:FireServer(criminal.Character.Humanoid, 100)
            elseif shootEvent then
                -- Usar shoot event con daño masivo
                shootEvent:FireServer(criminal.Character.Head.Position, criminal.Character, 100)
            end
            
            -- Método alternativo: cambiar health directamente
            pcall(function()
                criminal.Character.Humanoid.Health = 0
            end)
            
            wait(0.1)
        end
    end
end

-- Noclip function
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        noclipBtn.Text = "👻 ON"
        
        -- Activar noclip
        local connection
        connection = RunService.Stepped:Connect(function()
            if not noclipEnabled then
                connection:Disconnect()
                return
            end
            
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        noclipBtn.Text = "👻 NOCLIP"
        
        -- Restaurar colisiones
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

-- Speed function
local function toggleSpeed()
    speedEnabled = not speedEnabled
    
    if speedEnabled then
        speedBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        speedBtn.Text = "💨 ON"
        humanoid.WalkSpeed = normalSpeed * speedMultiplier
    else
        speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
        speedBtn.Text = "💨 SPEED"
        humanoid.WalkSpeed = normalSpeed
    end
end

-- Fly function
local function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        flyBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        flyBtn.Text = "🚁 ON"
        
        -- Crear BodyVelocity para fly
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        -- Reducir gravedad
        Workspace.Gravity = 0
        
        -- Control de vuelo (simplificado para móvil)
        local flyConnection
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled then
                bodyVelocity:Destroy()
                Workspace.Gravity = originalGravity
                flyConnection:Disconnect()
                return
            end
            
            -- Vuelo básico hacia adelante
            local camera = Workspace.CurrentCamera
            local moveVector = camera.CFrame.LookVector * 50
            bodyVelocity.Velocity = moveVector
        end)
    else
        flyBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
        flyBtn.Text = "🚁 FLY"
        Workspace.Gravity = originalGravity
    end
end

-- Eventos de botones
killAll1Btn.MouseButton1Click:Connect(function()
    killAllActive1 = not killAllActive1
    
    if killAllActive1 then
        killAll1Btn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        killAll1Btn.Text = "🎯 ACTIVE"
        statusLabel.Text = "🔫 TP Kill activo\n⚡ Eliminando criminales..."
        
        spawn(function()
            while killAllActive1 do
                killAllMethod1()
                wait(1) -- Delay entre rondas
            end
        end)
    else
        killAll1Btn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        killAll1Btn.Text = "🎯 TP KILL"
        statusLabel.Text = "🔫 TP Kill desactivado"
    end
end)

killAll2Btn.MouseButton1Click:Connect(function()
    killAllActive2 = not killAllActive2
    
    if killAllActive2 then
        killAll2Btn.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
        killAll2Btn.Text = "⚡ ACTIVE"
        statusLabel.Text = "⚡ Damage Kill activo\n💀 Eliminando criminales..."
        
        spawn(function()
            while killAllActive2 do
                killAllMethod2()
                wait(0.5) -- Más rápido que método 1
            end
        end)
    else
        killAll2Btn.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
        killAll2Btn.Text = "⚡ DMG KILL"
        statusLabel.Text = "⚡ Damage Kill desactivado"
    end
end)

noclipBtn.MouseButton1Click:Connect(toggleNoclip)
speedBtn.MouseButton1Click:Connect(toggleSpeed)
flyBtn.MouseButton1Click:Connect(toggleFly)

-- Hacer GUI draggable para móvil
local dragging = false
local dragStart = nil
local startPos = nil

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Actualizar character reference cuando respawnee
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

print("🚔 Prison Life Police Hack cargado")
print("📱 Optimizado para Android KRNL")
print("👮 Listo para mantener el orden")