local cooking = require("gorge_cooking")
local CoinLogic = require("coin_logic")
local COIN_VALUES = require("gorge_coin_values")

local COIN_RANGE = 2.5

local function DropCoins(inst, coins, pos)
	for id, count in ipairs(coins) do
		if count > 0 then
			for i = 1, count do
				inst:DoTaskInTime(i * id / 10, function()
					local coin = SpawnPrefab("quagmire_coin" .. id)

					local angle = math.pi * 2 * math.random()
					local range = math.max(COIN_RANGE * math.random(), 1)
					coin.Transform:SetPosition(
						pos.x + math.cos(angle) * range,
						0,
						pos.z + math.sin(angle) * range
					)

					-- 播放从天而降的动画
					coin:Fall()
				end)
			end
		end
	end
end

local Quagmire_Altar = Class(function(self, inst)
	self.inst = inst

	inst:AddTag("quagmire_altar")

	self.current_craving = nil
	self.round = 0
end)

-- 生成下一个渴望
function Quagmire_Altar:GenerateNextCraving()
	self.round = self.round + 1
	-- 简单的渴望轮换系统
	local cravings = { "meat", "veggie", "soup", "fish", "bread", "sweet", "snack", "cheese", "pasta" }
	self.current_craving = cravings[((self.round - 1) % #cravings) + 1]
	self.inst:PushEvent("ms_cravingchanged", { current = self.current_craving })
end

-- 获取当前渴望
function Quagmire_Altar:GetCraving()
	return self.current_craving
end

function Quagmire_Altar:AcceptFoodTribute(player, food)
	if food.components.quagmire_portalkey then
		TheWorld:PushEvent("quagmire_win")
		food:Remove()
		return true
	end

	if not food:HasTag("preparedfood") then
		return false, "NOTDISH"
		-- elseif self.inst.sg:HasStateTag("full") then
		-- 	return false, "SLOTFULL"
	end

	-- 获取食物ID (quagmire_food_042 -> 42)
	local food_id = tonumber(string.match(food.prefab, "(%d+)$"))

	-- 获取食物渴望
	local cravings = cooking.GetCravingsByRecipe(food.prefab)

	-- 判断是否银盘
	local silverdish = food:HasTag("replated_plate") or food:HasTag("replated_bowl")

	-- 计算奖励
	local coins, appraisal_data = CoinLogic.CalculateReward(
		COIN_VALUES[food_id] or { 10, 1 }, -- coins_data
		food.components.perishable:IsStale(), -- stale
		food.components.perishable:IsSpoiled(), -- spoiled
		self.current_craving,             -- current_craving
		cravings,                         -- cravings
		silverdish                        -- plated
	)

	-- 推送事件
	self.inst:PushEvent("craving_placed", {
		food = {
			chief = food.chief,
			doer = player,
			product = food.prefab,
			dish = food.basedish,
			silverdish = silverdish,
			stale = food.components.perishable:IsStale(),
			spoiled = food.components.perishable:IsSpoiled(),
			salted = food:HasTag("quagmire_salted"),
			recipe = food.recipe or {},
			coins = coins,
			matched = true,
		}
	})

	-- 发放奖励
	local pos = self.inst:GetPosition()
	self.inst:DoTaskInTime(0.2, function()
		DropCoins(self.inst, coins, pos)
	end)

	-- 撒盐额外奖励
	if food:HasTag("quagmire_salted") then
		self.inst:DoTaskInTime(0.5, function()
			local bonus_coin = SpawnPrefab("quagmire_coin1")
			local angle = math.pi * 2 * math.random()
			local range = math.max(COIN_RANGE * math.random(), 1)
			bonus_coin.Transform:SetPosition(
				pos.x + math.cos(angle) * range,
				0,
				pos.z + math.sin(angle) * range
			)
			-- 播放从天而降的动画
			bonus_coin:Fall()
		end)
	end

	-- 生成下一个渴望
	self:GenerateNextCraving()

	-- 删除食物
	if food.components.stackable then
		food = food.components.stackable:Get(1)
	end
	food:Remove()

	return true
end

return Quagmire_Altar
