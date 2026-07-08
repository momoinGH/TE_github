local Messagebottlemanager = Class(function(self, inst)
    self.inst = inst

    -- 是否已经发现这些单位
    self.has_been_found_by = {
        kraken = {},
        octopusking = {},
        sharkittenspawner = {},
        volcano = {}
    }
end)

local function GetRandomEnt(self, userid)
    local prefab_tab = shuffledKeys(self.has_been_found_by)
    for _, prefab in ipairs(prefab_tab) do
        local userids = self.has_been_found_by[prefab]
        if not userids[userid] then
            local ent = TroGetAnyEntByPrefab(prefab)
            if ent then
                return ent
            end
        end
    end
    return nil
end

function Messagebottlemanager:UseMessageBottle(bottle, doer, is_not_from_hermit)
    local ent = GetRandomEnt(self, doer.userid)
    if ent then
        self.has_been_found_by[ent.prefab][doer.userid] = true --下回不再找这个
        return ent:GetPosition()
    end
    return nil --不处理
end

function Messagebottlemanager:OnSave()
    return {
        has_been_found_by = self.has_been_found_by
    }
end

function Messagebottlemanager:OnLoad(data)
    if not data then return end
    self.has_been_found_by = data.has_been_found_by or self.has_been_found_by
end

return Messagebottlemanager
