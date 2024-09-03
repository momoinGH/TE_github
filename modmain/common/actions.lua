local Utils = require("tropical_utils/utils")
local Constructor = require("tropical_utils/constructor")
Constructor.SetEnv(env)
local InteriorSpawnerUtils = require("interiorspawnerutils")

-- Runar: 未定义的优先级，没有的话碎布加燃料会有问题
ACTIONS.ADDFUEL.priority   = 1
ACTIONS.GIVE.priority      = 0

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


-- 使用道具
Constructor.AddAction({ priority = 1 },
    "TROPICAL_USE_ITEM",
    function(act)
        return FunctionOrValue(act.invobject.components.tro_consumable.str, act.invobject, act.doer, act.target)
    end,
    function(act)
        return act.invobject.components.tro_consumable:Use(act.doer, act.target)
    end
)


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
            if obj.components.deployable:ForceDeploy(act:GetActionPoint(), act.doer, act.rotation) then
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

-- 船炮开火
Constructor.AddAction({ priority = 8, rmb = true, distance = 25, mount_valid = false },
    "BOATCANNON",
    STRINGS.ACTIONS.BOATCANNON,
    function(act)
        local boat = act.doer:GetCurrentPlatform()
        local item = boat
            and boat:HasTag("shipwrecked_boat")
            and boat.components.container
            and boat.components.container:GetItemInSlot(2)
        if not item then return true end --应该不可能

        ----------------posiciona pra sair no canhao-----------------------
        local angle = act.doer:GetRotation()
        local dist = 1.5
        local offset = Vector3(dist * math.cos(angle * DEGREES), 0, -dist * math.sin(angle * DEGREES))
        local targetPos = act.target and act.target:GetPosition() or act:GetActionPoint()
        local bombpos = act.doer:GetPosition() + offset
        local x, y, z = bombpos:Get()

        -------------------------------------------------------

        local bomba = SpawnPrefab(item.prefab == "woodlegs_boatcannon" and "cannonshotobsidian" or "cannonshot")
        if boat.prefab == "woodlegsboat" and act.doer.prefab == "woodlegs" then
            bomba.components.explosive.explosivedamage = 50
        else
            item.components.finiteuses:Use(1)
        end
        bomba.Transform:SetPosition(x, y + 1.5, z)
        bomba.components.complexprojectile:Launch(targetPos, act.doer)
        act.doer.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/cannon")

        return true
    end
)


Constructor.AddAction({ priority = 9, rmb = true, distance = 20, mount_valid = false },
    "TIRO",
    STRINGS.ACTIONS.TIRO,
    function(act)
        if act.doer ~= nil and act.doer:HasTag("ironlord") then
            return true
        end
    end
)



Constructor.AddAction({ priority = 10, rmb = true, distance = 1, mount_valid = false },
    "OPENTUNA",
    STRINGS.ACTIONS.OPENTUNA,
    function(act)
        if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("tunacan") then
            local nut = act.invobject
            if act.invobject.replica.inventoryitem then
                if act.invobject.components.stackable and act.invobject.components.stackable.stacksize > 1 then
                    nut = act.invobject.components.stackable:Get()
                end
                if act.doer.components.inventory then
                    local peixe = SpawnPrefab("fish_med_cooked")
                    act.doer.components.inventory:GiveItem(peixe, 1)
                end
            end
            nut:Remove()
            return true
        end
    end
)


Constructor.AddAction({ priority = 10, rmb = true, distance = 2, mount_valid = false },
    "PAINT",
    STRINGS.ACTIONS.PAINT,
    function(act)
        local equipamento = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if act.doer ~= nil and equipamento then
            if equipamento.components.finiteuses then
                equipamento.components.finiteuses:Use(1)
            end

            if equipamento and equipamento:HasTag("shop_wall_checkered_metal") then
                act.target.AnimState:SetBank("wallhamletcity")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("shop_wall_checkered_metal", true)
                act.target.wallpaper = "shop_wall_checkered_metal"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_circles") then
                act.target.AnimState:SetBank("wallhamletcity")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("shop_wall_circles", true)
                act.target.wallpaper = "shop_wall_circles"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_marble") then
                act.target.AnimState:SetBank("wallhamletcity")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("shop_wall_marble", true)
                act.target.wallpaper = "shop_wall_marble"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_sunflower") then
                act.target.AnimState:SetBank("wallhamletcity")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("shop_wall_sunflower", true)
                act.target.wallpaper = "shop_wall_sunflower"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_woodwall") then
                act.target.AnimState:SetBank("wallhamletcity")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("shop_wall_woodwall", true)
                act.target.wallpaper = "shop_wall_woodwall"
                return true
            end

            if equipamento and equipamento:HasTag("wall_mayorsoffice_whispy") then
                act.target.AnimState:SetBank("wallhamletcity")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("wall_mayorsoffice_whispy", true)
                act.target.wallpaper = "wall_mayorsoffice_whispy"
                return true
            end

            if equipamento and equipamento:HasTag("harlequin_panel") then
                act.target.AnimState:SetBank("wallhamletcity")
                act.target.AnimState:SetBuild("wallhamletcity2")
                act.target.AnimState:PlayAnimation("harlequin_panel", true)
                act.target.wallpaper = "harlequin_panel"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_fullwall_moulding") then
                act.target.AnimState:SetBank("wallhamletcity")
                act.target.AnimState:SetBuild("wallhamletcity2")
                act.target.AnimState:PlayAnimation("shop_wall_fullwall_moulding", true)
                act.target.wallpaper = "shop_wall_fullwall_moulding"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_floraltrim2") then
                act.target.AnimState:SetBank("wallhamletcity")
                act.target.AnimState:SetBuild("wallhamletcity2")
                act.target.AnimState:PlayAnimation("shop_wall_floraltrim2", true)
                act.target.wallpaper = "shop_wall_floraltrim2"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_upholstered") then
                act.target.AnimState:SetBank("wallhamletcity")
                act.target.AnimState:SetBuild("wallhamletcity2")
                act.target.AnimState:PlayAnimation("shop_wall_upholstered", true)
                act.target.wallpaper = "shop_wall_upholstered"
                return true
            end



            if equipamento and equipamento:HasTag("floor_cityhall") then
                act.target.AnimState:PlayAnimation("floor_cityhall", true)
                act.target.floorpaper = "floor_cityhall"
                return true
            end

            if equipamento and equipamento:HasTag("noise_woodfloor") then
                act.target.AnimState:PlayAnimation("noise_woodfloor", true)
                act.target.floorpaper = "noise_woodfloor"
                return true
            end

            if equipamento and equipamento:HasTag("shop_floor_checker") then
                act.target.AnimState:PlayAnimation("shop_floor_checker", true)
                act.target.floorpaper = "shop_floor_checker"
                return true
            end

            if equipamento and equipamento:HasTag("shop_floor_herringbone") then
                act.target.AnimState:PlayAnimation("shop_floor_herringbone", true)
                act.target.floorpaper = "shop_floor_herringbone"
                return true
            end

            if equipamento and equipamento:HasTag("shop_floor_hexagon") then
                act.target.AnimState:PlayAnimation("shop_floor_hexagon", true)
                act.target.floorpaper = "shop_floor_hexagon"
                return true
            end

            if equipamento and equipamento:HasTag("shop_floor_octagon") then
                act.target.AnimState:PlayAnimation("shop_floor_octagon", true)
                act.target.floorpaper = "shop_floor_octagon"
                return true
            end

            if equipamento and equipamento:HasTag("shop_floor_sheetmetal") then
                act.target.AnimState:PlayAnimation("shop_floor_sheetmetal", true)
                act.target.floorpaper = "shop_floor_sheetmetal"
                return true
            end

            if equipamento and equipamento:HasTag("shop_floor_woodmetal") then
                act.target.AnimState:PlayAnimation("shop_floor_woodmetal", true)
                act.target.floorpaper = "shop_floor_woodmetal"
                return true
            end

            if equipamento and equipamento:HasTag("shop_floor_hoof_curvy") then
                act.target.AnimState:PlayAnimation("shop_floor_hoof_curvy", true)
                act.target.floorpaper = "shop_floor_hoof_curvy"
                return true
            end

            if equipamento and equipamento:HasTag("shop_floor_woodpaneling2") then
                act.target.AnimState:PlayAnimation("shop_floor_woodpaneling2", true)
                act.target.floorpaper = "shop_floor_woodpaneling2"
                return true
            end
        end
    end
)

Constructor.AddAction({ priority = 10, mount_valid = true },
    "SMELT",
    STRINGS.ACTIONS.SMELT,
    function(act)
        if act.target.components.melter then
            act.target.components.melter:StartCooking()
            return true
        end
    end
)


----------------------------------------------------------------------------------------------------
-- 柜子

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
        else
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
                target.components.shopped:Restock(true)
            end

            return true
        end
    end
)


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
                local shopkeeper = FindEntity(act.doer, InteriorSpawnerUtils.RADIUS, nil, { "shopkeep" })
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

----------------------------------------------------------------------------------------------------

Utils.FnDecorator(ACTIONS.HARVEST, "fn", function(inst)
    if act.target.components.melter then
        return { act.target.components.melter:Harvest(act.doer) }, true
    end
end)

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
    end
)

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
    "ACTIVATESAIL",
    STRINGS.ACTIONS.ACTIVATESAIL,
    function(act)
        if act.doer ~= nil and act.invobject:HasTag("boatlight") then
            act.invobject:AddTag("ligado")
        end
        return true
    end
)

Constructor.AddAction({ priority = 10, mount_valid = true },
    "COMPACTPOOP",
    STRINGS.ACTIONS.COMPACTPOOP,
    function(act)
        if act.invobject.components.stackable and act.invobject.components.stackable.stacksize > 1 then
            nut = act.invobject.components.stackable:Get()
            nut:Remove()
        else
            act.invobject:Remove()
        end
        act.doer.components.inventory:GiveItem(SpawnPrefab("poop2"))
        return true
    end
)

Constructor.AddAction({ priority = 10, mount_valid = true },
    "DESACTIVATESAIL",
    STRINGS.ACTIONS.DESACTIVATESAIL,
    function(act)
        if act.doer ~= nil and act.invobject:HasTag("boatlight") then
            act.invobject:RemoveTag("ligado")
        end
        return true
    end
)


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

Constructor.AddAction(nil,
    "SNACKRIFICE",
    STRINGS.ACTIONS.SNACKRIFICE,
    function(act)
        local snackrificer = act.target.components.snackrificer
        if snackrificer then
            snackrificer:Snackrifice(act.doer, act.invobject)
            return true
        end
    end
)

Constructor.AddAction({ priority = 3, rmb = true, distance = 1, mount_valid = false, encumbered_valid = true },
    "COLLECTSAP",
    STRINGS.ACTIONS.COLLECTSAP,
    function(act)
        if act.target and act.target.components.sappy then
            act.target.components.sappy:CollectSap(act.doer)
            act.target:RemoveTag("sappy")
            return true
        end
    end
)

-- 海难小船登船
Constructor.AddAction({ priority = 10, distance = 4, mount_valid = false, encumbered_valid = true },
    "BOATMOUNT",
    STRINGS.ACTIONS.BOATMOUNT,
    function(act) return true end --不需要state
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
