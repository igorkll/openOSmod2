local component = require("component")
local computer = require("computer")
local event = require("event")
local gui = require("simpleGui3").create()

local function roft_splash(str)
    gui.status(str, 0)
    computer.beep(100, 2)
    os.sleep(0.5)
end

roft_splash("roft companuiy")
roft_splash("sponsor - rootmaster")
gui.status("OPEN OS MOD 2", 0)
computer.beep(2000, 3)
os.sleep(0.5)

while not component.isAvailable("internet") do
    gui.status("no internet connection", true)
end

local sel = 1
while true do
    sel = gui.menu("фшк нвой спр обнвлный опирциной сысмы", {
        "безопастность - достыгаться отсутствием поддержики файлов LUA",
        "добавленна проверка подпИси midi файлов",
		"удалена камдня стрк",
		"дблвн gui",
        "next"
    }, sel)
    if sel == 5 then
        break
    end
end

if not _G.bisos then
	while true do
		if gui.yesno("вы хотите устанавить новый bios!", true, 2) then
			break
		end
	end

	gui.status("установка bios...")
	component.eeprom.set([[
	_G.bisos = true
	local init
	do
		local component_invoke = component.invoke
		local function boot_invoke(address, method, ...)
			local result = table.pack(pcall(component_invoke, address, method, ...))
			if not result[1] then
				return nil, result[2]
			else
				return table.unpack(result, 2, result.n)
			end
		end

		-- backwards compatibility, may remove later
		local eeprom = component.list("eeprom")()
		computer.getBootAddress = function()
			return boot_invoke(eeprom, "getData")
		end
		computer.setBootAddress = function(address)
			return boot_invoke(eeprom, "setData", address)
		end

		do
			local screen = component.list("screen")()
			local gpu = component.list("gpu")()

			local function delay(time)
				local inTime = computer.uptime()
				while computer.uptime() - inTime < time do
					computer.pullSignal(time - (computer.uptime() - inTime))
				end
			end

			if gpu and screen then
				boot_invoke(gpu, "bind", screen)

				local static = {
					balls = {
						"⡠⠊⠉⠑⢄",
						"⢇   ⡸",
						"⢀⠕⠒⠪⡀",
						"⡇   ⢸",
						"⠈⠢⠤⠔⠁"
					},
					meat = {
						" ",
						"⠉",
						" ",
						"⠤",
						" "
					},
					konec = {
						"     ",
						"⡝⠑⠒⠤⡀",
						"⡇  ⠐⡺",
						"⠵⠔⠒⠉",
						"     "
					}
				}
		
				local screen_width, _ = boot_invoke(gpu, "getResolution")
				local length = screen_width - 10
		
				local buffer = static["balls"]
		
				for i = 1, 5 do
					buffer[i] = buffer[i] .. static["meat"][i]:rep(length) .. static["konec"][i]
					boot_invoke(gpu, "set", 1, i, buffer[i])
				end
		
				delay(1)
			end
			local melody = { 554, 622, 622, 698, 831, -10, 740, 698, 622, 554, 622, -1, -20, 415, 415, -1 }
			local rhythm = { 6, 10, 6, 6, 1, -10, 1, 1, 1, 6, 10, 4, -20, 2, 10, 10 }

			for i = 1, 16 do
				if melody[i] > 0 then
					computer.beep(melody[i], rhythm[i] * 0.1)
				elseif melody[i] == -1 then
					delay(rhythm[i] * 0.1)
				elseif melody[i] == -10 then
					if gpu then
						boot_invoke(gpu, "set", 7, 3, "PENIS BIOS")
					end
				elseif melody[i] == -20 then
					if gpu then
						boot_invoke(gpu, "set", 17, 3, "; FUCKING PEOPLE SINCE 1984")
					end
				end
			end
		end

		local function tryLoadFrom(address)
			local handle, reason = boot_invoke(address, "open", "/init.lua")
			if not handle then
				return nil, reason
			end
			local buffer = ""
			repeat
				local data, reason = boot_invoke(address, "read", handle, math.huge)
				if not data and reason then
					return nil, reason
				end
				buffer = buffer .. (data or "")
			until not data
			boot_invoke(address, "close", handle)
			return load(buffer, "=init")
		end
		local reason
		if computer.getBootAddress() then
			init, reason = tryLoadFrom(computer.getBootAddress())
		end
		if not init then
			computer.setBootAddress()
			for address in component.list("filesystem") do
				init, reason = tryLoadFrom(address)
				if init then
					computer.setBootAddress(address)
					break
				end
			end
		end
		if not init then
			error("no bootable medium found" .. (reason and (": " .. tostring(reason)) or ""), 0)
		end
	end
	return init(...)
	]])
	computer.shutdown(true)
end

local sel = 1
while true do
    sel = gui.menu("openOS mod V7 V2 V5 V4 likeOS liked pro", {
        "paint",
        "midi1",
		"midi2",
		"market",
        "shutdown"
    }, sel)
	event.hook = true
	event.superHook = true
    if sel == 1 then
        os.execute("paint /home/save.pic -f")
	elseif sel == 2 then
		os.execute("player /usr/midi/midi1.mid")
	elseif sel == 3 then
		os.execute("player /usr/midi/midi2.mid")
    elseif sel == 4 then
		os.execute("market")
	elseif sel == 5 then
		computer.shutdown()
	end
	event.hook = false
	event.superHook = false
end