local GlassmorphismUI = {}

-- Function to create a glassmorphism-style Frame
function GlassmorphismUI.createGlassFrame(parent, size, position, blurAmount, transparency)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.Parent = parent

    -- Background transparency and blur effect
    frame.BackgroundTransparency = transparency or 0.4
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- White base color for the glass effect

    -- Adding blur effect (using a UIBlurEffect)
    local blur = Instance.new("BlurEffect")
    blur.Parent = frame
    blur.Size = blurAmount or 24  -- Default blur size is 24

    -- Apply rounded corners
    local corner = Instance.new("UICorner")
    corner.Parent = frame

    return frame
end

-- Function to create a glassmorphism-style TextLabel
function GlassmorphismUI.createGlassLabel(parent, size, position, text, fontSize, blurAmount, transparency)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.Text = text
    label.Parent = parent

    -- Text properties
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = fontSize or 24  -- Default font size is 24
    label.TextTransparency = 0.1  -- Slight transparency for text to blend well with the glass effect

    -- Background transparency and blur effect
    label.BackgroundTransparency = transparency or 0.4
    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    -- Adding blur effect (using a UIBlurEffect)
    local blur = Instance.new("BlurEffect")
    blur.Parent = label
    blur.Size = blurAmount or 24  -- Default blur size is 24

    -- Apply rounded corners
    local corner = Instance.new("UICorner")
    corner.Parent = label

    return label
end

-- Function to create a glassmorphism-style ImageLabel
function GlassmorphismUI.createGlassImage(parent, size, position, imageId, blurAmount, transparency)
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = size
    imageLabel.Position = position
    imageLabel.Image = imageId
    imageLabel.Parent = parent

    -- Background transparency and blur effect
    imageLabel.BackgroundTransparency = transparency or 0.4
    imageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    -- Adding blur effect (using a UIBlurEffect)
    local blur = Instance.new("BlurEffect")
    blur.Parent = imageLabel
    blur.Size = blurAmount or 24  -- Default blur size is 24

    -- Apply rounded corners
    local corner = Instance.new("UICorner")
    corner.Parent = imageLabel

    return imageLabel
end

-- Function to create a glassmorphism-style Button with glowing gradient effect on hover
function GlassmorphismUI.createGlassButton(parent, size, position, text, fontSize, blurAmount, transparency)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.Text = text
    button.Parent = parent

    -- Text properties
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = fontSize or 24  -- Default font size is 24
    button.TextTransparency = 0.1  -- Slight transparency for text to blend well with the glass effect

    -- Background transparency and blur effect
    button.BackgroundTransparency = transparency or 0.4
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    -- Adding blur effect (using a UIBlurEffect)
    local blur = Instance.new("BlurEffect")
    blur.Parent = button
    blur.Size = blurAmount or 24  -- Default blur size is 24

    -- Apply rounded corners
    local corner = Instance.new("UICorner")
    corner.Parent = button

    -- Gradient effect
    local gradient = Instance.new("UIGradient")
    gradient.Parent = button
    gradient.Color = ColorSequence.new(
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 0, 255)
    )
    gradient.Rotation = 45

    -- Hover effect for glowing gradient animation
    button.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local goal = { BackgroundTransparency = 0.2 }
        local tween = game:GetService("TweenService"):Create(button, tweenInfo, goal)
        tween:Play()
    end)

    button.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local goal = { BackgroundTransparency = 0.4 }
        local tween = game:GetService("TweenService"):Create(button, tweenInfo, goal)
        tween:Play()
    end)

    return button
end

-- Function to create a glassmorphism-style Slider
function GlassmorphismUI.createGlassSlider(parent, size, position, minValue, maxValue, defaultValue, transparency)
    local slider = Instance.new("Frame")
    slider.Size = size
    slider.Position = position
    slider.Parent = parent
    slider.BackgroundTransparency = transparency or 0.4
    slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    -- Slider bar
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 10)
    sliderBar.Position = UDim2.new(0, 0, 0.5, -5)
    sliderBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sliderBar.Parent = slider

    -- Slider handle
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 20, 0, 20)
    handle.Position = UDim2.new(0, (defaultValue - minValue) / (maxValue - minValue) * sliderBar.Size.X.Offset, 0.5, -10)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.BorderRadius = UDim.new(0.5, 0)
    handle.Parent = sliderBar

    -- Input handling
    local dragging = false
    local function updateSlider(input)
        if dragging then
            local newX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.Size.X.Offset)
            handle.Position = UDim2.new(0, newX, 0.5, -10)
            local newValue = minValue + (newX / sliderBar.Size.X.Offset) * (maxValue - minValue)
            return newValue
        end
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    return slider
end

return GlassmorphismUI
