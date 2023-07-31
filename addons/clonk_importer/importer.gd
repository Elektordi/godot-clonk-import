@tool

var c4group_path
var interface: EditorInterface

func import(c4group, source, target):
	if c4group == "":
		c4group_path = "c4group"
	elif "://" in c4group:
		c4group_path = ProjectSettings.globalize_path(c4group)
	else:
		c4group_path = c4group

	print("Step: recursive_explode")
	var r = recursive_explode(source)
	if r != OK:
		return r

	print("Step: recursive_import")
	r = recursive_import(source, target)
	if r != OK:
		return r

	print("Import OK")
	return OK


func recursive_explode(path: String):
	var dir = DirAccess.open(path)
	print("Entering %s..." % dir.get_current_dir())
	for d in dir.get_directories():
		var r = recursive_explode(path.path_join(d))
		if r != OK:
			return r
	for f in dir.get_files():
		if f.contains(".c4"):
			var r = explode(path.path_join(f))
			if r != OK:
				return r
	return OK


func explode(f: String):
	var path = ProjectSettings.globalize_path(f)
	print("Exploding %s..." % path)
	var output = []
	var r = OS.execute(c4group_path, [path, "-x"], output, true, false) # Blocking
	for l in output:
		print("> %s" % l)

	if r == 127:
		return ERR_FILE_MISSING_DEPENDENCIES
	if r != 0:
		return ERR_CANT_CREATE

	print("Explode OK")
	return OK


func recursive_import(source: String, target: String):
	var dir = DirAccess.open(source)
	print("Entering %s..." % dir.get_current_dir())
	if not DirAccess.dir_exists_absolute(target):
		DirAccess.make_dir_absolute(target)
	for d in dir.get_directories():
		var r = recursive_import(source.path_join(d), target.path_join(d.get_basename()))
		if r != OK:
			return r
	var resources = []
	var defer_import = []
	for f in dir.get_files():
		if f == "DefCore.txt":
			defer_import.append([source, target])
		elif f.get_extension() in ["png", "jpg"]:  # Add "bmp"?
			if dir.file_exists(target.path_join(f)):
				continue
			var r = dir.copy(source.path_join(f), target.path_join(f))
			if r != OK:
				return r
			resources.append(target.path_join(f))
	if not resources.is_empty():
		print("start")
		interface.get_resource_filesystem().reimport_files(resources)
		print("end")
	for d in defer_import:
		var r = import_object(d[0], d[1])
		if r != OK:
			return r
	return OK


func import_object(source: String, target: String):
	var node = ClonkObject.new()
	print("Reading %s..." % source)
	var result = node.set_from_directory(source, target)
	if result != OK:
		return result
	var scene = PackedScene.new()
	result = scene.pack(node)
	if result != OK:
		return result
	var target_scene = target.path_join(node.name + ".tscn")
	print("Writing %s..." % target)
	return ResourceSaver.save(scene, target_scene)
