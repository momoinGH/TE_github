local assets = { Asset("ANIM", "anim/x_marks_spotsw.zip") }

local prefabs = { "messagebottle", "collapse_small" }

local treasures = { "healingstaff", "purplegem", "orangegem", "yellowgem", "greengem", "redgem", "bluegem",
    "supertelescope", "spear_poison", "boat_lantern", "papyrus", "tunacan", "goldnugget", "gears",
    "rope", "minerhat", "dubloon", "obsidianaxe", "telescope", "captainhat", "peg_leg",
    "volcanostaff", "footballhat", "spear", "goldenaxe", "goldenshovel", "goldenpickaxe",
    "seatrap", "compass", "boneshard", "transistor", "gunpowder", "heatrock", "antivenom",
    "healingsalve", "blowdart_sleep", "nightsword", "amulet", "clothsail", "boatrepairkit",
    "coconade", "boatcannon", "snakeskinhat", "armor_snakeskin", "spear_launcher", "piratehat",
    "boomerang", "snakeskin", "strawhat", "blubbersuit", "nightmarefuel", "obsidianmachete",
    "trap_teeth", "spear_obsidian", "armorobsidian", "goldenmachete", "obsidiancoconade",
    "fabric", "harpoon", "umbrella", "birdtrap", "featherhat", "beehat", "bandage", "armorwood",
    "armormarble", "blowdart_pipe", "armorgrass", "armorseashell", "cane", "icestaff",
    "firestaff", "blowdart_fire", "yellowamulet", "armorruins", "ruins_bat", "ruinshat",
    "cutgrass", "charcoal", "axe", "hammer", "shovel", "bugnet", "fishingrod", "spidergland",
    "silk", "flint", "coral", "earring", }

local function spawntreasure(inst)
    local chest = SpawnPrefab("treasurechest")
    local map = TheWorld.Map
    local x, y, z = inst.Transform:GetWorldPosition()
    chest.Transform:SetPosition(x, y, z)

    ------------------------vai vir um desses 50% de chance pra cada-------------------------

    -----pode vir até 9 moedas----------------------
    for i = 1, 9 do
        if math.random() > 0.5 then
            local single = SpawnPrefab("dubloon")
            chest.components.container:GiveItem(single)
        end
    end

    -----pode vir até 8 tesouros----------------------
    for i = 1, 8 do
        if math.random() > 0.5 then
            local single = SpawnPrefab(treasures[math.random(1, #treasures)])
            if single then
                chest.components.container:GiveItem(single)
            end
        end
    end

    inst:Remove()
end

local function onfinishcallback(inst, worker)
    -- figure out which side to drop the loot
    local pt = inst:GetPosition()
    local hispos = Vector3(worker.Transform:GetWorldPosition())

    local he_right = ((hispos - pt):Dot(TheCamera:GetRightVec()) > 0)

    if he_right then
        inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec() * (math.random() + 1)))
        inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec() * (math.random() + 1)))
    else
        inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec() * (math.random() + 1)))
        inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec() * (math.random() + 1)))
    end

    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/loot_reveal")

    SpawnAt("buriedtreasure_worked", inst)
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local minimap = inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.entity:AddSoundEmitter()

    inst:AddTag("buriedtreasure")

    minimap:SetIcon("xspot.png")
    --	minimap:SetEnabled(false)

    anim:SetBank("x_marks_spotsw")
    anim:SetBuild("x_marks_spotsw")
    anim:PlayAnimation("anim")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onfinishcallback)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "boneshard" })

    --	inst:DoTaskInTime(1, RevealFog)
    --	inst:DoTaskInTime(0.5, FocusMinimap)

    return inst
end

local function treasure()
    local inst = CreateEntity()
    inst.entity:AddTransform()

    inst:DoTaskInTime(0, spawntreasure)

    return inst
end

return Prefab("buriedtreasure", fn, assets, prefabs),
    Prefab("buriedtreasure_worked", treasure)
