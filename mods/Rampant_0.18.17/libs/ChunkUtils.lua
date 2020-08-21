if chunkUtilsG then
    return chunkUtilsG
end
local chunkUtils = {}

-- imports

local stringUtils = require("StringUtils")
local baseUtils = require("BaseUtils")
local constants = require("Constants")
local mapUtils = require("MapUtils")
local chunkPropertyUtils = require("ChunkPropertyUtils")

-- constants

local HIVE_BUILDINGS_TYPES = constants.HIVE_BUILDINGS_TYPES

local CHUNK_SIZE_DIVIDER = constants.CHUNK_SIZE_DIVIDER
local DEFINES_WIRE_TYPE_RED = defines.wire_type.red
local DEFINES_WIRE_TYPE_GREEN = defines.wire_type.green

local CHUNK_PASS_THRESHOLD = constants.CHUNK_PASS_THRESHOLD

local AI_STATE_ONSLAUGHT = constants.AI_STATE_ONSLAUGHT

local BASE_PHEROMONE = constants.BASE_PHEROMONE
local PLAYER_PHEROMONE = constants.PLAYER_PHEROMONE
local RESOURCE_PHEROMONE = constants.RESOURCE_PHEROMONE
local BUILDING_PHEROMONES = constants.BUILDING_PHEROMONES

local CHUNK_SIZE = constants.CHUNK_SIZE
local CHUNK_SIZE_DIVIDER = constants.CHUNK_SIZE_DIVIDER

local CHUNK_NORTH_SOUTH = constants.CHUNK_NORTH_SOUTH
local CHUNK_EAST_WEST = constants.CHUNK_EAST_WEST

local CHUNK_ALL_DIRECTIONS = constants.CHUNK_ALL_DIRECTIONS
local CHUNK_IMPASSABLE = constants.CHUNK_IMPASSABLE

local RESOURCE_NORMALIZER = constants.RESOURCE_NORMALIZER

local CHUNK_TICK = constants.CHUNK_TICK

local GENERATOR_PHEROMONE_LEVEL_1 = constants.GENERATOR_PHEROMONE_LEVEL_1
local GENERATOR_PHEROMONE_LEVEL_2 = constants.GENERATOR_PHEROMONE_LEVEL_2
local GENERATOR_PHEROMONE_LEVEL_3 = constants.GENERATOR_PHEROMONE_LEVEL_3
local GENERATOR_PHEROMONE_LEVEL_4 = constants.GENERATOR_PHEROMONE_LEVEL_4
local GENERATOR_PHEROMONE_LEVEL_5 = constants.GENERATOR_PHEROMONE_LEVEL_5
local GENERATOR_PHEROMONE_LEVEL_6 = constants.GENERATOR_PHEROMONE_LEVEL_6

-- imported functions

local isRampant = stringUtils.isRampant
local setNestCount = chunkPropertyUtils.setNestCount
local setPlayerBaseGenerator = chunkPropertyUtils.setPlayerBaseGenerator
local addPlayerBaseGenerator = chunkPropertyUtils.addPlayerBaseGenerator
local setResourceGenerator = chunkPropertyUtils.setResourceGenerator
local addResourceGenerator = chunkPropertyUtils.addResourceGenerator
local setHiveCount = chunkPropertyUtils.setHiveCount
local setTrapCount = chunkPropertyUtils.setTrapCount
local setTurretCount = chunkPropertyUtils.setTurretCount
local setUtilityCount = chunkPropertyUtils.setUtilityCount
local getPlayerBaseGenerator = chunkPropertyUtils.getPlayerBaseGenerator
local getNestCount = chunkPropertyUtils.getNestCount
local getHiveCount = chunkPropertyUtils.getHiveCount
local getTrapCount = chunkPropertyUtils.getTrapCount
local getUtilityCount = chunkPropertyUtils.getUtilityCount
local getTurretCount = chunkPropertyUtils.getTurretCount
local setRaidNestActiveness = chunkPropertyUtils.setRaidNestActiveness
local setNestActiveness = chunkPropertyUtils.setNestActiveness

local processNestActiveness = chunkPropertyUtils.processNestActiveness

local getEnemyStructureCount = chunkPropertyUtils.getEnemyStructureCount

local findNearbyBase = baseUtils.findNearbyBase
local createBase = baseUtils.createBase

local upgradeEntity = baseUtils.upgradeEntity

local setChunkBase = chunkPropertyUtils.setChunkBase
local setPassable = chunkPropertyUtils.setPassable
local setPathRating = chunkPropertyUtils.setPathRating

local getChunkByXY = mapUtils.getChunkByXY

local mMin = math.min
local mMax = math.max
local mFloor = math.floor

local mRandom = math.random

-- module code

local function getEntityOverlapChunks(map, entity)
    local boundingBox = entity.prototype.collision_box or entity.prototype.selection_box;
    local overlapArray = map.chunkOverlapArray

    overlapArray[1] = -1 --LeftTop
    overlapArray[2] = -1 --RightTop
    overlapArray[3] = -1 --LeftBottom
    overlapArray[4] = -1 --RightBottom

    if boundingBox then
        local center = entity.position
        local topXOffset
        local topYOffset

        local bottomXOffset
        local bottomYOffset

        topXOffset = boundingBox.left_top.x
        topYOffset = boundingBox.left_top.y
        bottomXOffset = boundingBox.right_bottom.x
        bottomYOffset = boundingBox.right_bottom.y

        local leftTopChunkX = mFloor((center.x + topXOffset) * CHUNK_SIZE_DIVIDER) * CHUNK_SIZE
        local leftTopChunkY = mFloor((center.y + topYOffset) * CHUNK_SIZE_DIVIDER) * CHUNK_SIZE

        local rightTopChunkX = mFloor((center.x + bottomXOffset) * CHUNK_SIZE_DIVIDER) * CHUNK_SIZE
        local leftBottomChunkY = mFloor((center.y + bottomYOffset) * CHUNK_SIZE_DIVIDER) * CHUNK_SIZE

        overlapArray[1] = getChunkByXY(map, leftTopChunkX, leftTopChunkY) -- LeftTop
        if (leftTopChunkX ~= rightTopChunkX) then
            overlapArray[2] = getChunkByXY(map, rightTopChunkX, leftTopChunkY) -- RightTop
        end
        if (leftTopChunkY ~= leftBottomChunkY) then
            overlapArray[3] = getChunkByXY(map, leftTopChunkX, leftBottomChunkY) -- LeftBottom
        end
        if (leftTopChunkX ~= rightTopChunkX) and (leftTopChunkY ~= leftBottomChunkY) then
            overlapArray[4] = getChunkByXY(map, rightTopChunkX, leftBottomChunkY) -- RightBottom
        end
    end
    return overlapArray
end

local function scanPaths(chunk, surface, map)
    local pass = CHUNK_IMPASSABLE

    local x = chunk.x
    local y = chunk.y

    local filteredEntitiesCliffQuery = map.filteredEntitiesCliffQuery
    local filteredTilesPathQuery = map.filteredTilesPathQuery
    local count_entities_filtered = surface.count_entities_filtered
    local count_tiles_filtered = surface.count_tiles_filtered

    local passableNorthSouth = false
    local passableEastWest = false

    local topPosition = filteredEntitiesCliffQuery.area[1]
    local bottomPosition = filteredEntitiesCliffQuery.area[2]
    topPosition[2] = y
    bottomPosition[2] = y + 32

    for xi=x, x + 32 do
        topPosition[1] = xi
        bottomPosition[1] = xi + 1
        if (count_entities_filtered(filteredEntitiesCliffQuery) == 0) and
            (count_tiles_filtered(filteredTilesPathQuery) == 0)
        then
            passableNorthSouth = true
            break
        end
    end

    topPosition[1] = x
    bottomPosition[1] = x + 32

    for yi=y, y + 32 do
        topPosition[2] = yi
        bottomPosition[2] = yi + 1
        if (count_entities_filtered(filteredEntitiesCliffQuery) == 0) and
            (count_tiles_filtered(filteredTilesPathQuery) == 0)
        then
            passableEastWest = true
            break
        end
    end

    if passableEastWest and passableNorthSouth then
        pass = CHUNK_ALL_DIRECTIONS
    elseif passableEastWest then
        pass = CHUNK_EAST_WEST
    elseif passableNorthSouth then
        pass = CHUNK_NORTH_SOUTH
    end
    return pass
end

local function scorePlayerBuildings(surface, map)
    if surface.count_entities_filtered(map.hasPlayerStructuresQuery) > 0 then
        return (surface.count_entities_filtered(map.filteredEntitiesPlayerQueryLowest) * GENERATOR_PHEROMONE_LEVEL_1) +
            (surface.count_entities_filtered(map.filteredEntitiesPlayerQueryLow) * GENERATOR_PHEROMONE_LEVEL_3) +
            (surface.count_entities_filtered(map.filteredEntitiesPlayerQueryHigh) * GENERATOR_PHEROMONE_LEVEL_5) +
            (surface.count_entities_filtered(map.filteredEntitiesPlayerQueryHighest) * GENERATOR_PHEROMONE_LEVEL_6)
    end
    return 0
end

function chunkUtils.initialScan(chunk, surface, map, tick, rebuilding)
    local waterTiles = (1 - (surface.count_tiles_filtered(map.filteredTilesQuery) * 0.0009765625)) * 0.80
    local natives = map.natives
    local enemyBuildings = surface.find_entities_filtered(map.filteredEntitiesEnemyStructureQuery)

    if (waterTiles >= CHUNK_PASS_THRESHOLD) or (#enemyBuildings > 0) then
        local neutralObjects = mMax(0, mMin(1 - (surface.count_entities_filtered(map.filteredEntitiesChunkNeutral) * 0.005), 1) * 0.20)
        local pass = scanPaths(chunk, surface, map)

        local playerObjects = scorePlayerBuildings(surface, map)

        if ((playerObjects > 0) or (#enemyBuildings > 0)) and (pass == CHUNK_IMPASSABLE) then
            pass = CHUNK_ALL_DIRECTIONS
        end

        if (pass ~= CHUNK_IMPASSABLE) then
            local resources = surface.count_entities_filtered(map.countResourcesQuery) * RESOURCE_NORMALIZER

            local buildingHiveTypeLookup = natives.buildingHiveTypeLookup
            local counts = map.chunkScanCounts
            for i=1,#HIVE_BUILDINGS_TYPES do
                counts[HIVE_BUILDINGS_TYPES[i]] = 0
            end

            if (#enemyBuildings > 0) then
                if natives.newEnemies then
                    local base = findNearbyBase(map, chunk)
                    if base then
                        setChunkBase(map, chunk, base)
                    else
                        base = createBase(natives, chunk, tick, rebuilding)
                    end
                    local alignment = base.alignment

                    local unitList = surface.find_entities_filtered(map.filteredEntitiesUnitQuery)
                    for i=1,#unitList do
                        local unit = unitList[i]
                        if (unit.valid) then
                            unit.destroy()
                        end
                    end

                    for i = 1, #enemyBuildings do
                        local enemyBuilding = enemyBuildings[i]
                        if not isRampant(enemyBuilding.name) then
                            local newEntity = upgradeEntity(enemyBuilding, surface, alignment, natives, nil, true)
                            if newEntity then
                                local hiveType = buildingHiveTypeLookup[newEntity.name]
                                counts[hiveType] = counts[hiveType] + 1
                            end
                        else
                            local hiveType = buildingHiveTypeLookup[enemyBuilding.name] or
                                (((enemyBuilding.type == "turret") and "turret") or "biter-spawner")
                            counts[hiveType] = counts[hiveType] + 1
                        end
                    end

                    setNestCount(map, chunk, counts["spitter-spawner"] + counts["biter-spawner"])
                    setUtilityCount(map, chunk, counts["utility"])
                    setHiveCount(map, chunk, counts["hive"])
                    setTrapCount(map, chunk, counts["trap"])
                    setTurretCount(map, chunk, counts["turret"])
                else
                    for i=1,#enemyBuildings do
                        local building = enemyBuildings[i]
                        local hiveType = buildingHiveTypeLookup[building.name] or (((building.type == "turret") and "turret") or "biter-spawner")
                        counts[hiveType] = counts[hiveType] + 1
                    end

                    setNestCount(map, chunk, counts["spitter-spawner"] + counts["biter-spawner"])
                    setUtilityCount(map, chunk, counts["utility"])
                    setHiveCount(map, chunk, counts["hive"])
                    setTrapCount(map, chunk, counts["trap"])
                    setTurretCount(map, chunk, counts["turret"])
                end
            end

            setPlayerBaseGenerator(map, chunk, playerObjects)
            setResourceGenerator(map, chunk, resources)

            setPassable(map, chunk, pass)
            setPathRating(map, chunk, waterTiles + neutralObjects)

            return chunk
        end
    end

    return -1
end

function chunkUtils.chunkPassScan(chunk, surface, map)
    local waterTiles = (1 - (surface.count_tiles_filtered(map.filteredTilesQuery) * 0.0009765625)) * 0.80

    if (waterTiles >= CHUNK_PASS_THRESHOLD) then
        local neutralObjects = mMax(0, mMin(1 - (surface.count_entities_filtered(map.filteredEntitiesChunkNeutral) * 0.005), 1) * 0.20)
        local pass = scanPaths(chunk, surface, map)

        local playerObjects = getPlayerBaseGenerator(map, chunk)

        local nests = getNestCount(map, chunk)

        if ((playerObjects > 0) or (nests > 0)) and (pass == CHUNK_IMPASSABLE) then
            pass = CHUNK_ALL_DIRECTIONS
        end

        setPassable(map, chunk, pass)
        setPathRating(map, chunk, waterTiles + neutralObjects)

        return chunk
    end

    return -1
end

function chunkUtils.mapScanPlayerChunk(chunk, surface, map)
    local playerObjects = scorePlayerBuildings(surface, map)
    setPlayerBaseGenerator(map, chunk, playerObjects)
end

function chunkUtils.mapScanResourceChunk(chunk, surface, map)
    local resources = surface.count_entities_filtered(map.countResourcesQuery) * RESOURCE_NORMALIZER
    setResourceGenerator(map, chunk, resources)
    local waterTiles = (1 - (surface.count_tiles_filtered(map.filteredTilesQuery) * 0.0009765625)) * 0.80
    local neutralObjects = mMax(0, mMin(1 - (surface.count_entities_filtered(map.filteredEntitiesChunkNeutral) * 0.005), 1) * 0.20)
    setPathRating(map, chunk, waterTiles + neutralObjects)
end

function chunkUtils.mapScanEnemyChunk(chunk, surface, map)
    local buildingHiveTypeLookup = map.natives.buildingHiveTypeLookup
    local buildings = surface.find_entities_filtered(map.filteredEntitiesEnemyStructureQuery)
    local counts = map.chunkScanCounts
    for i=1,#HIVE_BUILDINGS_TYPES do
        counts[HIVE_BUILDINGS_TYPES[i]] = 0
    end
    for i=1,#buildings do
        local building = buildings[i]
        local hiveType = buildingHiveTypeLookup[building.name] or (((building.type == "turret") and "turret") or "biter-spawner")
        counts[hiveType] = counts[hiveType] + 1
    end

    setNestCount(map, chunk, counts["spitter-spawner"] + counts["biter-spawner"])
    setUtilityCount(map, chunk, counts["utility"])
    setHiveCount(map, chunk, counts["hive"])
    setTrapCount(map, chunk, counts["trap"])
    setTurretCount(map, chunk, counts["turret"])
end

function chunkUtils.entityForPassScan(map, entity)
    local overlapArray = getEntityOverlapChunks(map, entity)

    for i=1,#overlapArray do
        local chunk = overlapArray[i]
        if (chunk ~= -1) then
            map.chunkToPassScan[chunk] = true
        end
    end
end

function chunkUtils.createChunk(topX, topY)
    local chunk = {
        x = topX,
        y = topY
    }
    chunk[BASE_PHEROMONE] = 0
    chunk[PLAYER_PHEROMONE] = 0
    chunk[RESOURCE_PHEROMONE] = 0
    chunk[CHUNK_TICK] = 0

    return chunk
end

function chunkUtils.colorChunk(chunk, surface, color)
    local lx = math.floor(chunk.x * CHUNK_SIZE_DIVIDER) * CHUNK_SIZE
    local ly = math.floor(chunk.y * CHUNK_SIZE_DIVIDER) * CHUNK_SIZE

    local graphicId = rendering.draw_rectangle({
            color = color or {0.1, 0.3, 0.1, 0.6},
            width = 32 * 32,
            filled = true,
            left_top = {lx, ly},
            right_bottom = {lx+32, ly+32},
            surface = surface,
            time_to_live = 180,
            draw_on_ground = true,
            visible = true
    })
end

function chunkUtils.colorXY(x, y, surface, color)
    local lx = math.floor(x * CHUNK_SIZE_DIVIDER) * CHUNK_SIZE
    local ly = math.floor(y * CHUNK_SIZE_DIVIDER) * CHUNK_SIZE

    local graphicId = rendering.draw_rectangle({
            color = color or {0.1, 0.3, 0.1, 0.6},
            width = 32 * 32,
            filled = true,
            left_top = {lx, ly},
            right_bottom = {lx+32, ly+32},
            surface = surface,
            time_to_live = 180,
            draw_on_ground = true,
            visible = true
    })
end


function chunkUtils.registerEnemyBaseStructure(map, entity, base, surface)
    local entityType = entity.type
    if ((entityType == "unit-spawner") or (entityType == "turret")) and (entity.force.name == "enemy") then
        local overlapArray = getEntityOverlapChunks(map, entity)

        local natives = map.natives
        local getFunc
        local setFunc
        local hiveTypeLookup = natives.buildingHiveTypeLookup
        local hiveType = hiveTypeLookup[entity.name]
        if (hiveType == "spitter-spawner") or (hiveType == "biter-spawner") then
            natives.builtEnemyBuilding = natives.builtEnemyBuilding + 1
            getFunc = getNestCount
            setFunc = setNestCount
        elseif (hiveType == "turret") then
            natives.builtEnemyBuilding = natives.builtEnemyBuilding + 1
            getFunc = getTurretCount
            setFunc = setTurretCount
        elseif (hiveType == "trap") then
            getFunc = getTrapCount
            setFunc = setTrapCount
        elseif (hiveType == "utility") then
            natives.builtEnemyBuilding = natives.builtEnemyBuilding + 1
            getFunc = getUtilityCount
            setFunc = setUtilityCount
        elseif (hiveType == "hive") then
            natives.builtEnemyBuilding = natives.builtEnemyBuilding + 1
            getFunc = getHiveCount
            setFunc = setHiveCount
        else
            if (entityType == "turret") then
                natives.builtEnemyBuilding = natives.builtEnemyBuilding + 1
                getFunc = getTurretCount
                setFunc = setTurretCount
            elseif (entityType == "unit-spawner") then
                natives.builtEnemyBuilding = natives.builtEnemyBuilding + 1
                getFunc = getNestCount
                setFunc = setNestCount
            end
        end

        for i=1,#overlapArray do
            local chunk = overlapArray[i]
            if (chunk ~= -1) then
                setFunc(map, chunk, getFunc(map, chunk) + 1)
                setChunkBase(map, chunk, base)
                processNestActiveness(map, chunk, natives, surface)
            end
        end
    end

    return entity
end

function chunkUtils.unregisterEnemyBaseStructure(map, entity)
    local entityType = entity.type
    if ((entityType == "unit-spawner") or (entityType == "turret")) and (entity.force.name == "enemy") then
        local overlapArray = getEntityOverlapChunks(map, entity)

        local natives = map.natives
        local getFunc
        local setFunc
        local hiveTypeLookup = map.natives.buildingHiveTypeLookup
        local hiveType = hiveTypeLookup[entity.name]
        if (hiveType == "spitter-spawner") or (hiveType == "biter-spawner") then
            natives.lostEnemyBuilding = natives.lostEnemyBuilding + 1
            getFunc = getNestCount
            setFunc = setNestCount
        elseif (hiveType == "turret") then
            natives.lostEnemyBuilding = natives.lostEnemyBuilding + 1
            getFunc = getTurretCount
            setFunc = setTurretCount
        elseif (hiveType == "trap") then
            getFunc = getTrapCount
            setFunc = setTrapCount
        elseif (hiveType == "utility") then
            natives.lostEnemyBuilding = natives.lostEnemyBuilding + 1
            getFunc = getUtilityCount
            setFunc = setUtilityCount
        elseif (hiveType == "hive") then
            natives.lostEnemyBuilding = natives.lostEnemyBuilding + 1
            getFunc = getHiveCount
            setFunc = setHiveCount
        else
            if (entityType == "turret") then
                natives.lostEnemyBuilding = natives.lostEnemyBuilding + 1
                getFunc = getTurretCount
                setFunc = setTurretCount
            elseif (entityType == "unit-spawner") then
                hiveType = "biter-spawner"
                natives.lostEnemyBuilding = natives.lostEnemyBuilding + 1
                getFunc = getNestCount
                setFunc = setNestCount
            end
        end

        for i=1,#overlapArray do
            local chunk = overlapArray[i]
            if (chunk ~= -1) then
                local count = getFunc(map, chunk)
                if count then
                    if (count <= 1) then
                        if (hiveType == "spitter-spawner") or (hiveType == "biter-spawner") then
                            setRaidNestActiveness(map, chunk, 0)
                            setNestActiveness(map, chunk, 0)
                        end
                        setFunc(map, chunk, 0)
                        if (getEnemyStructureCount(map, chunk) == 0) then
                            setChunkBase(map, chunk, nil)
                        end
                    else
                        setFunc(map, chunk, count - 1)
                    end
                end
            end
        end

    end
end

function chunkUtils.accountPlayerEntity(entity, natives, addObject, creditNatives)
    if (BUILDING_PHEROMONES[entity.type] ~= nil) and (entity.force.name ~= "enemy") then
        local map = natives.map
        local entityValue = BUILDING_PHEROMONES[entity.type]

        local overlapArray = getEntityOverlapChunks(map, entity)
        if not addObject then
            if creditNatives then
                natives.destroyPlayerBuildings = natives.destroyPlayerBuildings + 1
                if (natives.state == AI_STATE_ONSLAUGHT) then
                    natives.points = natives.points + entityValue
                else
                    natives.points = natives.points + (entityValue * 0.12)
                end
            end
            entityValue = -entityValue
        end

        for i=1,#overlapArray do
            local chunk = overlapArray[i]
            if (chunk ~= -1) then
                addPlayerBaseGenerator(map, chunk, entityValue)
            end
        end
    end
    return entity
end

function chunkUtils.unregisterResource(entity, map)
    if entity.prototype.infinite_resource then
        return
    end
    local overlapArray = getEntityOverlapChunks(map, entity)

    for i=1,#overlapArray do
        local chunk = overlapArray[i]
        if (chunk ~= -1) then
            addResourceGenerator(map, chunk, -RESOURCE_NORMALIZER)
        end
    end
end

function chunkUtils.registerResource(entity, map)
    local overlapArray = getEntityOverlapChunks(map, entity)

    for i=1,#overlapArray do
        local chunk = overlapArray[i]
        if (chunk ~= -1) then
            addResourceGenerator(map, chunk, RESOURCE_NORMALIZER)
        end
    end
end

function chunkUtils.makeImmortalEntity(surface, entity)
    local repairPosition = entity.position
    local repairName = entity.name
    local repairForce = entity.force
    local repairDirection = entity.direction

    local wires
    if (entity.type == "electric-pole") then
        wires = entity.neighbours
    end
    entity.destroy()
    local newEntity = surface.create_entity({position=repairPosition,
                                             name=repairName,
                                             direction=repairDirection,
                                             force=repairForce})
    if wires then
        for _,v in pairs(wires.copper) do
            if (v.valid) then
                newEntity.connect_neighbour(v);
            end
        end
        for _,v in pairs(wires.red) do
            if (v.valid) then
                newEntity.connect_neighbour({wire = DEFINES_WIRE_TYPE_RED, target_entity = v});
            end
        end
        for _,v in pairs(wires.green) do
            if (v.valid) then
                newEntity.connect_neighbour({wire = DEFINES_WIRE_TYPE_GREEN, target_entity = v});
            end
        end
    end

    newEntity.destructible = false
end

chunkUtilsG = chunkUtils
return chunkUtils
