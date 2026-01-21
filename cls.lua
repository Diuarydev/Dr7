-- ======================================
-- INTEGRAÇÃO WHITELIST LEVE + AUTORAID
-- ======================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- ⚙️ WHITELIST
local WHITELIST = {"clt0","teste1","clt2","clt3"}
local WHITELIST_VIP = {"Diuaryy","luaneburgesa"}

-- Verifica se está autorizado
local function estaAutorizado()
    local username = LocalPlayer.Name:lower()
    for _, nome in ipairs(WHITELIST) do
        if username == nome:lower() then return true, "normal" end
    end
    for _, nome in ipairs(WHITELIST_VIP) do
        if username == nome:lower() then return true, "vip" end
    end
    return false, nil
end

-- UI simples de acesso negado
local function mostrarAcessoNegado()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WhitelistDenied"
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,50)
    title.Position = UDim2.new(0,0,0,10)
    title.BackgroundTransparency = 1
    title.Text = "ACESSO NEGADO"
    title.TextColor3 = Color3.fromRGB(255,0,0)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1,-20,0,100)
    msg.Position = UDim2.new(0,10,0,60)
    msg.BackgroundTransparency = 1
    msg.Text = "❌ Username não autorizado\n\nSeu username: " .. LocalPlayer.Name
    msg.TextColor3 = Color3.fromRGB(200,200,200)
    msg.TextSize = 14
    msg.Font = Enum.Font.Gotham
    msg.TextWrapped = true
    msg.Parent = frame

    task.spawn(function()
        task.wait(5)
        LocalPlayer:Kick("⛔ Acesso negado - Username não autorizado")
    end)
end

-- Checa autorização
local autorizado, tipo = estaAutorizado()
if not autorizado then
    mostrarAcessoNegado()
    return
end

print("✅ Bem-vindo, "..LocalPlayer.Name.."!")
if tipo=="vip" then
    print("👑 Status: VIP")
else
    print("⭐ Status: Membro")
end

-- ======================================
-- AUTO RAID CONTÍNUO
-- ======================================

local raids = {
    {Id=1000001, RaidId=50301, MapId=50028, IsOpen=1},
    {Id=1000002, RaidId=50302, MapId=50036, IsOpen=1},
}

local autoRaidEnabled = false
local autoRaidThread

-- ====================
-- GUI
-- ====================
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRaidGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 70)
frame.Position = UDim2.new(0.8, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Botão ON/OFF
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 0, 30)
button.Position = UDim2.new(0, 5, 0, 5)
button.Text = "AutoRaid: OFF"
button.BackgroundColor3 = Color3.fromRGB(100,100,100)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Parent = frame

-- Label de status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 15)
statusLabel.Position = UDim2.new(0, 5, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
statusLabel.Text = "Desligado"
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = frame

-- ====================
-- Funções de raid
-- ====================
local function startRaid(raid)
    -- Teleporta e entra na raid
    Remotes.StartLocalPlayerTeleport:FireServer({[1]={mapId=raid.RaidId}})
    wait(1)
    Remotes.EnterCityRaidMap:FireServer(raid.Id)
    print("Raid iniciada: "..raid.RaidId)
end

-- Espera com possibilidade de cancelar (verifica OFF a cada segundo)
local function waitWithCancel(seconds)
    local elapsed = 0
    while elapsed < seconds do
        if not autoRaidEnabled then
            return false -- cancelado
        end
        wait(1)
        elapsed = elapsed + 1
    end
    return true -- terminou normalmente
end

-- Loop contínuo de AutoRaid
local function autoRaidLoop()
    while autoRaidEnabled do
        for _, raid in ipairs(raids) do
            if raid.IsOpen == 1 then
                startRaid(raid)
                print("Esperando 2 minutos para completar a raid "..raid.RaidId.."...")
                waitWithCancel(120) -- espera completar a raid
            end
        end
        wait(5) -- evita loop muito rápido
    end
end

-- ====================
-- Toggle ON/OFF
-- ====================
button.MouseButton1Click:Connect(function()
    autoRaidEnabled = not autoRaidEnabled
    button.Text = "AutoRaid: "..(autoRaidEnabled and "ON" or "OFF")
    statusLabel.Text = autoRaidEnabled and "Ligado" or "Desligado"

    if autoRaidEnabled then
        -- inicia o loop em uma thread separada
        autoRaidThread = spawn(autoRaidLoop)
    end
end)
