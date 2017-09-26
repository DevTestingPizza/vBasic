-------------- NO NEED TO TOUCH ANYTHING, CHANGE THE vBasic_settings.lua FILE INSTEAD! --------------
if settings.enablePVP then
    SetCanAttackFriendly(GetPlayerPed(-1), true, false)
    NetworkSetFriendlyFireOption(true)
end

if settings.disableEmergencyServices then
    for i = 1, 32 do
        Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
    end
end

if settings.enableWelcomeMessage then
    AddEventHandler("playerSpawned", function()
        local welcomeMsg = string.format(settings.welcomeMessage, GetPlayerName(PlayerId()))
        if settings.makeWelcomeMessageGlobal then
            TriggerServerEvent('sendWelcomeMessage', welcomeMsg)
        else
            TriggerEvent('chatMessage', '', {255,255,255}, welcomeMsg)
        end
    end)
end

function printSettings()
    print(string.format('\n\r---- vBasic Settings ----\nPVP enabled: %s\nWanted level disabled: %s\nEmergency services disabled: %s\nGod mode enabled: %s\nWhitelist enabled: %s\nWelcome message enabled: %s\nMake welcome message global: %s\n---- vBasic Settings ----\n\r', settings.enablePVP, settings.disableWantedLevel, settings.disableEmergencyServices, settings.forceGodModeEnabled, settings.enableWhitelist, settings.enableWelcomeMessage, settings.makeWelcomeMessageGlobal))
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (settings.disableWantedLevel == true) and (GetPlayerWantedLevel(PlayerId()) ~= 0) then
            ClearPlayerWantedLevel(PlayerId())
        end
        if ((settings.forceGodModeEnabled == true) and (GetPlayerInvincible() == false))  or (GetEntityHealth(GetPlayerPed(PlayerId())) < 200) then
            SetEntityHealth(GetPlayerPed(PlayerId()), 200)
            SetPlayerInvincible(PlayerId(), f)
        end
    end
end)
Citizen.CreateThread(function()
    Citizen.Wait(500)
    printSettings()
end)

-----------------------------------------------------------------------------------------------------