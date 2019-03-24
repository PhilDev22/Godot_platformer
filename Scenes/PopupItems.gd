extends Node2D

#item cards folder
var cards_path = "res://Assets/items/item_cards/"
var card_sword_prefix = "card_weapon"

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
	if stage == 5:
		item_ids = [8, 10]
	if stage == 6:
		item_ids = [8, 10]
	if stage == 7:
		item_ids = [9, 11]
		
	$Card0.texture = load(cards_path + card_sword_prefix + str( item_ids[0] + 1 ) + ".png")
	$Card1.texture = load(cards_path + card_sword_prefix + str( item_ids[1] + 1 ) + ".png")
	
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