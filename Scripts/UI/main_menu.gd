extends CanvasLayer
@export var start_scene_path : String
@onready var options_panel = $OptionsPanel

func _ready() -> void:
	options_panel.visible = false
	if not AudioManager.music_player.playing:
		var stream = preload("res://Audio/CriticalTheme.wav")
		AudioManager.play_music(stream)
	
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(start_scene_path)

func _on_options_pressed() -> void:
	options_panel.visible = true
	
func _on_quit_pressed() -> void:
	get_tree().quit()
