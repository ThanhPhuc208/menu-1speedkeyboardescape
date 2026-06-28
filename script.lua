local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local player = Players.LocalPlayer

local autoWinEnabled = false
local autoClickEnabled = false

local function getWinPart()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and (v.Name:lower():match("win") or v.Name:lower():match("finish") or v.Name:lower():match("trophy")) then
			return v
		end
	end
	return nil
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThanhPhucHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 200)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(50, 50, 50)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "THANH PHUC ON TOP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local AutoWinBtn = Instance.new("TextButton")
AutoWinBtn.Size = UDim2.new(0, 220, 0, 40)
AutoWinBtn.Position = UDim2.new(0.5, -110, 0.25, 5)
AutoWinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AutoWinBtn.BorderSizePixel = 0
AutoWinBtn.Text = "AUTO WIN: ĐANG TẮT"
AutoWinBtn.TextColor3 = Color3.fromRGB(255, 65, 65)
AutoWinBtn.TextSize = 13
AutoWinBtn.Font = Enum.Font.SourceSansBold
AutoWinBtn.Parent = MainFrame

local Corner1 = Instance.new("UICorner")
Corner1.CornerRadius = UDim.new(0, 6)
Corner1.Parent = AutoWinBtn

local Stroke1 = Instance.new("UIStroke")
Stroke1.Color = Color3.fromRGB(60, 60, 60)
Stroke1.Thickness = 1
Stroke1.Parent = AutoWinBtn

local AutoClickBtn = Instance.new("TextButton")
AutoClickBtn.Size = UDim2.new(0, 220, 0, 40)
AutoClickBtn.Position = UDim2.new(0.5, -110, 0.5, 15)
AutoClickBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AutoClickBtn.BorderSizePixel = 0
AutoClickBtn.Text = "AUTO NHẶT PHÍM: ĐANG TẮT"
AutoClickBtn.TextColor3 = Color3.fromRGB(255, 65, 65)
AutoClickBtn.TextSize = 13
AutoClickBtn.Font = Enum.Font.SourceSansBold
AutoClickBtn.Parent = MainFrame

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0, 6)
Corner2.Parent = AutoClickBtn

local Stroke2 = Instance.new("UIStroke")
Stroke2.Color = Color3.fromRGB(60, 60, 60)
Stroke2.Thickness = 1
Stroke2.Parent = AutoClickBtn

local HintText = Instance.new("TextLabel")
HintText.Size = UDim2.new(1, 0, 0, 20)
HintText.Position = UDim2.new(0, 0, 1, -20)
HintText.BackgroundTransparency = 1
HintText.Text = "Gõ '/speed' trong chat để ẩn/hiện"
HintText.TextColor3 = Color3.fromRGB(100, 100, 100)
HintText.TextSize = 11
HintText.Font = Enum.Font.SourceSansItalic
HintText.Parent = MainFrame

local function toggleMenu(msg)
	if msg:lower() == "/speed" then
		MainFrame.Visible = not MainFrame.Visible
	end
end
player.Chatted:Connect(toggleMenu)
pcall(function()
	TextChatService.MessageReceived:Connect(function(message)
		if message.TextSource and message.TextSource.UserId == player.UserId then
			toggleMenu(message.Text)
		end
	end)
end)

task.spawn(function()
	while task.wait(0.5) do
		if autoWinEnabled then
			local char = player.Character
			local rootPart = char and char:FindFirstChild("HumanoidRootPart")
			if rootPart then
				local winPart = getWinPart()
				if winPart then
					rootPart.CFrame = winPart.CFrame + Vector3.new(0, 2, 0)
				end
			end
		end
	end
end)

task.spawn(function()
	while task.wait(0.1) do
		if autoClickEnabled then
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("ClickDetector") then
					fireclickdetector(v)
				end
			end
			local char = player.Character
			local rootPart = char and char:FindFirstChild("HumanoidRootPart")
			if rootPart then
				for _, v in pairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") and (v.Name:lower():match("key") or v.Name:lower():match("board") or v.Name:lower():match("speed")) then
						if (rootPart.Position - v.Position).Magnitude < 30 then
							firetouchinterest(rootPart, v, 0)
							firetouchinterest(rootPart, v, 1)
						end
					end
				end
			end
		end
	end
end)

AutoWinBtn.MouseButton1Click:Connect(function()
	autoWinEnabled = not autoWinEnabled
	if autoWinEnabled then
		AutoWinBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
		AutoWinBtn.Text = "AUTO WIN: ĐANG BẬT"
	else
		AutoWinBtn.TextColor3 = Color3.fromRGB(255, 65, 65)
		AutoWinBtn.Text = "AUTO WIN: ĐANG TẮT"
	end
end)

AutoClickBtn.MouseButton1Click:Connect(function()
	autoClickEnabled = not autoClickEnabled
	if autoClickEnabled then
		AutoClickBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
		AutoClickBtn.Text = "AUTO NHẶT PHÍM: ĐANG BẬT"
	else
		AutoClickBtn.TextColor3 = Color3.fromRGB(255, 65, 65)
		AutoClickBtn.Text = "AUTO NHẶT PHÍM: ĐANG TẮT"
	end
end)

