-- 监听船的开始移动和停止移动
local function OnLocomote(inst, data)
    local boat = inst:TroGetSWBoat()
    if not boat then return end

    local is_moving = inst.sg:HasStateTag("moving")
    local should_move = inst.components.locomotor:WantsToMoveForward()

    if is_moving and not should_move then
        boat:PushEvent("boat_stopmoving")  --小船停止移动
    elseif not is_moving and should_move then
        boat:PushEvent("boat_startmoving") --小船开始移动
    end
end

-- 在玩家下线前把船脱离出来，因为船作为child不会进行保存
local function OnDespawnBefore(inst)
    inst.components.pro_driver:SetBoat()
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("pro_driver")

    inst:ListenForEvent("locomote", OnLocomote)

    Utils.FnDecorator(inst, "OnDespawn", OnDespawnBefore)
end)
