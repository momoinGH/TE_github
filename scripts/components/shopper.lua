local InteriorSpawnerUtils = require("interiorspawnerutils")

--- 玩家购买商品，针对货架或柜子里的商品
local Shopper = Class(function(self, inst)
	self.inst = inst
end)

--- 是否有老板在看着，如果为false表示玩家可以偷
function Shopper:IsWatching(target)
	local x, y, z = target.Transform:GetWorldPosition()
	for i, ent in ipairs(TheSim:FindEntities(x, y, z, InteriorSpawnerUtils.RADIUS, { "shopkeep" })) do
		if not ent:HasTag("sleeping") and (not ent.components.sleeper or not ent.components.sleeper:IsAsleep()) then
			return true
		end
	end
end

--- 是否有足够的钱购买
function Shopper:CanPayFor(target)
	local inventory = self.inst.components.inventory

	if target.components.shopped then
		--货架
		local prefab_wanted = target.components.shopped.costprefab
		assert(prefab_wanted) --默认一定存在

		if prefab_wanted == "oinc" then
			if inventory:GetMoney() >= target.cost then
				return true
			end
		else
			if inventory:FindItem(function(look) return look.prefab == prefab_wanted end) then
				return true
			end
		end
	elseif target:HasTag("cost_one_oinc") then
		--柜子
		if inventory:GetMoney() >= 1 then
			return true
		end
	end

	return false
end

function Shopper:BoughtItem(target)
	local item = target.components.shelfer and target.components.shelfer:GiveGift()
		or target.components.shopped and target.components.shopped:BuyGoods(self.inst)
	if item then
		self.inst.components.inventory:GiveItem(item)
	end
end

--- 购买商品
function Shopper:PayFor(target)
	local inventory = self.inst.components.inventory

	if target.components.shopped then
		-- 货架
		local prefab_wanted = target.components.shopped.costprefab
		if prefab_wanted == "oinc" then
			inventory:PayMoney(target.components.shopped.cost)
		else
			inventory:ConsumeByName(prefab_wanted, 1)
		end
		self:BoughtItem(target)
	elseif target:HasTag("cost_one_oinc") then
		--柜子
		inventory:PayMoney(1)
	end
end

--- 偷取货架上商品
function Shopper:Take(target)
	self:BoughtItem(target)
end

return Shopper
