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

func open_log_file(date_time : Dictionary) -> void:
	if log_file == null:
		log_file = FileAccess.open("user://game_log-%02d%02d%02d.txt" % [date_time.day, date_time.month, date_time.year], FileAccess.WRITE)

func close_log_file() -> void:
	if log_file != null:
		log_file.close()

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
