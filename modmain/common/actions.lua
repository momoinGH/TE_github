local RoomUtils          = require("tropical_utils/room_utils")

-- Runar: 未定义的优先级，没有的话碎布加燃料会有问题
ACTIONS.ADDFUEL.priority = 1
ACTIONS.GIVE.priority    = 0

Utils.FnDecorator(ACTIONS.JUMPIN, "strfn", function(act)
    if act.target ~= nil then
        if act.target:HasTag("hamlet_houseexit") then
            return { "LEAVE" }, true
        elseif act.target:HasTag("interior_door") or act.target.prefab == "lavaarena_portal" then
            return { "ENTER" }, true
        elseif act.target:HasTag("stairs") then
            return { "USE" }, true
        end
    end
end)

ACTIONS.CASTAOE.strfn = function(act)
    return act.invobject ~= nil and
        string.upper(act.invobject.nameoverride ~= nil and act.invobject.nameoverride or act.invobject.prefab) or nil
end;

Constructor.AddAction(nil, "STOREOPEN", STRINGS.ACTIONS.STOREOPEN, function(act)
    if act.target.components.store == nil then return false end

    if act.target.components.store:CanOpen(act.doer) then
        act.target.components.store:OpenStore(act.doer)
    end

    act.doer._isopening:set(true)
    act.doer._isopening:set_local(true)
    act.target.NetEvt_Requested:push()
    return true
end
)

Constructor.AddAction(nil, "LAVASPIT", STRINGS.ACTIONS.LAVASPIT, function(act)
    if act.doer and act.target and act.doer.prefab == "dragoon" then
        local x, y, z = act.doer.Transform:GetWorldPosition()
        local downvec = TheCamera:GetDownVec()
        local offsetangle = math.atan2(downvec.z, downvec.x) * (180 / math.pi)
        offsetangle = ReduceAngle(offsetangle)
        local offsetvec =
            Vector3(math.cos(offsetangle * DEGREES), -.3, math.sin(offsetangle * DEGREES)) * 1.7
        local spit = SpawnPrefab("dragoonspit")
        spit.Transform:SetPosition(x + offsetvec.x, y + offsetvec.y, z + offsetvec.z)
        spit.Transform:SetRotation(act.doer.Transform:GetRotation())
    end
end)

-- DEPLOY_AI Action [FIX FOR MOBS THAT PLANT TREES]
Constructor.AddAction(nil, "DEPLOY_AI", STRINGS.ACTIONS.DEPLOY_AI, function(act)
    if act.invobject and act.invobject.components.deployable then
        local obj =
            (act.doer.components.inventory and act.doer.components.inventory:RemoveItem(act.invobject)) or
            (act.doer.replica.container and act.doer.replica.container:RemoveItem(act.invobject))
        if obj then
            if obj.components.deployable:TroForceDeploy(act:GetActionPoint(), act.doer, act.rotation) then
                return true
            else
                act.doer.components.inventory:GiveItem(obj)
            end
        end
    end
end)

Constructor.AddAction(nil, "FLUP_HIDE", STRINGS.ACTIONS.FLUP_HIDE, function(act)
    --Dummy action for flup hiding
end)


Constructor.AddAction(nil, "FISH1", STRINGS.ACTIONS.FISH1, function(act)
    if (act.invobject and act.invobject.components.fishingrod)
        or (act.doer and act.doer.components.fishingrod)
    then
        fishingrod:StartFishing(act.target, act.doer)
    end
    return true
end)

Constructor.AddAction(nil, "TIGERSHARK_FEED", STRINGS.ACTIONS.TIGERSHARK_FEED, function(act)
    local doer = act.doer
    if doer and doer.components.lootdropper then
        doer.components.lootdropper:SpawnLootPrefab("wetgoop")
    end
end)

Constructor.AddAction(nil, "MATE", STRINGS.ACTIONS.MATE, function(act)
    if act.target == act.doer then
        return false
    end

    if act.doer.components.mateable then
        act.doer.components.mateable:Mate()
        return true
    end
end)

Constructor.AddAction(nil, "CRAB_HIDE", STRINGS.ACTIONS.CRAB_HIDE, function(act)
    --Dummy action for flup hiding
end)


Constructor.AddAction(nil, "HIDECRAB", STRINGS.ACTIONS.HIDECRAB, function(act)
    return act.doer ~= nil
end)

Constructor.AddAction(nil, "SHOWCRAB", STRINGS.ACTIONS.SHOWCRAB, function(act)
    return act.doer ~= nil
end)



Constructor.AddAction(nil, "PEAGAWK_TRANSFORM", STRINGS.ACTIONS.PEAGAWK_TRANSFORM, function(act)
    --Dummy action for flup hiding
end)



Constructor.AddAction(nil, "MANUALEXTINGUISH", STRINGS.ACTIONS.MANUALEXTINGUISH, function(act)
    if act.doer:HasTag("extinguisher") then
        if act.target.components.burnable and act.target.components.burnable:IsBurning() then
            act.target.components.burnable:Extinguish()
            return true
        end
    elseif act.target.components.sentientball then
        act.target.components.burnable:Extinguish()
        -- damage player?
        return true
    elseif act.invobject:HasTag("frozen") and act.target.components.burnable and act.target.components.burnable:IsBurning() then
        act.target.components.burnable:Extinguish(true, TUNING.SMOTHERER_EXTINGUISH_HEAT_PERCENT, act.invobject)
        return true
    end
end)


Constructor.AddAction(nil, "SPECIAL_ACTION", STRINGS.ACTIONS.SPECIAL_ACTION, function(act)
    if act.doer.special_action then
        act.doer.special_action(act.doer, act)
        return true
    end
end)

Constructor.AddAction(nil, "SPECIAL_ACTION2", STRINGS.ACTIONS.SPECIAL_ACTION2, function(act)
    if act.doer.special_action2 then
        act.doer.special_action2(act)
        return true
    end
end)

Constructor.AddAction(nil, "INFEST", STRINGS.ACTIONS.INFEST, function(act)
    if not act.doer.infesting then
        act.doer.components.infester:Infest(act.target)
    end
    return true
end)


Constructor.AddAction(nil, "DIGDUNG", STRINGS.ACTIONS.DIGDUNG, function(act)
    act.target.components.workable:WorkedBy(act.doer, 1)
end)

Constructor.AddAction(nil, "MOUNTDUNG", STRINGS.ACTIONS.MOUNTDUNG, function(act)
    act.doer.dung_target:Remove()
    act.doer:AddTag("hasdung")
    act.doer.dung_target = nil
end)

Constructor.AddAction(nil, "BARK", STRINGS.ACTIONS.BARK, function(act)
    return true
end)

Constructor.AddAction(nil, "RANSACK", STRINGS.ACTIONS.RANSACK, function(act)
    return true
end)

Constructor.AddAction(nil, "CUREPOISON", STRINGS.ACTIONS.CUREPOISON, function(act)
    if act.invobject and act.invobject.components.poisonhealer then
        local target = act.target or act.doer
        return act.invobject.components.poisonhealer:Cure(target)
    end
end)

Constructor.AddAction(nil, "USEDOOR", STRINGS.ACTIONS.USEDOOR, function(act)
    if act.target:HasTag("secret_room") then
        return false
    end

    if act.target.components.door and not act.target.components.door.disabled then
        act.target.components.door:Activate(act.doer)
        return true
    elseif act.target.components.door and act.target.components.door.disabled then
        return false, "LOCKED"
    end
end)


Constructor.AddAction(nil, "FIX", STRINGS.ACTIONS.FIX, function(act)
    if act.target then
        local target = act.target
        local numworks = 1
        target.components.workable:WorkedBy(act.doer, numworks)
        --	return target:fix(act.doer)		
    end
end)

ACTIONS.RUMMAGE.extra_arrive_dist = function(doer, dest)
    if dest ~= nil then
        local target_x, target_y, target_z = dest:GetPoint()

        local is_on_water = TheWorld.Map:IsOceanTileAtPoint(target_x, 0, target_z) and
            not TheWorld.Map:IsPassableAtPoint(target_x, 0, target_z)
        if is_on_water then
            return 2
        end
    end
    return 0
end

Constructor.AddAction({ priority = 9, rmb = true, distance = 20, mount_valid = false },
    "TIRO",
    STRINGS.ACTIONS.TIRO,
    function(act)
        if act.doer ~= nil and act.doer:HasTag("ironlord") then
            return true
        end
    end
)

----------------------------------------------------------------------------------------------------



local function DoToolWork(act, workaction)
    if
        act.target.components.workable ~= nil and act.target.components.workable:CanBeWorked() and
        act.target.components.workable.action == workaction
    then
        if act.target:HasTag("grass_tall") then
            local equipamento = act.doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipamento and equipamento.prefab == "shears" then
                local x, y, z = act.target.Transform:GetWorldPosition()
                local gramaextra = SpawnPrefab("cutgrass")
                if gramaextra then gramaextra.Transform:SetPosition(x, y, z) end
            end
        end

        if act.target:HasTag("hedgetoshear") then
            local equipamento = act.doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipamento and equipamento.prefab == "shears" then
                local x, y, z = act.target.Transform:GetWorldPosition()
                local gramaextra = SpawnPrefab("clippings")
                if gramaextra then gramaextra.Transform:SetPosition(x, y, z) end
            end
        end

        if act.target:HasTag("hangingvine") then
            local equipamento = act.doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipamento and equipamento.prefab == "shears" then
                local x, y, z = act.target.Transform:GetWorldPosition()
                act.target:DoTaskInTime(1, function()
                    local gramaextra = SpawnPrefab("rope")
                    if gramaextra then gramaextra.Transform:SetPosition(x, y, z) end
                end)
            end
        end

        act.target.components.workable:WorkedBy(
            act.doer,
            (act.invobject ~= nil and act.invobject.components.tool ~= nil and
                act.invobject.components.tool:GetEffectiveness(workaction)) or
            (act.doer ~= nil and act.doer.components.worker ~= nil and
                act.doer.components.worker:GetEffectiveness(workaction)) or
            1
        )
    end
    return true
end

Constructor.AddAction({ priority = 10, mount_valid = true },
    "HACK",
    STRINGS.ACTIONS.HACK,
    function(act)
        return DoToolWork(act, ACTIONS.HACK)
    end
)

Constructor.AddAction(nil,
    "INSTALL",
    STRINGS.ACTIONS.INSTALL,
    function(act)
        if act.invobject ~= nil and act.target ~= nil then
            if act.invobject.components.installable ~= nil
                and act.target.components.installations ~= nil
                and act.target.components.installations:CanInstall(act.invobject.components.installable.prefab)
                and act.invobject.components.installable:DoInstall(act.target) then
                act.invobject:Remove()
                return true
            end
        end
    end
)

-- 收回
Constructor.AddAction({ priority = 11, rmb = true, distance = 4, mount_valid = false },
    "TRO_DISMANTLE",
    STRINGS.ACTIONS.TRO_DISMANTLE,
    function(act)
        if act.target ~= nil and
            act.target.components.pro_portablestructure ~= nil and
            not (act.target.components.burnable ~= nil and act.target.components.burnable:IsBurning()) then
            if act.target.candismantle and not act.target:candismantle() then
                return false
            end
        end
        return act.target.components.pro_portablestructure:Dismantle(act.doer)
    end
)



----------------------------------------------------------------------------------------------------


-- 上岸
Constructor.AddAction({ priority = 9, distance = 4, mount_valid = false, encumbered_valid = true },
    "BOATDISMOUNT",
    STRINGS.ACTIONS.BOATDISMOUNT,
    function(act) return true end
)

----------------------------------------------------------------------------------------------------
--活性机甲
Constructor.AddAction(nil, "IRONTURNON", STRINGS.ACTIONS.IRONTURNON, function(act)
    local inst = act.invobject
    if inst and inst.components.ironmachine and not inst.components.ironmachine:IsOn() then
        inst.components.ironmachine:TurnOn()
        return true
    end
end)

Constructor.AddAction(nil, "IRONTURNOFF", STRINGS.ACTIONS.IRONTURNOFF, function(act)
    local inst = act.invobject
    if inst and inst.components.ironmachine and inst.components.ironmachine:IsOn() then
        inst.components.ironmachine:TurnOff()
        return true
    end
end)

Constructor.AddAction(nil, "CHARGE_UP", STRINGS.ACTIONS.CHARGE_UP, function(act)
    if act.doer:HasTag("ironlord") then
        return true
    end
end)
ACTIONS.CHARGE_UP.do_not_locomote = true

-- 渡渡羽毛扇摇扇动作写死在sg里了，没留overridebuild，勾一下
AddStategraphPostInit("wilson", function(sg)
    local old_enter = sg.states["use_fan"].onenter
    sg.states["use_fan"].onenter = function(inst, ...)
        old_enter(inst, ...)
        local invobject = nil
        if inst.bufferedaction ~= nil then
            invobject = inst.bufferedaction.invobject
        end
        local src_symbol = invobject ~= nil and invobject.components.fan ~= nil and invobject.components.fan.overridesymbol
        if src_symbol == "fan01" then
            inst.AnimState:OverrideSymbol("fan01", "fan_tropical", src_symbol)
        end
    end
end)

----------------------------------------------------------------------------------------------------

-- 添加猪镇和暴食地皮挖起的特殊掉落
local SpeciaTileDrop =
{
    [WORLD_TILES.PIGRUINS] = "cutstone",
    [WORLD_TILES.PIGRUINS_BLUE] = "cutstone",
    [WORLD_TILES.HAMARCHIVE] = "cutstone",

    [WORLD_TILES.QUAGMIRE_GATEWAY] = "turf_quagmire_gateway",
    [WORLD_TILES.QUAGMIRE_CITYSTONE] = "turf_quagmire_citystone",
    [WORLD_TILES.QUAGMIRE_PARKFIELD] = "turf_quagmire_parkfield",
    [WORLD_TILES.QUAGMIRE_PARKSTONE] = "turf_quagmire_parkstone",
    [WORLD_TILES.QUAGMIRE_PEATFOREST] = "turf_quagmire_peatforest",

}
local old_HandleDugGround = HandleDugGround
function HandleDugGround(dug_ground, x, y, z, ...)
    if SpeciaTileDrop[dug_ground] then
        local loot = SpawnPrefab(SpeciaTileDrop[dug_ground])
        if loot.components.inventoryitem ~= nil then
            loot.components.inventoryitem:InheritWorldWetnessAtXZ(x, z)
        end
        loot.Transform:SetPosition(x, y, z)
        if loot.Physics ~= nil then
            local angle = math.random() * TWOPI
            loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
        end
    else
        return old_HandleDugGround(dug_ground, x, y, z, ...)
    end
end

-- 添加深层雨林地皮和毒瘴雨林地皮挖起的特殊效果
local old_terraform = ACTIONS.TERRAFORM.fn
ACTIONS.TERRAFORM.fn = function(act)
    if act.invobject and act.invobject.components.terraformer then
        local tile = TheWorld.Map:GetTileAtPoint(act:GetActionPoint():Get())
        if tile == GROUND.GASRAINFOREST then
            if act.doer.components.talker then
                act.doer.components.talker:Say(GetString(act.doer.prefab, "ANNOUNCE_TOOLCORRODED"))
            end
            local finiteuses = act.invobject.components.finiteuses
            if finiteuses then
                finiteuses:Use(finiteuses:GetUses())
            end
            return
        elseif tile == GROUND.DEEPRAINFOREST then
            if act.doer.components.talker then
                act.doer.components.talker:Say(GetString(act.doer.prefab, "ANNOUNCE_TURFTOOHARD"))
            end
            return
        end
    end
    return old_terraform(act)
end
