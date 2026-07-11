local TRADER = require("prefabs/pig_trades_defs").TRADER

--- 哈姆雷特猪镇猪人使用，控制它们收什么物品
local Economy = Class(function(self, inst)
	self.inst = inst
	self.cities = {}

	self.inst:WatchWorldState("isday", function() self:processdelays() end)

	self.inst:DoTaskInTime(0.1, function()
		-- Fixup for beta glitch when a world was saved without a city on it.
		if not self.cities or #self.cities < 1 then
			self:AddCity(1)
			self:AddCity(2)
		end
	end)
end)

function Economy:GetTradeItems(traderprefab)
	if TRADER[traderprefab] then
		return TRADER[traderprefab].items
	end
end

function Economy:GetTradeItemDesc(traderprefab)
	if not TRADER[traderprefab] then
		return nil
	end
	return TRADER[traderprefab].desc
end

-- 下次交易需要的时间
function Economy:GetDelay(traderprefab, city, inst)
	return self.cities[city][traderprefab].GUIDS[inst.GUID] or 0
end

-- 交易，给予奖励并开始冷却
function Economy:MakeTrade(traderprefab, city, inst)
	self.cities[city][traderprefab].GUIDS[inst.GUID] = TRADER[traderprefab].reset
	return TRADER[traderprefab].reward, TRADER[traderprefab].rewardqty
end

function Economy:processdelays()
	for c, city in ipairs(self.cities) do
		for i, trader in pairs(city) do
			for guid, data in pairs(trader.GUIDS) do
				if data > 0 then
					data = data - 1
					trader.GUIDS[guid] = data
				end
			end
		end
	end
end

function Economy:AddCity(city)
	self.cities[city] = deepcopy(TRADER)

	for i, item in pairs(self.cities[city]) do
		item.GUIDS = {}
	end
end

function Economy:OnSave()
	local refs = {}
	local data = {}
	data.cities = self.cities

	for city, d in pairs(self.cities) do
		for item, itemdata in pairs(d) do
			for guid, guiddata in pairs(itemdata.GUIDS) do
				table.insert(refs, guid)
			end
		end
	end

	return data, refs
end

function Economy:OnLoad(data)
	if data and data.cities then
		self.cities = data.cities
	end
end

function Economy:LoadPostPass(ents)
	for city, data in pairs(self.cities) do
		for item, itemdata in pairs(data) do
			local newguids = {}
			for guid, guiddata in pairs(itemdata.GUIDS) do
				local child = ents[guid]
				if child then
					newguids[child.entity.GUID] = guiddata
				end
			end
			itemdata.GUIDS = newguids
		end
	end
end

return Economy
