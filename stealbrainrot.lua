-- Steal a Brainrot Base Script GUI
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.3, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🧠 Brainrot Tool"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Speed Boost Button
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(1, 0, 0.3, 0)
speedBtn.Position = UDim2.new(0, 0, 0.4, 0)
speedBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
speedBtn.Text = "Speed Boost"
speedBtn.TextColor3 = Color3.new(1, 1, 1)
speedBtn.Font = Enum.Font.Gotham
speedBtn.TextSize = 14
speedBtn.Parent = frame

speedBtn.MouseButton1Click:Connect(function()
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 50
	end
end)

-- Jump Boost Button
local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(1, 0, 0.3, 0)
jumpBtn.Position = UDim2.new(0, 0, 0.7, 0)
jumpBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 80)
jumpBtn.Text = "Jump Boost"
jumpBtn.TextColor3 = Color3.new(1, 1, 1)
jumpBtn.Font = Enum.Font.Gotham
jumpBtn.TextSize = 14
jumpBtn.Parent = frame

jumpBtn.MouseButton1Click:Connect(function()
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.JumpPower = 100
	end
end)
