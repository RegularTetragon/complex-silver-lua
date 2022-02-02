require "lib/engine/v2"
require "lib/engine/level"

level(v2:new(), v2:new(26, 16))

function love.update(dt)
    for _, system in pairs(systems) do
        for entity, active in pairs(entities) do
            if entity[system] then
                entity[system]:update(entity, old_t and t - old_t or 1 / 30)
            end
        end
    end
    old_t = dt
    cam = player_instance.trans.p
    camera(cam.x - 64 + rnd() * screen_shake, cam.y - 96 + rnd() * screen_shake)
end

function love.draw()
    cls()
    local e_count
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
