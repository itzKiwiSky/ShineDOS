textengine = {}

utilities = require 'src.utilities'

textengine.rom = {}
textengine.paddingX = 10
textengine.paddingY = 10
textengine.txtsize = 15
textengine.txtoffset = 10
textengine.maxList = 35

function textengine.setupOutput(fontName, x, y, size, offset, maxList)
    textengine.paddingX = x or 10
    textengine.paddingY = y or 10
    textengine.txtsize = size or 15
    textengine.txtoffset = offset or 10
    textengine.maxList = maxList or 25
    local font = love.graphics.newFont("resources/fonts/" .. fontName, size)
    love.graphics.setFont(font)
end

function textengine.add(rgbTable, text)
    local text = {
        colors = rgbTable,
        content = text
    }
    table.insert(textengine.rom, text)
end

function textengine.render()
    local txtY = textengine.paddingY
    for txtid = 1, #textengine.rom, 1 do
        r, g, b = utilities.rgbToColor(textengine.rom[txtid].colors[1], textengine.rom[txtid].colors[2], textengine.rom[txtid].colors[3])
        love.graphics.setColor(r, g, b)
        love.graphics.print(textengine.rom[txtid].content, textengine.paddingX, txtY)
        txtY = txtY + (textengine.txtsize + textengine.txtoffset)
        love.graphics.setColor(1, 1, 1)
    end
end

function textengine.update(elapsed)
    textengine.listOffset = #textengine.rom - textengine.maxList
    if #textengine.rom > textengine.maxList then
        table.remove(textengine.rom, 1)
    end
end

return textengine