-- 💙 Smurfs Hub 💙 para The Lost Land
-- Feito com carinho pelos Smurfs

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- GUI principal
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SmurfsHub"

local MainGUI = Instance.new("Frame", ScreenGui)
MainGUI.Name = "MainGUI"
MainGUI.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainGUI.Position = UDim2.new(0.05, 0, 0.3, 0)
MainGUI.Size = UDim2.new(0, 260, 0, 350)
MainGUI.Active = true
MainGUI.Draggable = true
Instance.new("UICorner", MainGUI).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", MainGUI)
title.Text = "💙 Smurfs Hub 💙"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18

-------------------- 🪨 Seção: FARM --------------------
local RockName = Instance.new("TextBox", MainGUI)
RockName.PlaceholderText = "Nome do minério (ex: Ferro)"
RockName.Size = UDim2.new(0, 230, 0, 30)
RockName.Position = UDim2.new(0, 15, 0, 40)
RockName.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
RockName.TextColor3 = Color3.fromRGB(255, 255, 255)
RockName.Font = Enum.Font.GothamBold
RockName.TextSize = 14
Instance.new("UICorner", RockName).CornerRadius = UDim.new(0, 6)

local AutoFarmButton = Instance.new("TextButton", MainGUI)
AutoFarmButton.Text = "🔁 Farm Minério"
AutoFarmButton.Size = UDim2.new(0, 230, 0, 35)
AutoFarmButton.Position = UDim2.new(0, 15, 0, 80)
AutoFarmButton.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
AutoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmButton.Font = Enum.Font.GothamBlack
AutoFarmButton.TextSize = 15
Instance.new("UICorner", AutoFarmButton).CornerRadius = UDim.new(0, 6)

local flying = false
AutoFarmButton.MouseButton1Click:Connect(function()
	flying = not flying
	while flying and task.wait(0.5) do
		local char = LocalPlayer.Character
		if not char then continue end

		local rockName = RockName.Text
		local ore = workspace:FindFirstChild("Ores") and workspace.Ores:FindFirstChild(rockName)
		if ore and ore:FindFirstChild("Reference") then
			local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
			if tool then tool.Parent = char end

			-- Animação de voo
			local goal = { CFrame = ore.Reference.CFrame + Vector3.new(0, 5, 0) }
			TweenService:Create(char.HumanoidRootPart, TweenInfo.new(0.5), goal):Play()
			task.wait(0.6)

			-- Atacar minério
			if tool then
				ReplicatedStorage.Events:WaitForChild("DestroyModel"):FireServer(tool, char.HumanoidRootPart.CFrame)
			end

			-- Coletar drop
			for _, drop in pairs(workspace:GetDescendants()) do
				if drop:IsA("Part") and drop.Name == rockName and (drop.Position - char.HumanoidRootPart.Position).Magnitude < 15 then
					char.HumanoidRootPart.CFrame = drop.CFrame
					task.wait(0.2)
					pcall(function()
						ReplicatedStorage.Events:FindFirstChild("Pick up"):FireServer(drop)
					end)
				end
			end
		end
	end
end)

-------------------- ⚙️ Seção: OPÇÕES --------------------
-- Select Menu (Dropdown)
local PlayerSelect = Instance.new("TextButton", MainGUI)
PlayerSelect.Text = "👤 Teleportar para jogador"
PlayerSelect.Size = UDim2.new(0, 230, 0, 30)
PlayerSelect.Position = UDim2.new(0, 15, 0, 130)
PlayerSelect.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerSelect.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerSelect.Font = Enum.Font.Gotham
PlayerSelect.TextSize = 13
Instance.new("UICorner", PlayerSelect).CornerRadius = UDim.new(0, 6)

PlayerSelect.MouseButton1Click:Connect(function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local button = Instance.new("TextButton", MainGUI)
			button.Text = "➡️ " .. p.Name
			button.Size = UDim2.new(0, 230, 0, 25)
			button.Position = UDim2.new(0, 15, 0, 165 + (#MainGUI:GetChildren() * 27))
			button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
			button.Font = Enum.Font.Gotham
			button.TextSize = 12
			Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)

			button.MouseButton1Click:Connect(function()
				local targetChar = p.Character
				if targetChar then
					LocalPlayer.Character.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
				end
			end)
		end
	end
end)

-- Speed Slider
local Speed = 16
local SpeedBtn = Instance.new("TextButton", MainGUI)
SpeedBtn.Text = "⚡ Speed: 16"
SpeedBtn.Size = UDim2.new(0, 230, 0, 30)
SpeedBtn.Position = UDim2.new(0, 15, 0, 210)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.Font = Enum.Font.Gotham
SpeedBtn.TextSize = 13
Instance.new("UICorner", SpeedBtn).CornerRadius = UDim.new(0, 6)

SpeedBtn.MouseButton1Click:Connect(function()
	Speed = Speed + 16
	if Speed > 100 then Speed = 16 end
	SpeedBtn.Text = "⚡ Speed: " .. Speed
	LocalPlayer.Character.Humanoid.WalkSpeed = Speed
end)

-- Jump Slider
local Jump = 50
local JumpBtn = Instance.new("TextButton", MainGUI)
JumpBtn.Text = "🦘 Jump: 50"
JumpBtn.Size = UDim2.new(0, 230, 0, 30)
JumpBtn.Position = UDim2.new(0, 15, 0, 250)
JumpBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
JumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpBtn.Font = Enum.Font.Gotham
JumpBtn.TextSize = 13
Instance.new("UICorner", JumpBtn).CornerRadius = UDim.new(0, 6)

JumpBtn.MouseButton1Click:Connect(function()
	Jump = Jump + 25
	if Jump > 150 then Jump = 50 end
	JumpBtn.Text = "🦘 Jump: " .. Jump
	LocalPlayer.Character.Humanoid.JumpPower = Jump
end)

-- ESP Players
local function enableESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			if not player.Character.Head:FindFirstChild("ESP") then
				local billboard = Instance.new("BillboardGui", player.Character.Head)
				billboard.Name = "ESP"
				billboard.Size = UDim2.new(0, 100, 0, 40)
				billboard.AlwaysOnTop = true
				local label = Instance.new("TextLabel", billboard)
				label.Size = UDim2.new(1, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.Text = "👁‍🗨 " .. player.Name
				label.TextColor3 = Color3.new(0, 0.7, 1)
				label.TextScaled = true
			end
		end
	end
end

local ESPBtn = Instance.new("TextButton", MainGUI)
ESPBtn.Text = "👁‍🗨 Ativar ESP"
ESPBtn.Size = UDim2.new(0, 230, 0, 30)
ESPBtn.Position = UDim2.new(0, 15, 0, 290)
ESPBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ESPBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
ESPBtn.Font = Enum.Font.GothamBlack
ESPBtn.TextSize = 14
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0, 6)

ESPBtn.MouseButton1Click:Connect(function()
	enableESP()
end)
