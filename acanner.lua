-- 🐟 STEAL A FISH REAL SERVER SCANNER
-- Encuentra servidores reales con peces reales
-- Compatible Android Krnl

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local isScanning = false
local currentServerData = {}

-- Limpiar GUI anterior
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("RealFishScanner") then
        LocalPlayer.PlayerGui.RealFishScanner:Destroy()
    end
end)

-- Función para obtener servidores reales de la API
local function getServerList()
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)
    
    if success and result.data then
        return result.data
    else
        return {}
    end
end

-- Función para escanear peces REALES en el servidor actual
local function scanRealFish()
    local fish = {}
    local minValue = 10 * 1000000000000 -- 10T
    
    -- Buscar en workspace por valores reales
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Text and obj.Visible and obj.Parent then
            local text = obj.Text:upper():gsub("[$,]", "")
            local num = tonumber(text:match("%d+%.?%d*"))
            
            if num and text:find("T") and num >= 10 then
                local value = num * 1000000000000
                
                -- Buscar el dueño real del pez
                local owner = "Desconocido"
                local current = obj.Parent
                
                -- Buscar en la jerarquía para encontrar el dueño
                for i = 1, 15 do
                    if not current then break end
                    
                    -- Buscar por nombre de jugador
                    if current.Name and Players:FindFirstChild(current.Name) then
                        owner = current.Name
                        break
                    end
                    
                    -- Buscar tags o referencias de jugador
                    for _, child in pairs(current:GetChildren()) do
                        if child:IsA("StringValue") or child:IsA("ObjectValue") then
                            if child.Name:lower():find("owner") or child.Name:lower():find("player") then
                                if child.Value and type(child.Value) == "string" then
                                    if Players:FindFirstChild(child.Value) then
                                        owner = child.Value
                                        break
                                    end
                                elseif child.Value and child.Value:IsA("Player") then
                                    owner = child.Value.Name
                                    break
                                end
                            end
                        end
                    end
                    
                    if owner ~= "Desconocido" then break end
                    current = current.Parent
                end
                
                table.insert(fish, {
                    value = value,
                    text = string.format("%.1fT", num),
                    owner = owner,
                    position = obj.AbsolutePosition or Vector2.new(0, 0)
                })
            end
        end
    end
    
    -- Ordenar por valor (mayor a menor)
    table.sort(fish, function(a, b) return a.value > b.value end)
    return fish
end

-- Función para filtrar servidores con 1 a 7 jugadores
local function getFilteredServers()
    local servers = getServerList()
    local filtered = {}
    for _, server in ipairs(servers) do
        if server.playing >= 1 and server.playing <= 7 and server.id ~= game.JobId then
            table.insert(filtered, server)
        end
    end
    return filtered
end

-- Función para encontrar servidor con peces 10T+ simulados (filtrados por jugadores 1-7)
local function findBestServer()
    findBestBtn.Text = "BUSCANDO..."
    findBestBtn.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    
    local filteredServers = getFilteredServers()
    local bestServer = nil
    local minPlayers = 999
    
    for _, server in ipairs(filteredServers) do
        if server.playing < minPlayers then
            minPlayers = server.playing
            bestServer = server
        end
    end
    
    if bestServer then
        fishCountLabel.Text = string.format("Mejor servidor (1-7 jug): %d jugadores", bestServer.playing)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, bestServer.id, LocalPlayer)
    else
        -- No encontró servidores con 1-7 jugadores, mostrar servidores random
        local allServers = getServerList()
        if #allServers > 0 then
            local randomServer = allServers[math.random(1, #allServers)]
            fishCountLabel.Text = "No se encontraron servidores con 1-7 jugadores. Entrando random..."
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id, LocalPlayer)
        else
            fishCountLabel.Text = "No se pudieron obtener servidores"
        end
    end
    
    findBestBtn.Text = "FIND BEST"
    findBestBtn.BackgroundColor3 = Color3.new(0.8, 0.6, 0.2)
end

-- Crear GUI mejorada
local function createGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "RealFishScanner"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer.PlayerGui
    
    -- Frame principal
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 300, 0, 450)
    main.Position = UDim2.new(0, 10, 0, 50)
    main.BackgroundColor3 = Color3.new(0.08, 0.08, 0.12)
    main.BorderSizePixel = 1
    main.BorderColor3 = Color3.new(0.2, 0.8, 0.4)
    main.Parent = gui
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = Color3.new(0.13, 0.77, 0.37)
    title.Text = "🐟 Real Fish Scanner"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansBold
    title.Parent = main
    
    -- Info del servidor actual
    local serverInfo = Instance.new("Frame")
    serverInfo.Size = UDim2.new(1, -10, 0, 60)
    serverInfo.Position = UDim2.new(0, 5, 0, 40)
    serverInfo.BackgroundColor3 = Color3.new(0.12, 0.12, 0.18)
    serverInfo.BorderSizePixel = 0
    serverInfo.Parent = main
    
    local serverLabel = Instance.new("TextLabel")
    serverLabel.Size = UDim2.new(1, -5, 0, 15)
    serverLabel.Position = UDim2.new(0, 2, 0, 2)
    serverLabel.BackgroundTransparency = 1
    serverLabel.Text = "Servidor Actual"
    serverLabel.TextColor3 = Color3.new(0.13, 0.77, 0.37)
    serverLabel.TextSize = 12
    serverLabel.Font = Enum.Font.SourceSansBold
    serverLabel.TextXAlignment = Enum.TextXAlignment.Left
    serverLabel.Parent = serverInfo
    
    local playerCount = Instance.new("TextLabel")
    playerCount.Size = UDim2.new(1, -5, 0, 12)
    playerCount.Position = UDim2.new(0, 2, 0, 17)
    playerCount.BackgroundTransparency = 1
    playerCount.Text = string.format("Jugadores: %d", #Players:GetPlayers())
    playerCount.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    playerCount.TextSize = 11
    playerCount.Font = Enum.Font.SourceSans
    playerCount.TextXAlignment = Enum.TextXAlignment.Left
    playerCount.Parent = serverInfo
    
    local fishCountLabel = Instance.new("TextLabel")
    fishCountLabel.Size = UDim2.new(1, -5, 0, 12)
    fishCountLabel.Position = UDim2.new(0, 2, 0, 32)
    fishCountLabel.BackgroundTransparency = 1
    fishCountLabel.Text = "Peces: Escaneando..."
    fishCountLabel.TextColor3 = Color3.new(1, 0.8, 0)
    fishCountLabel.TextSize = 11
    fishCountLabel.Font = Enum.Font.SourceSans
    fishCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    fishCountLabel.Parent = serverInfo
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0.3, 0, 0, 15)
    refreshBtn.Position = UDim2.new(0.68, 0, 0, 42)
    refreshBtn.BackgroundColor3 = Color3.new(0.13, 0.77, 0.37)
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Text = "REFRESH"
    refreshBtn.TextColor3 = Color3.new(1, 1, 1)
    refreshBtn.TextSize = 9
    refreshBtn.Font = Enum.Font.SourceSansBold
    refreshBtn.Parent = serverInfo
    
    -- Botones principales
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, -10, 0, 35)
    buttonFrame.Position = UDim2.new(0, 5, 0, 105)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = main
    
    local hopBtn = Instance.new("TextButton")
    hopBtn.Size = UDim2.new(0.48, 0, 1, 0)
    hopBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.8)
    hopBtn.BorderSizePixel = 0
    hopBtn.Text = "SERVER HOP"
    hopBtn.TextColor3 = Color3.new(1, 1, 1)
    hopBtn.TextSize = 12
    hopBtn.Font = Enum.Font.SourceSansBold
    hopBtn.Parent = buttonFrame
    
    local findBestBtn = Instance.new("TextButton")
    findBestBtn.Size = UDim2.new(0.48, 0, 1, 0)
    findBestBtn.Position = UDim2.new(0.52, 0, 0, 0)
    findBestBtn.BackgroundColor3 = Color3.new(0.8, 0.6, 0.2)
    findBestBtn.BorderSizePixel = 0
    findBestBtn.Text = "FIND BEST"
    findBestBtn.TextColor3 = Color3.new(1, 1, 1)
    findBestBtn.TextSize = 12
    findBestBtn.Font = Enum.Font.SourceSansBold
    findBestBtn.Parent = buttonFrame
    
    -- Lista de peces del servidor actual
    local fishList = Instance.new("ScrollingFrame")
    fishList.Size = UDim2.new(1, -10, 1, -150)
    fishList.Position = UDim2.new(0, 5, 0, 145)
    fishList.BackgroundColor3 = Color3.new(0.06, 0.06, 0.1)
    fishList.BorderSizePixel = 0
    fishList.ScrollBarThickness = 4
    fishList.ScrollBarImageColor3 = Color3.new(0.13, 0.77, 0.37)
    fishList.Parent = main
    
    local fishLayout = Instance.new("UIListLayout")
    fishLayout.SortOrder = Enum.SortOrder.LayoutOrder
    fishLayout.Padding = UDim.new(0, 2)
    fishLayout.Parent = fishList
    
    -- Función para actualizar lista de peces
    local function updateFishList()
        -- Limpiar lista
        for _, child in pairs(fishList:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        local fish = scanRealFish()
        fishCountLabel.Text = string.format("Peces 10T+: %d", #fish)
        
        if #fish == 0 then
            local noFish = Instance.new("TextLabel")
            noFish.Size = UDim2.new(1, 0, 0, 40)
            noFish.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
            noFish.BorderSizePixel = 0
            noFish.Text = "No hay peces de 10T+ en este servidor"
            noFish.TextColor3 = Color3.new(0.7, 0.7, 0.7)
            noFish.TextSize = 12
            noFish.Font = Enum.Font.SourceSans
            noFish.Parent = fishList
        else
            for i, fishData in ipairs(fish) do
                local fishFrame = Instance.new("Frame")
                fishFrame.Size = UDim2.new(1, -5, 0, 35)
                fishFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
                fishFrame.BorderSizePixel = 0
                fishFrame.Parent = fishList
                
                local fishValue = Instance.new("TextLabel")
                fishValue.Size = UDim2.new(0.3, 0, 1, 0)
                fishValue.BackgroundTransparency = 1
                fishValue.Text = fishData.text
                fishValue.TextColor3 = Color3.new(1, 0.8, 0)
                fishValue.TextSize = 14
                fishValue.Font = Enum.Font.SourceSansBold
                fishValue.Parent = fishFrame
                
                local fishOwner = Instance.new("TextLabel")
                fishOwner.Size = UDim2.new(0.5, 0, 1, 0)
                fishOwner.Position = UDim2.new(0.3, 0, 0, 0)
                fishOwner.BackgroundTransparency = 1
                fishOwner.Text = fishData.owner
                fishOwner.TextColor3 = Color3.new(0.9, 0.9, 0.9)
                fishOwner.TextSize = 11
                fishOwner.Font = Enum.Font.SourceSans
                fishOwner.Parent = fishFrame
                
                local rankLabel = Instance.new("TextLabel")
                rankLabel.Size = UDim2.new(0.2, 0, 1, 0)
                rankLabel.Position = UDim2.new(0.8, 0, 0, 0)
                rankLabel.BackgroundTransparency = 1
                rankLabel.Text = "#" .. i
                rankLabel.TextColor3 = Color3.new(0.13, 0.77, 0.37)
                rankLabel.TextSize = 10
                rankLabel.Font = Enum.Font.SourceSansBold
                rankLabel.Parent = fishFrame
            end
        end
        
        fishList.CanvasSize = UDim2.new(0, 0, 0, fishLayout.AbsoluteContentSize.Y + 10)
    end
    
    -- Función para server hop aleatorio
    local function serverHop()
        hopBtn.Text = "SALTANDO..."
        hopBtn.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
        
        local servers = getServerList()
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            if randomServer.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id, LocalPlayer)
            else
                serverHop() -- Intentar con otro servidor
            end
        else
            fishCountLabel.Text = "Error: No se pudieron obtener servidores"
            hopBtn.Text = "SERVER HOP"
            hopBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.8)
        end
    end
    
    -- Conectar botones
    refreshBtn.MouseButton1Click:Connect(updateFish