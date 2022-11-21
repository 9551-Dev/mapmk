local obj_decode = require("wavefront")

return function(file,w,h,smoothing)
    local data = love.filesystem.read(file)
    local obj_data = obj_decode(data).geometry

    local uv_image = {}

    for vector_index,normal_index in pairs(obj_data.normal_idx) do
        local uv_index = obj_data.uv_idx[vector_index]*2
        local norm_index = normal_index*3

        local u,v = obj_data.uvs[uv_index-1],1-obj_data.uvs[uv_index]
        local x,y,z = obj_data.normals[norm_index-2],obj_data.normals[norm_index-1],obj_data.normals[norm_index]

        local u_scaled = math.ceil(u*w)
        local v_scaled = math.ceil(v*h)

        if not uv_image[v_scaled] then uv_image[v_scaled] = {} end
        uv_image[v_scaled][u_scaled] = {
            0.5+x/2,
            0.5+y/2,
            0.5+z/2
        }
    end

    local image = {}

    for y=1,h do
        image[y] = {}
        for x=1,w do
            local r,g,b  = 0,0,0
            local weight = 0
            for int_y=1,h do
                local layer = uv_image[int_y]
                if layer then for int_x=1,w do
                    local pix = layer[int_x]

                    if pix then
                        local distance = 1/math.max(((int_y-y)^2+(int_x-x)^2),smoothing)
                        weight = weight + distance
                        r = r + pix[1]*distance
                        g = g + pix[2]*distance
                        b = b + pix[3]*distance
                    end
                end end
            end
            image[y][x] = {r/weight,g/weight,b/weight}
        end
    end

    return image
end