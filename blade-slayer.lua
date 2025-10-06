

-- HUB FINAL AJUSTADO - DiuaryOG
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
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
hubFrame.Size = UDim2.new(0, 180, 0, 300)  -- aumentei largura para caber o botão
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
title.TextColor3 = Color3.fromRGB(173, 216, 230)  -- azul bebê
title.TextScaled = true
title.Font = Enum.Font.GothamBold  -- fonte bonita
title.Text = "DiuaryOG"
title.Parent = hubFrame

-- BOTÃO MINIMIZAR (DESLOCADO)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,30,0,30)
minimizeBtn.Position = UDim2.new(0,155,0,0)  -- ajustado para não cobrir o G
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
