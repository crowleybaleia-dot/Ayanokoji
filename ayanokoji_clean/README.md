# Ayanokoji UI Library

UI library para Roblox exploits. Baseada em Lua, compatível com executores UNC completos (Potassium, Xeno, etc.).

## Uso rápido

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/crowleybaleia-dot/Ayanokoji/main/ayanokoji_clean/init.lua"
))()

local Window = Library:CreateWindow({
    Title    = "Meu Hub",
    AutoShow = true,
})

local Tab  = Window:AddTab("Main")
local Box  = Tab:AddLeftGroupbox("Geral")

Box:AddToggle("meu_toggle", {
    Text    = "Ativar algo",
    Default = false,
    Callback = function(val)
        print(val)
    end,
})
```

## Estrutura do repositório

```
init.lua                  ← loader principal (use esse no seu script)
ui.lua                    ← core da biblioteca
demo.lua                  ← exemplo completo de uso
fonts/
  lexend.ttf
  lexend-medium.ttf
  lexend-bold.ttf
components/
  button.lua
  toggle.lua              ← inclui AddKeyPicker
  slider.lua              ← inclui AddMinMaxSlider
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

## Componentes

### Toggle
```lua
local toggle = Box:AddToggle("flag_id", {
    Text     = "Nome",
    Default  = false,
    Callback = function(val) end,
    Tooltip  = "Descrição opcional",
    Risky    = false, -- colore o label de vermelho
})

toggle:SetValue(true)
toggle:OnChanged(function(val) end)

-- Keybind (encadeia no toggle)
toggle:AddKeyPicker("flag_id_key", {
    Default = "None",
    Mode    = "Toggle", -- ou "Hold"
    Text    = "Nome",
})
```

### Slider
```lua
local slider = Box:AddSlider("flag_id", {
    Text     = "Nome",
    Min      = 0,
    Max      = 100,
    Default  = 50,
    Rounding = 1,   -- casas decimais (0 = inteiro)
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
    Text       = "Nome",
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
    Text        = "Nome",
    Func        = function() end,
    DoubleClick = false, -- pede confirmação antes de executar
    Tooltip     = "...",
})

-- Botão duplo (lado a lado)
local btn = Box:AddButton({ Text = "Esquerdo", Func = function() end })
btn:AddButton({ Text = "Direito", Func = function() end })
```

### Input
```lua
local inp = Box:AddInput("flag_id", {
    Text        = "Nome",
    Default     = "",
    Placeholder = "Digite...",
    Numeric     = false,
    Finished    = false, -- true = callback só no Enter
    Callback    = function(val) end,
})

inp:SetValue("texto")
inp:OnChanged(function(val) end)
```

### ColorPicker
```lua
-- Geralmente encadeado num label
local cp = Box:AddLabel("Cor"):AddColorPicker("flag_id", {
    Default  = Color3.fromRGB(255, 0, 0),
    Callback = function(color) end,
})

cp:SetValueRGB(Color3.fromRGB(0, 255, 0))
cp:OnChanged(function(color) end)
```

### Label
```lua
local lbl = Box:AddLabel("Texto aqui")
lbl:SetText("Novo texto")
lbl:SetColor(Color3.fromRGB(255, 50, 50))
lbl:Hide()
lbl:Show()
```

### DependencyBox
```lua
-- Mostra elementos só quando a condição é verdadeira
local dep = Box:AddDependencyBox()
dep:AddToggle("sub_toggle", { Text = "Sub toggle", Default = false })
dep:SetupDependencies({
    { aztup_toggles["meu_toggle"], true }
})
```

### Tabbox (abas dentro de groupbox)
```lua
local tabbox = Tab:AddLeftTabbox()
local t1 = tabbox:AddTab("Aba 1")
local t2 = tabbox:AddTab("Aba 2")

t1:AddToggle("flag", { Text = "Toggle na aba 1", Default = false })
```

## Notify e Watermark

```lua
-- Notificação flutuante
Library:Notify("Mensagem aqui", 5) -- segundos

-- Watermark (canto da tela, arrastável)
Library:SetWatermarkVisibility(true)
Library:SetWatermark("Meu Hub | v1.0", "Meu Hub") -- (texto rico, texto simples pra medir)
```

## ThemeManager e SaveManager

```lua
local TabUI = Window:AddTab("UI")

Library.SaveManager:SetFolder("MeuHub/configs")
Library.SaveManager:BuildConfigSection(TabUI)
Library.ThemeManager:ApplyToTab(TabUI)
```

## Acessando valores

```lua
-- Toggles
aztup_toggles["flag_id"].Value       -- boolean
aztup_toggles["flag_id"]:SetValue(true)

-- Options (sliders, dropdowns, inputs, colorpickers, keypickers)
aztup_options["flag_id"].Value
aztup_options["flag_id"]:SetValue(x)
```

## Tecla padrão para abrir/fechar

`RightShift` ou `RightControl`

Para customizar:
```lua
Library.ToggleKeybind = aztup_options["meu_keybind"]
```

## Notas sobre as fontes

Na primeira execução o loader baixa automaticamente as fontes Lexend do GitHub e salva em `Ayanokoji/fonts/` na workspace do executor. Nas execuções seguintes usa o cache local. Se o executor não suportar `writefile` com binários, a lib usa Gotham como fallback silencioso.
