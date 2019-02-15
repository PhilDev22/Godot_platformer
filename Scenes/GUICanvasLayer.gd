extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func set_hearts(count, max_hearts):
	for i in max_hearts:
		get_node("Heart" + str(i)).play("empty")
	for i in count:
		get_node("Heart" + str(i)).play("default")
