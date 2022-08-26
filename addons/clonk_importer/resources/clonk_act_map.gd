extends Resource

class_name ClonkActMap

export (Dictionary) var data = {}


func set_from_text(text):
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
        action[x[0]] = x[1]

    for l in list:
        data[l['Name']] = l
