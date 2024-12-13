local Library = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Theme Variables (Neumorphism)
Library.Theme = {
    Background = Color3.fromRGB(235, 235, 235),
    Topbar = Color3.fromRGB(250, 250, 250),
    ElementBackground = Color3.fromRGB(240, 240, 240),
    ElementShadow = Color3.fromRGB(180, 180, 180),
    ElementHover = Color3.fromRGB(225, 225, 225),
    Accent = Color3.fromRGB(100, 150, 255),
    Text = Color3.fromRGB(40, 40, 40),
    CloseButton = Color3.fromRGB(255, 100, 100),
    ButtonGradientStart = Color3.fromRGB(100, 100, 255),
    ButtonGradientEnd = Color3.fromRGB(70, 130, 180),
}

-- Neumorphism Button Creation
function Library:CreateNeumorphicButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Parent = parent
    Button.BackgroundColor3 = Library.Theme.ElementBackground
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, 10)
    Button.Font = Enum.Font.SourceSans
    Button.Text = text or "Button"
    Button.TextColor3 = Library.Theme.Text
    Button.TextSize = 16

    -- Neumorphic inset shadow
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = Button
    UIStroke.Color = Library.Theme.ElementShadow
    UIStroke.Thickness = 4
    UIStroke.Transparency = 0.7

    -- Hover Effect (Neumorphic)
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Library.Theme.ElementHover
        TweenService:Create(Button, TweenInfo.new(0.2), {Position = UDim2.new(0, 10, 0, 5)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Library.Theme.ElementBackground
        TweenService:Create(Button, TweenInfo.new(0.2), {Position = UDim2.new(0, 10, 0, 10)}):Play()
    end)

    -- Click Event
    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return Button
end

-- Toggle Creation
function Library:CreateNeumorphicToggle(parent, text, initialState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Library.Theme.ElementBackground
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.Position = UDim2.new(0, 10, 0, 70)

    -- Label for Toggle
    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0, 100, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Font = Enum.Font.SourceSans
    Label.Text = text
    Label.TextColor3 = Library.Theme.Text
    Label.TextSize = 16

    -- Toggle Button (Slider)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = initialState and Library.Theme.Accent or Library.Theme.ElementShadow
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -60, 0, 8)
    ToggleButton.Text = ""
    ToggleButton.TextButtonStyle = Enum.ButtonStyle.RobloxButton

    -- Toggle Animation
    local ToggleTween = TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = initialState and UDim2.new(1, -60, 0, 8) or UDim2.new(1, -110, 0, 8)})
    ToggleTween:Play()

    -- Toggle Event
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
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BorderSizePixel = 0

    -- Topbar Frame
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Library.Theme.Topbar
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

    -- Tab Button (Switching between content)
    local TabButtonFrame = Instance.new("Frame")
    TabButtonFrame.Name = "TabButtonFrame"
    TabButtonFrame.Parent = MainFrame
    TabButtonFrame.BackgroundTransparency = 1
    TabButtonFrame.Size = UDim2.new(1, -20, 0, 50)
    TabButtonFrame.Position = UDim2.new(0, 10, 0, 40)

    local TabButton1 = Instance.new("TextButton")
    TabButton1.Parent = TabButtonFrame
    TabButton1.Size = UDim2.new(0, 150, 0, 40)
    TabButton1.Position = UDim2.new(0, 0, 0, 0)
    TabButton1.Text = "Tab 1"
    TabButton1.TextColor3 = Library.Theme.Text
    TabButton1.Font = Enum.Font.SourceSans
    TabButton1.BackgroundColor3 = Library.Theme.ElementBackground
    TabButton1.TextSize = 16

    local TabButton2 = Instance.new("TextButton")
    TabButton2.Parent = TabButtonFrame
    TabButton2.Size = UDim2.new(0, 150, 0, 40)
    TabButton2.Position = UDim2.new(0, 160, 0, 0)
    TabButton2.Text = "Tab 2"
    TabButton2.TextColor3 = Library.Theme.Text
    TabButton2.Font = Enum.Font.SourceSans
    TabButton2.BackgroundColor3 = Library.Theme.ElementBackground
    TabButton2.TextSize = 16

    -- Tab Content Area
    local TabContentFrame = Instance.new("Frame")
    TabContentFrame.Parent = MainFrame
    TabContentFrame.Size = UDim2.new(1, -20, 0, 300)
    TabContentFrame.Position = UDim2.new(0, 10, 0, 90)

    -- First Tab Content (Example Buttons, Toggles)
    local Tab1Content = Instance.new("Frame")
    Tab1Content.Parent = TabContentFrame
    Tab1Content.Size = UDim2.new(1, 0, 1, 0)
    Tab1Content.BackgroundTransparency = 1

    -- Add elements to Tab 1
    Library:CreateNeumorphicButton(Tab1Content, "Button 1", function()
        print("Button 1 clicked in Tab 1")
    end)

    Library:CreateNeumorphicToggle(Tab1Content, "Enable Something", false, function(state)
        print("Feature in Tab 1:", state)
    end)

    -- Second Tab Content (Different Elements)
    local Tab2Content = Instance.new("Frame")
    Tab2Content.Parent = TabContentFrame
    Tab2Content.Size = UDim2.new(1, 0, 1, 0)
    Tab2Content.BackgroundTransparency = 1

    -- Add elements to Tab 2
    Library:CreateNeumorphicButton(Tab2Content, "Button 2", function()
        print("Button 2 clicked in Tab 2")
    end)

    Library:CreateNeumorphicToggle(Tab2Content, "Enable Another Feature", true, function(state)
        print("Feature in Tab 2:", state)
    end)

    -- Switch between Tabs
    TabButton1.MouseButton1Click:Connect(function()
        Tab1Content.Visible = true
        Tab2Content.Visible = false
    end)

    TabButton2.MouseButton1Click:Connect(function()
        Tab1Content.Visible = false
        Tab2Content.Visible = true
    end)

    -- Initially show Tab 1 content
    Tab1Content.Visible = true
    Tab2Content.Visible = false

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame
    }
end

return Library
