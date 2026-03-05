Utils.FnDecorator(ACTIONS.COOK, "stroverridefn", function(act)
    if act.target and act.target.prefab == "smelter" then
        return { STRINGS.ACTIONS.SMELT }, true
    end
end)

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
