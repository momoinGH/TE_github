local tasks = {
    "FrostIsland_icelake",
    "FrostIsland_Wildbeaver",
    "FrostIsland_Beach",
    "FrostIsland_palace",
    "FrostIsland_deciduoustree",
    "FrostIsland_maxwell",
    "FrostIsland_Mine",
    "FrostIsland_Mammoth"
}

for _, t in ipairs(tasks) do
    AddTaskPreInit(t, function(task)
        task.room_tags = task.room_tags or {}
        table.insert(task.room_tags, "frost") --冰岛区域
    end)
end
