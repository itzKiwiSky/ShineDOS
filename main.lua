function love.load()
    terminal = require 'src.components.textEngine'
    command = require 'src.components.command'
    json = require 'libraries.json'
    utf8 = require 'utf8'

    love.filesystem.createDirectory("disk")
    love.filesystem.createDirectory("disk/programs")
    love.filesystem.createDirectory("disk/documents/")
    love.filesystem.createDirectory("disk/temp")


    local moonshine = require 'libraries.moonshine'
    effect = moonshine(moonshine.effects.scanlines).chain(moonshine.effects.crt).chain(moonshine.effects.glow)
    effect.scanlines.opacity=0.6
    effect.glow.min_luma = 0
    effect.glow.strength = 5

    love.keyboard.setKeyRepeat(true)
    terminal.setupOutput("headUpdaisy.ttf", 10, 10, 18, 10, 24)

    math.randomseed(os.time())

    terminal.add({255, 255, 0}, ".::::::::. :::    ::: ::::::::::: ::::    ::: :::::::::: :::::::::    .::::::::. .::::::::.")
    terminal.add({255, 255, 0}, ":+:    :+: :+:    :+:     :+:     :+:+:   :+: :+:        :+:      :+: :+:    :+: :+:    :+:")
    terminal.add({255, 255, 0}, "+:+        +:+    +:+     +:+     :+:+:+  +:+ +:+        +:+      +:+ +:+    +:+ +:+       ")
    terminal.add({255, 255, 0}, "+#++:++#++ +#++:++#++     +#+     +#+ +:+ +#+ +#++:++#   +#+      +:+ +#+    +:+ +#++:++#++")
    terminal.add({255, 255, 0}, "       +#+ +#+    +#+     +#+     +#+  +#+#+# +#+        +#+      +#+ +#+    +#+        +#+")
    terminal.add({255, 255, 0}, "#+#    #+# #+#    #+#     #+#     #+#   #+#+# #+#        #+#      #+# #+#    #+# #+#    #+#")
    terminal.add({255, 255, 0}, " ########  ###    ### ########### ###    #### ########## #########     ########   ######## ")
    terminal.add({255, 255, 0}, "")
    terminal.add({255, 255, 0}, "Version 1.0 | Type 'help' to see all commands")

    cmd = ""
end

function love.draw()
    effect(function() 
        terminal.render()
        love.graphics.print({{255, 255, 255}, table.concat(command.currentDir, "/") .. "/> " .. cmd .. "_"}, 10, love.graphics.getHeight() - (textengine.txtsize + textengine.txtoffset))
    end)

end

function love.update(elapsed)
    terminal.update(elapsed) 
end

function love.textinput(t)
    cmd = cmd .. t
end

function love.keypressed(key)
    if key == "backspace" then
        local byteoffset = utf8.offset(cmd, -1)
        if byteoffset then
            cmd = string.sub(cmd, 1, byteoffset - 1)
        end
    end
    if key == "return" then
        terminal.add({255, 255, 255}, "> " .. cmd)
        command.parse(cmd)
        cmd = ""
    end
end
