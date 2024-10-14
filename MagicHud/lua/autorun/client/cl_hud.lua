-- Version 1.3

include("autorun/sh_hudconfig.lua")

surface.CreateFont("Font1", {font = "Trebuchet18", size = 18, weight = 600, antialias = true})
surface.CreateFont("Font2", {font = "Trebuchet18", size = 18, weight = 600, antialias = true})

local BackgroundBlur = Color(0, 0, 0, 225)
local ShadowColor = Color(0, 0, 0, 100)
local BarW = 160
local BarH = 16

local heart = Material("magichud/heart.png", "noclamp smooth")
local user = Material("magichud/id.png", "noclamp smooth")
local world = Material("magichud/shield.png", "noclamp smooth")
local id = Material("magichud/briefcase.png", "noclamp smooth")
local moneyicon = Material("magichud/cash.png", "noclamp smooth")
local calculator = Material("magichud/cash2.png", "noclamp smooth")
local gunlicenseIcon = Material("icon16/page_white_text.png", "noclamp smooth")

local x = ScrW()
local y = ScrH()

local function GetRainbowColor()
    local hue = (CurTime() % 6) / 6
    local color = HSVToColor(hue * 360, 1, 1)
    return color
end

local function DrawAgenda()
    local agenda = LocalPlayer():getAgendaTable()
    if not agenda then return end

    local agendaText = LocalPlayer():getDarkRPVar("agenda") or ""
    local title = agenda.Title
    local wrappedAgendaText = DarkRP.textWrap(agendaText, "Font2", 330)
    local lineCount = #string.Explode("\n", wrappedAgendaText)
    local backgroundHeight = 40 + (lineCount * 20) + 10

    if MagicHud.ShowBackground then
        draw.RoundedBox(6, 10, 60, 350, backgroundHeight, Color(0, 0, 0, 225))
    end

    draw.SimpleTextOutlined(title, "Font1", 20, 70, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 150))

    local lines = string.Explode("\n", wrappedAgendaText)
    for i, line in ipairs(lines) do
        draw.SimpleTextOutlined(line, "Font2", 20, 100 + (i - 1) * 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 150))
    end
end

local function DrawBackgroundBlur()
    if MagicHud.ShowBackground then
        surface.SetDrawColor(BackgroundBlur)
        surface.DrawRect(0, 0, ScrW(), 30)
    end
end

local function DrawTopRightText()
    if MagicHud.EnableTopRightTextCycle then
        local time = CurTime()
        local interval = MagicHud.TopRightTextInterval or 10
        local textIndex = math.floor(time / interval) % #MagicHud.TopRightTexts + 1
        local topRightText = MagicHud.TopRightTexts[textIndex]
        draw.SimpleText(topRightText, "Font1", ScrW() - 20, 14, MagicHud.TopRightTextColor or Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    elseif MagicHud.TopRightTexts[1] then
        local topRightText = MagicHud.TopRightTexts[1]
        draw.SimpleText(topRightText, "Font1", ScrW() - 20, 14, MagicHud.TopRightTextColor or Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
end

local function DrawIconWithSoftShadow(xpos, ypos, icon, iconSize, shadowOffset)
    local shadowSize = iconSize + 2
    surface.SetDrawColor(ShadowColor)
    surface.SetMaterial(icon)
    surface.DrawTexturedRect(xpos + shadowOffset, ypos + shadowOffset, shadowSize, shadowSize)
    surface.SetDrawColor(Color(0, 0, 0, 50))
    surface.DrawTexturedRect(xpos + shadowOffset + 1, ypos + shadowOffset + 1, shadowSize + 2, shadowSize + 2)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(icon)
    surface.DrawTexturedRect(xpos, ypos, iconSize, iconSize)
end

local function IsPlayerVisibleAndClose(ply)
    local distance = ply:GetPos():Distance(LocalPlayer():GetPos())
    if distance > 400 then return false end

    local tr = util.TraceLine({
        start = LocalPlayer():GetShootPos(),
        endpos = ply:GetShootPos(),
        filter = {LocalPlayer(), ply},
        mask = MASK_SHOT_HULL
    })
    return not tr.Hit
end

local function Draw3D2DPlayerInfo(ply)
    if not MagicHud.EnableOverheadHUD then return end

    local pos = ply:EyePos() + ply:GetUp() * 25
    local distance = ply:GetPos():Distance(LocalPlayer():GetPos())

    if distance > 400 then return end

    local Ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)

    cam.Start3D2D(pos, Ang, 0.2)

    local yOffset = -50

    if not MagicHud.SandboxMode and ply:getDarkRPVar("HasGunlicense") then
        local gunLicenseYPos = yOffset
        surface.SetMaterial(gunlicenseIcon)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(-12, gunLicenseYPos, 24, 24)
        yOffset = yOffset + 25
    end

    if MagicHud.EnableRankDisplay then
        local userGroup = ply:GetUserGroup()
        local rankConfig = MagicHud.RankSettings[userGroup]

        if rankConfig then
            local displayRank = rankConfig.DisplayName or userGroup
            local rankColor = rankConfig.RainbowColor and GetRainbowColor() or rankConfig.Color or color_white
            local rankIcon = rankConfig.Icon and Material(rankConfig.Icon, "noclamp smooth") or nil

            local rankYPos = yOffset + 5
            surface.SetFont("Font2")
            local rankTextWidth = surface.GetTextSize(displayRank) or 0

            local rankTotalWidth = rankTextWidth
            if rankIcon then
                rankTotalWidth = rankTotalWidth + 20
            end
            local rankXPos = -rankTotalWidth / 2

            if rankIcon then
                surface.SetMaterial(rankIcon)
                surface.SetDrawColor(color_white)
                surface.DrawTexturedRect(rankXPos, rankYPos, 16, 16)
                rankXPos = rankXPos + 20
            end

            draw.SimpleTextOutlined(displayRank, "Font2", rankXPos, rankYPos, rankColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 150))
        end

        yOffset = yOffset + 25
    end

    if ply:getDarkRPVar("wanted") and ply:getDarkRPVar("wantedReason") then
        local wantedReason = ply:getDarkRPVar("wantedReason")
        local timeFactor = math.sin(CurTime() * 8)
        local wantedColor = Color(255 * (timeFactor + 1) / 2, 0, 255 * (1 - (timeFactor + 1) / 2), 255)
        local playerName = ply:Nick()
        draw.SimpleTextOutlined("WANTED: " .. wantedReason .. " | " .. playerName, "Font1", 0, yOffset, wantedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 150))
    else
        draw.SimpleTextOutlined(ply:Nick(), "Font1", 0, yOffset, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 150))
    end

    yOffset = yOffset + 20

    if not MagicHud.SandboxMode then
        local jobText = ply:getDarkRPVar("job") or "ERROR"
        draw.SimpleTextOutlined(jobText, "Font1", 0, yOffset, team.GetColor(ply:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 150))
        yOffset = yOffset + 15
    end

    local healthText = ply:Health() .. "%"
    draw.SimpleTextOutlined(healthText, "Font1", 0, yOffset, MagicHud.HealthColor or Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 150))

    if ply:Armor() > 0 then
        local armorText = ply:Armor() .. "%"
        draw.SimpleTextOutlined(armorText, "Font1", 0, yOffset + 15, MagicHud.ArmorColor or Color(0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 150))
    end

    cam.End3D2D()
end

hook.Add("PostDrawOpaqueRenderables", "Custom3D2DPlayerInfo", function()
    for _, ply in pairs(player.GetAll()) do
        if ply ~= LocalPlayer() and ply:Alive() and IsPlayerVisibleAndClose(ply) then
            Draw3D2DPlayerInfo(ply)
        end
    end
end)

function PlainHudBase()
    local ply = LocalPlayer()
    if not MagicHud.EnableHUD then return end

    local hudXOffset = MagicHud.BarXPos or 10
    local hudYOffset = 14
    local iconYOffset = 8
    local iconTextSpacing = 25
    local elementSpacing = 40
    local iconSize = 16
    local shadowOffset = 1

    DrawBackgroundBlur()

    DrawIconWithSoftShadow(hudXOffset, iconYOffset, user, iconSize, shadowOffset)
    local nameText = ply:GetName()
    draw.SimpleText(nameText, "Font1", hudXOffset + iconTextSpacing, hudYOffset, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    hudXOffset = hudXOffset + iconTextSpacing + surface.GetTextSize(nameText) + elementSpacing

    DrawIconWithSoftShadow(hudXOffset, iconYOffset, heart, iconSize, shadowOffset)
    local healthText = ply:Health() .. "%"
    draw.SimpleText(healthText, "Font1", hudXOffset + iconTextSpacing, hudYOffset, MagicHud.HealthColor or Color(255, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    hudXOffset = hudXOffset + iconTextSpacing + surface.GetTextSize(healthText) + elementSpacing

    if ply:Armor() > 0 then
        DrawIconWithSoftShadow(hudXOffset, iconYOffset, world, iconSize, shadowOffset)
        local armorText = ply:Armor() .. "%"
        draw.SimpleText(armorText, "Font1", hudXOffset + iconTextSpacing, hudYOffset, MagicHud.ArmorColor or Color(0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        hudXOffset = hudXOffset + iconTextSpacing + surface.GetTextSize(armorText) + elementSpacing
    end

    if not MagicHud.SandboxMode then
        DrawIconWithSoftShadow(hudXOffset, iconYOffset, id, iconSize, shadowOffset)
        local jobText = team.GetName(ply:Team())
        draw.SimpleText(jobText, "Font1", hudXOffset + iconTextSpacing, hudYOffset, MagicHud.JobColor or Color(0, 255, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        hudXOffset = hudXOffset + iconTextSpacing + surface.GetTextSize(jobText) + elementSpacing

        DrawIconWithSoftShadow(hudXOffset, iconYOffset, moneyicon, iconSize, shadowOffset)
        local money = DarkRP.formatMoney(ply:getDarkRPVar("money"))
        draw.SimpleText(money, "Font1", hudXOffset + iconTextSpacing, hudYOffset, MagicHud.MoneyColor or Color(0, 255, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        hudXOffset = hudXOffset + iconTextSpacing + surface.GetTextSize(money) + elementSpacing

        DrawIconWithSoftShadow(hudXOffset, iconYOffset, calculator, iconSize, shadowOffset)
        local salary = DarkRP.formatMoney(ply:getDarkRPVar("salary"))
        draw.SimpleText(salary, "Font1", hudXOffset + iconTextSpacing, hudYOffset, MagicHud.SalaryColor or Color(0, 255, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        hudXOffset = hudXOffset + iconTextSpacing + surface.GetTextSize(salary) + elementSpacing
    end

    if not MagicHud.SandboxMode then
        local hasGunLicense = ply:getDarkRPVar("HasGunlicense")
        local gunLicenseAlpha = hasGunLicense and 255 or 100
        surface.SetDrawColor(255, 255, 255, gunLicenseAlpha)
        surface.SetMaterial(gunlicenseIcon)
        surface.DrawTexturedRect(hudXOffset, iconYOffset, iconSize, iconSize)
        hudXOffset = hudXOffset + iconSize + elementSpacing
    end

    if IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():Clip1() > -1 then
        draw.SimpleText(ply:GetActiveWeapon():GetPrintName(), "Font1", ScrW() - 130, ScrH() - 58, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(ply:GetActiveWeapon():Clip1() .. " / " .. ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()) or 0, "Font1", ScrW() - 130, ScrH() - 26, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if not MagicHud.SandboxMode and MagicHud.EnableAgenda then
        DrawAgenda()
    end

    DrawTopRightText()
end

hook.Add("HUDPaint", "PlainHUD", function()
    PlainHudBase()
end)

local tohide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true
}

local hideHUDElements = {
    ["DarkRP_HUD"]              = true,
    ["DarkRP_EntityDisplay"]    = true,
    ["DarkRP_ZombieInfo"]       = true,
    ["DarkRP_LocalPlayerHUD"]   = true,
    ["DarkRP_Hungermod"]        = true,
}

local function HUDShouldDraw(name)
    if tohide[name] or hideHUDElements[name] then
        return false
    end
end

hook.Add("HUDShouldDraw", "hideElements", HUDShouldDraw)