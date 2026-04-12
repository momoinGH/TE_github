-- 在水里就切换到水里的动画
local function CheckGround(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local in_water = TheWorld.Map:IsOceanAtPoint(x, y, z)
    if in_water then
        inst.AnimState:SetBank("grass_inwater")
        inst.AnimState:SetBuild("grass_inwater")
        if inst.components.workable then
            inst.components.workable:SetWorkable(false)
        end
    end
end

AddPrefabPostInit("grass", function(inst)
    if not TheWorld.ismastersim then return end

    inst:DoTaskInTime(0, CheckGround)
end)
