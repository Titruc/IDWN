extends Node

var effect : AudioEffect
var mic_capture: VOIPInputCapture
@export var output : AudioStreamPlayer3D
# Called when the node enters the scene tree for the first time.
func _ready():
	var idx = AudioServer.get_bus_index("mic")
	mic_capture = AudioServer.get_bus_effect(idx, 0)
	mic_capture.packet_ready.connect(_on_packet_ready)
	#print("effect")

func _process(delta):
	processVoice()


func processVoice():
	mic_capture.send_test_packets()
	#print("haa")
	
func _on_packet_ready(packet : PackedByteArray):
	rpc("voice_packet_received", packet)


@rpc("any_peer", "call_remote", "unreliable_ordered", 1)
func voice_packet_received(packet: PackedByteArray) -> void:
	#print(packet.size())
	output.stream.push_packet(packet)
	output.play()
	var packet2 = packet
	#print("haaa")
