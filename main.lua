local mapmk = require("mapmk")

love.window.setFullscreen(true)

local w,h = 50,50

local scale = 20

local image_data
function love.load()
    love.graphics.setPointSize(scale)
    image_data = mapmk("monke.obj",w,h,1)
end

function love.draw()
    for y=1,h do
        local layer = image_data[y]
        if layer then
            for x=1,w do
                local pixel = layer[x]
                if pixel then
                    love.graphics.setColor(pixel[1],pixel[2],pixel[3],1)
                    love.graphics.points(x*scale,y*scale)
                end
            end
        end
    end
end