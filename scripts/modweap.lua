require "class"
require "util"
CustomPrefab = Class(Prefab, function(self, name, fn, assets, deps, force_path_search, atlas, image, h, swap_build, j)
    Prefab._ctor(self, name, fn, assets, deps, force_path_search)
    self.name = name;
    self.atlas = atlas and resolvefilepath(atlas) or resolvefilepath("images/inventoryimages.xml")
    self.imagefn = type(image) == "function" and image or nil;
    self.image = self.imagefn == nil and image or "torch.tex"
    self.swap_build = swap_build;
    local k = {
        common_head1 = { swap = { "swap_hat" }, hide = { "HAIR_NOHAT", "HAIR", "HEAD" }, show = { "HAT", "HAIR_HAT", "HEAD_HAT" } },
        common_head2 = { swap = { "swap_hat" }, show = { "HAT" } },
        common_body = { swap = { "swap_body" } },
        common_hand = { swap = { "swap_object" }, hide = { "ARM_normal" }, show = { "ARM_carry" } }
    }
    self.swap_data = k[j] ~= nil and k[j] or j
end)
