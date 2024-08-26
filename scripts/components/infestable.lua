--- 可被感染组件，用于哈姆雷特虫群
local Infestable = Class(function(self, inst)
	self.inst = inst
	self.infesters = {}
end)

function Infestable:infest(inst)
	local found = false
	for i, v in ipairs(self.infesters) do
		if v == inst then
			found = true
		end
	end
	if not found then
		table.insert(self.infesters, inst)
	end
end

function Infestable:uninfest(inst)
	for i, v in ipairs(self.infesters) do
		if v == inst then
			table.remove(self.infesters, i)
			break
		end
	end
end

return Infestable
