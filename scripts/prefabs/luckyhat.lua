local assets =
{
    Asset("ANIM", "anim/hat_woodlegs.zip"),
}

local function treasure(_, _, inst)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil

    if not owner or not inst.components.equippable or not inst.components.equippable:IsEquipped() then
        return
    end

    local player
    if owner:HasTag("player") then
        player = owner
    else
        local x, y, z = inst.Transform:GetWorldPosition()
        player = FindClosestPlayerInRangeSq(x, y, z, 900)
    end

    if not player then return end


    local map = TheWorld.Map
    local x, z
    local sx, sy = map:GetSize()

    for i = 1, 500 do
        x = math.random(-sx, sx)
        z = math.random(-sy, sy)
        if map:IsAboveGroundAtPoint(x, 0, z) then
            break
        end
    end

    SpawnPrefab("buriedtreasure").Transform:SetPosition(x, 0, z)

    if player == owner and player.player_classified ~= nil then
        -- 如果玩家正在装备，就打开地图提示一下
        if self.open_map_on_reveal then
            player.player_classified.revealmapspot_worldx:set(x)
            player.player_classified.revealmapspot_worldz:set(z)
            player.player_classified.revealmapspotevent:push()
        end

        player:DoStaticTaskInTime(4 * FRAMES, function()
            player.player_classified.MapExplorer:RevealArea(x, 0, z, true, true)
        end)
    elseif player.components.talker then
        player.components.talker:Say(GetString(player, "ANNOUNCE_TREASURE"))
    end
end

local function OnEquip(inst, owner, phase)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_woodlegs", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end

    if inst.components.fueled then
        inst.components.fueled:StartConsuming()
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end

    if inst.components.fueled then
        inst.components.fueled:StopConsuming()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("woodlegshat")
    inst.AnimState:SetBuild("hat_woodlegs")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.WINTERHAT_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:SetSections(6)
    inst.components.fueled:SetSectionCallback(treasure)

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"


    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("luckyhat", fn, assets, prefabs)
