-- HUB DIUARYOG COM SISTEMA DE KEY
-- Arquivo único completo

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- SISTEMA DE KEY
local KEYS_VALIDAS = {
    "iluminado55"
}

local function verificarKey()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Criar GUI de verificação
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local TextBox = Instance.new("TextBox")
    local UICorner2 = Instance.new("UICorner")
    local ConfirmButton = Instance.new("TextButton")
    local UICorner3 = Instance.new("UICorner")
    local StatusLabel = Instance.new("TextLabel")
    
    ScreenGui.Name = "KeySystemGui"
    ScreenGui.Parent = playerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    Frame.Size = UDim2.new(0, 350, 0, 200)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame
    
    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "SISTEMA DE KEY"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame
    
    TextBox.Size = UDim2.new(0, 300, 0, 40)
    TextBox.Position = UDim2.new(0.5, -150, 0, 60)
    TextBox.PlaceholderText = "Digite sua key aqui..."
    TextBox.Text = ""
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.BorderSizePixel = 0
    TextBox.Parent = Frame
    
    UICorner2.CornerRadius = UDim.new(0, 8)
    UICorner2.Parent = TextBox
    
    ConfirmButton.Size = UDim2.new(0, 300, 0, 40)
    ConfirmButton.Position = UDim2.new(0.5, -150, 0, 110)
    ConfirmButton.Text = "VERIFICAR KEY"
    ConfirmButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    ConfirmButton.TextColor3 = Color3.new(1, 1, 1)
    ConfirmButton.TextSize = 16
    ConfirmButton.Font = Enum.Font.GothamBold
    ConfirmButton.BorderSizePixel = 0
    ConfirmButton.Parent = Frame
    
    UICorner3.CornerRadius = UDim.new(0, 8)
    UICorner3.Parent = ConfirmButton
    
    StatusLabel.Size = UDim2.new(1, -20, 0, 25)
    StatusLabel.Position = UDim2.new(0, 10, 0, 160)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.new(1, 1, 1)
    StatusLabel.TextSize = 12
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
                StatusLabel.Text = "KEY VÁLIDA! Iniciando script..."
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                ConfirmButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                wait(1)
                ScreenGui:Destroy()
                return
            end
        end
        
        StatusLabel.Text = "KEY INVÁLIDA! Tente novamente."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        TextBox.Text = ""
    end)
    
    repeat wait(0.1) until keyValida
    return keyValida
end

-- Verificar key antes de carregar o HUB
if not verificarKey() then
    return
end

-- HUB DIUARYOG
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local rerollRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RerollOrnament")

-- CONFIGURAÇÃO
local ORNAMENT_ID = 400002
local DELAY_REROLL = 0.1
local AUTO_REROLL_ATIVO = false
local STRIPES_DESEJADOS = {}

-- PLAYERGUI
local playerGui = player:WaitForChild("PlayerGui")

-- GUI PRINCIPAL
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DiuaryOG"
screenGui.Parent = playerGui

local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 180, 0, 300)
hubFrame.Position = UDim2.new(0,50,0,50)
hubFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
hubFrame.Parent = screenGui
hubFrame.Active = true

-- ARRASTAR GUI
local dragging = false
local dragInput, mousePos, framePos
hubFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = hubFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
hubFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        hubFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
                                     framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- TÍTULO ESTILIZADO AZUL BEBÊ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0,150,0,30)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.TextColor3 = Color3.fromRGB(173, 216, 230)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Text = "DiuaryOG"
title.Parent = hubFrame

-- BOTÃO MINIMIZAR
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,30,0,30)
minimizeBtn.Position = UDim2.new(0,155,0,0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200,200,0)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(0,0,0)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.Parent = hubFrame

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, obj in pairs(hubFrame:GetChildren()) do
        if obj ~= title and obj ~= minimizeBtn then
            obj.Visible = not minimized
        end
    end
    hubFrame.Size = minimized and UDim2.new(0,180,0,30) or UDim2.new(0,180,0,300)
end)

-- LABEL STRIPE ENCONTRADO
local foundLabel = Instance.new("TextLabel")
foundLabel.Size = UDim2.new(0,150,0,25)
foundLabel.Position = UDim2.new(0,0,0,35)
foundLabel.BackgroundTransparency = 1
foundLabel.TextColor3 = Color3.fromRGB(255,255,0)
foundLabel.TextScaled = true
foundLabel.Font = Enum.Font.SourceSansBold
foundLabel.Text = "🎯 Stripe: NENHUM"
foundLabel.Parent = hubFrame

-- BOTÃO TOGGLE
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0,130,0,25)
toggleButton.Position = UDim2.new(0,10,0,65)
toggleButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Text = "Ligar"
toggleButton.Parent = hubFrame

-- FUNÇÃO AUTO-REROLL
local function autoReroll()
    while AUTO_REROLL_ATIVO do
        pcall(function()
            rerollRemote:InvokeServer(ORNAMENT_ID)
        end)
        local pasta = Workspace:FindFirstChild("Diuaryy")
        if pasta then
            for _, obj in pairs(pasta:GetDescendants()) do
                for _, stripeName in ipairs(STRIPES_DESEJADOS) do
                    if obj.Name == stripeName then
                        foundLabel.Text = "🎯 Stripe: "..stripeName
                        AUTO_REROLL_ATIVO = false
                        toggleButton.Text = "Ligar"
                        toggleButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
                        return
                    end
                end
            end
        end
        task.wait(DELAY_REROLL)
    end
end

-- TOGGLE
toggleButton.MouseButton1Click:Connect(function()
    if #STRIPES_DESEJADOS == 0 then
        warn("Selecione pelo menos um Stripe!")
        return
    end
    AUTO_REROLL_ATIVO = not AUTO_REROLL_ATIVO
    if AUTO_REROLL_ATIVO then
        foundLabel.Text = "🎯 Stripe: NENHUM"
        toggleButton.Text = "Desligar"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
        task.spawn(autoReroll)
    else
        toggleButton.Text = "Ligar"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
    end
end)

-- CHECKBOXES DE STRIPE
for i=1,9 do
    local stripeName = "Stripe"..i
    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0,130,0,20)
    cb.Position = UDim2.new(0,10,0,100 + (i-1)*22)
    cb.BackgroundColor3 = Color3.fromRGB(200,0,0)
    cb.TextColor3 = Color3.new(1,1,1)
    cb.Text = stripeName
    cb.Parent = hubFrame
    
    cb.MouseButton1Click:Connect(function()
        local selecionado = false
        for idx, name in ipairs(STRIPES_DESEJADOS) do
            if name == stripeName then
                table.remove(STRIPES_DESEJADOS, idx)
                selecionado = true
                cb.BackgroundColor3 = Color3.fromRGB(200,0,0)
                break
            end
        end
        if not selecionado then
            table.insert(STRIPES_DESEJADOS, stripeName)
            cb.BackgroundColor3 = Color3.fromRGB(0,200,0)
        end
        foundLabel.Text = "🎯 Stripe: NENHUM"
        print("✅ Stripes selecionados:", table.concat(STRIPES_DESEJADOS,", "))
    end)
end

print("HUB DiuaryOG carregado com sucesso!")