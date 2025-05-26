import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'note.dart';

class NoteStorage {
  static const String key = 'notes';

  // Load notes from local storage
  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];
    final List<dynamic> list = jsonDecode(data);
    return list.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Save notes to local storage
  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> noteList =
        notes.map((note) => note.toJson()).toList();
    await prefs.setString(key, jsonEncode(noteList));
  }
}
