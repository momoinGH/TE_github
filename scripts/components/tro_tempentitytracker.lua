local KEY = "_tro_tempentitytracker_key"

--- 用于记录一些不需要保存但是预制件创建时需要获取的对象，常用于绑定两个传送门
local TempEntityTracker = Class(function(self, inst)
    self.inst = inst

    self.ents = {}
end)

---记录该预制件的生成，如果这个key是预制件名则在对应预制件生成时自动记录，否则就需要自己手动记录
---@param key string 预制件名
function TempEntityTracker:AddKey(key)
    self.ents[key] = {}
end

function TempEntityTracker:KeyExists(key)
    return self.ents[key] ~= nil
end

function TempEntityTracker:GetEnts(key)
    local ents = {}
    for k, _ in pairs(self.ents[key]) do
        table.insert(ents, k)
    end
    return ents
end

function TempEntityTracker:RemoveEnt(ent)
    self.ents[ent[KEY]][ent] = nil
end

local function OnRemove(ent)
    TheWorld.components.tro_tempentitytracker:RemoveEnt(ent)
end

---当对象生成时记录该对象
---@param ent Entity
---@param key string|nil 如果为空默认对象的预制件名
function TempEntityTracker:OnEntSpawned(ent, key)
    key = key or ent.prefab
    self.ents[key][ent] = true
    ent[KEY] = key
    ent:ListenForEvent("onremove", OnRemove)
end

return TempEntityTracker
