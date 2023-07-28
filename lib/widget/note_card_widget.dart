import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../model/note.dart';

class NoteCardWidget extends StatelessWidget {
  final Note note;
  final int index;
  const NoteCardWidget({super.key, required this.note, required this.index});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.yMMMd().format(note.createdTime);

    return CupertinoListTile(
      title:
          Text(note.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.desc,
            style: TextStyle(fontSize: 14, color: CupertinoColors.black),
          ),
          SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(fontSize: 14, color: CupertinoColors.black),
          ),
        ],
      ),
    );
  }
}
