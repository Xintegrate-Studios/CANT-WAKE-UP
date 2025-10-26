extends Node3D

var NOTE_ID : int = 1 # default note id to show

@export var NoteContent : Label3D

func _update_note(note_id : int) -> void:
	NoteContent.text = NotesGlobal.NOTES[note_id]


func _on_note_closeup() -> void:
	pass # Replace with function body.
