extends Node2D

#sword folder
var items_path_root = "res://Assets/item_cards/"
#sword files
var item_paths = [
	"card_sword1.png",
	"card_sword2.png",
	"card_sword3.png",
	"card_sword4.png",
	"card_sword5.png",
	"card_sword6.png",
	"card_sword7.png",
	"card_sword8.png",
]

var item_ids = [-1, -1]
var selected_item_id = -1
var selection = -1

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		_switch_item(0)
	elif Input.is_action_pressed("ui_right"):
		_switch_item(1)
	elif Input.is_action_pressed("ui_select"):
		_confirm_item()
		
func init_items(stage):
	if stage == 1:
		item_ids = [0, 2]
	if stage == 2:
		item_ids = [1, 3]
	if stage == 3:
		item_ids = [4, 6]
	if stage == 4:
		item_ids = [5, 7]	
			
	$Card0.texture = load(items_path_root + item_paths[ item_ids[0] ])
	$Card1.texture = load(items_path_root + item_paths[ item_ids[1] ])
	
func _confirm_item():
	if selection == 0:
		selected_item_id = item_ids[0]
	elif selection == 1:
		selected_item_id = item_ids[1]
		
	var player = get_tree().get_root().get_node("/root/Stage/Player")
	
	if selected_item_id != -1:
		player.get_node("Sword").change_type(selected_item_id)
		
	get_tree().get_root().get_node("/root/Global").current_sword_id = selected_item_id
	
	player.on_close_item_popup()
	
	_close()
	
func _switch_item(nr):
	var current = selection
	selection = nr
	if selection != current:
		get_node("Card" + str(selection)).apply_scale(Vector2(1.1, 1.1))
		if current != -1:
			get_node("Card" + str(current)).apply_scale(Vector2(1.0/1.1, 1.0/1.1))
	
func _close():
	queue_free()