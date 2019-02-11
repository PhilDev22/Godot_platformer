extends Node2D

func _ready():
	$Enemies/EnemyGhost/AnimMoveGhost1 .play("move")
	$Enemies/EnemyGhost2/AnimMoveGhost2 .play("move")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
