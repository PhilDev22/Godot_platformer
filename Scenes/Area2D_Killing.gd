extends Area2D

func _on_Area2D_Killing_area_entered(area):
	if area.get_parent().has_method("die"):
		area.get_parent().die()
