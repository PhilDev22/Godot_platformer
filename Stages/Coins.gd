extends Node2D

func _ready():
	var coins = get_child_count()
	get_owner().get_node("/root/Global").coins_total += coins
	print("coins: " + str(coins))
	print("total: " + str(get_owner().get_node("/root/Global").coins_total))

