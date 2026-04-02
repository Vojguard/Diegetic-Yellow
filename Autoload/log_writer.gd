extends Node

enum EVENT_TAG {
	NG,
	EL,
	FL,
	PL,
	IC,
	TH
}

const HEADER_LINE = "-----------------------------"

var event_dict = { # More events
	EVENT_TAG.NG : "New Game Start",
	EVENT_TAG.EL : "Entered Level", # TODO: + jméno levelu
	EVENT_TAG.FL : "Finished Level",
	EVENT_TAG.PL : "Player Loaded",
	EVENT_TAG.IC : "Item Collected",
	EVENT_TAG.TH : "Target Hit"
}

var log_file = null

func check_andor_create_folder() -> void:
	if DirAccess.dir_exists_absolute(Globals.LOGS.LOG_FOLDER):
		print("exists")
	else:
		print("create folder")
		DirAccess.make_dir_absolute(Globals.LOGS.LOG_FOLDER)

func open_log_file(date_time : Dictionary) -> void:
	check_andor_create_folder()
	if log_file == null:
		log_file = FileAccess.open(Globals.LOGS.LOG_FORMAT % [date_time.day, date_time.month, date_time.year], FileAccess.WRITE)

func close_log_file() -> void:
	if log_file != null:
		log_file.close()
		Globals.LOGS.IS_NEW_LOG = true

func check_log_open() -> bool:
	if log_file == null: return false
	else:
		return log_file.is_open()

func print_header_to_log(date_time : Dictionary, event_tag : EVENT_TAG) -> void:
	if !check_log_open(): return
	log_file.store_line(HEADER_LINE)
	var event_name = event_dict[event_tag]
	var string_to_store =("(%s)[%02d-%02d-%04d %02d:%02d:%02d] %-15s " % [event_tag, date_time.day, date_time.month, date_time.year,
	 date_time.hour, date_time.minute, date_time.second, event_name])
	log_file.store_line(string_to_store)

func print_event_to_log(time_stamp : int, event_tag : EVENT_TAG, score : int) -> void:
	if !check_log_open(): return
	var sec = time_stamp % 60
	var mins = time_stamp / 60
	var event_name = event_dict[event_tag]
	var string_to_store = ("(%s)[%02d:%02d] %-15s -> Score: %3d" % [event_tag, mins, sec, event_name, score])
	log_file.store_line(string_to_store)

func print_interaction_to_log(time_stamp : int, event_tag : EVENT_TAG, score : int, interactible : Interactable) -> void:
	print_event_to_log(time_stamp, event_tag, score)
	var string_to_store = ("--: %s > time: %dms count: %d" % [interactible.name, interactible.on_screen_time, interactible.on_screen_appearance])
	log_file.store_line(string_to_store)
	
