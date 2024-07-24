class_name MKUtil

static func to_num_string(number:int, length:int = 3) -> String:
	var s = str(number)
	while len(s) < length:
		s = "0" + s
	return s

static func toTopDown(pos:Vector3) -> Vector2:
	return Vector2(pos.x, pos.z)

# https://gist.github.com/hiulit/772b8784436898fd7f942750ad99e33e
static func get_all_files(path: String, file_ext := "", files := []):
	var dir = DirAccess.open(path)

	if dir == null:
		return files

	dir.list_dir_begin()

	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir():
			files = get_all_files(path + file_name + "/", file_ext, files)
		else:
			if file_ext and file_name.get_extension() != file_ext:
				file_name = dir.get_next()
				continue

			files.append(path + file_name)

		file_name = dir.get_next()

	return files

static func stepForward(v:float, destination:float, step:float):
	if destination < v:
		return max(v - step, destination)
	return min(v + step, destination)

static func formatTime(time:float) -> String:
	var milliseconds = int(fmod(time, 1.0) * 1000)
	var seconds = floor(fmod(time, 60))
	var minutes = floor(time / 60)

	return str(
		MKUtil.to_num_string(minutes, 2), # minutes
   ":", MKUtil.to_num_string(seconds, 2), # minutes
   ".", MKUtil.to_num_string(milliseconds, 3))

static func getSpotTh(spot:int) -> String:
	var spotID = "th"
	if spot < 10 or spot > 19:
		match spot % 10:
			1:
				spotID = "st"
			2:
				spotID = "nd"
			3:
				spotID = "rd"
	return spotID
	
static func mod(x:int, y:int) -> int:
	return ((x % y) + y) % y
	
static func fmod(x:float, y:float) -> float:
	return fmod(fmod(x, y) + y, y)

static func applyBytes(bytes:PackedByteArray, apply:PackedByteArray, offset:int) -> PackedByteArray:
	for i in range(apply.size()):
		bytes[offset+i] = apply[i]
	return bytes

static func remapToRange(v, s1, e1, s2, e2):
	return s2 + ((v - s1) * ((e2 - s2) / (e1 - s1)))

static func print(v):
	file_print(str(v), get_stack())
	
static func file_print(text:String, stack, name:String = "", color:String = ""):
	if name == "":
		if len(stack) > 1:
			name = stack[1].source.get_file().get_basename()
		else:
			name = "Unknown"
		
	if color == "":
		var h = 0
		for i in len(name):
			h += (name.unicode_at(i) ** 2) + i
		color = str("#", Color.from_hsv(h/20.0, 0.75, 1.0, 1.0).to_html())
		
	var date = Time.get_time_dict_from_system()
	var dateStr = str(to_num_string(date.hour, 2), ":", to_num_string(date.minute, 2), ":", to_num_string(date.second, 2))
	
	print_rich(str("[b][color=", color, "][", dateStr, " - ", name, "][/color][/b] ", text))
