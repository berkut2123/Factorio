-- entity/sign-icons

if DECT.ENABLED["signs"] then
	local categories = DECT.CONFIG.SIGN_CATEGORIES
	local blacklist = DECT.CONFIG.SIGN_BLACKLIST
	local whitelist = DECT.CONFIG.SIGN_WHITELIST

	for _, cat in pairs(categories) do
		if data.raw[cat] then
			for _, obj in pairs(data.raw[cat]) do
				local blacklisted = false
				local sprite_scale = 0.7
				local sprite_shift = {-0.02, -0.14}
				for _, blacklisted_name_pattern in pairs(blacklist) do
					if obj.name:find(blacklisted_name_pattern) then
						for _, whitelisted_name in pairs(whitelist) do
							if obj.name ~= whitelisted_name then
								blacklisted = true
							end
						end
					end
				end
				if not blacklisted then
					local sprite = {}

					if obj.icons == nil and obj.icon ~= nil then
						sprite.file = obj.icon
						sprite.tint = nil
						sprite.icon_size = obj.icon_size
					else
						sprite.file = obj.icons[1].icon
						sprite.tint = obj.icons[1].tint
						if obj.icons[1].icon_size ~= nil then
							sprite.icon_size = obj.icons[1].icon_size
						elseif obj.icon_size ~= nil and obj.icons[1].icon_size == nil then
							sprite.icon_size = obj.icon_size
						else
							sprite.file = nil
						end
					end

					if sprite.icon_size == 64 then
						sprite_scale = 0.4
						sprite_shift = {-0.0, -0.1}
					end

					if sprite.file then
						new_icon = {
							type = "simple-entity",
							name = "dect-icon-" .. obj.name,
							order = cat,
							icons = {
								{
									icon = sprite.file,
									tint = sprite.tint
								}
							},
							icon_size = sprite.icon_size,
							flags = {"placeable-off-grid", "not-on-map"},
							selectable_in_game = false,
							render_layer = "higher-object-above",
							picture = {
								filename = sprite.file,
								priority = "extra-high",
								width = sprite.icon_size,
								height = sprite.icon_size,
								scale = sprite_scale,
								shift = sprite_shift,
								tint = sprite.tint
							}
						}
						data:extend({new_icon})
					end
				end
			end
		end
	end
end
