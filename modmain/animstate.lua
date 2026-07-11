---@author: Runar 2024-11-13 16:36:57
-- AnimState 增强 Ver 1.11.22
-- 滤镜与色彩空间封装

-- 对animstate和inst进行映射，可以在AnimsState里可以拿到自己的inst
local Links = {} -- key = AnimState, value = Entity
local function _GetEntity(anim)
    return anim ~= nil and Links[anim]
end

local function _NewLink(anim, inst)
    if inst:IsValid() then
        Links[anim] = inst
        inst:ListenForEvent("onremove", function() Links[anim] = nil end)
    end
end

local old_add = Entity.AddAnimState
Entity.AddAnimState = function(ent, ...)
    local inst = Ents[ent:GetGUID()] -- Get real instant
    if _GetEntity(inst and inst.AnimState) then
        Links[inst.AnimState] = nil
    end
    local anim = old_add(ent, ...)
    _NewLink(anim, inst)
    return anim
end

----------------------------------------------------------------------------------------------------


local filters = {
    generic = function(animstate)
        animstate:SetAddColour(0, 0, 0, 0)
        animstate:SetMultColour(1, 1, 1, 1)
        animstate:SetHSV()
    end,
    withered = function(animstate) animstate:SetHSV(.3, .4, .5) end,
    shadowed = function(animstate) animstate:SetMultColour(0, 0, 0, .6) end,
    green = function(animstate)
        animstate:SetHSV(30 / 255 + math.random() * 0.05, .75 + math.random() * 0.05, .75 + math.random() * 0.05)
    end,
}

--[[ animations[animname] =
table{[1]FrameAction:function(self, frame),
      [2]TotalFrame:number,
      [3]Interval:nil|number|function(frame)}
]]
local animations = {
    shake = { function(animstate, frame)
        animstate:SetScale(1 - .1 * math.sin(PI / 2 * frame + PI / 8), 1 + .1 * math.sin(PI / 2 * frame + PI / 8))
    end, 3 },
}

---AnimState:SetHSV
---@param hue number @Hue(0~1)
---@param saturation number @Saturation(0~1)
---@param lightness number @Value(0~1)
function AnimState:SetHSV(hue, saturation, lightness)
    self:SetHue(hue or 0)
    self:SetSaturation(saturation or 1)
    self:SetBrightness(lightness or 1)
end

---AnimState:SetFilter
---@param filter string|nil @filter name
function AnimState:SetFilter(filter, ...)
    assert(filter == nil or type(filter) == "string",
        string.format("AnimState Extension: filtername '%s' is not a string!\n", filter))
    if filters[filter] then filters[filter](self, ...) end
end

---AnimState:FilterList
---@return string[] @filter names
function AnimState:FilterList()
    local list = {}
    for filter in pairs(filters) do table.insert(list, filter) end
    return list
end

function AnimState:PlayExtendAnim(animname)
    assert(animname == nil or type(animname) == "string",
        string.format("AnimState Extension: animname '%s' is not a string!\n", animname))
    if not animname or not animations[animname] then return end
    local inst = CreateEntity()
    inst._animTask = inst:StartThread(function()
        for frame = 0, animations[animname][2] do
            animations[animname][1](self, frame)
            Sleep(FunctionOrValue(animations[animname][3], frame) or FRAMES)
        end
        self:SetScale(1, 1)
        inst:Remove()
    end)
end

local _SetOceanBlendParams = AnimState.SetOceanBlendParams
function AnimState:SetOceanBlendParams(...)
    if TUNING.tropical.ocean_style == "tropical" then return end
    return _SetOceanBlendParams(self, ...)
end

local _SetLayer = AnimState.SetLayer
function AnimState:SetLayer(layer, ...)
    if TUNING.tropical.ocean_style == "tropical" and layer <= LAYER_BELOW_GROUND then
        layer = LAYER_GROUND -- TODO: if sorting issues occur use ground and increase the sort
        self:SetSortOrder(5)
    end
    return _SetLayer(self, layer, ...)
end

----------------------------------------------------------------------------------------------------

local overridesymbol_maps = {}

local OldOverrideSymbol = AnimState.OverrideSymbol
function AnimState:OverrideSymbol(symbol, swap_build, swap_symbol, ...)
    local inst = _GetEntity(self)
    local get_fn = inst and inst.prefab and overridesymbol_maps[inst.prefab] and overridesymbol_maps[inst.prefab][symbol]
    if get_fn then
        swap_build, swap_symbol = get_fn(inst, swap_build, swap_symbol) --重新映射
    end
    return OldOverrideSymbol(self, symbol, swap_build, swap_symbol, ...)
end

---对指定的OverrideSymbol参数进行重新映射，可针对每个预制件每个symbol映射到新的动画文件
---@param prefab_name string
---@param need_symbol string
---@param get_fn function 参数为(inst, swap_build, swap_symbol)，返回值为swap_build, swap_symbol
function _G.TroRemapOverrideSymbol(prefab_name, need_symbol, get_fn)
    assert(type(prefab_name) == "string" and type(need_symbol) == "string" and type(get_fn) == "function")
    overridesymbol_maps[prefab_name] = overridesymbol_maps[prefab_name] or {}
    overridesymbol_maps[prefab_name][need_symbol] = get_fn
end

local animation_maps = {}

local function AnimationHook(self, anim, is_loop, ...)
    local inst = _GetEntity(self)
    local val = inst and inst.prefab and animation_maps[inst.prefab] and (animation_maps[inst.prefab][anim] or animation_maps[inst.prefab]._)
    if val then
        if type(val) == "function" then
            anim, is_loop = val(inst, anim, is_loop, ...)
        else
            anim = val
        end
    end
    return anim, is_loop
end

local OldPlayAnimation = AnimState.PlayAnimation
function AnimState:PlayAnimation(anim, is_loop, ...)
    anim, is_loop = AnimationHook(self, anim, is_loop, ...)
    return OldPlayAnimation(self, anim, is_loop, ...)
end

local OldPushAnimation = AnimState.PushAnimation
function AnimState:PushAnimation(anim, is_loop, ...)
    anim, is_loop = AnimationHook(self, anim, is_loop, ...)
    return OldPushAnimation(self, anim, is_loop, ...)
end

---重新映射某个预制件的动画
---@param prefab_name string
---@param anim string|nil 要重映射的动画名，如果为空则表示对所有动画修改
---@param val string|function 新的动画名，或者一个返回anim和is_loop的函数
function _G.TroRemapAnimation(prefab_name, anim, val)
    animation_maps[prefab_name] = animation_maps[prefab_name] or {}
    if not anim then
        anim = "_" --对所有动画修改
    end
    animation_maps[prefab_name][anim] = val
end

if troisdev then
    -- 调用SetBuild时检查是否有同名动画文件，用来解决动画不显示又不知道哪里调用的问题
    -- 并不是很准确，因为build不一定非得和压缩包名一样，所以可以偶尔检查一次
    -- TUNING.TEST_CHECK_ANIM_HAS_BUILD = true
    local memoizedFilePaths = Hooks.GetUpValue(resolvefilepath, "memoizedFilePaths")
    local OldSetBuild = AnimState.SetBuild
    function AnimState:SetBuild(build, ...)
        local inst = _GetEntity(self)
        if inst and
            not memoizedFilePaths["anim/" .. build .. ".zip"]
            and TUNING.TEST_CHECK_ANIM_HAS_BUILD --在控制台设置这个值为true就开始打印
        then
            TroErrorHandle(string.trofmt("{} 调用了SetBuild但是没有 {}.zip 动画文件，注意检查动画是否正常显示", inst, build), false, "warn")
        end
        return OldSetBuild(self, build, ...)
    end
end
