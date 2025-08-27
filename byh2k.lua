-- 👻 LIFE SENTENCE - NOCLIP BUTTON by H2K
-- Botón flotante estético y funcional
-- No se resetea al morir - Compatible Android Krnl

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local noclipActive = false
local noclipConnection = nil

-- Limpiar GUI anterior
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("H2KNoclip") then
        LocalPlayer.PlayerGui:FindFirstChild("H2KNoclip"):Destroy()
    end
end)

-- Función de noclip real
local function toggleNoclip()
    noclipActive = not noclipActive
    
    if noclipActive then
        -- Activar noclip
        noclipConnection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        -- Desactivar noclip
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Crear botón estético
local function createButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "H2KNoclip"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer.PlayerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "NoclipFrame"
    mainFrame.Size = UDim2.new(0, 120, 0, 100)
    mainFrame.Position = UDim2.new(1, -140, 0.5, -50)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    -- Gradiente de fondo
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    }
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Sombra
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, -4)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 19)
    shadowCorner.Parent = shadow
    
    -- Borde de estado
    local statusStroke = Instance.new("UIStroke")
    statusStroke.Color = Color3.fromRGB(255, 85, 85)
    statusStroke.Thickness = 2
    statusStroke.Transparency = 0
    statusStroke.Parent = mainFrame
    
    -- Header con créditos
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 25)
    header.BackgroundColor3 = Color3.fromRGB(45, 85, 255)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 15)
    headerCorner.Parent = header
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 85, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 125, 255))
    }
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    local creditsLabel = Instance.new("TextLabel")
    creditsLabel.Size = UDim2.new(1, 0, 1, 0)
    creditsLabel.BackgroundTransparency = 1
    creditsLabel.Text = "by H2K"
    creditsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    creditsLabel.TextSize = 12
    creditsLabel.Font = Enum.Font.GothamBold
    creditsLabel.TextStrokeTransparency = 0
    creditsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    creditsLabel.Parent = header
    
    -- Botón principal
    local noclipButton = Instance.new("TextButton")
    noclipButton.Name = "NoclipButton"
    noclipButton.Size = UDim2.new(1, -16, 1, -35)
    noclipButton.Position = UDim2.new(0, 8, 0, 30)
    noclipButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    noclipButton.Text = ""
    noclipButton.BorderSizePixel = 0
    noclipButton.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = noclipButton
    
    -- Gradiente del botón
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 45))
    }
    buttonGradient.Rotation = 90
    buttonGradient.Parent = noclipButton
    
    -- Texto "NO CLIP"
    local noclipText = Instance.new("TextLabel")
    noclipText.Size = UDim2.new(1, 0, 0.6, 0)
    noclipText.Position = UDim2.new(0, 0, 0, 5)
    noclipText.BackgroundTransparency = 1
    noclipText.Text = "NO CLIP"
    noclipText.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipText.TextSize = 16
    noclipText.Font = Enum.Font.GothamBold
    noclipText.TextStrokeTransparency = 0
    noclipText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noclipText.Parent = noclipButton
    
    -- Estado del botón
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, 0, 0.4, 0)
    statusText.Position = UDim2.new(0, 0, 0.6, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "OFF"
    statusText.TextColor3 = Color3.fromRGB(255, 85, 85)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.GothamBold
    statusText.TextStrokeTransparency = 0
    statusText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    statusText.Parent = noclipButton
    
    -- Función para actualizar estado visual
    local function updateButtonState()
        if noclipActive then
            -- Estado ON
            buttonGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 170, 85)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 130, 65))
            }
            statusText.Text = "ON"
            statusText.TextColor3 = Color3.fromRGB(150, 255, 150)
            statusStroke.Color = Color3.fromRGB(85, 255, 85)
            noclipText.TextColor3 = Color3.fromRGB(200, 255, 200)
        else
            -- Estado OFF
            buttonGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 45))
            }
            statusText.Text = "OFF"
            statusText.TextColor3 = Color3.fromRGB(255, 85, 85)
            statusStroke.Color = Color3.fromRGB(255, 85, 85)
            noclipText.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    
    -- Conectar click del botón
    noclipButton.MouseButton1Click:Connect(function()
        toggleNoclip()
        updateButtonState()
        
        -- Animación de click
        local clickTween = TweenService:Create(noclipButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, -20, 1, -39)
        })
        local backTween = TweenService:Create(noclipButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, -16, 1, -35)
        })
        
        clickTween:Play()
        clickTween.Completed:Connect(function()
            backTween:Play()
        end)
    end)
    
    -- Efectos hover
    noclipButton.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(noclipButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        })
        hoverTween:Play()
    end)
    
    noclipButton.MouseLeave:Connect(function()
        local unhoverTween = TweenService:Create(noclipButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        })
        unhoverTween:Play()
    end)
    
    -- Hacer arrastrable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Estado inicial
    updateButtonState()
    
    return {
        gui = screenGui,
        updateState = updateButtonState
    }
end

-- Función para mantener noclip activo tras respawn
local function onCharacterAdded(character)
    if noclipActive then
        wait(1) -- Esperar que el personaje cargue
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        -- Reactivar noclip
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Crear el botón
local button = createButton()

-- Conectar respawn
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Si ya hay personaje, conectarlo
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

-- Limpiar al salir
game:BindToClose(function()
    if noclipConnection then
        noclipConnection:Disconnect()
    end
end)

-- Confirmación
print("👻 H2K Noclip Button cargado exitosamente!")
print("📱 Botón estético funcional para Life Sentence")
print("🔄 No se resetea al morir")
print("✨ by H2K - Compatible Android Krnl")