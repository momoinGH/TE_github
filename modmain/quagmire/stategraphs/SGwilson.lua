local actionhandlers = {
    ActionHandler(ACTIONS.MEAL, "doshortaction"),
    -- ActionHandler(ACTIONS.SNACKRIFICE, "give"),
}

local eventhandlers = {

}

local states = {

}

for _, actionhandler in ipairs(actionhandlers) do
    AddStategraphActionHandler("wilson", actionhandler)
end

for _, eventhandler in ipairs(eventhandlers) do
    AddStategraphEvent("wilson", eventhandler)
end

for _, state in ipairs(states) do
    AddStategraphState("wilson", state)
end
