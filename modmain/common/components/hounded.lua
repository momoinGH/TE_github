-- 区域刷怪逻辑
AddComponentPostInit("hounded", function(self, inst)
    local _spawndata = Hooks.GetUpValue(self.SetSpawnData, "_spawndata")
    local _SummonSpawn = Hooks.GetUpValue(self.SummonSpawn, "SummonSpawn")
    local _GetSpawnPoint = Hooks.GetUpValue(_SummonSpawn, "GetSpawnPoint")
    local _SPAWN_DIST = Hooks.GetUpValue(_GetSpawnPoint, "SPAWN_DIST")
    local _activeplayers = Hooks.GetUpValue(self.OnUpdate, "_activeplayers")
    local _targetableplayers = Hooks.GetUpValue(self.OnUpdate, "_targetableplayers")
    local CheckForLocationImmunity = Hooks.GetUpValue(self.OnUpdate, "CheckForLocationImmunity")
    local _delayedplayerspawninfo = Hooks.GetUpValue(self.OnUpdate, "_delayedplayerspawninfo")

    local function SummonSpawn(pt, upgrade, radius_override)
        local x, y, z = pt:Get()
        -- local spawndat = deepcopy(_spawndata)

        if TheWorld:HasTag("cave") then
            _spawndata.base_prefab = "worm"
            _spawndata.winter_prefab = "worm"
            _spawndata.summer_prefab = "worm"
            _spawndata.upgrade_spawn = "worm_boss"
        elseif TheWorld.Map:IsHamletAreaAtPoint(x, 0, z) then
            _spawndata.base_prefab = "circlingbat"
            _spawndata.winter_prefab = "circlingbat"
            _spawndata.summer_prefab = "circlingbat"
            _spawndata.upgrade_spawn = " "
        elseif TheWorld.Map:IsShipwreckedAreaAtPoint(x, 0, z) then
            _spawndata.base_prefab = "crocodog"
            _spawndata.winter_prefab = "watercrocodog"
            _spawndata.summer_prefab = "poisoncrocodog"
            _spawndata.upgrade_spawn = " "
        else
            _spawndata.base_prefab = "hound"
            _spawndata.winter_prefab = "icehound"
            _spawndata.summer_prefab = "firehound"
            _spawndata.upgrade_spawn = "warglet"
        end

        if _spawndata.base_prefab == "circlingbat" then
            _SPAWN_DIST = 4
        else
            _SPAWN_DIST = 30
        end

        Hooks.SetUpvalue(_GetSpawnPoint, "SPAWN_DIST", _SPAWN_DIST)
        -- Hooks.SetUpvalue(self.SetSpawnData, "_spawndata", spawndat)
        return _SummonSpawn(pt, upgrade, radius_override)
    end

    Hooks.SetUpvalue(self.SummonSpawn, "SummonSpawn", SummonSpawn)

    -- 如果玩家在虚空小房子，则不生成猎犬
    Hooks.FnDecorator(self, "OnUpdate", function(self)
        for i, player in ipairs(_activeplayers) do
            if not _delayedplayerspawninfo[player] then
                if TheWorld.Map:TroIsWorldOut(player.Transform:GetWorldPosition()) then
                    _targetableplayers[player.GUID] = "arena"
                elseif _targetableplayers[player.GUID] == "arena" then
                    _targetableplayers[player.GUID] = nil
                    CheckForLocationImmunity(player)
                end
            end
        end
    end)
end)
