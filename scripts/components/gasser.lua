local Gasser = Class(function(self, inst)
	self.inst = inst
end)


function Gasser:CollectPointActions(doer, pos, actions, right)
	if right then
		table.insert(actions, ACTIONS.GAS)
	end
end

local function SpawnGas(pt)
	local cloud = SpawnPrefab("gascloud")
	cloud.spawn(cloud)
	cloud.Transform:SetPosition(pt.x, pt.y, pt.z)
end

function Gasser:Gas(pt)
	SpawnGas(pt)
end

return Gasser
