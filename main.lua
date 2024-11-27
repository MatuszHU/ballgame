local love = require "love"
local enemy = require "Enemies"
local button = require "Button"

math.randomseed(os.time())

local game = {
    difficulty = 1,
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    },
    point = 0,
    level = {15,30,60,120}
}

local font = {
    small = {
        font = love.graphics.newFont(8),
        size = 8
    },
    medium = {
        font = love.graphics.newFont(16),
        size = 16
    },
    large = {
        font = love.graphics.newFont(30),
        size = 30
    },
    massive = {
        font = love.graphics.newFont(60),
        size = 60
    }
}
local player = {
    radius = 20,
    x = 30,
    y = 30
}

local buttons = {
    menu_state = {},
    ended = {}
}

local enemies = {}

local function changeGameState(state)
    game.state["menu"] = state == "menu"
    game.state["paused"] = state == "paused"
    game.state["running"] = state == "running"
    game.state["ended"] = state == "ended"
end

local function startNewGame()
    
    changeGameState("running")
    
    game.point = 0
    
    enemies = {enemy(1)}
end
function love.load()
    love.window.setTitle("Mentsd meg a labdát!")
    
    buttons.menu_state.play = button("Play Game",startNewGame, nil, 120, 40)
    buttons.menu_state.setting = button("Settings",nil, nil, 120, 40)
    buttons.menu_state.exit = button("Exit",love.event.quit, nil, 120, 40)
    
    buttons.ended.again = button("Again",startNewGame, nil, 100, 50)
    buttons.ended.menu = button("Back",changeGameState, "menu", 100, 50)
    buttons.ended.exit = button("Exit",love.event.quit, nil, 100, 50)
    
    love.mouse.setVisible(false)

end

function love.mousepressed(x,y,button,touch,presses)
    if not game.state['running'] then
        if button == 1 then
            if game.state["menu"] then
                for index in pairs(buttons.menu_state) do
                    buttons.menu_state[index]:pressed(x,y, player.radius)
                end 
            elseif game.state["ended"] then
                for index in pairs(buttons.ended) do
                    buttons.ended[index]:pressed(x,y, player.radius)
                end 
            end
        end
    end
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    if game.state["running"] then
        for i = 1, #enemies do
            if not enemies[i]:touch(player.x, player.y, player.radius) then
                enemies[i]:move(player.x, player.y)
                for j = 1, #game.level do
                    if math.floor(game.point) == game.level[i] then
                        table.insert(enemies,1,enemy(game.difficulty*(i+1)))
                        game.point = game.point +1
                    end
                end
            else
                changeGameState("ended")
            end
        end
        game.point = game.point + dt
    end

end
function love.draw()
    love.graphics.setFont(font.medium.font)
    love.graphics.printf("FPS:"..love.timer.getFPS().." Platform: "..love.system.getOS(), font.medium.font,10,love.graphics.getHeight()-30,love.graphics.getWidth())
    
    if game.state["running"] then
        love.graphics.printf(math.floor(game.point), font.large.font ,0, 15, love.graphics.getWidth(), "center")
        for i = 1, #enemies do
            enemies[i]:draw()
        end
        love.graphics.circle("fill", player.x,player.y, player.radius)
    elseif game.state["menu"] then
        buttons.menu_state.play:draw(10,20,17,10)
        buttons.menu_state.setting:draw(10,70,17,10)
        buttons.menu_state.exit:draw(10,120,17,10)
    elseif game.state["ended"] then

        love.graphics.setFont(font.large.font)
        buttons.ended.again:draw(love.graphics.getWidth()/2.25,love.graphics.getHeight()/1.8,10,10)
        buttons.ended.menu:draw(love.graphics.getWidth()/2.25,love.graphics.getHeight()/1.53,17,10)
        buttons.ended.exit:draw(love.graphics.getWidth()/2.25,love.graphics.getHeight()/1.33,22,10)

        love.graphics.printf(math.floor(game.point), font.massive.font, 0, love.graphics.getHeight()/2 - font.massive.size, love.graphics.getWidth(), "center")
    end

    if not game.state["running"] then
        love.graphics.circle("fill", player.x,player.y, player.radius/2)
    end

end