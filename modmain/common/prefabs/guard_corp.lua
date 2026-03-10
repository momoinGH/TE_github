local Utils = require("tropical_utils/utils")
-- 根据地皮判断不太好，能不能给草添加特殊标签
local CANT_PICK_TILES = {
    [GROUND.SUBURB] = true,
    [GROUND.FOUNDATION] = true,
    [GROUND.COBBLEROAD] = true,
    [GROUND.FIELDS] = true
}

-- 当玩家采集哈姆雷特的草时，附近守卫攻击玩家
local GUARD_MUST_TAGS = { "_combat", "_health", "guard" }
local function OnPlayerPick(inst, worker)
    if worker and worker:HasTag("player") and not worker:HasTag("sneaky") then
        local x, y, z = inst.Transform:GetWorldPosition()
        local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
        if CANT_PICK_TILES[tile] then
            for _, v in ipairs(TheSim:FindEntities(x, y, z, 40, GUARD_MUST_TAGS)) do
                if v.components.combat:CanTarget(worker) then
                    v.components.combat:SuggestTarget(worker)
                end
            end
        end
    end
end

local function OnTransplantfnAfter(retTab, inst)
    -- checks to turn into Tall Grass if on the right terrain 高草转化
    local map = TheWorld.Map
    local x, y, z = inst.Transform:GetWorldPosition()
    local tiletype = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

    if tiletype == GROUND.PLAINS
        or tiletype == GROUND.RAINFOREST
        or tiletype == GROUND.DEEPRAINFOREST then
        local newgrass = SpawnPrefab("grass_tall")
        newgrass.Transform:SetPosition(x, y, z)
        if newgrass:HasTag("machetecut") then
            inst:RemoveTag("machetecut")
        end
        newgrass.components.workable:SetWorkAction(ACTIONS.DIG)
        newgrass.components.workable:SetWorkLeft(1)
        newgrass.components.timer:StartTimer("spawndelay", 60 * 8 * 4)
        newgrass.AnimState:PlayAnimation("picked", true)
        inst:Remove()
    end
end

for _, v in ipairs({
    "grass",
}) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("grasss") --用于海难刮大风用的

        if not TheWorld.ismastersim then return end

        if inst.components.workable then
            Hooks.FnDecorator(inst.components.workable, "onfinish", OnPlayerPick)
        end

        if inst.components.pickable then
            Hooks.FnDecorator(inst.components.pickable, "onpickedfn", OnPlayerPick)
            Hooks.FnDecorator(inst.components.pickable, "ontransplantfn", nil, OnTransplantfnAfter)
        end
    end)
end
