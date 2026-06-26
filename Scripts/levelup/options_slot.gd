extends TextureButton
class_name OptionsSlot

@export var combat_stats: CombatStats

@export var upgrade : Upgrade:
	set(value):
		upgrade = value
		$NameLabel.text = upgrade.title
		$DescLabel.text = upgrade.description

signal erase_shuriken_number
signal erase_crit_chance
signal erase_speed
signal erase_fire_rate
signal erase_range

signal health_modified

func _pressed():
	if upgrade:
		match upgrade.stat:
			"max_hp":
				combat_stats.max_hp += upgrade.value
				combat_stats.current_hp += upgrade.value
				
				# We update the player's healthbar in a very cursed way
				health_modified.emit()
			"damage":
				combat_stats.damage += upgrade.value
			"shuriken_speed":
				combat_stats.shuriken_speed += upgrade.value
			"current_number_of_shurikens":
				var new_val = combat_stats.current_number_of_shurikens + int(upgrade.value)
				combat_stats.current_number_of_shurikens = new_val
				
				# If we reach the maximum number of shurikens, we erase this type of upgrade from future pools
				if combat_stats.current_number_of_shurikens == combat_stats.MAX_NUMBER_OF_SHURIKENS:
					erase_shuriken_number.emit()
			"speed":
				combat_stats.current_speed += int(upgrade.value)
				
				if combat_stats.current_speed == combat_stats.MAX_SPEED:
					erase_speed.emit()
					
			"crit_chance":
				combat_stats.crit_chance += int(upgrade.value)
				
				if combat_stats.crit_chance == combat_stats.MAX_CRIT_CHANCE:
					erase_crit_chance.emit()
					
			"fire_rate":
				combat_stats.fire_rate -= int(upgrade.value)
				
				if combat_stats.fire_rate == combat_stats.MAX_FIRE_RATE:
					erase_fire_rate.emit()
			
			"range":
				combat_stats.range += int(upgrade.value)
				
				if combat_stats.range == combat_stats.MAX_RANGE:
					erase_range.emit()
					
		print("Dupa upgrade - max_speed: ", combat_stats.current_speed, " damage: ", combat_stats.damage)
		get_parent().close_option()
