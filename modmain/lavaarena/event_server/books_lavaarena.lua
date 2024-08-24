local assets =
{
    Asset("ANIM", "anim/book_fossil.zip"),
    Asset("ANIM", "anim/swap_book_fossil.zip"),
    Asset("ANIM", "anim/book_elemental.zip"),
    Asset("ANIM", "anim/swap_book_elemental.zip"),
}

local function OnEquip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:OverrideSymbol("book_closed", "swap_book_" .. inst.booktype, "book_closed")
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
end


local function common(inst, booktype)
    inst.booktype = booktype

    InitLavaarenaWeapon(inst, nil, 15)
    inst.castsound = "dontstarve/common/lava_arena/spell/fossilized"

    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
end

----------------------------------------------------------------------------------------------------

local function SpawnFosilFx(inst, pos)
    local poses = {}
    for f = 1, 20 do
        local g = f / 5
        local h = math.sqrt(g * 512)
        local i = math.sqrt(g)
        local off = Vector3(math.sin(h) * i * 1.2, 0, math.cos(h) * i * 1.2)
        local tile = TheWorld.Map:GetTileAtPoint((pos + off):Get())
        if tile ~= 1 and tile ~= 255 then
            table.insert(poses, off)
        end
    end

    for i = 1, 13 do
        inst:DoTaskInTime(i * 0.15, function()
            SpawnAt("fossilizing_fx", pos + poses[math.random(#poses)]).Transform:SetScale(.65, .65, .65)
        end)
    end
end;

local function FossilSpell(inst, doer, pos)
    SpawnFosilFx(inst, pos)

    for _, v in ipairs(GetPlayerAttackTarget(doer, 4.1, function(ent)
        return ent.components.freezable and not ent.components.freezable:IsFrozen()
    end, nil, true)) do
        v.components.freezable:AddColdness(5)
        v.components.freezable:SpawnShatterFX()
    end

    inst.components.rechargeable:Discharge(18)
end

local function fossil_postinit(inst)
    common(inst, "fossil")
    inst.components.aoespell:SetSpellFn(FossilSpell)
end

----------------------------------------------------------------------------------------------------

local function ElementalSpell(inst, doer, pos)
    local follower = SpawnPrefab("lavaarena_elemental")
    follower.Transform:SetPosition(pos:Get())

    inst.components.rechargeable:Discharge(18)
end

local function elemental_postinit(inst)
    common(inst, "elemental")
    inst.components.aoespell:SetSpellFn(ElementalSpell)
end

add_event_server_data("lavaarena", "prefabs/books_lavaarena", {
    fossil_postinit = fossil_postinit,
    elemental_postinit = elemental_postinit
}, assets)
