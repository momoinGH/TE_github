SetSharedLootTable('bishopb', {})

local function bishop_fnb()
    local inst = Prefabs.bishop.fn()
    inst:AddTag("Arena")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('bishopb')
    inst.kind = ""
    inst.soundpath = "dontstarve/creatures/bishop/"
    inst.effortsound = "dontstarve/creatures/bishop/idle"

    return inst
end

return Prefab("bishopb", bishop_fnb, assets, prefabs)
