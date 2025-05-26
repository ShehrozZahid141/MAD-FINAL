import 'package:flutter/material.dart';
import 'note.dart';

class NoteEditor extends StatefulWidget {
  final Note? note;

  NoteEditor({this.note});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(labelText: 'Content'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final now = DateTime.now().toString();
                final note = Note(
                  id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch,
                  title: titleController.text,
                  content: contentController.text,
                  timestamp: now,
                );
                Navigator.pop(context, note);
              },
              child: Text('Save Note'),
            )
          ],
        ),
      ),
    );
  }
}
