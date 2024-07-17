extends Node

var peer = ENetMultiplayerPeer.new()
@export var playerScene : PackedScene
@export var lobbyScene : Node3D
@export var gameControler : Node
@export var menu : Node2D
@export var ipGetter : TextEdit
@export var code : TextEdit
@export var codeGetter : TextEdit
@export var playerID = []

var upnp : UPNP
var possibleCodeCaractere = ['!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-', '.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?', '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[', '\\', ']', '^', '_', '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~', '¡', '¢', '£', '¤', '¥', '¦', '§', '¨', '©', 'ª', '«', '¬', '®', '¯', '°', '±', '²', '³', '´', 'µ', '¶', '·', '¸', '¹', 'º', '»', '¼', '½', '¾', '¿', '×', '÷', '×', '÷', 'À', 'Á', 'Â', 'Ã', 'Ä', 'Å', 'Æ', 'Ç', 'È', 'É', 'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ï', 'Ð', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', '×', 'Ø', 'Ù', 'Ú', 'Û', 'Ü', 'Ý', 'Þ', 'ß', 'à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç', 'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï', 'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', '÷', 'ø', 'ù', 'ú', 'û', 'ü', 'ý', 'þ', 'ÿ', 'Ā', 'ā', 'Ă', 'ă', 'Ą', 'ą', 'Ć', 'ć', 'Ĉ', 'ĉ', 'Ċ', 'ċ', 'Č', 'č', 'Ď', 'ď', 'Đ', 'đ', 'Ē', 'ē', 'Ĕ', 'ĕ', 'Ė', 'ė', 'Ę', 'ę', 'Ě', 'ě', 'Ĝ', 'ĝ', 'Ğ', 'ğ', 'Ġ', 'ġ', 'Ģ', 'ģ', 'Ĥ', 'ĥ', 'Ħ', 'ħ', 'Ĩ', 'ĩ', 'Ī', 'ī', 'Ĭ', 'ĭ', 'Į', 'į', 'İ', 'ı', 'Ĳ', 'ĳ', 'Ĵ', 'ĵ', 'Ķ', 'ķ', 'ĸ', 'Ĺ', 'ĺ', 'Ļ', 'ļ', 'Ľ', 'ľ', 'Ŀ', 'ŀ', 'Ł', 'ł', 'Ń', 'ń', 'Ņ', 'ņ', 'Ň', 'ň', 'ŉ', 'Ŋ', 'ŋ', 'Ō', 'ō', 'Ŏ', 'ŏ', 'Ő', 'ő', 'Œ', 'œ', 'Ŕ', 'ŕ', 'Ŗ', 'ŗ', 'Ř', 'ř', 'Ś', 'ś', 'Ŝ', 'ŝ', 'Ş', 'ş', 'Š', 'š', 'Ţ', 'ţ', 'Ť', 'ť', 'Ŧ', 'ŧ', 'Ũ', 'ũ', 'Ū', 'ū', 'Ŭ', 'ŭ', 'Ů', 'ů', 'Ű', 'ű', 'Ų', 'ų', 'Ŵ', 'ŵ', 'Ŷ', 'ŷ', 'Ÿ', 'Ź', 'ź', 'Ż', 'ż', 'Ž', 'ž', 'ſ', 'ƒ', 'Ơ', 'ơ', 'Ư', 'ư', 'Ǎ', 'ǎ', 'Ǐ', 'ǐ', 'Ǒ', 'ǒ', 'Ǔ', 'ǔ', 'Ǖ', 'ǖ', 'Ǘ', 'ǘ', 'Ǚ', 'ǚ', 'Ǜ', 'ǜ', 'Ǻ', 'ǻ', 'Ǽ', 'ǽ', 'Ǿ', 'ǿ', 'Ș', 'ș', 'Ț', 'ț', 'ˆ', 'ˇ', '˘', '˙', '˚', '˛', '˜', '˝', '̏', '̑', 'Α', 'Β', 'Γ', 'Δ', 'Ε', 'Ζ', 'Η', 'Θ', 'Ι', 'Κ', 'Λ', 'Μ', 'Ν', 'Ξ', 'Ο', 'Π', 'Ρ', 'Σ', 'Τ', 'Υ', 'Φ', 'Χ', 'Ψ', 'Ω', 'α', 'β', 'γ', 'δ', 'ε', 'ζ', 'η', 'θ', 'ι', 'κ', 'λ', 'μ', 'ν', 'ξ', 'ο', 'π', 'ρ', 'ς', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω', 'ϑ', 'ϒ', 'ϖ', 'Ё', 'Ђ', 'Ѓ', 'Є', 'Ѕ', 'І', 'Ї', 'Ј', 'Љ', 'Њ', 'Ћ', 'Ќ', 'Ў', 'Џ', 'А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ж', 'З', 'И', 'Й', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Ъ', 'Ы', 'Ь', 'Э', 'Ю', 'Я', 'а', 'б', 'в', 'г', 'д', 'е', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я', 'ё', 'ђ', 'ѓ', 'є', 'ѕ', 'і', 'ї', 'ј', 'љ', 'њ', 'ћ', 'ќ', 'ў', 'џ']

func _on_host_pressed():
	peer.create_server(9999, 6)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_addPlayer)
	multiplayer.peer_connected.disconnect(_removePlayer)
	menu.hide()
	upnp = upnp_config(9999)
	_addPlayer()

func _addPlayer(id = 1):
	playerID.append(id)
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
	var codeTemp = ""
	for i in ipListe:
		codeTemp += possibleCodeCaractere[i]
		codeTemp += possibleCodeCaractere[randi_range(257, 298)]
	
	return codeTemp

func get_ip_from_code(codePar : String):
	var ip = ""
	codePar = codePar.substr(0, len(codePar)-1)
	for i in codePar:
		var value = possibleCodeCaractere.find(i)
		if value < 256:
			ip += str(value)
		else:
			ip += "."
	return ip
			
		
			
			
	
	
	
func upnp_config(port : int):
	var upnpTemp = UPNP.new()
	var discover_result = upnpTemp.discover()
	
	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		if upnpTemp.get_gateway() and upnpTemp.get_gateway().is_valid_gateway():
			var map_result_udp = upnpTemp.add_port_mapping(port,port,"godot-udp","UDP",0)
			var map_result_tcp = upnpTemp.add_port_mapping(port,port,"godot-tcp","TCP",0)
			
			if not map_result_udp == UPNP.UPNP_RESULT_SUCCESS:
				upnpTemp.add_port_mapping(port,port,"","UDP")
			if not map_result_tcp == UPNP.UPNP_RESULT_SUCCESS:
				upnpTemp.add_port_mapping(port,port,"","TCP")
	return upnpTemp

func get_public_ip(upnpPar : UPNP):
	return upnpPar.query_external_address()
	
func close_upnp(upnpPar : UPNP, port : int):
	upnpPar.delete_port_mapping(port,"UDP")
	upnpPar.delete_port_mapping(port,"TCP")

func _removePlayer(id):
	print("remove")
	var player = lobbyScene.get_node(str(id))
	if player:
		lobbyScene.call_deferred("remove_child", player)

func _on_get_code_pressed():
	code.text = get_secure_code()


func _on_join_with_code_pressed():
	var ip = get_ip_from_code(codeGetter.text)
	peer.create_client(ip,9999)
	multiplayer.multiplayer_peer = peer
	menu.hide()
