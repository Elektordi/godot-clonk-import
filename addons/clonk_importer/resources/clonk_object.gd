tool
extends Node2D

class_name ClonkObject

export (Resource) var defcore = ClonkTxtDefCore.new()


func set_from_file(source_file):
    var directory = source_file.get_base_dir()
    defcore.set_from_text(read_file(source_file), directory)
    name = defcore.get_data("name", "Object")

    var graphics = load(directory+"/Graphics.png")

    var sprite = Sprite.new()
    add_child(sprite)
    sprite.set_owner(self)
    sprite.name = "Base"
    sprite.texture = graphics
    var offset = defcore.get_data("offset")
    if offset:
        offset = offset.split(",")
        sprite.offset = Vector2(offset[0], offset[1])
        sprite.centered = false
    var picture = defcore.get_data("picture")
    if picture:
        picture = picture.split(",")
        sprite.region_enabled = true
        sprite.region_rect = Rect2(picture[0], picture[1], picture[2], picture[3])


func read_file(source_file):
    var file = File.new()
    var err = file.open(source_file, File.READ)
    if err != OK:
        return err
    file.seek_end()
    var size = file.get_position()
    file.seek(0)
    var text = file.get_buffer(size).get_string_from_ascii()
    # file.as_text() decoding fails badly for non-utf8 text
    file.close()
    return text
