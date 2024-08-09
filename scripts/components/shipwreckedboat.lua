local SourceModifierList = require("util/sourcemodifierlist")

local function OnItemGet(inst, data)
    local item = data.item
    if not item.components.shipwreckedboatparts or (data.slot ~= 1 and data.slot ~= 2) then
        return
    end

    inst.components.shipwreckedboat.speedmultiplier:SetModifier(item, item.components.shipwreckedboatparts.speed_mult)

    local player = next(inst.components.walkableplatform:GetPlayersOnPlatform())
    if player then
        local fn = item.components.shipwreckedboatparts.onplayermountedfn
        if fn then
            fn(item, inst, player)
        end
    end

    item:PushEvent("boat_equipped", { owner = inst })
end

local function OnItemLose(inst, data)
    local item = data.prev_item
    if not item.components.shipwreckedboatparts or (data.slot ~= 1 and data.slot ~= 2) then
        return
    end

    inst.components.shipwreckedboat.speedmultiplier:RemoveModifier(item)

    local player = next(inst.components.walkableplatform:GetPlayersOnPlatform())
    if player then
        local fn = item.components.shipwreckedboatparts.onplayerdismountedfn
        if fn then
            fn(item, inst, player)
        end
    end

    item:PushEvent("boat_unequipped", { owner = inst })
end

--- 海难小船
local ShipwreckedBoat = Class(function(self, inst)
    self.inst = inst

    self.speedmultiplier = SourceModifierList(self.inst)

    inst:AddTag("shipwrecked_boat")

    inst:ListenForEvent("itemget", OnItemGet)
    inst:ListenForEvent("itemlose", OnItemLose)
end)

function ShipwreckedBoat:GetDriver()
    return next(self.inst.components.walkableplatform:GetPlayersOnPlatform())
end

--- 返回移速倍率
function ShipwreckedBoat:GetSpeedMutliplier()
    return self.speedmultiplier:Get()
end

--- 玩家上船
function ShipwreckedBoat:OnPlayerMounted(player)
    if self.inst.components.container then
        for i = 1, 2 do
            local item = self.inst.components.container:GetItemInSlot(i)
            local fn = item and item.components.shipwreckedboatparts.onplayermountedfn
            if fn then
                fn(item, self.inst, player)
            end
        end
    end
end

--- 玩家下船
function ShipwreckedBoat:OnPlayerDismounted(player)
    if self.inst.components.container then
        for i = 1, 2 do
            local item = self.inst.components.container:GetItemInSlot(i)
            local fn = item and item.components.shipwreckedboatparts.onplayerdismountedfn
            if fn then
                fn(item, self.inst, player)
            end
        end
    end
end

return ShipwreckedBoat
