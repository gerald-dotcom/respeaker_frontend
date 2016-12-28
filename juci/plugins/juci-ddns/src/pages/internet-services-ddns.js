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

JUCI.app
.controller("DDNSPage", function ($scope, $uci, $network) {
	$scope.data = {}; 
	$uci.$sync(["ddns"]).done(function () {
		$scope.ddns_not_installed = !$uci.ddns._exists; 
		$scope.ddns_list = $uci.ddns["@service"]; 
		$scope.$apply(); 
	}); 

	function nextNumber(){
		var i; 
		for(i = 0; i < $scope.ddns_list.length; i++){
			if(!$scope.ddns_list.find(function(x){ return x[".name"] == "DDNS_"+i; })) return i; 
		}
		return i; 
	}

	$scope.onAddDdnsSection = function(){
		var name = "DDNS_"+nextNumber(); 
		$uci.ddns.$create({
			".type": "service", 
			".name": name, 
			"label": name,
			"enabled": true
		}).done(function(ddns){
			$scope.$apply(); 
		}); 
	} 
	
	$scope.onRemoveDdnsSection = function(ddns){
		if(!ddns) return; 
		ddns.$delete().done(function(){
			$scope.$apply(); 
		});  
	}

	$scope.getItemTitle = function(item){
		return item[".name"]; 
	}
});
