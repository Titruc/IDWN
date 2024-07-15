extends Node
@onready var input : AudioStreamPlayer
var index : int
var effect : AudioEffectCapture
var playback : AudioStreamGeneratorPlayback
@export var nodePath : NodePath
var inputBreshold = 0.005
@export var id : int
var isInitiate : bool = false
var recieveBuffer : PackedFloat32Array = PackedFloat32Array()

func audioSetup(id : int):
	print("haaaa")
	set_multiplayer_authority(id)
	#if is_multiplayer_authority():
	input = $input
	input.stream = AudioStreamMicrophone.new()
	input.play()
	index = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(index, 0)
	
	var aaa = get_node(nodePath)
	get_node(nodePath).play()
	playback = get_node(nodePath).get_stream_playback()
	isInitiate = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(id)
	if isInitiate:
		if is_multiplayer_authority():
			processMic()
		processVoice(id)
	
		
	
		
func processMic():
	var serialData : PackedVector2Array = effect.get_buffer(effect.get_frames_available())
	
	if serialData.size() > 0:
		var data = PackedFloat32Array()
		data.resize(serialData.size())
		var maxAmplitude = 0.0
		
		for i in range(serialData.size()):
			var value = (serialData[i].x + serialData[i].y) / 2
			maxAmplitude = max(value, maxAmplitude)
			data[i] = value
		if maxAmplitude < inputBreshold:
			return
		
		sendData.rpc(data)

@rpc("any_peer","call_remote","unreliable_ordered")
func sendData(data : PackedFloat32Array):
	recieveBuffer.append_array(data)
	

func processVoice(id):
	if recieveBuffer.size() <= 0:
		return
	for i in range(min(playback.get_frames_available(),recieveBuffer.size())):
		playback.push_frame(Vector2(recieveBuffer[0],recieveBuffer[0]))
		recieveBuffer.remove_at(0)
	
	
	
