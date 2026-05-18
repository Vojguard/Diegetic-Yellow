extends Node

enum GAME_VERSIONS {
	HEADS,
	TAILS
}

const HEADS_STRING_NAME = "HEADS VERSION"
const TAILS_STRING_NAME = "TAILS VERSION"

class GAME:
	const TARGET_HIT_SCORE = 20
	const COLLECTABLE_SCORE = 50
	
	static var mouse_sens_modifier : float = 1.0
	
	static var version_walkthrough := SCENES.WALKTHROUGH_HEADS
	static var version_string_name = HEADS_STRING_NAME
	static var location_at_walkthrough : int = 0
	
	static func set_chosen_game_version(version : GAME_VERSIONS) -> void:
		if version == GAME_VERSIONS.HEADS:
			version_walkthrough = SCENES.WALKTHROUGH_HEADS
			version_string_name = HEADS_STRING_NAME
		elif version == GAME_VERSIONS.TAILS:
			version_walkthrough = SCENES.WALKTHROUGH_TAILS
			version_string_name = TAILS_STRING_NAME
	
	static func progress_walkthrough() -> void:
		location_at_walkthrough += 1
	
	static  func get_current_walkthrough_location() -> int:
		return location_at_walkthrough
	
	static func get_scene_at_current_location() -> String:
		if location_at_walkthrough < version_walkthrough.size():
			return version_walkthrough[location_at_walkthrough]
		else:
			location_at_walkthrough = 0
			return SCENES.MAIN_MENU
	
	static func get_chosen_walkthrough_scene(level : int) -> String:
		return version_walkthrough[level]

class LEVEL:
	static var start_time : int = 0
	static var score : int = 0
	static var percent_targets_destroyed : float = 0
	static var percent_collectibles_collected : float = 0
	static var time_spend : int = 0
	
	static func set_start_time() -> void:
		start_time = Time.get_ticks_msec()
	
	## Takes [param ptd] for the percentage of targets destroyed [br]
	## [param scr] for the score
	## [param pcc] for the percentage of cubes collected [br]
	## [param ts] for the time spent in the level [br]
	## [i]percentages are in a value of 0-1[/i]
	static func set_level_stats(scr : int, ptd : float, pcc : float, ts: float) -> void:
		score = scr
		percent_targets_destroyed = ptd
		percent_collectibles_collected = pcc
		time_spend = ts
	
	static func reset_level_stats() -> void:
		score = 0
		percent_targets_destroyed = 0
		percent_collectibles_collected = 0
		time_spend = 0
	
	## returns array as follows: [br]
	## percentage of targets destroyed [br]
	## percentage of items collected [br]
	## time spent [br]
	## score
	static func get_level_stats() -> Array:
		return [percent_targets_destroyed, percent_collectibles_collected, time_spend, score]
	
	static func get_time() -> int:
		return (Time.get_ticks_msec() - start_time) / 1000 
	
## holds the const strings of scenes
class SCENES:
	## path to main menu
	const MAIN_MENU : String = "res://UI/main_menu.tscn"
	
	## path to end level screen
	const END_LEVEL : String = "res://UI/level_end_screen.tscn"
	
	## @deprecated: will not be used in final build. replaced by [member LEVEL_ONE]
	const ARENA : String = "res://Levels/Arena/arena_scene.tscn" 
	## path to level one
	const LEVEL_ONE : String = "res://Levels/One/level_one.tscn"
	const LEVEL_ONE_ALT : String = "res://Levels/One/level_one_alt.tscn"
	## path to level two
	const LEVEL_TWO : String = "res://Levels/Two/level_two.tscn"
	const LEVEL_TWO_ALT : String = "res://Levels/Two/level_two_alt.tscn"
	
	
	const WALKTHROUGH_HEADS : Array[String] = [LEVEL_ONE, LEVEL_TWO_ALT, LEVEL_ONE_ALT, LEVEL_TWO]
	const WALKTHROUGH_TAILS : Array[String] = [LEVEL_ONE_ALT, LEVEL_TWO, LEVEL_ONE, LEVEL_TWO_ALT]

class LOGS:
	const LOG_FOLDER : String = "user://game_logs/"
	const LOG_SUBFOLDER : String = LOG_FOLDER + "/%02d%02d%02d/"
	const LOG_FORMAT : String = "game_log-%02d%02d%02d.txt"
	const HEAT_MAP_FORMAT : String = "heat_map-%02d%02d%02d-%s.txt"
	static var IS_NEW_LOG : bool = false
