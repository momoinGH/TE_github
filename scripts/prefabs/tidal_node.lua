local assets =
{
    Asset("ANIM", "anim/bubbles.zip"),
}

local function fn1()
    local inst = CreateEntity()

    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    --inst.entity:AddPhysics()
    anim:SetBuild("bubbles")
    anim:SetBank("bubbles")
    anim:SetOrientation(ANIM_ORIENTATION.OnGround)
    anim:PlayAnimation("corentemarinha2", true)
    local animado = math.random(1, 3)
    if animado == 2 then anim:PlayAnimation("corentemarinha2", true) end
    if animado == 3 then anim:PlayAnimation("corentemarinha3", true) end

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("ondamarinha")

    inst:WatchWorldState("startcaveday", function(inst) inst.Transform:SetRotation(180) end)
    inst:WatchWorldState("stopcaveday", function(inst) inst.Transform:SetRotation(0) end)

    return inst
end

return Prefab("tidal_node", fn1, assets)
