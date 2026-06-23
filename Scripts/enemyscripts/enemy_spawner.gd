extends Node2D

@export var player : Player
@export var scenes : Array[PackedScene]

var enemy_counter : int  

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func wave_spawn(enemy_scene : PackedScene):
	print("spawned an enemy")
	player.pathFollow.progress_ratio = rng.randf_range(0.0,1.0)
	var new_enemy = enemy_scene.instantiate()
	new_enemy.name = "Enemy_%d" % enemy_counter
	enemy_counter += 1
	add_child(new_enemy)
	new_enemy.global_position = player.wave_enemy_position.global_position




func _on_wave_timer_timeout() -> void:
	pass # Replace with function body.
