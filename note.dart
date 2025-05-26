class Note {
  int id;
  String title;
  String content;
  String timestamp;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  // Convert Note object to JSON map
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'timestamp': timestamp,
      };

  // Convert JSON map to Note object
  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        timestamp: json['timestamp'],
      );
}
