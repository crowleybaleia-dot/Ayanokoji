# Project rain UI lib exported for use
--@ Project rain had its source leaked, and the dev uni released his project, which included the Project rain UI lib. This repository serves only to make life easier for anyone who wants to use the UI lib created by him/them.

---@ notes : some things are not working, but they will be fixed if they haven't already been fixed by the time you are reading this.

## Quick Start

```lua
local Library = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/crowleybaleia-dot/Ayanokoji/main/ayanokoji_clean/init.lua"
))()

local Window = Library:CreateWindow({
Title    = "My Hub",
AutoShow = true,
})

local Tab  = Window:AddTab("Main")
local Box  = Tab:AddLeftGroupbox("General")

Box:AddToggle("my_toggle", {
Text    = "Enable something",
Default = false,
Callback = function(val)
print(val)
end,
})
```

## Repository Structure

```
init.lua                  ← main loader (use this one in your script)
ui.lua                    ← library core
demo.lua                  ← complete usage example
fonts/
lexend.ttf
lexend-medium.ttf
lexend-bold.ttf
components/
button.lua
toggle.lua              ← includes AddKeyPicker
slider.lua              ← includes AddMinMaxSlider
dropdown.lua
colorpicker.lua
input.lua
label.lua
panel.lua
hud.lua                 ← Notify, Watermark
managers/
ThemeManager.lua
SaveManager.lua
```

## Components

### Toggle

```lua
local toggle = Box:AddToggle("flag_id", {
Text     = "Name",
Default  = false,
Callback = function(val) end,
Tooltip  = "Optional description",
Risky    = false, -- colors the label red
})

toggle:SetValue(true)
toggle:OnChanged(function(val) end)

--@ Keybind (chained to toggle)
toggle:AddKeyPicker("flag_id_key", {
Default = "None",
Mode    = "Toggle", -- or "Hold"
Text    = "Name",
})
```

### Slider

```lua
local slider = Box:AddSlider("flag_id", {
Text     = "Name",
Min      = 0,
Max      = 100,
Default  = 50,
Rounding = 1,   --@ decimal places (0 = integer)
Suffix   = " x",
Prefix   = "",
Compact  = false,
Callback = function(val) end,
})

slider:SetValue(75)
slider:OnChanged(function(val) end)
```

### MinMax Slider

```lua
local mm = Box:AddMinMaxSlider("flag_id", {
Text     = "Range",
Min      = 0,
Max      = 100,
Default  = { Min = 20, Max = 80 },
Rounding = 0,
})

mm:SetValue({ Min = 10, Max = 90 })
```

### Dropdown

```lua
local dd = Box:AddDropdown("flag_id", {
Text       = "Name",
Values     = { "A", "B", "C" },
Default    = "A",
Multi      = false,
Searchable = true,
AllowNull  = false,
Callback   = function(val) end,
})

dd:SetValue("B")
dd:OnChanged(function(val) end)
```

### Button

```lua
Box:AddButton({
Text        = "Name",
Func        = function() end,
DoubleClick = false, --@ asks for confirmation before executing
Tooltip     = "...",
})

--@ Dual button (side by side)
local btn = Box:AddButton({ Text = "Left", Func = function() end })
btn:AddButton({ Text = "Right", Func = function() end })
```

### Input

```lua
local inp = Box:AddInput("flag_id", {
Text        = "Name",
Default     = "",
Placeholder = "Type...",
Numeric     = false,
Finished    = false, -- true = callback only on Enter
Callback    = function(val) end,
})

inp:SetValue("text")
inp:OnChanged(function(val) end)
```

### ColorPicker

```lua
-- Usually chained to a label
local cp = Box:AddLabel("Color"):AddColorPicker("flag_id", {
Default  = Color3.fromRGB(255, 0, 0),
Callback = function(color) end,
})

cp:SetValueRGB(Color3.fromRGB(0, 255, 0))
cp:OnChanged(function(color) end)
```

### Label

```lua
local lbl = Box:AddLabel("Text here")
lbl:SetText("New text")
lbl:SetColor(Color3.fromRGB(255, 50, 50))
lbl:Hide()
lbl:Show()
```

### DependencyBox

```lua
--@ Shows elements only when the condition is true
local dep = Box:AddDependencyBox()
dep:AddToggle("sub_toggle", { Text = "Sub toggle", Default = false })
dep:SetupDependencies({
{ aztup_toggles["my_toggle"], true }
})
```

### Tabbox (tabs inside groupbox)

```lua
local tabbox = Tab:AddLeftTabbox()
local t1 = tabbox:AddTab("Tab 1")
local t2 = tabbox:AddTab("Tab 2")
t1:AddToggle("flag", { Text = "Toggle on tab 1", Default = false })
```

## Notify and Watermark

```lua
-- Floating notification
Library:Notify("Message here", 5) -- seconds

-- Watermark (screen corner, draggable)
Library:SetWatermarkVisibility(true)
Library:SetWatermark("My Hub | v1.0", "Name of your Hub") -- (rich text, plain text for measurement)
```

## ThemeManager and SaveManager

```lua
local TabUI = Window:AddTab("UI")
Library.SaveManager:SetFolder("MyHub/configs")
Library.SaveManager:BuildConfigSection(TabUI)
Library.ThemeManager:ApplyToTab(TabUI)
```

## Accessing Values

```lua
-- Toggles
aztup_toggles["flag_id"].Value       --@ boolean
aztup_toggles["flag_id"]:SetValue(true)

-- Options (sliders, dropdowns, inputs, colorpickers, keypickers)
aztup_options["flag_id"].Value
aztup_options["flag_id"]:SetValue(x)
```

## Default Open/Close Key

`RightShift` or `RightControl`

To customize:

```lua
Library.ToggleKeybind = aztup_options["my_keybind"]
```

## Notes on Fonts

On the first execution, the loader automatically downloads the Lexend fonts from GitHub and saves them to `Ayanokoji/fonts/` in the executor's workspace. On subsequent executions, it uses the local cache. If the executor does not support `writefile` with binary data, the lib falls back to Gotham.