local Utils = require("tropical_utils/utils")

-- 对于熔炉、暴食里的一些预制件没有主机代码，但是有通用代码，其实只需要实现对应的主机代码就行了，没必要重新定义一个预制件
-- 好像这个方法没有AddPrefabPostInit方便和自由o(￣ヘ￣o＃).
local MyEventServerFiles = {}

Utils.FnDecorator(GLOBAL, "requireeventfile", nil, function(retTab, fullpath)
    for k, v in pairs(MyEventServerFiles[fullpath] or {}) do
        retTab[1][k] = v --替换成我实现的初始化函数
    end

    return retTab
end)

function add_event_server_data(eventname, path, data)
    local fullpath = eventname .. "_event_server/" .. path
    MyEventServerFiles[fullpath] = data
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", inst.symbol_build, inst.symbol_build)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function OnDischarged(inst)
    inst.components.aoetargeting:SetEnabled(false)
end

local function OnCharged(inst)
    inst.components.aoetargeting:SetEnabled(true)
end

local function OnAttack(inst, attacker, target)
    if target then
        SpawnPrefab(inst.weaponspark):Setup(attacker, target)
    end
end

---初始化有技能的熔炉武器
---@param inst Entity
---@param symbol_build string|nil
---@param damage number|nil
---@param weaponspark string|nil
function InitLavaarenaWeapon(inst, symbol_build, damage, weaponspark)
    inst:AddComponent("aoespell")

    inst:AddComponent("equippable")
    if symbol_build then
        inst.symbol_build = symbol_build
        inst.components.equippable:SetOnEquip(OnEquip)
        inst.components.equippable:SetOnUnequip(OnUnequip)
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("weapon")
    if damage then
        inst.components.weapon:SetDamage(damage)
    end
    if weaponspark then
        inst.weaponspark = weaponspark
        inst.components.weapon:SetOnAttack(OnAttack)
    end


    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
    inst.components.rechargeable:SetOnChargedFn(OnCharged)
end

----------------------------------------------------------------------------------------------------

--下面的文件根据源码调用add_event_server_data实现初始化函数就行了

modimport "modmain/event_server/firehits"
modimport "modmain/event_server/weaponsparks"
modimport "modmain/event_server/lavaarena_blooms"
modimport "modmain/event_server/fireball_projectile"


modimport "modmain/event_server/blowdart_lava"
modimport "modmain/event_server/blowdart_lava2"
modimport "modmain/event_server/lavaarena_firebomb"
modimport "modmain/event_server/hammer_mjolnir"
modimport "modmain/event_server/spear_gungnir"
modimport "modmain/event_server/spear_lance"
modimport "modmain/event_server/lavaarena_heavyblade"
modimport "modmain/event_server/lavaarena_lucy"
modimport "modmain/event_server/healingstaff"


modimport "modmain/event_server/fireballstaff"
modimport "modmain/event_server/books_lavaarena"
