extends Resource

class_name ClonkNames

export (Dictionary) var names = {}


func set_from_text(text):
    var part = ""
    for l in text.split("\n"):
        l = l.strip_edges()
        if l == "":
            continue
        if l[0] == ";":
            continue
        var x = l.split(":", false, 2)
        if x.size() < 2:
            continue
        names[x[0]] = x[1]
