-- HUB DIUARYOG PROFISSIONAL COM ABAS v3.1
-- By DiuaryOG 💙

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
local angrySkillRemote = ReplicatedStorage.Remotes.PlayerAngrySkillHarm
local heroSkillRemote = ReplicatedStorage.Remotes.HeroSkillHarm
local rerollHaloRemote = ReplicatedStorage.Remotes.RerollHalo

-- CONFIG
local ORNAMENT_ID = 400002
local DELAY_REROLL = 0.1
local AUTO_REROLL_ATIVO = false
local AUTO_CLICK_ATIVO = false
local AUTO_REBORN_ATIVO = false
local AUTO_OPEN_ATIVO = false
local AUTO_ANGRY_SKILL_ATIVO = false
local AUTO_HERO_SKILL_ATIVO = false
local AUTO_HALO_BRONZE_ATIVO = false
local AUTO_HALO_OURO_ATIVO = false
local AUTO_HALO_DIAMANTE_ATIVO = false
local ANGRY_SKILL_DELAY = 1
local HERO_SKILL_DELAY = 0.01
local HALO_DELAY = 0.001
local STRIPES_DESEJADOS = {}
local KEYS_VALIDAS = { "luh", "fifa" }
local ABA_ATUAL = "Farm"

-- Lista de heróis e skills
local heroesSkills = {
    {
        heroGuid = "b01ae2c8-ac0e-4712-bd76-c56e3072d109",
        skillId = 200616,
        harmIndex = 15
    },
    {
        heroGuid = "b8481640-e554-4df7-8b4e-d54fb530b918",
        skillId = 200616,
        harmIndex = 15
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
screenGui.Parent = playerGui

-- FRAME PRINCIPAL
local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 500, 0, 400)
hubFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
hubFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
hubFrame.BorderSizePixel = 0
hubFrame.Active = true
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
version.Parent = header

-- BOTÃO MINIMIZAR
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -50, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 10)
minCorner.Parent = minimizeBtn

-- SIDEBAR (MENU LATERAL)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -50)
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
sidebar.BorderSizePixel = 0
sidebar.Parent = hubFrame

-- CONTENT AREA
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -130, 1, -60)
contentArea.Position = UDim2.new(0, 130, 0, 60)
contentArea.BackgroundTransparency = 1
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
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    minimizeBtn.Text = minimized and "+" or "─"
    
    sidebar.Visible = not minimized
    contentArea.Visible = not minimized
    
    if minimized then
        hubFrame:TweenSize(
            UDim2.new(0, 500, 0, 50),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
    else
        hubFrame:TweenSize(
            UDim2.new(0, 500, 0, 400),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
    end
end)

-- CRIAR BOTÃO DE ABA
local function createTabButton(text, icon, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 45)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.TextColor3 = Color3.fromRGB(150, 150, 180)
    btn.Text = icon .. "\n" .. text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    return btn
end

-- CRIAR ABAS
local farmTab = createTabButton("Farm", "🎮", 10)
local marcaTab = createTabButton("Marca", "🎯", 65)
local skillsTab = createTabButton("Skills", "⚡", 120)
local auraTab = createTabButton("Aura", "✨", 175)

-- CONTAINERS DAS ABAS
local farmContainer = Instance.new("Frame")
farmContainer.Size = UDim2.new(1, 0, 1, 0)
farmContainer.BackgroundTransparency = 1
farmContainer.Visible = true
farmContainer.Parent = contentArea

local marcaContainer = Instance.new("Frame")
marcaContainer.Size = UDim2.new(1, 0, 1, 0)
marcaContainer.BackgroundTransparency = 1
marcaContainer.Visible = false
marcaContainer.Parent = contentArea

local skillsContainer = Instance.new("Frame")
skillsContainer.Size = UDim2.new(1, 0, 1, 0)
skillsContainer.BackgroundTransparency = 1
skillsContainer.Visible = false
skillsContainer.Parent = contentArea

local auraContainer = Instance.new("Frame")
auraContainer.Size = UDim2.new(1, 0, 1, 0)
auraContainer.BackgroundTransparency = 1
auraContainer.Visible = false
auraContainer.Parent = contentArea

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
    
    -- Esconder todos
    farmContainer.Visible = false
    marcaContainer.Visible = false
    skillsContainer.Visible = false
    auraContainer.Visible = false
    
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
    end
end

farmTab.MouseButton1Click:Connect(function() switchTab("Farm") end)
marcaTab.MouseButton1Click:Connect(function() switchTab("Marca") end)
skillsTab.MouseButton1Click:Connect(function() switchTab("Skills") end)
auraTab.MouseButton1Click:Connect(function() switchTab("Aura") end)

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

-- === ABA MARCA ===
local toggleButton, toggleStatus = createButton("🎯 AutoReroll Marca", marcaContainer, 10)

local foundLabel = Instance.new("TextLabel")
foundLabel.Size = UDim2.new(0, 340, 0, 30)
foundLabel.Position = UDim2.new(0, 10, 0, 60)
foundLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
foundLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
foundLabel.TextSize = 12
foundLabel.Font = Enum.Font.GothamBold
foundLabel.Text = "🎯 Status: Aguardando..."
foundLabel.BorderSizePixel = 0
foundLabel.Parent = marcaContainer

local foundCorner = Instance.new("UICorner")
foundCorner.CornerRadius = UDim.new(0, 10)
foundCorner.Parent = foundLabel

local stripesLabel = Instance.new("TextLabel")
stripesLabel.Size = UDim2.new(0, 200, 0, 20)
stripesLabel.Position = UDim2.new(0, 10, 0, 100)
stripesLabel.BackgroundTransparency = 1
stripesLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
stripesLabel.TextSize = 11
stripesLabel.Font = Enum.Font.GothamBold
stripesLabel.Text = "SELECIONAR STRIPES"
stripesLabel.TextXAlignment = Enum.TextXAlignment.Left
stripesLabel.Parent = marcaContainer

-- CHECKBOXES
for i = 1, 9 do
    local stripeName = "Stripe" .. i
    local row = math.floor((i - 1) / 3)
    local col = (i - 1) % 3
    
    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 105, 0, 32)
    cb.Position = UDim2.new(0, 10 + (col * 110), 0, 130 + (row * 37))
    cb.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    cb.TextColor3 = Color3.new(1, 1, 1)
    cb.Text = stripeName
    cb.TextSize = 12
    cb.Font = Enum.Font.GothamBold
    cb.BorderSizePixel = 0
    cb.AutoButtonColor = false
    cb.Parent = marcaContainer

    local cbCorner = Instance.new("UICorner")
    cbCorner.CornerRadius = UDim.new(0, 10)
    cbCorner.Parent = cb

    local cbStroke = Instance.new("UIStroke")
    cbStroke.Color = Color3.fromRGB(60, 60, 80)
    cbStroke.Thickness = 1
    cbStroke.Transparency = 0.6
    cbStroke.Parent = cb

    cb.MouseButton1Click:Connect(function()
        local selecionado = false
        for idx, name in ipairs(STRIPES_DESEJADOS) do
            if name == stripeName then
                table.remove(STRIPES_DESEJADOS, idx)
                selecionado = true
                cb.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                cbStroke.Color = Color3.fromRGB(60, 60, 80)
                break
            end
        end
        if not selecionado then
            table.insert(STRIPES_DESEJADOS, stripeName)
            cb.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
            cbStroke.Color = Color3.fromRGB(100, 255, 100)
        end
        foundLabel.Text = "🎯 " .. #STRIPES_DESEJADOS .. " stripe(s) selecionado(s)"
    end)
end

-- === ABA SKILLS ===
local angrySkillButton, angrySkillStatus = createButton("☠️ AutoAngrySkill", skillsContainer, 10)
local heroSkillButton, heroSkillStatus = createButton("⚔️ AutoHeroSkill", skillsContainer, 110)

-- Slider Angry Skill
local angrySliderLabel = Instance.new("TextLabel")
angrySliderLabel.Size = UDim2.new(0, 340, 0, 20)
angrySliderLabel.Position = UDim2.new(0, 10, 0, 60)
angrySliderLabel.BackgroundTransparency = 1
angrySliderLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
angrySliderLabel.TextSize = 11
angrySliderLabel.Font = Enum.Font.GothamBold
angrySliderLabel.Text = string.format("Delay: %.2fs", ANGRY_SKILL_DELAY)
angrySliderLabel.TextXAlignment = Enum.TextXAlignment.Left
angrySliderLabel.Parent = skillsContainer

local angrySliderBar = Instance.new("Frame")
angrySliderBar.Size = UDim2.new(0, 340, 0, 8)
angrySliderBar.Position = UDim2.new(0, 10, 0, 85)
angrySliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
angrySliderBar.BorderSizePixel = 0
angrySliderBar.Parent = skillsContainer

local angrySliderCorner = Instance.new("UICorner")
angrySliderCorner.CornerRadius = UDim.new(1, 0)
angrySliderCorner.Parent = angrySliderBar

local angrySliderFill = Instance.new("Frame")
angrySliderFill.Size = UDim2.new(ANGRY_SKILL_DELAY/5, 0, 1, 0)
angrySliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
angrySliderFill.BorderSizePixel = 0
angrySliderFill.Parent = angrySliderBar

local angrySliderFillCorner = Instance.new("UICorner")
angrySliderFillCorner.CornerRadius = UDim.new(1, 0)
angrySliderFillCorner.Parent = angrySliderFill

-- Slider Hero Skill
local heroSliderLabel = Instance.new("TextLabel")
heroSliderLabel.Size = UDim2.new(0, 340, 0, 20)
heroSliderLabel.Position = UDim2.new(0, 10, 0, 160)
heroSliderLabel.BackgroundTransparency = 1
heroSliderLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
heroSliderLabel.TextSize = 11
heroSliderLabel.Font = Enum.Font.GothamBold
heroSliderLabel.Text = string.format("Delay: %.2fs", HERO_SKILL_DELAY)
heroSliderLabel.TextXAlignment = Enum.TextXAlignment.Left
heroSliderLabel.Parent = skillsContainer

local heroSliderBar = Instance.new("Frame")
heroSliderBar.Size = UDim2.new(0, 340, 0, 8)
heroSliderBar.Position = UDim2.new(0, 10, 0, 185)
heroSliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
heroSliderBar.BorderSizePixel = 0
heroSliderBar.Parent = skillsContainer

local heroSliderCorner = Instance.new("UICorner")
heroSliderCorner.CornerRadius = UDim.new(1, 0)
heroSliderCorner.Parent = heroSliderBar

local heroSliderFill = Instance.new("Frame")
heroSliderFill.Size = UDim2.new(HERO_SKILL_DELAY/5, 0, 1, 0)
heroSliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
heroSliderFill.BorderSizePixel = 0
heroSliderFill.Parent = heroSliderBar

local heroSliderFillCorner = Instance.new("UICorner")
heroSliderFillCorner.CornerRadius = UDim.new(1, 0)
heroSliderFillCorner.Parent = heroSliderFill

-- === ABA AURA ===
local haloInfo = Instance.new("TextLabel")
haloInfo.Size = UDim2.new(0, 340, 0, 30)
haloInfo.Position = UDim2.new(0, 10, 0, 10)
haloInfo.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
haloInfo.TextColor3 = Color3.fromRGB(255, 215, 0)
haloInfo.TextSize = 12
haloInfo.Font = Enum.Font.GothamBold
haloInfo.Text = "✨ Reroll de Halos Automático"
haloInfo.BorderSizePixel = 0
haloInfo.Parent = auraContainer

local haloInfoCorner = Instance.new("UICorner")
haloInfoCorner.CornerRadius = UDim.new(0, 10)
haloInfoCorner.Parent = haloInfo

local bronzeButton, bronzeStatus = createButton("🥉 Halo Bronze", auraContainer, 50)
local ouroButton, ouroStatus = createButton("🥇 Halo Ouro", auraContainer, 100)
local diamanteButton, diamanteStatus = createButton("💎 Halo Diamante", auraContainer, 150)

-- FUNÇÕES
local function detectarStripes()
    local stripes = {}
    local pasta = Workspace:FindFirstChild(LocalPlayer.Name)
    if pasta then
        for _, obj in pairs(pasta:GetDescendants()) do
            if string.match(obj.Name, "^Stripe%d+$") then
                table.insert(stripes, obj)
            end
        end
    end
    return stripes
end

local function autoClick()
    while AUTO_CLICK_ATIVO do
        pcall(function()
            local args = {{}}
            clickRemote:FireServer(unpack(args))
        end)
        task.wait(0.01)
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

local function autoAngrySkill()
    while AUTO_ANGRY_SKILL_ATIVO do
        local args = {{["harmIndex"]=2,["skillId"]=200410}}
        pcall(function()
            angrySkillRemote:FireServer(unpack(args))
        end)
        task.wait(ANGRY_SKILL_DELAY)
    end
end

local function usarHeroSkills()
    for _, hero in ipairs(heroesSkills) do
        local args = {{
            harmIndex = hero.harmIndex,
            isSkill = true,
            heroGuid = hero.heroGuid,
            skillId = hero.skillId
        }}
        pcall(function()
            heroSkillRemote:FireServer(unpack(args))
        end)
        task.wait(0.01)
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

local function autoReroll()
    while AUTO_REROLL_ATIVO do
        pcall(function()
            rerollRemote:InvokeServer(ORNAMENT_ID)
        end)
        
        task.wait(0.01)
        
        local todosStripes = detectarStripes()
        local achou = false
        
        for _, stripe in pairs(todosStripes) do
            for _, name in ipairs(STRIPES_DESEJADOS) do
                if stripe.Name == name then
                    foundLabel.Text = "🎯 Encontrado: " .. name .. "!"
                    AUTO_REROLL_ATIVO = false
                    toggleStatus.Text = "OFF"
                    toggleStatus.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                    achou = true
                    break
                end
            end
            if achou then break end
        end
        
        if achou then
            return
        end
        
        task.wait(DELAY_REROLL)
    end
end

-- TOGGLES
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

angrySkillButton.MouseButton1Click:Connect(function()
    AUTO_ANGRY_SKILL_ATIVO = not AUTO_ANGRY_SKILL_ATIVO
    angrySkillStatus.Text = AUTO_ANGRY_SKILL_ATIVO and "ON" or "OFF"
    angrySkillStatus.BackgroundColor3 = AUTO_ANGRY_SKILL_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if AUTO_ANGRY_SKILL_ATIVO then task.spawn(autoAngrySkill) end
end)

heroSkillButton.MouseButton1Click:Connect(function()
    AUTO_HERO_SKILL_ATIVO = not AUTO_HERO_SKILL_ATIVO
    heroSkillStatus.Text = AUTO_HERO_SKILL_ATIVO and "ON" or "OFF"
    heroSkillStatus.BackgroundColor3 = AUTO_HERO_SKILL_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if AUTO_HERO_SKILL_ATIVO then
        task.spawn(function()
            while AUTO_HERO_SKILL_ATIVO do
                usarHeroSkills()
                task.wait(HERO_SKILL_DELAY)
            end
        end)
    end
end)

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

toggleButton.MouseButton1Click:Connect(function()
    if #STRIPES_DESEJADOS == 0 then
        foundLabel.Text = "⚠️ Selecione pelo menos 1 stripe!"
        return
    end
    AUTO_REROLL_ATIVO = not AUTO_REROLL_ATIVO
    toggleStatus.Text = AUTO_REROLL_ATIVO and "ON" or "OFF"
    toggleStatus.BackgroundColor3 = AUTO_REROLL_ATIVO and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if AUTO_REROLL_ATIVO then
        foundLabel.Text = "🎯 Procurando stripe..."
        task.spawn(autoReroll)
    else
        foundLabel.Text = "🎯 Status: Parado"
    end
end)

-- SLIDERS
local angryDragging = false
local heroDragging = false

local function updateAngrySlider(input)
    local relativeX = math.clamp(input.Position.X - angrySliderBar.AbsolutePosition.X, 0, angrySliderBar.AbsoluteSize.X)
    ANGRY_SKILL_DELAY = math.clamp((relativeX / angrySliderBar.AbsoluteSize.X) * 5, 0.01, 5)
    angrySliderFill.Size = UDim2.new(relativeX / angrySliderBar.AbsoluteSize.X, 0, 1, 0)
    angrySliderLabel.Text = string.format("Delay: %.2fs", ANGRY_SKILL_DELAY)
end

local function updateHeroSlider(input)
    local relativeX = math.clamp(input.Position.X - heroSliderBar.AbsolutePosition.X, 0, heroSliderBar.AbsoluteSize.X)
    HERO_SKILL_DELAY = math.clamp((relativeX / heroSliderBar.AbsoluteSize.X) * 5, 0.01, 5)
    heroSliderFill.Size = UDim2.new(relativeX / heroSliderBar.AbsoluteSize.X, 0, 1, 0)
    heroSliderLabel.Text = string.format("Delay: %.2fs", HERO_SKILL_DELAY)
end

angrySliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        angryDragging = true
        updateAngrySlider(input)
    end
end)

angrySliderBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        angryDragging = false
    end
end)

heroSliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        heroDragging = true
        updateHeroSlider(input)
    end
end)

heroSliderBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        heroDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if angryDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        pcall(function() updateAngrySlider(input) end)
    end
    if heroDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        pcall(function() updateHeroSlider(input) end)
    end
end)

-- Inicializar na aba Farm
switchTab("Farm")

print("✅ HUB DiuaryOG v3.1 carregado!")
print("📌 4 Abas: Farm, Marca, Skills, Aura")
print("🎮 Tudo funcional e corrigido!")