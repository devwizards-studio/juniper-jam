extends Node2D
class_name ShurikenSpawner

const SHURIKEN = preload("res://scenes/combat/shuriken.tscn")
const CRIT_SHURIKEN = preload("res://scenes/combat/crit_shuriken.tscn")

@export var combat_stats: CombatStats
@export var time_scaler: TimeScaler

@onready var timer: Timer = $Timer

@export var horizontal_angle: float = 0
@export var horizontal_angle_step: float = 10

@export var horizontal_wiggle_size: float = 0
@export var wiggle_speed: float = 0

var is_puking: bool = false
var is_in_minigame: bool = false
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	timer.wait_time = combat_stats.fire_rate
	timer.start()

func _on_timer_timeout() -> void:
	timer.wait_time = combat_stats.fire_rate
	if !is_puking and !is_in_minigame:
		spawn_shurikens()
	
func spawn_shurikens():
	var start_point = global_position # era position, dar am schimbat ca sa se miste odata cu playerul
	var horizontal_angle_spacing = 360.0 / combat_stats.current_number_of_shurikens;
	var horizontal_wiggle_modifier = horizontal_wiggle_size * sin(wiggle_speed * Time.get_ticks_msec())
	
	for i in range(0, combat_stats.current_number_of_shurikens):
		var shuriken_dir_x_position = start_point.x + cos(((horizontal_angle + i * horizontal_angle_spacing + horizontal_wiggle_modifier) * PI) / 180.0) * combat_stats.range
		var shuriken_dir_y_position = start_point.y + sin(((horizontal_angle + i * horizontal_angle_spacing + horizontal_wiggle_modifier) * PI) / 180.0) * combat_stats.range
		
		var new_position_vector = Vector2(shuriken_dir_x_position, shuriken_dir_y_position)
		var shuriken_direction = (new_position_vector - start_point).normalized()
		
		var new_shuriken = pick_random_shuriken()
		new_shuriken.global_position = start_point # era position, dar am schimbat ca sa se miste odata cu playerul
		new_shuriken.start_position = global_position
		
		new_shuriken.move_direction = shuriken_direction

		new_shuriken.horizontal_angle = horizontal_angle
		new_shuriken.horizontal_angle_spacing = i * horizontal_angle_spacing
		new_shuriken.wiggle_speed = wiggle_speed
		new_shuriken.horizontal_wiggle_size = horizontal_wiggle_size
		
		get_parent().get_parent().add_child(new_shuriken)
	
		if horizontal_angle >= 360.0:
			horizontal_angle -= 360.0
			
	horizontal_angle += horizontal_angle_step
	
func pick_random_shuriken() -> Shuriken:
	var picked_number = rng.randi_range(1,100)
	if picked_number <= combat_stats.crit_chance:
		return CRIT_SHURIKEN.instantiate()
	else:
		return SHURIKEN.instantiate()
