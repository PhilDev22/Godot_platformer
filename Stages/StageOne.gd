extends Node2D

func _ready():
	$Enemies/EnemyGhost/AnimMoveGhost1 .play("move")
	$Enemies/EnemyGhost2/AnimMoveGhost2 .play("move")