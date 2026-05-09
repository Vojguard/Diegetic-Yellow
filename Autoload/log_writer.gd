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

var event_dict = {
	EVENT_TAG.NG : "New Game Start",
	EVENT_TAG.EL : "Entered Level",
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
		var path : String = Globals.LOGS.LOG_FORMAT % [date_time.day, date_time.month, date_time.year]
		if FileAccess.file_exists(path):
			log_file = FileAccess.open(path, FileAccess.READ_WRITE)
			log_file.seek_end()
		else:
			log_file = FileAccess.open(path, FileAccess.WRITE)

func close_log_file() -> void:
	if log_file != null:
		log_file.close()
		Globals.LOGS.IS_NEW_LOG = true

func check_log_open() -> bool:
	if log_file == null: return false
	else:
		return log_file.is_open()

func print_header_to_log(date_time : Dictionary, event_tag : EVENT_TAG, extra : String = "") -> void:
	if !check_log_open(): return
	log_file.store_line(HEADER_LINE)
	var event_name = event_dict[event_tag]
	var string_to_store =("(%s)[%02d-%02d-%04d %02d:%02d:%02d] %-14s " % [event_tag, date_time.day, date_time.month, date_time.year,
	 date_time.hour, date_time.minute, date_time.second, event_name])
	var final_line_to_store = str(string_to_store,extra)
	log_file.store_line(final_line_to_store)

func print_event_to_log(time_stamp : int, event_tag : EVENT_TAG, score : int, extra : String = "") -> void:
	if !check_log_open(): return
	var sec = time_stamp % 60
	var mins = time_stamp / 60
	var event_name = event_dict[event_tag]
	var string_to_store = ("(%s)[%02d:%02d] %-14s -> S: %4d" % [event_tag, mins, sec, event_name, score])
	var final_line_to_store = str(string_to_store, extra)
	log_file.store_line(final_line_to_store)

func print_interaction_to_log(time_stamp : int, event_tag : EVENT_TAG, score : int, interactible : Interactable) -> void:
	var interactible_pos_X = interactible.position.x
	var interactible_pos_Z = -interactible.position.z
	var string_to_store = (" : (%6.2f, %6.2f) > T: %5dms / A: %2d" % [interactible_pos_X, interactible_pos_Z, interactible.on_screen_time, interactible.on_screen_appearance])
	print_event_to_log(time_stamp, event_tag, score, string_to_store)
