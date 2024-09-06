local Utils = require("tropical_utils/utils")
local containers = require("containers")
local params = containers.params

params.smelter = deepcopy(params.cookpot)
params.smelter.widget.buttoninfo.text = STRINGS.ACTIONS.SMELT