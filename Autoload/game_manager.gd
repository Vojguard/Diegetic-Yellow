class_name GameManager
extends Node3D

const target_hit_score = Globals.GAME.TARGET_HIT_SCORE
const collectable_score = Globals.GAME.COLLECTABLE_SCORE

var player: PlayerController = null

var start_time = 0
var score: int = 0

var max_targets : int = 1
var max_items : int = 1

var targets_hit : int = 0
var items_collected : int = 0

func _ready() -> void:
	max_targets = $"../Targets".get_child_count()
	max_items = $"../Collectible".get_child_count()
	var curr_level : String = Globals.GAME.get_scene_at_current_location()
	curr_level = curr_level.split("/")[-1].split(".")[0]
	var time_dict := Time.get_datetime_dict_from_system()
	LogWriter.print_header_to_log(time_dict, LogWriter.EVENT_TAG.EL, curr_level)
	LogWriter.open_heat_file(time_dict, curr_level)
	_connect_signals()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("reload"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _connect_signals() -> void:
	print("connection")
	SignalBus.player_loaded.connect(_on_player_loaded)
	SignalBus.target_hit.connect(_on_target_hit)
	SignalBus.item_collected.connect(_on_item_collected)

func _disconnect_signals() -> void:
	SignalBus.player_loaded.disconnect(_on_player_loaded)
	SignalBus.target_hit.disconnect(_on_target_hit)
	SignalBus.item_collected.disconnect(_on_item_collected)

func _on_player_loaded(p : PlayerController) -> void:
	player = p
	score = 0
	Globals.LEVEL.set_start_time()
	LogWriter.print_event_to_log(Globals.LEVEL.get_time(), LogWriter.EVENT_TAG.PL, score)
	print("player_loaded")

func _on_target_hit(_t : Target) -> void:
	targets_hit += 1
	var add_score : int = target_hit_score + roundi(target_hit_score * 1.0/maxi(1, _t.on_screen_appearance))
	print(add_score)
	_update_score(add_score)
	LogWriter.print_interaction_to_log(Globals.LEVEL.get_time(), LogWriter.EVENT_TAG.TH, score, _t)
	# LogWriter.print_event_to_log(get_time(), LogWriter.EVENT_TAG.TH, score)
	print("target hit %d" % score)

func _on_item_collected(_ci : Collectible) -> void:
	items_collected += 1
	var add_score : int = collectable_score + roundi(collectable_score * 1.0/maxi(1,_ci.on_screen_appearance))
	_update_score(add_score)
	LogWriter.print_interaction_to_log(Globals.LEVEL.get_time(), LogWriter.EVENT_TAG.IC, score, _ci)
	# LogWriter.print_event_to_log(get_time(), LogWriter.EVENT_TAG.IC, score)
	print("item collected %d" % score)

func _update_score(score_update : int) -> void:
	score += score_update
	SignalBus.score_updated.emit(score)

func _on_exit_body_entered(body: Node3D) -> void:
	if body is PlayerController: 
		var perc_th = targets_hit / (max_targets * 1.0)
		var perc_ic = items_collected / (max_items * 1.0)
		Globals.LEVEL.set_level_stats(score, perc_th, perc_ic, Globals.LEVEL.get_time())
		Globals.GAME.progress_walkthrough()
		var thp = perc_th * 100.0
		var icp = perc_ic * 100.0
		var finished_level_info = (" > Targets: %3d%% | Collectibles: %3d%%" % [thp, icp])
		LogWriter.print_event_to_log(Globals.LEVEL.get_time(), LogWriter.EVENT_TAG.FL, score, finished_level_info)
		LogWriter.close_heat_file()
		call_deferred("_load_next_scene", Globals.SCENES.END_LEVEL)
		

func _load_next_scene(next : String) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_disconnect_signals()
	get_tree().change_scene_to_file(next)

func _return_to_main_menu() -> void:
	_load_next_scene(Globals.SCENES.MAIN_MENU)
