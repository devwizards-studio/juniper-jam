extends Control

var url :=  "https://exdyjuyoumyhqvbzkixv.supabase.co/rest/v1/Leaderboard"
var api_key := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV4ZHlqdXlvdW15aHF2YnpraXh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIzMDQzMzYsImV4cCI6MjA5Nzg4MDMzNn0.mHbW0UzK52C6QUKCMy4QTD-J_Ner8WcNKBK_AcKcDTU"

var http_request : HTTPRequest
@export var vbox : VBoxContainer
@onready var leaderboard_visuals : LabelSettings = preload("res://Resources/leaderboard_settings.tres")

func _ready() -> void:
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_http_request_request_completed)
	fetch_leaderboard()


func fetch_leaderboard():
	print("fetching leaderboard")
	var headers = [
		"Content-Type: application/json",
		"apikey: " + api_key,
		"Authorization: Bearer " + api_key
	]
	var err = http_request.request(url + "?order=score.desc&limit=10", headers, HTTPClient.METHOD_GET)
	print("returned error code: ", err)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("response code: ", response_code)
	print("body: ", body.get_string_from_utf8())
	print("request completed fired")
	print(result)
	print(response_code)
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var scores = json.get_data()
	#print(response_code)
	for child in vbox.get_children():
		child.queue_free()
	for i in range(min(10, scores.size())):
		var entry = scores[i]
		var label = Label.new()
		label.label_settings = leaderboard_visuals
		label.text = "%d. %s - %d" % [i + 1, entry["player_name"], int(entry["score"])]
		vbox.add_child(label)


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file( "res://UI/GameOver.tscn")
