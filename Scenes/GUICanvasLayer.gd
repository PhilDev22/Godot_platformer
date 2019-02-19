extends CanvasLayer

onready var scn_heart = preload("res://Scenes/GUIHeart.tscn")

var start_hearts = 3
var max_hearts = start_hearts
var active_hearts = start_hearts

func _ready():
	_load_all_hearts()

func _load_all_hearts():
	for i in max_hearts:
		var heart = scn_heart.instance()
		heart.set_name("Heart" + str(i))
		heart.set_position(Vector2(36 + (i * 50), 30))
		add_child(heart)

func set_active_hearts(count):
	if count > max_hearts:
		count = max_hearts
	
	active_hearts = count
	
	for i in max_hearts:
		get_node("Heart" + str(i)).play("empty")
	for i in active_hearts:
		get_node("Heart" + str(i)).play("default")
		
func add_heart():
	var heart = scn_heart.instance()
	heart.set_name("Heart" + str(max_hearts))
	heart.set_position(Vector2(36 + (max_hearts * 50), 30))
	add_child(heart)
	max_hearts += 1
	set_active_hearts(active_hearts + 1)