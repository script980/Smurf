-- 💙 Smurfs Hub 💙 | Funciona em qualquer jogo agora

local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
end)

if not success then
    warn("OrionLib não carregado!")
    return
end

local iconID = "rbxassetid://130657275856887"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = OrionLib:MakeWindow({
    Name = "💙 Smurfs Hub 💙",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "SmurfsHub",
    IntroEnabled = true,
    IntroText = "💙 Smurfs Hub 💙",
    Icon = iconID
})

local FarmTab = Window:MakeTab({ Name = "Farm", Icon = iconID, PremiumOnly = false })
local OptionsTab = Window:MakeTab({ Name = "Opções", Icon = iconID, PremiumOnly = false })

local Speed = 16
local Jump = 50
local Fly = false
local FlyConnection

OptionsTab:AddSlider({
    Name = "Velocidade",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    ValueName = "Vel",
    Callback = function(value)
        Speed = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end
})

OptionsTab:AddSlider({
    Name = "Pulo",
    Min = 50,
    Max = 300,
    Default = 50,
    Increment = 1,
    ValueName = "Jump",
    Callback = function(value)
        Jump = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = value
        end
    end
})

OptionsTab:AddToggle({
    Name = "Ativar Voo (Superman)",
    Default = false,
    Callback = function(state)
        Fly = state
        if Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local HRP = LocalPlayer.Character.HumanoidRootPart
            local BodyVelocity = Instance.new("BodyVelocity", HRP)
            BodyVelocity.Name = "SmurfFly"
            BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            BodyVelocity.Velocity = Vector3.zero

            FlyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if Fly and HRP then
                    BodyVelocity.Velocity = HRP.CFrame.LookVector * Speed + Vector3.new(0, 3, 0)
                end
            end)
        else
            local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if HRP and HRP:FindFirstChild("SmurfFly") then
                HRP.SmurfFly:Destroy()
            end
            if FlyConnection then
                FlyConnection:Disconnect()
            end
        end
    end
})

OptionsTab:AddParagraph("💡 Dica", "Esse hub detecta o jogo automaticamente e tenta executar farm de minério se possível. Use as opções acima em qualquer jogo.")

-- ESP compatível em qualquer jogo
OptionsTab:AddToggle({
    Name = "ESP básico (nome + distância)",
    Default = false,
    Callback = function(enabled)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char and char:FindFirstChild("Head") then
                    if enabled and not char:FindFirstChild("ESP") then
                        local esp = Instance.new("BillboardGui", char)
                        esp.Name = "ESP"
                        esp.Adornee = char.Head
                        esp.Size = UDim2.new(0, 200, 0, 50)
                        esp.AlwaysOnTop = true
                        esp.StudsOffset = Vector3.new(0, 2, 0)

                        local label = Instance.new("TextLabel", esp)
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.TextScaled = true

                        game:GetService("RunService").RenderStepped:Connect(function()
                            if label and char:FindFirstChild("HumanoidRootPart") then
                                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
                                label.Text = player.Name .. " | " .. dist .. "m | " .. player.AccountAge .. "d"
                            end
                        end)
                    elseif not enabled and char:FindFirstChild("ESP") then
                        char.ESP:Destroy()
                    end
                end
            end
        end
    end
})

-- Teleporte
local playerList = {}
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        table.insert(playerList, plr.Name)
    end
end

local targetPlayer = nil

OptionsTab:AddDropdown({
    Name = "Selecionar jogador",
    Default = "",
    Options = playerList,
    Callback = function(val)
        targetPlayer = val
    end
})

OptionsTab:AddButton({
    Name = "Teleportar até jogador",
    Callback = function()
        local target = Players:FindFirstChild(targetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
})
