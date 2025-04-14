-- 地震组件quaker不好覆盖，这里判断如果是地震生成的物品就直接删除

local function CheckIsQUaker(inst)
    if not inst.persists and inst.shadow and inst.updatetask then --地震生成的，根据quaker组件的SpawnDebris函数进行判断
        local x, _, z = inst.Transform:GetWorldPosition()
        local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
        if IsSpecialTile(tile) then
            inst:Remove()
        end
    end
end

for _, v in ipairs({
    "rocks",
    "rabbit",
    "mole",
    "carrat",
    "flint",
    "goldnugget",
    "nitre",
    "redgem",
    "bluegem",
    "marble",
    "moonglass",
    "rock_avocado_fruit",
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end

        inst:ListenForEvent("startfalling", CheckIsQUaker)
    end)
end