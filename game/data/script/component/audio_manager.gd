extends Node

@onready var input : AudioStreamPlayer 
var index : int
var effect : AudioEffectCapture
var playback : AudioStreamGeneratorPlayback
@export var outputPath : NodePath
var inputThreshold = 0.005
var receiveBuffer := PackedByteArray()
var isReady : bool = false
@export var id_autority : int
var bufferSize : int = 0
var audioBuffer : PackedFloat32Array
@export var compressionMode : int = 2
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
	sendData.rpc(compressByteArray(floatArrayToByteArray(data)), floatArrayToByteArray(data).size() * 4)
		

func processVoice():
	
	if receiveBuffer.size() <= 0:
		return
	audioBuffer.append_array(byteArrayToFloatArray(decompressByteArray(receiveBuffer,bufferSize)))
	receiveBuffer.clear()
	print(id_autority, " " ,audioBuffer.size())
	for i in range(min(playback.get_frames_available(), audioBuffer.size())):
		playback.push_frame(Vector2(audioBuffer[0], audioBuffer[0]))
		audioBuffer.remove_at(0)
		
@rpc("any_peer", "call_remote", "unreliable_ordered")
func sendData(data : PackedByteArray, size : int):
	receiveBuffer.append_array(data)
	bufferSize = size
	

func floatArrayToByteArray(array : PackedFloat32Array):
	return array.to_byte_array()

func byteArrayToFloatArray(array : PackedByteArray):
	return array.to_float32_array()
	
func compressByteArray(array : PackedByteArray):
	return array.compress(compressionMode)
	
func decompressByteArray(array : PackedByteArray, size : int):
	if array.size() > 0:
		return array.decompress(size, compressionMode)
	return PackedByteArray()
