local Utils = require("tropical_utils/utils")

-- TODO 整个文件为shelf服务，看看能不能优化掉，至少这些代码不要写在inventoryitem
AddComponentPostInit("inventoryitem", function(self)
    Utils.FnDecorator(self, "OnPickup", function(self)
        if self.inst.bookshelf then
            self:TakeOffShelf()
        end
    end)

    function self:TakeOffShelf()
        local shelf_slot = SpawnPrefab("shelf_slot")
        shelf_slot.components.inventoryitem:PutOnShelf(self.inst.bookshelf, self.inst.bookshelfslot)
        shelf_slot.components.shelfer:SetShelf(self.inst.bookshelf, self.inst.bookshelfslot)

        self.inst:RemoveTag("bookshelfed")
        self.inst.bookshelfslot = nil
        self.inst.bookshelf = nil
        self.inst.follower:FollowSymbol(0, "dumb", 0, 0, 0)
        if self.inst.Physics then
            self.inst.Physics:SetActive(true)
        end
    end

    function self:PutOnShelf(shelf, slot)
        self.inst:AddTag("bookshelfed")
        self.inst.bookshelfslot = slot
        self.inst.bookshelf = shelf
        if self.inst.Physics then
            self.inst.Physics:SetActive(false)
        end
        local follower = self.inst.entity:AddFollower()
        follower:FollowSymbol(shelf.GUID, slot, 10, 0, 0.6)
        self.inst.follower = follower
    end

    function self:OnSave()
        local data = {}
        local refs = {}

        if self.inst:HasTag("bookshelfed") and self.inst.bookshelf then
            data.bookshelfGUID = self.inst.bookshelf.GUID
            data.bookshelfslot = self.inst.bookshelfslot
            table.insert(refs, self.inst.bookshelf.GUID)
        end

        if self.canbepickedup then
            data.canbepickedup = self.canbepickedup
        end

        if self.inst.onshelf then
            data.onshelf = self.inst.onshelf.GUID
            table.insert(refs, self.inst.onshelf.GUID)
        end

        return data, refs
    end

    function self:OnLoad(data)
        if data.canbepickedup then
            self.canbepickedup = data.canbepickedup
        end
    end

    function self:LoadPostPass(newents, data)
        if data and data.bookshelfGUID then
            if newents[data.bookshelfGUID] then
                local bookshelf = newents[data.bookshelfGUID].entity
                self:PutOnShelf(bookshelf, data.bookshelfslot)
            end
        end
        if data and data.onshelf then
            if newents[data.onshelf] and newents[data.onshelf].entity:IsValid() then
                self.inst.onshelf = newents[data.onshelf].entity
                -- fixup for items that misremembered they were on a shelf.
                self.inst:DoTaskInTime(1, function()
                    if self.inst.onshelf then
                        local shelfitem = self.inst.onshelf and self.inst.onshelf.components and
                            self.inst.onshelf.components.shelfer and self.inst.onshelf.components.shelfer:GetGift()
                        if self.inst ~= shelfitem then
                            -- we thought we were on a shelf. Alas, we were not
                            self.inst.onshelf = nil
                        end
                    end
                end)
            end
        end
    end
end)
