local assets =
{
    Asset("ANIM", "anim/fire_water_pit.zip"),
}

local prefabs =
{
    "chimineafire",
    "collapse_small",
}

local loot =
{
    "sand",
    "sand",
    "tar",
    "tar",
    "tar",
    "limestone",
    "limestone",
    "limestone",
}

local total_day_time = 480
local CHIMINEA_FUEL_MAX = total_day_time * 2
local CHIMINEA_FUEL_START = total_day_time
local CHIMINEA_BONUS_MULT = 2

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle_water", true)
end

local function onignite(inst)
    if not inst.components.cooker then
        inst:AddComponent("cooker")
    end
end

local function onextinguish(inst)
    if inst.components.cooker then
        inst:RemoveComponent("cooker")
    end
    if inst.components.fueled then
        inst.components.fueled:InitializeFuelLevel(0)
    end
end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    local minimap = inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    minimap:SetIcon("firewater_pit.png")
    minimap:SetPriority(1)

    anim:SetBank("fire_water_pit")
    anim:SetBuild("fire_water_pit")
    anim:PlayAnimation("idle_water", true)
    inst:AddTag("campfire")
    inst:AddTag("structure")
    inst:AddTag("nowaves")
    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("quebraonda")
    
    MakeWaterObstaclePhysics(inst, 0.3, 2, 1.25)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------------
    inst:AddComponent("burnable")
    --inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:AddBurnFX("chimineafire", Vector3(0, 0, 0))
    -- TODO: inst.components.burnable:MakeNotWildfireStarter()
    inst:ListenForEvent("onextinguish", onextinguish)
    inst:ListenForEvent("onignite", onignite)

    -------------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    -------------------------
    inst:AddComponent("fueled")
    inst.components.fueled.maxfuel = CHIMINEA_FUEL_MAX
    inst.components.fueled.accepting = true

    inst.components.fueled:SetSections(4)
    inst.components.fueled.bonusmult = CHIMINEA_BONUS_MULT
    inst.components.fueled.ontakefuelfn = function() inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel") end
    inst.components.fueled.rate = 1

    inst.components.fueled:SetUpdateFn(function()
        if inst.components.burnable and inst.components.fueled then
            inst.components.burnable:SetFXLevel(inst.components.fueled:GetCurrentSection(),
                inst.components.fueled:GetSectionPercent())
        end
    end)

    inst.components.fueled:SetSectionCallback(function(section)
        if section == 0 then
            inst.components.burnable:Extinguish()
        else
            if not inst.components.burnable:IsBurning() then
                inst.components.burnable:Ignite()
            end

            inst.components.burnable:SetFXLevel(section, inst.components.fueled:GetSectionPercent())
        end
    end)

    inst.components.fueled:InitializeFuelLevel(CHIMINEA_FUEL_START)

    -----------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = function(inst)
        local sec = inst.components.fueled:GetCurrentSection()
        if sec == 0 then
            return "OUT"
        elseif sec <= 4 then
            local t = { "EMBERS", "LOW", "NORMAL", "HIGH" }
            return t[sec]
        end
    end
    --[[
    inst:ListenForEvent("onbuilt", function()
        anim:PlayAnimation("place")
        anim:PushAnimation("idle_water", true)
        inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    end)]]

    return inst
end

return Prefab("sea_chiminea", fn, assets, prefabs),
    MakePlacer("sea_chiminea_placer", "fire_water_pit", "fire_water_pit", "idle_water")
