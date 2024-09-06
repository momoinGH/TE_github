local assets =
{
    Asset("ANIM", "anim/pig_ruins_vines_door.zip"),
    Asset("ANIM", "anim/pig_ruins_vines_build.zip"),
}

local assets_wall =
{
    Asset("ANIM", "anim/pig_ruins_vines_wall.zip"),
    Asset("ANIM", "anim/pig_ruins_vines_build.zip"),
}

local prefabs =
{

}

local RUINS_ENTRANCE_VINES_HACKS = 4
local RUINS_DOOR_VINES_HACKS = 2

local function getanimname(inst)
    local stage_string = "_closed"

    if inst.stage == 1 then
        stage_string = "_med"
    elseif inst.stage == 0 then
        stage_string = "_open"
    end

    return inst.door_orientation .. stage_string
end

local function regrow(inst)
    -- this is just for viuals, it doesn't actually lock the assotiated door.
    if inst.stage ~= 2 then
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/traps/vine_grow")
        inst.stage = 2
        inst.components.workable.workable = true
        inst.components.workable.workleft = inst.components.workable.maxwork
        inst:RemoveTag("NOCLICK")
        inst.AnimState:PlayAnimation(getanimname(inst) .. "_pre", true)
        inst.AnimState:PushAnimation(getanimname(inst), true)
    end
end

local function hackedopen(inst)
    -- this is just for viuals, it doesn't actually open the assotiated door.
    inst.stage = 0
    inst.components.workable.workable = false
    inst:AddTag("NOCLICK")
    inst.AnimState:PlayAnimation(getanimname(inst), true)
end

local function onhackedfn(inst, hacker, hacksleft)
    if hacksleft <= 0 then
        if inst.stage > 0 then
            inst.stage = inst.stage - 1

            if inst.stage == 0 then
                if inst.door then
                    inst.door.components.vineable:SetOpen(true)
                end
            else
                -- 进入下一阶段
                inst.AnimState:PlayAnimation(getanimname(inst) .. "_hit")
                inst.AnimState:PushAnimation(getanimname(inst), true)
                inst.components.workable.workleft = inst.components.workable.maxwork
            end
        end
    else
        inst.AnimState:PlayAnimation(getanimname(inst) .. "_hit")
        inst.AnimState:PushAnimation(getanimname(inst), true)
    end

    local fx = SpawnPrefab("hacking_fx")
    local x, y, z = inst.Transform:GetWorldPosition()
    fx.Transform:SetPosition(x, y + math.random() * 2, z)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/vine_hack")
end

local function setup(inst, door)
    inst.door = door
    inst.Transform:SetPosition(0, 0, 0)
    inst:ListenForEvent("onremove", function() inst:Remove() end, door)
    door:AddChild(inst)

    inst.door_orientation = door.door_orientation
    if inst.door_orientation ~= "south" then
        inst.AnimState:SetSortOrder(3)
    end

    inst.AnimState:PlayAnimation(getanimname(inst), true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.door_orientation = "north"
    inst.stage = 2

    inst.AnimState:SetBank("pig_ruins_vines_door")
    inst.AnimState:SetBuild("pig_ruins_vines_build")
    inst.AnimState:PlayAnimation(getanimname(inst), true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HACK)
    inst.components.workable.onwork = onhackedfn
    inst.components.workable.workleft = RUINS_DOOR_VINES_HACKS
    inst.components.workable.maxwork = RUINS_DOOR_VINES_HACKS

    inst:AddComponent("shearable")

    inst:AddComponent("inspectable")

    inst.setup = setup
    inst.regrow = regrow
    inst.hackedopen = hackedopen
    inst.persists = false

    return inst
end


local function makewallfn(facing)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.door_orientation = facing

        inst.AnimState:SetSortOrder(3)
        inst.AnimState:SetBank("pig_ruins_vines_wall")
        inst.AnimState:SetBuild("pig_ruins_vines_build")
        inst.AnimState:PlayAnimation(inst.door_orientation .. math.random(1, 15), true)

        return inst
    end
    return fn
end

return Prefab("pig_ruins_creeping_vines", fn, assets, prefabs),
    Prefab("pig_ruins_wall_vines_north", makewallfn("north_"), assets_wall, prefabs),
    Prefab("pig_ruins_wall_vines_east", makewallfn("east_"), assets_wall, prefabs),
    Prefab("pig_ruins_wall_vines_west", makewallfn("west_"), assets_wall, prefabs)
