-- Gui to Lua
-- Estilo: Azul, Preto e Branco com Fonte Moderna
-- Recursos: Auto Farm, Auto Pickup, Spam Tool para Ferro, Rubi, Ouro e mais

-- INSTANCIAS
local ScreenGui = Instance.new("ScreenGui")
local MainGUI = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local RockName = Instance.new("TextBox")
local ItemName = Instance.new("TextBox")
local AutoFarmRock = Instance.new("TextButton")
local AutoPickupItem = Instance.new("TextButton")
local AutoSpamTool = Instance.new("TextButton")
local RockList = Instance.new("TextLabel")

-- PROPRIEDADES GERAIS
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainGUI.Name = "MainGUI"
MainGUI.Active = true
MainGUI.Draggable = true
MainGUI.Parent = ScreenGui
MainGUI.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainGUI.Position = UDim2.new(0.15, 0, 0.25, 0)
MainGUI.Size = UDim2.new(0, 300, 0, 300)
MainGUI.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- TÍTULO
Title.Name = "Title"
Title.Parent = MainGUI
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.Cartoon
Title.Text = "💙 Smurf Hub 💙"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 18

-- ROCK NAME
RockName.Name = "RockName"
RockName.Parent = MainGUI
RockName.PlaceholderText = "Digite o nome da rocha (Ex: Rubi)"
RockName.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
RockName.Position = UDim2.new(0.05, 0, 0.15, 0)
RockName.Size = UDim2.new(0.9, 0, 0, 30)
RockName.Font = Enum.Font.Cartoon
RockName.TextColor3 = Color3.fromRGB(255, 255, 255)
RockName.TextSize = 14

-- ITEM NAME
ItemName.Name = "ItemName"
ItemName.Parent = MainGUI
ItemName.PlaceholderText = "Nome do item para coletar"
ItemName.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ItemName.Position = UDim2.new(0.05, 0, 0.3, 0)
ItemName.Size = UDim2.new(0.9, 0, 0, 30)
ItemName.Font = Enum.Font.Cartoon
ItemName.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemName.TextSize = 14

-- AUTO FARM ROCK
AutoFarmRock.Name = "AutoFarmRock"
AutoFarmRock.Parent = MainGUI
AutoFarmRock.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
AutoFarmRock.Position = UDim2.new(0.05, 0, 0.45, 0)
AutoFarmRock.Size = UDim2.new(0.4, 0, 0, 40)
AutoFarmRock.Font = Enum.Font.Cartoon
AutoFarmRock.Text = "Farm Rocha"
AutoFarmRock.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmRock.TextSize = 14

-- AUTO PICKUP ITEM
AutoPickupItem.Name = "AutoPickupItem"
AutoPickupItem.Parent = MainGUI
AutoPickupItem.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
AutoPickupItem.Position = UDim2.new(0.55, 0, 0.45, 0)
AutoPickupItem.Size = UDim2.new(0.4, 0, 0, 40)
AutoPickupItem.Font = Enum.Font.Cartoon
AutoPickupItem.Text = "Pegar Item"
AutoPickupItem.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoPickupItem.TextSize = 14

-- AUTO SPAM TOOL
AutoSpamTool.Name = "AutoSpamTool"
AutoSpamTool.Parent = MainGUI
AutoSpamTool.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AutoSpamTool.Position = UDim2.new(0.05, 0, 0.65, 0)
AutoSpamTool.Size = UDim2.new(0.9, 0, 0, 40)
AutoSpamTool.Font = Enum.Font.Cartoon
AutoSpamTool.Text = "🔁 Usar ferramenta"
AutoSpamTool.TextColor3 = Color3.fromRGB(0, 0, 0)
AutoSpamTool.TextSize = 14

-- LISTA DE MINÉRIOS (Texto decorativo)
RockList.Name = "RockList"
RockList.Parent = MainGUI
RockList.BackgroundTransparency = 1
RockList.Position = UDim2.new(0.05, 0, 0.85, 0)
RockList.Size = UDim2.new(0.9, 0, 0, 40)
RockList.Font = Enum.Font.Cartoon
RockList.TextColor3 = Color3.fromRGB(255, 255, 255)
RockList.TextSize = 12
RockList.Text = "⛏️ Exemplos: Ferro, Rubi, Ouro, Prata, Carvão"

-- FUNÇÕES
local toggleFarm = false
AutoFarmRock.MouseButton1Click:Connect(function()
	toggleFarm = not toggleFarm
	while toggleFarm and wait(0.1) do
		local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		if tool and RockName.Text ~= "" then
			local args = {
				[1] = tool,
				[2] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			}
			game:GetService("ReplicatedStorage").Events.DestroyModel:FireServer(unpack(args))
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
				game:GetService("Workspace").Ores[RockName.Text].Reference.CFrame
		end
	end
end)

AutoPickupItem.MouseButton1Click:Connect(function()
	for _, v in pairs(game.Workspace:GetDescendants()) do
		if v.Name == ItemName.Text then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
			wait(0.2)
			local args = {[1] = v}
			game:GetService("ReplicatedStorage").Events:FindFirstChild("Pick up"):FireServer(unpack(args))
		end
	end
end)

local toggleSpam = false
AutoSpamTool.MouseButton1Click:Connect(function()
	toggleSpam = not toggleSpam
	while toggleSpam and wait(0.1) do
		local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		if tool then
			local args = {
				[1] = tool,
				[2] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			}
			game:GetService("ReplicatedStorage").Events.DestroyModel:FireServer(unpack(args))
		end
	end
end)
