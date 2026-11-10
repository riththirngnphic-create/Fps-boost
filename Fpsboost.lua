
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Old = PlayerGui:FindFirstChild("E404_HUB")
if Old then Old:Destroy() end

local Red = Color3.fromRGB(255, 15, 25)
local Glow = Color3.fromRGB(255, 65, 75)
local Black = Color3.fromRGB(4, 0, 0)

local Gui = Instance.new("ScreenGui")
Gui.Name = "E404_HUB"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 999999
Gui.Parent = PlayerGui

local function New(Class, Properties, Parent)
    local Object = Instance.new(Class)
    for Key, Value in pairs(Properties) do
        Object[Key] = Value
    end
    Object.Parent = Parent
    return Object
end

local function IsCharacter(Object)
    for _, P in ipairs(Players:GetPlayers()) do
        if P.Character and Object:IsDescendantOf(P.Character) then
            return true
        end
    end
    return false
end

-- INTRO

local Intro = New("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Black,
    BorderSizePixel = 0
}, Gui)

local LightningLayer = New("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 2
}, Intro)

local Title = New("TextLabel", {
    Size = UDim2.new(1, 0, 0, 75),
    Position = UDim2.new(0, 0, 0.34, 0),
    BackgroundTransparency = 1,
    Text = "E404 HUB",
    TextColor3 = Red,
    TextStrokeColor3 = Glow,
    TextStrokeTransparency = 0.1,
    Font = Enum.Font.Code,
    TextSize = 48,
    ZIndex = 10
}, Intro)

local Subtitle = New("TextLabel", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0.47, 0),
    BackgroundTransparency = 1,
    Text = "SYSTEM BREACH // INITIALIZING",
    TextColor3 = Glow,
    Font = Enum.Font.Code,
    TextSize = 14,
    ZIndex = 10
}, Intro)

local BarBack = New("Frame", {
    Size = UDim2.new(0.55, 0, 0, 7),
    Position = UDim2.new(0.225, 0, 0.57, 0),
    BackgroundColor3 = Color3.fromRGB(45, 5, 5),
    BorderSizePixel = 0,
    ZIndex = 10
}, Intro)

local Bar = New("Frame", {
    Size = UDim2.fromScale(0, 1),
    BackgroundColor3 = Red,
    BorderSizePixel = 0,
    ZIndex = 11
}, BarBack)

local Percent = New("TextLabel", {
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 0.60, 0),
    BackgroundTransparency = 1,
    Text = "0%",
    TextColor3 = Red,
    Font = Enum.Font.Code,
    TextSize = 15,
    ZIndex = 10
}, Intro)

local LightningRunning = true

local function CreateLightning()
    local Camera = Workspace.CurrentCamera
    if not Camera then return end

    local View = Camera.ViewportSize
    local X = math.random(0, math.max(1, View.X))
    local Y = math.random(0, math.max(1, View.Y))

    for i = 1, math.random(6, 11) do
        local NX = X + math.random(-65, 65)
        local NY = Y + math.random(12, 55)

        local DX = NX - X
        local DY = NY - Y
        local Length = math.sqrt(DX * DX + DY * DY)
        local Angle = math.deg(math.atan2(DY, DX))

        local Segment = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(
                (X + NX) / 2,
                (Y + NY) / 2
            ),
            Size = UDim2.fromOffset(Length, 7),
            Rotation = Angle,
            BackgroundColor3 = Glow,
            BorderSizePixel = 0,
            ZIndex = 2
        }, LightningLayer)

        New("UICorner", {
            CornerRadius = UDim.new(1, 0)
        }, Segment)

        New("UIStroke", {
            Color = Red,
            Thickness = 5,
            Transparency = 0.1
        }, Segment)

        local Core = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, 0, 0, 2),
            BackgroundColor3 = Color3.fromRGB(255, 220, 220),
            BorderSizePixel = 0,
            ZIndex = 3
        }, Segment)

        TweenService:Create(Segment, TweenInfo.new(0.25), {
            BackgroundTransparency = 1
        }):Play()

        for _, Effect in ipairs(Segment:GetChildren()) do
            if Effect:IsA("UIStroke") then
                TweenService:Create(Effect, TweenInfo.new(0.25), {
                    Transparency = 1
                }):Play()
            end
        end

        task.delay(0.3, function()
            if Segment.Parent then
                Segment:Destroy()
            end
        end)

        X = NX
        Y = NY
    end
end

task.spawn(function()
    while LightningRunning and Gui.Parent do
        CreateLightning()
        task.wait(0.09)
    end
end)

local Start = os.clock()

while os.clock() - Start < 15 do
    local Progress = math.clamp((os.clock() - Start) / 15, 0, 1)
    Bar.Size = UDim2.fromScale(Progress, 1)
    Percent.Text = math.floor(Progress * 100) .. "%"
    task.wait(0.05)
end

LightningRunning = false
Percent.Text = "100%"
Subtitle.Text = "ACCESS GRANTED"

task.wait(0.3)
Intro:Destroy()

-- EXTREME GRAPHICS

local EffectClasses = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Smoke = true,
    Fire = true,
    Sparkles = true,
    Explosion = true
}

local function Optimize(Object)
    if IsCharacter(Object) then return end

    if EffectClasses[Object.ClassName] then
        Object:Destroy()
        return
    end

    if Object:IsA("Decal") or Object:IsA("Texture") then
        Object:Destroy()
        return
    end

    if Object:IsA("BasePart") then
        if not Object.CanCollide then
            Object.LocalTransparencyModifier = 1
        else
            Object.Material = Enum.Material.SmoothPlastic
            Object.Reflectance = 0
            Object.CastShadow = false
        end
    end
end

for _, Object in ipairs(Workspace:GetDescendants()) do
    Optimize(Object)
end

Workspace.DescendantAdded:Connect(function(Object)
    task.defer(function()
        if Object.Parent then
            Optimize(Object)
        end
    end)
end)

for _, Object in ipairs(Lighting:GetDescendants()) do
    if Object:IsA("PostEffect") or Object:IsA("Atmosphere") then
        Object:Destroy()
    end
end

Lighting.GlobalShadows = false
Lighting.FogEnd = 100000
Lighting.Brightness = 1

-- PLAYER OUTLINE

local Highlights = {}
local CharacterConnections = {}

local function AddPlayer(Target)
    if Target == Player then return end

    local function Setup(Character)
        if Highlights[Target] then
            Highlights[Target]:Destroy()
        end

        local Highlight = New("Highlight", {
            Adornee = Character,
            FillTransparency = 1,
            OutlineColor = Red,
            OutlineTransparency = 0,
            DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        }, Gui)

        Highlights[Target] = Highlight

        if CharacterConnections[Target] then
            CharacterConnections[Target]:Disconnect()
        end

        CharacterConnections[Target] = Character.DescendantAdded:Connect(function(Object)
            task.defer(function()
                if not Object.Parent then return end

                if Object:IsA("ParticleEmitter")
                    or Object:IsA("Trail")
                    or Object:IsA("Beam") then
                    Object:Destroy()
                end
            end)
        end)
    end

    if Target.Character then
        Setup(Target.Character)
    end

    Target.CharacterAdded:Connect(Setup)
end

for _, Target in ipairs(Players:GetPlayers()) do
    AddPlayer(Target)
end

Players.PlayerAdded:Connect(AddPlayer)

Players.PlayerRemoving:Connect(function(Target)
    if Highlights[Target] then
        Highlights[Target]:Destroy()
        Highlights[Target] = nil
    end

    if CharacterConnections[Target] then
        CharacterConnections[Target]:Disconnect()
        CharacterConnections[Target] = nil
    end
end)

-- MONITOR

local function CreateMonitor(Text, Position)
    local Frame = New("TextLabel", {
        Size = UDim2.fromOffset(165, 42),
        Position = Position,
        BackgroundColor3 = Black,
        BackgroundTransparency = 0.08,
        BorderColor3 = Red,
        BorderSizePixel = 1,
        Text = Text,
        TextColor3 = Red,
        TextSize = 15,
        Font = Enum.Font.Code,
        Active = true
    }, Gui)

    New("UICorner", {
        CornerRadius = UDim.new(0, 5)
    }, Frame)

    New("UIDragDetector", {}, Frame)

    return Frame
end

local FPSLabel = CreateMonitor(
    "FPS SIM: 950",
    UDim2.new(0, 15, 0, 100)
)

local PingLabel = CreateMonitor(
    "PING SIM: 1 ms",
    UDim2.new(0, 15, 0, 150)
)

task.spawn(function()
    while Gui.Parent do
        FPSLabel.Text = "FPS SIM: " .. math.random(850, 1000)
        PingLabel.Text = "PING SIM: " .. math.random(1, 2) .. " ms"
        task.wait(0.3)
    end
end)
