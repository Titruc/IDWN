extends Node

var peer = ENetMultiplayerPeer.new()
@export var playerScene : PackedScene
@export var lobbyScene : Node3D
@export var gameControler : Node
@export var menu : Node2D
@export var ipGetter : TextEdit
@export var code : TextEdit
@export var codeGetter : TextEdit

var upnp : UPNP

func _on_host_pressed():
	peer.create_server(9999, 6)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_addPlayer)
	menu.hide()
	upnp = upnp_config(9999)
	print(get_public_ip(upnp))
	_addPlayer()

func _addPlayer(id = 1):
	print(id)
	var player = playerScene.instantiate()
	player.name = str(id)
	lobbyScene.call_deferred("add_child",player)
	
	
func _on_join_pressed():
	peer.create_client(ipGetter.text,9999)
	multiplayer.multiplayer_peer = peer
	menu.hide()

func get_secure_code():
	upnp = upnp_config(9999)
	var public_ip = get_public_ip(upnp) + "."
	close_upnp(upnp,9999)
	var ipListe = []
	var nbr = ""
	for i in public_ip:
		if i != ".":
			nbr += i
		else:
			ipListe.append(int(nbr))
			nbr = ""
	var code = ""
	for i in ipListe:
		code += char(i)
		code += char(randi_range(257, 300))
	
	return code

func get_ip_from_code(code : String):
	var ip = ""
	code = code.substr(0, len(code)-1)
	for i in code:
		var value = i.unicode_at(0)
		if value < 256:
			ip += str(value)
		else:
			ip += "."
	return ip
			
		
			
			
	
	
	
func upnp_config(port : int):
	var upnp = UPNP.new()
	var discover_result = upnp.discover()
	
	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			var map_result_udp = upnp.add_port_mapping(port,port,"godot-udp","UDP",0)
			var map_result_tcp = upnp.add_port_mapping(port,port,"godot-tcp","TCP",0)
			
			if not map_result_udp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(port,port,"","UDP")
			if not map_result_tcp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(port,port,"","TCP")
	return upnp

func get_public_ip(upnp : UPNP):
	return upnp.query_external_address()
	
func close_upnp(upnp : UPNP, port : int):
	upnp.delete_port_mapping(port,"UDP")
	upnp.delete_port_mapping(port,"TCP")

			


func _on_get_code_pressed():
	code.text = get_secure_code()


func _on_join_with_code_pressed():
	var ip = get_ip_from_code(codeGetter.text)
	print(ip)
	peer.create_client(ip,9999)
	multiplayer.multiplayer_peer = peer
	menu.hide()
