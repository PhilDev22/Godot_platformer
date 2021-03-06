extends Node

var MAX_LEVEL = 7

var current_scene = null
var current_level = 0 # 0 = menu
var current_sword_id = -1 # -1 = no sword
var coins = 0
var coins_total = 0

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	#if the starting level is not level 0, then load it
	if current_level > 0:
		current_level -= 1
		load_next_level()

func load_next_level():
	var path_new_stage = "res://Stages/Stage" + str(current_level + 1) +".tscn"
	var path_outro = "res://Stages/Outro.tscn"
	var file2Check = File.new()
	if file2Check.file_exists(path_new_stage) and current_level + 1 <= MAX_LEVEL:
		current_level += 1
		goto_scene(path_new_stage)
	else:
		print("Could not find scene: " + path_new_stage)
		goto_scene(path_outro)
		
	
func reset():
	current_level = -1
	coins = 0
	coins_total = 0
	current_sword_id = -1
	load_next_level()
	
func reset_woodboxes():
	var environment_node = current_scene.get_node("Environment")
	if environment_node != null:
		for woodbox in environment_node.get_children():
	        woodbox.reset()
	
func set_sword_id(id):
	current_sword_id = id
	
func add_coin(count):
	coins += 1
	get_tree().get_root().find_node("GUICanvasLayer", true, false).update_coins()
		
func goto_scene(path):
    # This function will usually be called from a signal callback,
    # or some other function from the running scene.
    # Deleting the current scene at this point might be
    # a bad idea, because it may be inside of a callback or function of it.
    # The worst case will be a crash or unexpected behavior.

    # The way around this is deferring the load to a later time, when
    # it is ensured that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
    # Immediately free the current scene,
    # there is no risk here.
    current_scene.free()

    # Load new scene.
    var s = ResourceLoader.load(path)

    # Instance the new scene.
    current_scene = s.instance()

    # Add it to the active scene, as child of root.
    get_tree().get_root().add_child(current_scene)

    # Optional, to make it compatible with the SceneTree.change_scene() API.
    get_tree().set_current_scene(current_scene)