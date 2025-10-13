-- 📘 MOREIRA METHOD - Private Server Checker GUI
-- Made by ChatGPT 💙

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoreiraMethodGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal (pantalla completa)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(1, 0, 1, 0)
frame.Position = UDim2.new(0, 0, 0, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Título principal
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 80)
title.Position = UDim2.new(0, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "MOREIRA METHOD"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.TextStrokeTransparency = 0.4
title.Parent = frame

-- Mensaje de advertencia
local warningLabel = Instance.new("TextLabel")
warningLabel.Name = "WarningLabel"
warningLabel.Size = UDim2.new(1, -100, 0, 50)
warningLabel.Position = UDim2.new(0, 50, 0, 180)
warningLabel.BackgroundTransparency = 1
warningLabel.Font = Enum.Font.GothamBold
warningLabel.TextScaled = true
warningLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
warningLabel.Text = ""
warningLabel.Parent = frame

-- TextBox para link
local linkBox = Instance.new("TextBox")
linkBox.Name = "LinkBox"
linkBox.Size = UDim2.new(0.6, 0, 0, 50)
linkBox.Position = UDim2.new(0.2, 0, 0.6, 0)
linkBox.PlaceholderText = "Enter your private server link here..."
linkBox.Font = Enum.Font.Gotham
linkBox.TextScaled = true
linkBox.TextColor3 = Color3.fromRGB(255, 255, 255)
linkBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
linkBox.BorderSizePixel = 0
linkBox.ClearTextOnFocus = false
linkBox.Parent = frame

local linkCorner = Instance.new("UICorner")
linkCorner.CornerRadius = UDim.new(0, 8)
linkCorner.Parent = linkBox

-- Botón verde "Send"
local sendButton = Instance.new("TextButton")
sendButton.Name = "SendButton"
sendButton.Size = UDim2.new(0, 140, 0, 50)
sendButton.Position = UDim2.new(0.5, -70, 0.75, 0)
sendButton.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
sendButton.Font = Enum.Font.GothamBold
sendButton.Text = "SEND"
sendButton.TextScaled = true
sendButton.TextColor3 = Color3.new(1, 1, 1)
sendButton.Parent = frame

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 8)
sendCorner.Parent = sendButton

-- Verificar si está en un servidor privado
local privateServerId = game.PrivateServerId
local privateServerOwnerId = game.PrivateServerOwnerId
local isPrivateServer = privateServerId ~= "" and privateServerOwnerId ~= 0

if not isPrivateServer then
    warningLabel.Text = "You must be in a private server to use this feature."
else
    warningLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    warningLabel.Text = "Private server detected ✅"
end

-- Acción del botón
sendButton.MouseButton1Click:Connect(function()
    local link = linkBox.Text
    if link == "" then
        warningLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        warningLabel.Text = "Please enter your private server link first!"
        return
    end

    print("🔗 Private server link entered:", link)
    warningLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    warningLabel.Text = "Link received! Processing..."
end)
