AddModRPCHandler("Living Artifact", "UpdateControls", function(player)
    player.player_classified.artifactoverridden:set(true)
end)

AddModRPCHandler("Living Artifact", "UpdateInput", function(player, event, x, y, z)
    if event then player:PushEvent(event) end
    if x and y and z then player.targetpos = Vector3(x, y, z) end
end)

local function UpdateInput(event, pos)
    if event then ThePlayer:PushEvent(event) end

    local x, y, z
    if pos then
        ThePlayer.targetpos = pos
        x, y, z = pos.x, pos.y, pos.z
    end

    SendModRPCToServer(GetModRPC("Living Artifact", "UpdateInput"), event, x, y, z)
end

TheInput:AddControlHandler(CONTROL_SECONDARY, function(down)
    if TheNet:IsServerPaused() or not (ThePlayer and ThePlayer:HasTag("ironlord")) then return end

    local event = down and "rightbuttondown" or "rightbuttonup"
    UpdateInput(event, TheInput:GetWorldPosition())
end)

TheInput:AddMoveHandler(function()
    if TheNet:IsServerPaused() or not (ThePlayer and ThePlayer:HasTag("charged")) then return end
    UpdateInput(nil, TheInput:GetWorldPosition())
end)

AddClientModRPCHandler("Living Artifact", "ToggleBGM", function(on)
    if on then
        ThePlayer.SoundEmitter:KillAllSounds()
        ThePlayer.SoundEmitter:PlaySound("dontstarve_DLC003/music/iron_lord_suit", "ironlord_music")
    else
        ThePlayer.SoundEmitter:KillSound("ironlord_music")
    end
end)
