import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../database/notes_database.dart';
import '../model/note.dart';
import '../widget/note_form_widget.dart';
import 'home_page.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({Key? key, this.note}) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    title = widget.note?.title ?? '';
    description = widget.note?.desc ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemGrey6,
        toolbarHeight: 50,
        elevation: 0.0,
        leadingWidth: 120,
        leading: _leadingAppBar(context),
        actions: [
          deleteButton(),
          SizedBox(width: 8.0),
          buildButton(),
          SizedBox(width: 4.0),
        ],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          title: title,
          desc: description,
          onChangedTitle: (title) => setState(() => this.title = title),
          onChangedDescription: (description) =>
              setState(() => this.description = description),
        ),
      ),
      bottomSheet: _bottomSheet(),
    );
  }

  Container _bottomSheet() {
    return Container(
      height: 50,
      color: CupertinoColors.systemGrey6,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.checklist,
              color: CupertinoColors.activeOrange,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.camera,
              color: CupertinoColors.activeOrange,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.pencil_outline,
              color: CupertinoColors.activeOrange,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.create,
              color: CupertinoColors.activeOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _leadingAppBar(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          SizedBox(width: 8.0),
          Icon(CupertinoIcons.back, size: 24, color: CupertinoColors.activeOrange),
          Text(
            "All Notes",
            style: TextStyle(fontSize: 18, color: CupertinoColors.activeOrange),
          ),
        ],
      ),
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
    );
  }

  Widget deleteButton() => InkWell(
        child: Icon(
          CupertinoIcons.delete,
          color: CupertinoColors.activeOrange,
          size: 24,
        ),
        onTap: () async {
          await NotesDatabase.instance.delete(widget.note!.id!);
          Navigator.of(context).pop();
        },
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? Colors.orange.shade400 : Colors.red,
        ),
        onPressed: addOrUpdateNote,
        child: Text("Save"),
      ),
    );
  }

  Future addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;
      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copyWith(
      title: title,
      desc: description,
    );
    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      desc: description,
      createdTime: DateTime.now(),
    );
    await NotesDatabase.instance.createNote(note);
  }
}
