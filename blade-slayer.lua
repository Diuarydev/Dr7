-- HUB DIUARYOG COM SISTEMA DE KEY E DETECÇÃO AUTOMÁTICA DE STRIPES
-- By DiuaryOG 💙

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- SISTEMA DE KEY
local KEYS_VALIDAS = { "luh", "fifa" }

local function verificarKey()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TextBox = Instance.new("TextBox")
    local ConfirmButton = Instance.new("TextButton")
    local StatusLabel = Instance.new("TextLabel")

    ScreenGui.Name = "KeySystemGui"
    ScreenGui.Parent = playerGui
    Frame.Size = UDim2.new(0, 350, 0, 200)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.Parent = ScreenGui

    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "SISTEMA DE KEY"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame

    TextBox.Size = UDim2.new(0, 300, 0, 40)
    TextBox.Position = UDim2.new(0.5, -150, 0, 60)
    TextBox.PlaceholderText = "Digite sua key aqui..."
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextScaled = true
    TextBox.Parent = Frame

    ConfirmButton.Size = UDim2.new(0, 300, 0, 40)
    ConfirmButton.Position = UDim2.new(0.5, -150, 0, 110)
    ConfirmButton.Text = "VERIFICAR KEY"
    ConfirmButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    ConfirmButton.TextColor3 = Color3.new(1, 1, 1)
    ConfirmButton.Font = Enum.Font.GothamBold
    ConfirmButton.TextScaled = true
    ConfirmButton.Parent = Frame

    StatusLabel.Size = UDim2.new(1, -20, 0, 25)
    StatusLabel.Position = UDim2.new(0, 10, 0, 160)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextColor3 = Color3.new(1, 1, 1)
    StatusLabel.TextScaled = true
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = Frame

    local keyValida = false
    ConfirmButton.MouseButton1Click:Connect(function()
        local keyInput = TextBox.Text
        if keyInput == "" then
            StatusLabel.Text = "Digite uma key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        for _, key in pairs(KEYS_VALIDAS) do
            if keyInput == key then
                keyValida = true
                StatusLabel.Text = "KEY VÁLIDA! Iniciando..."
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                ConfirmButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                task.wait(1)
                ScreenGui:Destroy()
                return
            end
        end
        StatusLabel.Text = "KEY INVÁLIDA!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        TextBox.Text = ""
    end)
    repeat task.wait() until keyValida
end

-- VERIFICA A KEY
verificarKey()

-- HUB
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rerollRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RerollOrnament")
local clickRemote = ReplicatedStorage.Remotes.PlayerClickAttack
local rebornRemote = ReplicatedStorage.Remotes.PlayerReborn
local openBoxRemote = ReplicatedStorage.Remotes.OpenAntiqueBox

-- CONFIG
local ORNAMENT_ID = 400002
local DELAY_REROLL = 0.1
local AUTO_REROLL_ATIVO = false
local AUTO_CLICK_ATIVO = false
local AUTO_REBORN_ATIVO = false
local AUTO_OPEN_ATIVO = false
local STRIPES_DESEJADOS = {}

-- GUI PRINCIPAL
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DiuaryOG"
screenGui.Parent = playerGui

local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 200, 0, 480)
hubFrame.Position = UDim2.new(0, 50, 0, 50)
hubFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
hubFrame.BorderSizePixel = 0
hubFrame.Parent = screenGui
hubFrame.Active = true

-- Sombra do HUB
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = hubFrame

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = hubFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- ARRASTAR
local dragging = false
local dragInput, mousePos, framePos
hubFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = hubFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
hubFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        hubFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- TÍTULO AZUL BEBÊ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 150, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(173, 216, 230)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Text = "DiuaryOG"
title.Parent = hubFrame

-- BOTÃO MINIMIZAR
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(0, 150, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(0, 0, 0)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = hubFrame

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, obj in pairs(hubFrame:GetChildren()) do
        if obj ~= title and obj ~= minimizeBtn then obj.Visible = not minimized end
    end
    hubFrame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 480)
end)

-- LABEL DE STATUS
local foundLabel = Instance.new("TextLabel")
foundLabel.Size = UDim2.new(0, 150, 0, 25)
foundLabel.Position = UDim2.new(0, 0, 0, 35)
foundLabel.BackgroundTransparency = 1
foundLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
foundLabel.TextScaled = true
foundLabel.Font = Enum.Font.GothamBold
foundLabel.Text = "🎯 Stripe: NENHUM"
foundLabel.Parent = hubFrame

-- BOTÃO TOGGLE REROLL
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 130, 0, 25)
toggleButton.Position = UDim2.new(0, 10, 0, 65)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Text = "Reroll: OFF"
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = hubFrame

-- BOTÃO AUTO CLICK
local clickButton = Instance.new("TextButton")
clickButton.Size = UDim2.new(0, 130, 0, 20)
clickButton.Position = UDim2.new(0, 10, 0, 310)  -- Movido para baixo
clickButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
clickButton.TextColor3 = Color3.new(1, 1, 1)
clickButton.Text = "AutoClick: OFF"
clickButton.TextScaled = true
clickButton.Font = Enum.Font.GothamBold
clickButton.Parent = hubFrame

-- BOTÃO AUTO REBORN
local rebornButton = Instance.new("TextButton")
rebornButton.Size = UDim2.new(0, 130, 0, 20)
rebornButton.Position = UDim2.new(0, 10, 0, 335)  -- Movido para baixo
rebornButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
rebornButton.TextColor3 = Color3.new(1, 1, 1)
rebornButton.Text = "AutoReborn: OFF"
rebornButton.TextScaled = true
rebornButton.Font = Enum.Font.GothamBold
rebornButton.Parent = hubFrame

-- BOTÃO AUTO OPEN BAÚS
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 130, 0, 20)
openButton.Position = UDim2.new(0, 10, 0, 360)  -- Movido para baixo
openButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.Text = "AutoOpen: OFF"
openButton.TextScaled = true
openButton.Font = Enum.Font.GothamBold
openButton.Parent = hubFrame

-- DETECÇÃO AUTOMÁTICA DE STRIPES
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

-- FUNÇÃO AUTO-REROLL
local function autoReroll()
    while AUTO_REROLL_ATIVO do
        local achou = false
        pcall(function() rerollRemote:InvokeServer(ORNAMENT_ID) end)
        local todosStripes = detectarStripes()
        for _, stripe in pairs(todosStripes) do
            for _, stripeName in ipairs(STRIPES_DESEJADOS) do
                if stripe.Name == stripeName then
                    foundLabel.Text = "🎯 Stripe: " .. stripeName
                    achou = true
                    break
                end
            end
            if achou then break end
        end

        if achou then
            AUTO_REROLL_ATIVO = false
            toggleButton.Text = "Reroll: OFF"
            toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            return
        end

        task.wait(DELAY_REROLL)
    end
end

-- FUNÇÃO AUTO CLICK
local function autoClick()
    while AUTO_CLICK_ATIVO do
        pcall(function()
            local args = {{}}
            clickRemote:FireServer(unpack(args))
        end)
        task.wait(0.01)
    end
end

-- FUNÇÃO AUTO REBORN
local function autoReborn()
    while AUTO_REBORN_ATIVO do
        pcall(function()
            rebornRemote:FireServer()
        end)
        task.wait(1)
    end
end

-- FUNÇÃO AUTO OPEN BAÚS
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

-- TOGGLE REROLL
toggleButton.MouseButton1Click:Connect(function()
    if #STRIPES_DESEJADOS == 0 then
        warn("Selecione pelo menos um Stripe!")
        return
    end
    AUTO_REROLL_ATIVO = not AUTO_REROLL_ATIVO
    if AUTO_REROLL_ATIVO then
        foundLabel.Text = "🎯 Stripe: NENHUM"
        toggleButton.Text = "Reroll: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.spawn(autoReroll)
    else
        toggleButton.Text = "Reroll: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- TOGGLE AUTO CLICK
clickButton.MouseButton1Click:Connect(function()
    AUTO_CLICK_ATIVO = not AUTO_CLICK_ATIVO
    if AUTO_CLICK_ATIVO then
        clickButton.Text = "AutoClick: ON"
        clickButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.spawn(autoClick)
    else
        clickButton.Text = "AutoClick: OFF"
        clickButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- TOGGLE AUTO REBORN
rebornButton.MouseButton1Click:Connect(function()
    AUTO_REBORN_ATIVO = not AUTO_REBORN_ATIVO
    if AUTO_REBORN_ATIVO then
        rebornButton.Text = "AutoReborn: ON"
        rebornButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.spawn(autoReborn)
    else
        rebornButton.Text = "AutoReborn: OFF"
        rebornButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- TOGGLE AUTO OPEN
openButton.MouseButton1Click:Connect(function()
    AUTO_OPEN_ATIVO = not AUTO_OPEN_ATIVO
    if AUTO_OPEN_ATIVO then
        openButton.Text = "AutoOpen: ON"
        openButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.spawn(autoOpenBaus)
    else
        openButton.Text = "AutoOpen: OFF"
        openButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- CHECKBOXES DE STRIPES
for i = 1, 9 do
    local stripeName = "Stripe" .. i
    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 130, 0, 20)
    cb.Position = UDim2.new(0, 10, 0, 100 + (i - 1) * 22)
    cb.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    cb.TextColor3 = Color3.new(1, 1, 1)
    cb.Text = stripeName
    cb.TextScaled = true
    cb.Font = Enum.Font.GothamBold
    cb.Parent = hubFrame

    cb.MouseButton1Click:Connect(function()
        local selecionado = false
        for idx, name in ipairs(STRIPES_DESEJADOS) do
            if name == stripeName then
                table.remove(STRIPES_DESEJADOS, idx)
                selecionado = true
                cb.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                break
            end
        end
        if not selecionado then
            table.insert(STRIPES_DESEJADOS, stripeName)
            cb.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
        foundLabel.Text = "🎯 Stripe: NENHUM"
    end)
end

print("✅ HUB DiuaryOG carregado com sucesso!")