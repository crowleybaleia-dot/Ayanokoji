local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/crowleybaleia-dot/Ayanokoji/main/ayanokoji_clean/init.lua"
))()

local Window = Library:CreateWindow({
    Title    = "Ayanokoji",
    Center   = true,
    AutoShow = true,
    Size     = UDim2.fromOffset(550, 500),
})

--@ aba principal
local TabMain = Window:AddTab("Main")
local LeftBox  = TabMain:AddLeftGroupbox("General")
local RightBox = TabMain:AddRightGroupbox("Options")

local MyToggle = LeftBox:AddToggle("MyToggle", {
    Text    = "Toggle",
    Default = false,
    Callback = function(val)
        print("Toggle:", val)
    end,
})

MyToggle:AddKeyPicker("MyToggleKey", {
    Default = "None",
    Mode    = "Toggle",
    Text    = "Toggle",
    SyncToggleState = true,
})

LeftBox:AddSlider("MySlider", {
    Text     = "Slider",
    Min      = 0,
    Max      = 100,
    Default  = 50,
    Rounding = 0,
    Callback = function(val)
        print("Slider:", val)
    end,
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
    Func = function()
        Library:NotifyWithSound("Button pressed!", 3)
    end,
}):AddButton({
    Text = "Double click",
    DoubleClick = true,
    Func = function()
        Library:NotifyWithSound("Confirmed!", 3)
    end,
})

LeftBox:AddDivider()

LeftBox:AddLabel("Label"):AddColorPicker("LabelColor", {
    Default  = Color3.fromRGB(255, 255, 255),
    Callback = function(val)
        print("Color:", val)
    end,
})

RightBox:AddToggle("MyToggle2", {
    Text    = "Toggle with keybind",
    Default = false,
}):AddKeyPicker("MyToggle2Key", {
    Default = "None",
    Mode    = "Toggle",
    Text    = "Toggle with keybind",
    SyncToggleState = true,
})

RightBox:AddDropdown("MyDropdown", {
    Text    = "Dropdown",
    Values  = { "Option 1", "Option 2", "Option 3" },
    Default = "Option 1",
    Callback = function(val)
        print("Dropdown:", val)
    end,
})

RightBox:AddDropdown("MyMultiDropdown", {
    Text    = "Multi dropdown",
    Values  = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Default = { "Option 1" },
    Multi   = true,
    Callback = function(val)
        print("Multi dropdown:", val)
    end,
})

RightBox:AddInput("MyInput", {
    Text        = "Input",
    Placeholder = "Type here...",
    Callback    = function(val)
        print("Input:", val)
    end,
})

--@ aba UI (configs + theme + keybind)
local TabUI = Window:AddTab("UI")

Library.SaveManager:SetFolder("Ayanokoji/configs")
Library.SaveManager:BuildConfigSection(TabUI)
Library.ThemeManager:ApplyToTab(TabUI)

--@ watermark
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

--@ inicializa keybinders após load completo
loaded_signal:connect(function()
    Library.SaveManager:LoadAutoloadConfig()
end)
