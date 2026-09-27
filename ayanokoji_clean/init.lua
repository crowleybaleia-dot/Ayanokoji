local BASE_URL = "https://raw.githubusercontent.com/crowleybaleia-dot/Ayanokoji/main/ayanokoji_clean/"

local function fetch(path)
    local ok, result = pcall(game.HttpGet, game, BASE_URL .. path)
    assert(ok, "[Ayanokoji] Falhou ao buscar: " .. path .. "\n" .. tostring(result))
    return result
end

local function loadModule(path)
    local src = fetch(path)
    local fn, err = loadstring(src)
    assert(fn, "[Ayanokoji] Erro ao compilar: " .. path .. "\n" .. tostring(err))
    return fn()
end

local FONT_FOLDER = "Ayanokoji/fonts/"
local FONT_JSON   = "Ayanokoji/fonts/Lexend.json"

local function ensureFolder(path)
    if not isfolder(path) then makefolder(path) end
end

local function downloadFont(filename)
    local localPath = FONT_FOLDER .. filename
    if not isfile(localPath) then
        local data = fetch("fonts/" .. filename)
        writefile(localPath, data)
    end
end

local function makeLexend()
    ensureFolder("Ayanokoji")
    ensureFolder(FONT_FOLDER)

    downloadFont("lexend.ttf")
    downloadFont("lexend-medium.ttf")
    downloadFont("lexend-bold.ttf")

    --@ gera familia de fonte como o original
    writefile(FONT_JSON, game:GetService("HttpService"):JSONEncode({
        name = "Lexend",
        faces = {
            { name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(FONT_FOLDER .. "lexend.ttf") },
            { name = "Medium",  weight = 500, style = "normal", assetId = getcustomasset(FONT_FOLDER .. "lexend-medium.ttf") },
            { name = "Bold",    weight = 700, style = "normal", assetId = getcustomasset(FONT_FOLDER .. "lexend-bold.ttf") },
        }
    }))

    local jsonAsset = getcustomasset(FONT_JSON)
    local fonts = {
        regular = Font.new(jsonAsset, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        medium  = Font.new(jsonAsset, Enum.FontWeight.Medium,  Enum.FontStyle.Normal),
        bold    = Font.new(jsonAsset, Enum.FontWeight.Bold,    Enum.FontStyle.Normal),
    }

    --@ preload antes de retornar
    local done = 0
    for _, font in pairs(fonts) do
        task.spawn(function()
            local params = Instance.new("GetTextBoundsParams")
            params.Text = "Preload"
            params.Font = font
            params.Size = 16
            game:GetService("TextService"):GetTextBoundsAsync(params)
            params:Destroy()
            done += 1
        end)
    end
    repeat task.wait() until done == 3

    return fonts
end

getgenv().lexend = makeLexend()

getgenv().services = {
    TweenService     = game:GetService("TweenService"),
    RunService       = game:GetService("RunService"),
    Debris           = game:GetService("Debris"),
    CoreGui          = game:GetService("CoreGui"),
    Players          = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
}

--@ toggle.lua conecta aqui para inicializar KeyPickers
local loaded_bindable = Instance.new("BindableEvent")
getgenv().loaded_signal = {
    connect = function(_, fn)
        return loaded_bindable.Event:Connect(fn)
    end
}

--@ stubs luraph
getgenv().LPH_OBFUSCATED = false
getgenv().LPH_ENCSTR     = function(s) return s end

local components = {}
local componentList = {
    "slider", "toggle", "dropdown",
    "colorpicker", "button", "input",
    "label", "panel", "hud"
}

for _, name in ipairs(componentList) do
    components[name] = loadModule("components/" .. name .. ".lua")
end

getgenv().__AYANOKOJI_COMPONENTS__ = components

local Library = loadModule("ui.lua")

local ThemeManager = loadModule("managers/ThemeManager.lua")
ThemeManager:SetLibrary(Library)
Library.ThemeManager = ThemeManager

local SaveManager = loadModule("managers/SaveManager.lua")
SaveManager:SetLibrary(Library)
Library.SaveManager = SaveManager

task.defer(function()
    loaded_bindable:Fire()
end)

return Library
