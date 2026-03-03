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

class LOGS:
	const LOG_FOLDER : String = "user://game_logs//"
	const LOG_FORMAT : String = LOG_FOLDER + "game_log-%02d%02d%02d.txt"
	static var IS_NEW_LOG : bool = false
