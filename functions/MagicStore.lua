local StoreScreen = require "screens/storescreen"
local ModStoreData = require "ModStoreData"
local CoinsPrefab, GoodsPrefab = ModStoreData.CoinsPrefab, ModStoreData.GoodsPrefab

----------------------------------------------------------------------------------------------------
local function AtlasTextureFinder(moneyprefab)
    if moneyprefab and moneyprefab == "goldnugget" then
        return "images/inventoryimages/hamletinventory.xml"
    else
        return "images/inventoryimages/volcanoinventory.xml"
    end
end

--==============================--
local function RequestedFunction(inst)
    SendModRPCToServer(GetModRPC("ServerStore", "Requested"), inst)

    inst.goodsinfo = {}
    for k, v in pairs(inst._goodslist:value()) do
        table.insert(inst.goodsinfo, {
            locat = k,
            index = inst._goodslist:value()[k],
            count = inst._countlist:value()[k],
            spoil = inst._spoillist:value()[k],
            ratio = inst._ratiolist:value()[k],
            stock = inst._stocklist:value()[k],
            price = inst._pricelist:value()[k],
            disct = inst._disctlist:value()[k],
            atlas = AtlasTextureFinder(CoinsPrefab[inst._moneylist:value()[k]]),
            moneyprefab = CoinsPrefab[inst._moneylist:value()[k]],
            goodsprefab = GoodsPrefab[inst._goodslist:value()[k]],
        })
    end

    local topscreen = GLOBAL.TheFrontEnd:GetActiveScreen()
    if topscreen.name ~= "StoreScreen" and GLOBAL.TheFrontEnd:GetScreenStackSize() <= 1 then
        inst.OpenStore(inst)
    end
end

--==============================--
local RequireTime = 0
local function OpenStoreFunction1(inst)
    if RequireTime > 10 then
        RequireTime = 0
        return false
    end
    if #inst.goodsinfo == 0 then
        inst:DoTaskInTime(0.1 + RequireTime / 10, function() inst.Requested(inst) end)
        return false
    end

    inst:DoTaskInTime(0.1, function()
        if not GLOBAL.ThePlayer._isopening:value() then return false end
        GLOBAL.TheFrontEnd:PushScreen(StoreScreen(GLOBAL.ThePlayer, inst, inst.goodsinfo, "lavaarena_boarlord.tex"))
    end)
end

local function OpenStoreFunction2(inst)
    if RequireTime > 10 then
        RequireTime = 0
        return false
    end
    if #inst.goodsinfo == 0 then
        inst:DoTaskInTime(0.1 + RequireTime / 10, function() inst.Requested(inst) end)
        return false
    end

    inst:DoTaskInTime(0.1, function()
        if not GLOBAL.ThePlayer._isopening:value() then return false end
        GLOBAL.TheFrontEnd:PushScreen(StoreScreen(GLOBAL.ThePlayer, inst, inst.goodsinfo, "quagmire_goatmum.tex"))
    end)
end

local function OpenStoreFunction3(inst)
    if RequireTime > 10 then
        RequireTime = 0
        return false
    end
    if #inst.goodsinfo == 0 then
        inst:DoTaskInTime(0.1 + RequireTime / 10, function() inst.Requested(inst) end)
        return false
    end

    inst:DoTaskInTime(0.1, function()
        if not GLOBAL.ThePlayer._isopening:value() then return false end
        GLOBAL.TheFrontEnd:PushScreen(StoreScreen(GLOBAL.ThePlayer, inst, inst.goodsinfo, "quagmire_goatkid.tex"))
    end)
end

local function OpenStoreFunction4(inst)
    if RequireTime > 10 then
        RequireTime = 0
        return false
    end
    if #inst.goodsinfo == 0 then
        inst:DoTaskInTime(0.1 + RequireTime / 10, function() inst.Requested(inst) end)
        return false
    end

    inst:DoTaskInTime(0.1, function()
        if not GLOBAL.ThePlayer._isopening:value() then return false end
        GLOBAL.TheFrontEnd:PushScreen(StoreScreen(GLOBAL.ThePlayer, inst, inst.goodsinfo, "quagmire_swampigelder.tex"))
    end)
end

local function OpenStoreFunction5(inst)
    if RequireTime > 10 then
        RequireTime = 0
        return false
    end
    if #inst.goodsinfo == 0 then
        inst:DoTaskInTime(0.1 + RequireTime / 10, function() inst.Requested(inst) end)
        return false
    end

    inst:DoTaskInTime(0.1, function()
        if not GLOBAL.ThePlayer._isopening:value() then return false end
        GLOBAL.TheFrontEnd:PushScreen(StoreScreen(GLOBAL.ThePlayer, inst, inst.goodsinfo, "quagmire_swampigelder.tex"))
    end)
end

--==============================--
local function PurchasedFunction(inst)
    if #inst.goodsinfo == 0 then return false end

    for k, v in pairs(inst._stocklist:value()) do
        inst.goodsinfo[k].stock = inst._stocklist:value()[k]
    end

    local topscreen = GLOBAL.TheFrontEnd:GetActiveScreen()
    if topscreen.name == "StoreScreen" and GLOBAL.TheFrontEnd:GetScreenStackSize() >= 0 then
        topscreen:CreatGoods(inst.goodsinfo)
    end
end


--==============================--
local function ShutStoreFunction(inst)
    --inst:DoTaskInTime(0.1, function()print(GLOBAL.ThePlayer._isopening:value()) end)
end

--==============================--
local function AdminPushFunction(inst)
    if #inst.goodsinfo == 0 then return false end

    for k, v in pairs(inst._goodslist:value()) do
        inst.goodsinfo[k].locat = k
        inst.goodsinfo[k].index = inst._goodslist:value()[k]
        inst.goodsinfo[k].count = inst._countlist:value()[k]
        inst.goodsinfo[k].spoil = inst._spoillist:value()[k]
        inst.goodsinfo[k].ratio = inst._ratiolist:value()[k]
        inst.goodsinfo[k].stock = inst._stocklist:value()[k]
        inst.goodsinfo[k].money = inst._moneylist:value()[k]
        inst.goodsinfo[k].price = inst._pricelist:value()[k]
        inst.goodsinfo[k].disct = inst._disctlist:value()[k]
        inst.goodsinfo[k].prefab = GoodsPrefab[inst._goodslist:value()[k]]
    end

    local topscreen = GLOBAL.TheFrontEnd:GetActiveScreen()
    if topscreen.name == "StoreScreen" and GLOBAL.TheFrontEnd:GetScreenStackSize() >= 0 then
        topscreen:CreatGoods(inst.goodsinfo)
    end
end

----------------------------------------------------------------------------------------------------
--[API]AddPrefabPostInit(prefab, fn)
----------------------------------------------------------------------------------------------------
AddPrefabPostInit("lavaarena_boarlord", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction1
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)

AddPrefabPostInit("lavaarena_spectator4", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction2
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)

AddPrefabPostInit("lavaarena_spectator2", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction3
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)

AddPrefabPostInit("lavaarena_spectator3", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction5
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)

AddPrefabPostInit("lavaarena_spectator1", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction4
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)

AddPrefabPostInit("quagmire_goatkid", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction3
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)

AddPrefabPostInit("quagmire_trader_merm", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction4
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)

AddPrefabPostInit("quagmire_trader_merm2", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction4
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)

AddPrefabPostInit("quagmire_trader_merm3", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction4
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)

AddPrefabPostInit("quagmire_goatkid2", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction3
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)

AddPrefabPostInit("quagmire_goatmum", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction2
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)

AddPrefabPostInit("quagmire_swampigelder", function(inst)
    inst._goodslist = net_bytearray(inst.GUID, "GoodsList")
    inst._countlist = net_bytearray(inst.GUID, "CountList")
    inst._spoillist = net_bytearray(inst.GUID, "SpoilList")
    inst._ratiolist = net_bytearray(inst.GUID, "RatioList")
    inst._stocklist = net_bytearray(inst.GUID, "StockList")
    inst._moneylist = net_bytearray(inst.GUID, "MoneyList")
    inst._pricelist = net_bytearray(inst.GUID, "PriceList")
    inst._disctlist = net_bytearray(inst.GUID, "DisctList")

    inst.goodsinfo = {}
    inst.NetEvt_Requested = net_event(inst.GUID, "Store_NetEvt_Requested")
    inst.NetEvt_OpenStore = net_event(inst.GUID, "Store_NetEvt_OpenStore")
    inst.NetEvt_Purchased = net_event(inst.GUID, "Store_NetEvt_Purchased")
    inst.NetEvt_ShutStore = net_event(inst.GUID, "Store_NetEvt_ShutStore")
    inst.NetEvt_AdminPush = net_event(inst.GUID, "Store_NetEvt_AdminPush")

    inst.Requested = RequestedFunction
    inst.OpenStore = OpenStoreFunction4
    inst.Purchased = PurchasedFunction
    inst.ShutStore = ShutStoreFunction
    inst.AdminPush = AdminPushFunction

    if GLOBAL.TheNet:IsDedicated() and not GLOBAL.TheNet:GetIsClient() then return end

    inst:ListenForEvent("Store_NetEvt_Requested", inst.Requested, inst)
    inst:ListenForEvent("Store_NetEvt_OpenStore", inst.OpenStore, inst)
    inst:ListenForEvent("Store_NetEvt_Purchased", inst.Purchased, inst)
    inst:ListenForEvent("Store_NetEvt_ShutStore", inst.ShutStore, inst)
    inst:ListenForEvent("Store_NetEvt_AdminPush", inst.AdminPush, inst)
end)
