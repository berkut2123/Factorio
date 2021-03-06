--[[ Copyright (c) 2017 Optera
* Part of Loader Redux
*
* See LICENSE.md in the project directory for license information.
--]]

function make_loader_item(name, subgroup, order)
  return{
    type="item",
    name=name,
    icon="__LoaderRedux__/graphics/icon/"..name..".png",
    icon_size = 32,
    icon_mipmaps = nil,
    subgroup=subgroup,
    order=order,
    place_result=name,
    stack_size=50
  }
end

if mods["boblogistics"] then
  data:extend({
    make_loader_item("loader","bob-logistic-tier-1","d-a"),
    make_loader_item("fast-loader","bob-logistic-tier-2","d-b"),
    make_loader_item("express-loader","bob-logistic-tier-3","d-c"),
    make_loader_item("purple-loader","bob-logistic-tier-4","d-d"),
    make_loader_item("green-loader","bob-logistic-tier-5","d-f"),
  })
else
  data:extend({
    make_loader_item("loader","belt","d-a"),
    make_loader_item("fast-loader","belt","d-b"),
    make_loader_item("express-loader","belt","d-c"),
  })
end