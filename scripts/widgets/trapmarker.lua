local Widget = require "widgets/widget"

local TrapMarker = Class(Widget, function(self, owner)
     self.owner = owner
     Widget._ctor(self, "TrapMarker")
     self:SetClickable(false)
     self:Hide()
     
     self.markers = {}
end)

function TrapMarker:ShowMarker()
     self:ClearMarker()
     self:StartUpdating()
     self:Show()
end

function TrapMarker:HideMarker()
     self:ClearMarker()
     self:StopUpdating()
     self:Hide()
end

function TrapMarker:ClearMarker()
     for t,m in pairs(self.markers) do
          m:Remove()
          self.markers[t] = nil
     end
end

function TrapMarker:OnUpdate(dt)
     if TheNet:IsServerPaused() then return end
     
     local old_markers = {}
     for t,m in pairs(self.markers) do old_markers[t] = true end

     local x, y, z = ThePlayer.Transform:GetWorldPosition()
     local traps = TheSim:FindEntities(x, y, z, TUNING.SCAN_DISTANCE, {"tentacle", "invisible"})

     for i,t in ipairs(traps) do
          if self.markers[t] == nil then
               local fx = SpawnPrefab("hiddendanger_fx")
               fx.Transform:SetPosition(t.Transform:GetWorldPosition())
               self.markers[t] = fx
          else
               old_markers[t] = false
          end
     end

     for t,m in pairs(self.markers) do
          if not t:HasTag("invisible") then
               ErodeAway(m, 0.5)
               self.markers[t] = nil
          elseif old_markers[t] == true then
               m:Remove()
               self.markers[t] = nil
          end
     end
end

return TrapMarker
