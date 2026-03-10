-- PlayFootstep函数使用，我需要玩家在室内走路时有声音，但是因为没有地皮，只能覆盖函数，这里使用木板地皮的声音
local function GetCurrentTileTypeBefore(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:TroIsWorldOut(x, 0, z) then
        return { WORLD_TILES.WOODFLOOR, GetTileInfo(WORLD_TILES.WOODFLOOR) }, true
    end
end
Hooks.FnDecorator(EntityScript, "GetCurrentTileType", GetCurrentTileTypeBefore)
