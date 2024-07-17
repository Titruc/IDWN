extends Node2D


@export var character : PackedScene

func _ready():
	var s = character.instantiate()
	s.name = "aaaa"
	s.get_child(0).id = 1
	add_child(s)
	
	
