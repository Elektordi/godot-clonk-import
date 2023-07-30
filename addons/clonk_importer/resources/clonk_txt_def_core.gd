extends Resource

class_name ClonkTxtDefCore

@export var data: Dictionary = {"defcore":{}}


func set_from_text(text, directory):
	var part = ""
	for l in text.split("\n"):
		l = l.strip_edges()
		if l == "":
			continue
		if l[0] == ";":
			continue
		if l[0] == "[":
			part = l.trim_prefix("[").trim_suffix("]").to_lower()
			data[part] = {}
			continue

		var x = l.split("=", false, 2)
		if x.size() < 2:
			continue
		data[part][x[0].to_lower()] = x[1]


func get_data(key, default=null, part="DefCore"):
	key = key.to_lower()
	part = part.to_lower()
	if not data.has(part):
		return default
	if not data[part].has(key):
		return default
	return data[part][key]
