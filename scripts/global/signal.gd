extends Node

# face stuff
@warning_ignore("unused_signal")
signal open_mouth
@warning_ignore("unused_signal")
signal close_mouth
@warning_ignore("unused_signal")
signal open_left_eye
@warning_ignore("unused_signal")
signal open_right_eye
@warning_ignore("unused_signal")
signal close_left_eye
@warning_ignore("unused_signal")
signal close_right_eye

# dialog stuff
@warning_ignore("unused_signal")
signal send_dialog(dialog: String)
@warning_ignore("unused_signal")
signal close_dialog

# scene stuff
@warning_ignore("unused_signal") # more like unuwused signal ;3
signal change_scene
