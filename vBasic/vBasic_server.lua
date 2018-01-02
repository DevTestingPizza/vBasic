-------------- NO NEED TO TOUCH ANYTHING, CHANGE THE CONVARS IN YOUR server.cfg FILE INSTEAD! --------------
-- Creating settings list.
local settings = {}
-- If the convar "vb_check" cannot be found, convars are probably not setup so disable the script.
settings.check = (GetConvar("vb_check", "false") == "true") and true or false
settings.debug = (GetConvar("vb_debug", "false") == "true") and true or false
if not settings.check then
    -- Warn in the server console that the convars have not been setup correctly, so the script will be disabled.
    print("\r")
    print("######################## vBasic ########################")
    print("     YOU HAVE NOT CONFIGURED THE CONVARS CORRECTLY,") 
    print("  VBASIC WILL BE DISABLED UNTIL THE CONVARS ARE FIXED.")
    print("\r")
    print("        PLEASE CHECK THE GITHUB WIKI FOR HELP.")
    print("        https://github.com/TomGrobbe/vBasic/wiki")
    print("########################################################")
    print("\r")
else
    -- The convars are probably setup, not sure if correct but at least it won"t cause crashes anymore.
    -- Converting the convars into their correct format (bool, string, float) and adding them to the settings list.
    settings.enablePVP = (GetConvar("vb_enable_pvp", "false") == "true") and true or false
    settings.disableWantedLevel = (GetConvar("vb_disable_wanted_level", "false") == "true") and true or false
    settings.disableEmergencyServices = (GetConvar("vb_disable_emergency_services", "false") == "true") and true or false
    settings.forceGodModeEnabled = (GetConvar("vb_force_god_mode_enabled", "false") == "true") and true or false
    settings.enableWelcomeMessage = (GetConvar("vb_enable_welcome_message", "false") == "true") and true or false
    settings.makeWelcomeMessageGlobal = (GetConvar("vb_make_welcome_message_global", "false") == "true") and true or false
    settings.welcomeMessage = GetConvar("vb_welcome_message", "Hello {player}, welcome to the server!")
    settings.enableWhitelist = (GetConvar("vb_enable_whitelist", "false") == "true") and true or false
    settings.whitelistKickMessage = GetConvar("vb_whitelist_kick_message", "Sorry, you are not whitelisted!")
    settings.trafficDensity = tonumber(GetConvar("vb_traffic_density", 1.0))
    settings.crowdDensity = tonumber(GetConvar("vb_crowd_density", 1.0))
    settings.enableCrowdControl = (GetConvar("vb_enable_crowd_control", "false") == "true") and true or false
    settings.enableTrafficControl = (GetConvar("vb_enable_traffic_control", "false") == "true") and true or false
    settings.enableUnlimitedStamina = (GetConvar("vb_enable_unlimited_stamina", "false") == "true") and true or false
    
    -- Notify in the server console that the convars have been loaded.
    print("\r")
    print("######################## vBasic ########################")
    print("    You have successfully setup the vBasic convars.")
    print("                        Enjoy :)")
    print("########################################################")
    print("\r")
    
    -- The convars are loaded and the server console has been notified that the script will be activated.
    -- The script can now continue safely.
    
    -- Only add the event handler (for when a player joins) if the whitelist is enabled and/or the welcome message is enabled and set to announce globally.
    if settings.enableWhitelist or (settings.makeWelcomeMessageGlobal and settings.enableWelcomeMessage) then
        
        AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
            -- Defer the connection so we can perform some checks, without accidentally timing out the user.
            deferrals.defer()
            
            -- Save the source
            local s = source
            
            -- Save the joined state (false = not joined, true = player has joined)
            local joined = false
            
            -- Update the status so the user knows what's going on.
            deferrals.update("Welcome, please wait. This won't take long...")
            Wait(100)
            if settings.enableWhitelist then
                -- If the whitelist is enabled, check if the user is on that list.
                if not IsPlayerAceAllowed(s, "vbasic.whitelisted") then
                    -- If the user is not on that list, kick them with the settings.whitelistKickMessage convar. 
                    deferrals.done(tostring(settings.whitelistKickMessage))
                else
                    -- If the user is on the list, let them join.
                    deferrals.done()
                    -- Set joined state to true.
                    joined = true
                end
            else
                -- The whitelist is not enabled, so the user is free to join.
                deferrals.done()
                -- Set joined state to true.
                joined = true
            end
            
            -- If the welcome message is enabled and set to globally announce then send the message to all players.
            -- If the player was kicked somewhere in the whitelist check steps above, "joined" will be false and this won't be executed.
            if joined and settings.enableWelcomeMessage and settings.makeWelcomeMessageGlobal then
                local message = tostring(string.gsub(settings.welcomeMessage, "{player}", GetPlayerName(s)))
                TriggerClientEvent("chatMessage", -1, "", {255,255,255}, message)
                print(message)
            end
        end)
    end
end

-- Create an event handler that sends the settings to the client triggering the event.
-- If the convars have not been setup correctly, the message: "convars-error will be sent instead.
RegisterServerEvent("vb:request_settings")
AddEventHandler("vb:request_settings", function()
    if settings.check then
        -- If the settings/convars have been setup correctly, send the settings to the requesting client.
        TriggerClientEvent("vb:load_settings", source, json.encode(settings))
    else
        -- If the settings have not been setup correctly, send "convars-error" to the client.
        TriggerClientEvent("vb:load_settings", source, "convars-error")
        -- Also log in the server console that the settings have not been sent because the convars have not been setup correctly.
        print("[vBasic] Warning, could not send settings to player " .. GetPlayerName(source) .. " because the convars are not setup correctly.")
    end
end)

-- Added update checker.
PerformHttpRequest("https://vespura.com/vbasic-version.txt", function(err, serverVersion, headers)
    local version = "v3.0.1"
    if string.find(serverVersion, version) == nil then
        print("\n")
        print("###################### vBasic #######################")
        print("## WARNING: Version mismatch. Please update to the ##")
        print("## latest version as soon as possible.  Download:  ##")
        print("##   https://github.com/tomgrobbe/vbasic/releases  ##")
        print("#####################################################")
        print("\n")
    else
        print("[vBasic] Running on the latest version, you're all set.")
    end
end, "GET", "", "")
