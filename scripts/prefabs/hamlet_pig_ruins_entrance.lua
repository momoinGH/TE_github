local MakeRuinDoor = require("prefabs/hamlet_pig_ruins_entrance_defs")

local function GetMaze1()

end

local function GetMaze2()

end

local function GetMaze3()

end

local function GetMaze4()

end

local function GetMaze5()

end

local function GetSmallMaze()

end

----------------------------------------------------------------------------------------------------

local function Runis1AnimInit(inst)
    inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
    inst.AnimState:Hide("swap_ornament2")
    inst.AnimState:Hide("swap_ornament3")
    inst.AnimState:Hide("swap_ornament4")
end

local function Runis2AnimInit(inst)
    inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
    inst.AnimState:Hide("swap_ornament3")
    inst.AnimState:Hide("swap_ornament4")
    inst.AnimState:Hide("swap_ornament")
end

local function Runis3AnimInit(inst)
    inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
    inst.AnimState:Hide("swap_ornament2")
    inst.AnimState:Hide("swap_ornament4")
    inst.AnimState:Hide("swap_ornament")
end

local function Runis4AnimInit(inst)
    inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
    inst.AnimState:Hide("swap_ornament2")
    inst.AnimState:Hide("swap_ornament3")
    inst.AnimState:Hide("swap_ornament")
end

local function RunisSmallAnimInit(inst)
    inst.AnimState:Hide("swap_ornament4")
    inst.AnimState:Hide("swap_ornament3")
    inst.AnimState:Hide("swap_ornament2")
    inst.AnimState:Hide("swap_ornament")
    inst.AnimState:OverrideSymbol("statue_01", "pig_ruins_entrance", "")
    inst.AnimState:OverrideSymbol("swap_ornament", "pig_ruins_entrance", "")
end

return MakeRuinDoor("pig_ruins_entrance", { hack = true, maze_id = "runis_1", get_maze_fn = GetMaze1 }, Runis1AnimInit),
    MakeRuinDoor("pig_ruins_exit", { maze_id = "runis_1" }, Runis1AnimInit),

    MakeRuinDoor("pig_ruins_entrance2", { hack = true, maze_id = "runis_2", get_maze_fn = GetMaze2 }, Runis2AnimInit),
    MakeRuinDoor("pig_ruins_exit2", { maze_id = "runis_2" }, Runis2AnimInit),

    MakeRuinDoor("pig_ruins_entrance3", { hack = true, get_maze_fn = GetMaze3 }, Runis3AnimInit),

    MakeRuinDoor("pig_ruins_entrance4", { hack = true, maze_id = "runis_4", get_maze_fn = GetMaze4 }, Runis4AnimInit),
    MakeRuinDoor("pig_ruins_exit4", { maze_id = "runis_4" }, Runis4AnimInit),

    MakeRuinDoor("pig_ruins_entrance5", { hack = true, get_maze_fn = GetMaze5 }, Runis4AnimInit),
    MakeRuinDoor("pig_ruins_entrance_small", { get_maze_fn = GetSmallMaze }, RunisSmallAnimInit)
