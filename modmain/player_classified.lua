-- player_classified上的网络变量比一般的网络变量性能更好点，因为这个不会广播给所有玩家，只会推送给指定的玩家客户端上，所以客户端也是拿不到其他玩家的值的


local net_vars = {}
local is_end = false

--- 在player_classified中添加网络变量，同时客户端监听事件
--- 命名尽量加上mod前缀，毕竟网络变量一旦重名就会报错，而且不会提示哪里报错的
---@param net_class table 网络变量类
---@param name string 变量名，注意不要重合，重合会报错的
---@param event_name string|nil 事件名，默认为name
---@param master_listen boolean 主机是否也监听网络变量事件，值改变时玩家也会推送该事件
function TroAddPlayerClassifiedNetVar(net_class, name, event_name, master_listen)
    assert(not is_end, "不能再添加了")
    event_name = event_name or name
    --允许重复定义，不允许事件名不同
    assert(not net_vars[name] or (net_vars[name].event_name == event_name
            and net_vars[name].master_listen == master_listen
            and net_vars[name].net_class == net_class),
        "已经定义过" .. name .. "网络变量，但是参数不一致")

    net_vars[name] = {
        net_class = net_class,
        event_name = event_name,
        master_listen = master_listen,
    }
end

-- 注册操作
function TroPlayerClassifiedNetVarEnd()
    if is_end then return end

    is_end = true
    local function RegisterNetListeners(inst)
        if TheWorld.ismastersim then
            inst._parent = inst._parent or inst.entity:GetParent()
        end

        for name, data in pairs(net_vars) do
            if not TheWorld.ismastersim or data.master_listen then
                local event_name = data.event_name
                inst:ListenForEvent(event_name, function(inst)
                    if inst._parent ~= nil then
                        inst._parent:PushEvent(event_name)
                    end
                end)
            end
        end
    end

    AddPrefabPostInit("player_classified", function(inst)
        for name, data in pairs(net_vars) do
            if not inst[name] then
                local net_class = data.net_class
                inst[name] = net_class(inst.GUID, name, data.event_name)
            else
                TroErrorHandle("重复定义player_classified网络变量，会崩溃的！" .. name, true)
            end
        end

        inst:DoStaticTaskInTime(0, RegisterNetListeners)
    end)
end
