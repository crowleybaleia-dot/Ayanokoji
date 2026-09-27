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

local function ensureFolder(path)
    if not isfolder(path) then makefolder(path) end
end

local function loadFont(filename)
    local localPath = FONT_FOLDER .. filename
    if not isfile(localPath) then
        local ok, res = pcall(function()
            return (syn and syn.request or request or http_request or http.request)({
                Url = BASE_URL .. "fonts/" .. filename,
                Method = "GET",
            })
        end)
        if ok and res and res.StatusCode == 200 and #res.Body > 100 then
            --@ valida assinatura TTF antes de salvar
            local sig = res.Body:sub(1, 4)
            if sig == "\0\1\0\0" or sig == "OTTO" or sig == "true" then
                pcall(writefile, localPath, res.Body)
            end
        end
    end
    if isfile(localPath) then
        local ok, asset = pcall(getcustomasset, localPath)
        if ok and asset and asset ~= "" then
            local ok2, font = pcall(Font.new, asset)
            if ok2 then return font end
        end
    end
    return Font.fromEnum(Enum.Font.GothamMedium) --@ fallback
end

ensureFolder("Ayanokoji")
ensureFolder(FONT_FOLDER)

getgenv().lexend = {
    regular = loadFont("lexend.ttf"),
    medium  = loadFont("lexend-medium.ttf"),
    bold    = loadFont("lexend-bold.ttf"),
}

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
