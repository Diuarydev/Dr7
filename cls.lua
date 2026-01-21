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
-- AUTO RAID FINAL - COM BOTÃO ON/OFF
-- ======================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- CONFIGURAÇÃO DAS RAIDS
local raids = {
    [1000001] = {
        Id = 1000001,
        MapId = 50301,
        LobbyMapId = 50028,
        Name = "Monster Siege 1 (Mundo 19)"
    },
    [1000002] = {
        Id = 1000002,
        MapId = 50302,
        LobbyMapId = 50036,
        Name = "Monster Siege 2 (Mundo 36)"
    }
}

local autoRaidEnabled = false
local emRaid = false
local raidAtual = nil

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoRaidGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 70)
frame.Position = UDim2.new(0.8, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 0, 35)
button.Position = UDim2.new(0, 5, 0, 5)
button.Text = "Auto Raid: OFF"
button.BackgroundColor3 = Color3.fromRGB(220,60,80)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.Parent = frame

Instance.new("UICorner", button).CornerRadius = UDim.new(0,8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 20)
status.Position = UDim2.new(0, 5, 0, 45)
status.BackgroundTransparency = 1
status.Text = "Aguardando..."
status.TextColor3 = Color3.fromRGB(200,200,200)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.Parent = frame

-- TELEPORTA PRO LOBBY
local function irProLobby(raid)
    Remotes.LocalPlayerTeleport:FireServer({ mapId = raid.LobbyMapId })
end

-- ENTRA NA RAID
local function entrarNaRaid(raid)
    if emRaid or not autoRaidEnabled then return end

    emRaid = true
    raidAtual = raid
    status.Text = "Entrando: "..raid.Name

    Remotes.StartLocalPlayerTeleport:FireServer({ mapId = raid.MapId })
    task.wait()
    Remotes.EnterCityRaidMap:FireServer(raid.Id)
end

-- SAI DA RAID
local function sairDaRaid()
    if not raidAtual then return end

    status.Text = "Saindo..."
    Remotes.QuitCityRaidMap:FireServer(raidAtual.Id)

    emRaid = false
    raidAtual = nil
    status.Text = "Aguardando..."
end

-- RAID COMPLETA
Remotes.ChallengeRaidsSuccess.OnClientEvent:Connect(function()
    if not autoRaidEnabled or not emRaid then return end
    task.wait(10)
    sairDaRaid()
end)

-- RAID FALHOU
Remotes.ChallengeRaidsFail.OnClientEvent:Connect(function()
    if not autoRaidEnabled or not emRaid then return end
    task.wait(10)
    sairDaRaid()
end)

-- DETECTA RAID ABERTA
Remotes.UpdateCityRaidInfo.OnClientEvent:Connect(function(data)
    if not autoRaidEnabled or emRaid then return end
    if type(data) ~= "table" then return end

    local raidId = data.id or data.Id or data.raidId
    local raid = raids[raidId]
    if not raid then return end

    if data.action == "OpenCityRaid" or data.isOpen or data.rankInfo then
        status.Text = raid.Name.." aberta!"
        irProLobby(raid)
        task.wait()
        entrarNaRaid(raid)
    end
end)

-- BOTÃO ON / OFF
button.MouseButton1Click:Connect(function()
    autoRaidEnabled = not autoRaidEnabled
    button.Text = "Auto Raid: "..(autoRaidEnabled and "ON" or "OFF")
    button.BackgroundColor3 = autoRaidEnabled
        and Color3.fromRGB(50,200,100)
        or Color3.fromRGB(220,60,80)

    status.Text = autoRaidEnabled and "Ativado!" or "Aguardando..."
end)

print("AUTO RAID FINAL COM BOTÃO CARREGADO")
