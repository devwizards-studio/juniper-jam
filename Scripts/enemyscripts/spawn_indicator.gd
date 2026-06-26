extends Node2D
class_name SpawnIndicator

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("flicker")
	
func _on_flicker_end():
	queue_free()
