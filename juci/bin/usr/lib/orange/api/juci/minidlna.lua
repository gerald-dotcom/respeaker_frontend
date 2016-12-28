#!/usr/bin/lua

-- JUCI Lua Backend Server API
-- Copyright (c) 2016 Martin Schröder <mkschreder.uk@gmail.com>. All rights reserved. 
-- This module is distributed under GNU GPLv3 with additional permission for signed images.
-- See LICENSE file for more details. 

local juci = require("orange/core");
local json = require("orange/json");

local function get_status(opts)
	local info = juci.shell("wget -q -O - http://127.0.0.1:8200 | sed 's/<tr[^>]*>/\\n/g' | sed 's/<[^>]*>/\\t/g'"); 
	local result = { count = {} }; 
	for line in info:gmatch("[^\r\n]+") do 
		local field,value = line:match("%s+([^\t]+)%s+(%S+)%s+");  
		if(field == "Audio files") then result.count.audio = tonumber(value); end 
		if(field == "Video files") then result.count.video = tonumber(value); end 
		if(field == "Image files") then result.count.image = tonumber(value); end 
	end
	return result; 
end

local function folder_tree()
	return juci.file.folder_tree();
end

local function autocomplete(opts)
	local ret = juci.file.autocomplete(opts);
	if(ret == 1) then return ret; end
	return ret; 
end

return {
	["folder_tree"] = folder_tree,
	["autocomplete"] = autocomplete,
	["status"] = get_status
};
