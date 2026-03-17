local assets =
{
    Asset("ANIM", "anim/fern_plant.zip"),
}

local function onsave(inst, data)
    data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname)
    end
end


local function plantfn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("fern_plant")
    inst.AnimState:SetBuild("fern_plant")

    local color = 0.7 + math.random() * 0.3
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst.animname = math.random() < 0.5 and "idle" or "idle2"
    inst.AnimState:PlayAnimation(inst.animname)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("deep_jungle_fern_noise_plant", plantfn, assets)
