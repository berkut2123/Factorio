-- Version 1

local _entity_utils = {}

-- -- Utils

-- return a table with all neighbours of one entity
-- for each of this, will give the position and direction
-- with this structure {entity : LuaEntity, horizontal_direction : String, vertical_direction : String}
-- the possible direction is: "same" if don't change, "west"(L) "east"(R) and "north"(U) "south"(D)
-- @entity, entity to find connected neighbours
function _entity_utils.getConnectedNeighbours(entity)
	local neighbours = {}
    
	if _entity_utils.entityHasAttribute(entity, "neighbours") then -- if entity not null & there's neighbours	
		for _, neighbour_entities in pairs(entity.neighbours) do
			for _, neighbour in pairs(neighbour_entities) do					
				local _horizontal_direction = "same"
				local _vertical_direction = "same"
				
				if entity.position.x > neighbour.position.x then
					_horizontal_direction = "west"
				else
					_horizontal_direction = "east"
				end
				if entity.position.y > neighbour.position.y then
					_vertical_direction = "south"
				else
					_vertical_direction = "north"
				end
				
				table.insert(neighbours, 
				{
					entity = neighbour,
					horizontal_direction = _horizontal_direction,
					vertical_direction = _vertical_direction
				})						
			end
		end
	end
	
	return neighbours
end

-- return a table with all neighbours of one entity
-- with the same prototype
-- for each of this, will give the position and direction
-- with this structure {entity : LuaEntity, horizontal_direction : String, vertical_direction : String}
-- the possible direction is: "same" if don't change, "west"(L) "east"(R) and "north"(U) "south"(D)
-- @entity, entity to find connected neighbours
function _entity_utils.getConnectedNeighboursOfSamePrototype(entity)
	local same_prototype = {}
    
	if _entity_utils.entityHasAttribute(entity, "neighbours") then -- if entity not null & there's neighbours	
		for _, neighbour_entities in pairs(entity.neighbours) do
			for _, neighbour in pairs(neighbour_entities) do
				if type(neighbour) == "table" then -- if is an entity, else is a wall or an electric pole
					if neighbour.prototype == entity.prototype then
					
						local _horizontal_direction = "same"
						local _vertical_direction = "same"
						
						if entity.position.x > neighbour.position.x then
							_horizontal_direction = "west"
						else
							_horizontal_direction = "east"
						end
						if entity.position.y > neighbour.position.y then
							_vertical_direction = "south"
						else
							_vertical_direction = "north"
						end
						
						table.insert(same_prototype, 
						{
							entity = neighbour,
							horizontal_direction = _horizontal_direction,
							vertical_direction = _vertical_direction
						})
						
						--for debug
						--[[
						game.print
						(
							"Found at " .. tostring(neighbour.position.x) .. ", " .. tostring(neighbour.position.y) 
							.. " in direction " .. _horizontal_direction .. " " .. _vertical_direction
						)	
						--]]
					end
				end
			end
		end
	end
	
	return same_prototype
end

-- Return rounded of a given number, <= 0.49 to 0, >= 0.50 to 1
-- @num, number to round
function round(num)
 return (num + 0.5 - (num + 0.5) % 1)
end

-- Return size of given prototype,
-- like a tuple {width, height} with width, height integer >= 0,
-- if both is equal than zero, maybe there's an error in the given entity structure
-- @entity to calculate size
function _entity_utils.getPrototypeSize(prototype)
	if prototype ~= nil and type(prototype) == "table" then
		left_top_point     = prototype.selection_box.left_top
		right_bottom_point = prototype.selection_box.right_bottom
		
		_width  = round(math.abs(left_top_point.x) + math.abs(right_bottom_point.x))
		_height = round(math.abs(left_top_point.y) + math.abs(right_bottom_point.y))
			
		return {width = _width, height = _height}			
	end
	return {0, 0}
end

-- Return size of given entity,
-- like a tuple {width, height} with width, height integer >= 0,
-- if both is equal than zero, maybe there's an error in the given entity structure
-- @entity to calculate size
function _entity_utils.getEntitySize(entity)
	if entity ~= nil and type(entity) == "table" then
		left_top_point     = entity.prototype.selection_box.left_top
		right_bottom_point = entity.prototype.selection_box.right_bottom
		
		_width  = round(math.abs(left_top_point.x) + math.abs(right_bottom_point.x))
		_height = round(math.abs(left_top_point.y) + math.abs(right_bottom_point.y))
			
		return {width = _width, height = _height}			
	end
	return {0, 0}
end

-- Return the effective size of given entity with actual direction,
-- like a tuple {width, height} with width, height integer >= 0,
-- if the entity is in horizontal will return {height, width} instead {width, height},
-- if both is equal than zero, maybe there's an error in the given entity structure
-- @entity to calculate size
function _entity_utils.getEntityOrientedSize(entity)
	if entity ~= nil and type(entity) == "table" then
		left_top_point     = entity.prototype.selection_box.left_top
		right_bottom_point = entity.prototype.selection_box.right_bottom
		
		_width  = round(math.abs(left_top_point.x) + math.abs(right_bottom_point.x))
		_height = round(math.abs(left_top_point.y) + math.abs(right_bottom_point.y))
					
		if entity.direction == 0 or entity.direction == 4 then -- if is horizontal			
			return {width = _width, height = _height}
		else -- if is vertical
			return {width = _height, height = _width}
		end
	end
	return {0, 0}
end

-- Return an integer >= 0,
-- that rappresent the distance from the right pointer to the center of given entity
-- example: entity dimension 2x2 (because betwin 2 tile the left one is the center),
-- center is 2, difference is 0
-- example: entity dimension 3x3, center is 2, difference is 1
-- example: entity dimension 4x4, center is 3, difference is 1
-- example: entity dimension 5x5, center is 3, difference is 2
-- @entity to calculate difference
function _entity_utils.rightDifferenceToEntityCenter(entity)
	_width = _entity_utils.getEntitySize(entity).width
	return _width-round((_width+1)/2)
end

-- Return an integer >= 0,
-- that rappresent the distance from the down pointer to the center of given entity
-- example: see rightDifferenceToEntityCenter(...)
-- @entity to calculate difference
function _entity_utils.downDifferenceToEntityCenter(entity)
	_height = _entity_utils.getEntitySize(entity).height
	return _height-round((_height+1)/2)
end

-- Return an integer >= 0,
-- that rappresent the distance from the right pointer to the center of given size
-- size is requested like a tuple {width, height} with width, height integer >= 0,
-- example: see rightDifferenceToEntityCenter(...)
-- @size to calculate difference
function _entity_utils.rightDifferenceToSizeCenter(size)
	return size.width-round((size.width+1)/2)
end

-- Return an integer >= 0,
-- that rappresent the distance from the down pointer to the center of given size
-- size is requested like a tuple {width, height} with width, height integer >= 0,
-- example: see rightDifferenceToEntityCenter(...)
-- @size to calculate difference
function _entity_utils.downDifferenceToSizeCenter(size)
	return size.height-round((size.height+1)/2)
end

-- -- Existence checking

-- Check if an entity have an attribute,
-- check that if entity is not null too
-- @entity, entity to check attributes
-- @attribute, attribute to check existence
function _entity_utils.entityHasAttribute(entity, attribute)
	if (entity and type(entity) == "table") or type(attribute) == "string" then
		local no_err, _ = pcall(function() return entity[attribute] end)
		return no_err
	end
	return nil
end

--Check if entity has fluidbox,
-- check that if entity is not null too
-- @entity, entity to check fluidbox
function _entity_utils.entityHasFluidbox(entity)
	if entity and type(entity) == "table" then
		local fluidbox = entity.fluidbox
		return fluidbox and #fluidbox > 0
	end
end

return _entity_utils