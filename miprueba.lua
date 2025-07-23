--Mod menu y botones
local modMenu = Instance.new("ScreenGui")
local noClip = Instance.new("TextButton")
local noClipEnabled = false

--Propiedades

modMenu.Name = "modMenu"
modMenu.ResetOnSpawn = false
modMenu.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")


noClip.Name = "NoClip"
noClip.Size = UDim2.new(0, 150, 0, 50)
noClip.Position = UDim2.new(0, 120, 0, 120)
noClip.Text = "NoClipOff"
noClip.Parent = modMenu
noClip.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
noClip.TextColor3 = Color3.fromRGB(255, 255, 255)
noClip.Font = Enum.Font.SourceSans
noClip.TextSize = 20 

noClip.MouseButton1Click:Connect(function()
  noClipEnabled = not noClipEnabled
  noClip.Text = noClipEnabled and
  "NoClipOn" or "NoClipOff"
end)

local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

RunService.Stepped:Connect(function()
  if player.Character then
    for _, part in 
    pairs(player.Character:GetDescendants()) do
      if part:IsA("BasePart") then
        part.CanCollide = not noClipEnabled
      end
    end
  end
end)
