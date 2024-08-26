local assets =
{
    Asset("ANIM", "anim/lavaarena_boarrior_basic.zip"),
    Asset("ANIM", "anim/lavaarena_rhinodrill_basic.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur_basic.zip"),
}

local function MakeTribute(name, bank, build, anim, scale, arenaativa, enemy_count)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation(anim, true)
        inst.Transform:SetScale(scale, scale, scale)

        inst:AddTag("lavaarena_tribute")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.enemy_count = enemy_count
        inst.arenaativa = arenaativa

        inst:AddComponent("tradable")

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"

        MakeHauntableLaunchAndSmash(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeTribute("spiderbattle", "spider", "spider_build", "idle", .4, 1, 27),
    MakeTribute("houndbattle", "hound", "hound", "idle", .3, 2, 28),
    MakeTribute("mermbattle", "pigman", "merm_build", "idle_loop", .3, 3, 18),
    MakeTribute("boarbattle", "boaron", "lavaarena_boaron_basic", "idle_loop", .3, 4, 24),
    MakeTribute("knightbattle", "knight", "knight_build", "idle_loop", .3, 5, 24),
    MakeTribute("lizardbattle", "snapper", "lavaarena_snapper_basic", "idle_loop", .3, 6, 24),
    MakeTribute("bossboarbattle", "boarrior", "lavaarena_boarrior_basic", "idle_loop", .2, 7, 24),
    MakeTribute("rhinocebrosbattle", "rhinodrill", "lavaarena_rhinodrill_basic", "idle_loop", .2, 8, 24),
    MakeTribute("swineclopsbattle", "beetletaur", "lavaarena_beetletaur", "idle_loop", .2, 9, 24)
