AddModRPCHandler("volcanomod", "quest1", function(inst)
    local a, b, c = inst.Transform:GetWorldPosition()
    local log = SpawnPrefab("log")
    log.Transform:SetPosition(a + 4, b, c - 4)

    TheFrontEnd:PopScreen()
    SetPause(false)
end)

AddModRPCHandler("volcanomod", "quest2", function(inst)
    TheFrontEnd:PopScreen()
    SetPause(false)
end)