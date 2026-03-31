local RoomUtils = require("tropical_utils/room_utils")

-- 给workable使用，表示可以被破坏，比如火药
Constructor.AddAction(nil, "BLANK", "")

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

Constructor.AddAction(nil, "FIX", STRINGS.ACTIONS.FIX, function(act)
    if act.target then
        local target = act.target
        local numworks = 1
        target.components.workable:WorkedBy(act.doer, numworks)
        --	return target:fix(act.doer)		
    end
end)

Constructor.AddAction({ priority = 9, rmb = true, distance = 20, mount_valid = false }, "TIRO", STRINGS.ACTIONS.TIRO, function(act)
    if act.doer ~= nil and act.doer:HasTag("ironlord") then
        return true
    end
end
)

----------------------------------------------------------------------------------------------------

-- 收回
Constructor.AddAction({ priority = 11, rmb = true, distance = 4, mount_valid = false }, "TRO_DISMANTLE", STRINGS.ACTIONS.TRO_DISMANTLE, function(act)
    if act.target ~= nil and
        act.target.components.tro_portablestructure ~= nil and
        not (act.target.components.burnable ~= nil and act.target.components.burnable:IsBurning()) then
        if act.target.candismantle and not act.target:candismantle() then
            return false
        end
    end
    return act.target.components.tro_portablestructure:Dismantle(act.doer)
end
)

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

----------------------------------------------------------------------------------------------------

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
    if not item then return true end --应该不可能

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

local SMELT = Action({ priority = 10, mount_valid = true })
SMELT.str = (STRINGS.ACTIONS.SMELT)
SMELT.id = "SMELT"
SMELT.fn = function(act)
    if act.target.components.melter then
        act.target.components.melter:StartCooking()
        return true
    end
end
AddAction(SMELT)

-- 给予、补货，target支持柜子、柜子的槽、货架
local PigShopDefs = require("prefabs/pig_shop_defs")
Constructor.AddAction({ priority = 10, distance = 2, mount_valid = true }, "GIVE_SHELF", STRINGS.ACTIONS.GIVE_SHELF, function(act)
    local target = act.target
    if act.doer:HasTag("player") then
        --玩家往柜子里放东西
        return target.components.shelfer
            and target.components.shelfer:AcceptGift(act.doer, act.invobject)
            or false
    end

    --商店老板
    if target:HasTag("shop_shelf") then
        --柜子随机补3-8个
        local shelve_count = #target.shelves
        for i = 1, math.min(math.random(3, 8), shelve_count) do
            for _, v in ipairs(target.shelves) do
                if not v:HasTag("slot_one") then
                    local item = PigShopDefs.SHELFS.DEFAULT[math.random(#PigShopDefs.SHELFS.DEFAULT)] --先使用默认的
                    item = SpawnPrefab(item)
                    if item and not v.components.shelfer:AcceptGift(act.doer, item) then              --应该不会失败
                        print(string.trofmt("猪人{}向{}补货失败，物品是{}", act.doer, target, item))
                        item:Remove()
                    end
                    break
                end
            end
        end
    elseif target.components.shopped then
        --货架
        if target.components.shopped.shoptype then
            target.components.shopped:Restock(true)
        end
    end

    return true
end)

-- 剪，支持workable和shearable
Constructor.AddAction({}, "SHEAR", STRINGS.ACTIONS.SHEAR, function(act)
    if act.target.components.shearable and act.target.components.shearable:CanBeWorked() then
        act.target.components.shearable:WorkedBy(act.doer)
        return true
    end

    if act.target.components.workable and act.target.components.workable:CanBeWorked() and act.target.components.workable.action == ACTIONS.SHEAR then
        act.target.components.workable:WorkedBy(act.doer)
        return true
    end

    return false
end
)

-- 劈砍
Constructor.AddAction({ priority = 10, mount_valid = true }, "HACK", STRINGS.ACTIONS.HACK, function(act)
    if act.target.components.hackable and act.target.components.hackable:CanBeWorked() then
        act.target.components.hackable:WorkedBy(act.doer)
        return true
    end

    if act.target.components.workable and act.target.components.workable:CanBeWorked() and act.target.components.workable.action == ACTIONS.HACK then
        act.target.components.workable:WorkedBy(act.doer)
        return true
    end

    return false
end)

-- 柜子
-- 拿取、偷、购买
Constructor.AddAction({ priority = 5, distance = 2 }, "TAKE_SHELF", STRINGS.ACTIONS.TAKE_SHELF, function(act)
    local target = act.target
    if act.doer:HasTag("player") then
        --玩家
        if target:HasTag("playercrafted") then
            -- 拿
            local item = target.components.shelfer and target.components.shelfer:GiveGift()
            if item then
                act.doer.components.inventory:GiveItem(item)
                return true
            end
        else
            -- 购买、偷
            if not act.doer.components.shopper:IsWatching(act.target) then     --偷
                act.doer.components.shopper:Take(act.target)
                return true
            end

            local reason, prefab_wanted
            if TheWorld.state.isnight then                                        --晚上不能买
                reason = "closed"
            elseif not act.doer.components.shopper:CanPayFor(act.target) then     --钱不够
                prefab_wanted = act.target:HasTag("cost_one_oinc") and "oinc"
                    or act.target.components.shopped.costprefab
                if prefab_wanted == "oinc" then
                    reason = "money"
                else
                    reason = "goods"
                end
            end

            if not reason then
                act.doer.components.shopper:PayFor(act.target)
            end
            local shopkeeper = FindEntity(act.doer, RoomUtils.RADIUS, nil, { "shopkeep" })
            if shopkeeper then
                if reason == "money" then
                    shopkeeper.components.talker:Say(STRINGS.CITY_PIG_SHOPKEEPER_NOT_ENOUGH[math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_NOT_ENOUGH)])
                elseif reason == "goods" then
                    local name = STRINGS.NAMES[string.upper(prefab_wanted)]
                    assert(name)     --严格一点，货币名字还是得有的
                    shopkeeper.components.talker:Say(string.format(STRINGS.CITY_PIG_SHOPKEEPER_DONT_HAVE[math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_DONT_HAVE)], name))
                elseif reason == "closed" then
                    shopkeeper.components.talker:Say(STRINGS.CITY_PIG_SHOPKEEPER_CLOSING[math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_CLOSING)])
                else
                    shopkeeper.components.talker:Say(STRINGS.CITY_PIG_SHOPKEEPER_SALE[math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_SALE)])
                end
            end

            return true
        end
    else
        --商店老板
    end
end
)

ACTIONS.TAKE_SHELF.stroverridefn = function(act)
    if not act.doer:HasTag("player") then --npc不需要
        return STRINGS.ACTIONS.TAKE_SHELF.GENERIC
    end

    local target = act.target
    local item = target.replica.container and target.replica.container:GetNumSlots() == 1 and target.replica.container:GetItemInSlot(1)
    local name = item and item:GetDisplayName()
        or target.replica.named and target:GetDisplayName()
        or ""
    if target:HasTag("playercrafted") then
        return subfmt(STRINGS.ACTIONS.TAKE_SHELF.TAKE, { item = name })
    elseif act.doer.components.shopper and not act.doer.components.shopper:IsWatching(target) then
        return subfmt(STRINGS.ACTIONS.TAKE_SHELF.STEAL, { item = name })
    else
        return subfmt(STRINGS.ACTIONS.TAKE_SHELF.BUY, { item = name })
    end
end

-- 剪
Constructor.AddAction({ priority = 10, distance = 3, mount_valid = true }, "GAS", STRINGS.ACTIONS.GAS,
    function(act)
        local pos = act.target and act.target:GetPosition() or act:GetActionPoint()
        act.invobject.components.gasser:Gas(pos)
        return true
    end
)

Constructor.AddAction({ priority = 10, mount_valid = true }, "PAN", STRINGS.ACTIONS.PAN,
    function(act)
        if act.target.components.workable and act.target.components.workable.action == ACTIONS.PAN then
            local numworks = 1

            if act.invobject and act.invobject.components.tool then
                numworks = act.invobject.components.tool:GetEffectiveness(ACTIONS.PAN)
            elseif act.doer and act.doer.components.worker then
                numworks = act.doer.components.worker:GetEffectiveness(ACTIONS.PAN)
            end
            act.target.components.workable:WorkedBy(act.doer, numworks)
        end
        return true
    end)

Constructor.AddAction({ priority = 3, instant = false, mount_valid = true, rmb = true, distance = 1, canforce = true },
    "MEAL",
    STRINGS.ACTIONS.MEAL,
    function(act)
        if act.target ~= nil and act.target.components.mealer ~= nil then
            act.target.components.mealer:StartMealing()
            return true
        end
    end
)

Constructor.AddAction(nil, "SNACKRIFICE", STRINGS.ACTIONS.SNACKRIFICE, function(act)
    local snackrificer = act.target.components.snackrificer
    if snackrificer then
        snackrificer:Snackrifice(act.doer, act.invobject)
        return true
    end
end)
