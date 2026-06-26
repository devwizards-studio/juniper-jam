extends HBoxContainer

@onready var health_bar: HealthBar = $"../../HealthBar"

var OptionSlot = preload("res://scenes/UI/options_slot.tscn")

const DAMAGE = preload("res://Resources/combat/upgrade_dmg.tres")
const HP = preload("res://Resources/combat/upgrade_hp.tres")
const SHURIKEN_NUMBER = preload("res://Resources/combat/upgrade_shurikens.tres")
const SHURIKEN_SPEED = preload("res://Resources/combat/upgrade_shuriken_speed.tres")
const SPEED = preload("res://Resources/combat/upgrade_speed.tres")
const FIRE_RATE = preload("res://Resources/combat/upgrade_fire_rate.tres")
const CRIT_CHANCE = preload("res://Resources/combat/upgrade_crit_chance.tres")
const RANGE = preload("res://Resources/combat/upgrade_range.tres")

@export var combat_stats: CombatStats
var all_upgrades : Array[Upgrade] = [
	DAMAGE,
	HP,
	SHURIKEN_NUMBER,
	SHURIKEN_SPEED,
	SPEED,
	FIRE_RATE,
	CRIT_CHANCE,
	RANGE
	]

func _ready():
	hide()

func close_option():
	for child in get_children():
		child.queue_free()
	hide()
	get_tree().paused = false

func show_option():
	var pool = all_upgrades.duplicate()
	pool.shuffle()
	var chosen = pool.slice(0, min(3, pool.size()))
	
	for upgrade in chosen:
		var slot = OptionSlot.instantiate()
		add_child(slot)
		
		slot.upgrade = upgrade
		slot.combat_stats = combat_stats
		connect_signals(slot)
		
		slot.process_mode = Node.PROCESS_MODE_ALWAYS
		
	process_mode = Node.PROCESS_MODE_ALWAYS
	show()
	get_tree().paused = true
	
func connect_signals(slot: OptionsSlot):
	match slot.upgrade.stat:
		"max_hp":
			slot.health_modified.connect(_on_health_modified)
		"current_number_of_shurikens":
			slot.erase_shuriken_number.connect(_on_erase_shuriken_number)
		"crit_chance":
			slot.erase_crit_chance.connect(_on_erase_crit_chance)
		"speed":
			slot.erase_speed.connect(_on_erase_speed)
		"fire_rate":
			slot.erase_fire_rate.connect(_on_erase_fire_rate)
		"range":
			slot.erase_range.connect(_on_erase_range)

func _on_health_modified():
	health_bar.max_value = combat_stats.max_hp
	health_bar.value = combat_stats.current_hp

func _on_erase_shuriken_number():
	all_upgrades.erase(SHURIKEN_NUMBER)
	
func _on_erase_crit_chance():
	all_upgrades.erase(CRIT_CHANCE)
	
func _on_erase_speed():
	all_upgrades.erase(SPEED)
	
func _on_erase_fire_rate():
	all_upgrades.erase(FIRE_RATE)
	
func _on_erase_range():
	all_upgrades.erase(RANGE)
