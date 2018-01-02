-------------- NO NEED TO TOUCH ANYTHING, CHANGE THE CONVARS IN YOUR server.cfg FILE INSTEAD! --------------
-- Creating the local settings list.
local settings = {}

-- Create a new thread. This way the code will only be executed if the script is really ready for it and all other
-- resources and checks have been completed.
Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Small delay to let the server script load before requesting data.
    print('Requesting settings from server.')
    TriggerServerEvent("vb:request_settings")
    RegisterNetEvent("vb:load_settings")
    AddEventHandler("vb:load_settings", function(json_settings)
        print('Server settings incoming....')
        if json_settings ~= "convars-error" and json_settings ~= nil then
            -- JSON Decode the settings and put them in the settings list/table.
            settings = json.decode(json_settings)
            
            -- Print debug info if enabled.
            DebugPrint('\n')
            DebugPrint('Settings received\n')
            DebugPrint(json_settings)
            DebugPrint('\n')
            
            if settings.enableWelcomeMessage then
                local message = tostring(string.gsub(settings.welcomeMessage, "{player}", GetPlayerName(PlayerId())))
                TriggerEvent("chatMessage", "", {255,255,255}, message)
                DebugPrint('welcome message for local player sent: ' .. message)
            end
            
            DebugPrint('Settings loaded, calling main function now.')
            SettingsLoaded()
        end
    end)
end)

-- Will be executed if the settings are loaded successfully.
function SettingsLoaded()
    Citizen.CreateThread(function()
        DebugPrint('Main function called, loop starting now.')
        -- Create the infinite loop.
        while true do
            -- Of course, can't forget about the crash prevention, also creating a local PlayerPed and Player (ID) variable to prevent repetition.
            Citizen.Wait(0)
            local PlayerPed = PlayerPedId()
            local Player = PlayerId()
            
            -- If enablePVP is true, then enable PVP.
            if settings.enablePVP then
                SetCanAttackFriendly(PlayerPed, true, false)
                NetworkSetFriendlyFireOption(true)
            end
            
            -- If disableWantedLevel is true and the player is currently wanted, then clear wanted level.
            if settings.disableWantedLevel and GetPlayerWantedLevel(Player) ~= 0 then
                ClearPlayerWantedLevel(Player)
            end
            
            -- If disableEmergencyServices is true, disable them.
            if settings.disableEmergencyServices then
                -- Disable police dispatch for the player in general.
                SetDispatchCopsForPlayer(Player, false)
                
                -- Disable specific/more emergency services from being dispatched.
                EnableDispatchService(1, false) -- PoliceAutomobileDispatch
                EnableDispatchService(2, false) -- PoliceHelicopterDispatch
                EnableDispatchService(3, false) -- FireDepartmentDispatch
                EnableDispatchService(4, false) -- SwatAutomobileDispatch
                EnableDispatchService(5, false) -- AmbulanceDepartmentDispatch
                EnableDispatchService(6, false) -- PoliceRidersDispatch
                EnableDispatchService(7, false) -- PoliceVehicleRequest
                EnableDispatchService(8, false) -- PoliceRoadBlockDispatch
                EnableDispatchService(11, false) -- GangDispatch
                EnableDispatchService(12, false) -- SwatHelicopterDispatch
                EnableDispatchService(13, false) -- PoliceBoatDispatch
                EnableDispatchService(14, false) -- ArmyVehicleDispatch
                EnableDispatchService(15, false) -- BikerBackupDispatch
            end
            
            -- If godmode is set to true, enable god mode for the player if it isn't enabled already.
            if settings.forceGodModeEnabled then
                if not GetPlayerInvincible(Player) then
                    SetPlayerInvincible(Player, true)
                end
                
                -- Heal the player to 200 health if their health is < 200.
                if GetEntityHealth(PlayerPed) < 200 then
                    SetEntityHealth(PlayerPed, 200)
                end
            end
            
            -- If enableTrafficControl is true, then manage trafficDensity.
            if settings.enableTrafficControl then
                SetVehicleDensityMultiplierThisFrame(settings.trafficDensity)
                SetRandomVehicleDensityMultiplierThisFrame(settings.trafficDensity)
                SetParkedVehicleDensityMultiplierThisFrame(settings.trafficDensity)
                SetSomeVehicleDensityMultiplierThisFrame(settings.trafficDensity)
            end
            
            -- If enableCrowdControl is true, then manage crowdDensity.
            if settings.enableCrowdControl then
                SetPedDensityMultiplierThisFrame(settings.crowdDensity)
                SetScenarioPedDensityMultiplierThisFrame(settings.crowdDensity)
            end
            
            -- If unlimited stamina is true, enable player stamina.
            if settings.enableUnlimitedStamina then
                ResetPlayerStamina(Player)
            end
        end
    end)
end

function DebugPrint(data)
    if settings.debug then
        print('[vBasic DEBUG] ' .. tostring(data))
    end
end
