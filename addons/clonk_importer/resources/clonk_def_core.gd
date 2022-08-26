extends Resource

class_name ClonkDefCore

export (Dictionary) var data = {}


func set_from_text(text):
    var part = ""
    for l in text.split("\n"):
        l = l.strip_edges()
        if l == "":
            continue
        if l[0] == ";":
            continue
        if l[0] == "[":
            part = l.trim_prefix("[").trim_suffix("]")
            data[part] = {}
            continue

        var x = l.split("=", false, 2)
        if x.size() < 2:
            continue
        data[part][x[0]] = x[1]
