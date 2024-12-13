local Library = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Variables
Library.Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Topbar = Color3.fromRGB(45, 45, 45),
    ElementBackground = Color3.fromRGB(40, 40, 40),
    ElementHover = Color3.fromRGB(50, 50, 50),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(70, 130, 180),
    CloseButton = Color3.fromRGB(255, 100, 100),
    ToggleOn = Color3.fromRGB(70, 130, 180), -- Accent color for the 'on' state
    ToggleOff = Color3.fromRGB(100, 100, 100) -- Dimmed color for the 'off' state
}

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUILibrary"
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BackgroundTransparency = 0.5 -- Adjust transparency for blurred glass effect
    MainFrame.Size = UDim2.new(0, 400, 0, 400) -- Increased height for tabs and toggles
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Parent = MainFrame
    BlurEffect.Size = 24 -- Adjust the blur intensity

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Library.Theme.Topbar
    Topbar.BackgroundTransparency = 0.3 -- Partial transparency for glass effect
    Topbar.Size = UDim2.new(1, 0, 0, 30)
    Topbar.BorderSizePixel = 0

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Topbar
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -30, 1, 0)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Font = Enum.Font.SourceSans
    Title.Text = title or "UI Library"
    Title.TextColor3 = Library.Theme.Text
    Title.TextSize = 18

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Topbar
    CloseButton.BackgroundColor3 = Library.Theme.CloseButton
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Library.Theme.Text
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.SourceSans

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Enable dragging for the window
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

    -- Tab System (from previous code)
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Library.Theme.Topbar
    TabContainer.Size = UDim2.new(1, 0, 0, 40) -- Height for the tab buttons
    TabContainer.Position = UDim2.new(0, 0, 0, 30)

    local TabButtons = {}
    local TabContents = {}

    function Library:CreateTab(tabName, contentCallback)
        -- Create a tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Library.Theme.ElementBackground
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.Position = UDim2.new(0, #TabButtons * 100, 0, 0) -- Position tabs side by side
        TabButton.Font = Enum.Font.SourceSans
        TabButton.Text = tabName
        TabButton.TextColor3 = Library.Theme.Text
        TabButton.TextSize = 16

        -- Create the tab content area
        local TabContent = Instance.new("Frame")
        TabContent.Name = tabName.."Content"
        TabContent.Parent = MainFrame
        TabContent.BackgroundColor3 = Library.Theme.ElementBackground
        TabContent.Size = UDim2.new(1, 0, 1, -70) -- Adjust height for tabs
        TabContent.Position = UDim2.new(0, 0, 0, 70)
        TabContent.Visible = false -- Hide by default

        -- Add custom content to this tab via the callback
        if contentCallback then
            contentCallback(TabContent)
        end

        -- Handle tab button clicks
        TabButton.MouseButton1Click:Connect(function()
            for _, content in pairs(TabContents) do
                content.Visible = false -- Hide all tab contents
            end
            TabContent.Visible = true -- Show the clicked tab's content
        end)

        -- Add to TabButtons and TabContents for later management
        table.insert(TabButtons, TabButton)
        table.insert(TabContents, TabContent)
    end

    -- Create Toggle (Switch)
    function Library:CreateToggle(window, text, initialState, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = "ToggleFrame"
        ToggleFrame.Parent = window.MainFrame
        ToggleFrame.BackgroundColor3 = Library.Theme.ElementBackground
        ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
        ToggleFrame.Position = UDim2.new(0, 10, 0, 50)
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Size = UDim2.new(0, 100, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
        ToggleLabel.Font = Enum.Font.SourceSans
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = Library.Theme.Text
        ToggleLabel.TextSize = 16

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleFrame
        ToggleButton.BackgroundColor3 = initialState and Library.Theme.ToggleOn or Library.Theme.ToggleOff
        ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        ToggleButton.Position = UDim2.new(1, -50, 0, 5)
        ToggleButton.Text = ""
        
        local function updateToggleState()
            ToggleButton.BackgroundColor3 = initialState and Library.Theme.ToggleOn or Library.Theme.ToggleOff
            if callback then
                callback(initialState)
            end
        end

        ToggleButton.MouseButton1Click:Connect(function()
            initialState = not initialState
            updateToggleState()
        end)

        -- Initialize the state
        updateToggleState()

        return ToggleButton
    end

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        CreateTab = Library.CreateTab,
        CreateToggle = Library.CreateToggle
    }
end

function Library:CreateButton(window, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Parent = window.MainFrame
    Button.BackgroundColor3 = Library.Theme.ElementBackground
    Button.Size = UDim2.new(1, -20, 0, 30)
    Button.Position = UDim2.new(0, 10, 0, 50)
    Button.Font = Enum.Font.SourceSans
    Button.Text = text or "Button"
    Button.TextColor3 = Library.Theme.Text
    Button.TextSize = 16

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Library.Theme.ElementHover
    end)

    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Library.Theme.ElementBackground
    end)

    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return Button
end

return Library
