local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/crowleybaleia-dot/Ayanokoji/refs/heads/main/ayanokoji_/init.lua"
))()

local Window = Library:CreateWindow({
    Title    = "Ayanokoji Demo",
    Position = UDim2.fromOffset(200, 80),
    Size     = UDim2.fromOffset(550, 500),
    AutoShow = true,
})

local TabMain = Window:AddTab("Main")

local LeftBox  = TabMain:AddLeftGroupbox("Geral")
local RightBox = TabMain:AddRightGroupbox("Opções")

LeftBox:AddToggle("my_toggle", {
    Text    = "Ativar algo",
    Default = false,
    Callback = function(val)
        print("Toggle:", val)
    end,
})

LeftBox:AddToggle("my_toggle_kb", {
    Text    = "Com keybind",
    Default = false,
}):AddKeyPicker("my_toggle_kb_key", {
    Default = "None",
    Mode    = "Toggle",
    Text    = "Com keybind",
})

LeftBox:AddSlider("my_slider", {
    Text     = "Velocidade",
    Min      = 0,
    Max      = 100,
    Default  = 16,
    Rounding = 0,
    Suffix   = " studs/s",
    Callback = function(val)
        print("Slider:", val)
    end,
})

LeftBox:AddMinMaxSlider("my_minmax", {
    Text     = "Range de dano",
    Min      = 0,
    Max      = 200,
    Default  = { Min = 20, Max = 80 },
    Rounding = 0,
})

LeftBox:AddButton({
    Text = "Clica aqui",
    Func = function()
        Library:Notify("Botão clicado!", 3)
    end,
})

LeftBox:AddButton({
    Text        = "Ação perigosa",
    DoubleClick = true,
    Func        = function()
        Library:Notify("Confirmado!", 3)
    end,
})

LeftBox:AddDivider()
LeftBox:AddLabel("Isso é um label")

RightBox:AddInput("my_input", {
    Text        = "Nome do player",
    Placeholder = "Digite aqui...",
    Callback    = function(val)
        print("Input:", val)
    end,
})

RightBox:AddDropdown("my_dropdown", {
    Text    = "Modo",
    Values  = { "Fácil", "Normal", "Difícil" },
    Default = "Normal",
    Callback = function(val)
        print("Dropdown:", val)
    end,
})

RightBox:AddDropdown("my_multi", {
    Text    = "Features ativas",
    Values  = { "ESP", "Aimbot", "AutoFarm", "SpeedHack" },
    Default = { "ESP" },
    Multi   = true,
})

RightBox:AddLabel("Cor do ESP"):AddColorPicker("esp_color", {
    Default = Color3.fromRGB(255, 50, 50),
    Callback = function(val)
        print("Cor:", val)
    end,
})

local TabVisuals = Window:AddTab("Visuals")
local VBox = TabVisuals:AddLeftGroupbox("ESP")

VBox:AddToggle("esp_enabled", { Text = "Player ESP", Default = false })
VBox:AddToggle("esp_boxes",   { Text = "Boxes",       Default = true  })
VBox:AddToggle("esp_names",   { Text = "Names",       Default = true  })
VBox:AddSlider("esp_distance", {
    Text     = "Distância máxima",
    Min      = 50,
    Max      = 2000,
    Default  = 500,
    Rounding = 0,
    Suffix   = " studs",
})

local TabUI = Window:AddTab("UI")

Library.SaveManager:SetFolder("Ayanokoji/configs")
Library.SaveManager:BuildConfigSection(TabUI)
Library.ThemeManager:ApplyToTab(TabUI)

Library:SetWatermarkVisibility(true)

task.spawn(function()
    while task.wait(1) do
        Library:SetWatermark(
            string.format("Ayanokoji  |  %s  |  FPS: %d",
                game.PlaceId,
                math.floor(1 / (game:GetService("RunService").Heartbeat:Wait()))
            ),
            "Ayanokoji"
        )
    end
end)
