local Quagmire_Installations = Class(function(self, inst)
    self.inst = inst
    self.station = nil

    self.oninstallfn = nil
end)

function Quagmire_Installations:IsEnabled()
    return self.station == nil
end

function Quagmire_Installations:Install(station)
    if self.station ~= nil then
        return
    end

    self.station = station
    self.inst:RemoveTag("installations")

    self.inst:AddChild(station) -- station就不会在自动保存了，需要加载时手动保存和重新生成
    station.entity:SetParent(self.inst.entity)
    station.Transform:SetPosition(0, 0, 0)

    if self.oninstallfn ~= nil then
        self.oninstallfn(self.inst, station)
    end

    if station.oninstallfn ~= nil then
        station.oninstallfn(station, self.inst)
    end
end

function Quagmire_Installations:OnSave()
    return {
        station_data = self.station_data
            or self.station and self.station:IsValid() and self.station:GetSaveRecord()
            or nil
    }
end

function Quagmire_Installations:OnLoad(data)
    if not data then return end

    if data.station_data then
        self.station_data = data.station_data
        self.inst:DoTaskInTime(0, function()
            local station = SpawnSaveRecord(self.station_data)
            self.station_data = nil
            self:Install(station)
        end)
    end
end

return Quagmire_Installations
