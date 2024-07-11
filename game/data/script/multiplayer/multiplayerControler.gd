extends Node

var peer = ENetMultiplayerPeer.new()
@export var playerScene : PackedScene
@export var lobbyScene : Node3D
@export var gameControler : Node
@export var menu : Node2D
@export var ipGetter : TextEdit


func _on_host_pressed():
	peer.create_server(1617, 6)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_addPlayer)
	menu.hide()
	_addPlayer()

func _addPlayer(id = 1):
	print(id)
	var player = playerScene.instantiate()
	player.name = str(id)
	lobbyScene.call_deferred("add_child",player)
	
	
func _on_join_pressed():
	peer.create_client(ipGetter.text,1617)
	multiplayer.multiplayer_peer = peer
	menu.hide()
	
