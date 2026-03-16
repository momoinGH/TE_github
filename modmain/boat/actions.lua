-- 跳船
Constructor.AddAction({ priority = 10, distance = 4, mount_valid = false, encumbered_valid = true },
    "BOATMOUNT",
    STRINGS.ACTIONS.BOATMOUNT,
    function(act)
        act.doer.components.tro_driver:StartHopBoat(act.target)
        return true
    end
)

-- 发射船炮
Constructor.AddAction({ priority = 11, distance = 25 }, "BOATCANNON", STRINGS.ACTIONS.BOATCANNON, function(act)
    local boat = act.doer:TroGetSWBoat()
    local item = boat
        and boat:HasTag("shipwrecked_boat")
        and boat.components.container
        and boat.components.container:GetItemInSlot(2)
    if not item then return true end     --应该不可能

    ----------------posiciona pra sair no canhao-----------------------
    local angle = act.doer:GetRotation()
    local dist = 1.5
    local offset = Vector3(dist * math.cos(angle * DEGREES), 0, -dist * math.sin(angle * DEGREES))
    local bombpos = act.doer:GetPosition() + offset
    local x, y, z = bombpos:Get()
    act.doer:ForceFacePoint(x, y, z)
    -------------------------------------------------------

    local bomba = SpawnPrefab(item.prefab == "obsidian_boatcannon" and "cannonshotobsidian" or "cannonshot")
    if boat.prefab == "woodlegsboat" and act.doer.prefab == "woodlegs" then
        bomba.components.explosive.explosivedamage = 50
    else
        item.components.finiteuses:Use(1)
    end
    bomba.Transform:SetPosition(x, y + 1.5, z)
    bomba.components.complexprojectile:Launch(act.target and act.target:GetPosition() or act:GetActionPoint(), act.doer)
    act.doer.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/cannon")

    return true
end)
