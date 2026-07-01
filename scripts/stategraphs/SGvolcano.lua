require("stategraphs/commonstates")

local actionhandlers =
{
}

local events =
{
}

local states =
{
	State {
		name = "active",
		tags = { "busy" },

		onenter = function(inst)
			inst.AnimState:PlayAnimation("active_idle_pre")
			inst.AnimState:PushAnimation("active_idle", true)
			inst.SoundEmitter:SetParameter("volcano", "volcano_state", 1.0)
		end,
	},

	State {
		name = "active_pst",
		tags = { "busy" },

		onenter = function(inst)
			inst.AnimState:PlayAnimation("active_idle_pst")
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("dormant") end)
		},
	},

	State {
		name = "dormant",
		tags = { "busy" },

		onenter = function(inst)
			inst.AnimState:PlayAnimation("dormant_idle_pre")
			inst.AnimState:PushAnimation("dormant_idle", true)
			inst.SoundEmitter:SetParameter("volcano", "volcano_state", 0.0)
		end,
	},

	State {
		name = "dormant_pst",
		tags = { "busy" },

		onenter = function(inst)
			inst.AnimState:PlayAnimation("dormant_idle_pst")
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("active") end)
		},
	},

	State {
		name = "erupt",
		tags = { "busy" },

		onenter = function(inst)
			inst.AnimState:PlayAnimation("rumble")
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("erupt_loop") end)
		},
	},

	State {
		name = "erupt_loop",
		tags = { "busy" },

		onenter = function(inst)
			inst.AnimState:PlayAnimation("erupt")
		end,

		timeline =
		{
			TimeEvent(0 * FRAMES, function(inst) TheWorld.SoundEmitter:SetParameter("earthquake", "intensity", 0.1) end),

			TimeEvent(48 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/volcano/volcano_erupt_charge")
			end),
			TimeEvent(63 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/volcano/volcano_erupt")
			end),
			TimeEvent(64 * FRAMES, function(inst) TheWorld.SoundEmitter:SetParameter("earthquake", "intensity", 0.06) end),
			TimeEvent(72 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/volcano/volcano_erupt_sizzle")
			end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("erupt_loop") end)
		},
	},

	State {
		name = "rumble",
		tags = { "busy" },

		onenter = function(inst)
			inst.AnimState:PlayAnimation("rumble")
		end,

		events =
		{
			EventHandler("animqueueover", function(inst)
				if TheWorld.state.issummer then
					inst.sg:GoToState("active")
				else
					inst.sg:GoToState("dormant")
				end
			end)
		},
	},
}

return StateGraph("volcano", states, events, "dormant", actionhandlers)
