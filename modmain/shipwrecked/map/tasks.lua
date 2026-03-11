-- 给这些task添加新的钥匙，解锁该task就能凭借钥匙解锁其他的task了
AddTaskPreInit("RedForest", function(task)
    task.keys_given = task.keys_given or {}
    table.insert(task.keys_given, KEYS.VOLCANO_ENTRANCE)
end)
