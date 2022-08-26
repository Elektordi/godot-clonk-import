extends Resource

class_name ClonkDefCore

export (Dictionary) var data = {"DefCore":{}}
export (AtlasTexture) var picture


func set_from_text(text, directory):
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

    if data["DefCore"].has("Picture"):
        var p = data["DefCore"]["Picture"].split(",")
        if p.size() == 4:
            picture = AtlasTexture.new()
            picture.region = Rect2(p[0].to_int(), p[1].to_int(),p[2].to_int(), p[3].to_int())
            picture.atlas = load(directory+"/Graphics.png")
