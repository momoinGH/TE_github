local function oncanshear(self, canshear)
    if canshear then
        self.inst:AddTag("shearable")
    else
        self.inst:RemoveTag("shearable")
    end
end

--- 可以剪
local Shearable = Class(function(self, inst)
    self.inst = inst

    self.product = nil   --产物
    self.product_num = 1 --产物数量
    self.drop = true     --是直接掉落还是放入物品栏
    self.canshear = true --是否可以剪

    self.onshear = nil
end, nil, {
    canshear = oncanshear
})

function Shearable:SetProduct(product, product_num, drop)
    self.product = product
    self.product_num = product_num or 2
    if self.drop ~= nil then
        self.drop = drop
    end
end

-- 剪，这里就不考虑工作效率了
function Shearable:Shear(shearer)
    if self.product then
        for _ = 1, self.product_num do
            local product = SpawnPrefab(self.product)
            if product.components.inventoryitem then
                if not self.drop and shearer and shearer.components.inventory then
                    shearer.components.inventory:GiveItem(product) --如果失败会从玩家身上掉出来
                else
                    product.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
                    product.components.inventoryitem:OnDropped()
                end
            end
        end
    end

    if self.onshear then
        self.onshear(self.inst, shearer)
    end
end

return Shearable
