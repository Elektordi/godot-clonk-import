extends Resource

class_name ClonkTxtActMap

@export (Dictionary) var data = {}


func set_from_text(text, directory):
    var action = {}
    var list = []
    for l in text.split("\n"):
        l = l.strip_edges()
        if l == "":
            continue
        if l[0] == ";":
            continue
        if l[0] == "[":
            var part = l.trim_prefix("[").trim_suffix("]")
            if part != "Action":
                continue
            action = {}
            list.append(action)

        var x = l.split("=", false, 2)
        if x.size() < 2:
            continue
        action[x[0].to_lower()] = x[1]

    for l in list:
        data[l['name']] = l


func get_data(anim, key, default=null):
    key = key.to_lower()
    if not data.has(anim):
        return default
    if not data[anim].has(key):
        return default
    return data[anim][key]
