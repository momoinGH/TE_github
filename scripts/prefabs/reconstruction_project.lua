local assets =
{
    Asset("ANIM", "anim/pig_house.zip"),
}

local prefabs =
{

}

SetSharedLootTable('reconstruction_project',
    {
        { "boards", 1.00 },
        { "boards", 0.50 },
        { "pigskin", 1.00 },
        { "pigskin", 0.50 },
        { "cutstone", 1.00 },
    })

SetSharedLootTable('lawnornamentsdrop',
    {
        { "oinc", 1.00 },
        { "oinc", 1.00 },
        { "oinc", 1.00 },
        { "oinc", 1.00 },
        { "cutstone", 1.00 },
    })

SetSharedLootTable('topiarymedium',
    {
        { "oinc", 1.00 },
        { "oinc", 1.00 },
        { "oinc", 1.00 },
        { "oinc", 1.00 },
        { "oinc", 1.00 },
    })

SetSharedLootTable('topiarylarge',
    {
        { "oinc", 1.00 },
        { "oinc", 1.00 },
        { "oinc", 1.00 },
        { "oinc", 1.00 },
        { "oinc", 1.00 },
        { "oinc", 1.00 },
    })

SetSharedLootTable('lamp_post',
    {
        { "alloy", 1.00 },
        { "transistor", 1.00 },
        { "lantern", 1.00 },
    })


local REBUILD_REACTION_TIME = TUNING.TOTAL_DAY_TIME / 50
local REBUILD_REACTION_VARIANCE = TUNING.SEG_TIME * 3 / 50

local OFF_SCREENDIST = 30
local AUTO_REPAIRDIST = 100


local function fix(inst, fixer)
    if fixer and fixer.components.fixer then -- covers the actual worker (possibly the player?)
        fixer.components.fixer:ClearTarget()
    end
    if inst.fixer and inst.fixer.components.fixer then -- covers worker selected
        inst.fixer.components.fixer:ClearTarget()
    end
    if inst.construction_prefab then
        local newprop = SpawnPrefab(inst.construction_prefab)
        newprop.Transform:SetPosition(inst.Transform:GetWorldPosition())

        newprop.AnimState:PlayAnimation("place")
        newprop.AnimState:PushAnimation("idle")
        if inst.cityID then
            if newprop.components.citypossession then
                newprop.components.citypossession.cityID = inst.cityID
            end
            if newprop.citypossessionfn then
                newprop.citypossessionfn(newprop)
            end
        end
        if inst.interiorID then
            newprop.interiorID = inst.interiorID
        end
        if newprop.reconstructed then
            newprop:reconstructed()
        end
        newprop:AddTag("reconstructed")
        if inst.spawnerdata and newprop.components.spawner then
            newprop.components.spawner:Configure(inst.spawnerdata.childname, inst.spawnerdata.delay or 0,
                inst.spawnerdata.delay or 0)

            if inst.spawnerdata.child and inst.spawnerdata.child:IsValid() then
                newprop.components.spawner:TakeOwnership(inst.spawnerdata.child)
            end
        end

        --重新连接室内
        if newprop.components.teleporter
            and inst.room_door and inst.room_door:IsValid()
            and inst.room_door.components.teleporter
        then
            newprop.components.teleporter:Target(inst.room_door)
            if not inst.room_door.components.teleporter.target then
                inst.room_door.components.teleporter:Target(newprop)
            end
        end
        inst.room_door = nil
    end
    inst:Remove()
end

local function onhammered(inst, worker)
    if worker and worker.components.inventory and worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("fixable_crusher") then
        SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")

        local bank = inst.reconstruction_stages[inst.reconstruction_stage].bank

        if bank and bank == bank:match("topiary0[1-7]") then
            inst.components.lootdropper:SetChanceLootTable('lawnornamentsdrop')
        end

        if bank and bank == bank:match("topiary_pigman")
            or bank and bank == bank:match("topiary_werepig") then
            inst.components.lootdropper:SetChanceLootTable('topiarymedium')
        end

        if bank and bank == bank:match("topiary_beefalo")
            or bank and bank == bank:match("topiary_pigking") then
            inst.components.lootdropper:SetChanceLootTable('topiarylarge')
        end

        if bank and bank == bank:match("lamp_post") then
            inst.components.lootdropper:SetChanceLootTable('lamp_post')
        end

        inst.components.lootdropper:DropLoot()
        inst:Remove()
        return
    end


    if worker and worker.components.inventory and worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("hammer") then
        inst.reconstruction_stage = inst.reconstruction_stage + 1

        if inst.reconstruction_stages[inst.reconstruction_stage] then
            inst.AnimState:SetBank(inst.reconstruction_stages[inst.reconstruction_stage].bank)
            inst.AnimState:SetBuild(inst.reconstruction_stages[inst.reconstruction_stage].build)
            inst.AnimState:PlayAnimation(inst.reconstruction_stages[inst.reconstruction_stage].anim, true)
            local scale = inst.reconstruction_stages[inst.reconstruction_stage].scale
            if scale then
                inst.AnimState:SetScale(scale[1], scale[2], scale[3])
            end

            inst.saveartdata = {
                bank  = inst.reconstruction_stages[inst.reconstruction_stage].bank,
                build = inst.reconstruction_stages[inst.reconstruction_stage].build,
                anim  = inst.reconstruction_stages[inst.reconstruction_stage].anim,
                scale = inst.reconstruction_stages[inst.reconstruction_stage].scale,
            }

            inst.components.workable:SetWorkLeft(4)
        else
            fix(inst, worker)
        end
    else
        inst.components.workable:SetWorkLeft(4)
    end
end

local function onhit(inst, worker)

end

local function OnSave(inst, data)
    if inst.saveartdata then
        data.bank = inst.saveartdata.bank
        data.build = inst.saveartdata.build
        data.anim = inst.saveartdata.anim
        if inst.saveartdata.scale then
            print("SCALE-X SAVE", inst.saveartdata.scale[1])
            data.scaleX = inst.saveartdata.scale[1]
            data.scaleY = inst.saveartdata.scale[2]
            data.scaleZ = inst.saveartdata.scale[3]
        end
    end
    data.reconstruction_stages = inst.reconstruction_stages
    data.reconstruction_stage = inst.reconstruction_stage
    data.construction_prefab = inst.construction_prefab

    if inst.cityID then
        data.cityID = inst.cityID
    end
    if inst.interiorID then
        data.interiorID = inst.interiorID
    end


    if inst.spawnerdata and inst.spawnerdata.child and inst.spawnerdata.child:IsValid() then
        data.childname = inst.spawnerdata.childname
        data.child = inst.spawnerdata.child and inst.spawnerdata.child.GUID or nil
        data.delay = inst.spawnerdata.delay
    end
    local refs = {}
    if data.child then
        table.insert(refs, data.child)
    end
    if inst.room_door then
        table.insert(refs, inst.room_door.GUID)
        data.room_door = inst.room_door.GUID
    end

    return #refs > 0 and refs or nil
end

local function OnLoad(inst, data)
    if not data then return end

    if data.bank then
        inst.AnimState:SetBank(data.bank)
        inst:Show()
    end
    if data.build then
        inst.AnimState:SetBuild(data.build)
        inst:Show()
    end
    if data.anim then
        inst.AnimState:PlayAnimation(data.anim, true)
        inst:Show()
    end
    if data.scaleX then
        print("HAD SCALE-X", data.scaleX)
        inst.AnimState:SetScale(data.scaleX, data.scaleY, data.scaleZ)
        inst:Show()
    end

    if data.cityID then
        inst.cityID = data.cityID
    end

    if data.interiorID then
        inst.interiorID = data.interiorID
    end

    inst.reconstruction_stage = data.reconstruction_stage
    inst.reconstruction_stages = data.reconstruction_stages
    inst.construction_prefab = data.construction_prefab

    if data.childname then
        inst.spawnerdata = {
            childname = data.childname,
            delay = data.delay
        }
    end
end

local function OnLoadPostPass(inst, newents, data)
    if data and data.room_door and newents[data.room_door] then
        inst.room_door = newents[data.room_door].entity
    end
end

local function getstatus(inst)
    if inst.reconstruction_stage == 2 then
        return "SCAFFOLD"
    else
        return "RUBBLE"
    end
end

local function IsWater(tile)
    return tile == WORLD_TILES.OCEAN_SWELL or
        tile == WORLD_TILES.OCEAN_BRINEPOOL or
        tile == WORLD_TILES.OCEAN_HAZARDOUS or
        tile == WORLD_TILES.OCEAN_ROUGH or
        tile == WORLD_TILES.OCEAN_BRINEPOOL_SHORE or
        tile == WORLD_TILES.OCEAN_COASTAL or
        tile == WORLD_TILES.OCEAN_WATERLOG or
        tile == WORLD_TILES.OCEAN_COASTAL_SHORE
end

local function GetSpawnPoint(inst, pt)
    local theta = math.random() * TWOPI
    local radius = OFF_SCREENDIST

    local offset = FindWalkableOffset(pt, theta, radius, 12, true)
    if offset then
        local pos = pt + offset

        local ground = TheWorld
        local tile = WORLD_TILES.GRASS
        if ground and ground.Map then
            tile = inst:GetCurrentTileType(pos:Get())
        end

        local onWater = IsWater(tile)
        if not onWater then
            return pos
        end
    end
end

local function setfixer(inst, fixer)
    fixer.components.fixer:SetTarget(inst)
    inst.fixer = fixer
end

local function spawnFixer(inst)
    -- if away from player fix, else
    -- look for fixer pig
    -- spawn if none
    -- set pig's fixer target to this inst.
    local player = GetClosestInstWithTag("player", inst, 30)
    if not player then return end
    if inst:GetDistanceSqToInst(player) > AUTO_REPAIRDIST * AUTO_REPAIRDIST then
        fix(inst)
    else
        if not inst.fixer or inst.fixer.components.health:IsDead() then
            inst.fixer = nil
            if TheWorld.state.isday then
                local x, y, z = inst.Transform:GetWorldPosition()

                local ents = TheSim:FindEntities(x, y, z, 30, { "fixer" })
                if #ents > 0 then
                    for i, ent in ipairs(ents) do
                        if ent.components.fixer.target == nil then
                            setfixer(inst, ent)
                            break
                        end
                    end
                else
                    local pt = Vector3(player.Transform:GetWorldPosition())
                    local spawn_pt = GetSpawnPoint(inst, pt)
                    if spawn_pt then
                        local fixer = SpawnPrefab("pigman_mechanic")
                        fixer.Physics:Teleport(spawn_pt:Get())
                        setfixer(inst, fixer)
                    end
                end
            end
        end
        inst.task:Cancel()
        inst.task = nil
        inst.task = inst:DoTaskInTime(20, function() spawnFixer(inst) end)
    end
end

local RoomUtils = require("tropical_utils/room_utils")

-- 销毁同时把室内销毁掉
local function OnRemove(inst)
    local room_center = inst.room_door and inst.room_door:IsValid() and inst.room_door:TroGetRoomCenter() --room_door有值就表示没修好就销毁了
    if room_center then
        RoomUtils.OnRoomDestroy(room_center, inst, nil, true)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("rubble.png")

    anim:SetBank("pig_house")
    anim:SetBuild("pig_house")

    anim:PlayAnimation("unbuilt", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.room_door = nil --室内门对象，等修好后要重新连接

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('reconstruction_project')

    MakeSnowCovered(inst)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst.reconstruction_stage = 1
    inst.reconstruction_stages = {}

    inst:Hide()

    inst.fix = fix

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnLoadPostPass = OnLoadPostPass
    inst.OnRemoveEntity = OnRemove


    inst.task = inst:DoTaskInTime(REBUILD_REACTION_TIME + (math.random() * REBUILD_REACTION_VARIANCE), spawnFixer)
    return inst
end

return Prefab("reconstruction_project", fn, assets, prefabs)
