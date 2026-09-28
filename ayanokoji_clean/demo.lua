local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/crowleybaleia-dot/Ayanokoji/main/ayanokoji_clean/init.lua"
))()

local Window = Library:CreateWindow({
    Title    = "Ayanokoji",
    Center   = true,
    AutoShow = true,
    Size     = UDim2.fromOffset(550, 500),
})

Window:SetWindowTitle(string.format('Ayanokoji <font color="#%s">ui</font>', Library.AccentColor:ToHex()))


local TabMain = Window:AddTab("Main")
local TabOther = Window:AddTab("Other")
local TabUI = Window:AddTab("UI")

-- Main / Left
local LeftBox = TabMain:AddLeftGroupbox("General")

local MyToggle = LeftBox:AddToggle("MyToggle", {
    Text     = "Toggle",
    Default  = false,
    Callback = function(val) print("Toggle:", val) end,
})

MyToggle:AddKeyPicker("MyToggleKey", {
    Default         = "None",
    Mode            = "Toggle",
    Text            = "Toggle",
    SyncToggleState = true,
})

LeftBox:AddToggle("MyRiskyToggle", {
    Text     = "Risky toggle",
    Default  = false,
    Risky    = true,
    Callback = function(val) print("Risky:", val) end,
})

LeftBox:AddSlider("MySlider", {
    Text     = "Slider",
    Min      = 0,
    Max      = 100,
    Default  = 50,
    Rounding = 0,
    Callback = function(val) print("Slider:", val) end,
})

LeftBox:AddMinMaxSlider("MyMinMax", {
    Text     = "Min/Max Slider",
    Min      = 0,
    Max      = 100,
    Default  = { Min = 25, Max = 75 },
    Rounding = 0,
})

LeftBox:AddButton({
    Text = "Notify",
    Func = function() Library:NotifyWithSound("Button pressed!", 3) end,
}):AddButton({
    Text        = "Double click",
    DoubleClick = true,
    Func        = function() Library:NotifyWithSound("Confirmed!", 3) end,
})

LeftBox:AddDivider()

LeftBox:AddLabel("Label"):AddColorPicker("LabelColor", {
    Default  = Color3.fromRGB(255, 255, 255),
    Callback = function(val) print("Color:", val) end,
})

LeftBox:AddLabel("This is a long label that wraps across multiple lines inside the groupbox.", true)

-- Main / Right
local RightBox = TabMain:AddRightGroupbox("Options")

LeftBox:AddToggle("MyDepToggle", {
    Text    = "Toggle (enables below)",
    Default = false,
})

local DepBox = LeftBox:AddDependencyBox()
DepBox:AddToggle("MyDepChild", {
    Text    = "Visible when above is on",
    Default = false,
})
DepBox:AddSlider("MyDepSlider", {
    Text     = "Dep slider",
    Min      = 0,
    Max      = 10,
    Default  = 5,
    Rounding = 0,
})
DepBox:SetupDependencies({
    { aztup_toggles["MyDepToggle"], true }
})

RightBox:AddToggle("MyToggle2", {
    Text    = "Toggle with keybind",
    Default = false,
}):AddKeyPicker("MyToggle2Key", {
    Default         = "None",
    Mode            = "Toggle",
    Text            = "Toggle with keybind",
    SyncToggleState = true,
})

RightBox:AddDropdown("MyDropdown", {
    Text      = "Dropdown",
    Values    = { "Option 1", "Option 2", "Option 3" },
    Default   = "Option 1",
    Callback  = function(val) print("Dropdown:", val) end,
})

RightBox:AddDropdown("MySearchDropdown", {
    Text       = "Searchable dropdown",
    Values     = { "Alpha", "Beta", "Gamma", "Delta", "Epsilon" },
    Default    = "Alpha",
    Searchable = true,
    Callback   = function(val) print("Search dd:", val) end,
})

RightBox:AddDropdown("MyMultiDropdown", {
    Text     = "Multi dropdown",
    Values   = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Default  = { "Option 1" },
    Multi    = true,
    Callback = function(val) print("Multi:", val) end,
})

RightBox:AddDivider()

RightBox:AddInput("MyInput", {
    Text        = "Input",
    Placeholder = "Type here...",
    Callback    = function(val) print("Input:", val) end,
})

RightBox:AddInput("MyNumericInput", {
    Text        = "Numeric input",
    Placeholder = "Numbers only...",
    Numeric     = true,
    Callback    = function(val) print("Numeric:", val) end,
})

RightBox:AddInput("MyFinishedInput", {
    Text        = "Input (on enter)",
    Placeholder = "Press enter...",
    Finished    = true,
    Callback    = function(val) print("Finished:", val) end,
})

-- Other tab / tabbox
local Tabbox = TabOther:AddLeftTabbox()

local SubTab1 = Tabbox:AddTab("Sub 1")
local SubTab2 = Tabbox:AddTab("Sub 2")

SubTab1:AddToggle("Sub1Toggle", {
    Text    = "Toggle in Sub 1",
    Default = false,
})

SubTab1:AddSlider("Sub1Slider", {
    Text     = "Slider in Sub 1",
    Min      = 0,
    Max      = 50,
    Default  = 10,
    Rounding = 0,
})

SubTab2:AddToggle("Sub2Toggle", {
    Text    = "Toggle in Sub 2",
    Default = false,
})

SubTab2:AddDropdown("Sub2Dropdown", {
    Text    = "Dropdown in Sub 2",
    Values  = { "A", "B", "C" },
    Default = "A",
})

local RightTabbox = TabOther:AddRightTabbox()
local SubTab3 = RightTabbox:AddTab("Sub 3")
local SubTab4 = RightTabbox:AddTab("Sub 4")

SubTab3:AddButton({
    Text = "Button in Sub 3",
    Func = function() Library:Notify("Sub 3!", 2) end,
})

SubTab3:AddLabel("Label in Sub 3")

SubTab4:AddInput("Sub4Input", {
    Text        = "Input in Sub 4",
    Placeholder = "...",
})

SubTab4:AddLabel("Color in Sub 4"):AddColorPicker("Sub4Color", {
    Default = Color3.fromRGB(100, 200, 255),
})

-- UI tab
Library.SaveManager:SetFolder("Ayanokoji/configs")
Library.SaveManager:BuildConfigSection(TabUI)
Library.ThemeManager:ApplyToTab(TabUI)

aztup_options.AccentColor:OnChanged(function()
    Window:SetWindowTitle(string.format('Ayanokoji <font color="#%s">ui</font>', Library.AccentColor:ToHex()))
end)

-- Watermark
Library:SetWatermarkVisibility(true)

local fps = 0
game:GetService("RunService").Heartbeat:Connect(function(dt)
    fps = math.floor(1 / dt)
end)

task.spawn(function()
    while task.wait(1) do
        Library:SetWatermark(
            string.format("Ayanokoji  |  fps: %d", fps),
            "Ayanokoji"
        )
    end
end)

loaded_signal:connect(function()
    Library.SaveManager:LoadAutoloadConfig()
end)
