extends CanvasLayer

@export var time_scaler: TimeScaler

@onready var SPIN_MINIGAME = preload("res://scenes/UI/SpinMinigame.tscn")
@onready var timer: Timer = $Timer

@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var player_camera: PlayerCamera = $"../PlayerCamera"

var XP : int = 0:
	set(value):
		XP = value
		%XP.value = value
		
var total_XP : int = 0
var level : int = 1:
	set(value):
		level = value
		%Level.text = "Lv " + str(value)
		if level > 1:
			%OptionsContainer.show_option()
			
func gain_XP(amount):
	XP += amount
	total_XP += amount
	check_XP()

func check_XP():
	if XP > %XP.max_value:
		XP -= %XP.max_value
		level += 1
		if level <= 20:
			%XP.max_value += 100

#start minigame
func _on_timer_timeout() -> void:
	var player = get_parent()
	player.in_minigame = true
	
	var animations = ["high_foot", "lutz", "spin"]
	var chosen = animations[randi() % animations.size()]
	print("Animatie aleasa: ", chosen)
	animated_sprite_2d.play(chosen)
	
	player_camera.zoom_in()
	time_scaler.time_scale = 0.1
	animated_sprite_2d.speed_scale = 2.0  
	var new_minigame = SPIN_MINIGAME.instantiate()
	add_child(new_minigame)
	new_minigame.minigame_over.connect(_on_minigame_over)
	
	timer.stop()

func _on_minigame_over(scored_points: float):
	var player = get_parent()
	player.in_minigame = false
	animated_sprite_2d.play("idle")  # revine la idle după minigame
	player_camera.zoom_out()
	time_scaler.time_scale = 1
	animated_sprite_2d.speed_scale = time_scaler.time_scale
	gain_XP(scored_points)
	print("minigame over with score " + str(scored_points))
	timer.start()
