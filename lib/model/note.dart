final String tableNotes = "notes";

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, title, desc, time
  ];

  static final String id = "_id";
  static final String title = "title";
  static final String desc = "desc";
  static final String time = "time";
}

class Note {
  final int? id;
  final String title;
  final String desc;
  final DateTime createdTime;

  Note({
    this.id,
    required this.title,
    required this.desc,
    required this.createdTime,
  });

  Note copyWith({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? desc,
    DateTime? createdTime,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  static Note fromJson(Map<String, dynamic> json) => Note(
        id: json[NoteFields.id] as int?,
        title: json[NoteFields.title] as String,
        desc: json[NoteFields.desc] as String,
        createdTime: DateTime.parse(json[NoteFields.time] as String),
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      NoteFields.id: id,
      NoteFields.title: title,
      NoteFields.desc: desc,
      NoteFields.time: createdTime.toIso8601String(),
    };
  }
}
