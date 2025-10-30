-- HUB DIUARYOG PROFISSIONAL v3.3 - COMPLETO
-- By DiuaryOG 💙

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local rerollRemote = remotes:FindFirstChild("RerollOrnament")
local clickRemote = remotes:FindFirstChild("PlayerClickAttack")
local rebornRemote = remotes:FindFirstChild("PlayerReborn")
local openBoxRemote = remotes:FindFirstChild("OpenAntiqueBox")
local respirationSkillRemote = remotes:FindFirstChild("RespirationSkillHarm")
local rerollHaloRemote = remotes:FindFirstChild("RerollHalo")
local exchangeHaloRemote = remotes:FindFirstChild("ExchangeHaloDrawItem")
local useOrnamentRemote = remotes:FindFirstChild("UseOrnament")
local heroSkillRemote = remotes:FindFirstChild("HeroSkillHarm")
local PotionMergeRemote = remotes:FindFirstChild("PotionMerge")

local ORNAMENT_ID = 400002
local DELAY_REROLL = 0.1
local RESPIRATION_SKILL_DELAY = 0.05
local HALO_DELAY = 0.001
local EXCHANGE_HALO_DELAY = 0.01
local KEY_PERMANENTE = "fifa"
local KEYS_TEMPORARIAS = {"error557"}

_G.AUTO_CLICK_ATIVO = false
_G.AUTO_REBORN_ATIVO = false
_G.AUTO_OPEN_ATIVO = false
_G.AUTO_RESPIRATION_SKILL_ATIVO = false
_G.AUTO_HALO_BRONZE_ATIVO = false
_G.AUTO_HALO_OURO_ATIVO = false
_G.AUTO_HALO_DIAMANTE_ATIVO = false
_G.AUTO_EXCHANGE_HALO_ATIVO = false
_G.AUTO_OCT_ATIVO = false

local ORNAMENTS = {
    DMG = { ornamentId = 410028, machineId = 400005 },
    Power = { ornamentId = 410026, machineId = 400005 },
    Lucky = { ornamentId = 410025, machineId = 400005 }
}

local itensReroll = {
    {nome="MÁSCARA", id=400001, girando=false},
    {nome="MOCHILA", id=400003, girando=false},
    {nome="MARCA", id=400002, girando=false},
    {nome="TRILHA", id=400004, girando=false},
}

local ABA_ATUAL = "Farm"
local taskRunningFlags = {}
local function setFlag(name, v) taskRunningFlags[name] = v end
local function getFlag(name) return taskRunningFlags[name] end
local detectedHeroes = {}

-- SISTEMA KEY TEMPORÁRIA
local keyStorage = "DiuaryHub_KeyExpiration"
local keyDuration = 7 * 3600

local function salvarKeyExpiracao(timestamp)
    pcall(function() writefile(keyStorage, tostring(timestamp)) end)
end

local function carregarKeyExpiracao()
    local success, data = pcall(function() return readfile(keyStorage) end)
    if success and data then return tonumber(data) end
    return nil
end

local function limparKey()
    pcall(function() delfile(keyStorage) end)
end

local function verificarKeyValida()
    local expiracao = carregarKeyExpiracao()
    if expiracao then
        local tempoAtual = os.time()
        if tempoAtual < expiracao then
            local tempoRestante = expiracao - tempoAtual
            local horasRestantes = math.floor(tempoRestante / 3600)
            local minutosRestantes = math.floor((tempoRestante % 3600) / 60)
            print("✅ Key válida! Tempo restante: " .. horasRestantes .. "h " .. minutosRestantes .. "min")
            return true
        else
            print("⏰ Key expirada! Digite uma nova key.")
            limparKey()
            return false
        end
    end
    return false
end

-- VERIFICAR KEY
local function verificarKey()
    if verificarKeyValida() then return end
    
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystemGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999999
    ScreenGui.Parent = playerGui

    local Overlay = Instance.new("Frame", ScreenGui)
    Overlay.Size = UDim2.new(1,0,1,0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Overlay.BackgroundTransparency = 0.3
    Overlay.BorderSizePixel = 0

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 400, 0, 340)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -170)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Frame.BorderSizePixel = 0

    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 16)

    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.Color = Color3.fromRGB(80, 140, 255)
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0.5

    local Header = Instance.new("Frame", Frame)
    Header.Size = UDim2.new(1,0,0,70)
    Header.BackgroundColor3 = Color3.fromRGB(25,25,35)
    Header.BorderSizePixel = 0
    
    local HeaderCorner = Instance.new("UICorner", Header)
    HeaderCorner.CornerRadius = UDim.new(0,16)

    local IconLabel = Instance.new("TextLabel", Header)
    IconLabel.Size = UDim2.new(0,60,0,60)
    IconLabel.Position = UDim2.new(0.5,-30,0,5)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = "🔐"
    IconLabel.TextSize = 40
    IconLabel.Font = Enum.Font.GothamBold

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, -40, 0, 30)
    Title.Position = UDim2.new(0, 20, 0, 80)
    Title.BackgroundTransparency = 1
    Title.Text = "SISTEMA DE AUTENTICAÇÃO"
    Title.TextColor3 = Color3.fromRGB(200, 200, 220)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold

    local SubTitle = Instance.new("TextLabel", Frame)
    SubTitle.Size = UDim2.new(1, -40, 0, 40)
    SubTitle.Position = UDim2.new(0, 20, 0, 110)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Digite sua chave de acesso para continuar\n⏰ Keys temporárias: 7 horas"
    SubTitle.TextColor3 = Color3.fromRGB(120, 120, 140)
    SubTitle.TextSize = 10
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextWrapped = true

    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(0, 340, 0, 45)
    TextBox.Position = UDim2.new(0.5, -170, 0, 165)
    TextBox.PlaceholderText = "Insira sua key..."
    TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.Gotham
    TextBox.BorderSizePixel = 0

    local TextBoxCorner = Instance.new("UICorner", TextBox)
    TextBoxCorner.CornerRadius = UDim.new(0,10)

    local TextBoxStroke = Instance.new("UIStroke", TextBox)
    TextBoxStroke.Color = Color3.fromRGB(50,50,70)
    TextBoxStroke.Thickness = 1

    local ConfirmButton = Instance.new("TextButton", Frame)
    ConfirmButton.Size = UDim2.new(0, 340, 0, 45)
    ConfirmButton.Position = UDim2.new(0.5, -170, 0, 225)
    ConfirmButton.Text = "✓ VERIFICAR"
    ConfirmButton.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
    ConfirmButton.TextColor3 = Color3.new(1, 1, 1)
    ConfirmButton.TextSize = 15
    ConfirmButton.Font = Enum.Font.GothamBold
    ConfirmButton.BorderSizePixel = 0
    ConfirmButton.AutoButtonColor = false

    local BtnCorner = Instance.new("UICorner", ConfirmButton)
    BtnCorner.CornerRadius = UDim.new(0,10)

    local StatusLabel = Instance.new("TextLabel", Frame)
    StatusLabel.Size = UDim2.new(1, -40, 0, 40)
    StatusLabel.Position = UDim2.new(0, 20, 0, 280)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.Text = ""
    StatusLabel.TextWrapped = true

    ConfirmButton.MouseEnter:Connect(function()
        TweenService:Create(ConfirmButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 160, 255)}):Play()
    end)
    ConfirmButton.MouseLeave:Connect(function()
        TweenService:Create(ConfirmButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 140, 255)}):Play()
    end)

    local keyValida = false
    ConfirmButton.MouseButton1Click:Connect(function()
        local keyInput = TextBox.Text
        if keyInput == "" then
            StatusLabel.Text = "⚠️ Por favor, digite uma key válida"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
            TextBoxStroke.Color = Color3.fromRGB(255, 80, 80)
            return
        end
        
        if keyInput == KEY_PERMANENTE then
            keyValida = true
            local expiracao = os.time() + (100 * 365 * 24 * 3600)
            salvarKeyExpiracao(expiracao)
            StatusLabel.Text = "✓ Autenticação bem-sucedida!\n♾️ Key permanente ativada!"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            ConfirmButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            ConfirmButton.Text = "✓ SUCESSO"
            TextBoxStroke.Color = Color3.fromRGB(50, 200, 100)
            task.wait(1.5)
            TweenService:Create(Frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -200, -0.5, 0)}):Play()
            TweenService:Create(Overlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            ScreenGui:Destroy()
            return
        end
        
        for _, key in pairs(KEYS_TEMPORARIAS) do
            if keyInput == key then
                keyValida = true
                local expiracao = os.time() + keyDuration
                salvarKeyExpiracao(expiracao)
                StatusLabel.Text = "✓ Autenticação bem-sucedida!\n⏰ Válida por 7 horas"
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
                ConfirmButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                ConfirmButton.Text = "✓ SUCESSO"
                TextBoxStroke.Color = Color3.fromRGB(50, 200, 100)
                task.wait(1.5)
                TweenService:Create(Frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -200, -0.5, 0)}):Play()
                TweenService:Create(Overlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                task.wait(0.3)
                ScreenGui:Destroy()
                return
            end
        end
        
        StatusLabel.Text = "✗ Key inválida! Tente novamente."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        TextBoxStroke.Color = Color3.fromRGB(255, 80, 80)
        TextBox.Text = ""
    end)
    repeat task.wait(0.1) until keyValida
end

verificarKey()

-- GUI PRINCIPAL
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DiuaryOGHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999999
screenGui.Parent = playerGui

-- Floating button reduzido para mobile
local floatingButton = Instance.new("TextButton", screenGui)
floatingButton.Size = UDim2.new(0, 60, 0, 60)
floatingButton.Position = UDim2.new(0, 20, 0.5, -30)
floatingButton.BackgroundColor3 = Color3.fromRGB(25,25,35)
floatingButton.BorderSizePixel = 0
floatingButton.Text = ""
floatingButton.AutoButtonColor = false
floatingButton.ZIndex = 99999

local floatingCorner = Instance.new("UICorner", floatingButton)
floatingCorner.CornerRadius = UDim.new(1,0)

local floatingStroke = Instance.new("UIStroke", floatingButton)
floatingStroke.Color = Color3.fromRGB(80,140,255)
floatingStroke.Thickness = 2.5
floatingStroke.Transparency = 0.3

local floatingIcon = Instance.new("TextLabel", floatingButton)
floatingIcon.Size = UDim2.new(1,0,1,0)
floatingIcon.BackgroundTransparency = 1
floatingIcon.Text = "🤓"
floatingIcon.TextColor3 = Color3.fromRGB(150,200,255)
floatingIcon.TextSize = 28
floatingIcon.Font = Enum.Font.GothamBold

-- Pulse animation
task.spawn(function()
    while task.wait() do
        TweenService:Create(floatingButton, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Size = UDim2.new(0,65,0,65)}):Play()
        task.wait(1.5)
    end
end)

-- Drag floating
do
    local dragging = false
    local dragInput, dragStart, startPos
    floatingButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = floatingButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    floatingButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            floatingButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Main hub frame reduzido para mobile (500x420)
local hubFrame = Instance.new("Frame", screenGui)
hubFrame.Size = UDim2.new(0, 500, 0, 420)
hubFrame.Position = UDim2.new(0.5, -250, 0.5, -210)
hubFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
hubFrame.BorderSizePixel = 0
hubFrame.Visible = false
hubFrame.ZIndex = 100000

local hubCorner = Instance.new("UICorner", hubFrame)
hubCorner.CornerRadius = UDim.new(0,18)

local hubStroke = Instance.new("UIStroke", hubFrame)
hubStroke.Color = Color3.fromRGB(80,140,255)
hubStroke.Thickness = 2
hubStroke.Transparency = 0.6

-- Accent line
local accentLine = Instance.new("Frame", hubFrame)
accentLine.Size = UDim2.new(1,0,0,2)
accentLine.Position = UDim2.new(0,0,0,0)
accentLine.BackgroundColor3 = Color3.fromRGB(80,140,255)
accentLine.BorderSizePixel = 0

local accentCorner = Instance.new("UICorner", accentLine)
accentCorner.CornerRadius = UDim.new(0,18)

-- Header reduzido
local header = Instance.new("Frame", hubFrame)
header.Size = UDim2.new(1,0,0,55)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = Color3.fromRGB(20,20,28)
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0,18)

local headerGradient = Instance.new("UIGradient", header)
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,20))
}
headerGradient.Rotation = 90

local logoIcon = Instance.new("TextLabel", header)
logoIcon.Size = UDim2.new(0,40,0,40)
logoIcon.Position = UDim2.new(0,15,0,7)
logoIcon.BackgroundTransparency = 1
logoIcon.Text = "🥀"
logoIcon.TextSize = 26
logoIcon.Font = Enum.Font.GothamBold

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0,250,0,25)
title.Position = UDim2.new(0,60,0,8)
title.BackgroundTransparency = 1
title.Text = "DIUARY HUB"
title.TextColor3 = Color3.fromRGB(180,220,255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local titleGradient = Instance.new("UIGradient", title)
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150,200,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80,140,255))
}

local version = Instance.new("TextLabel", header)
version.Size = UDim2.new(0,100,0,16)
version.Position = UDim2.new(0,60,0,33)
version.BackgroundTransparency = 1
version.Text = "vivian"
version.TextColor3 = Color3.fromRGB(100,120,150)
version.TextSize = 9
version.Font = Enum.Font.GothamMedium
version.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,38,0,38)
closeBtn.Position = UDim2.new(1, -48, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,55)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,100,120)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,10)

local closeStroke = Instance.new("UIStroke", closeBtn)
closeStroke.Color = Color3.fromRGB(80,80,100)
closeStroke.Thickness = 1

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,55)}):Play()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255,100,120)}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(hubFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)}):Play()
    task.wait(0.3)
    hubFrame.Visible = false
    hubFrame.Size = UDim2.new(0, 500, 0, 420)
    hubFrame.Position = UDim2.new(0.5, -250, 0.5, -210)
    floatingButton.Visible = true
end)

floatingButton.MouseButton1Click:Connect(function()
    hubFrame.Visible = true
    hubFrame.Size = UDim2.new(0,0,0,0)
    hubFrame.Position = UDim2.new(0.5,0,0.5,0)
    TweenService:Create(hubFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 420), Position = UDim2.new(0.5, -250, 0.5, -210)}):Play()
    floatingButton.Visible = false
end)

-- Sidebar reduzido
local sidebar = Instance.new("Frame", hubFrame)
sidebar.Size = UDim2.new(0,120,1,-65)
sidebar.Position = UDim2.new(0,8,0,60)
sidebar.BackgroundColor3 = Color3.fromRGB(20,20,28)
sidebar.BorderSizePixel = 0

local sidebarCorner = Instance.new("UICorner", sidebar)
sidebarCorner.CornerRadius = UDim.new(0,12)

local sidebarStroke = Instance.new("UIStroke", sidebar)
sidebarStroke.Color = Color3.fromRGB(40,40,55)
sidebarStroke.Thickness = 1

local contentArea = Instance.new("Frame", hubFrame)
contentArea.Size = UDim2.new(1, -140, 1, -73)
contentArea.Position = UDim2.new(0,135,0,63)
contentArea.BackgroundTransparency = 1

-- Drag hub
do
    local dragging = false
    local dragInput, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = hubFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            hubFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Tab button creator reduzido
local function createTabButton(text, icon, yPos)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0,105,0,42)
    btn.Position = UDim2.new(0,7,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,35)
    btn.TextColor3 = Color3.fromRGB(120,140,180)
    btn.Text = ""
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(40,40,55)
    stroke.Thickness = 1
    stroke.Transparency = 0.5

    local iconLabel = Instance.new("TextLabel", btn)
    iconLabel.Size = UDim2.new(0,28,0,28)
    iconLabel.Position = UDim2.new(0,8,0,7)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 16
    iconLabel.Font = Enum.Font.GothamBold

    local textLabel = Instance.new("TextLabel", btn)
    textLabel.Size = UDim2.new(0,60,0,42)
    textLabel.Position = UDim2.new(0,40,0,0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(120,140,180)
    textLabel.TextSize = 11
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left

    btn.MouseEnter:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(80,140,255) then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,45)}):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(80,140,255) then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25,25,35)}):Play()
        end
    end)

    return btn, iconLabel, textLabel, stroke
end

-- Create tabs - adicionada nova aba OCT
local farmTab, farmIcon, farmText, farmStroke = createTabButton("Farm","🎮",8)
local marcaTab, marcaIcon, marcaText, marcaStroke = createTabButton("Marca","🎯",56)
local skillsTab, skillsIcon, skillsText, skillsStroke = createTabButton("Skills","⚡",104)
local auraTab, auraIcon, auraText, auraStroke = createTabButton("Aura","✨",152)
local talismaTab, talismaIcon, talismaText, talismaStroke = createTabButton("Talismã","💎",200)
local fusePotionTab, fusePotionIcon, fusePotionText, fusePotionStroke = createTabButton("Potion","🧪",248)
local octTab, octIcon, octText, octStroke = createTabButton("OCT","🐙",296)

-- Create containers
local farmContainer = Instance.new("Frame", contentArea)
farmContainer.Size = UDim2.new(1,0,1,0)
farmContainer.BackgroundTransparency = 1
farmContainer.Visible = true

local marcaContainer = Instance.new("Frame", contentArea)
marcaContainer.Size = UDim2.new(1,0,1,0)
marcaContainer.BackgroundTransparency = 1
marcaContainer.Visible = false

local skillsContainer = Instance.new("Frame", contentArea)
skillsContainer.Size = UDim2.new(1,0,1,0)
skillsContainer.BackgroundTransparency = 1
skillsContainer.Visible = false

local auraContainer = Instance.new("Frame", contentArea)
auraContainer.Size = UDim2.new(1,0,1,0)
auraContainer.BackgroundTransparency = 1
auraContainer.Visible = false

local talismaContainer = Instance.new("Frame", contentArea)
talismaContainer.Size = UDim2.new(1,0,1,0)
talismaContainer.BackgroundTransparency = 1
talismaContainer.Visible = false

local fusePotionContainer = Instance.new("Frame", contentArea)
fusePotionContainer.Size = UDim2.new(1,0,1,0)
fusePotionContainer.BackgroundTransparency = 1
fusePotionContainer.Visible = false

local octContainer = Instance.new("Frame", contentArea)
octContainer.Size = UDim2.new(1,0,1,0)
octContainer.BackgroundTransparency = 1
octContainer.Visible = false

-- Switch tabs atualizado com nova aba OCT
local function switchTab(tabName)
    ABA_ATUAL = tabName
    local tabs = {
        {btn = farmTab, icon = farmIcon, text = farmText, stroke = farmStroke},
        {btn = marcaTab, icon = marcaIcon, text = marcaText, stroke = marcaStroke},
        {btn = skillsTab, icon = skillsIcon, text = skillsText, stroke = skillsStroke},
        {btn = auraTab, icon = auraIcon, text = auraText, stroke = auraStroke},
        {btn = talismaTab, icon = talismaIcon, text = talismaText, stroke = talismaStroke},
        {btn = fusePotionTab, icon = fusePotionIcon, text = fusePotionText, stroke = fusePotionStroke},
        {btn = octTab, icon = octIcon, text = octText, stroke = octStroke}
    }
    
    for _, t in ipairs(tabs) do
        TweenService:Create(t.btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25,25,35)}):Play()
        TweenService:Create(t.text, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(120,140,180)}):Play()
        t.stroke.Transparency = 0.5
    end
    
    farmContainer.Visible = false
    marcaContainer.Visible = false
    skillsContainer.Visible = false
    auraContainer.Visible = false
    talismaContainer.Visible = false
    fusePotionContainer.Visible = false
    octContainer.Visible = false

    if tabName == "Farm" then
        TweenService:Create(farmTab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,255)}):Play()
        TweenService:Create(farmText, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
        farmStroke.Transparency = 0
        farmStroke.Color = Color3.fromRGB(100,160,255)
        farmContainer.Visible = true
    elseif tabName == "Marca" then
        TweenService:Create(marcaTab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,255)}):Play()
        TweenService:Create(marcaText, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
        marcaStroke.Transparency = 0
        marcaStroke.Color = Color3.fromRGB(100,160,255)
        marcaContainer.Visible = true
    elseif tabName == "Skills" then
        TweenService:Create(skillsTab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,255)}):Play()
        TweenService:Create(skillsText, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
        skillsStroke.Transparency = 0
        skillsStroke.Color = Color3.fromRGB(100,160,255)
        skillsContainer.Visible = true
    elseif tabName == "Aura" then
        TweenService:Create(auraTab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,255)}):Play()
        TweenService:Create(auraText, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
        auraStroke.Transparency = 0
        auraStroke.Color = Color3.fromRGB(100,160,255)
        auraContainer.Visible = true
    elseif tabName == "Talismã" then
        TweenService:Create(talismaTab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,255)}):Play()
        TweenService:Create(talismaText, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
        talismaStroke.Transparency = 0
        talismaStroke.Color = Color3.fromRGB(100,160,255)
        talismaContainer.Visible = true
    elseif tabName == "FusePotion" then
        TweenService:Create(fusePotionTab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,255)}):Play()
        TweenService:Create(fusePotionText, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
        fusePotionStroke.Transparency = 0
        fusePotionStroke.Color = Color3.fromRGB(100,160,255)
        fusePotionContainer.Visible = true
    elseif tabName == "OCT" then
        TweenService:Create(octTab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,255)}):Play()
        TweenService:Create(octText, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
        octStroke.Transparency = 0
        octStroke.Color = Color3.fromRGB(100,160,255)
        octContainer.Visible = true
    end
end

farmTab.MouseButton1Click:Connect(function() switchTab("Farm") end)
marcaTab.MouseButton1Click:Connect(function() switchTab("Marca") end)
skillsTab.MouseButton1Click:Connect(function() switchTab("Skills") end)
auraTab.MouseButton1Click:Connect(function() switchTab("Aura") end)
talismaTab.MouseButton1Click:Connect(function() switchTab("Talismã") end)
fusePotionTab.MouseButton1Click:Connect(function() switchTab("FusePotion") end)
octTab.MouseButton1Click:Connect(function() switchTab("OCT") end)

-- Button creator reduzido
local function createButton(text, icon, parent, yPos)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0,345,0,45)
    btn.Position = UDim2.new(0,10,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,35)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,12)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(50,50,70)
    stroke.Thickness = 1.5

    local gradient = Instance.new("UIGradient", btn)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,30))
    }
    gradient.Rotation = 45

    local iconLabel = Instance.new("TextLabel", btn)
    iconLabel.Size = UDim2.new(0,38,0,38)
    iconLabel.Position = UDim2.new(0,8,0,3)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 20
    iconLabel.Font = Enum.Font.GothamBold

    local textLabel = Instance.new("TextLabel", btn)
    textLabel.Size = UDim2.new(0,200,0,45)
    textLabel.Position = UDim2.new(0,50,0,0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(180,200,230)
    textLabel.TextSize = 13
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left

    local status = Instance.new("TextLabel", btn)
    status.Size = UDim2.new(0,65,0,26)
    status.Position = UDim2.new(1,-75,0.5,-13)
    status.BackgroundColor3 = Color3.fromRGB(220,60,80)
    status.TextColor3 = Color3.new(1,1,1)
    status.Text = "OFF"
    status.TextSize = 11
    status.Font = Enum.Font.GothamBold
    status.BorderSizePixel = 0

    local statusCorner = Instance.new("UICorner", status)
    statusCorner.CornerRadius = UDim.new(0,7)

    local statusStroke = Instance.new("UIStroke", status)
    statusStroke.Color = Color3.fromRGB(180,40,60)
    statusStroke.Thickness = 1.5

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,50)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80,140,255)}):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25,25,35)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50,50,70)}):Play()
    end)

    return btn, status, statusStroke
end

-- ABA FARM
local clickButton, clickStatus, clickStroke = createButton("AutoClick", "🖱️", farmContainer, 8)
local rebornButton, rebornStatus, rebornStroke = createButton("AutoReborn", "🔄", farmContainer, 60)
local openButton, openStatus, openStroke = createButton("AutoOpen Baús", "📦", farmContainer, 112)

-- ABA MARCA - Sistema de reroll individual por item (removido AutoReroll antigo)
local marcaInfo = Instance.new("TextLabel", marcaContainer)
marcaInfo.Size = UDim2.new(0,345,0,40)
marcaInfo.Position = UDim2.new(0,10,0,8)
marcaInfo.BackgroundColor3 = Color3.fromRGB(25,25,35)
marcaInfo.TextColor3 = Color3.fromRGB(255,215,100)
marcaInfo.TextSize = 11
marcaInfo.Font = Enum.Font.GothamBold
marcaInfo.Text = "🎯 SISTEMA DE REROLL POR ITEM"

local marcaInfoCorner = Instance.new("UICorner", marcaInfo)
marcaInfoCorner.CornerRadius = UDim.new(0,12)

local marcaInfoStroke = Instance.new("UIStroke", marcaInfo)
marcaInfoStroke.Color = Color3.fromRGB(80,80,100)
marcaInfoStroke.Thickness = 1

-- Funções de reroll individual
local function iniciarLoop(item)
    if item.girando then return end
    item.girando = true
    spawn(function()
        while item.girando do
            local ok, err = pcall(function()
                if rerollRemote then
                    rerollRemote:InvokeServer(item.id)
                end
            end)
            if not ok then
                warn("Erro "..item.nome..":", err)
            end
            wait(0.001)
        end
    end)
end

local function pararLoop(item)
    item.girando = false
end

-- Criar botões para cada item de reroll
local yPosReroll = 55
for _, item in ipairs(itensReroll) do
    local btnIniciar = Instance.new("TextButton", marcaContainer)
    btnIniciar.Size = UDim2.new(0,165,0,38)
    btnIniciar.Position = UDim2.new(0,10,0,yPosReroll)
    btnIniciar.BackgroundColor3 = Color3.fromRGB(25,25,35)
    btnIniciar.Text = "▶ "..item.nome
    btnIniciar.TextColor3 = Color3.fromRGB(100,255,150)
    btnIniciar.Font = Enum.Font.GothamBold
    btnIniciar.TextSize = 11
    btnIniciar.BorderSizePixel = 0
    btnIniciar.AutoButtonColor = false

    local iniciarCorner = Instance.new("UICorner", btnIniciar)
    iniciarCorner.CornerRadius = UDim.new(0,10)

    local iniciarStroke = Instance.new("UIStroke", btnIniciar)
    iniciarStroke.Color = Color3.fromRGB(50,200,100)
    iniciarStroke.Thickness = 1.5

    local btnParar = Instance.new("TextButton", marcaContainer)
    btnParar.Size = UDim2.new(0,165,0,38)
    btnParar.Position = UDim2.new(0,190,0,yPosReroll)
    btnParar.BackgroundColor3 = Color3.fromRGB(25,25,35)
    btnParar.Text = "⏸ PARAR"
    btnParar.TextColor3 = Color3.fromRGB(255,100,120)
    btnParar.Font = Enum.Font.GothamBold
    btnParar.TextSize = 11
    btnParar.BorderSizePixel = 0
    btnParar.AutoButtonColor = false

    local pararCorner = Instance.new("UICorner", btnParar)
    pararCorner.CornerRadius = UDim.new(0,10)

    local pararStroke = Instance.new("UIStroke", btnParar)
    pararStroke.Color = Color3.fromRGB(220,60,80)
    pararStroke.Thickness = 1.5

    btnIniciar.MouseEnter:Connect(function()
        TweenService:Create(btnIniciar, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,50)}):Play()
    end)
    btnIniciar.MouseLeave:Connect(function()
        TweenService:Create(btnIniciar, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25,25,35)}):Play()
    end)

    btnParar.MouseEnter:Connect(function()
        TweenService:Create(btnParar, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,50)}):Play()
    end)
    btnParar.MouseLeave:Connect(function()
        TweenService:Create(btnParar, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25,25,35)}):Play()
    end)

    btnIniciar.MouseButton1Click:Connect(function() 
        iniciarLoop(item)
        print("✅ Reroll "..item.nome.." iniciado!")
    end)
    
    btnParar.MouseButton1Click:Connect(function() 
        pararLoop(item)
        print("⏸ Reroll "..item.nome.." parado!")
    end)

    yPosReroll = yPosReroll + 45
end

-- ABA SKILLS
local respirationSkillButton, respirationSkillStatus, respirationStroke = createButton("Respiration Skill", "☠️", skillsContainer, 8)

local respirationDelayLabel = Instance.new("TextLabel", skillsContainer)
respirationDelayLabel.Size = UDim2.new(0,150,0,18)
respirationDelayLabel.Position = UDim2.new(0,10,0,60)
respirationDelayLabel.BackgroundTransparency = 1
respirationDelayLabel.TextColor3 = Color3.fromRGB(150,170,200)
respirationDelayLabel.TextSize = 10
respirationDelayLabel.Font = Enum.Font.GothamBold
respirationDelayLabel.Text = "⏱️ Delay (segundos):"
respirationDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local respirationDelayInput = Instance.new("TextBox", skillsContainer)
respirationDelayInput.Size = UDim2.new(0,345,0,35)
respirationDelayInput.Position = UDim2.new(0,10,0,80)
respirationDelayInput.BackgroundColor3 = Color3.fromRGB(25,25,35)
respirationDelayInput.TextColor3 = Color3.new(1,1,1)
respirationDelayInput.PlaceholderText = "0.01 - 5.00"
respirationDelayInput.Text = tostring(RESPIRATION_SKILL_DELAY)
respirationDelayInput.ClearTextOnFocus = false
respirationDelayInput.Font = Enum.Font.GothamMedium
respirationDelayInput.TextSize = 12
respirationDelayInput.BorderSizePixel = 0

local respInputCorner = Instance.new("UICorner", respirationDelayInput)
respInputCorner.CornerRadius = UDim.new(0,10)

local respInputStroke = Instance.new("UIStroke", respirationDelayInput)
respInputStroke.Color = Color3.fromRGB(50,50,70)
respInputStroke.Thickness = 1.5

respirationDelayInput.FocusLost:Connect(function()
    local v = tonumber(respirationDelayInput.Text)
    if v then 
        RESPIRATION_SKILL_DELAY = math.clamp(v, 0.01, 5)
        respirationDelayInput.Text = string.format("%.2f", RESPIRATION_SKILL_DELAY)
    else 
        respirationDelayInput.Text = string.format("%.2f", RESPIRATION_SKILL_DELAY)
    end
end)

-- DMG (CAPTURA APENAS SEUS PETS)
do
    local SKILL_ID = 200616
    local HARM_INDEX = 15
    local autoFireEnabled = false
    local autoFireRunning = false
    local delayValue = 0.0001
    local MAX_HEROES = 5
    local detectionOrder = {}

    local dmgButton, dmgStatus, dmgStroke = createButton("DMG", "⚔️", skillsContainer, 125)

    local dmgDelayLabel = Instance.new("TextLabel", skillsContainer)
    dmgDelayLabel.Size = UDim2.new(0,150,0,18)
    dmgDelayLabel.Position = UDim2.new(0,10,0,177)
    dmgDelayLabel.BackgroundTransparency = 1
    dmgDelayLabel.TextColor3 = Color3.fromRGB(150,170,200)
    dmgDelayLabel.TextSize = 10
    dmgDelayLabel.Font = Enum.Font.GothamBold
    dmgDelayLabel.Text = "⏱️ DMG Delay:"
    dmgDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

    local dmgDelayBox = Instance.new("TextBox", skillsContainer)
    dmgDelayBox.Size = UDim2.new(0,345,0,35)
    dmgDelayBox.Position = UDim2.new(0,10,0,197)
    dmgDelayBox.BackgroundColor3 = Color3.fromRGB(25,25,35)
    dmgDelayBox.Text = tostring(delayValue)
    dmgDelayBox.PlaceholderText = "0.0001 - 5.00"
    dmgDelayBox.ClearTextOnFocus = false
    dmgDelayBox.Font = Enum.Font.GothamMedium
    dmgDelayBox.TextSize = 12
    dmgDelayBox.TextColor3 = Color3.new(1,1,1)
    dmgDelayBox.BorderSizePixel = 0

    local dmgInputCorner = Instance.new("UICorner", dmgDelayBox)
    dmgInputCorner.CornerRadius = UDim.new(0,10)

    local dmgInputStroke = Instance.new("UIStroke", dmgDelayBox)
    dmgInputStroke.Color = Color3.fromRGB(50,50,70)
    dmgInputStroke.Thickness = 1.5

    local function clampDelay()
        local v = tonumber(dmgDelayBox.Text) or 0.0001
        v = math.clamp(v, 0.0001, 5)
        dmgDelayBox.Text = string.format("%.4f", v)
        return v
    end

    local function manageHeroLimit(newGuid)
        local count = 0
        for _ in pairs(detectedHeroes) do count = count + 1 end
        
        if count >= MAX_HEROES then
            local oldestGuid = detectionOrder[1]
            if oldestGuid then
                detectedHeroes[oldestGuid] = nil
                table.remove(detectionOrder, 1)
                print("🔄 DMG: Pet antigo removido, novo pet adicionado!")
            end
        end
        
        detectedHeroes[newGuid] = tick()
        table.insert(detectionOrder, newGuid)
        
        local count2 = 0
        for _ in pairs(detectedHeroes) do count2 = count2 + 1 end
        print("✅ DMG: Pet detectado (" .. count2 .. "/5) - GUID: " .. string.sub(newGuid, 1, 8) .. "...")
    end

    -- Hook que intercepta APENAS quando VOCÊ usa o remote
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            -- Captura quando VOCÊ usa a skill do pet
            if self == heroSkillRemote and method == "FireServer" then
                local data = args[1]
                if type(data) == "table" and data.heroGuid then
                    local guid = data.heroGuid
                    
                    -- Se não existe ainda, adiciona
                    if not detectedHeroes[guid] then
                        manageHeroLimit(guid)
                    else
                        -- Atualiza timestamp
                        detectedHeroes[guid] = tick()
                    end
                end
            end
            
            return oldNamecall(self, ...)
        end)
        
        print("🔍 DMG: Sistema ativo! Use seus pets para detectá-los.")
    end)

    local function autoFireLoop()
        if autoFireRunning then return end
        autoFireRunning = true
        
        while autoFireEnabled do
            local delayTime = clampDelay()
            
            -- Converte para lista
            local heroList = {}
            for guid, _ in pairs(detectedHeroes) do
                table.insert(heroList, guid)
            end
            
            -- Envia para todos os pets detectados
            for _, guid in ipairs(heroList) do
                pcall(function()
                    if heroSkillRemote then
                        heroSkillRemote:FireServer({
                            heroGuid = guid,
                            skillId = SKILL_ID,
                            harmIndex = HARM_INDEX,
                            isSkill = true
                        })
                    end
                end)
            end
            
            task.wait(delayTime)
        end
        autoFireRunning = false
    end

    dmgButton.MouseButton1Click:Connect(function()
        autoFireEnabled = not autoFireEnabled
        dmgStatus.Text = autoFireEnabled and "ON" or "OFF"
        if autoFireEnabled then
            TweenService:Create(dmgStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
            TweenService:Create(dmgStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40,180,80)}):Play()
            print("⚔️ DMG ativado!")
            
            local count = 0
            for _ in pairs(detectedHeroes) do count = count + 1 end
            if count == 0 then
                print("⚠️ Use seus pets para detectá-los automaticamente!")
            else
                print("✅ " .. count .. " pet(s) detectado(s)!")
            end
            
            task.spawn(autoFireLoop)
        else
            TweenService:Create(dmgStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
            TweenService:Create(dmgStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180,40,60)}):Play()
            print("⚔️ DMG desativado!")
        end
    end)
end

-- ABA AURA
local haloInfo = Instance.new("TextLabel", auraContainer)
haloInfo.Size = UDim2.new(0,345,0,40)
haloInfo.Position = UDim2.new(0,10,0,8)
haloInfo.BackgroundColor3 = Color3.fromRGB(25,25,35)
haloInfo.TextColor3 = Color3.fromRGB(255,215,100)
haloInfo.TextSize = 12
haloInfo.Font = Enum.Font.GothamBold
haloInfo.Text = "✨ SISTEMA DE HALOS PREMIUM"

local haloCorner = Instance.new("UICorner", haloInfo)
haloCorner.CornerRadius = UDim.new(0,12)

local haloStroke = Instance.new("UIStroke", haloInfo)
haloStroke.Color = Color3.fromRGB(80,80,100)
haloStroke.Thickness = 1.5

local bronzeButton, bronzeStatus, bronzeStroke = createButton("Reroll Bronze", "🥉", auraContainer, 55)
local ouroButton, ouroStatus, ouroStroke = createButton("Reroll Ouro", "🥇", auraContainer, 107)
local diamanteButton, diamanteStatus, diamanteStroke = createButton("Reroll Diamante", "💎", auraContainer, 159)
local exchangeButton, exchangeStatus, exchangeStroke = createButton("Exchange Halo (Diamante)", "🎁", auraContainer, 211)

local exchangeDelayLabel = Instance.new("TextLabel", auraContainer)
exchangeDelayLabel.Size = UDim2.new(0,150,0,18)
exchangeDelayLabel.Position = UDim2.new(0,10,0,263)
exchangeDelayLabel.BackgroundTransparency = 1
exchangeDelayLabel.TextColor3 = Color3.fromRGB(150,170,200)
exchangeDelayLabel.TextSize = 10
exchangeDelayLabel.Font = Enum.Font.GothamBold
exchangeDelayLabel.Text = "⏱️ Exchange Delay:"
exchangeDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local exchangeDelayInput = Instance.new("TextBox", auraContainer)
exchangeDelayInput.Size = UDim2.new(0,345,0,35)
exchangeDelayInput.Position = UDim2.new(0,10,0,283)
exchangeDelayInput.BackgroundColor3 = Color3.fromRGB(25,25,35)
exchangeDelayInput.TextColor3 = Color3.new(1,1,1)
exchangeDelayInput.PlaceholderText = "0.01 - 0.51"
exchangeDelayInput.Text = string.format("%.2f", EXCHANGE_HALO_DELAY)
exchangeDelayInput.ClearTextOnFocus = false
exchangeDelayInput.Font = Enum.Font.GothamMedium
exchangeDelayInput.TextSize = 12
exchangeDelayInput.BorderSizePixel = 0

local exchInputCorner = Instance.new("UICorner", exchangeDelayInput)
exchInputCorner.CornerRadius = UDim.new(0,10)

local exchInputStroke = Instance.new("UIStroke", exchangeDelayInput)
exchInputStroke.Color = Color3.fromRGB(50,50,70)
exchInputStroke.Thickness = 1.5

exchangeDelayInput.FocusLost:Connect(function()
    local v = tonumber(exchangeDelayInput.Text)
    if v then 
        EXCHANGE_HALO_DELAY = math.clamp(v, 0.01, 0.51)
        exchangeDelayInput.Text = string.format("%.2f", EXCHANGE_HALO_DELAY)
    else 
        exchangeDelayInput.Text = string.format("%.2f", EXCHANGE_HALO_DELAY)
    end
end)

-- ABA TALISMÃ
local talismaInfo = Instance.new("TextLabel", talismaContainer)
talismaInfo.Size = UDim2.new(0,345,0,50)
talismaInfo.Position = UDim2.new(0,10,0,8)
talismaInfo.BackgroundColor3 = Color3.fromRGB(25,25,35)
talismaInfo.TextColor3 = Color3.fromRGB(255,215,100)
talismaInfo.TextSize = 11
talismaInfo.Font = Enum.Font.GothamBold
talismaInfo.Text = "💎 SISTEMA DE ORNAMENTOS\n\nSelecione um ornamento e clique em EQUIPAR"
talismaInfo.TextWrapped = true

local talismaInfoCorner = Instance.new("UICorner", talismaInfo)
talismaInfoCorner.CornerRadius = UDim.new(0,12)

local talismaInfoStroke = Instance.new("UIStroke", talismaInfo)
talismaInfoStroke.Color = Color3.fromRGB(80,80,100)
talismaInfoStroke.Thickness = 1.5

local ornamentButtons = {}
do
    local y = 65
    for name, cfg in pairs(ORNAMENTS) do
        local btn = Instance.new("TextButton", talismaContainer)
        btn.Size = UDim2.new(0,345,0,42)
        btn.Position = UDim2.new(0,10,0,y)
        btn.BackgroundColor3 = Color3.fromRGB(25,25,35)
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0,12)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(50,50,70)
        stroke.Thickness = 1.5

        local icon = Instance.new("TextLabel", btn)
        icon.Size = UDim2.new(0,35,0,35)
        icon.Position = UDim2.new(0,8,0,3)
        icon.BackgroundTransparency = 1
        icon.Text = "💎"
        icon.TextSize = 18
        icon.Font = Enum.Font.GothamBold

        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(0,280,0,42)
        label.Position = UDim2.new(0,50,0,0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(180,200,230)
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left

        btn.MouseEnter:Connect(function()
            if btn.BackgroundColor3 ~= Color3.fromRGB(80,140,255) then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,50)}):Play()
            end
        end)

        btn.MouseLeave:Connect(function()
            if btn.BackgroundColor3 ~= Color3.fromRGB(80,140,255) then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25,25,35)}):Play()
            end
        end)

        ornamentButtons[name] = { button = btn, stroke = stroke, cfg = cfg, label = label }
        y = y + 50
    end
end

local equipButton = Instance.new("TextButton", talismaContainer)
equipButton.Size = UDim2.new(0,345,0,45)
equipButton.Position = UDim2.new(0,10,0,220)
equipButton.BackgroundColor3 = Color3.fromRGB(80,140,255)
equipButton.TextColor3 = Color3.new(1,1,1)
equipButton.Text = "⚡ EQUIPAR SELECIONADO"
equipButton.Font = Enum.Font.GothamBold
equipButton.TextSize = 14
equipButton.BorderSizePixel = 0
equipButton.AutoButtonColor = false

local equipCorner = Instance.new("UICorner", equipButton)
equipCorner.CornerRadius = UDim.new(0,12)

local equipStroke = Instance.new("UIStroke", equipButton)
equipStroke.Color = Color3.fromRGB(100,160,255)
equipStroke.Thickness = 2

equipButton.MouseEnter:Connect(function()
    TweenService:Create(equipButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100,160,255)}):Play()
end)

equipButton.MouseLeave:Connect(function()
    TweenService:Create(equipButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,255)}):Play()
end)

local talismaDesc = Instance.new("TextLabel", talismaContainer)
talismaDesc.Size = UDim2.new(0,345,0,45)
talismaDesc.Position = UDim2.new(0,10,0,272)
talismaDesc.BackgroundTransparency = 1
talismaDesc.TextColor3 = Color3.fromRGB(150,170,200)
talismaDesc.Font = Enum.Font.GothamMedium
talismaDesc.TextSize = 10
talismaDesc.Text = "Selecione um ornamento acima e clique em EQUIPAR\n💎 DMG = Dano | ⚡ Power = Poder | 🍀 Lucky = Sorte"
talismaDesc.TextWrapped = true

local ornamentSelecionado = nil
for name, data in pairs(ornamentButtons) do
    data.button.MouseButton1Click:Connect(function()
        for n, d in pairs(ornamentButtons) do
            TweenService:Create(d.button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25,25,35)}):Play()
            d.stroke.Color = Color3.fromRGB(50,50,70)
            TweenService:Create(d.label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180,200,230)}):Play()
        end
        TweenService:Create(data.button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,255)}):Play()
        data.stroke.Color = Color3.fromRGB(100,160,255)
        TweenService:Create(data.label, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
        ornamentSelecionado = name
        talismaDesc.Text = "✅ " .. name .. " selecionado! Clique em EQUIPAR para usar."
        talismaDesc.TextColor3 = Color3.fromRGB(100,255,150)
    end)
end

equipButton.MouseButton1Click:Connect(function()
    if not ornamentSelecionado then
        talismaDesc.Text = "⚠️ Selecione um ornamento primeiro!"
        talismaDesc.TextColor3 = Color3.fromRGB(255,120,120)
        return
    end
    local cfg = ORNAMENTS[ornamentSelecionado]
    pcall(function()
        if useOrnamentRemote then
            useOrnamentRemote:InvokeServer({
                ornamentId = cfg.ornamentId,
                machineId = cfg.machineId,
                isEquip = true
            })
        end
    end)
    talismaDesc.Text = "✅ " .. ornamentSelecionado .. " equipado com sucesso!"
    talismaDesc.TextColor3 = Color3.fromRGB(100,255,150)
end)

-- ABA FUSEPOTION - Sistema de fusão de poções
local fusePotionInfo = Instance.new("TextLabel", fusePotionContainer)
fusePotionInfo.Size = UDim2.new(0,345,0,45)
fusePotionInfo.Position = UDim2.new(0,10,0,8)
fusePotionInfo.BackgroundColor3 = Color3.fromRGB(25,25,35)
fusePotionInfo.TextColor3 = Color3.fromRGB(255,215,100)
fusePotionInfo.TextSize = 11
fusePotionInfo.Font = Enum.Font.GothamBold
fusePotionInfo.Text = "🧪 SISTEMA DE FUSÃO DE POÇÕES\n\nClique nos botões para fundir poções"
fusePotionInfo.TextWrapped = true

local fusePotionInfoCorner = Instance.new("UICorner", fusePotionInfo)
fusePotionInfoCorner.CornerRadius = UDim.new(0,12)

local fusePotionInfoStroke = Instance.new("UIStroke", fusePotionInfo)
fusePotionInfoStroke.Color = Color3.fromRGB(80,80,100)
fusePotionInfoStroke.Thickness = 1

-- Funções de fusão de poções
local function mergePotions(ids, count)
    for _, id in ipairs(ids) do
        local args = {
            {id = id, count = count or 5}
        }
        local ok, err = pcall(function()
            if PotionMergeRemote then
                PotionMergeRemote:InvokeServer(unpack(args))
            end
        end)
        if not ok then
            warn("Erro ao fundir poção ID "..id..":", err)
        end
    end
end

local function mergeSorte()
    mergePotions({10050, 10307}, 5)
    print("🍀 Poções de Sorte fundidas!")
end

local function mergePoder()
    mergePotions({10052, 10309}, 5)
    print("⚡ Poções de Poder fundidas!")
end

local function mergeDmg()
    mergePotions({10051, 10308}, 5)
    print("⚔️ Poções de DMG fundidas!")
end

local function mergeGold()
    mergePotions({10053, 10310}, 5)
    print("💰 Poções de Gold fundidas!")
end

-- Criar botões de fusão de poções
local potionButtons = {
    {name = "SORTE", icon = "🍀", callback = mergeSorte, yPos = 60},
    {name = "PODER", icon = "⚡", callback = mergePoder, yPos = 112},
    {name = "DMG", icon = "⚔️", callback = mergeDmg, yPos = 164},
    {name = "GOLD", icon = "💰", callback = mergeGold, yPos = 216}
}

for _, potionData in ipairs(potionButtons) do
    local btn = Instance.new("TextButton", fusePotionContainer)
    btn.Size = UDim2.new(0,345,0,45)
    btn.Position = UDim2.new(0,10,0,potionData.yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,35)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,12)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(50,50,70)
    stroke.Thickness = 1.5

    local icon = Instance.new("TextLabel", btn)
    icon.Size = UDim2.new(0,38,0,38)
    icon.Position = UDim2.new(0,8,0,3)
    icon.BackgroundTransparency = 1
    icon.Text = potionData.icon
    icon.TextSize = 20
    icon.Font = Enum.Font.GothamBold

    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(0,280,0,45)
    label.Position = UDim2.new(0,50,0,0)
    label.BackgroundTransparency = 1
    label.Text = "FUNDIR " .. potionData.name
    label.TextColor3 = Color3.fromRGB(180,200,230)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,50)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80,140,255)}):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25,25,35)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50,50,70)}):Play()
    end)

    btn.MouseButton1Click:Connect(potionData.callback)
end

-- ============================================
-- ABA OCT - AUTO FARM OCTOPUS
-- ============================================

local octInfo = Instance.new("TextLabel", octContainer)
octInfo.Size = UDim2.new(0,345,0,45)
octInfo.Position = UDim2.new(0,10,0,8)
octInfo.BackgroundColor3 = Color3.fromRGB(25,25,35)
octInfo.TextColor3 = Color3.fromRGB(255,215,100)
octInfo.TextSize = 11
octInfo.Font = Enum.Font.GothamBold
octInfo.Text = "🐙 AUTO FARM OCTOPUS\n\nPuxa e ataca Octopus automaticamente"
octInfo.TextWrapped = true

local octInfoCorner = Instance.new("UICorner", octInfo)
octInfoCorner.CornerRadius = UDim.new(0,12)

local octInfoStroke = Instance.new("UIStroke", octInfo)
octInfoStroke.Color = Color3.fromRGB(80,80,100)
octInfoStroke.Thickness = 1.5

-- Variáveis OCT
local octopusGUIDs = {}
local attackSpeedOct = 0.001
local loopSpeedOct = 0.05

-- Funções OCT
local function findOctopusGUID(octopus)
    for _, descendant in pairs(octopus:GetDescendants()) do
        if descendant:IsA("StringValue") then
            local value = descendant.Value
            if type(value) == "string" and value:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") then
                return value
            end
        end
    end
    for attrName, attrValue in pairs(octopus:GetAttributes()) do
        if type(attrValue) == "string" and attrValue:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") then
            return attrValue
        end
    end
    return nil
end

local function updateOctopusGUIDs()
    local enemiesFolder = Workspace:FindFirstChild("Enemys")
    if not enemiesFolder then return end
    for _, npc in pairs(enemiesFolder:GetChildren()) do
        if npc:IsA("Model") and npc.Name:lower() == "octopus" then
            local guid = findOctopusGUID(npc)
            if guid then
                octopusGUIDs[npc] = guid
            end
        end
    end
end

local function getAllOctopus()
    local enemiesFolder = Workspace:FindFirstChild("Enemys")
    if not enemiesFolder then return {} end
    local octopusList = {}
    for _, npc in pairs(enemiesFolder:GetChildren()) do
        if npc:IsA("Model") and npc.Name:lower() == "octopus" and npc:FindFirstChild("HumanoidRootPart") then
            table.insert(octopusList, npc)
        end
    end
    return octopusList
end

local function isAlive(octopus)
    local humanoid = octopus:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function freezeOctopus(octopus)
    pcall(function()
        local hrp = octopus:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                hrp.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -15)
            end
        end
    end)
end

local function attackOctopus(octopus)
    task.spawn(function()
        pcall(function()
            local guid = findOctopusGUID(octopus) or octopusGUIDs[octopus]
            if guid then
                local args = {{attackEnemyGUID = guid}}
                task.spawn(function()
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetAutoAttackRangeAddition"):InvokeServer()
                    end)
                end)
                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerClickAttack"):FireServer(unpack(args))
            end
        end)
    end)
end

local function monitorNewOctopus()
    local enemiesFolder = Workspace:WaitForChild("Enemys", 10)
    if not enemiesFolder then return end
    enemiesFolder.ChildAdded:Connect(function(child)
        if child:IsA("Model") and child.Name:lower() == "octopus" then
            task.wait(0.05)
            local guid = findOctopusGUID(child)
            if guid then
                octopusGUIDs[child] = guid
            end
        end
    end)
end

monitorNewOctopus()

-- Botão OCT
local octButton, octStatus, octButtonStroke = createButton("Auto Farm", "🐙", octContainer, 60)

-- Labels OCT
local octAttackLabel = Instance.new("TextLabel", octContainer)
octAttackLabel.Size = UDim2.new(1, -20, 0, 18)
octAttackLabel.Position = UDim2.new(0, 10, 0, 112)
octAttackLabel.BackgroundTransparency = 1
octAttackLabel.TextColor3 = Color3.fromRGB(150,170,200)
octAttackLabel.Text = "⚔️ Vel. Ataque: 0.001s"
octAttackLabel.TextSize = 10
octAttackLabel.Font = Enum.Font.GothamBold
octAttackLabel.TextXAlignment = Enum.TextXAlignment.Left

local octAttackSlider = Instance.new("Frame", octContainer)
octAttackSlider.Size = UDim2.new(0,345,0,8)
octAttackSlider.Position = UDim2.new(0,10,0,135)
octAttackSlider.BackgroundColor3 = Color3.fromRGB(50,50,55)
octAttackSlider.BorderSizePixel = 0

local octAttackCorner = Instance.new("UICorner", octAttackSlider)
octAttackCorner.CornerRadius = UDim.new(0,4)

local octAttackBtn = Instance.new("TextButton", octAttackSlider)
octAttackBtn.Size = UDim2.new(0,20,0,20)
octAttackBtn.Position = UDim2.new(0,0,0.5,-10)
octAttackBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)
octAttackBtn.Text = ""
octAttackBtn.BorderSizePixel = 0

local octAttackBtnCorner = Instance.new("UICorner", octAttackBtn)
octAttackBtnCorner.CornerRadius = UDim.new(1,0)

local octLoopLabel = Instance.new("TextLabel", octContainer)
octLoopLabel.Size = UDim2.new(1, -20, 0, 18)
octLoopLabel.Position = UDim2.new(0, 10, 0, 165)
octLoopLabel.BackgroundTransparency = 1
octLoopLabel.TextColor3 = Color3.fromRGB(150,170,200)
octLoopLabel.Text = "🔄 Vel. Loop: 0.050s"
octLoopLabel.TextSize = 10
octLoopLabel.Font = Enum.Font.GothamBold
octLoopLabel.TextXAlignment = Enum.TextXAlignment.Left

local octLoopSlider = Instance.new("Frame", octContainer)
octLoopSlider.Size = UDim2.new(0,345,0,8)
octLoopSlider.Position = UDim2.new(0,10,0,188)
octLoopSlider.BackgroundColor3 = Color3.fromRGB(50,50,55)
octLoopSlider.BorderSizePixel = 0

local octLoopCorner = Instance.new("UICorner", octLoopSlider)
octLoopCorner.CornerRadius = UDim.new(0,4)

local octLoopBtn = Instance.new("TextButton", octLoopSlider)
octLoopBtn.Size = UDim2.new(0,20,0,20)
octLoopBtn.Position = UDim2.new(0.05,-10,0.5,-10)
octLoopBtn.BackgroundColor3 = Color3.fromRGB(100,200,255)
octLoopBtn.Text = ""
octLoopBtn.BorderSizePixel = 0

local octLoopBtnCorner = Instance.new("UICorner", octLoopBtn)
octLoopBtnCorner.CornerRadius = UDim.new(1,0)

local octPerfLabel = Instance.new("TextLabel", octContainer)
octPerfLabel.Size = UDim2.new(1, -20, 0, 15)
octPerfLabel.Position = UDim2.new(0, 10, 0, 210)
octPerfLabel.BackgroundTransparency = 1
octPerfLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
octPerfLabel.Text = "💚 Performance: OK"
octPerfLabel.Font = Enum.Font.GothamMedium
octPerfLabel.TextSize = 10
octPerfLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Sliders OCT
local draggingOctAttack = false
local draggingOctLoop = false

octAttackBtn.MouseButton1Down:Connect(function() draggingOctAttack = true end)
octLoopBtn.MouseButton1Down:Connect(function() draggingOctLoop = true end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingOctAttack = false
        draggingOctLoop = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if draggingOctAttack then
        local mouse = LocalPlayer:GetMouse()
        local relativeX = math.clamp(mouse.X - octAttackSlider.AbsolutePosition.X, 0, octAttackSlider.AbsoluteSize.X)
        local percentage = relativeX / octAttackSlider.AbsoluteSize.X
        octAttackBtn.Position = UDim2.new(percentage, -10, 0.5, -10)
        attackSpeedOct = 0.001 + (percentage * 0.999)
        octAttackLabel.Text = string.format("⚔️ Vel. Ataque: %.3fs", attackSpeedOct)
        if attackSpeedOct < 0.01 then
            octPerfLabel.Text = "⚠️ Performance: Muito Rápido!"
            octPerfLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            octPerfLabel.Text = "💚 Performance: OK"
            octPerfLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end
    if draggingOctLoop then
        local mouse = LocalPlayer:GetMouse()
        local relativeX = math.clamp(mouse.X - octLoopSlider.AbsolutePosition.X, 0, octLoopSlider.AbsoluteSize.X)
        local percentage = relativeX / octLoopSlider.AbsoluteSize.X
        octLoopBtn.Position = UDim2.new(percentage, -10, 0.5, -10)
        loopSpeedOct = 0.01 + (percentage * 0.99)
        octLoopLabel.Text = string.format("🔄 Vel. Loop: %.3fs", loopSpeedOct)
    end
end)

-- Auto Farm OCT
local function autoOctopus()
    if getFlag("autoOct") then return end
    setFlag("autoOct", true)
    while _G.AUTO_OCT_ATIVO do
        updateOctopusGUIDs()
        local octopusList = getAllOctopus()
        for _, npc in pairs(octopusList) do
            if isAlive(npc) then
                freezeOctopus(npc)
            end
        end
        for _, npc in pairs(octopusList) do
            if not _G.AUTO_OCT_ATIVO then break end
            if isAlive(npc) then
                attackOctopus(npc)
                task.wait(attackSpeedOct)
            end
        end
        task.wait(loopSpeedOct)
    end
    for _, npc in pairs(getAllOctopus()) do
        pcall(function()
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Anchored = false end
        end)
    end
    setFlag("autoOct", false)
end

octButton.MouseButton1Click:Connect(function()
    _G.AUTO_OCT_ATIVO = not _G.AUTO_OCT_ATIVO
    octStatus.Text = _G.AUTO_OCT_ATIVO and "ON" or "OFF"
    if _G.AUTO_OCT_ATIVO then
        TweenService:Create(octStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
        TweenService:Create(octButtonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40,180,80)}):Play()
        print("🐙 Auto Farm Octopus ativado!")
        task.spawn(autoOctopus)
    else
        TweenService:Create(octStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
        TweenService:Create(octButtonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180,40,60)}):Play()
        print("🐙 Auto Farm Octopus desativado!")
    end
end)

task.wait(0.5)
updateOctopusGUIDs()

-- FUNÇÕES DE AUTO
local function autoClick()
    if getFlag("autoClick") then return end
    setFlag("autoClick", true)
    while _G.AUTO_CLICK_ATIVO do
        pcall(function()
            if clickRemote then clickRemote:FireServer({}) end
        end)
        task.wait(0.0001)
    end
    setFlag("autoClick", false)
end

local function autoReborn()
    if getFlag("autoReborn") then return end
    setFlag("autoReborn", true)
    while _G.AUTO_REBORN_ATIVO do
        pcall(function() if rebornRemote then rebornRemote:FireServer() end end)
        task.wait(0.01)
    end
    setFlag("autoReborn", false)
end

local function autoOpenBaus()
    if getFlag("autoOpen") then return end
    setFlag("autoOpen", true)
    local baus = {820001,820002,820003,820004,820005}
    while _G.AUTO_OPEN_ATIVO do
        for _, id in ipairs(baus) do
            pcall(function() if openBoxRemote then openBoxRemote:FireServer(id) end end)
            task.wait(0.0001)
        end
    end
    setFlag("autoOpen", false)
end

local function autoRespirationSkill()
    if getFlag("autoRespiration") then return end
    setFlag("autoRespiration", true)
    while _G.AUTO_RESPIRATION_SKILL_ATIVO do
        for i = 1,5 do
            pcall(function()
                if respirationSkillRemote then
                    respirationSkillRemote:FireServer({
                        harmIndex = i,
                        skillType = 2,
                        skillGemKey = "9_2",
                        skillId = 200401
                    })
                end
            end)
        end
        task.wait(RESPIRATION_SKILL_DELAY)
    end
    setFlag("autoRespiration", false)
end

local function autoHaloBronze()
    if getFlag("autoHaloBronze") then return end
    setFlag("autoHaloBronze", true)
    while _G.AUTO_HALO_BRONZE_ATIVO do
        pcall(function() if rerollHaloRemote then rerollHaloRemote:InvokeServer(1) end end)
        task.wait(0.0001)
    end
    setFlag("autoHaloBronze", false)
end

local function autoHaloOuro()
    if getFlag("autoHaloOuro") then return end
    setFlag("autoHaloOuro", true)
    while _G.AUTO_HALO_OURO_ATIVO do
        pcall(function() if rerollHaloRemote then rerollHaloRemote:InvokeServer(2) end end)
        task.wait(0.0001)
    end
    setFlag("autoHaloOuro", false)
end

local function autoHaloDiamante()
    if getFlag("autoHaloDiamante") then return end
    setFlag("autoHaloDiamante", true)
    while _G.AUTO_HALO_DIAMANTE_ATIVO do
        pcall(function() if rerollHaloRemote then rerollHaloRemote:InvokeServer(3) end end)
        task.wait(0.0001)
    end
    setFlag("autoHaloDiamante", false)
end

local function autoExchangeHalo()
    if getFlag("autoExchangeHalo") then return end
    setFlag("autoExchangeHalo", true)
    while _G.AUTO_EXCHANGE_HALO_ATIVO do
        pcall(function()
            if exchangeHaloRemote then
                exchangeHaloRemote:InvokeServer({ haloType = 3, count = 1 })
            end
        end)
        task.wait(0.0001)
    end
    setFlag("autoExchangeHalo", false)
end

-- TOGGLES COM ANIMAÇÕES
clickButton.MouseButton1Click:Connect(function()
    _G.AUTO_CLICK_ATIVO = not _G.AUTO_CLICK_ATIVO
    clickStatus.Text = _G.AUTO_CLICK_ATIVO and "ON" or "OFF"
    if _G.AUTO_CLICK_ATIVO then
        TweenService:Create(clickStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
        TweenService:Create(clickStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40,180,80)}):Play()
        task.spawn(autoClick)
    else
        TweenService:Create(clickStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
        TweenService:Create(clickStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180,40,60)}):Play()
    end
end)

rebornButton.MouseButton1Click:Connect(function()
    _G.AUTO_REBORN_ATIVO = not _G.AUTO_REBORN_ATIVO
    rebornStatus.Text = _G.AUTO_REBORN_ATIVO and "ON" or "OFF"
    if _G.AUTO_REBORN_ATIVO then
        TweenService:Create(rebornStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
        TweenService:Create(rebornStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40,180,80)}):Play()
        task.spawn(autoReborn)
    else
        TweenService:Create(rebornStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
        TweenService:Create(rebornStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180,40,60)}):Play()
    end
end)

openButton.MouseButton1Click:Connect(function()
    _G.AUTO_OPEN_ATIVO = not _G.AUTO_OPEN_ATIVO
    openStatus.Text = _G.AUTO_OPEN_ATIVO and "ON" or "OFF"
    if _G.AUTO_OPEN_ATIVO then
        TweenService:Create(openStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
        TweenService:Create(openStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40,180,80)}):Play()
        task.spawn(autoOpenBaus)
    else
        TweenService:Create(openStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
        TweenService:Create(openStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180,40,60)}):Play()
    end
end)

respirationSkillButton.MouseButton1Click:Connect(function()
    _G.AUTO_RESPIRATION_SKILL_ATIVO = not _G.AUTO_RESPIRATION_SKILL_ATIVO
    respirationSkillStatus.Text = _G.AUTO_RESPIRATION_SKILL_ATIVO and "ON" or "OFF"
    if _G.AUTO_RESPIRATION_SKILL_ATIVO then
        TweenService:Create(respirationSkillStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
        TweenService:Create(respirationStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40,180,80)}):Play()
        task.spawn(autoRespirationSkill)
    else
        TweenService:Create(respirationSkillStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
        TweenService:Create(respirationStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180,40,60)}):Play()
    end
end)

bronzeButton.MouseButton1Click:Connect(function()
    _G.AUTO_HALO_BRONZE_ATIVO = not _G.AUTO_HALO_BRONZE_ATIVO
    bronzeStatus.Text = _G.AUTO_HALO_BRONZE_ATIVO and "ON" or "OFF"
    if _G.AUTO_HALO_BRONZE_ATIVO then
        TweenService:Create(bronzeStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
        TweenService:Create(bronzeStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40,180,80)}):Play()
        task.spawn(autoHaloBronze)
    else
        TweenService:Create(bronzeStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
        TweenService:Create(bronzeStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180,40,60)}):Play()
    end
end)

ouroButton.MouseButton1Click:Connect(function()
    _G.AUTO_HALO_OURO_ATIVO = not _G.AUTO_HALO_OURO_ATIVO
    ouroStatus.Text = _G.AUTO_HALO_OURO_ATIVO and "ON" or "OFF"
    if _G.AUTO_HALO_OURO_ATIVO then
        TweenService:Create(ouroStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
        TweenService:Create(ouroStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40,180,80)}):Play()
        task.spawn(autoHaloOuro)
    else
        TweenService:Create(ouroStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
        TweenService:Create(ouroStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180,40,60)}):Play()
    end
end)

diamanteButton.MouseButton1Click:Connect(function()
    _G.AUTO_HALO_DIAMANTE_ATIVO = not _G.AUTO_HALO_DIAMANTE_ATIVO
    diamanteStatus.Text = _G.AUTO_HALO_DIAMANTE_ATIVO and "ON" or "OFF"
    if _G.AUTO_HALO_DIAMANTE_ATIVO then
        TweenService:Create(diamanteStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
        TweenService:Create(diamanteStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40,180,80)}):Play()
        task.spawn(autoHaloDiamante)
    else
        TweenService:Create(diamanteStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
        TweenService:Create(diamanteStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180,40,60)}):Play()
    end
end)

exchangeButton.MouseButton1Click:Connect(function()
    _G.AUTO_EXCHANGE_HALO_ATIVO = not _G.AUTO_EXCHANGE_HALO_ATIVO
    exchangeStatus.Text = _G.AUTO_EXCHANGE_HALO_ATIVO and "ON" or "OFF"
    if _G.AUTO_EXCHANGE_HALO_ATIVO then
        TweenService:Create(exchangeStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
        TweenService:Create(exchangeStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40,180,80)}):Play()
        task.spawn(autoExchangeHalo)
    else
        TweenService:Create(exchangeStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
        TweenService:Create(exchangeStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180,40,60)}):Play()
    end
end)

-- Inicializa
switchTab("Farm")

print("Diuary Hub carregado com sucesso!")