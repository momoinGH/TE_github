local assets=
{
	Asset("ANIM", "anim/infused_iron.zip"),
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

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()  
    inst.entity:AddLight() 	
	
    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)		
	
	inst.entity:AddSoundEmitter()
	inst.pickupsound = "metal"

    inst.AnimState:SetBank("infused_iron")
    inst.AnimState:SetBuild("infused_iron")
    inst.AnimState:PlayAnimation("idle")
	
    inst.Light:SetColour(111/255, 111/255, 227/255)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(true)
	
    inst:AddTag("molebait")
    inst:AddTag("infused")    
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end	
	
    --MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.HEAVY, TUNING.WINDBLOWN_SCALE_MAX.HEAVY)
    
    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 1
	
    inst:AddComponent("tradable")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml" 
	inst.caminho = "images/inventoryimages/hamletinventory.xml"
	
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.MOONGLASS_CHARGED_PERISH_TIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "iron"
	
    inst.OnSave = onsave 
    inst.OnLoad = onload 
    return inst
end

return Prefab( "common/inventory/infused_iron", fn, assets) 
