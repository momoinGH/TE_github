---@diagnostic disable: duplicate-set-field

local Drownable = require "components/drownable"
local Util = require "tools/utils"

Util.FnDecorator(Drownable, "IsOverWater", nil, function(rets, self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local valid = not TileGroupManager:IsInvalidTile(TheWorld.Map:GetTileAtPoint(x, y, z)) -- allow players to be out of bounds so that a number of mods will still work
    if rets and #rets > 0 then
        rets[1] = valid and rets[1]
    else
        rets = { valid }
    end
    return rets
end)

Util.FnDecorator(Drownable, "ShouldDrown", function(self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local entities = TheSim:FindEntities(x, y, z, 30, { "blows_air" })
    for i, v in ipairs(entities) do
        if v then return { false }, true end
    end

    entities = TheSim:FindEntities(x, y, z, 1, { "boat" })
    for i, v in ipairs(entities) do
        if v then return { false }, true end
    end
end)

function Drownable:OnSave()
    return {
        enabled = self.enabled
    }
end

function Drownable:OnLoad(data)
    if data and data.enabled ~= nil then
        self.enabled = data.enabled
    end
end
