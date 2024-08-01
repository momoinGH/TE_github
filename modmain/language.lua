local language = string.lower(GetModConfigData("language"))

--英文版本兜底，不使用的台词不应该添加
modimport("scripts/languages/tropical_strings_en")
-- modimport("scripts/languages/tropical_strings_" .. language) --TODO
modimport("scripts/languages/tropical_stringscreeps")
modimport("scripts/languages/tropical_wurt_quotes")


-- 其他语言的wiki先不管
modimport("scripts/languages/tropical_modwiki_zh")



-- local start = os.clock()
-- modimport("scripts/languages/tropical_strings_en.lua")
-- print("1读取花了" .. (os.clock() - start))
-- 1读取花了0.015000000000327
