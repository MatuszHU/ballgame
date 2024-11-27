local love = require "love"

function Enemy(level)
    
    local dice = math.random(1,4)
    local _x, _y
    local _radius = 20
    
    if dice == 1 then
        _x = math.random(_radius, love.graphics.getWidth())
        _y = -_radius*4
    
    elseif dice == 2 then
        _x = -_radius*4
        _y = math.random(_radius, love.graphics.getHeight())
    
    elseif dice == 3 then
        _x = math.random(_radius, love.graphics.getWidth())
        _y = love.graphics.getHeight() + (_radius*4)
    
    else
        _x = love.graphics.getWidth() + (_radius*4)
        _y = math.random(_radius, love.graphics.getHeight())
    end

    return {
        level = level or 1,
        radius = _radius,
        x = _x,
        y = _y,
        touch = function(self, playerX, playerY, cursorRadius)
            return math.sqrt((self.x-playerX)^2+(self.y-playerY)^2)<= cursorRadius*2
        end,

        move = function(self, ply_x, ply_y)
            
            if ply_x - self.x > 0 then
                self.x = self.x + self.level
            elseif ply_x - self.x < 0 then
                self.x = self.x - self.level
            end
            
            if ply_y - self.y > 0 then
                self.y = self.y + self.level
            elseif ply_y - self.y < 0 then
                self.y = self.y - self.level
            end
            
        end,
        draw = function(self)
            love.graphics.setColor(255, 255,0,1)
            love.graphics.circle("fill", self.x, self.y, self.radius)
            love.graphics.setColor(255,255,255,1)
        end
    }
end

return  Enemy