if (chunkProcessorG) then
    return chunkProcessorG
end
local chunkProcessor = {}

-- imports

local chunkUtils = require("ChunkUtils")
local mathUtils = require("MathUtils")
local constants = require("Constants")

-- constants

local CHUNK_SIZE = constants.CHUNK_SIZE

local MAX_TICKS_BEFORE_SORT_CHUNKS = constants.MAX_TICKS_BEFORE_SORT_CHUNKS

-- imported functions

local mapScanEnemyChunk = chunkUtils.mapScanEnemyChunk
local mapScanPlayerChunk = chunkUtils.mapScanPlayerChunk
local mapScanResourceChunk = chunkUtils.mapScanResourceChunk

local createChunk = chunkUtils.createChunk
local initialScan = chunkUtils.initialScan
local chunkPassScan = chunkUtils.chunkPassScan

local euclideanDistanceNamed = mathUtils.euclideanDistanceNamed

local tSort = table.sort

local abs = math.abs
local next = next
local table_size = table_size

local tRemove = table.remove

-- module code

local origin = {x=0,y=0}

local function sorter(a, b)
    local aDistance = euclideanDistanceNamed(a, origin)
    local bDistance = euclideanDistanceNamed(b, origin)

    if (aDistance == bDistance) then
        if (a.x == b.x) then
            return (abs(a.y) < abs(b.y))
        else
            return (abs(a.x) < abs(b.x))
        end
    end

    return (aDistance < bDistance)
end

function chunkProcessor.processPendingChunks(map, surface, tick, rebuilding, flush)
    local processQueue = map.processQueue
    local pendingChunks = map.pendingChunks

    local area = map.area

    local topOffset = area[1]
    local bottomOffset = area[2]

    local event = next(pendingChunks, map.chunkProcessorIterator)
    local endCount = 5
    if flush then
        endCount = table_size(pendingChunks)
    end
    for i=1,endCount do
        if not event then
            map.chunkProcessorIterator = nil
            if (table_size(pendingChunks) == 0) then
                -- this is needed as the next command remembers the max length a table has been
                map.pendingChunks = {}
            end
            break
        else
            local topLeft = event.area.left_top
            local x = topLeft.x
            local y = topLeft.y

            topOffset[1] = x
            topOffset[2] = y
            bottomOffset[1] = x + CHUNK_SIZE
            bottomOffset[2] = y + CHUNK_SIZE

            if map[x] and map[x][y] then
                local chunk = map[x][y]
                mapScanPlayerChunk(chunk, surface, map)
                mapScanEnemyChunk(chunk, surface, map)
                mapScanResourceChunk(chunk, surface, map)
            else
                if map[x] == nil then
                    map[x] = {}
                end

                local chunk = createChunk(x, y)

                chunk = initialScan(chunk, surface, map, tick, rebuilding)

                if (chunk ~= -1) then
                    map[x][y] = chunk
                    processQueue[#processQueue+1] = chunk
                end
            end
            local newEvent,_ = next(pendingChunks, event)
            pendingChunks[event] = nil
            event = newEvent
        end

    end
    map.chunkProcessorIterator = event

    if (#processQueue > map.nextChunkSort) or
        (((tick - map.nextChunkSortTick) > MAX_TICKS_BEFORE_SORT_CHUNKS) and
                ((map.nextChunkSort - 150) < #processQueue))
    then
        map.nextChunkSort = #processQueue + 150
        map.nextChunkSortTick = tick
        tSort(processQueue, sorter)
    end
end

function chunkProcessor.processScanChunks(map, surface)
    local area = map.area

    local topOffset = area[1]
    local bottomOffset = area[2]

    local removals = map.chunkRemovals

    local chunkCount = 0

    local chunkToPassScan = map.chunkToPassScan

    for chunk,_ in pairs(chunkToPassScan) do
        local x = chunk.x
        local y = chunk.y

        topOffset[1] = x
        topOffset[2] = y
        bottomOffset[1] = x + CHUNK_SIZE
        bottomOffset[2] = y + CHUNK_SIZE

        chunk = chunkPassScan(chunk, surface, map)

        if (chunk == -1) then
            map[x][y] = nil

            chunkCount = chunkCount + 1
            removals[chunkCount] = chunk
        end

        chunkToPassScan[chunk] = nil
    end

    if (chunkCount > 0) then
        local processQueue = map.processQueue
        for i=#processQueue,1,-1 do
            for ri=chunkCount,1,-1 do
                if (removals[ri] == processQueue[i]) then
                    tRemove(processQueue, i)
                    -- tRemove(removals, ri)
                    break
                end
            end
        end
    end
end

chunkProcessorG = chunkProcessor
return chunkProcessor
