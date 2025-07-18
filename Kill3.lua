-- Admin-like Kill All para KRNL / Synapse - solo si el servidor es vulnerable
-- ⚠️ Solo para pruebas de seguridad en colaboración con administradores

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local meleeEvent = ReplicatedStorage:WaitForChild("meleeEvent")

-- Crear GUI flotante estilo admin
local CoreGui = game:GetService("CoreGui")
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "AdminKillGUI"

local Btn = Instance.new("TextButton", Gui)
Btn.Size = UDim2.new(0, 150, 0, 50)
Btn.Position = UDim2.new(0.5, -75, 0.1, 0)
Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.GothamBold
Btn.TextSize = 18
Btn.Text = "⚠️ Kill All (Admin)"
Btn.Draggable = true
Btn.Active = true

Btn.MouseButton1Click:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            meleeEvent:FireServer(player)
        end
    end
end)
