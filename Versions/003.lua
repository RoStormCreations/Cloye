local Library = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Variables
Library.Theme = {
    Background = Color3.fromRGB(30, 30, 30), -- Dark background
    Topbar = Color3.fromRGB(40, 40, 40), -- Darker top bar for contrast
    ElementBackground = Color3.fromRGB(45, 45, 45), -- Dark grey element background
    ElementHover = Color3.fromRGB(60, 60, 60), -- Hover effect for elements
    Text = Color3.fromRGB(255, 255, 255), -- White text
    Accent = Color3.fromRGB(70, 130, 180), -- Blue accent color
    CloseButton = Color3.fromRGB(255, 100, 100), -- Red close button
    ButtonGradientStart = Color3.fromRGB(100, 100, 255), -- Button gradient start
    ButtonGradientEnd = Color3.fromRGB(70, 130, 180), -- Button gradient end
    ButtonShadow = Color3.fromRGB(0, 0, 0), -- Button shadow
    ToggleOn = Color3.fromRGB(70, 130, 180), -- Accent color for toggled state
    ToggleOff = Color3.fromRGB(100, 100, 100), -- Dimmed color for untoggled state
}

-- Create Window
function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUILibrary"
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BackgroundTransparency = 0.5
    MainFrame.Size = UDim2.new(0, 450, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BorderSizePixel = 0

    -- Blur effect for window background
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Parent = MainFrame
    BlurEffect.Size = 24

    -- Topbar Frame
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Library.Theme.Topbar
    Topbar.BackgroundTransparency = 0.3
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BorderSizePixel = 0

    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Topbar
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Font = Enum.Font.SourceSans
    Title.Text = title or "UI Library"
    Title.TextColor3 = Library.Theme.Text
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Topbar
    CloseButton.BackgroundColor3 = Library.Theme.CloseButton
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Library.Theme.Text
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.SourceSans
    CloseButton.TextButtonStyle = Enum.ButtonStyle.RobloxButton

    -- Close button hover effect
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 150, 150)}):Play()
    end)
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.1), {BackgroundColor3 = Library.Theme.CloseButton}):Play()
    end)

    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Dragging functionality
    local dragging, dragInput, dragStart, startPos

    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame
    }
end

-- Button with Gradient, Shadow, and Hover Effect
function Library:CreateButton(window, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Parent = window.MainFrame
    Button.BackgroundColor3 = Library.Theme.ElementBackground
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, 70)
    Button.Font = Enum.Font.SourceSans
    Button.Text = text or "Button"
    Button.TextColor3 = Library.Theme.Text
    Button.TextSize = 16

    -- Gradient for button
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Parent = Button
    UIGradient.Color = ColorSequence.new(Library.Theme.ButtonGradientStart, Library.Theme.ButtonGradientEnd)

    -- Shadow for button
    local Shadow = Instance.new("UIStroke")
    Shadow.Parent = Button
    Shadow.Color = Library.Theme.ButtonShadow
    Shadow.Thickness = 5
    Shadow.Transparency = 0.8

    -- Hover effect
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.1}):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.3}):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return Button
end

-- Toggle Button with Animation
function Library:CreateToggle(window, text, initialState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Parent = window.MainFrame
    ToggleFrame.BackgroundColor3 = Library.Theme.ElementBackground
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.Position = UDim2.new(0, 10, 0, 120)

    -- Toggle label
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(0, 100, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
    ToggleLabel.Font = Enum.Font.SourceSans
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Library.Theme.Text
    ToggleLabel.TextSize = 16

    -- Toggle button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = initialState and Library.Theme.ToggleOn or Library.Theme.ToggleOff
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -60, 0, 8)
    ToggleButton.Text = ""
    ToggleButton.TextButtonStyle = Enum.ButtonStyle.RobloxButton

    -- Toggle animation
    local ToggleTween = TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = initialState and UDim2.new(1, -60, 0, 8) or UDim2.new(1, -110, 0, 8)})
    ToggleTween:Play()

    -- Toggle button functionality
    ToggleButton.MouseButton1Click:Connect(function()
        initialState = not initialState
        ToggleTween = TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = initialState and UDim2.new(1, -60, 0, 8) or UDim2.new(1, -110, 0, 8)})
        ToggleTween:Play()

        if callback then
            callback(initialState)
        end
    end)

    return ToggleButton
end

return Library
