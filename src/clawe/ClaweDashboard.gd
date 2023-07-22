@tool
extends CanvasLayer

var clawe_base_url = "http://localhost:3334"
var clawe_pomodoro_url = str(clawe_base_url, "/api/pomodoros")

func _ready():
	Debug.pr("Clawe Dashboard ready")

	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_http_request_completed)

	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request(clawe_pomodoro_url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

	# Perform a POST request. The URL below returns JSON as of writing.
	# Note: Don't make simultaneous requests using a single HTTPRequest node.
	# The snippet below is provided for reference only.
	# var body = JSON.new().stringify({"name": "Godette"})
	# error = http_request.request("https://httpbin.org/post", [], HTTPClient.METHOD_POST, body)
	# if error != OK:
	# 	push_error("An error occurred in the HTTP request.")

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

	print("json res", response)
