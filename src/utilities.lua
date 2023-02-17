utilities = {}

function utilities.rgbToColor(r, g, b)
    local R, G, B = love.math.colorFromBytes(r, g, b)
    return R, G, B
end

return utilities