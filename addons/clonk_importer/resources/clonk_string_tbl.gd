extends Resource

class_name ClonkStringTbl

export (Dictionary) var table = {}


func set_from_text(text):
    for l in text.split("\n"):
        l = l.strip_edges()
        if l == "":
            continue
        if l[0] == ";":
            continue

        var x = l.split("=", false, 2)
        if x.size() < 2:
            continue
        table[x[0]] = x[1]
