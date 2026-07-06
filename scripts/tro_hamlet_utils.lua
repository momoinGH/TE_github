local RoomUtils = require("tropical_utils/room_utils")

--- 是否有老板在看着，如果为false表示玩家可以偷
local function IsTraderWatchingItem(target)
    local x, y, z = target.Transform:GetWorldPosition()
    for i, ent in ipairs(TheSim:FindEntities(x, y, z, RoomUtils.RADIUS, { "shopkeep" })) do
        if not ent:HasTag("sleeping") then
            return true
        end
    end
end

local function GetGoodsInfo(target)
    
    if target:HasTag("cost_one_oinc") then
        -- 货柜
        
    else
        local item = target.replica.container and target.replica.container:GetNumSlots() == 1
            and target.replica.container:GetItemInSlot(1)
        local payitem = item and item:GetDisplayName()
            or target.replica.named and target:GetDisplayName()
            or ""
    end
end


return {
    IsTraderWatchingItem = IsTraderWatchingItem,
    GetGoodsInfo = GetGoodsInfo
}
