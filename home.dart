import 'package:flutter/material.dart';
import 'note_editor.dart';
import 'note.dart';
import 'note_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void loadNotes() async {
    notes = await NoteStorage.loadNotes();
    setState(() {});
  }

  void saveNotes() async {
    await NoteStorage.saveNotes(notes);
  }

  void deleteNote(Note note) async {
    notes.removeWhere((n) => n.id == note.id);
    saveNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = notes.where((note) =>
        note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.content.toLowerCase().contains(query.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('MyNotes'),
        backgroundColor: Colors.deepPurple,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: TextField(
              onChanged: (text) => setState(() => query = text),
              decoration: InputDecoration(
                hintText: 'Search...',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: filteredNotes.isEmpty
          ? Center(child: Text('No notes found.'))
          : ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (_, i) {
                final note = filteredNotes[i];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.content.length > 50
                        ? note.content.substring(0, 50) + '...'
                        : note.content,
                  ),
                  trailing: Text(note.timestamp.split(' ').first),
                  onTap: () async {
                    final edited = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoteEditor(note: note),
                      ),
                    );
                    if (edited != null) {
                      final index =
                          notes.indexWhere((n) => n.id == edited.id);
                      if (index != -1) {
                        notes[index] = edited;
                        saveNotes();
                        setState(() {});
                      }
                    }
                  },
                  onLongPress: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Delete this note?'),
                      content: Text('Are you sure you want to delete it?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            deleteNote(note);
                            Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteEditor(),
            ),
          );
          if (newNote != null) {
            notes.add(newNote);
            saveNotes();
            setState(() {});
          }
        },
      ),
    );
  }
}
