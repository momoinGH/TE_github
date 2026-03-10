Hooks.FnDecorator(ACTIONS.COOK, "stroverridefn", function(act)
    if act.target and act.target.prefab == "smelter" then
        return { STRINGS.ACTIONS.SMELT }, true
    end
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
Constructor.AddAction({ priority = 10, distance = 2, mount_valid = true },
    "GIVE_SHELF",
    STRINGS.ACTIONS.GIVE_SHELF,
    function(act)
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
                        v.components.shelfer:AcceptGift(act.doer, item)                                   --应该不会失败
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
    end
)

-- 剪，支持workable和shearable
Constructor.AddAction({},
    "SHEAR",
    STRINGS.ACTIONS.SHEAR,
    function(act)
        if act.target.components.shearable then
            act.target.components.shearable:Shear(act.doer)
            return true
        end

        if act.target.components.workable and act.target.components.workable.action == ACTIONS.SHEAR then
            act.target.components.workable:WorkedBy(act.doer)
            return true
        end
    end
)

-- 柜子
-- 拿取、偷、购买
Constructor.AddAction({ priority = 5, distance = 2 },
    "TAKE_SHELF",
    function() end,
    function(act)
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
                if not act.doer.components.shopper:IsWatching(act.target) then --偷
                    act.doer.components.shopper:Take(act.target)
                    return true
                end

                local reason, prefab_wanted
                if TheWorld.state.isnight then                                    --晚上不能买
                    reason = "closed"
                elseif not act.doer.components.shopper:CanPayFor(act.target) then --钱不够
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
                        assert(name) --严格一点，货币名字还是得有的
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
    elseif not act.doer.components.shopper:IsWatching(target) then
        return subfmt(STRINGS.ACTIONS.TAKE_SHELF.STEAL, { item = name })
    else
        return subfmt(STRINGS.ACTIONS.TAKE_SHELF.BUY, { item = name })
    end
end

-- 剪
Constructor.AddAction({ priority = 10, distance = 3, mount_valid = true },
    "GAS",
    STRINGS.ACTIONS.GAS,
    function(act)
        local pos = act.target and act.target:GetPosition() or act:GetActionPoint()
        act.invobject.components.gasser:Gas(pos)
        return true
    end
)

Constructor.AddAction({ priority = 10, mount_valid = true },
    "PAN",
    STRINGS.ACTIONS.PAN,
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
