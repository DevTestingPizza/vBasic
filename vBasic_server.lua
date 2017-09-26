-------------- NO NEED TO TOUCH ANYTHING, CHANGE THE vBasic_settings.lua FILE INSTEAD! --------------
RegisterServerEvent('sendWelcomeMessage')
AddEventHandler('sendWelcomeMessage', function(welcomeMsg)
    TriggerClientEvent('chatMessage', -1, '', {255,255,255}, welcomeMsg)
end)

function isWhitelisted(source)
    if settings.enableWhitelist then
        local whitelisted = false
        local playerIds = GetPlayerIdentifiers(source)
        for sourceId in pairs(playerIds) do
            for whitelistId in pairs(whitelist) do
                if playerIds[sourceId] == whitelist[whitelistId] then
                    whitelisted = true
                end
            end
        end
        print('whitelist enabled')
        return whitelisted
    else
        print('whitelist not enabled')
        return true
    end
end

AddEventHandler('playerConnecting', function(playerName, setKickReason)
    local isPlayerOnWhitelist = isWhitelisted(source)
    if (isPlayerOnWhitelist == false) then
        setKickReason(settings.whitelistKickMessage)
        CancelEvent()
    end
end)
RegisterCommand('test', function(source)
    for i in pairs(GetPlayerIdentifiers(source)) do
        print(GetPlayerIdentifiers(source)[i])
    end
end)

function printSettings()
    print(string.format('\n\r---- vBasic Settings Loaded ----\nPVP enabled: %s\nWanted level disabled: %s\nEmergency services disabled: %s\nGod mode enabled: %s\nWhitelist enabled: %s\nWelcome message enabled: %s\nMake welcome message global: %s\n---- vBasic Settings Loaded ----\n\r', settings.enablePVP, settings.disableWantedLevel, settings.disableEmergencyServices, settings.forceGodModeEnabled, settings.enableWhitelist, settings.enableWelcomeMessage, settings.makeWelcomeMessageGlobal))
end

Citizen.CreateThread(function()
    Citizen.Wait(500)
    printSettings()
end)
-----------------------------------------------------------------------------------------------------