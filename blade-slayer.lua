-- HUB DIUARYOG PROFISSIONAL v3.2 - Layout Premium
-- By DiuaryOG 💙

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
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

-- Estados globais
_G.AUTO_CLICK_ATIVO = false
_G.AUTO_REBORN_ATIVO = false
_G.AUTO_OPEN_ATIVO = false
_G.AUTO_REROLL_ATIVO = false
_G.AUTO_RESPIRATION_SKILL_ATIVO = false
_G.AUTO_HALO_BRONZE_ATIVO = false
_G.AUTO_HALO_OURO_ATIVO = false
_G.AUTO_HALO_DIAMANTE_ATIVO = false
_G.AUTO_EXCHANGE_HALO_ATIVO = false

-- Ornamentos Config
local ORNAMENTS = {
    DMG = { ornamentId = 410028, machineId = 400005 },
    Power = { ornamentId = 410026, machineId = 400005 },
    Lucky = { ornamentId = 410025, machineId = 400005 }
}

-- FLAGS E ESTADOS
local ABA_ATUAL = "Farm"
local taskRunningFlags = {}
local function setFlag(name, v) taskRunningFlags[name] = v end
local function getFlag(name) return taskRunningFlags[name] end

-- Full DMG (detecção)
local detectedHeroes = {}

-- SISTEMA DE KEY
local function verificarKey()
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
    Frame.Size = UDim2.new(0, 400, 0, 280)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -140)
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
    SubTitle.Size = UDim2.new(1, -40, 0, 20)
    SubTitle.Position = UDim2.new(0, 20, 0, 110)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Digite sua chave de acesso para continuar"
    SubTitle.TextColor3 = Color3.fromRGB(120, 120, 140)
    SubTitle.TextSize = 11
    SubTitle.Font = Enum.Font.Gotham

    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(0, 340, 0, 45)
    TextBox.Position = UDim2.new(0.5, -170, 0, 145)
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
    ConfirmButton.Position = UDim2.new(0.5, -170, 0, 205)
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
    StatusLabel.Size = UDim2.new(1, -40, 0, 20)
    StatusLabel.Position = UDim2.new(0, 20, 0, 255)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.Text = ""

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
        for _, key in pairs(KEYS_VALIDAS) do
            if keyInput == key then
                keyValida = true
                StatusLabel.Text = "✓ Autenticação bem-sucedida!"
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
                ConfirmButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                ConfirmButton.Text = "✓ SUCESSO"
                TextBoxStroke.Color = Color3.fromRGB(50, 200, 100)
                task.wait(1)
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

-- Floating button
local floatingButton = Instance.new("TextButton", screenGui)
floatingButton.Size = UDim2.new(0, 70, 0, 70)
floatingButton.Position = UDim2.new(0, 25, 0.5, -35)
floatingButton.BackgroundColor3 = Color3.fromRGB(25,25,35)
floatingButton.BorderSizePixel = 0
floatingButton.Text = ""
floatingButton.AutoButtonColor = false
floatingButton.ZIndex = 99999

local floatingCorner = Instance.new("UICorner", floatingButton)
floatingCorner.CornerRadius = UDim.new(1,0)

local floatingStroke = Instance.new("UIStroke", floatingButton)
floatingStroke.Color = Color3.fromRGB(80,140,255)
floatingStroke.Thickness = 3
floatingStroke.Transparency = 0.3

local floatingIcon = Instance.new("TextLabel", floatingButton)
floatingIcon.Size = UDim2.new(1,0,1,0)
floatingIcon.BackgroundTransparency = 1
floatingIcon.Text = "🥀"
floatingIcon.TextColor3 = Color3.fromRGB(150,200,255)
floatingIcon.TextSize = 35
floatingIcon.Font = Enum.Font.GothamBold

-- Pulse animation
task.spawn(function()
    while task.wait() do
        TweenService:Create(floatingButton, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Size = UDim2.new(0,75,0,75)}):Play()
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

-- Main hub frame
local hubFrame = Instance.new("Frame", screenGui)
hubFrame.Size = UDim2.new(0, 650, 0, 480)
hubFrame.Position = UDim2.new(0.5, -325, 0.5, -240)
hubFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
hubFrame.BorderSizePixel = 0
hubFrame.Visible = false
hubFrame.ZIndex = 100000

local hubCorner = Instance.new("UICorner", hubFrame)
hubCorner.CornerRadius = UDim.new(0,20)

local hubStroke = Instance.new("UIStroke", hubFrame)
hubStroke.Color = Color3.fromRGB(80,140,255)
hubStroke.Thickness = 2
hubStroke.Transparency = 0.6

-- Accent line
local accentLine = Instance.new("Frame", hubFrame)
accentLine.Size = UDim2.new(1,0,0,3)
accentLine.Position = UDim2.new(0,0,0,0)
accentLine.BackgroundColor3 = Color3.fromRGB(80,140,255)
accentLine.BorderSizePixel = 0

local accentCorner = Instance.new("UICorner", accentLine)
accentCorner.CornerRadius = UDim.new(0,20)

-- Header
local header = Instance.new("Frame", hubFrame)
header.Size = UDim2.new(1,0,0,65)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = Color3.fromRGB(20,20,28)
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0,20)

local headerGradient = Instance.new("UIGradient", header)
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,20))
}
headerGradient.Rotation = 90

local logoIcon = Instance.new("TextLabel", header)
logoIcon.Size = UDim2.new(0,50,0,50)
logoIcon.Position = UDim2.new(0,20,0,7)
logoIcon.BackgroundTransparency = 1
logoIcon.Text = "🥀"
logoIcon.TextSize = 32
logoIcon.Font = Enum.Font.GothamBold

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0,300,0,30)
title.Position = UDim2.new(0,75,0,10)
title.BackgroundTransparency = 1
title.Text = "DIUARY HUB"
title.TextColor3 = Color3.fromRGB(180,220,255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local titleGradient = Instance.new("UIGradient", title)
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150,200,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80,140,255))
}

local version = Instance.new("TextLabel", header)
version.Size = UDim2.new(0,100,0,18)
version.Position = UDim2.new(0,75,0,40)
version.BackgroundTransparency = 1
version.Text = "vivian"
version.TextColor3 = Color3.fromRGB(100,120,150)
version.TextSize = 10
version.Font = Enum.Font.GothamMedium
version.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,45,0,45)
closeBtn.Position = UDim2.new(1, -60, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,55)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,100,120)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,12)

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
    hubFrame.Size = UDim2.new(0, 650, 0, 480)
    hubFrame.Position = UDim2.new(0.5, -325, 0.5, -240)
    floatingButton.Visible = true
end)

floatingButton.MouseButton1Click:Connect(function()
    hubFrame.Visible = true
    hubFrame.Size = UDim2.new(0,0,0,0)
    hubFrame.Position = UDim2.new(0.5,0,0.5,0)
    TweenService:Create(hubFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 650, 0, 480), Position = UDim2.new(0.5, -325, 0.5, -240)}):Play()
    floatingButton.Visible = false
end)

-- Sidebar
local sidebar = Instance.new("Frame", hubFrame)
sidebar.Size = UDim2.new(0,150,1,-75)
sidebar.Position = UDim2.new(0,10,0,70)
sidebar.BackgroundColor3 = Color3.fromRGB(20,20,28)
sidebar.BorderSizePixel = 0

local sidebarCorner = Instance.new("UICorner", sidebar)
sidebarCorner.CornerRadius = UDim.new(0,15)

local sidebarStroke = Instance.new("UIStroke", sidebar)
sidebarStroke.Color = Color3.fromRGB(40,40,55)
sidebarStroke.Thickness = 1

local contentArea = Instance.new("Frame", hubFrame)
contentArea.Size = UDim2.new(1, -180, 1, -85)
contentArea.Position = UDim2.new(0,170,0,75)
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

-- Tab button creator
local function createTabButton(text, icon, yPos)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0,130,0,50)
    btn.Position = UDim2.new(0,10,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,35)
    btn.TextColor3 = Color3.fromRGB(120,140,180)
    btn.Text = ""
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,12)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(40,40,55)
    stroke.Thickness = 1
    stroke.Transparency = 0.5

    local iconLabel = Instance.new("TextLabel", btn)
    iconLabel.Size = UDim2.new(0,35,0,35)
    iconLabel.Position = UDim2.new(0,10,0,7)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 20
    iconLabel.Font = Enum.Font.GothamBold

    local textLabel = Instance.new("TextLabel", btn)
    textLabel.Size = UDim2.new(0,70,0,50)
    textLabel.Position = UDim2.new(0,50,0,0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(120,140,180)
    textLabel.TextSize = 13
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

-- Create tabs
local farmTab, farmIcon, farmText, farmStroke = createTabButton("Farm","🎮",10)
local marcaTab, marcaIcon, marcaText, marcaStroke = createTabButton("Marca","🎯",70)
local skillsTab, skillsIcon, skillsText, skillsStroke = createTabButton("Skills","⚡",130)
local auraTab, auraIcon, auraText, auraStroke = createTabButton("Aura","✨",190)
local talismaTab, talismaIcon, talismaText, talismaStroke = createTabButton("Talismã","💎",250)

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
    local tabs = {
        {btn = farmTab, icon = farmIcon, text = farmText, stroke = farmStroke},
        {btn = marcaTab, icon = marcaIcon, text = marcaText, stroke = marcaStroke},
        {btn = skillsTab, icon = skillsIcon, text = skillsText, stroke = skillsStroke},
        {btn = auraTab, icon = auraIcon, text = auraText, stroke = auraStroke},
        {btn = talismaTab, icon = talismaIcon, text = talismaText, stroke = talismaStroke}
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
    end
end

farmTab.MouseButton1Click:Connect(function() switchTab("Farm") end)
marcaTab.MouseButton1Click:Connect(function() switchTab("Marca") end)
skillsTab.MouseButton1Click:Connect(function() switchTab("Skills") end)
auraTab.MouseButton1Click:Connect(function() switchTab("Aura") end)
talismaTab.MouseButton1Click:Connect(function() switchTab("Talismã") end)

-- Button creator
local function createButton(text, icon, parent, yPos)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0,440,0,55)
    btn.Position = UDim2.new(0,15,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,35)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,14)

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
    iconLabel.Size = UDim2.new(0,45,0,45)
    iconLabel.Position = UDim2.new(0,12,0,5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 24
    iconLabel.Font = Enum.Font.GothamBold

    local textLabel = Instance.new("TextLabel", btn)
    textLabel.Size = UDim2.new(0,250,0,55)
    textLabel.Position = UDim2.new(0,65,0,0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(180,200,230)
    textLabel.TextSize = 15
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left

    local status = Instance.new("TextLabel", btn)
    status.Size = UDim2.new(0,80,0,30)
    status.Position = UDim2.new(1,-95,0.5,-15)
    status.BackgroundColor3 = Color3.fromRGB(220,60,80)
    status.TextColor3 = Color3.new(1,1,1)
    status.Text = "OFF"
    status.TextSize = 13
    status.Font = Enum.Font.GothamBold
    status.BorderSizePixel = 0

    local statusCorner = Instance.new("UICorner", status)
    statusCorner.CornerRadius = UDim.new(0,8)

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
local clickButton, clickStatus, clickStroke = createButton("AutoClick", "🖱️", farmContainer, 10)
local rebornButton, rebornStatus, rebornStroke = createButton("AutoReborn", "🔄", farmContainer, 75)
local openButton, openStatus, openStroke = createButton("AutoOpen Baús", "📦", farmContainer, 140)

-- ABA MARCA
local autoRerollButton, autoRerollStatus, autoRerollStroke = createButton("AutoReroll Marca", "🎯", marcaContainer, 10)

local foundLabel = Instance.new("TextLabel", marcaContainer)
foundLabel.Size = UDim2.new(0,440,0,70)
foundLabel.Position = UDim2.new(0,15,0,75)
foundLabel.BackgroundColor3 = Color3.fromRGB(25,25,35)
foundLabel.TextColor3 = Color3.fromRGB(255,215,100)
foundLabel.TextSize = 13
foundLabel.Font = Enum.Font.GothamMedium
foundLabel.Text = "🎯 Sistema de Reroll Automático\n\nClique no botão acima para iniciar o reroll contínuo."
foundLabel.TextWrapped = true

local foundCorner = Instance.new("UICorner", foundLabel)
foundCorner.CornerRadius = UDim.new(0,14)

local foundStroke = Instance.new("UIStroke", foundLabel)
foundStroke.Color = Color3.fromRGB(80,80,100)
foundStroke.Thickness = 1

-- ABA SKILLS
local respirationSkillButton, respirationSkillStatus, respirationStroke = createButton("Respiration Skill", "☠️", skillsContainer, 10)

local respirationDelayLabel = Instance.new("TextLabel", skillsContainer)
respirationDelayLabel.Size = UDim2.new(0,150,0,20)
respirationDelayLabel.Position = UDim2.new(0,15,0,75)
respirationDelayLabel.BackgroundTransparency = 1
respirationDelayLabel.TextColor3 = Color3.fromRGB(150,170,200)
respirationDelayLabel.TextSize = 12
respirationDelayLabel.Font = Enum.Font.GothamBold
respirationDelayLabel.Text = "⏱️ Delay (segundos):"
respirationDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local respirationDelayInput = Instance.new("TextBox", skillsContainer)
respirationDelayInput.Size = UDim2.new(0,440,0,40)
respirationDelayInput.Position = UDim2.new(0,15,0,100)
respirationDelayInput.BackgroundColor3 = Color3.fromRGB(25,25,35)
respirationDelayInput.TextColor3 = Color3.new(1,1,1)
respirationDelayInput.PlaceholderText = "0.01 - 5.00"
respirationDelayInput.Text = tostring(RESPIRATION_SKILL_DELAY)
respirationDelayInput.ClearTextOnFocus = false
respirationDelayInput.Font = Enum.Font.GothamMedium
respirationDelayInput.TextSize = 14
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

    local dmgButton, dmgStatus, dmgStroke = createButton("DMG", "⚔️", skillsContainer, 150)

    local dmgDelayLabel = Instance.new("TextLabel", skillsContainer)
    dmgDelayLabel.Size = UDim2.new(0,150,0,20)
    dmgDelayLabel.Position = UDim2.new(0,15,0,215)
    dmgDelayLabel.BackgroundTransparency = 1
    dmgDelayLabel.TextColor3 = Color3.fromRGB(150,170,200)
    dmgDelayLabel.TextSize = 12
    dmgDelayLabel.Font = Enum.Font.GothamBold
    dmgDelayLabel.Text = "⏱️ DMG Delay:"
    dmgDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

    local dmgDelayBox = Instance.new("TextBox", skillsContainer)
    dmgDelayBox.Size = UDim2.new(0,440,0,40)
    dmgDelayBox.Position = UDim2.new(0,15,0,240)
    dmgDelayBox.BackgroundColor3 = Color3.fromRGB(25,25,35)
    dmgDelayBox.Text = tostring(delayValue)
    dmgDelayBox.PlaceholderText = "0.0001 - 5.00"
    dmgDelayBox.ClearTextOnFocus = false
    dmgDelayBox.Font = Enum.Font.GothamMedium
    dmgDelayBox.TextSize = 14
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
haloInfo.Size = UDim2.new(0,440,0,50)
haloInfo.Position = UDim2.new(0,15,0,10)
haloInfo.BackgroundColor3 = Color3.fromRGB(25,25,35)
haloInfo.TextColor3 = Color3.fromRGB(255,215,100)
haloInfo.TextSize = 14
haloInfo.Font = Enum.Font.GothamBold
haloInfo.Text = "✨ SISTEMA DE HALOS PREMIUM"

local haloCorner = Instance.new("UICorner", haloInfo)
haloCorner.CornerRadius = UDim.new(0,14)

local haloStroke = Instance.new("UIStroke", haloInfo)
haloStroke.Color = Color3.fromRGB(80,80,100)
haloStroke.Thickness = 1.5

local bronzeButton, bronzeStatus, bronzeStroke = createButton("Reroll Bronze", "🥉", auraContainer, 70)
local ouroButton, ouroStatus, ouroStroke = createButton("Reroll Ouro", "🥇", auraContainer, 135)
local diamanteButton, diamanteStatus, diamanteStroke = createButton("Reroll Diamante", "💎", auraContainer, 200)
local exchangeButton, exchangeStatus, exchangeStroke = createButton("Exchange Halo (Diamante)", "🎁", auraContainer, 265)

local exchangeDelayLabel = Instance.new("TextLabel", auraContainer)
exchangeDelayLabel.Size = UDim2.new(0,150,0,20)
exchangeDelayLabel.Position = UDim2.new(0,15,0,330)
exchangeDelayLabel.BackgroundTransparency = 1
exchangeDelayLabel.TextColor3 = Color3.fromRGB(150,170,200)
exchangeDelayLabel.TextSize = 12
exchangeDelayLabel.Font = Enum.Font.GothamBold
exchangeDelayLabel.Text = "⏱️ Exchange Delay:"
exchangeDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local exchangeDelayInput = Instance.new("TextBox", auraContainer)
exchangeDelayInput.Size = UDim2.new(0,440,0,40)
exchangeDelayInput.Position = UDim2.new(0,15,0,355)
exchangeDelayInput.BackgroundColor3 = Color3.fromRGB(25,25,35)
exchangeDelayInput.TextColor3 = Color3.new(1,1,1)
exchangeDelayInput.PlaceholderText = "0.01 - 0.51"
exchangeDelayInput.Text = string.format("%.2f", EXCHANGE_HALO_DELAY)
exchangeDelayInput.ClearTextOnFocus = false
exchangeDelayInput.Font = Enum.Font.GothamMedium
exchangeDelayInput.TextSize = 14
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
talismaInfo.Size = UDim2.new(0,440,0,60)
talismaInfo.Position = UDim2.new(0,15,0,10)
talismaInfo.BackgroundColor3 = Color3.fromRGB(25,25,35)
talismaInfo.TextColor3 = Color3.fromRGB(255,215,100)
talismaInfo.TextSize = 13
talismaInfo.Font = Enum.Font.GothamBold
talismaInfo.Text = "💎 SISTEMA DE ORNAMENTOS\n\nSelecione um ornamento e clique em EQUIPAR"
talismaInfo.TextWrapped = true

local talismaInfoCorner = Instance.new("UICorner", talismaInfo)
talismaInfoCorner.CornerRadius = UDim.new(0,14)

local talismaInfoStroke = Instance.new("UIStroke", talismaInfo)
talismaInfoStroke.Color = Color3.fromRGB(80,80,100)
talismaInfoStroke.Thickness = 1.5

local ornamentButtons = {}
do
    local y = 80
    for name, cfg in pairs(ORNAMENTS) do
        local btn = Instance.new("TextButton", talismaContainer)
        btn.Size = UDim2.new(0,440,0,50)
        btn.Position = UDim2.new(0,15,0,y)
        btn.BackgroundColor3 = Color3.fromRGB(25,25,35)
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0,14)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(50,50,70)
        stroke.Thickness = 1.5

        local icon = Instance.new("TextLabel", btn)
        icon.Size = UDim2.new(0,40,0,40)
        icon.Position = UDim2.new(0,10,0,5)
        icon.BackgroundTransparency = 1
        icon.Text = "💎"
        icon.TextSize = 22
        icon.Font = Enum.Font.GothamBold

        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(0,300,0,50)
        label.Position = UDim2.new(0,60,0,0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(180,200,230)
        label.TextSize = 16
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
        y = y + 60
    end
end

local equipButton = Instance.new("TextButton", talismaContainer)
equipButton.Size = UDim2.new(0,440,0,55)
equipButton.Position = UDim2.new(0,15,0,280)
equipButton.BackgroundColor3 = Color3.fromRGB(80,140,255)
equipButton.TextColor3 = Color3.new(1,1,1)
equipButton.Text = "⚡ EQUIPAR SELECIONADO"
equipButton.Font = Enum.Font.GothamBold
equipButton.TextSize = 16
equipButton.BorderSizePixel = 0
equipButton.AutoButtonColor = false

local equipCorner = Instance.new("UICorner", equipButton)
equipCorner.CornerRadius = UDim.new(0,14)

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
talismaDesc.Size = UDim2.new(0,440,0,50)
talismaDesc.Position = UDim2.new(0,15,0,345)
talismaDesc.BackgroundTransparency = 1
talismaDesc.TextColor3 = Color3.fromRGB(150,170,200)
talismaDesc.Font = Enum.Font.GothamMedium
talismaDesc.TextSize = 11
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
        task.wait(1)
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
            task.wait(0.001)
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
        task.wait(HALO_DELAY)
    end
    setFlag("autoHaloBronze", false)
end

local function autoHaloOuro()
    if getFlag("autoHaloOuro") then return end
    setFlag("autoHaloOuro", true)
    while _G.AUTO_HALO_OURO_ATIVO do
        pcall(function() if rerollHaloRemote then rerollHaloRemote:InvokeServer(2) end end)
        task.wait(HALO_DELAY)
    end
    setFlag("autoHaloOuro", false)
end

local function autoHaloDiamante()
    if getFlag("autoHaloDiamante") then return end
    setFlag("autoHaloDiamante", true)
    while _G.AUTO_HALO_DIAMANTE_ATIVO do
        pcall(function() if rerollHaloRemote then rerollHaloRemote:InvokeServer(3) end end)
        task.wait(HALO_DELAY)
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
        task.wait(EXCHANGE_HALO_DELAY)
    end
    setFlag("autoExchangeHalo", false)
end

local function autoReroll()
    if getFlag("autoReroll") then return end
    setFlag("autoReroll", true)
    while _G.AUTO_REROLL_ATIVO do
        pcall(function() if rerollRemote then rerollRemote:InvokeServer(ORNAMENT_ID) end end)
        task.wait(DELAY_REROLL)
    end
    setFlag("autoReroll", false)
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

autoRerollButton.MouseButton1Click:Connect(function()
    _G.AUTO_REROLL_ATIVO = not _G.AUTO_REROLL_ATIVO
    autoRerollStatus.Text = _G.AUTO_REROLL_ATIVO and "ON" or "OFF"
    if _G.AUTO_REROLL_ATIVO then
        TweenService:Create(autoRerollStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
        TweenService:Create(autoRerollStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40,180,80)}):Play()
        foundLabel.Text = "🎯 Sistema ativo - Girando marca automaticamente...\n\nClique novamente no botão para parar."
        foundLabel.TextColor3 = Color3.fromRGB(100,255,150)
        task.spawn(autoReroll)
    else
        TweenService:Create(autoRerollStatus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220,60,80)}):Play()
        TweenService:Create(autoRerollStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(180,40,60)}):Play()
        foundLabel.Text = "🎯 Sistema parado!\n\nClique no botão acima para reiniciar."
        foundLabel.TextColor3 = Color3.fromRGB(255,215,100)
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

print("Diuary Hub Premium carregado com sucesso!")