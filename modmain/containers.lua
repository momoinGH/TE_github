local containers = require("containers")
local params = containers.params

------ 蜜箱
local antchest_preservation = {
	-- bee = true,
	-- killerbee = true,
	-- honeycomb = true,
	-- beeswax = true,
	honey = true,
	royal_jelly = true,
	nectar_pod = true,
	pollen_item = true,
	medal_withered_royaljelly = true, --能力勋章凋零蜂王浆
}
local function antchestitemtestfn(container, item, slot)
	return antchest_preservation[item.prefab]
end

params.antchest = deepcopy(params.icebox) -- 野生蜜箱
params.antchest.itemtestfn = antchestitemtestfn

params.honeychest = params.antchest
