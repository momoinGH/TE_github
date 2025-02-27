local Utils = require("tropical_utils/utils")

--下面的文件根据源码调用add_event_server_data实现初始化函数就行了

--特效、建筑
modimport "modmain/lavaarena/event_server/firehits"
modimport "modmain/lavaarena/event_server/weaponsparks"
modimport "modmain/lavaarena/event_server/lavaarena_blooms"
modimport "modmain/lavaarena/event_server/fireball_projectile"
modimport "modmain/lavaarena/event_server/lavaarena_meteor"
modimport "modmain/lavaarena/event_server/damagenumber"
modimport "modmain/lavaarena/event_server/explosivehit"
modimport "modmain/lavaarena/event_server/lavaarena_battlestandard"
modimport "modmain/lavaarena/event_server/lavaarena_boarlord"
modimport "modmain/lavaarena/event_server/lavaarena_crowdstand"
modimport "modmain/lavaarena/event_server/lavaarena_groundlifts"
modimport "modmain/lavaarena/event_server/lavaarena_lootbeacon"
modimport "modmain/lavaarena/event_server/lavaarena_portal"
modimport "modmain/lavaarena/event_server/lavaarena_rhinobuff"
modimport "modmain/lavaarena/event_server/lavaarena_spawner"
modimport "modmain/lavaarena/event_server/sunderarmordebuff"
modimport "modmain/lavaarena/event_server/wathgrithr_bloodlustbuff"

-- 装备
modimport "modmain/lavaarena/event_server/blowdart_lava"
modimport "modmain/lavaarena/event_server/blowdart_lava2"
modimport "modmain/lavaarena/event_server/lavaarena_firebomb"
modimport "modmain/lavaarena/event_server/hammer_mjolnir"
modimport "modmain/lavaarena/event_server/spear_gungnir"
modimport "modmain/lavaarena/event_server/spear_lance"
modimport "modmain/lavaarena/event_server/lavaarena_heavyblade"
modimport "modmain/lavaarena/event_server/lavaarena_lucy"
modimport "modmain/lavaarena/event_server/healingstaff"
modimport "modmain/lavaarena/event_server/fireballstaff"
modimport "modmain/lavaarena/event_server/books_lavaarena"
modimport "modmain/lavaarena/event_server/armor_lavaarena"
modimport "modmain/lavaarena/event_server/hats_lavaarena"

-- 生物
modimport "modmain/lavaarena/event_server/lavaarena_beetletaur"
modimport "modmain/lavaarena/event_server/lavaarena_boaron"
modimport "modmain/lavaarena/event_server/lavaarena_boarrior"
modimport "modmain/lavaarena/event_server/lavaarena_elemental"
modimport "modmain/lavaarena/event_server/lavaarena_rhinodrill"
modimport "modmain/lavaarena/event_server/lavaarena_snapper"
modimport "modmain/lavaarena/event_server/lavaarena_trails"
modimport "modmain/lavaarena/event_server/lavaarena_turtillus"
modimport "modmain/lavaarena/event_server/lavaarena_peghook"


----------------------------------------------------------------------------------------------------

--- 根据装备计算增伤，必须要传入weapon才会计算
local function GetAttackedBefore(self, attacker, damage, weapon, ...)
    local damagetype = weapon and weapon.components.lavaarena_equip and weapon.components.lavaarena_equip.damagetype
    if damagetype and attacker and attacker.components.inventory then
        local mult = 1

        local item = attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        local attack_mult = item and item.components.lavaarena_equip and item.components.lavaarena_equip.attack_mult
        mult = mult * (attack_mult and attack_mult[damagetype] or 1)

        item = attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        attack_mult = item and item.components.lavaarena_equip and item.components.lavaarena_equip.attack_mult
        mult = mult * (attack_mult and attack_mult[damagetype] or 1)

        damage = damage * mult
        return nil, false, { self, attacker, damage, weapon, ... }
    end
end

AddComponentPostInit("combat", function(self, inst)
    Utils.FnDecorator(self, "GetAttacked", GetAttackedBefore)
end)

----------------------------------------------------------------------------------------------------
AddPrefabPostInit("world", function(inst)
    inst:AddComponent("lavaarenamobtracker") --熔炉单位对象记录

    if not TheWorld.ismastersim then return end

    TheWorld.components.tro_tempentitytracker:AddKey("lavaarena_portal")                 --熔炉传送门
    TheWorld.components.tro_tempentitytracker:AddKey("lavaarena_center")                 --角斗容器
    TheWorld.components.tro_tempentitytracker:AddKey("lavaarena_battlestandard_damager") --战旗
    TheWorld.components.tro_tempentitytracker:AddKey("lavaarena_battlestandard_shield")
    TheWorld.components.tro_tempentitytracker:AddKey("lavaarena_battlestandard_heal")
end)

----------------------------------------------------------------------------------------------------
--根据战旗添加buff
local function StartTrackingBefore(self, ent)
    self.count = self.count + 1

    if TheWorld.ismastersim then
        for _, v in ipairs({
            "lavaarena_battlestandard_damager",
            "lavaarena_battlestandard_shield",
            "lavaarena_battlestandard_heal"
        }) do
            local flag = TheWorld.components.tro_tempentitytracker:GetEnts(v)[1]
            if flag then
                ent:AddDebuff(flag.debuffprefab, flag.debuffprefab)
            end
        end
    end
end

local function StopTrackingBefore(self)
    self.count = self.count - 1
end

AddComponentPostInit("lavaarenamobtracker", function(self)
    Utils.FnDecorator(self, "StartTracking", StartTrackingBefore)
    Utils.FnDecorator(self, "StopTracking", StopTrackingBefore)
end)
