extends Node

enum EVENT_TAG {
	NG,
	PL,
	PE,
	IC,
	TH
}

const HEADER_LINE = "-----------------------------"

var event_dict = {
	EVENT_TAG.NG : "New Game Start",
	EVENT_TAG.PL : "Player Loaded",
	EVENT_TAG.PE : "Player Exited",
	EVENT_TAG.IC : "Item Collected",
	EVENT_TAG.TH : "Target Hit"
}

var log_file = null

func open_log_file() -> void:
	if log_file == null:
		log_file = FileAccess.open("user://game_log.txt", FileAccess.WRITE)

func close_log_file() -> void:
	if log_file != null:
		log_file.close()

func print_header_to_log(date_time : Dictionary, event_tag : EVENT_TAG) -> void:
	log_file.store_line(HEADER_LINE)
	var event_name = event_dict[event_tag]
	var string_to_store =("(%s)[%02d-%02d-%04d %02d:%02d:%02d] %-15s " % [event_tag, date_time.day, date_time.month, date_time.year,
	 date_time.hour, date_time.minute, date_time.second, event_name])
	log_file.store_line(string_to_store)

func print_event_to_log(time_stamp : int, event_tag : EVENT_TAG, score : int) -> void:
	var sec = time_stamp % 60
	var mins = time_stamp / 60
	var event_name = event_dict[event_tag]
	var string_to_store = ("(%s)[%02d:%02d] %-15s -> Score: %3d" % [event_tag, mins, sec, event_name, score])
	log_file.store_line(string_to_store)
