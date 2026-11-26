-- Delta Client ClickGUI Port built on Obsidian UI Library
-- Forked from https://github.com/deividcomsono/Obsidian -> HOKOKRTET/Obsidian

local repo = "https://raw.githubusercontent.com/HOKOKRTET/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

-- ClickGui = true enables side-by-side Delta category panels, glow shadows, bottom searchbar, and top description tooltip.
-- Set ClickGui = false to switch back to classic tabbed Obsidian layout with the Delta theme.
local Window = Library:CreateWindow({
	Title = "Delta Client",
	ClickGui = true,
	PanelWidth = 250,
	PanelHeight = 540,
	PanelGap = 16,
	SearchPlaceholder = "Поиск по модулям",
	NotifySide = "TopCenter",
	NotifyOnModuleToggle = true,
	ShowCustomCursor = false,
	UnlockMouseWhileOpen = true,
	ToggleKeybind = Enum.KeyCode.RightShift,
})

--// Categories (Tabs in classic mode) \\--
local Combat = Window:AddCategory("Combat", "delta:combat")
local Movement = Window:AddCategory("Movement", "delta:movement")
local Render = Window:AddCategory("Render", "delta:render")
local Player = Window:AddCategory("Player", "delta:player")
local Misc = Window:AddCategory("Misc", "delta:misc")
local UISettings = Window:AddCategory("Settings", "delta:settings")

--// Combat Modules \\--
local KillAura = Combat:AddModule("KillAura", {
	Text = "KillAura",
	Description = "Автоматически атакует ближайших противников в радиусе",
	Default = false,
	Keybind = "R",
})
KillAura:AddMode("KA_Mode", {
	Text = "Режим наводки",
	Values = { "Плавный", "Обычный", "Снап" },
	Default = "Плавный",
})
KillAura:AddMultiMode("KA_Targets", {
	Text = "Цели",
	Values = { "Игроки", "Мобы", "Невидимые", "Друзья" },
	Default = { "Игроки", "Мобы" },
})
KillAura:AddSlider("KA_Range", {
	Text = "Дистанция",
	Default = 3.2,
	Min = 2.0,
	Max = 6.0,
	Rounding = 1,
	Suffix = " м",
})
KillAura:AddCheckbox("KA_Crits", {
	Text = "Только криты",
	Default = true,
	Tooltip = "Бить только во время падения для критического урона",
})

local AutoTotem = Combat:AddModule("AutoTotem", {
	Text = "AutoTotem",
	Description = "Автоматически берет тотем бессмертия при низком HP",
	Default = false,
})
AutoTotem:AddSlider("AT_Health", {
	Text = "Здоровье",
	Default = 10,
	Min = 1,
	Max = 20,
	Rounding = 0,
	Suffix = " HP",
})

Combat:AddModule("Velocity", {
	Text = "Velocity",
	Description = "Снижает или отключает отбрасывание от ударов",
	Default = false,
}):AddCheckbox("Vel_Cancel", {
	Text = "Полная отмена",
	Default = true,
})

--// Movement Modules \\--
local Fly = Movement:AddModule("Fly", {
	Text = "Fly",
	Description = "Позволяет свободно летать в воздухе",
	Default = false,
	Keybind = "F",
})
Fly:AddMode("Fly_Mode", {
	Text = "Режим",
	Values = { "Vanilla", "Glide", "Matrix" },
	Default = "Vanilla",
})
Fly:AddSlider("Fly_Speed", {
	Text = "Скорость",
	Default = 2.0,
	Min = 0.5,
	Max = 10.0,
	Rounding = 1,
})

Movement:AddModule("Speed", {
	Text = "Speed",
	Description = "Увеличивает скорость передвижения игрока",
	Default = true,
}):AddSlider("Speed_Mult", {
	Text = "Множитель",
	Default = 1.4,
	Min = 1.0,
	Max = 5.0,
	Rounding = 2,
})

Movement:AddModule("NoSlow", {
	Text = "NoSlow",
	Description = "Убирает замедление при использовании предметов",
	Default = false,
})

--// Render Modules \\--
local ESP = Render:AddModule("ESP", {
	Text = "ESP",
	Description = "Подсвечивает игроков и объекты сквозь стены",
	Default = true,
	Keybind = "Z",
})
ESP:AddColor("ESP_Color", {
	Text = "Цвет обводки",
	Default = Color3.fromRGB(133, 156, 255),
})
ESP:AddMultiMode("ESP_Elements", {
	Text = "Элементы",
	Values = { "Боксы", "Ники", "Здоровье", "Трейсеры" },
	Default = { "Боксы", "Ники" },
})

local CustomFog = Render:AddModule("CustomFog", {
	Text = "CustomFog",
	Description = "Изменяет цвет и дальность тумана в мире",
	Default = false,
})
CustomFog:AddColor("Fog_Color", {
	Text = "Цвет тумана",
	Default = Color3.fromRGB(133, 156, 255),
})
CustomFog:AddSlider("Fog_Dist", {
	Text = "Дистанция",
	Default = 120,
	Min = 20,
	Max = 500,
	Rounding = 0,
})

Render:AddModule("Fullbright", {
	Text = "Fullbright",
	Description = "Максимальная яркость освещения без факелов",
	Default = true,
})

--// Player Modules \\--
Player:AddModule("FastPlace", {
	Text = "FastPlace",
	Description = "Ускоряет размещение блоков и использование предметов",
	Default = false,
})
Player:AddModule("ChestStealer", {
	Text = "ChestStealer",
	Description = "Быстро забирает предметы из открытого контейнера",
	Default = false,
	Keybind = "X",
}):AddSlider("Stealer_Delay", {
	Text = "Задержка",
	Default = 60,
	Min = 0,
	Max = 300,
	Rounding = 0,
	Suffix = " мс",
})

--// Misc Modules \\--
local ClientSpoof = Misc:AddModule("ClientSpoof", {
	Text = "ClientSpoof",
	Description = "Маскирует название клиента на сервере",
	Default = false,
})
ClientSpoof:AddString("Spoof_Brand", {
	Text = "Клиент",
	Default = "vanilla",
	Placeholder = "Введите бренд...",
})

Misc:AddModule("AutoReconnect", {
	Text = "AutoReconnect",
	Description = "Автоматически переподключается при кике с сервера",
	Default = true,
})

--// Standard Obsidian Groupboxes work seamlessly inside Delta panels too! \\--
local MenuGroup = UISettings:AddGroupbox({
	Side = "Left",
	Name = "Menu",
	IconName = "delta:settings",
})
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton({
	Text = "Test Notification",
	Func = function()
		Library:Notify({
			Title = "Delta Client",
			Description = "ClickGUI работает на базе Obsidian!",
			Time = 3,
			Icon = "delta:notify",
		})
	end,
})
MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

--// Addons: ThemeManager & SaveManager \\--
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("DeltaObsidian")
SaveManager:SetFolder("DeltaObsidian/configs")

ThemeManager:ApplyToTab(UISettings, "delta:theme")
SaveManager:BuildConfigSection(UISettings)
SaveManager:LoadAutoloadConfig()

-- Listening to changes (classic Obsidian style)
Toggles.KillAura:OnChanged(function(State)
	print("KillAura:", State)
end)
Options.KA_Range:OnChanged(function(Value)
	print("KillAura Range:", Value)
end)
