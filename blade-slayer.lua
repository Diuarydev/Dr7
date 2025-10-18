-- HUB DIUARYOG PROFISSIONAL COM ABAS v3.2 (com todas as funções integradas)
-- By DiuaryOG 💙
-- Coloque como LocalScript dentro de PlayerGui (StarterGui -> PlayerGui).

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Espera remotes
local remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Remotes
local rerollRemote = remotes:FindFirstChild("RerollOrnament")
local clickRemote = remotes:FindFirstChild("PlayerClickAttack")
local rebornRemote = remotes:FindFirstChild("PlayerReborn")
local openBoxRemote = remotes:FindFirstChild("OpenAntiqueBox")
local respirationSkillRemote = remotes:FindFirstChild("RespirationSkillHarm")
local rerollHaloRemote = remotes:FindFirstChild("RerollHalo")
local exchangeHaloRemote = remotes:FindFirstChild("ExchangeHaloDrawItem")
local useOrnamentRemote = remotes:FindFirstChild("UseOrnament")
local heroSkillRemote = remotes:FindFirstChild("HeroSkillHarm")

-- CONFIG
local ORNAMENT_ID = 400002
local DELAY_REROLL = 0.1
local RESPIRATION_SKILL_DELAY = 0.05
local HALO_DELAY = 0.001
local EXCHANGE_HALO_DELAY = 0.01
local KEYS_VALIDAS = { "luh", "fifa" }

-- Ornamentos Config
local ORNAMENTS = {
    DMG = { ornamentId = 410028, machineId = 400005 },
    Power = { ornamentId = 410026, machineId = 400005 },
    Lucky = { ornamentId = 410025, machineId = 400005 }
}

-- FLAGS E ESTADOS GLOBAIS
local ABA_ATUAL = "Farm"
local taskRunningFlags = {}
local function setFlag(name, v) taskRunningFlags[name] = v end
local function getFlag(name) return taskRunningFlags[name] end

-- Full DMG (detecção)
local detectedHeroes = {} -- shared cache for Full DMG detection

-- Função utilitária: safe wait
local function safeWait(t)
    task.wait(t or 0.01)
end

-- SISTEMA DE KEY (cliente-side)
local function verificarKey()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystemGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = playerGui

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 350, 0, 200)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0

    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "🔑 SISTEMA DE KEY"
    Title.TextColor3 = Color3.fromRGB(120, 180, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold

    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(0, 300, 0, 40)
    TextBox.Position = UDim2.new(0.5, -150, 0, 60)
    TextBox.PlaceholderText = "Digite sua key aqui..."
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.Gotham

    local ConfirmButton = Instance.new("TextButton", Frame)
    ConfirmButton.Size = UDim2.new(0, 300, 0, 40)
    ConfirmButton.Position = UDim2.new(0.5, -150, 0, 110)
    ConfirmButton.Text = "VERIFICAR"
    ConfirmButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    ConfirmButton.TextColor3 = Color3.new(1, 1, 1)
    ConfirmButton.TextSize = 16
    ConfirmButton.Font = Enum.Font.GothamBold
    ConfirmButton.BorderSizePixel = 0

    local StatusLabel = Instance.new("TextLabel", Frame)
    StatusLabel.Size = UDim2.new(1, -20, 0, 20)
    StatusLabel.Position = UDim2.new(0, 10, 0, 165)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = ""

    local keyValida = false
    ConfirmButton.MouseButton1Click:Connect(function()
        local keyInput = TextBox.Text
        if keyInput == "" then
            StatusLabel.Text = "⚠️ Digite uma key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        for _, key in pairs(KEYS_VALIDAS) do
            if keyInput == key then
                keyValida = true
                StatusLabel.Text = "✅ KEY VÁLIDA! Carregando..."
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                ConfirmButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                task.wait(1)
                ScreenGui:Destroy()
                return
            end
        end
        StatusLabel.Text = "❌ KEY INVÁLIDA!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
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

-- Floating button
local floatingButton = Instance.new("TextButton", screenGui)
floatingButton.Size = UDim2.new(0, 60, 0, 60)
floatingButton.Position = UDim2.new(0, 20, 0.5, -30)
floatingButton.BackgroundColor3 = Color3.fromRGB(45,45,55)
floatingButton.BorderSizePixel = 0
floatingButton.Text = ""
floatingButton.AutoButtonColor = false
floatingButton.ZIndex = 99999

local floatingCorner = Instance.new("UICorner", floatingButton)
floatingCorner.CornerRadius = UDim.new(0.25,0)

local floatingIcon = Instance.new("TextLabel", floatingButton)
floatingIcon.Size = UDim2.new(1,0,1,0)
floatingIcon.BackgroundTransparency = 1
floatingIcon.Text = "🥀"
floatingIcon.TextColor3 = Color3.new(1,1,1)
floatingIcon.TextSize = 30
floatingIcon.Font = Enum.Font.GothamBold

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

-- Main hub frame
local hubFrame = Instance.new("Frame", screenGui)
hubFrame.Size = UDim2.new(0, 500, 0, 400)
hubFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
hubFrame.BackgroundColor3 = Color3.fromRGB(20,20,25)
hubFrame.BorderSizePixel = 0
hubFrame.Visible = false
hubFrame.ZIndex = 100000

local hubCorner = Instance.new("UICorner", hubFrame)
hubCorner.CornerRadius = UDim.new(0,15)

local hubStroke = Instance.new("UIStroke", hubFrame)
hubStroke.Color = Color3.fromRGB(60,60,80)
hubStroke.Thickness = 1
hubStroke.Transparency = 0.7

-- Header
local header = Instance.new("Frame", hubFrame)
header.Size = UDim2.new(1,0,0,50)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = Color3.fromRGB(25,25,35)
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0,15)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0,250,0,35)
title.Position = UDim2.new(0,20,0,7)
title.BackgroundTransparency = 1
title.Text = "✦ DiuaryOG Hub"
title.TextColor3 = Color3.fromRGB(120,180,255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local version = Instance.new("TextLabel", header)
version.Size = UDim2.new(0,60,0,15)
version.Position = UDim2.new(0,20,0,32)
version.BackgroundTransparency = 1
version.Text = "v3.2 Pro"
version.TextColor3 = Color3.fromRGB(100,100,120)
version.TextSize = 10
version.Font = Enum.Font.Gotham

-- Close button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,40,0,40)
closeBtn.Position = UDim2.new(1, -50, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,10)

closeBtn.MouseButton1Click:Connect(function()
    hubFrame.Visible = false
    floatingButton.Visible = true
end)

floatingButton.MouseButton1Click:Connect(function()
    hubFrame.Visible = true
    floatingButton.Visible = false
end)

-- Sidebar menu
local sidebar = Instance.new("Frame", hubFrame)
sidebar.Size = UDim2.new(0,120,1,-50)
sidebar.Position = UDim2.new(0,0,0,50)
sidebar.BackgroundColor3 = Color3.fromRGB(18,18,22)
sidebar.BorderSizePixel = 0

local contentArea = Instance.new("Frame", hubFrame)
contentArea.Size = UDim2.new(1, -130, 1, -60)
contentArea.Position = UDim2.new(0,130,0,60)
contentArea.BackgroundTransparency = 1

-- Drag hub by header
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

-- Create tab button helper
local function createTabButton(text, icon, yPos)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0,110,0,40)
    btn.Position = UDim2.new(0,5,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,35)
    btn.TextColor3 = Color3.fromRGB(150,150,180)
    btn.Text = icon .. "\n" .. text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,10)
    return btn
end

-- Create tabs
local farmTab = createTabButton("Farm","🎮",10)
local marcaTab = createTabButton("Marca","🎯",55)
local skillsTab = createTabButton("Skills","⚡",100)
local auraTab = createTabButton("Aura","✨",145)
local talismaTab = createTabButton("Talismã","💎",190)

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

-- Switch tabs
local function switchTab(tabName)
    ABA_ATUAL = tabName
    local tabs = {farmTab, marcaTab, skillsTab, auraTab, talismaTab}
    for _, t in ipairs(tabs) do
        t.BackgroundColor3 = Color3.fromRGB(25,25,35)
        t.TextColor3 = Color3.fromRGB(150,150,180)
    end
    farmContainer.Visible = false
    marcaContainer.Visible = false
    skillsContainer.Visible = false
    auraContainer.Visible = false
    talismaContainer.Visible = false

    if tabName == "Farm" then
        farmTab.BackgroundColor3 = Color3.fromRGB(50,150,255)
        farmTab.TextColor3 = Color3.new(1,1,1)
        farmContainer.Visible = true
    elseif tabName == "Marca" then
        marcaTab.BackgroundColor3 = Color3.fromRGB(50,150,255)
        marcaTab.TextColor3 = Color3.new(1,1,1)
        marcaContainer.Visible = true
    elseif tabName == "Skills" then
        skillsTab.BackgroundColor3 = Color3.fromRGB(50,150,255)
        skillsTab.TextColor3 = Color3.new(1,1,1)
        skillsContainer.Visible = true
    elseif tabName == "Aura" then
        auraTab.BackgroundColor3 = Color3.fromRGB(50,150,255)
        auraTab.TextColor3 = Color3.new(1,1,1)
        auraContainer.Visible = true
    elseif tabName == "Talismã" then
        talismaTab.BackgroundColor3 = Color3.fromRGB(50,150,255)
        talismaTab.TextColor3 = Color3.new(1,1,1)
        talismaContainer.Visible = true
    end
end

farmTab.MouseButton1Click:Connect(function() switchTab("Farm") end)
marcaTab.MouseButton1Click:Connect(function() switchTab("Marca") end)
skillsTab.MouseButton1Click:Connect(function() switchTab("Skills") end)
auraTab.MouseButton1Click:Connect(function() switchTab("Aura") end)
talismaTab.MouseButton1Click:Connect(function() switchTab("Talismã") end)

-- Button creator (with status label)
local function createButton(text, parent, yPos)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0,340,0,40)
    btn.Position = UDim2.new(0,10,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,65)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,10)

    local status = Instance.new("TextLabel", btn)
    status.Size = UDim2.new(0,70,0,22)
    status.Position = UDim2.new(1,-75,0.5,-11)
    status.BackgroundColor3 = Color3.fromRGB(200,50,50)
    status.TextColor3 = Color3.new(1,1,1)
    status.Text = "OFF"
    status.TextSize = 10
    status.Font = Enum.Font.GothamBold
    status.BorderSizePixel = 0

    local statusCorner = Instance.new("UICorner", status)
    statusCorner.CornerRadius = UDim.new(1,0)

    return btn, status
end

-- === ABA FARM ===
local clickButton, clickStatus = createButton("🖱️ AutoClick", farmContainer, 10)
local rebornButton, rebornStatus = createButton("🔄 AutoReborn", farmContainer, 60)
local openButton, openStatus = createButton("📦 AutoOpen Baús", farmContainer, 110)

-- === ABA MARCA ===
local autoRerollButton, autoRerollStatus = createButton("🎯 AutoReroll Marca", marcaContainer, 10)
local foundLabel = Instance.new("TextLabel", marcaContainer)
foundLabel.Size = UDim2.new(0,340,0,40)
foundLabel.Position = UDim2.new(0,10,0,60)
foundLabel.BackgroundColor3 = Color3.fromRGB(30,30,40)
foundLabel.TextColor3 = Color3.fromRGB(255,215,0)
foundLabel.TextSize = 12
foundLabel.Font = Enum.Font.GothamBold
foundLabel.Text = "🎯 Clique no botão acima para começar!\nO sistema vai girar até você desligar."
foundLabel.TextWrapped = true
local foundCorner = Instance.new("UICorner", foundLabel)
foundCorner.CornerRadius = UDim.new(0,10)

-- === ABA SKILLS ===
local respirationSkillButton, respirationSkillStatus = createButton("☠️ RespirationSkill", skillsContainer, 10)

-- Respiration input
local respirationDelayLabel = Instance.new("TextLabel", skillsContainer)
respirationDelayLabel.Size = UDim2.new(0,100,0,20)
respirationDelayLabel.Position = UDim2.new(0,10,0,60)
respirationDelayLabel.BackgroundTransparency = 1
respirationDelayLabel.TextColor3 = Color3.fromRGB(150,150,180)
respirationDelayLabel.TextSize = 11
respirationDelayLabel.Font = Enum.Font.GothamBold
respirationDelayLabel.Text = "Delay (segundos):"
respirationDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local respirationDelayInput = Instance.new("TextBox", skillsContainer)
respirationDelayInput.Size = UDim2.new(0,340,0,30)
respirationDelayInput.Position = UDim2.new(0,10,0,80)
respirationDelayInput.BackgroundColor3 = Color3.fromRGB(35,35,50)
respirationDelayInput.TextColor3 = Color3.new(1,1,1)
respirationDelayInput.PlaceholderText = "0.01 a 5"
respirationDelayInput.Text = tostring(RESPIRATION_SKILL_DELAY)
respirationDelayInput.ClearTextOnFocus = false
respirationDelayInput.Font = Enum.Font.Gotham
respirationDelayInput.TextSize = 13

respirationDelayInput.FocusLost:Connect(function()
    local v = tonumber(respirationDelayInput.Text)
    if v then RESPIRATION_SKILL_DELAY = math.clamp(v, 0.01, 5); respirationDelayInput.Text = string.format("%.2f", RESPIRATION_SKILL_DELAY)
    else respirationDelayInput.Text = string.format("%.2f", RESPIRATION_SKILL_DELAY) end
end)

-- === Full DMG (integrated exactly, using hub UI) ===
do
    -- CONFIGURAÇÃO DA SKILL
    local fd_skillId = 200616
    local fd_harmIndex = 15

    -- services via remotes already defined
    local heroRemote = heroSkillRemote

    -- estado
    local autoFireEnabled_fd = false
    local delayValue_fd = 0.5
    local detectedHeroes_fd = detectedHeroes -- share global cache (populated by hook below)
    local autoFireRunning_fd = false

    -- Delay input (within skillsContainer)
    local fdDelayLabel = Instance.new("TextLabel", skillsContainer)
    fdDelayLabel.Size = UDim2.new(0,100,0,20)
    fdDelayLabel.Position = UDim2.new(0,10,0,190)
    fdDelayLabel.BackgroundTransparency = 1
    fdDelayLabel.TextColor3 = Color3.fromRGB(150,150,180)
    fdDelayLabel.TextSize = 11
    fdDelayLabel.Font = Enum.Font.GothamBold
    fdDelayLabel.Text = "Full DMG Delay:"
    fdDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

    local fdDelayBox = Instance.new("TextBox", skillsContainer)
    fdDelayBox.Size = UDim2.new(0,340,0,30)
    fdDelayBox.Position = UDim2.new(0,10,0,210)
    fdDelayBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
    fdDelayBox.Text = tostring(delayValue_fd)
    fdDelayBox.PlaceholderText = "0.001 - 5"
    fdDelayBox.ClearTextOnFocus = false
    fdDelayBox.Font = Enum.Font.Gotham
    fdDelayBox.TextSize = 13

    fdDelayBox.FocusLost:Connect(function()
        local v = tonumber(fdDelayBox.Text)
        if v then delayValue_fd = math.clamp(v, 0.001, 5); fdDelayBox.Text = string.format("%.3f", delayValue_fd)
        else fdDelayBox.Text = string.format("%.3f", delayValue_fd) end
    end)

    -- Hook (try, may fail if executor blocks)
    do
        local ok, err = pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if self == heroRemote and method == "FireServer" then
                    local args = {...}
                    local data = args[1]
                    if type(data) == "table" and data.heroGuid then
                        if not detectedHeroes_fd[data.heroGuid] then
                            detectedHeroes_fd[data.heroGuid] = true
                            print("✅ Full DMG Pet detectado:", data.heroGuid)
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)
        end)
        if not ok then
            warn("[Full DMG] hookmetamethod instalação falhou:", err)
            -- fallback: user can still manually populate detectedHeroes_fd if needed
        end
    end

    -- Loop
    local function autoFireLoop_fd()
        if autoFireRunning_fd then return end
        autoFireRunning_fd = true
        while autoFireEnabled_fd do
            local delayTime = (tonumber(fdDelayBox.Text) and math.clamp(tonumber(fdDelayBox.Text), 0.001, 5)) or delayValue_fd
            for guid, _ in pairs(detectedHeroes_fd) do
                pcall(function()
                    if heroRemote then
                        heroRemote:FireServer({
                            heroGuid = guid,
                            skillId = fd_skillId,
                            harmIndex = fd_harmIndex,
                            isSkill = true
                        })
                    end
                end)
            end
            task.wait(delayTime)
        end
        autoFireRunning_fd = false
    end

    -- Add Full DMG button
    local fullDmgButton, fullDmgStatus = createButton("⚔️ Full DMG", skillsContainer, 140)
    fullDmgButton.MouseButton1Click:Connect(function()
        autoFireEnabled_fd = not autoFireEnabled_fd
        fullDmgStatus.Text = autoFireEnabled_fd and "ON" or "OFF"
        fullDmgStatus.BackgroundColor3 = autoFireEnabled_fd and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
        if autoFireEnabled_fd then
            task.spawn(autoFireLoop_fd)
        end
    end)
end

-- === ABA AURA ===
local haloInfo = Instance.new("TextLabel", auraContainer)
haloInfo.Size = UDim2.new(0,340,0,30)
haloInfo.Position = UDim2.new(0,10,0,10)
haloInfo.BackgroundColor3 = Color3.fromRGB(30,30,40)
haloInfo.TextColor3 = Color3.fromRGB(255,215,0)
haloInfo.TextSize = 12
haloInfo.Font = Enum.Font.GothamBold
haloInfo.Text = "✨ Sistema de Halos"

local bronzeButton, bronzeStatus = createButton("🥉 Reroll Bronze", auraContainer, 50)
local ouroButton, ouroStatus = createButton("🥇 Reroll Ouro", auraContainer, 100)
local diamanteButton, diamanteStatus = createButton("💎 Reroll Diamante", auraContainer, 150)
local exchangeButton, exchangeStatus = createButton("🎁 Exchange Halo (Diamante)", auraContainer, 200)

-- Exchange delay input
local exchangeDelayLabel = Instance.new("TextLabel", auraContainer)
exchangeDelayLabel.Size = UDim2.new(0,340,0,20)
exchangeDelayLabel.Position = UDim2.new(0,10,0,250)
exchangeDelayLabel.BackgroundTransparency = 1
exchangeDelayLabel.TextColor3 = Color3.fromRGB(150,150,180)
exchangeDelayLabel.TextSize = 11
exchangeDelayLabel.Font = Enum.Font.GothamBold
exchangeDelayLabel.Text = "Delay (segundos):"
exchangeDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local exchangeDelayInput = Instance.new("TextBox", auraContainer)
exchangeDelayInput.Size = UDim2.new(0,340,0,25)
exchangeDelayInput.Position = UDim2.new(0,10,0,270)
exchangeDelayInput.BackgroundColor3 = Color3.fromRGB(35,35,50)
exchangeDelayInput.TextColor3 = Color3.new(1,1,1)
exchangeDelayInput.PlaceholderText = "0.01 a 0.51"
exchangeDelayInput.Text = string.format("%.2f", EXCHANGE_HALO_DELAY)
exchangeDelayInput.ClearTextOnFocus = false
exchangeDelayInput.Font = Enum.Font.Gotham
exchangeDelayInput.TextSize = 13

exchangeDelayInput.FocusLost:Connect(function()
    local v = tonumber(exchangeDelayInput.Text)
    if v then EXCHANGE_HALO_DELAY = math.clamp(v, 0.01, 0.51); exchangeDelayInput.Text = string.format("%.2f", EXCHANGE_HALO_DELAY)
    else exchangeDelayInput.Text = string.format("%.2f", EXCHANGE_HALO_DELAY) end
end)

-- === ABA TALISMÃ ===
local talismaInfo = Instance.new("TextLabel", talismaContainer)
talismaInfo.Size = UDim2.new(0,340,0,40)
talismaInfo.Position = UDim2.new(0,10,0,10)
talismaInfo.BackgroundColor3 = Color3.fromRGB(30,30,40)
talismaInfo.TextColor3 = Color3.fromRGB(255,215,0)
talismaInfo.TextSize = 11
talismaInfo.Font = Enum.Font.GothamBold
talismaInfo.Text = "💎 Sistema de Ornamentos\nClique para selecionar e equipar"
talismaInfo.TextWrapped = true

local ornamentButtons = {}
do
    local y = 60
    for name, cfg in pairs(ORNAMENTS) do
        local btn = Instance.new("TextButton", talismaContainer)
        btn.Size = UDim2.new(0,340,0,45)
        btn.Position = UDim2.new(0,10,0,y)
        btn.BackgroundColor3 = Color3.fromRGB(45,45,65)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Text = "💎 " .. name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0,10)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(60,60,80)
        stroke.Thickness = 2
        stroke.Transparency = 0.5

        ornamentButtons[name] = { button = btn, stroke = stroke, cfg = cfg }

        y = y + 55
    end
end

local equipButton = Instance.new("TextButton", talismaContainer)
equipButton.Size = UDim2.new(0,340,0,45)
equipButton.Position = UDim2.new(0,10,0,230)
equipButton.BackgroundColor3 = Color3.fromRGB(50,150,255)
equipButton.TextColor3 = Color3.new(1,1,1)
equipButton.Text = "⚡ EQUIPAR SELECIONADO"
equipButton.Font = Enum.Font.GothamBold
equipButton.TextSize = 15
equipButton.BorderSizePixel = 0
equipButton.AutoButtonColor = false

local talismaDesc = Instance.new("TextLabel", talismaContainer)
talismaDesc.Size = UDim2.new(0,340,0,35)
talismaDesc.Position = UDim2.new(0,10,0,285)
talismaDesc.BackgroundTransparency = 1
talismaDesc.TextColor3 = Color3.fromRGB(150,150,180)
talismaDesc.Font = Enum.Font.Gotham
talismaDesc.TextSize = 10
talismaDesc.Text = "Selecione um ornamento e clique em EQUIPAR\nDMG = Dano | Power = Poder | Lucky = Sorte"
talismaDesc.TextWrapped = true

local ornamentSelecionado = nil
for name, data in pairs(ornamentButtons) do
    data.button.MouseButton1Click:Connect(function()
        -- deselect all
        for n, d in pairs(ornamentButtons) do
            d.button.BackgroundColor3 = Color3.fromRGB(45,45,65)
            d.stroke.Color = Color3.fromRGB(60,60,80)
            d.stroke.Transparency = 0.5
        end
        data.button.BackgroundColor3 = Color3.fromRGB(60,120,255)
        data.stroke.Color = Color3.fromRGB(100,180,255)
        data.stroke.Transparency = 0
        ornamentSelecionado = name
        talismaDesc.Text = "✅ " .. name .. " selecionado! Clique em EQUIPAR para usar."
        talismaDesc.TextColor3 = Color3.fromRGB(100,255,100)
    end)
end

equipButton.MouseButton1Click:Connect(function()
    if not ornamentSelecionado then
        talismaDesc.Text = "⚠️ Selecione um ornamento primeiro!"
        talismaDesc.TextColor3 = Color3.fromRGB(255,100,100)
        return
    end
    local cfg = ORNAMENTS[ornamentSelecionado]
    pcall(function()
        if useOrnamentRemote then
            local result = useOrnamentRemote:InvokeServer({
                ornamentId = cfg.ornamentId,
                machineId = cfg.machineId,
                isEquip = true
            })
            print("Ornamento equipado:", ornamentSelecionado, result)
        end
    end)
    talismaDesc.Text = "✅ " .. ornamentSelecionado .. " equipado com sucesso!"
    talismaDesc.TextColor3 = Color3.fromRGB(100,255,100)
end)

-- === FUNÇÕES DE AUTO (implementações) ===

-- AutoClick
local function autoClick()
    if getFlag("autoClick") then return end
    setFlag("autoClick", true)
    while AUTO_CLICK_ATIVO do
        pcall(function()
            if clickRemote then clickRemote:FireServer({}) end
        end)
        task.wait(0.0001)
    end
    setFlag("autoClick", false)
end

-- AutoReborn
local function autoReborn()
    if getFlag("autoReborn") then return end
    setFlag("autoReborn", true)
    while AUTO_REBORN_ATIVO do
        pcall(function() if rebornRemote then rebornRemote:FireServer() end end)
        task.wait(1)
    end
    setFlag("autoReborn", false)
end

-- AutoOpen Baus
local function autoOpenBaus()
    if getFlag("autoOpen") then return end
    setFlag("autoOpen", true)
    local baus = {820001,820002,820003,820004,820005}
    while AUTO_OPEN_ATIVO do
        for _, id in ipairs(baus) do
            pcall(function() if openBoxRemote then openBoxRemote:FireServer(id) end end)
            task.wait(0.001)
        end
    end
    setFlag("autoOpen", false)
end

-- Respiration skill
local function autoRespirationSkill()
    if getFlag("autoRespiration") then return end
    setFlag("autoRespiration", true)
    while AUTO_RESPIRATION_SKILL_ATIVO do
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

-- Halo functions
local function autoHaloBronze()
    if getFlag("autoHaloBronze") then return end
    setFlag("autoHaloBronze", true)
    while AUTO_HALO_BRONZE_ATIVO do
        pcall(function() if rerollHaloRemote then rerollHaloRemote:InvokeServer(1) end end)
        task.wait(HALO_DELAY)
    end
    setFlag("autoHaloBronze", false)
end

local function autoHaloOuro()
    if getFlag("autoHaloOuro") then return end
    setFlag("autoHaloOuro", true)
    while AUTO_HALO_OURO_ATIVO do
        pcall(function() if rerollHaloRemote then rerollHaloRemote:InvokeServer(2) end end)
        task.wait(HALO_DELAY)
    end
    setFlag("autoHaloOuro", false)
end

local function autoHaloDiamante()
    if getFlag("autoHaloDiamante") then return end
    setFlag("autoHaloDiamante", true)
    while AUTO_HALO_DIAMANTE_ATIVO do
        pcall(function() if rerollHaloRemote then rerollHaloRemote:InvokeServer(3) end end)
        task.wait(HALO_DELAY)
    end
    setFlag("autoHaloDiamante", false)
end

local function autoExchangeHalo()
    if getFlag("autoExchangeHalo") then return end
    setFlag("autoExchangeHalo", true)
    while AUTO_EXCHANGE_HALO_ATIVO do
        pcall(function()
            if exchangeHaloRemote then
                exchangeHaloRemote:InvokeServer({ haloType = 3, count = 1 })
            end
        end)
        task.wait(EXCHANGE_HALO_DELAY)
    end
    setFlag("autoExchangeHalo", false)
end

-- AutoReroll (marca)
local function autoReroll()
    if getFlag("autoReroll") then return end
    setFlag("autoReroll", true)
    while AUTO_REROLL_ATIVO do
        pcall(function() if rerollRemote then rerollRemote:InvokeServer(ORNAMENT_ID) end end)
        task.wait(DELAY_REROLL)
    end
    setFlag("autoReroll", false)
end

-- === TOGGLES / Events ===

-- Farm toggles
clickButton.MouseButton1Click:Connect(function()
    AUTO_CLICK_ATIVO = not AUTO_CLICK_ATIVO
    clickStatus.Text = AUTO_CLICK_ATIVO and "ON" or "OFF"
    clickStatus.BackgroundColor3 = AUTO_CLICK_ATIVO and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    if AUTO_CLICK_ATIVO then task.spawn(autoClick) end
end)

rebornButton.MouseButton1Click:Connect(function()
    AUTO_REBORN_ATIVO = not AUTO_REBORN_ATIVO
    rebornStatus.Text = AUTO_REBORN_ATIVO and "ON" or "OFF"
    rebornStatus.BackgroundColor3 = AUTO_REBORN_ATIVO and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    if AUTO_REBORN_ATIVO then task.spawn(autoReborn) end
end)

openButton.MouseButton1Click:Connect(function()
    AUTO_OPEN_ATIVO = not AUTO_OPEN_ATIVO
    openStatus.Text = AUTO_OPEN_ATIVO and "ON" or "OFF"
    openStatus.BackgroundColor3 = AUTO_OPEN_ATIVO and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    if AUTO_OPEN_ATIVO then task.spawn(autoOpenBaus) end
end)

-- Marca reroll toggle
autoRerollButton.MouseButton1Click:Connect(function()
    AUTO_REROLL_ATIVO = not AUTO_REROLL_ATIVO
    autoRerollStatus.Text = AUTO_REROLL_ATIVO and "ON" or "OFF"
    autoRerollStatus.BackgroundColor3 = AUTO_REROLL_ATIVO and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    if AUTO_REROLL_ATIVO then
        foundLabel.Text = "🎯 Girando marca automaticamente...\nClique novamente para parar."
        task.spawn(autoReroll)
    else
        foundLabel.Text = "🎯 Sistema parado!\nClique no botão acima para começar."
    end
end)

-- Respiration toggle
respirationSkillButton.MouseButton1Click:Connect(function()
    AUTO_RESPIRATION_SKILL_ATIVO = not AUTO_RESPIRATION_SKILL_ATIVO
    respirationSkillStatus.Text = AUTO_RESPIRATION_SKILL_ATIVO and "ON" or "OFF"
    respirationSkillStatus.BackgroundColor3 = AUTO_RESPIRATION_SKILL_ATIVO and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    if AUTO_RESPIRATION_SKILL_ATIVO then task.spawn(autoRespirationSkill) end
end)

-- Halo toggles
bronzeButton.MouseButton1Click:Connect(function()
    AUTO_HALO_BRONZE_ATIVO = not AUTO_HALO_BRONZE_ATIVO
    bronzeStatus.Text = AUTO_HALO_BRONZE_ATIVO and "ON" or "OFF"
    bronzeStatus.BackgroundColor3 = AUTO_HALO_BRONZE_ATIVO and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    if AUTO_HALO_BRONZE_ATIVO then task.spawn(autoHaloBronze) end
end)

ouroButton.MouseButton1Click:Connect(function()
    AUTO_HALO_OURO_ATIVO = not AUTO_HALO_OURO_ATIVO
    ouroStatus.Text = AUTO_HALO_OURO_ATIVO and "ON" or "OFF"
    ouroStatus.BackgroundColor3 = AUTO_HALO_OURO_ATIVO and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    if AUTO_HALO_OURO_ATIVO then task.spawn(autoHaloOuro) end
end)

diamanteButton.MouseButton1Click:Connect(function()
    AUTO_HALO_DIAMANTE_ATIVO = not AUTO_HALO_DIAMANTE_ATIVO
    diamanteStatus.Text = AUTO_HALO_DIAMANTE_ATIVO and "ON" or "OFF"
    diamanteStatus.BackgroundColor3 = AUTO_HALO_DIAMANTE_ATIVO and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    if AUTO_HALO_DIAMANTE_ATIVO then task.spawn(autoHaloDiamante) end
end)

exchangeButton.MouseButton1Click:Connect(function()
    AUTO_EXCHANGE_HALO_ATIVO = not AUTO_EXCHANGE_HALO_ATIVO
    exchangeStatus.Text = AUTO_EXCHANGE_HALO_ATIVO and "ON" or "OFF"
    exchangeStatus.BackgroundColor3 = AUTO_EXCHANGE_HALO_ATIVO and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    if AUTO_EXCHANGE_HALO_ATIVO then task.spawn(autoExchangeHalo) end
end)

-- Inicializa aba Farm
switchTab("Farm")

print("✅DiuaryOG carregado com sucesso!")