-- 📘 MOREIRA METHOD GUI by ChatGPT

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoreiraMethodGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Crear Frame principal
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 400, 0, 180)
frame.Position = UDim2.new(0.5, -200, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Bordes redondeados
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = frame

-- Título "MOREIRA METHOD"
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "MOREIRA METHOD"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.TextStrokeTransparency = 0.4
title.Parent = frame

-- Porcentaje
local percentLabel = Instance.new("TextLabel")
percentLabel.Name = "PercentLabel"
percentLabel.Size = UDim2.new(1, 0, 0, 40)
percentLabel.Position = UDim2.new(0, 0, 0, 70)
percentLabel.BackgroundTransparency = 1
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextScaled = true
percentLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
percentLabel.Text = "0%"
percentLabel.Parent = frame

-- Barra de fondo
local barBackground = Instance.new("Frame")
barBackground.Name = "BarBackground"
barBackground.Size = UDim2.new(0.9, 0, 0, 25)
barBackground.Position = UDim2.new(0.05, 0, 1, -45)
barBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
barBackground.BorderSizePixel = 0
barBackground.Parent = frame

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 8)
bgCorner.Parent = barBackground

-- Barra de progreso
local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = barBackground

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 8)
barCorner.Parent = progressBar

-- Animación de carga (10 minutos = 600 segundos)
local totalTime = 600
for i = 0, totalTime do
	local progress = i / totalTime
	progressBar.Size = UDim2.new(progress, 0, 1, 0)
	percentLabel.Text = string.format("%d%%", math.floor(progress * 100))
	task.wait(1)
end

percentLabel.Text = "100%"
