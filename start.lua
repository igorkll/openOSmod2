local component = require("component")
local computer = require("computer")
local gui = require("simpleGui3").create()

local function roft_splash(str)
    gui.status(str, 0)
    computer.beep(100, 1)
    os.sleep(0.5)
end

roft_splash("corporate - roft")
roft_splash("corporate - roft")


if not component.isAvailable("internet") then
    gui.status()
end