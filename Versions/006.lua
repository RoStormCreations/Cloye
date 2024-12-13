-- UI Library
local UILibrary = {}

-- Function to create a new Frame
function UILibrary.CreateFrame(parent, size, position, backgroundColor, name)
    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(0, 100, 0, 100)
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = backgroundColor or Color3.fromRGB(255, 255, 255)
    frame.Name = name or "Frame"
    frame.Parent = parent
    return frame
end

-- Function to create a new TextLabel
function UILibrary.CreateLabel(parent, text, size, position, textColor, name)
    local label = Instance.new("TextLabel")
    label.Text = text or "Label"
    label.Size = size or UDim2.new(0, 100, 0, 50)
    label.Position = position or UDim2.new(0, 0, 0, 0)
    label.TextColor3 = textColor or Color3.fromRGB(0, 0, 0)
    label.BackgroundTransparency = 1
    label.Name = name or "Label"
    label.Parent = parent
    return label
end

-- Function to create a new TextButton
function UILibrary.CreateButton(parent, text, size, position, callback, textColor, backgroundColor, name)
    local button = Instance.new("TextButton")
    button.Text = text or "Button"
    button.Size = size or UDim2.new(0, 100, 0, 50)
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = backgroundColor or Color3.fromRGB(0, 0, 255)
    button.Name = name or "Button"
    button.Parent = parent
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return button
end

-- Function to create a new TextBox
function UILibrary.CreateTextBox(parent, size, position, placeholderText, textColor, backgroundColor, name)
    local textBox = Instance.new("TextBox")
    textBox.Size = size or UDim2.new(0, 100, 0, 50)
    textBox.Position = position or UDim2.new(0, 0, 0, 0)
    textBox.PlaceholderText = placeholderText or "Enter text..."
    textBox.TextColor3 = textColor or Color3.fromRGB(0, 0, 0)
    textBox.BackgroundColor3 = backgroundColor or Color3.fromRGB(255, 255, 255)
    textBox.Name = name or "TextBox"
    textBox.Parent = parent
    return textBox
end

return UILibrary
