-- HUB DIUARYOG PROFISSIONAL COM ABAS v3.2
-- By DiuaryOG 💙
-- Atualizado: Sistema de Talismã, RespirationSkill, ExchangeHalo e AutoReroll Simplificado

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Aguardar Remotes
wait(2)

-- Remotes
local rerollRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RerollOrnament")
local clickRemote = ReplicatedStorage.Remotes.PlayerClickAttack
local rebornRemote = ReplicatedStorage.Remotes.PlayerReborn
local openBoxRemote = ReplicatedStorage.Remotes.OpenAntiqueBox
local respirationSkillRemote = ReplicatedStorage.Remotes.RespirationSkillHarm
local rerollHaloRemote = ReplicatedStorage.Remotes.RerollHalo
local exchangeHaloRemote = ReplicatedStorage.Remotes.ExchangeHaloDrawItem
local useOrnamentRemote = ReplicatedStorage.Remotes.UseOrnament

-- CONFIG
local ORNAMENT_ID = 400002
local DELAY_REROLL = 0.1
local AUTO_REROLL_ATIVO = false
local AUTO_CLICK_ATIVO = false
local AUTO_REBORN_ATIVO = false
local AUTO_OPEN_ATIVO = false
local AUTO_RESPIRATION_SKILL_ATIVO = false
local AUTO_HALO_BRONZE_ATIVO = false
local AUTO_HALO_OURO_ATIVO = false
local AUTO_HALO_DIAMANTE_ATIVO = false
local AUTO_EXCHANGE_HALO_ATIVO = false
local RESPIRATION_SKILL_DELAY = 0.05
local HALO_DELAY = 0.001
local EXCHANGE_HALO_DELAY = 0.01
local KEYS_VALIDAS = { "luh", "fifa" }
local ABA_ATUAL = "Farm"

-- Ornamentos Config
local ORNAMENTS = {
    DMG = { ornamentId = 410028, machineId = 400005, selected = false },
    Power = { ornamentId = 410026, machineId = 400005, selected = false },
    Lucky = { ornamentId = 410025, machineId = 400005, selected = false }
}
local ornamentSelecionado = nil

-- Lista de heróis e skills (ATUALIZADO - 10 HERÓIS)
local heroesSkills = {
    -- Conta 1
    {
        heroGuid = "f69689dd-85f5-4c8d-9cc9-3734109eadef",
        skillId = 200616,
        harmIndex = 1
    },
    {
        heroGuid = "12192dfe-97c5-439b-b271-fa9fc28e3b56",
        skillId = 200616,
        harmIndex = 1
    },
    {
        heroGuid = "c4cfa56d-f873-4c3a-851a-650b3477dbf3",
        skillId = 200616,
        harmIndex = 1
    },
    {
        heroGuid = "b6cf37e3-609b-4ed3-92e0-0e250ee1502e",
        skillId = 200616,
        harmIndex = 1
    },
    {
        heroGuid = "25a13523-7985-4ea8-9ec7-6c619a378b8d",
        skillId = 200616,
        harmIndex = 1
    },
    -- Conta 2
    {
        heroGuid = "b88fd791-06ad-4e1e-964a-f6e67cafcb1a",
        skillId = 200616,
        harmIndex = 1
    },
    {
        heroGuid = "e2c0a234-efd6-4331-a1a3-7d6d47a0b52a",
        skillId = 200616,
        harmIndex = 1
    },
    {
        heroGuid = "31c1e490-e22a-40cb-b644-47e13cea3c40",
        skillId = 200616,
        harmIndex = 1
    },
    {
        heroGuid = "200362e0-9581-4699-875c-35193486ce4c",
        skillId = 200616,
        harmIndex = 1
    },
    {
        heroGuid = "6a87918b-0a7f-4241-abb9-287cf8b1a095",
        skillId = 200616,
        harmIndex = 1
    }
}

-- SISTEMA DE KEY
local function verificarKey()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local TextBox = Instance.new("TextBox")
    local TextCorner = Instance.new("UICorner")
    local ConfirmButton = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local StatusLabel = Instance.new("TextLabel")

    ScreenGui.Name = "KeySystemGui"
    ScreenGui.Parent = playerGui
    ScreenGui.ResetOnSpawn = false
    
    Frame.Size = UDim2.new(0, 350, 0, 200)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame

    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "🔑 SISTEMA DE KEY"
    Title.TextColor3 = Color3.fromRGB(120, 180, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame

    TextBox.Size = UDim2.new(0, 300, 0, 40)
    TextBox.Position = UDim2.new(0.5, -150, 0, 60)
    TextBox.PlaceholderText = "Digite sua key aqui..."
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.Gotham
    TextBox.BorderSizePixel = 0
    TextBox.Parent = Frame

    TextCorner.CornerRadius = UDim.new(0, 8)
    TextCorner.Parent = TextBox

    ConfirmButton.Size = UDim2.new(0, 300, 0, 40)
    ConfirmButton.Position = UDim2.new(0.5, -150, 0, 110)
    ConfirmButton.Text = "VERIFICAR"
    ConfirmButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    ConfirmButton.TextColor3 = Color3.new(1, 1, 1)
    ConfirmButton.TextSize = 16
    ConfirmButton.Font = Enum.Font.GothamBold
    ConfirmButton.BorderSizePixel = 0
    ConfirmButton.Parent = Frame

    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = ConfirmButton

    StatusLabel.Size = UDim2.new(1, -20, 0, 20)
    StatusLabel.Position = UDim2.new(0, 10, 0, 165)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = ""
    StatusLabel.Parent = Frame

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

-- BOTÃO FLUTUANTE (SEMPRE VISÍVEL)
local floatingButton = Instance.new("ImageButton")
floatingButton.Size = UDim2.new(0, 60, 0, 60)
floatingButton.Position = UDim2.new(0, 20, 0.5, -30)
floatingButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
floatingButton.BorderSizePixel = 0
floatingButton.ZIndex = 99999
floatingButton.Active = false
floatingButton.Parent = screenGui

local floatingCorner = Instance.new("UICorner")
floatingCorner.CornerRadius = UDim.new(1, 0)
floatingCorner.Parent = floatingButton

local floatingStroke = Instance.new("UIStroke")
floatingStroke.Color = Color3.fromRGB(120, 180, 255)
floatingStroke.Thickness = 3
floatingStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
floatingStroke.Parent = floatingButton

local floatingIcon = Instance.new("TextLabel")
floatingIcon.Size = UDim2.new(1, 0, 1, 0)
floatingIcon.BackgroundTransparency = 1
floatingIcon.Text = "💙"
floatingIcon.TextColor3 = Color3.new(1, 1, 1)
floatingIcon.TextSize = 30
floatingIcon.Font = Enum.Font.GothamBold
floatingIcon.ZIndex = 99999
floatingIcon.Parent = floatingButton

-- Animação de pulso
--[[task.spawn(function()
    while true do
        floatingButton:TweenSize(
            UDim2.new(0, 65, 0, 65),
            Enum.EasingDirection.InOut,
            Enum.EasingStyle.Sine,
            0.8,
            true
        )
        task.wait(0.8)
        floatingButton:TweenSize(
            UDim2.new(0, 60, 0, 60),
            Enum.EasingDirection.InOut,
            Enum.EasingStyle.Sine,
            0.8,
            true
        )
        task.wait(0.8)
    end
end)
]]

-- Arrastar botão flutuante
local floatDragging = false
local floatDragInput, floatDragStart, floatStartPos

floatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = true
        floatDragStart = input.Position
        floatStartPos = floatingButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                floatDragging = false
            end
        end)
    end
end)

floatingButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        floatDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if floatDragging and input == floatDragInput then
        local delta = input.Position - floatDragStart
        floatingButton.Position = UDim2.new(
            floatStartPos.X.Scale,
            floatStartPos.X.Offset + delta.X,
            floatStartPos.Y.Scale,
            floatStartPos.Y.Offset + delta.Y
        )
    end
end)

-- FRAME PRINCIPAL
local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 500, 0, 400)
hubFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
hubFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
hubFrame.BorderSizePixel = 0
hubFrame.Active = true
hubFrame.Visible = false
hubFrame.ZIndex = 100000
hubFrame.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 15)
hubCorner.Parent = hubFrame

local hubStroke = Instance.new("UIStroke")
hubStroke.Color = Color3.fromRGB(60, 60, 80)
hubStroke.Thickness = 1
hubStroke.Transparency = 0.7
hubStroke.Parent = hubFrame

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
header.BorderSizePixel = 0
header.ZIndex = 100001
header.Parent = hubFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 250, 0, 35)
title.Position = UDim2.new(0, 20, 0, 7)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(120, 180, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Text = "🥀 DiuaryOG Hub"
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 100002
title.Parent = header

local version = Instance.new("TextLabel")
version.Size = UDim2.new(0, 60, 0, 15)
version.Position = UDim2.new(0, 20, 0, 32)
version.BackgroundTransparency = 1
version.TextColor3 = Color3.fromRGB(100, 100, 120)
version.TextSize = 10
version.Font = Enum.Font.Gotham
version.Text = "vivian"
version.TextXAlignment = Enum.TextXAlignment.Left
version.ZIndex = 100002
version.Parent = header

-- BOTÃO FECHAR (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 100002
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

-- SIDEBAR (MENU LATERAL)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -50)
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 100001
sidebar.Parent = hubFrame

-- CONTENT AREA
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -130, 1, -60)
contentArea.Position = UDim2.new(0, 130, 0, 60)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = 100001
contentArea.Parent = hubFrame

-- ARRASTAR (PC E MOBILE)
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    hubFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

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
        updateInput(input)
    end
end)

-- MINIMIZAR
closeBtn.MouseButton1Click:Connect(function()
    hubFrame.Visible = false
    floatingButton.Visible = true
end)

-- BOTÃO FLUTUANTE ABRE O HUB
floatingButton.MouseButton1Click:Connect(function()
    hubFrame.Visible = true
    floatingButton.Visible = false
end)

-- CRIAR BOTÃO DE ABA
local function createTabButton(text, icon, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.TextColor3 = Color3.fromRGB(150, 150, 180)
    btn.Text = icon .. "\n" .. text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 100002
    btn.Parent = sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    return btn
end

-- CRIAR ABAS
local farmTab = createTabButton("Farm", "🎮", 10)
local marcaTab = createTabButton("Marca", "🎯", 55)
local skillsTab = createTabButton("Skills", "⚡", 100)
local auraTab = createTabButton("Aura", "✨", 145)
local talismaTab = createTabButton("Talismã", "💎", 190)

-- CONTAINERS DAS ABAS
local farmContainer = Instance.new("Frame")
farmContainer.Size = UDim2.new(1, 0, 1, 0)
farmContainer.BackgroundTransparency = 1
farmContainer.Visible = true
farmContainer.ZIndex = 100002
farmContainer.Parent = contentArea

local marcaContainer = Instance.new("Frame")
marcaContainer.Size = UDim2.new(1, 0, 1, 0)
marcaContainer.BackgroundTransparency = 1
marcaContainer.Visible = false
marcaContainer.ZIndex = 100002
marcaContainer.Parent = contentArea

local skillsContainer = Instance.new("Frame")
skillsContainer.Size = UDim2.new(1, 0, 1, 0)
skillsContainer.BackgroundTransparency = 1
skillsContainer.Visible = false
skillsContainer.ZIndex = 100002
skillsContainer.Parent = contentArea

local auraContainer = Instance.new("Frame")
auraContainer.Size = UDim2.new(1, 0, 1, 0)
auraContainer.BackgroundTransparency = 1
auraContainer.Visible = false
auraContainer.ZIndex = 100002
auraContainer.Parent = contentArea

local talismaContainer = Instance.new("Frame")
talismaContainer.Size = UDim2.new(1, 0, 1, 0)
talismaContainer.BackgroundTransparency = 1
talismaContainer.Visible = false
talismaContainer.ZIndex = 100002
talismaContainer.Parent = contentArea

-- FUNÇÃO PARA TROCAR ABA
local function switchTab(tabName)
    ABA_ATUAL = tabName
    
    -- Resetar cores
    farmTab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    farmTab.TextColor3 = Color3.fromRGB(150, 150, 180)
    marcaTab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    marcaTab.TextColor3 = Color3.fromRGB(150, 150, 180)
    skillsTab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    skillsTab.TextColor3 = Color3.fromRGB(150, 150, 180)
    auraTab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    auraTab.TextColor3 = Color3.fromRGB(150, 150, 180)
    talismaTab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    talismaTab.TextColor3 = Color3.fromRGB(150, 150, 180)
    
    -- Esconder todos
    farmContainer.Visible = false
    marcaContainer.Visible = false
    skillsContainer.Visible = false
    auraContainer.Visible = false
    talismaContainer.Visible = false
    
    -- Mostrar aba selecionada
    if tabName == "Farm" then
        farmTab.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        farmTab.TextColor3 = Color3.new(1, 1, 1)
        farmContainer.Visible = true
    elseif tabName == "Marca" then
        marcaTab.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        marcaTab.TextColor3 = Color3.new(1, 1, 1)
        marcaContainer.Visible = true
    elseif tabName == "Skills" then
        skillsTab.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        skillsTab.TextColor3 = Color3.new(1, 1, 1)
        skillsContainer.Visible = true
    elseif tabName == "Aura" then
        auraTab.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        auraTab.TextColor3 = Color3.new(1, 1, 1)
        auraContainer.Visible = true
    elseif tabName == "Talismã" then
        talismaTab.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        talismaTab.TextColor3 = Color3.new(1, 1, 1)
        talismaContainer.Visible = true
    end
end

farmTab.MouseButton1Click:Connect(function() switchTab("Farm") end)
marcaTab.MouseButton1Click:Connect(function() switchTab("Marca") end)
skillsTab.MouseButton1Click:Connect(function() switchTab("Skills") end)
auraTab.MouseButton1Click:Connect(function() switchTab("Aura") end)
talismaTab.MouseButton1Click:Connect(function() switchTab("Talismã") end)

-- FUNÇÃO CRIAR BOTÃO
local function createButton(text, parent, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 340, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 100003
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0, 50, 0, 22)
    status.Position = UDim2.new(1, -55, 0.5, -11)
    status.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    status.TextColor3 = Color3.new(1, 1, 1)
    status.Text = "OFF"
    status.TextSize = 10
    status.Font = Enum.Font.GothamBold
    status.BorderSizePixel = 0
    status.ZIndex = 100004
    status.Parent = btn
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = status
    
    return btn, status
end

-- === ABA FARM ===
local clickButton, clickStatus = createButton("🖱️ AutoClick", farmContainer, 10)
local rebornButton, rebornStatus = createButton("🔄 AutoReborn", farmContainer, 60)
local openButton, openStatus = createButton("📦 AutoOpen Baús", farmContainer, 110)

-- === ABA MARCA (SIMPLIFICADO) ===
local toggleButton, toggleStatus = createButton("🎯 AutoReroll Marca", marcaContainer, 10)

local foundLabel = Instance.new("TextLabel")
foundLabel.Size = UDim2.new(0, 340, 0, 40)
foundLabel.Position = UDim2.new(0, 10, 0, 60)
foundLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
foundLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
foundLabel.TextSize = 12
foundLabel.Font = Enum.Font.GothamBold
foundLabel.Text = "🎯 Clique no botão acima para começar!\nO sistema vai girar até você desligar."
foundLabel.TextWrapped = true
foundLabel.BorderSizePixel = 0
foundLabel.Parent = marcaContainer

local foundCorner = Instance.new("UICorner")
foundCorner.CornerRadius = UDim.new(0, 10)
foundCorner.Parent = foundLabel

-- === ABA SKILLS ===
local respirationSkillButton, respirationSkillStatus = createButton("☠️ RespirationSkill", skillsContainer, 10)

-- Slider RespirationSkill
local respirationSliderLabel = Instance.new("TextLabel")
respirationSliderLabel.Size = UDim2.new(0, 340, 0, 20)
respirationSliderLabel.Position = UDim2.new(0, 10, 0, 60)
respirationSliderLabel.BackgroundTransparency = 1
respirationSliderLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
respirationSliderLabel.TextSize = 11
respirationSliderLabel.Font = Enum.Font.GothamBold
respirationSliderLabel.Text = string.format("Delay: %.2fs", RESPIRATION_SKILL_DELAY)
respirationSliderLabel.TextXAlignment = Enum.TextXAlignment.Left
respirationSliderLabel.Parent = skillsContainer

local respirationSliderBar = Instance.new("Frame")
respirationSliderBar.Size = UDim2.new(0, 340, 0, 8)
respirationSliderBar.Position = UDim2.new(0, 10, 0, 85)
respirationSliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
respirationSliderBar.BorderSizePixel = 0
respirationSliderBar.Parent = skillsContainer

local respirationSliderCorner = Instance.new("UICorner")
respirationSliderCorner.CornerRadius = UDim.new(1, 0)
respirationSliderCorner.Parent = respirationSliderBar

local respirationSliderFill = Instance.new("Frame")
respirationSliderFill.Size = UDim2.new(RESPIRATION_SKILL_DELAY/5, 0, 1, 0)
respirationSliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
respirationSliderFill.BorderSizePixel = 0
respirationSliderFill.Parent = respirationSliderBar

local respirationSliderFillCorner = Instance.new("UICorner")
respirationSliderFillCorner.CornerRadius = UDim.new(1, 0)
respirationSliderFillCorner.Parent = respirationSliderFill

-- === ABA AURA ===
local haloInfo = Instance.new("TextLabel")
haloInfo.Size = UDim2.new(0, 340, 0, 30)
haloInfo.Position = UDim2.new(0, 10, 0, 10)
haloInfo.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
haloInfo.TextColor3 = Color3.fromRGB(255, 215, 0)
haloInfo.TextSize = 12
haloInfo.Font = Enum.Font.GothamBold
haloInfo.Text = "✨ Sistema de Halos"
haloInfo.BorderSizePixel = 0
haloInfo.Parent = auraContainer

local haloInfoCorner = Instance.new("UICorner")
haloInfoCorner.CornerRadius = UDim.new(0, 10)
haloInfoCorner.Parent = haloInfo

local bronzeButton, bronzeStatus = createButton("🥉 Reroll Bronze", auraContainer, 50)
local ouroButton, ouroStatus = createButton("🥇 Reroll Ouro", auraContainer, 100)
local diamanteButton, diamanteStatus = createButton("💎 Reroll Diamante", auraContainer, 150)
local exchangeButton, exchangeStatus = createButton("🎁 Exchange Halo (Diamante)", auraContainer, 200)

-- Slider Exchange Halo
local exchangeSliderLabel = Instance.new("TextLabel")
exchangeSliderLabel.Size = UDim2.new(0, 340, 0, 20)
exchangeSliderLabel.Position = UDim2.new(0, 10, 0, 250)
exchangeSliderLabel.BackgroundTransparency = 1
exchangeSliderLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
exchangeSliderLabel.TextSize = 11
exchangeSliderLabel.Font = Enum.Font.GothamBold
exchangeSliderLabel.Text = string.format("Delay: %.2fs", EXCHANGE_HALO_DELAY)
exchangeSliderLabel.TextXAlignment = Enum.TextXAlignment.Left
exchangeSliderLabel.Parent = auraContainer

local exchangeSliderBar = Instance.new("Frame")
exchangeSliderBar.Size = UDim2.new(0, 340, 0, 8)
exchangeSliderBar.Position = UDim2.new(0, 10, 0, 275)
exchangeSliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
exchangeSliderBar.BorderSizePixel = 0
exchangeSliderBar.Parent = auraContainer

local exchangeSliderCorner = Instance.new("UICorner")
exchangeSliderCorner.CornerRadius = UDim.new(1, 0)
exchangeSliderCorner.Parent = exchangeSliderBar

local exchangeSliderFill = Instance.new("Frame")
exchangeSliderFill.Size = UDim2.new(EXCHANGE_HALO_DELAY/0.5, 0, 1, 0)
exchangeSliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
exchangeSliderFill.BorderSizePixel = 0
exchangeSliderFill.Parent = exchangeSliderBar

local exchangeSliderFillCorner = Instance.new("UICorner")
exchangeSliderFillCorner.CornerRadius = UDim.new(1, 0)
exchangeSliderFillCorner.Parent = exchangeSliderFill

-- === ABA TALISMÃ ===
local talismaInfo = Instance.new("TextLabel")
talismaInfo.Size = UDim2.new(0, 340, 0, 40)
talismaInfo.Position = UDim2.new(0, 10, 0, 10)
talismaInfo.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
talismaInfo.TextColor3 = Color3.fromRGB(255, 215, 0)
talismaInfo.TextSize = 11
talismaInfo.Font = Enum.Font.GothamBold
talismaInfo.Text = "💎 Sistema de Ornamentos\nClique para selecionar e equipar"
talismaInfo.TextWrapped = true
talismaInfo.BorderSizePixel = 0
talismaInfo.Parent = talismaContainer

local talismaInfoCorner = Instance.new("UICorner")
talismaInfoCorner.CornerRadius = UDim.new(0, 10)
talismaInfoCorner.Parent = talismaInfo

-- Criar botões de ornamentos
local ornamentButtons = {}
local yPos = 60
for name, config in pairs(ORNAMENTS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 340, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = "💎 " .. name
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = talismaContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    stroke.Parent = btn
    
    ornamentButtons[name] = {button = btn, stroke = stroke, config = config}
    yPos = yPos + 55
end

local equipButton = Instance.new("TextButton")
equipButton.Size = UDim2.new(0, 340, 0, 45)
equipButton.Position = UDim2.new(0, 10, 0, 230)
equipButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
equipButton.TextColor3 = Color3.new(1, 1, 1)
equipButton.Text = "⚡ EQUIPAR SELECIONADO"
equipButton.TextSize = 15
equipButton.Font = Enum.Font.GothamBold
equipButton.BorderSizePixel = 0
equipButton.AutoButtonColor = false
equipButton.Parent = talismaContainer

local equipCorner = Instance.new("UICorner")
equipCorner.CornerRadius = UDim.new(0, 10)
equipCorner.Parent = equipButton

local talismaDesc = Instance.new("TextLabel")
talismaDesc.Size = UDim2.new(0, 340, 0, 35)
talismaDesc.Position = UDim2.new(0, 10, 0, 285)
talismaDesc.BackgroundTransparency = 1
talismaDesc.TextColor3 = Color3.fromRGB(150, 150, 180)
talismaDesc.TextSize = 10
talismaDesc.Font = Enum.Font.Gotham
talismaDesc.Text = "Selecione um ornamento e clique em EQUIPAR\nDMG = Dano | Power = Poder | Lucky = Sorte"
talismaDesc.TextWrapped = true
talismaDesc.Parent = talismaContainer

-- FUNÇÕES
local function autoClick()
    while AUTO_CLICK_ATIVO do
        pcall(function()
            local args = {{}}
            clickRemote:FireServer(unpack(args))
        end)
        task.wait(0.001)
    end
end

local function autoReborn()
    while AUTO_REBORN_ATIVO do
        pcall(function()
            rebornRemote:FireServer()
        end)
        task.wait(1)
    end
end

local function autoOpenBaus()
    local baus = {820001, 820002, 820003, 820004, 820005}
    while AUTO_OPEN_ATIVO do
        for _, bauID in ipairs(baus) do
            pcall(function()
                openBoxRemote:FireServer(bauID)
            end)
            task.wait(0.01)
        end
    end
end

local function autoRespirationSkill()
    while AUTO_RESPIRATION_SKILL_ATIVO do
        for i = 1, 5 do
            local args = {{
                harmIndex = i,
                skillType = 2,
                skillGemKey = "9_2",
                skillId = 200401
            }}
            pcall(function()
                respirationSkillRemote:FireServer(unpack(args))
            end)
        end
        task.wait(RESPIRATION_SKILL_DELAY)
    end
end

local function autoHaloBronze()
    while AUTO_HALO_BRONZE_ATIVO do
        pcall(function()
            rerollHaloRemote:InvokeServer(1)
        end)
        task.wait(HALO_DELAY)
    end
end

local function autoHaloOuro()
    while AUTO_HALO_OURO_ATIVO do
        pcall(function()
            rerollHaloRemote:InvokeServer(2)
        end)
        task.wait(HALO_DELAY)
    end
end

local function autoHaloDiamante()
    while AUTO_HALO_DIAMANTE_ATIVO do
        pcall(function()
            rerollHaloRemote:InvokeServer(3)
        end)
        task.wait(HALO_DELAY)
    end
end

local function autoExchangeHalo()
    while AUTO_EXCHANGE_HALO_ATIVO do
        pcall(function()
            local args = {{
                haloType = 3,
                count = 1
            }}
            exchangeHaloRemote:InvokeServer(unpack(args))
        end)
        task.wait(EXCHANGE_HALO_DELAY)
    end
end

local function autoReroll()
    while AUTO_REROLL_ATIVO do
        pcall(function()
            rerollRemote:InvokeServer(ORNAMENT_ID)
        end)
        task.wait(DELAY_REROLL)
    end
end

-- TOGGLES ABA FARM
clickButton.MouseButton1Click:Connect(function()
    AUTO_CLICK_ATIVO = not AUTO_CLICK_ATIVO
    clickStatus.Text = AUTO_CLICK_ATIVO and "ON" or "OFF"
    clickStatus.BackgroundColor3 = AUTO_CLICK_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if AUTO_CLICK_ATIVO then task.spawn(autoClick) end
end)

rebornButton.MouseButton1Click:Connect(function()
    AUTO_REBORN_ATIVO = not AUTO_REBORN_ATIVO
    rebornStatus.Text = AUTO_REBORN_ATIVO and "ON" or "OFF"
    rebornStatus.BackgroundColor3 = AUTO_REBORN_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if AUTO_REBORN_ATIVO then task.spawn(autoReborn) end
end)

openButton.MouseButton1Click:Connect(function()
    AUTO_OPEN_ATIVO = not AUTO_OPEN_ATIVO
    openStatus.Text = AUTO_OPEN_ATIVO and "ON" or "OFF"
    openStatus.BackgroundColor3 = AUTO_OPEN_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if AUTO_OPEN_ATIVO then task.spawn(autoOpenBaus) end
end)

-- TOGGLE ABA MARCA (SIMPLIFICADO)
toggleButton.MouseButton1Click:Connect(function()
    AUTO_REROLL_ATIVO = not AUTO_REROLL_ATIVO
    toggleStatus.Text = AUTO_REROLL_ATIVO and "ON" or "OFF"
    toggleStatus.BackgroundColor3 = AUTO_REROLL_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    
    if AUTO_REROLL_ATIVO then
        foundLabel.Text = "🎯 Girando marca automaticamente...\nClique novamente para parar."
        task.spawn(autoReroll)
    else
        foundLabel.Text = "🎯 Sistema parado!\nClique no botão acima para começar."
    end
end)

-- TOGGLES ABA SKILLS
respirationSkillButton.MouseButton1Click:Connect(function()
    AUTO_RESPIRATION_SKILL_ATIVO = not AUTO_RESPIRATION_SKILL_ATIVO
    respirationSkillStatus.Text = AUTO_RESPIRATION_SKILL_ATIVO and "ON" or "OFF"
    respirationSkillStatus.BackgroundColor3 = AUTO_RESPIRATION_SKILL_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if AUTO_RESPIRATION_SKILL_ATIVO then task.spawn(autoRespirationSkill) end
end)

-- TOGGLES ABA AURA
bronzeButton.MouseButton1Click:Connect(function()
    AUTO_HALO_BRONZE_ATIVO = not AUTO_HALO_BRONZE_ATIVO
    bronzeStatus.Text = AUTO_HALO_BRONZE_ATIVO and "ON" or "OFF"
    bronzeStatus.BackgroundColor3 = AUTO_HALO_BRONZE_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if AUTO_HALO_BRONZE_ATIVO then task.spawn(autoHaloBronze) end
end)

ouroButton.MouseButton1Click:Connect(function()
    AUTO_HALO_OURO_ATIVO = not AUTO_HALO_OURO_ATIVO
    ouroStatus.Text = AUTO_HALO_OURO_ATIVO and "ON" or "OFF"
    ouroStatus.BackgroundColor3 = AUTO_HALO_OURO_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if AUTO_HALO_OURO_ATIVO then task.spawn(autoHaloOuro) end
end)

diamanteButton.MouseButton1Click:Connect(function()
    AUTO_HALO_DIAMANTE_ATIVO = not AUTO_HALO_DIAMANTE_ATIVO
    diamanteStatus.Text = AUTO_HALO_DIAMANTE_ATIVO and "ON" or "OFF"
    diamanteStatus.BackgroundColor3 = AUTO_HALO_DIAMANTE_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if AUTO_HALO_DIAMANTE_ATIVO then task.spawn(autoHaloDiamante) end
end)

exchangeButton.MouseButton1Click:Connect(function()
    AUTO_EXCHANGE_HALO_ATIVO = not AUTO_EXCHANGE_HALO_ATIVO
    exchangeStatus.Text = AUTO_EXCHANGE_HALO_ATIVO and "ON" or "OFF"
    exchangeStatus.BackgroundColor3 = AUTO_EXCHANGE_HALO_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if AUTO_EXCHANGE_HALO_ATIVO then task.spawn(autoExchangeHalo) end
end)

-- TOGGLES ABA TALISMÃ
for name, data in pairs(ornamentButtons) do
    data.button.MouseButton1Click:Connect(function()
        -- Desselecionar todos
        for n, d in pairs(ornamentButtons) do
            d.button.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
            d.stroke.Color = Color3.fromRGB(60, 60, 80)
            d.stroke.Transparency = 0.5
        end
        
        -- Selecionar o clicado
        data.button.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
        data.stroke.Color = Color3.fromRGB(100, 180, 255)
        data.stroke.Transparency = 0
        ornamentSelecionado = name
        
        talismaDesc.Text = "✅ " .. name .. " selecionado!\nClique em EQUIPAR para usar."
        talismaDesc.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)
end

equipButton.MouseButton1Click:Connect(function()
    if not ornamentSelecionado then
        talismaDesc.Text = "⚠️ Selecione um ornamento primeiro!\nClique em um dos ornamentos acima."
        talismaDesc.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local config = ORNAMENTS[ornamentSelecionado]
    local args = {{
        ornamentId = config.ornamentId,
        machineId = config.machineId,
        isEquip = true
    }}
    
    pcall(function()
        local result = useOrnamentRemote:InvokeServer(unpack(args))
        print(string.format("✅ Ornamento %s equipado! Retorno: %s", 
            ornamentSelecionado,
            tostring(result)
        ))
    end)
    
    talismaDesc.Text = "✅ " .. ornamentSelecionado .. " equipado com sucesso!\nSelecione outro para equipar novamente."
    talismaDesc.TextColor3 = Color3.fromRGB(100, 255, 100)
end)

-- SLIDERS
local respirationDragging = false
local exchangeDragging = false

local function updateRespirationSlider(input)
    local relativeX = math.clamp(input.Position.X - respirationSliderBar.AbsolutePosition.X, 0, respirationSliderBar.AbsoluteSize.X)
    RESPIRATION_SKILL_DELAY = math.clamp((relativeX / respirationSliderBar.AbsoluteSize.X) * 5, 0.01, 5)
    respirationSliderFill.Size = UDim2.new(relativeX / respirationSliderBar.AbsoluteSize.X, 0, 1, 0)
    respirationSliderLabel.Text = string.format("Delay: %.2fs", RESPIRATION_SKILL_DELAY)
end

local function updateExchangeSlider(input)
    local relativeX = math.clamp(input.Position.X - exchangeSliderBar.AbsolutePosition.X, 0, exchangeSliderBar.AbsoluteSize.X)
    EXCHANGE_HALO_DELAY = math.clamp((relativeX / exchangeSliderBar.AbsoluteSize.X) * 0.5, 0.01, 0.51)
    exchangeSliderFill.Size = UDim2.new(relativeX / exchangeSliderBar.AbsoluteSize.X, 0, 1, 0)
    exchangeSliderLabel.Text = string.format("Delay: %.2fs", EXCHANGE_HALO_DELAY)
end

respirationSliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        respirationDragging = true
        updateRespirationSlider(input)
    end
end)

respirationSliderBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        respirationDragging = false
    end
end)

exchangeSliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        exchangeDragging = true
        updateExchangeSlider(input)
    end
end)

exchangeSliderBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        exchangeDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if respirationDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        pcall(function() updateRespirationSlider(input) end)
    end
    if exchangeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        pcall(function() updateExchangeSlider(input) end)
    end
end)

-- Inicializar na aba Farm
switchTab("Farm")

print("✅ HUB DiuaryOG v3.2 carregado com sucesso!")