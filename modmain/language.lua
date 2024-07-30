local language = string.lower(GetModConfigData("language"))

modimport("scripts/languages/tropical_stringscomplement.lua")
modimport("scripts/languages/tropical_stringscreeps.lua")
modimport("scripts/languages/tropical_wurt_quotes.lua")
modimport("scripts/languages/tropical_strings_" .. language .. ".lua")

-- 其他语言的wiki先不管
modimport("scripts/languages/tropical_modwiki_zh")
