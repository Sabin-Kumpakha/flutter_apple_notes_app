import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final String? title;
  final String? desc;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    this.title = '',
    this.desc = '',
    required this.onChangedTitle,
    required this.onChangedDescription,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(),
            SizedBox(height: 8),
            buildDescription(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildDescription() {
    return TextFormField(
      maxLines: 30,
      initialValue: desc,
      style: TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Type something...',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      validator: (title) =>
          title != null && title.isEmpty ? 'The description cannot be empty' : null,
      onChanged: onChangedDescription,
    );
  }

  Widget buildTitle() {
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      validator: (title) =>
          title != null && title.isEmpty ? 'The title cannot be empty' : null,
      onChanged: onChangedTitle,
    );
  }
}
