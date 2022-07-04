local snakeX = 1
local snakeY = 1

local score = 0
local gameOver = false
local level = 0

local snakeMoving = 'd'
local tileGrid = {}
local snakeTiles = {{snakeX, snakeY}}
local snakeTimer = 0

local largeFont = love.graphics.newFont(32)
local hugeFont = love.graphics.newFont(128)

local appleAudio = love.audio.newSource('apple.wav','static')
local hitAudio = love.audio.newSource('hit.wav','static')


TILE_SIZE = 32

SNAKE_SPEED = 0.07
WINDOW_WIDHT = 1280
WINDOW_HEIGHT = 720

TILE_EMPTY = 0
TILE_SNAKE_HEAD = 1
TILE_SNAKE_BODY = 2
APPLE = 3
TILE_BLOCK = 4


MAX_TILES_X = WINDOW_WIDHT/TILE_SIZE
MAX_TILES_Y = math.floor(WINDOW_HEIGHT/TILE_SIZE) 


function love.load()
    love.window.setTitle('SNAKE')
    love.window.setMode(WINDOW_WIDHT, WINDOW_HEIGHT, {fullscreen = false})

    math.randomseed(os.time())

    initializeGrid()
    initializeSnake()

end

function love.keypressed(key)

    if key == 'escape' then 
        love.event.quit()
     end

     if key == 'a' and snakeMoving ~= 'd' then
        snakeMoving = 'a'

     elseif key == 'd' and snakeMoving ~= 'a' then
        snakeMoving = 'd'

     elseif key == 'w' and snakeMoving ~= 's' then
        snakeMoving = 'w'

     elseif key == 's' and snakeMoving ~= 'w' then
        snakeMoving = 's'

     end

     if gameOver then
        if key == 'enter' or key == 'return' or key == 'space' then
            initializeGrid()
            initializeSnake()
            score = 0
            gameOver = false
        end
     end
end


function love.update(dt)
    if not gameOver then

        local preHeadX, preHeadY = snakeX, snakeY
        snakeTimer = snakeTimer + dt

        if snakeTimer >= SNAKE_SPEED then 
            if snakeMoving == 'a' then
                if snakeX <= 1 then
                    snakeX = MAX_TILES_X
                else
                snakeX = snakeX -1 
                end
            elseif snakeMoving == 'd' then
                if snakeX >= MAX_TILES_X then
                    snakeX = 1
                else
                snakeX = snakeX +1
                end
            elseif snakeMoving == 'w' then
                if snakeY <= 1 then
                    snakeY = MAX_TILES_Y
                else
                snakeY = snakeY -1
                end
            elseif snakeMoving == 's' then
                if snakeY >= MAX_TILES_Y then
                    snakeY = 1
                else

                snakeY = snakeY +1
                end
            end

            table.insert(snakeTiles, 1, {snakeX, snakeY})

            if tileGrid[snakeY][snakeX] == TILE_SNAKE_BODY or 
                tileGrid[snakeY][snakeX] == TILE_BLOCK then
                gameOver = true
                love.audio.play( hitAudio )

            else if tileGrid[snakeY][snakeX] == APPLE then
                
                score = score + 1
                generateStuff(APPLE)
                love.audio.play( appleAudio )
                

            else

                local tail = snakeTiles[#snakeTiles]
                tileGrid[tail[2]][tail[1]] = TILE_EMPTY
                table.remove(snakeTiles)
            end
        end

            if #snakeTiles > 1 then
                tileGrid[preHeadY][preHeadX] = TILE_SNAKE_BODY
            end

           tileGrid[snakeY][snakeX] = TILE_SNAKE_HEAD

            snakeTimer = 0
        end

       
    end
    
end

function love.draw()

   
        drawGrid()
        love.graphics.setFont(largeFont)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print('Score: '.. tostring(score), 0, 0)

        if gameOver then
            drawGameOver()
        end

    
end

function drawGrid()

    for y = 1, MAX_TILES_Y do
        for x = 1, MAX_TILES_X do

            if tileGrid[y][x] == TILE_EMPTY  then
                -- uncomment for showing the grid
              --love.graphics.setColor(1,1,1,1)
              --love.graphics.rectangle('line', (x - 1) * TILE_SIZE, (y - 1)* TILE_SIZE, TILE_SIZE, TILE_SIZE)

            elseif  tileGrid[y][x] == APPLE then
                love.graphics.setColor(1,0,0,1)
                love.graphics.rectangle('fill',(x - 1) * TILE_SIZE, (y - 1)* TILE_SIZE,
                 TILE_SIZE, TILE_SIZE)

            elseif tileGrid[y][x] == TILE_SNAKE_HEAD then
                love.graphics.setColor(0,1,0,1)
                love.graphics.rectangle('fill',(x - 1) * TILE_SIZE, (y - 1)* TILE_SIZE,
                    TILE_SIZE, TILE_SIZE)
            elseif tileGrid[y][x] == TILE_SNAKE_BODY then
                love.graphics.setColor(0,0.5,0,1)
                love.graphics.rectangle('fill',(x - 1) * TILE_SIZE, (y - 1)* TILE_SIZE,
                    TILE_SIZE, TILE_SIZE)
            elseif tileGrid[y][x] == TILE_BLOCK then
                love.graphics.setColor(0.8,0.8,0.8,1)
                love.graphics.rectangle('fill',(x - 1) * TILE_SIZE, (y - 1)* TILE_SIZE,
                    TILE_SIZE, TILE_SIZE)
            end

        end
    end
  
end

function drawGameOver()
    love.graphics.setFont(hugeFont)
    love.graphics.printf('GAME OVER', 0, WINDOW_HEIGHT/2 - 64, WINDOW_WIDHT, 'center')

    love.graphics.setFont(largeFont)
    love.graphics.printf('Press enter to restart', 0, WINDOW_HEIGHT/2 + 96, WINDOW_WIDHT, 'center')

end

function generateStuff(Stuff)
    local stuffX, stuffY

    repeat
        stuffX, stuffY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)

    until tileGrid[stuffY][stuffX] == TILE_EMPTY

    tileGrid[stuffY][stuffX] = Stuff

end

function initializeSnake()

    snakeX, snakeY = 1, 1
    snakeMoving = 'd'
    snakeTiles = {{snakeX, snakeY}}  
    tileGrid[snakeTiles[1][2]][snakeTiles[1][1]] = TILE_SNAKE_HEAD
end

function initializeGrid()
    
    tileGrid = {}
    
    for y = 1, MAX_TILES_Y do
          
        table.insert(tileGrid, {})

        for x = 1, MAX_TILES_X do
            table.insert(tileGrid[y], TILE_EMPTY)
 
        end
    end

    -- for i = 1, 5 do
    --     generateStuff(TILE_BLOCK)
    -- end
    generateStuff(APPLE)
    
end



