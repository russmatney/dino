@tool
extends CanvasLayer

var pomodoros = []
var durations = []
var breaks = []
var current
var latest

## ready ##################################################################

func _ready():
	Debug.pr("Clawe Dashboard ready")

	await fetch_pomodoros()

## pomodoro calcs ##################################################################
## could be done on the backend

func date_str_to_int(ds):
	# NOTE this parse timezones (trailing 'Z'), may be come a problem at some point
	# var dt_dict = Time.get_datetime_dict_from_datetime_string(ds, false)
	var dt_ms = Time.get_unix_time_from_datetime_string(ds)
	# Debug.pr("dt_dict", dt_dict)
	# Debug.pr("dt_ms", dt_ms)
	return dt_ms

func secs_between_date_strs(a, b):
	if a and b:
		return date_str_to_int(a) - date_str_to_int(b)

# subtract hours from mins, hours+mins from secs
func secs_to_time_dict(secs):
	var hours = secs / 3600
	var mins = secs / 60
	# secs = secs % 3600
	return {mins=mins, hours=hours, secs=secs}

func sort_pomos_recent(a, b):
	var a_t = a.get("pomodoro/started-at")
	var b_t = b.get("pomodoro/started-at")
	if a_t and b_t:
		return date_str_to_int(a_t) > date_str_to_int(b_t)
	else:
		return false

func sort_pomos_chrono(a, b):
	var a_t = a.get("pomodoro/started-at")
	var b_t = b.get("pomodoro/started-at")
	if a_t and b_t:
		return date_str_to_int(a_t) < date_str_to_int(b_t)
	else:
		return false

## set pomodoros ################################################

func set_pomodoros(ps):
	pomodoros = ps

	var currents = ps.filter(func (p):
		return p.get("pomodoro/is-current"))
	if len(currents) > 0:
		current = currents.front()

	Debug.prn("current", current)

	# note, copy by reference
	ps.sort_custom(sort_pomos_recent)
	var last_8 = ps.slice(0, 7)

	durations = []
	breaks = []

	var _next
	if len(last_8) > 0:
		latest = last_8[0]
		_next = last_8[0]
	for p in last_8:
		if p == _next:
			continue
		var d = secs_between_date_strs(p.get("pomodoro/finished-at"), p.get("pomodoro/started-at"))
		durations.append(secs_to_time_dict(d))

		var b = secs_between_date_strs(_next.get("pomodoro/started-at"), p.get("pomodoro/finished-at"))
		breaks.append(secs_to_time_dict(b))

		_next = p

	show_current()
	show_durations()
	show_breaks()

## pomodoros ui

@onready var current_text = $%Current
@onready var breaks_text = $%Breaks
@onready var durations_text = $%Durations

func show_current():
	if current:
		var time_dict = secs_between_date_strs(Time.get_datetime_string_from_system(true), current.get("pomodoro/started-at"))
		time_dict = secs_to_time_dict(time_dict)
		current_text.text = Debug.to_pretty(time_dict, true)
	elif latest:
		var time_dict = secs_between_date_strs(Time.get_datetime_string_from_system(true), latest.get("pomodoro/finished-at"))
		time_dict = secs_to_time_dict(time_dict)
		current_text.text = Debug.to_pretty(time_dict, true)

func show_durations():
	Debug.prn(durations)
	durations_text.text = Debug.to_pretty(durations, true)

func show_breaks():
	breaks_text.text = Debug.to_pretty(breaks, true)

## pomodoros api ##################################################################

var clawe_base_url = "http://localhost:3334"
var clawe_pomodoro_url = str(clawe_base_url, "/api/pomodoros")
var clawe_pomodoro_start_url = str(clawe_pomodoro_url, "/start")
var clawe_pomodoro_stop_url = str(clawe_pomodoro_url, "/stop")

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	Debug.pr(result, response_code, headers)
	match response_code:
		404: Debug.warn("http response: 404. Does the attempted url exist?")
		200: _http_success(body)
		_: Debug.warn("Unespected http response: ", response_code, result)

func _http_success(body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	var ps = response.get("pomodoros", [])
	if len(ps) > 0:
		set_pomodoros(ps)


func fetch_pomodoros():
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_http_request_completed)

	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request(clawe_pomodoro_url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func start_pomodoro():
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_http_request_completed)

	var body = JSON.stringify({"name": "Godette"})
	var error = http_request.request(clawe_pomodoro_start_url, [], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
