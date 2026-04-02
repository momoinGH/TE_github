-- 添加标签，这个标签会保存和加载
-- 类似有add_component_if_missing标记的组件，不过后者是自动添加组件的
function EntityScript:TroAddSaveTag(tag)
    self._tro_save_tags = self._tro_save_tags or {}
    self._tro_save_tags[tag] = true
    self:AddTag(tag)
end

local OldRemoveTag = EntityScript.RemoveTag
function EntityScript:RemoveTag(tag, ...)
    if tag and self._tro_save_tags and self._tro_save_tags[tag] then
        self._tro_save_tags[tag] = nil
    end
    return OldRemoveTag(self, tag, ...)
end

local OldGetPersistData = EntityScript.GetPersistData
function EntityScript:GetPersistData(...)
    local data, references = OldGetPersistData(self, ...)

    if self._tro_save_tags then
        data = data or {}
        data.tro_save_tags = {}
        for tag, _ in pairs(self._tro_save_tags) do
            if self:HasTag(tag) then
                table.insert(data.tro_save_tags, tag)
            end
        end
    end

    return data, references
end

local OldSetPersistData = EntityScript.SetPersistData
function EntityScript:SetPersistData(data, ...)
    if data and data.tro_save_tags then
        for _, tag in ipairs(data.tro_save_tags) do
            self:TroAddSaveTag(tag)
        end
    end
    return OldSetPersistData(self, data, ...)
end
