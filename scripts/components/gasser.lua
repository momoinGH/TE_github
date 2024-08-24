local Gasser = Class(function(self, inst)
	self.inst = inst
end)

function Gasser:Gas(pt)
	local cloud = SpawnPrefab("gascloud")
	cloud.spawn(cloud)
	cloud.Transform:SetPosition(pt.x, pt.y, pt.z)
end

return Gasser
