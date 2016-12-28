#!/usr/bin/lua

-- JUCI Lua Backend Server API
-- Copyright (c) 2016 Martin Schröder <mkschreder.uk@gmail.com>. All rights reserved. 
-- This module is distributed under GNU GPLv3 with additional permission for signed images.
-- See LICENSE file for more details. 


local json = require("orange/json"); 

-- T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 3
-- B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
-- D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
-- P:  Vendor=1d6b ProdID=0002 Rev= 3.16
-- S:  Manufacturer=Linux 3.16.0-38-generic ehci_hcd
-- S:  Product=EHCI Host Controller
-- S:  SerialNumber=0000:00:1d.0
-- C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
-- I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
-- E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

function usb_list_devices()
	local f = assert(io.open("/sys/kernel/debug/usb/devices")); 
	local line = f:read("*l"); 
	local obj = {}; 
	local devices = {}; 
	while line do
		if line == "" then 
			if next(obj) ~= nil then table.insert(devices, obj) end
			obj = {}; 
		end
		if line:find("^S:") then 
			local key,value = line:match(".:[%s%*]+([^=]+)=(.*)"); 
			obj[string.lower(key)] = value; 
		elseif line:find("^P:") then
			local vendor,prod,rev = line:match("P:  Vendor=([^%s]+) ProdID=([^%s]+) Rev=%s*([^%s]+)"); 
			obj["vendorid"] = vendor; 
			obj["productid"] = prod; 
			obj["rev"] = rev; 
		end
		line = f:read("*l"); 
	end
	f:close(); 
	-- add last device
	if next(obj) ~= nil then table.insert(devices, obj) end
	local res = {}; 
	res["devices"] = devices; 
	return res; 
end

return {
	list = usb_list_devices
}; 

