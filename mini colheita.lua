-- Serviços
local Jogadores = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JogadorLocal = Jogadores.LocalPlayer

-- Remotes
local m1Remote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Event"):WaitForChild("Combat"):WaitForChild("M1")
local forageEvent = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Event"):WaitForChild("Pet"):WaitForChild("PutForageEvent")
local abrirCaixaRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Box"):WaitForChild("[C-S]OpenBox")

-- Argumentos
local argsM1 = {3}
local argsFrango = {"Chicken"}
local argsCoelho = {"Rabbit"}
local argsElite = {"EliteBox"}
local argsFine = {"FineBox"}
local argsCommon = {"CommonBox"}

-- GUI
local telaGui = Instance.new("ScreenGui")
telaGui.Name = "MiniHubUnificado"
telaGui.Parent = JogadorLocal:WaitForChild("PlayerGui")

local quadroPrincipal = Instance.new("Frame")
quadroPrincipal.Size = UDim2.new(0, 270, 0, 300)
quadroPrincipal.Position = UDim2.new(0, 100, 0, 100)
quadroPrincipal.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
quadroPrincipal.BorderSizePixel = 0
quadroPrincipal.Parent = telaGui
quadroPrincipal.Active = true
quadroPrincipal.Draggable = true

-- Função para criar botão toggle
local function criarBotaoToggle(texto, posY)
	local botao = Instance.new("TextButton")
	botao.Size = UDim2.new(0, 230, 0, 40)
	botao.Position = UDim2.new(0, 20, 0, posY)
	botao.Text = texto
	botao.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	botao.TextColor3 = Color3.new(1,1,1)
	botao.Parent = quadroPrincipal
	return botao
end

-- Criando todos os botões
local botaoAutoM1 = criarBotaoToggle("Ligar Auto M1", 10)
local botaoAutoFrango = criarBotaoToggle("Ligar Auto Frango", 60)
local botaoAutoCoelho = criarBotaoToggle("Ligar Auto Coelho", 110)
local botaoElite = criarBotaoToggle("Abrir EliteBox", 160)
local botaoFine = criarBotaoToggle("Abrir FineBox", 210)
local botaoCommon = criarBotaoToggle("Abrir CommonBox", 260)

-- Variáveis de controle
local autoM1 = false
local autoFrango = false
local autoCoelho = false
local autoElite = false
local autoFine = false
local autoCommon = false

-- Funções de toggle
botaoAutoM1.MouseButton1Click:Connect(function()
	autoM1 = not autoM1
	botaoAutoM1.Text = autoM1 and "Desligar Auto M1" or "Ligar Auto M1"
end)

botaoAutoFrango.MouseButton1Click:Connect(function()
	autoFrango = not autoFrango
	botaoAutoFrango.Text = autoFrango and "Desligar Auto Frango" or "Ligar Auto Frango"
end)

botaoAutoCoelho.MouseButton1Click:Connect(function()
	autoCoelho = not autoCoelho
	botaoAutoCoelho.Text = autoCoelho and "Desligar Auto Coelho" or "Ligar Auto Coelho"
end)

botaoElite.MouseButton1Click:Connect(function()
	autoElite = not autoElite
	botaoElite.Text = autoElite and "Parar EliteBox" or "Abrir EliteBox"
end)

botaoFine.MouseButton1Click:Connect(function()
	autoFine = not autoFine
	botaoFine.Text = autoFine and "Parar FineBox" or "Abrir FineBox"
end)

botaoCommon.MouseButton1Click:Connect(function()
	autoCommon = not autoCommon
	botaoCommon.Text = autoCommon and "Parar CommonBox" or "Abrir CommonBox"
end)

-- Botão de minimizar/maximizar
local botaoMinimizar = Instance.new("TextButton")
botaoMinimizar.Size = UDim2.new(0, 40, 0, 25)
botaoMinimizar.Position = UDim2.new(1, -45, 0, 5)
botaoMinimizar.Text = "_"
botaoMinimizar.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
botaoMinimizar.TextColor3 = Color3.new(1,1,1)
botaoMinimizar.Parent = quadroPrincipal

local minimizado = false

botaoMinimizar.MouseButton1Click:Connect(function()
	minimizado = not minimizado
	if minimizado then
		botaoAutoM1.Visible = false
		botaoAutoFrango.Visible = false
		botaoAutoCoelho.Visible = false
		botaoElite.Visible = false
		botaoFine.Visible = false
		botaoCommon.Visible = false
		quadroPrincipal.Size = UDim2.new(0, 270, 0, 40)
	else
		botaoAutoM1.Visible = true
		botaoAutoFrango.Visible = true
		botaoAutoCoelho.Visible = true
		botaoElite.Visible = true
		botaoFine.Visible = true
		botaoCommon.Visible = true
		quadroPrincipal.Size = UDim2.new(0, 270, 0, 300)
	end
end)

-- Loop de execução
spawn(function()
	while true do
		if autoM1 then
			pcall(function() m1Remote:FireServer(unpack(argsM1)) end)
		end
		if autoFrango then
			pcall(function() forageEvent:FireServer(unpack(argsFrango)) end)
		end
		if autoCoelho then
			pcall(function() forageEvent:FireServer(unpack(argsCoelho)) end)
		end
		if autoElite then
			pcall(function() abrirCaixaRemote:InvokeServer(unpack(argsElite)) end)
		end
		if autoFine then
			pcall(function() abrirCaixaRemote:InvokeServer(unpack(argsFine)) end)
		end
		if autoCommon then
			pcall(function() abrirCaixaRemote:InvokeServer(unpack(argsCommon)) end)
		end
		wait(0.001)
	end
end)
