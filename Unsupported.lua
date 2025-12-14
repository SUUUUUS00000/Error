local Players, TweenService, UserInputService, Lighting = game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("Lighting")

local GameID = 7072772332
if game.PlaceId == GameID or _G.UnsupportedGameGUILaunched then return end
_G.UnsupportedGameGUILaunched = true

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = Player:WaitForChild("PlayerGui")

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

local function CreateFrame(Name, Size, Position)
    local Frame = Instance.new("Frame")
    Frame.Name = Name
    Frame.Size = Size
    Frame.Position = Position
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.BackgroundTransparency = 0.15
    Frame.BorderSizePixel = 0
    Frame.Visible = false
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Frame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Transparency = 0.9
    Stroke.Thickness = 1
    Stroke.Parent = Frame
    
    return Frame
end

local function CreateHeader(Parent)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
    Header.BackgroundTransparency = 0.4
    Header.BorderSizePixel = 0
    Header.Parent = Parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Header
    
    return Header
end

local function CreateLabel(Parent, Text, Size, Position, Options)
    local Label = Instance.new("TextLabel")
    Label.Name = "TextLabel"
    Label.Text = Text
    Label.Size = Size
    Label.Position = Position
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Options and Options.TextColor3 or Color3.fromRGB(255, 255, 255)
    Label.TextTransparency = 1
    Label.Font = Options and Options.Font or Enum.Font.GothamSemibold
    Label.TextSize = Options and Options.TextSize or 18
    Label.TextWrapped = true
    Label.Parent = Parent
    
    if Options then
        if Options.XAlignment then Label.TextXAlignment = Options.XAlignment end
        if Options.YAlignment then Label.TextYAlignment = Options.YAlignment end
    end
    
    return Label
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "UnsupportedGameGui"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = PlayerGui

local MainFrame = CreateFrame("MainFrame", UDim2.new(0, 400, 0, 200), UDim2.new(0.5, 0, 0.5, 0))
MainFrame.Parent = GUI

local Header = CreateHeader(MainFrame)

local Title = CreateLabel(Header, "Unsupported Game", UDim2.new(1, -40, 0, 30), UDim2.new(0, 111.5, 0, 10), {
    TextSize = 20,
    XAlignment = Enum.TextXAlignment.Left
})

local MessageFrame = Instance.new("Frame")
MessageFrame.Name = "MessageFrame"
MessageFrame.Size = UDim2.new(1, -40, 1, -70)
MessageFrame.Position = UDim2.new(0, 20, 0, 60)
MessageFrame.BackgroundTransparency = 1
MessageFrame.Parent = MainFrame

local MessageText = CreateLabel(MessageFrame, "This game is not supported", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), {
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.Gotham,
    TextSize = 18,
    XAlignment = Enum.TextXAlignment.Center,
    YAlignment = Enum.TextYAlignment.Center
})

local IsHiding = false
local CanClose = false

local function ShowGUI()
    MainFrame.Visible = true
    
    TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 24}):Play()
    
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 200)}):Play()
    
    task.delay(0.2, function()
        for _, Child in ipairs(MainFrame:GetDescendants()) do
            if Child:IsA("TextLabel") then
                TweenService:Create(Child, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
            end
        end
        CanClose = true
    end)
end

local function HideGUI()
    if IsHiding or not CanClose then return end
    IsHiding = true
    
    for _, Child in ipairs(MainFrame:GetDescendants()) do
        if Child:IsA("TextLabel") then
            TweenService:Create(Child, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        end
    end
    
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.35), {Size = 0}):Play()
    
    task.delay(0.5, function()
        if GUI then GUI:Destroy() end
        if Blur then Blur:Destroy() end
    end)
end

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and CanClose then
        HideGUI()
    end
end)

ShowGUI()