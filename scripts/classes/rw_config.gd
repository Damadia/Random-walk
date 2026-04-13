class_name RwConfig
extends Node

var EntityConfig : Dictionary = {}
var FatherConfig : Dictionary = {}


func _init(EC : Dictionary = {}, FC : Dictionary = {}) -> void:
	EntityConfig["steps"] = EC["steps"] if EC.get("steps", -1) != -1 else 1
	EntityConfig["p"] = EC["p"] if EC.get("p", -1) != -1 else 0.5
	EntityConfig["q"] = 1 - float(EntityConfig["p"])
	EntityConfig["speed"] = EC["speed"] if EC.get("speed", -1) != -1 else 50
	EntityConfig["intervalSpeed"] = EC["intervalSpeed"] if EC.get("intervalSpeed", -1) != -1 else 1.0
	
	FatherConfig["spawnInterval"] = FC["spawnInterval"] if FC.get("spawnInterval", -1) != -1 else 2.0
	FatherConfig["limit"] = FC["limit"] if FC.get("limit", -1) != -1 else 5
	
	
func _to_string() -> String:
	return "EC: %s \nFC: %s" % [EntityConfig, FatherConfig]
