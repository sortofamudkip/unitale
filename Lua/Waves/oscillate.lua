-- a series of oscillating orbs; the orb firsts starts left/right off-map, then, when the x-axis matches the heart's, it 
--    moves left and right, oscillating back and forth.
spawntimer = 0
left_right = 0
bullets = {}

function randRange(low, high)
    return math.random(low*10, high*10)/10.0
end

function Update()
    spawntimer = spawntimer + 1
    if spawntimer%60 == 0 then 
        local posx = 0
        if left_right % 2 == 0 then --left
            posx = -Arena.width/2 
        else
            posx = Arena.width/2 --right 
        end
        local posy = Arena.height/2 + 10
        local bullet = CreateProjectile('orb', posx, posy)

        bullet.SetVar('velx', 0) --initially moving downward
        bullet.SetVar('vely', -2.5*randRange(0.75, 1))
        bullet.SetVar('found_target', false) -- hasn't found target yet
        bullet.SetVar('start_time', spawntimer)
        bullet.SetVar('left_right', left_right%2)

        left_right = left_right + 1
        table.insert(bullets, bullet)
    end

    for i=1,#bullets do
        local bullet = bullets[i]
        if bullet.GetVar('found_target') == false and math.abs(bullet.y - Player.y) <= 3 then -- make it start oscillating

            if bullet.GetVar('left_right') == 0 then bullet.SetVar('velx', 1) -- go left
            else bullet.SetVar('velx', -1) -- go right
            end
            bullet.SetVar('vely', 0)
            bullet.SetVar('start_time', 0)
            bullet.SetVar('found_target', true) -- hasn't found target yet
        end
    end

    for i = 1, #bullets do
        local bullet = bullets[i]
        local velx = bullet.GetVar('velx')
        local vely = bullet.GetVar('vely')

        if bullet.GetVar('found_target') == true then
            velx = 2.4*(math.cos(2*math.pi/300*(bullet.GetVar('start_time')))) --oscillate every 300 frames
            bullet.SetVar('velx', velx)
            bullet.SetVar('start_time', bullet.GetVar('start_time')+1)
        end

        local newposx = bullet.x + velx
        local newposy = bullet.y + vely
        bullet.MoveTo(newposx, newposy)
        
    end
    -- make it disappear after a while
    -- for i=1, #bullets do
    --     local bullet = ground_bullets[i]
    --     if bullet.isactive == true then
    --         bullet.SetVar('time', bullet.GetVar('time')+1)
    --         if bullet.GetVar('time') % 200 == 0 then --keep alive for 200 frames
    --             bullet.Remove()
    --         end
    --     end
    -- end
end