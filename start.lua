local component = require("component")
local computer = require("computer")
local gui = require("simpleGui3").create()

local function roft_splash(str)
    gui.status(str, 0)
    computer.beep(100, 1)
    os.sleep(0.5)
end

roft_splash("roft companuiy")
roft_splash("sponsor - krinj")
gui.status("OPEN OS MOD 2", 0)
computer.beep(2000, 3)
os.sleep(0.5)

while not component.isAvailable("internet") do
    gui.status("no internet connection", true)
end