@tool
extends CanvasLayer

var clawe_base_url = "http://localhost:3334"
var clawe_pomodoro_url = str(clawe_base_url, "/api/pomodoros")
var clawe_pomodoro_start_url = str(clawe_pomodoro_url, "/start")
var clawe_pomodoro_stop_url = str(clawe_pomodoro_url, "/stop")

var pomodoros = []
var latest_durations = []
var latest_breaks = []
var current

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

# TODO subtract hours from mins, hours+mins from secs
func secs_to_time_dict(secs):
	var hours = secs / 3600
	var mins = secs / 60
	# TODO proper remainder
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

func set_pomodoros(ps):
	pomodoros = ps
	Debug.pr(pomodoros)

	current = ps.filter(func (p):
		return p.get("pomodoro/is-current")).front()

	Debug.prn("current", current)
	Debug.prn("current", date_str_to_int(current.get("pomodoro/started-at")))

	# note, copy by reference
	ps.sort_custom(sort_pomos_recent)
	var last_8 = ps.slice(0, 7)
	Debug.prn(last_8)

	latest_durations = []
	latest_breaks = []
	var next = last_8[0]
	for p in last_8:
		if p == next:
			continue
		var d = secs_between_date_strs(p.get("pomodoro/finished-at"), p.get("pomodoro/started-at"))
		latest_durations.append(secs_to_time_dict(d))

		var b = secs_between_date_strs(next.get("pomodoro/started-at"), p.get("pomodoro/finished-at"))
		latest_breaks.append(secs_to_time_dict(b))

		next = p

	Debug.prn("durs", latest_durations)
	Debug.prn("breaks", latest_breaks)


func _ready():
	Debug.pr("Clawe Dashboard ready")

	await fetch_pomodoros()

## pomodoros api ##################################################################

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
