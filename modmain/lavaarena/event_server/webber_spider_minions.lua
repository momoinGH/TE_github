local assets =
{
    Asset("ANIM", "anim/ds_spider_basic.zip"),
    Asset("ANIM", "anim/spider_build.zip"),
    Asset("ANIM", "anim/spider_warrior_lavaarena_build.zip"),
    Asset("SOUND", "sound/spider.fsb"),
}
local function master_postinit(inst, offset)

end

add_event_server_data("lavaarena", "prefabs/webber_spider_minions", {
    master_postinit = master_postinit,
}, assets)
