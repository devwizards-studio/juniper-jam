extends Camera2D
class_name PlayerCamera

func zoom_in():
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(2.0, 2.0), 1.0)
	
func zoom_out():
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(1.0, 1.0), 1.0)
