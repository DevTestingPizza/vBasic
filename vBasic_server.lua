-------------- NO NEED TO TOUCH ANYTHING, CHANGE THE CONVARS IN YOUR server.cfg FILE INSTEAD! --------------
local settings = {}
settings.enablePVP = GetConvar("vb_enable_pvp", "false")
settings.disableWantedLevel = GetConvar('vb_disable_wanted_level', "true")
settings.disableEmergencyServices = GetConvar('vb_disable_emergency_services', "true")
settings.forceGodModeEnabled = GetConvar('vb_force_god_mode_enabled', "true")
settings.enableWelcomeMessage = GetConvar('vb_enable_welcome_message', "true")
settings.makeWelcomeMessageGlobal = GetConvar('vb_make_welcome_message_global', "false")
settings.welcomeMessage = GetConvar('vb_welcome_message', 'Hello {player}, welcome to the server!')
settings.enableWhitelist = GetConvar('vb_enable_whitelist', "false")
settings.whitelistKickMessage = GetConvar('vb_whitelist_kick_message', 'Sorry, you are not whitelisted!')
settings.trafficDensity = GetConvar('vb_traffic_density', '1.0')
settings.crowdDensity = GetConvar('vb_crowd_density', '1.0')
settings.enableCrowdControl = GetConvar('vb_enable_crowd_control', 'false')
settings.enableTrafficControl = GetConvar('vb_enable_traffic_control', 'false')
settings.enableUnlimitedStamina = GetConvar('vb_enable_unlimited_stamina', 'true')
local whitelist = GetConvar('vb_whitelist', "steam:110000105959047;license:0546489720234464684;ip:127.0.0.1")


function sendClientData ()
    TriggerClientEvent('sendData', -1, settings)
end
Citizen.CreateThread(function() -- needs to be sent multiple times with delays because of a bug
    Citizen.Wait(1000)
    sendClientData()
    Citizen.Wait(1000)
    sendClientData()
end)


function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
whitelist = stringsplit(whitelist, ';')

RegisterServerEvent('sendWelcomeMessage')
AddEventHandler('sendWelcomeMessage', function(welcomeMsg)
    TriggerClientEvent('chatMessage', -1, '', {255,255,255}, welcomeMsg)
end)

function isWhitelisted(source)
    if settings.enableWhitelist == "true" then
        local whitelisted = false
        local playerIds = GetPlayerIdentifiers(source)
        for sourceId in pairs(playerIds) do
            for whitelistId in pairs(whitelist) do
                if string.lower(playerIds[sourceId]) == string.lower(whitelist[whitelistId]) then
                    whitelisted = true
                end
            end
        end
        return whitelisted
    else
        return true
    end
end

AddEventHandler('playerConnecting', function(playerName, setKickReason)
    TriggerClientEvent('loadClientSettings', -1, settings)
    local isPlayerOnWhitelist = isWhitelisted(source)
    if (isPlayerOnWhitelist == false) then
        setKickReason(settings.whitelistKickMessage)
        CancelEvent()
    end
    Citizen.Wait(5000)-- needs to be sent multiple times with delays because of a bug
    sendClientData()
    Citizen.Wait(5000)
    sendClientData()
    Citizen.Wait(5000)
    sendClientData()
    Citizen.Wait(5000)
    sendClientData()
end)


------------------------------------------------------------------------------------------------------------
