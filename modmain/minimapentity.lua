local Links = {}
local function _GetEntity(anim)
    return anim ~= nil and Links[anim]
end

local function _NewLink(anim, inst)
    if inst:IsValid() then
        Links[anim] = inst
        inst:ListenForEvent("onremove", function() Links[anim] = nil end)
    end
end

local old_add = Entity.AddMiniMapEntity
Entity.AddMiniMapEntity = function(ent, ...)
    local inst = Ents[ent:GetGUID()] -- Get real instant
    if _GetEntity(inst and inst.MiniMapEntity) then
        Links[inst.MiniMapEntity] = nil
    end
    local minimapentity = old_add(ent, ...)
    _NewLink(minimapentity, inst)
    return minimapentity
end

local OldSetIcon = MiniMapEntity.SetIcon
function MiniMapEntity:SetIcon(icon, ...)
    local inst = _GetEntity(self)
    if inst then
        inst.tro_minimap_icon = icon --主要是为了添加这个字段，获取小地图图标，不过这个没有同步效果，只能拿到客户端设置的值
    end
    return OldSetIcon(self, icon, ...)
end

----------------------------------------------------------------------------------------------------

