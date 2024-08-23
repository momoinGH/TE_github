local function Setup(inst, attacker, target, projectile, flashcolour)
    if inst.doubleflip then
        inst.flip:set(math.random(4))
    else
        inst.flip:set(math.random() < 0.5)
    end
    local x, y, z = target.Transform:GetWorldPosition()
    inst.Transform:SetPosition(x, y, z)
end

local function master_postinit(inst, variation, doubleflip) --搞不懂这些变量什么意思，也许可以替换成prefabs/hitsparks_fx.lua文件里的特效
    inst.doubleflip = doubleflip
    inst.Setup = Setup
end

add_event_server_data("lavaarena", "prefabs/weaponsparks", {
    master_postinit = master_postinit
})
