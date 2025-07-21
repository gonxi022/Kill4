-- Arsenal Mod Menu (Auto Win / Auto Kill / ESP / Touch UI)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Estados de funciones
local settings = {
    autoKill = false,
    autoPlay = false,
    esp = false
}

-- GUI
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.ResetOnSpawn = false
screenGui.Name = "ArsenalModMenu"

local mainButton = Instance.new("TextButton", screenGui)
mainButton.Size = UDim2.new(0, 50, 0, 50)
mainButton.Position = UDim2.new(0, 10, 0.5, -25)
mainButton.Text = "≡"
mainButton.BackgroundColor3 = Color3.new(0, 0, 0)
mainButton.TextColor3 = Color3.new(1, 1, 1)
mainButton.TextScaled = true
mainButton.ZIndex = 10

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 180)
frame.Position = UDim2.new(0, 70, 0.5, -90)
frame.Visible = false
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.ZIndex = 9

function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name .. ": OFF"
    btn.TextScaled = true
    btn.MouseButton1Click:Connect(function()
        settings[name] = not settings[name]
        btn.Text = name .. ": " .. (settings[name] and "ON" or "OFF")
        callback(settings[name])
    end)
end

mainButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- ESP
local function createESP(player)
    if player == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.new(1, 0, 0)
    box.Transparency = 1
    box.Filled = false

    RunService.RenderStepped:Connect(function()
        if settings.esp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
                local size = 50 / dist
                box.Size = Vector2.new(size * 2, size * 3)
                box.Position = Vector2.new(pos.X - size, pos.Y - size * 1.5)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        wait(1)
        createESP(p)
    end)
end)

-- Auto Kill
spawn(function()
    while true do
        task.wait(0.3)
        if settings.autoKill then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Humanoid") then
                    p.Character.Humanoid.Health = 0
                end
            end
        end
    end
end)

-- Auto Play (bot simple)
spawn(function()
    while true do
        task.wait(0.5)
        if settings.autoPlay and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, -3)
                end
            end
        end
    end
end)

-- Crear botones
createToggle("esp", 10, function(_) end)
createToggle("autoKill", 55, function(_) end)
createToggle("autoPlay", 100, function(_) end)