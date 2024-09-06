local Products = {
    ash = {
        priority = -1,
        test = function(worker, names, attrs) return true end,
    },
    opalpreciousgem = { -- gem
        priority = 20,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 42 end,
    },
    greengem = {
        priority = 10,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 28 end,
    },
    yellowgem = {
        priority = 5,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 10 end,
    },
    orangegem = {
        priority = 3,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 4 end,
    },
    alloy = { -- iron
        priority = 5,
        test = function(worker, names, attrs) return attrs.iron and attrs.iron >= 4 end,
    },
    gunpowder = { -- nitro
        priority = 3,
        test = function(worker, names, attrs) return attrs.nitro and attrs.nitro >= 4 end,
    },
    nitre = {
        priority = 1,
        test = function(worker, names, attrs) return attrs.nitro and attrs.nitro >= 1 end,
    },
    goldenbar = { -- gold
        priority = 10,
        test = function(worker, names, attrs) return attrs.gold and attrs.gold >= 2 end,
    },
    goldnugget = {
        priority = 5,
        test = function(worker, names, attrs) return attrs.gold and attrs.gold >= 1 end,
    },
    stonebar = { -- mineral
        priority = 1,
        test = function(worker, names, attrs) return attrs.mineral and attrs.mineral >= 1 end,
    }
}

for k, v in pairs(Products) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0

    v.cookbook_category = "smelter"
end

return Products
