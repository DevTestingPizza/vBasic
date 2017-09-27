-------------- NO NEED TO TOUCH ANYTHING, CHANGE THE CONVARS IN YOUR server.cfg FILE INSTEAD! --------------
local settings = {}
RegisterNetEvent('sendData')
AddEventHandler('sendData', function(options)
    settings = options
    settings.welcomeMessage = string.gsub(settings.welcomeMessage, '{player}', GetPlayerName(PlayerId()))
end)

Citizen.CreateThread(function()
    while settings.welcomeMessage == nil do
        Citizen.Wait(0)
    end
    if settings.enablePVP == "true" then
        SetCanAttackFriendly(GetPlayerPed(-1), true, false)
        NetworkSetFriendlyFireOption(true)
    end

    if settings.disableEmergencyServices == "true" then
        for i = 1, 32 do
            Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
        end
    end

    if settings.enableWelcomeMessage == "true" then
        AddEventHandler("playerSpawned", function()
            if settings.makeWelcomeMessageGlobal == "true" then
                TriggerServerEvent('sendWelcomeMessage', settings.welcomeMessage)
            else
                TriggerEvent('chatMessage', '', {255,255,255}, settings.welcomeMessage)
            end
        end)
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (settings.disableWantedLevel == "true") and (GetPlayerWantedLevel(PlayerId()) ~= 0) then
            ClearPlayerWantedLevel(PlayerId())
        end
        if (settings.forceGodModeEnabled == "true") and ((GetPlayerInvincible() == false)  or (GetEntityHealth(GetPlayerPed(PlayerId())) < 200)) then
            SetEntityHealth(GetPlayerPed(PlayerId()), 200)
            SetPlayerInvincible(PlayerId(), true)
        end
    end
end)
------------------------------------------------------------------------------------------------------------