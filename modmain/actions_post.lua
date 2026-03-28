-- Runar: 未定义的优先级，没有的话碎布加燃料会有问题
ACTIONS.ADDFUEL.priority = 1
ACTIONS.GIVE.priority    = 0

Hooks.FnDecorator(ACTIONS.JUMPIN, "strfn", function(act)
    if act.target ~= nil then
        if act.target:HasTag("interior_houseexit") then
            return { "LEAVE" }, true
        elseif act.target:HasTag("interior_door") or act.target.prefab == "lavaarena_portal" then
            return { "ENTER" }, true
        elseif act.target:HasTag("stairs") then
            return { "USE" }, true
        end
    end
end)

Hooks.FnDecorator(ACTIONS.MANUALEXTINGUISH, "fn", function(act)
    if act.doer:HasTag("extinguisher") then
        if act.target.components.burnable and act.target.components.burnable:IsBurning() then
            act.target.components.burnable:Extinguish()
            return { true }, true
        end
    elseif act.target.components.sentientball then
        act.target.components.burnable:Extinguish()
        -- damage player?
        return { true }, true
    end
end)

-- 如果打开的箱子在水里就增加点交互距离
ACTIONS.RUMMAGE.extra_arrive_dist = function(doer, dest)
    if dest ~= nil then
        local target_x, target_y, target_z = dest:GetPoint()
        local is_on_water = TheWorld.Map:IsOceanTileAtPoint(target_x, 0, target_z) and
            not TheWorld.Map:IsPassableAtPoint(target_x, 0, target_z)
        if is_on_water then
            return 2
        end
    end
    return 0
end


Hooks.FnDecorator(ACTIONS.INSTALL, "fn", function(act)
    if act.invobject ~= nil and act.target ~= nil then
        if act.invobject.components.installable ~= nil
            and act.target.components.installations ~= nil
            and act.target.components.installations:CanInstall(act.invobject.components.installable.prefab)
            and act.invobject.components.installable:DoInstall(act.target) then
            act.invobject:Remove()
            return { true }, true
        end
    end
end)


-- 添加猪镇和暴食地皮挖起的特殊掉落
local SpeciaTileDrop =
{
    [WORLD_TILES.PIGRUINS] = "cutstone",
    [WORLD_TILES.PIGRUINS_BLUE] = "cutstone",
    [WORLD_TILES.HAMARCHIVE] = "cutstone",

    [WORLD_TILES.QUAGMIRE_GATEWAY] = "turf_quagmire_gateway",
    [WORLD_TILES.QUAGMIRE_CITYSTONE] = "turf_quagmire_citystone",
    [WORLD_TILES.QUAGMIRE_PARKFIELD] = "turf_quagmire_parkfield",
    [WORLD_TILES.QUAGMIRE_PARKSTONE] = "turf_quagmire_parkstone",
    [WORLD_TILES.QUAGMIRE_PEATFOREST] = "turf_quagmire_peatforest",

}
local old_HandleDugGround = HandleDugGround
function HandleDugGround(dug_ground, x, y, z, ...)
    if SpeciaTileDrop[dug_ground] then
        local loot = SpawnPrefab(SpeciaTileDrop[dug_ground])
        if loot.components.inventoryitem ~= nil then
            loot.components.inventoryitem:InheritWorldWetnessAtXZ(x, z)
        end
        loot.Transform:SetPosition(x, y, z)
        if loot.Physics ~= nil then
            local angle = math.random() * TWOPI
            loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
        end
    else
        return old_HandleDugGround(dug_ground, x, y, z, ...)
    end
end

-- 添加深层雨林地皮和毒瘴雨林地皮挖起的特殊效果
local old_terraform = ACTIONS.TERRAFORM.fn
ACTIONS.TERRAFORM.fn = function(act)
    if act.invobject and act.invobject.components.terraformer then
        local tile = TheWorld.Map:GetTileAtPoint(act:GetActionPoint():Get())
        if tile == WORLD_TILES.GASRAINFOREST then
            if act.doer.components.talker then
                act.doer.components.talker:Say(GetString(act.doer.prefab, "ANNOUNCE_TOOLCORRODED"))
            end
            local finiteuses = act.invobject.components.finiteuses
            if finiteuses then
                finiteuses:Use(finiteuses:GetUses())
            end
            return
        elseif tile == WORLD_TILES.DEEPRAINFOREST then
            if act.doer.components.talker then
                act.doer.components.talker:Say(GetString(act.doer.prefab, "ANNOUNCE_TURFTOOHARD"))
            end
            return
        end
    end
    return old_terraform(act)
end

Hooks.FnDecorator(ACTIONS.COOK, "stroverridefn", function(act)
    if act.target and act.target.prefab == "smelter" then
        return { STRINGS.ACTIONS.SMELT }, true
    end
end)
