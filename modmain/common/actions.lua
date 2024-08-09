local Utils = require("tropical_utils/utils")
local Constructor = require("tropical_utils/constructor")
Constructor.SetEnv(env)

-- Runar: 未定义的优先级，没有的话碎布加燃料会有问题
ACTIONS.ADDFUEL.priority = 1
ACTIONS.GIVE.priority    = 0

Utils.FnDecorator(ACTIONS.JUMPIN, "strfn", function(act)
    if act.target ~= nil then
        if act.target:HasTag("hamletteleport") then
            return { "HAMLET" }, true
        elseif act.target:HasTag("stairs") then
            return { "USE" }, true
        end
    end
end)

-- 进入哈姆雷特小房子
Utils.FnDecorator(ACTIONS.JUMPIN, "fn", function(act)
    if act.doer ~= nil and
        act.doer.sg ~= nil and
        act.doer.sg.currentstate.name == "jumpin_pre" then
        if act.target ~= nil and
            act.target.components.teleporter ~= nil and
            act.target.components.teleporter:IsActive()
            and act.target:HasTag("hamletteleport")
        then
            act.doer.sg:GoToState("hamletteleport", { teleporter = act.target })
            return { true }, true
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


Constructor.AddAction({ priority = 0, rmb = true, distance = 20, mount_valid = true },
    "THROW",
    STRINGS.ACTIONS.THROW,
    function(act)
        local thrown = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if act.target and not act.pos then
            act.pos = act.target:GetPosition()
        end
        if thrown and thrown.components.throwable then
            thrown.components.throwable:Throw(act.pos, act.doer)
            return true
        end
    end
)

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
        act.doer.special_action(act)
        return true
    end
end)

Constructor.AddAction(nil, "SPECIAL_ACTION2", STRINGS.ACTIONS.SPECIAL_ACTION2, function(act)
    if act.doer.special_action2 then
        act.doer.special_action2(act)
        return true
    end
end)

Constructor.AddAction(nil, "LAUNCH_THROWABLE", STRINGS.ACTIONS.LAUNCH_THROWABLE, function(act)
    if act.target and not act.pos then
        act.pos = act.target:GetPosition()
    end
    act.invobject.components.thrower:Throw(act.pos)
    return true
end)

-- TODO 这些action的fn不用返回true吗？
Constructor.AddAction(nil, "INFEST", STRINGS.ACTIONS.INFEST, function(act)
    if not act.doer.infesting then
        act.doer.components.infester:Infest(act.target)
    end
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

Constructor.AddAction({ priority = 9, rmb = true, distance = 1, mount_valid = false, encumbered_valid = true },
    "SHOP",
    STRINGS.ACTIONS.SHOP,
    function(act)
        if act.doer.components.inventory then
            if act.doer:HasTag("player") and act.doer.components.shopper then
                if act.doer.components.shopper:IsWatching(act.target) then
                    local sell = true
                    local reason = nil

                    if act.target:HasTag("shopclosed") or TheWorld.state.isnight then
                        reason = "closed"
                        sell = false
                    elseif not act.doer.components.shopper:CanPayFor(act.target) then
                        local prefab_wanted = act.target.costprefab
                        if prefab_wanted == "oinc" then
                            reason = "money"
                        else
                            reason = "goods"
                        end
                        sell = false
                    end

                    if sell then
                        act.doer.components.shopper:PayFor(act.target)
                        act.target.components.shopdispenser:RemoveItem()
                        act.target:SetImage(nil)

                        if act.target and act.target.shopkeeper_speech then
                            act.target.shopkeeper_speech(act.target,
                                STRINGS.CITY_PIG_SHOPKEEPER_SALE[math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_SALE)])
                        end

                        return true
                    else
                        if reason == "money" then
                            if act.target and act.target.shopkeeper_speech then
                                act.target.shopkeeper_speech(act.target,
                                    STRINGS.CITY_PIG_SHOPKEEPER_NOT_ENOUGH
                                    [math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_NOT_ENOUGH)])
                            end
                        elseif reason == "goods" then
                            if act.target and act.target.shopkeeper_speech then
                                act.target.shopkeeper_speech(act.target,
                                    STRINGS.CITY_PIG_SHOPKEEPER_DONT_HAVE
                                    [math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_DONT_HAVE)])
                            end
                        elseif reason == "closed" then
                            if act.target and act.target.shopkeeper_speech then
                                act.target.shopkeeper_speech(act.target,
                                    STRINGS.CITY_PIG_SHOPKEEPER_CLOSING
                                    [math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_CLOSING)])
                            end
                        end
                        return true
                    end
                else
                    act.doer.components.shopper:Take(act.target)
                    -- THIS IS WHAT HAPPENS IF ISWATCHING IS FALSE
                    act.target.components.shopdispenser:RemoveItem()
                    act.target:SetImage(nil)
                    return true
                end
            end
        end
    end
)


Constructor.AddAction(nil, "FIX", STRINGS.ACTIONS.FIX, function(act)
    if act.target then
        local target = act.target
        local numworks = 1
        target.components.workable:WorkedBy(act.doer, numworks)
        --	return target:fix(act.doer)		
    end
end)

Constructor.AddAction(nil, "STOCK", STRINGS.ACTIONS.STOCK, function(act)
    if act.target then
        act.target.restock(act.target, true)
        act.doer.changestock = nil
        return true
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


Constructor.AddAction({ priority = 9, rmb = true, distance = 8, mount_valid = false, encumbered_valid = true },
    "BOATDISMOUNT",
    STRINGS.ACTIONS.BOATDISMOUNT,
    function(act)
        if act.doer ~= nil and act.doer:HasTag("player") then
            act.doer:AddTag("pulando")
            if not act.doer.components.interactions then
                act.doer:AddComponent("interactions")
            end
            act.doer.components.interactions:BoatDismount(act.doer, act:GetActionPoint())
            return true
        end
    end
)

Constructor.AddAction({ priority = 4, distance = 20, encumbered_valid = true },
    "SURF",
    STRINGS.ACTIONS.SURF,
    function(act)
        local doer_x, doer_y, doer_z = act.doer.Transform:GetWorldPosition()
        local planchadesurf = TheWorld.Map:GetPlatformAtPoint(doer_x, doer_z)
        if planchadesurf and planchadesurf:HasTag("planchadesurf") then
            local pos = act:GetActionPoint()
            if pos == nil then
                pos = act.target:GetPosition()
            end
            planchadesurf.components.oar:Row(act.doer, pos)
            planchadesurf.components.health:DoDelta(-0.5)

            return true
        end
    end
)

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
        bomba.components.complexprojectile:Launch(targetPos)
        act.doer.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/cannon")

        return true
    end
)


Constructor.AddAction({ priority = 9, rmb = true, distance = 20, mount_valid = false },
    "TIRO",
    STRINGS.ACTIONS.TIRO,
    function(act)
        if act.doer ~= nil and act.doer:HasTag("ironlord") then
            --        act.doer:AddComponent("interactions")
            --        act.doer.components.interactions:TIRO(act.doer, act.target:GetPosition())
            return true
        end
    end
)

-- 收回小船
Constructor.AddAction({ priority = 11, rmb = true, distance = 4, mount_valid = false },
    "RETRIEVE",
    STRINGS.ACTIONS.RETRIEVE,
    function(act)
        if act.target.components.portablestructure
            and act.target.components.walkableplatform
            and not next(act.target.components.walkableplatform:GetPlayersOnPlatform()) --船上不能有玩家
        then
            act.target.components.portablestructure:Dismantle(act.doer)
            return true
        end
    end
)

Constructor.AddAction({ priority = 10, rmb = true, distance = 1, mount_valid = false },
    "BOATREPAIR",
    STRINGS.ACTIONS.BOATREPAIR,
    function(act)
        if act.doer:HasTag("aquatic") and act.invobject:HasTag("boatrepairkit") then
            local platform = act.doer:GetCurrentPlatform()
            local boat = platform and platform:HasTag("shipwrecked_boat") and platform or nil
            local boat2 = act.doer.components.driver.vehicle
            if boat and boat2 then
                if boat2.components.finiteuses and boat.components.armor.condition and boat2.components.finiteuses.current + 150 >= boat2.components.finiteuses.total then
                    boat2.components.finiteuses.current = boat2.components.finiteuses.total
                    boat.components.armor.condition = boat2.components.finiteuses.current
                    if boat2.components.finiteuses then
                        boat2.components.finiteuses:Use(1)
                    end
                    if act.invobject.prefab == "sewing_tape" then
                        local nut = act.invobject
                        if act.invobject.components.stackable and act.invobject.components.stackable.stacksize > 1 then
                            nut = act.invobject.components.stackable:Get()
                        end
                        nut:Remove()
                    else
                        if act.invobject.components.finiteuses then
                            act.invobject.components.finiteuses:Use(1)
                        end
                    end
                    return true
                end

                boat2.components.finiteuses.current = boat2.components.finiteuses.current + 150
                boat.components.armor.condition = boat.components.armor.condition + 150
                if act.invobject.components.finiteuses then
                    act.invobject.components.finiteuses:Use(1)
                end
            end
            return true
        end


        if
            act.doer ~= nil and act.target ~= nil and act.doer:HasTag("player") and act.target.components.interactions and
            act.target:HasTag("shipwrecked_boat")
        then
            local equipamento = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

            if equipamento then
                if act.target.components.finiteuses.current + 150 >= act.target.components.finiteuses.total then
                    act.target.components.finiteuses.current = act.target.components.finiteuses.total
                    local gastabarco = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)                      -------armadura

                    if gastabarco then gastabarco.components.armor.condition = act.target.components.finiteuses.current end ---------armadura
                    if equipamento.components.finiteuses then
                        equipamento.components.finiteuses:Use(1)
                    end
                    return true
                end
                act.target.components.finiteuses.current = act.target.components.finiteuses.current + 150
                local gastabarco = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)                      ---------armadura
                if gastabarco then gastabarco.components.armor.condition = act.target.components.finiteuses.current end ---------armadura
                if equipamento.components.finiteuses then
                    equipamento.components.finiteuses:Use(1)
                end
            end
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
    "DISLODGE",
    STRINGS.ACTIONS.DISLODGE,
    function(act)
        local equipamento = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if act.target.components.dislodgeable and act.target.components.dislodgeable.canbedislodged and act.target.components.dislodgeable.caninteractwith then
            if act.doer ~= nil and equipamento then
                if equipamento.components.finiteuses then
                    equipamento.components.finiteuses:Use(1)
                end

                if equipamento and equipamento:HasTag("ballpein_hammer") then
                    if act.target.components.dislodgeable then
                        act.target.components.dislodgeable:Dislodge(act.doer)
                    end
                    return true
                end
            end
        else
            return false
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
                act.target.AnimState:SetBank("wallhamletcity1")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("shop_wall_checkered_metal", true)
                act.target.wallpaper = "shop_wall_checkered_metal"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_circles") then
                act.target.AnimState:SetBank("wallhamletcity1")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("shop_wall_circles", true)
                act.target.wallpaper = "shop_wall_circles"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_marble") then
                act.target.AnimState:SetBank("wallhamletcity1")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("shop_wall_marble", true)
                act.target.wallpaper = "shop_wall_marble"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_sunflower") then
                act.target.AnimState:SetBank("wallhamletcity1")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("shop_wall_sunflower", true)
                act.target.wallpaper = "shop_wall_sunflower"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_woodwall") then
                act.target.AnimState:SetBank("wallhamletcity1")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("shop_wall_woodwall", true)
                act.target.wallpaper = "shop_wall_woodwall"
                return true
            end

            if equipamento and equipamento:HasTag("wall_mayorsoffice_whispy") then
                act.target.AnimState:SetBank("wallhamletcity1")
                act.target.AnimState:SetBuild("wallhamletcity1")
                act.target.AnimState:PlayAnimation("wall_mayorsoffice_whispy", true)
                act.target.wallpaper = "wall_mayorsoffice_whispy"
                return true
            end

            if equipamento and equipamento:HasTag("harlequin_panel") then
                act.target.AnimState:SetBank("wallhamletcity2")
                act.target.AnimState:SetBuild("wallhamletcity2")
                act.target.AnimState:PlayAnimation("harlequin_panel", true)
                act.target.wallpaper = "harlequin_panel"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_fullwall_moulding") then
                act.target.AnimState:SetBank("wallhamletcity2")
                act.target.AnimState:SetBuild("wallhamletcity2")
                act.target.AnimState:PlayAnimation("shop_wall_fullwall_moulding", true)
                act.target.wallpaper = "shop_wall_fullwall_moulding"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_floraltrim2") then
                act.target.AnimState:SetBank("wallhamletcity2")
                act.target.AnimState:SetBuild("wallhamletcity2")
                act.target.AnimState:PlayAnimation("shop_wall_floraltrim2", true)
                act.target.wallpaper = "shop_wall_floraltrim2"
                return true
            end

            if equipamento and equipamento:HasTag("shop_wall_upholstered") then
                act.target.AnimState:SetBank("wallhamletcity2")
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

-- TODO 能优化掉吗？
Constructor.AddAction({ priority = 10, distance = 1, mount_valid = true },
    "GIVE2",
    STRINGS.ACTIONS.GIVE2,
    function(act)
        if act.invobject.components.inventoryitem then
            act.target.components.shelfer:AcceptGift(act.doer, act.invobject)
            return true
        end
    end
)


local function ExtraPickupRange(doer, dest)
    if dest ~= nil then
        local target_x, target_y, target_z = dest:GetPoint()

        local is_on_water = TheWorld.Map:IsOceanTileAtPoint(target_x, 0, target_z) and
            not TheWorld.Map:IsPassableAtPoint(target_x, 0, target_z)
        if is_on_water then
            return 0.75
        end
    end
    return 0
end

Constructor.AddAction({ priority = 1, distance = 2, extra_arrive_dist = ExtraPickupRange, mount_valid = true },
    "PICKUP",
    STRINGS.ACTIONS.PICKUP,
    function(act)
        if act.target and act.target.components.inventoryitem and act.target.components.shelfer then
            local item = act.target.components.shelfer:GetGift()
            if item then
                item:AddTag("cost_one_oinc")
                if act.target.components.shelfer.shelf and not act.target.components.shelfer.shelf:HasTag("playercrafted") then
                    if act.doer.components.shopper and act.doer.components.shopper:IsWatching(item) then
                        if act.doer.components.shopper:CanPayFor(item) then
                            act.doer.components.shopper:PayFor(item)
                        else
                            return false, "CANTPAY"
                        end
                    else
                        if act.target.components.shelfer.shelf and act.target.components.shelfer.shelf.curse then
                            act.target.components.shelfer.shelf.curse(act.target)
                        end
                    end
                end
                item:RemoveTag("cost_one_oinc")
                if item.components.perishable then item.components.perishable:StartPerishing() end
                act.target = act.target.components.shelfer:GiveGift()
            end
        end

        if act.doer.components.inventory ~= nil and
            act.target ~= nil and
            act.target.components.inventoryitem ~= nil and
            (act.target.components.inventoryitem.canbepickedup or
                (act.target.components.inventoryitem.canbepickedupalive and not act.doer:HasTag("player"))) and
            not (act.target:IsInLimbo() or
                (act.target.components.burnable ~= nil and act.target.components.burnable:IsBurning() and act.target.components.lighter == nil) or
                (act.target.components.projectile ~= nil and act.target.components.projectile:IsThrown())) then
            if act.doer.components.itemtyperestrictions ~= nil and not act.doer.components.itemtyperestrictions:IsAllowed(act.target) then
                return false, "restriction"
            elseif act.target.components.container ~= nil and act.target.components.container:IsOpenedByOthers(act.doer) then
                return false, "INUSE"
            elseif (act.target.components.yotc_racecompetitor ~= nil and act.target.components.entitytracker ~= nil) then
                local trainer = act.target.components.entitytracker:GetEntity("yotc_trainer")
                if trainer ~= nil and trainer ~= act.doer then
                    return false, "NOTMINE_YOTC"
                end
            elseif act.doer.components.inventory.noheavylifting and act.target:HasTag("heavy") then
                return false, "NO_HEAVY_LIFTING"
            end

            if (act.target:HasTag("spider") and act.doer:HasTag("spiderwhisperer")) and
                (act.target.components.follower.leader ~= nil and act.target.components.follower.leader ~= act.doer) then
                return false, "NOTMINE_SPIDER"
            end
            if act.target.components.curseditem and not act.target.components.curseditem:checkplayersinventoryforspace(act.doer) then
                return false, "FULL_OF_CURSES"
            end

            if act.target.components.inventory ~= nil and act.target:HasTag("drop_inventory_onpickup") then
                act.target.components.inventory:TransferInventory(act.doer)
            end

            act.doer:PushEvent("onpickupitem", { item = act.target })

            if act.target.components.equippable ~= nil and not act.target.components.equippable:IsRestricted(act.doer) then
                local equip = act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot)
                if equip ~= nil and not act.target.components.inventoryitem.cangoincontainer then
                    --special case for trying to carry two backpacks
                    if equip.components.inventoryitem ~= nil and equip.components.inventoryitem.cangoincontainer then
                        --act.doer.components.inventory:SelectActiveItemFromEquipSlot(act.target.components.equippable.equipslot)
                        act.doer.components.inventory:GiveItem(act.doer.components.inventory:Unequip(act.target
                            .components
                            .equippable.equipslot))
                    else
                        act.doer.components.inventory:DropItem(equip)
                    end
                    act.doer.components.inventory:Equip(act.target)
                    return true
                elseif act.doer:HasTag("player") then
                    if equip == nil or act.doer.components.inventory:GetNumSlots() <= 0 then
                        act.doer.components.inventory:Equip(act.target)
                        return true
                    elseif GetGameModeProperty("non_item_equips") then
                        act.doer.components.inventory:DropItem(equip)
                        act.doer.components.inventory:Equip(act.target)
                        return true
                    end
                end
            end

            act.doer.components.inventory:GiveItem(act.target, nil, act.target:GetPosition())
            return true
        end
    end
)

-- TODO 能优化掉吗？
Constructor.AddAction({ priority = 10, mount_valid = true },
    "HARVEST1",
    STRINGS.ACTIONS.HARVEST1,
    function(act)
        if act.target.components.melter then
            return act.target.components.melter:Harvest(act.doer)
        end
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
    end
)

Constructor.AddAction({ priority = 10, mount_valid = true },
    "INVESTIGATEGLASS",
    STRINGS.ACTIONS.INVESTIGATEGLASS,
    function(act)
        if act.target:HasTag("secret_room") then
            act.target.Investigate(act.doer)
            return true
        end

        if act.target and act.target.components.mystery then
            act.target.components.mystery:Investigate(act.doer)

            local equipamento = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if act.doer ~= nil and equipamento then
                equipamento.components.finiteuses:Use(1)
            end

            return true
        end
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

-- TOOD 能优化掉吗？
Constructor.AddAction({ priority = 10, mount_valid = true },
    "HACK1",
    STRINGS.ACTIONS.HACK,
    function(act)
        local equipamento = act.doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equipamento and equipamento.components.finiteuses then
            equipamento.components.finiteuses:Use(1)
        end
        local numworks = 1
        if equipamento and equipamento.components.tool then
            numworks = equipamento.components.tool:GetEffectiveness(ACTIONS.HACK)
        elseif act.doer and act.doer.components.worker then
            numworks = act.doer.components.worker:GetEffectiveness(ACTIONS.HACK)
        end
        if equipamento and equipamento.components.obsidiantool then
            equipamento.components.obsidiantool:Use(act.doer, act.target)
        end
        if act.target and act.target.components.hackable then
            act.target.components.hackable:Hack(act.doer, numworks)
            return true
        end
        if act.target and act.target.components.workable and act.target.components.workable.action == ACTIONS.HACK then
            act.target.components.workable:WorkedBy(act.doer, numworks)
            return true
        end
        --    return DoToolWork(act, ACTIONS.HACK)
    end
)

Constructor.AddAction({ priority = 10, distance = 3, mount_valid = true },
    "GAS",
    STRINGS.ACTIONS.GAS,
    function(act)
        if act.invobject and act.invobject.components.gasser then
            act.invobject.components.gasser:Gas(act:GetActionPoint())
            return true
        end
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
    "GIVE_DISH",
    STRINGS.ACTIONS.GIVE_DISH,
    function(act)
        if act.target ~= nil and act.target.components.specialstewer then
            if act.target.dish == nil and act.invobject.components.specialstewer_dish then
                if act.invobject.components.specialstewer_dish:IsDishType(act.target.components.specialstewer.cookertype) then
                    act.target:SetDish(act.doer, act.invobject)
                    return true
                end
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

-- TODO 能优化掉吗？
Constructor.AddAction(nil,
    "REPLATE",
    STRINGS.ACTIONS.REPLATE,
    function(act)
        local replatable = act.target and act.target.components.replatable or nil
        if act.invobject and replatable and replatable:CanReplate(act.invobject) then
            replatable:Replate(act.invobject)
            act.invobject.components.stackable:Get(1):Remove()
            return true
        end
    end
)

Constructor.AddAction({ priority = 3, rmb = true, distance = 3, mount_valid = false, encumbered_valid = true },
    "SETUPITEM",
    STRINGS.ACTIONS.SETUPITEM,
    function(act)
        if act.target and act.target.components.setupable and act.invobject then
            if act.target.components.setupable:IsSetup() then
                return false
            else
                act.target.components.setupable:Setup(act.invobject)

                return true
            end
        end
    end
)

Constructor.AddAction({ priority = 3, rmb = true, distance = 1, mount_valid = false, encumbered_valid = true },
    "TAPSUGARTREE",
    STRINGS.ACTIONS.TAPSUGARTREE,
    function(act)
        if act.target and act.invobject and act.target.components.sappy then
            act.target.components.sappy:Tap(act.invobject)

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

Constructor.AddAction({ distance = 2, priority = 3, },
    "KILLSOFTLY",
    STRINGS.ACTIONS.KILLSOFTLY,
    function(act)
        if act.target and act.target.components.health and act.target.components.lootdropper then
            act.target.components.health.invincible = false
            if act.doer.prefab == "wigfrid" then
                act.target.components.lootdropper:DropLoot()
            end

            if act.invobject ~= nil and act.invobject.components.finiteuses then
                act.invobject.components.finiteuses:Use(1)
            end
            if act.doer.prefab == "wigfrid" then
                act.target.components.lootdropper:DropLoot()
            end
            act.target.components.health:Kill()

            return true
        end
    end
)

Constructor.AddAction(nil, "MILK", STRINGS.ACTIONS.MILK, function(act)
    return act.target ~= nil
        and act.invobject ~= nil
        and act.invobject.components.milker ~= nil
        and act.target:HasTag("goddess_deer")
        and act.target:HasTag("windy4")
        and act.target:HasTag("milkable")
        and act.invobject.components.milker:Fill()
end
)
