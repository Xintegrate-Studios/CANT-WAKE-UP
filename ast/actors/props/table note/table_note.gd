extends Node3D

var NOTE_ID : int = 1: # default note id to show
	set(value):
		NOTE_ID = value
		_update_note(value)

@export var NoteContentLabel : Label

func _ready() -> void:
	_update_note(NOTE_ID)

func _update_note(note_id : int) -> void:
	NoteContentLabel.text = NotesGlobal.NOTES[note_id]

func _on_note_closeup() -> void:
	PlayerGlobal.player.toggle_note_closeup(!UIGlobal.in_note_closeup, NOTE_ID)
