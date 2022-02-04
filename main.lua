if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

require "engine.entity"
require "engine.systems"
require "engine.tileset"

require "engine.v2"
require "engine.level"
require "engine.constants"

local untitledLevel = level:load "untitled"
untitledLevel:construct()

local ts = tileset:load "sprites"
local spr = ts:sprite(1)

local t = 0
function love.update(dt)
    t = t + dt
    for _, system in pairs(systems) do
        for entity, active in pairs(entities) do
            if entity[system] then
                entity[system]:update(entity, dt)
            end
        end
    end
end

function love.draw()
    local e_count
    love.graphics.scale(zoom, zoom)
    for _, system in pairs(systems) do
        e_count = 0
        for entity, active in pairs(entities) do
            e_count = e_count + 1
            if entity[system] then
                entity[system]:render(entity)
            end
        end
    end
    if _dbg_systems then
        print("systems:", 0, 0)
        for _, system in pairs(systems) do
            print(system)
        end
        print("entities:", 32, 0)
        print(e_count)
    end
end
