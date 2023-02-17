command = {}

command.currentDir = {"disk"}

stringx = require 'pl.stringx'

function command.parse(CMD)
    commandToken = stringx.split(CMD, " ")
    if commandToken[1] == "ld" then
        local items = love.filesystem.getDirectoryItems(table.concat(command.currentDir, "/"))
        --print(debugcomponent.showTableContent(items))
        terminal.add({255, 255, 0}, "Currently on drive " .. table.concat(command.currentDir, "/"))
        terminal.add({255, 255, 0}, "Listing all items from this folder")
        terminal.add({255, 255, 0}, "-----------------------------------")
        for i = 1, #items, 1 do
            local info = love.filesystem.getInfo(table.concat(command.currentDir, "/") .. "/" .. items[i])
            --print(debugcomponent.showTableContent(info))
            if info.type == "file" then
                terminal.add({255, 255, 0}, "[FILE]   | " .. items[i] .. "  /  " .. info.size .. " bytes") 
            end
            if info.type == "directory" then
                terminal.add({255, 255, 0}, "[FOLDER] | " .. items[i]) 
            end
        end
    elseif commandToken[1] == "help" then
        local page
        local help = {
            {
                "ld | List directories",
                "help | Help message",
                "out | write text on screen",
                "nwdir | Create new directory",
                "nwfile | create new file",
                "del | Delete a file or a directory",
                "clean | clear the screen",
                "run | Run a program"
            },
        }
        if commandToken[2] == nil then
            page = 1
        else
            page = commandToken[2]
        end
        for hi = 1, #help[page], 1 do
            terminal.add({0, 255, 0}, help[page][hi])
        end
        
    elseif commandToken[1] == "out" then
        if commandToken[2] ~= nil then
            tokens = {}
            for i = 2, #commandToken, 1 do
                table.insert(tokens, commandToken[i])
            end
            terminal.add({255, 255, 255}, table.concat(tokens, " "))
        end
    elseif commandToken[1] == "nwdir" then
        if commandToken[2] == nil then
            terminal.add({255, 0, 0}, "[ERROR] | Invalid name")
        else
            local sucess = love.filesystem.createDirectory(table.concat(command.currentDir, "/") .. "/" ..  commandToken[2])
            if not sucess then
                terminal.add({255, 0, 0}, "[ERROR] | An error has occured during the execution of this command!")
            end
        end
    elseif commandToken[1] == "nwfile" then
        if commandToken[2] == nil then
            terminal.add({255, 0, 0}, "[ERROR] | Invalid name")
        else
            local sucess = love.filesystem.newFile(table.concat(command.currentDir, "/") .. "/" .. commandToken[2], "w")
            if sucess == nil then
                terminal.add({255, 0, 0}, "[ERROR] | An error has occured during the execution of this command!")
            else
                sucess:close()
            end
        end
    elseif commandToken[1] == "del" then
        if commandToken[2] == nil then
            terminal.add({255, 0, 0}, "[ERROR] | Invalid name")
        else
            local sucess = love.filesystem.remove(table.concat(command.currentDir, "/") .. "/" .. commandToken[2])
            if not sucess then
                terminal.add({255, 0, 0}, "[ERROR] | An error has occured during the execution of this command!")
            end
        end
    elseif commandToken[1] == "clean" then
        terminal.rom = {}
    elseif commandToken[1] == "cd" then
        if commandToken[2] == nil then
        elseif commandToken[2] == ".." then
            if #command.currentDir == 1 then
                terminal.add({255, 0, 0}, "[ERROR] | failed to run this command!")
            else
                table.remove(command.currentDir, #command.currentDir)
            end
        elseif commandToken[2] == "//" then
            terminal.add({255, 255, 255}, table.concat(command.currentDir, "/"))
        else
            local dirInfo = love.filesystem.getInfo(table.concat(command.currentDir, "/") .. "/" .. commandToken[2])
            if dirInfo == nil then
                terminal.add({255, 0, 0}, "[ERROR] | Invalid directory name!")
            else
                table.insert(command.currentDir, commandToken[2])
            end
        end
    elseif commandToken[1] == "run" then
        if commandToken[2] == nil then
            terminal.add({255, 0, 0}, "[ERROR] | Can't run a null program")
        else    
            code, error = love.filesystem.load(table.concat(command.currentDir, "/") .. "/" .. commandToken[2] .. ".lua")
            if error ~= nil then
                terminal.add({255, 0, 0}, "[ERROR] | Invalid program or is not installed yet!")
            else
                Error = pcall(code(), Command(commandToken[3], commandToken[4], commandToken[5], commandToken[6],commandToken[7]))
                if Error then
                    terminal.add({255, 0, 0}, "[ERROR] | An error has occured during the execution of this program!") 
                end
            end
        end
    else
        if commandToken[1] ~= nil then
            terminal.add({255, 0, 0}, "[ERROR] | Invalid command " .. '"' .. commandToken[1] .. '"')
        end
    end
end

return command