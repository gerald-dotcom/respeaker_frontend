/*	
	This file is part of JUCI (https://github.com/mkschreder/juci.git)

	Copyright (c) 2015 Martin K. Schröder <mkschreder.uk@gmail.com>

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
*/ 

(function(){
	var _timeouts = {}; 
	JUCI.interval = {
		once: function(t, fn){
			var i = setTimeout(function _onTimeout(){
				fn(function next(ret, err){
					clearTimeout(i); 
					delete _timeouts[name]; 
				}); 
			}, t); 
			_timeouts[name] = i; 
		}, 
		repeat: function(name, t, fn){
			function _onTimeout(){
				if(fn) fn(function next(ret, err){
					if(!ret) {
						if(!_timeouts[name] || !_timeouts[name].cleared)
							_timeouts[name] = setTimeout(_onTimeout, t); 
					}
				}); 
			}
			//_timeouts[name] = setTimeout(_onTimeout, t); 
			_onTimeout(); 
		}, 
		$clearAll: function(){
			Object.keys(_timeouts).map(function(t){ 
				clearTimeout(_timeouts[t]); 
			});
			_timeouts = {}; 
		} 
	}; 
})(); 
