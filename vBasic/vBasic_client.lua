-- vBasic by Vespura.
-- v4.0 / 29-06-2018
-- No need to touch anything in here, use the convars instead.


local settings = {}
Citizen.CreateThread(function()
    -- Handler for whenever the settings are received from the server.
    RegisterNetEvent("vBasic:setSettings")
    AddEventHandler("vBasic:setSettings", function(data)
        settings = json.decode(data)
    end)
    
    -- Wait a little before requesting the settings.
    Citizen.Wait(100)
    TriggerServerEvent("vBasic:getSettings")
    
    -- Wait for the settings to be received.
    while settings.pvp == nil do
        Citizen.Wait(1)
    end
    
    -- Loop these things every 10 ticks.
    while true do
        Citizen.Wait(10) -- these things don't need to run every tick.
        
        -- manage pvp
        if (settings.pvp == 1) then
            SetCanAttackFriendly(PlayerPedId(), true, false)
            NetworkSetFriendlyFireOption(true)
        elseif (settings.pvp == 2) then
            SetCanAttackFriendly(PlayerPedId(), false, false)
            NetworkSetFriendlyFireOption(false)
        end
        
        -- manage godmode
        if (settings.godmode == 1) then
            SetPlayerInvincible(PlayerId(), true)
            SetEntityInvincible(PlayerPedId(), true)
        elseif (settings.godmode == 2) then
            SetPlayerInvincible(PlayerId(), false)
            SetEntityInvincible(PlayerPedId(), false)
        end
        
        -- manage unlimited stamina
        if (settings.unlimitedStamina) then
            ResetPlayerStamina(PlayerId())
        end
    end
end)


-- A second thread for running at a different delay.
Citizen.CreateThread(function()

    -- Wait until the settings have been loaded.
    while settings.trafficDensity == nil or settings.pedDensity == nil do
        Citizen.Wait(1)
    end
    
    -- Do this every tick.
    while true do
        Citizen.Wait(0) -- these things NEED to run every tick.
        
        -- Traffic and ped density management
        SetTrafficDensity(settings.trafficDensity)
        SetPedDensity(settings.pedDensity)
        
        -- Wanted level management
        if (settings.neverWanted and GetPlayerWantedLevel(PlayerId()) > 0) then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
        
        -- Dispatch services management
        for i=0,20 do
            EnableDispatchService(i, not settings.noEmergencyServices)
        end
        
    end
end)


function SetTrafficDensity(density)
    SetParkedVehicleDensityMultiplierThisFrame(density)
    SetVehicleDensityMultiplierThisFrame(density)
    SetRandomVehicleDensityMultiplierThisFrame(density)
end

function SetPedDensity(density)
    SetPedDensityMultiplierThisFrame(density)
    SetScenarioPedDensityMultiplierThisFrame(density, density)
end

