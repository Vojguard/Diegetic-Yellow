extends Node

## holds the const strings of scenes
class SCENES:
	## path to main menu
	const MAIN_MENU : String = "res://UI/main_menu.tscn"
	## @deprecated: will not be used in final build. replaced by [member LEVEL_ONE]
	const ARENA : String = "res://Levels/Arena/arena_scene.tscn" 
	## path to level one
	const LEVEL_ONE : String = "res://Levels/One/level_one.tscn"
	## @experimental: empty string, path to level two
	const LEVEL_TWO : String = ""
