extends Node

enum LEVELS {
	MAIN,
	ONE,
	TWO
}

class GAME:
	const TARGET_HIT_SCORE = 10
	const COLLECTABLE_SCORE = 2
	
	static var chosen_pair := SCENES.PAIR_ONE
	
	static func set_chosen_pair(one : bool) -> void:
		if one:
			chosen_pair = SCENES.PAIR_ONE
		else:
			chosen_pair = SCENES.PAIR_TWO
	
	static func get_chosen_pair_scene(level : int) -> String:
		return chosen_pair[level]

## holds the const strings of scenes
class SCENES:
	## path to main menu
	const MAIN_MENU : String = "res://UI/main_menu.tscn"
	## @deprecated: will not be used in final build. replaced by [member LEVEL_ONE]
	const ARENA : String = "res://Levels/Arena/arena_scene.tscn" 
	## path to level one
	const LEVEL_ONE : String = "res://Levels/One/level_one.tscn"
	const LEVEL_ONE_ALT : String = "res://Levels/One/level_one_alt.tscn"
	## path to level two
	const LEVEL_TWO : String = "res://Levels/Two/level_two.tscn"
	const LEVEL_TWO_ALT : String = "res://Levels/Two/level_two.tscn" #TODO: prepsat na pravy
	
	const PAIR_ONE : Array[String] = [LEVEL_ONE, LEVEL_TWO_ALT]
	const PAIR_TWO : Array[String] = [LEVEL_ONE_ALT, LEVEL_TWO]

class LOGS:
	const LOG_FOLDER : String = "user://game_logs//"
	const LOG_FORMAT : String = LOG_FOLDER + "game_log-%02d%02d%02d.txt"
	static var IS_NEW_LOG : bool = false
