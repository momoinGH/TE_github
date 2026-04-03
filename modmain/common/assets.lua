Assets =
{
    Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
    Asset("SOUND", "sound/music_stream_SW.fsb"),
    Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),

    Asset("SOUNDPACKAGE", "sound/sw_character.fev"),
    Asset("SOUND", "sound/sw_character.fsb"),

    Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
    Asset("SOUND", "sound/DLC003_sfx.fsb"),
    Asset("SOUND", "sound/DLC003_music_stream.fsb"),
    Asset("SOUND", "sound/DLC003_AMB_stream.fsb"), --这个太大，有106MB

    Asset("SOUNDPACKAGE", "sound/dontstarve_wagstaff.fev"),
    Asset("SOUND", "sound/dontstarve_wagstaff.fsb"),

    -------------overlays -------------------

    -------------mapstyle -------------------
    Asset("ATLAS", "images/mapstyle/hud_shipwrecked.xml"),

    Asset("ATLAS", "images/mapstyle/hud_hamlet.xml"),

    Asset("ATLAS", "images/mapstyle/hud_pigcity.xml"),

    -------------colour cubes -------------------
    Asset("IMAGE", "images/colour_cubes/sw_mild_day_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/SW_mild_dusk_cc.tex"),

    Asset("IMAGE", "images/colour_cubes/SW_wet_day_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/SW_wet_dusk_cc.tex"),

    Asset("IMAGE", "images/colour_cubes/sw_green_day_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/sw_green_dusk_cc.tex"),

    Asset("IMAGE", "images/colour_cubes/SW_dry_day_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/SW_dry_dusk_cc.tex"),

    Asset("IMAGE", "images/colour_cubes/sw_volcano_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/sw_volcano_active_cc.tex"),

    Asset("IMAGE", "images/colour_cubes/pork_temperate_day_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/pork_temperate_dusk_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/pork_temperate_night_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/pork_temperate_fullmoon_cc.tex"),

    Asset("IMAGE", "images/colour_cubes/pork_cold_day_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/pork_cold_dusk_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/pork_cold_fullmoon_cc.tex"),

    Asset("IMAGE", "images/colour_cubes/pork_lush_day_test.tex"),
    Asset("IMAGE", "images/colour_cubes/pork_lush_dusk_test.tex"),
    Asset("IMAGE", "images/colour_cubes/pork_warm_fullmoon_cc.tex"),

    Asset("IMAGE", "images/colour_cubes/pork_cold_bloodmoon_cc.tex"),

    Asset("IMAGE", "images/colour_cubes/heat_vision_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/shooting_goggles_cc.tex"),


    -------------anims -------------------
    --玩家动画
    Asset("ANIM", "anim/player_wagstaff.zip"),          --使用传送伞
    Asset("ANIM", "anim/player_mount_wagstaff.zip"),    --使用传送伞
    Asset("ANIM", "anim/player_actions_machete.zip"),   --砍伐动画，有动画hack_pre、hack_loop、hack_pst
    Asset("ANIM", "anim/player_actions_telescope.zip"), --望远镜，有动画telescope、telescope_pst


    Asset("ANIM", "anim/ripple_build.zip"),             --水里波纹，用于物品浮在水面时

    --TODO 这几个纹理怎么使用
    Asset("IMAGE", "levels/textures/outro.tex"),                   --哈姆雷特云纹理
    Asset("IMAGE", "levels/textures/ground_noise_water_deep.tex"), --海洋纹理


    -- @Runar: 声明资产不需要声明tex
    Asset("ATLAS", "images/names_wilbur.xml"),
    Asset("ATLAS", "images/names_woodlegs.xml"),
    Asset("ATLAS", "images/names_walani.xml"),
    Asset("ATLAS", "images/names_gold_cn_wilbur.xml"),
    Asset("ATLAS", "images/names_gold_cn_woodlegs.xml"),
    Asset("ATLAS", "images/names_gold_cn_walani.xml"),

    Asset("ATLAS", "images/tabs.xml"), --制作栏图标

    -- TODO 图鉴的料理图，检查是否正常显示
    Asset("ATLAS", "images/cookbook/cookbook_sw.xml"),
    Asset("ATLAS", "images/cookbook/cookbook_ham.xml"),
}
