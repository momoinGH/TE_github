local Constructor = require("tropical_utils/constructor")
Constructor.SetEnv(env)

local function GetDefaultItem()
    return {
        build = "pigman_tribe",
        bank = "pigman_tribe",
        anim = "idle",
        animoffsetbgx = 80,
        animoffsetbgy = 60,
    }
end

Constructor.AddScrapbookWiki("tropical", {
    adult_flytrap = {
        build = "venus_flytrap_lg_build",
        bank = "venus_flytrap_planted",
        anim = "idle",
        health = TUNING.ADULT_FLYTRAP_HEALTH,
        damage = TUNING.ADULT_FLYTRAP_DAMAGE,
        weaponrange = TUNING.ADULT_FLYTRAP_ATTACK_DIST,
        sanityaura = -TUNING.SANITYAURA_MED,
    },
})
