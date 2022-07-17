extends RichTextLabel

func _ready(): if OS.get_name() != "HTML5": connect("meta_clicked", onClick)

func onClick(meta): OS.shell_open(meta)
