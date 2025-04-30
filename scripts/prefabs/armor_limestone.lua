local assets =
{
	Asset("ANIM", "anim/armor_limestone.zip"),
}

local ARMORLIMESTONE = 150*5.5
local ARMORLIMESTONE_ABSORPTION = .70
local ARMORLIMESTONE_SLOW = 0.90

local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve_DLC002/common/armour/limestone")
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_limestone", "swap_body")
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)
    
    inst.AnimState:SetBank("armor_limestone")
    inst.AnimState:SetBuild("armor_limestone")
    inst.AnimState:PlayAnimation("anim")
	
    inst.foleysound = "dontstarve_DLC002/common/foley/limestone_suit"  
		
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inspectable")  
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml"
	inst.caminho = "images/inventoryimages/hamletinventory.xml"
	    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(ARMORLIMESTONE, ARMORLIMESTONE_ABSORPTION)
 
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    --inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
	
    inst.components.equippable.walkspeedmult = ARMORLIMESTONE_SLOW
	
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/armorlimestone", fn, assets) 
