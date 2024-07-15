extends Node

@onready var input : AudioStreamPlayer 
var index : int
var effect : AudioEffectCapture
var playback : AudioStreamGeneratorPlayback
@export var outputPath : NodePath
var inputThreshold = 0.005
var receiveBuffer := PackedByteArray()
var receiveBufferSizeUnpack : int = 0
var isReady : bool = false
@export var id_autority : int
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setupAudio(id):
	input = $input
	set_multiplayer_authority(id)
	if is_multiplayer_authority():
		input.stream = AudioStreamMicrophone.new()
		input.play()
		index = AudioServer.get_bus_index("Record")
		effect = AudioServer.get_bus_effect(index, 0)

	playback = get_node(outputPath).get_stream_playback()
	isReady = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isReady:
		if is_multiplayer_authority():
			processMic()
		processVoice()
	else:
		setupAudio(id_autority)

func processMic():
	var sterioData : PackedVector2Array = effect.get_buffer(effect.get_frames_available())
	
	#if sterioData.size() > 0:
		
	var data = PackedFloat32Array()
	data.resize(sterioData.size())
	var maxAmplitude := 0.0
	
	for i in range(sterioData.size()):
		var value = (sterioData[i].x + sterioData[i].y) / 2
		maxAmplitude = max(value, maxAmplitude)
		data[i] = value
	if maxAmplitude < inputThreshold:
		return
	var compressData = compressData(data)
	sendData.rpc(compressData, data.size())
		

func processVoice():
	print(receiveBufferSizeUnpack)
	if receiveBufferSizeUnpack <= 0:
		return
	var unpackData = readData(receiveBuffer,receiveBufferSizeUnpack)
	
	if unpackData.size() <= 0:
		return
	
	for i in range(min(playback.get_frames_available(), unpackData.size())):
		playback.push_frame(Vector2(unpackData[0], unpackData[0]))
		unpackData.remove_at(0)
		

@rpc("any_peer", "call_remote", "unreliable_ordered")
func sendData(data : PackedByteArray, size : int):
	receiveBuffer.append_array(data)
	receiveBufferSizeUnpack = size
	
func compressData(data : PackedFloat32Array):
	return data.to_byte_array().compress()

func readData(data : PackedByteArray, size : int):
	return data.decompress(size * 4).to_float32_array()
