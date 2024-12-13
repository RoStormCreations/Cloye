-- Roblox UI Library
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
    CloseButton = Color3.fromRGB(255, 100, 100)
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
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
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

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame
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
