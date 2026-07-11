local actionhandlers = {
    ActionHandler(ACTIONS.MEAL, "doshortaction"),
    -- ActionHandler(ACTIONS.SNACKRIFICE, "give"),
}

local eventhandlers = {

}

local states = {

}

for _, actionhandler in ipairs(actionhandlers) do
    AddStategraphActionHandler("wilson_client", actionhandler)
end

for _, eventhandler in ipairs(eventhandlers) do
    AddStategraphEvent("wilson_client", eventhandler)
end

for _, state in ipairs(states) do
    AddStategraphState("wilson_client", state)
end
