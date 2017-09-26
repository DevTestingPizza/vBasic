settings = {
    ['enablePVP'] = false,   -- Allow PVP?
    ['disableWantedLevel'] = true,      -- Disable wanted level for everyone.
    ['disableEmergencyServices'] = true,    -- Stop NPC police, ambulance and fire trucks from responding to events. (Does not disable wanted level).
    ['forceGodModeEnabled'] = true,     -- Should godmode be enabled for everyone, no matter what? If true, you might as well set 'enablePVP' to false to improve performance.
    ['enableWhitelist'] = false,    -- Should the whitelist be enabled?
    ['whitelistKickMessage'] = 'Sorry, you are not whitelisted!',    -- Should the whitelist be enabled?
    ['enableWelcomeMessage'] = true,    -- Should players who join the server receive a welcome message?
    ['makeWelcomeMessageGlobal'] = false,   -- Set to true if you want everyone to see the message, leave at false to only send the message to the new player.
    ['welcomeMessage'] = 'Hello %s, welcome to the server!'    -- The welcome message sent to joining players. %s will be replaced with the player name.
}

whitelist = {
    'steam:110000105959047',
    'license:0546489720234464684',
    'ip:127.0.0.1' -- IP's work, but are not recommended for a secure whitelist.
}
