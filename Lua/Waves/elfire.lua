-- a series of bullets, starting from the left and right, that hurl downwards at an angle.
spawntimer = 0
left_right = 0
fire_bullets = {}
ground_bullets = {}

function randRange(low, high)
    return math.random(low*10, high*10)/10.0
end

function Update()

    spawntimer = spawntimer + 1
    if spawntimer%30 == 0 then --every 30 frames, create a bullet
        local posx = 0
        if left_right % 2 == 0 then --left
            posx = -Arena.width/2 
        else
            posx = Arena.width/2 --right 
        end
        local posy = randRange(0.8,1)*Arena.height/2
        local bullet = CreateProjectile('orb', posx, posy)
        local velx = 0
        if left_right % 2 == 0 then
            velx = (1 - randRange(0, 0.6)) --only go right
        else
            velx = (randRange(0, 0.6) - 1) --only go left
        end
        velx = velx * 2.0 * randRange(0.8,1)
        bullet.SetVar('velx', velx)
        bullet.SetVar('vely', -1.1*randRange(0.75, 1))
        bullet.SetVar('start_time', spawntimer)

        left_right = left_right + 1
        table.insert(fire_bullets, bullet)
    end

    for i=1,#fire_bullets do
        local bullet = fire_bullets[i]
        if bullet.isactive == true then
            local velx = bullet.GetVar('velx')
            local vely = bullet.GetVar('vely')
            local newposx = bullet.x + velx
            local newposy = bullet.y + vely
            
            if spawntimer - bullet.GetVar('start_time') > 20 and (bullet.x < -Arena.width/2 + 8 or bullet.x > Arena.width/2 - 8) then
                bullet.Remove()
            elseif (bullet.y < -Arena.height/2 + 8) then -- if at the bottom
                local ground_bullet = CreateProjectile('flame', bullet.x, bullet.y)
                ground_bullet.SetVar('time', 0)
                table.insert(ground_bullets, ground_bullet)
                bullet.Remove()
            else
                bullet.MoveTo(newposx, newposy)
                bullet.SetVar('vely', vely)
            end
        end
    end
    for i=1, #ground_bullets do
        local bullet = ground_bullets[i]
        if bullet.isactive == true then
            bullet.SetVar('time', bullet.GetVar('time')+1)
            if bullet.GetVar('time') % 130 == 0 then --keep alive for 130 frames
                bullet.Remove()
            end
        end
    end
end