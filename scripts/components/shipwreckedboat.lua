--[[
海难小船逻辑：

1. 玩家上船后将装备小船，同时小船生成一个复制体挂在玩家身上
2. 复制体所有特征与小船一样，不过自己container里面没有东西，通过container_proxy和小船内容一致
4. 玩家下船时删除复制体，装备的小船掉落
5. 玩家退出游戏重进时，由于复制体不会保存，所以重新上线时会重新生成一个复制体
6. 动画数据小船和复制体应该一起修改

]]

local function OnItemGet(inst, data)
    local item = data and data.item
    local part = item and item.components.shipwreckedboatparts
    if not part or (data.slot ~= 1 and data.slot ~= 2) then
        return
    end

    local self = inst.components.shipwreckedboat
    self:UpdateSpeedMult()

    local driver = inst.components.inventoryitem.owner
    if driver then
        if part.onplayermountedfn then
            part.onplayermountedfn(item, inst, driver)
        end
    end

    item:PushEvent("boat_equipped", { owner = inst }) --需要判断真假船！可以根据pro_fakeboat标签判断
end

local function OnItemLose(inst, data)
    local item = data and data.item
    local part = item and item.components.shipwreckedboatparts
    if not part or (data.slot ~= 1 and data.slot ~= 2) then
        return
    end

    local self = inst.components.shipwreckedboat
    self:UpdateSpeedMult()

    local driver = inst.components.inventoryitem.owner
    if driver then
        if part.onplayerdismountedfn then
            part.onplayerdismountedfn(item, inst, driver)
        end
    end

    item:PushEvent("boat_unequipped", { owner = inst })
end

--- 海难小船
local Boat = Class(function(self, inst)
    self.inst = inst

    self.boatfx = nil --这是船体的复制体，真正的船被玩家装入物品栏后该船就会生成并挂在玩家身上跟随移动

    inst:AddTag("shipwrecked_boat")

    inst:ListenForEvent("itemget", OnItemGet)
    inst:ListenForEvent("itemlose", OnItemLose)
end)

--重新计算移速倍率
function Boat:UpdateSpeedMult()
    local c = self.inst.components.container
    if not c then return end

    local speed_mult = 1
    for i = 1, c.numslots do
        local item = c.slots[i]
        if item ~= nil then
            speed_mult = speed_mult * item.components.shipwreckedboatparts.speed_mult
        end
    end

    self.inst.components.equippable.walkspeedmult = speed_mult
end

local function SpawnFakeBoat(inst)
    local b = SpawnPrefab(inst.prefab .. "_fake")
    b.Transform:SetPosition(0, 0, 0)
    b.components.container_proxy:SetMaster(inst)
    b.components.container_proxy:SetCanBeOpened(true)
    b.boat = inst
    return b
end

--- 玩家上船（或者说被装备的时候）
function Boat:OnPlayerMounted(player)
    self.boatfx = SpawnFakeBoat(self.inst)
    player:AddChild(self.boatfx)

    -- 刷新一下外观
    local c = self.inst.components.container
    if c then
        for i = 1, math.min(2, c.numslots) do
            local item = c.slots[i]
            if item then
                c:RemoveItemBySlot(i)
                c:GiveItem(item, i)
            end
        end
    end

    if self.inst.components.container then
        self.inst.components.container:Open(player)

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
function Boat:OnPlayerDismounted(player)
    if self.boatfx then
        self.boatfx:Remove()
        self.boatfx = nil
    end

    if self.inst.components.container then
        self.inst.components.container:Close(player)

        for i = 1, 2 do
            local item = self.inst.components.container:GetItemInSlot(i)
            local fn = item and item.components.shipwreckedboatparts.onplayerdismountedfn
            if fn then
                fn(item, self.inst, player)
            end
        end
    end
end

return Boat
