local assets =
{
    Asset("ANIM", "anim/lavaarena_boaraudience1.zip"),
    Asset("ANIM", "anim/lavaarena_boaraudience1_build_1.zip"),
    Asset("ANIM", "anim/lavaarena_boaraudience1_build_2.zip"),
    Asset("ANIM", "anim/lavaarena_boaraudience1_build_3.zip"),
    Asset("ANIM", "anim/lavaarena_decor.zip"),
    Asset("ANIM", "anim/lavaarena_banner.zip"),
}

local function stand_postinit(inst)
    --生成围栏和一堆猪人
end

local builds = { "lavaarena_boaraudience1", "lavaarena_boaraudience1_build_1", "lavaarena_boaraudience1_build_2", "lavaarena_boaraudience1_build_3" }
local function spectator_postinit(inst)
    inst.AnimState:SetBuild(builds[math.random(#builds)]) --随便换，也不需要保存

    local shade = .75 + math.random() * .25
    inst.AnimState:SetMultColour(shade, shade, shade, 1)

    inst:SetStateGraph("SGlavaarena_spectator")
end



add_event_server_data("lavaarena", "prefabs/lavaarena_crowdstand", {
    stand_postinit = stand_postinit,
    spectator_postinit = spectator_postinit
}, assets)

--[[
随机动画：
idle_loop
boo
chat 只有朝下的动画
cheer
cheer2
cheer3
eat_l
]]