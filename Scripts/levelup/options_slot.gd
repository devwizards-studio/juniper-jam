extends TextureButton

@export var combat_stats: CombatStats

@export var upgrade : Upgrade:
	set(value):
		upgrade = value
		$NameLabel.text = upgrade.title
		$DescLabel.text = upgrade.description

func _pressed():
	if upgrade:
		match upgrade.stat:
			"max_hp":
				combat_stats.max_hp += upgrade.value
				combat_stats.current_hp += upgrade.value
			"damage":
				combat_stats.damage += upgrade.value
			"shuriken_speed":
				combat_stats.shuriken_speed += upgrade.value
			"current_number_of_shurikens":
				var new_val = combat_stats.current_number_of_shurikens + int(upgrade.value)
				combat_stats.current_number_of_shurikens = min(new_val, 8)
			"max_speed":
				combat_stats.max_speed += int(upgrade.value)
		print("Dupa upgrade - max_speed: ", combat_stats.max_speed, " damage: ", combat_stats.damage)
		get_parent().close_option()
