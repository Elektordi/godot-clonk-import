@tool
extends Node2D

class_name ClonkObject

const fps = 38  # Got this from OpenClonk doc...

@export var defcore: Resource = ClonkTxtDefCore.new()
@export var actmap: Resource = ClonkTxtActMap.new()


func set_from_directory(directory: String, res_directory: String):
	defcore.set_from_text(read_file(directory.path_join("DefCore.txt")), directory)
	name = defcore.get_data("name", "Object")

	var graphics = load(res_directory.path_join("Graphics.png"))

	var base_sprite = Sprite2D.new()
	add_child(base_sprite)
	base_sprite.set_owner(self)
	base_sprite.name = "Base"
	base_sprite.texture = graphics
	var offset = defcore.get_data("offset")
	if offset:
		offset = offset.split(",")
		base_sprite.offset = Vector2(int(offset[0]), int(offset[1]))
		base_sprite.centered = false

	var picture = defcore.get_data("picture")
	if picture:
		picture = picture.split(",")
		var picture_sprite = Sprite2D.new()
		add_child(picture_sprite)
		picture_sprite.set_owner(self)
		picture_sprite.visible = false
		picture_sprite.name = "Picture"
		picture_sprite.texture = graphics
		picture_sprite.region_enabled = true
		picture_sprite.region_rect = Rect2(int(picture[0]), int(picture[1]), int(picture[2]), int(picture[3]))

	var width = defcore.get_data("width")
	var height = defcore.get_data("height")
	if width and height:
		base_sprite.region_enabled = true
		base_sprite.region_rect = Rect2(0, 0, int(width), int(height))

	var actmap_file = directory.path_join("ActMap.txt")
	if FileAccess.file_exists(actmap_file):
		actmap.set_from_text(read_file(actmap_file), directory)
		var player = AnimationPlayer.new()
		add_child(player)
		player.set_owner(self)
		var lib = AnimationLibrary.new()
		player.add_animation_library(name, lib)
		var resetanim = Animation.new()
		resetanim.length = 0
		var track_index = resetanim.add_track(Animation.TYPE_VALUE)
		resetanim.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)
		resetanim.track_set_path(track_index, base_sprite.name+":visible")
		resetanim.track_insert_key(track_index, 0.0, true)
		for actname in actmap.data:
			var anim = Animation.new()
			var length = int(actmap.get_data(actname, "length", 1))
			var delay = int(actmap.get_data(actname, "delay", 1))
			var framesdata = actmap.get_data(actname, "facet")
			if framesdata:
				framesdata = framesdata.split(",")
				while framesdata.size()<6:
					framesdata.append("0")
			anim.length = float(delay*length)/fps
			var sprite = Sprite2D.new()
			add_child(sprite)
			sprite.set_owner(self)
			sprite.name = "[Activity] "+actname
			sprite.visible = false
			sprite.texture = graphics
			sprite.region_enabled = true
			if framesdata:
				sprite.region_rect = Rect2(int(framesdata[0]), int(framesdata[1]), int(framesdata[2])*length, int(framesdata[3]))
				sprite.offset = Vector2(int(framesdata[4]), int(framesdata[5])) + base_sprite.offset
				sprite.centered = base_sprite.centered
			sprite.hframes = length
			track_index = anim.add_track(Animation.TYPE_VALUE)
			anim.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)
			anim.track_set_path(track_index, sprite.name+":frame")
			if actmap.get_data(actname, "reverse", "") != "1":
				for i in range(length):
					anim.track_insert_key(track_index, float(i*delay)/fps, i)
			else:
				for i in range(length):
					anim.track_insert_key(track_index, float(i*delay)/fps, length-i-1)
			track_index = anim.add_track(Animation.TYPE_VALUE)
			anim.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)
			anim.track_set_path(track_index, sprite.name+":visible")
			anim.track_insert_key(track_index, 0.0, true)
			track_index = anim.add_track(Animation.TYPE_VALUE)
			anim.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)
			anim.track_set_path(track_index, base_sprite.name+":visible")
			anim.track_insert_key(track_index, 0.0, false)
			if actmap.get_data(actname, "nextaction")==actname:
				anim.loop_mode = Animation.LOOP_LINEAR
			lib.add_animation(actname, anim)
			track_index = resetanim.add_track(Animation.TYPE_VALUE)
			anim.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)
			resetanim.track_set_path(track_index, sprite.name+":visible")
			resetanim.track_insert_key(track_index, 0.0, false)
		lib.add_animation("RESET", resetanim)

	var topface = defcore.get_data("topface")
	if topface:
		topface = topface.split(",")
		var sprite_top = Sprite2D.new()
		add_child(sprite_top)
		sprite_top.set_owner(self)
		sprite_top.name = "Topface"
		sprite_top.texture = graphics
		sprite_top.centered = false
		sprite_top.region_enabled = true
		sprite_top.region_rect = Rect2(int(topface[0]), int(topface[1]), int(topface[2]), int(topface[3]))
		sprite_top.centered = base_sprite.centered
		sprite_top.offset = Vector2(int(topface[4]), int(topface[5])) + base_sprite.offset
	return OK

func read_file(source_file):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if not file:
		return FileAccess.get_open_error()
	file.seek_end()
	var size = file.get_position()
	file.seek(0)
	var text = file.get_buffer(size).get_string_from_ascii()
	# file.as_text() decoding fails badly for non-utf8 text
	file.close()
	return text
