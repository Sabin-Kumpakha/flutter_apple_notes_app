import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../database/notes_database.dart';
import '../model/note.dart';
import '../widget/note_card_widget.dart';
import 'add_edit_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppbar = true;
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // i want to show the appbar only when i scroll up

      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!_showAppbar)
          setState(() {
            _showAppbar = true;
          });
      }
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (_showAppbar)
          setState(() {
            _showAppbar = false;
          });
      }
    });
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 60),
        child: NestedScrollView(
          controller: _scrollController,
          scrollBehavior: CupertinoScrollBehavior(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _silverAppBar(),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: [
                _textAndSearchBar(),
                _buildNotes(),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _bottomSheet(context),
    );
  }

  Widget _buildNotes() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: isLoading
            ? CircularProgressIndicator()
            : notes.isEmpty
                ? Center(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "No Notes Found",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  )
                : _buildListOfNotes(),
      ),
    );
  }

  Widget _textAndSearchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Text(
                "All Notes",
                style: TextStyle(fontSize: 28, color: CupertinoColors.black),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // SearchBar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CupertinoSearchTextField(
            padding: EdgeInsets.all(10),
            onChanged: (value) {
              print(value);
            },
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            "Notes",
            style: TextStyle(fontSize: 22, color: CupertinoColors.black),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _silverAppBar() {
    return SliverAppBar(
      backgroundColor: CupertinoColors.systemGrey6,
      title: Text(
        _showAppbar ? "Notes" : "",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
      ),
      pinned: true,
      centerTitle: true,
      floating: true,
      toolbarHeight: 50,
      leadingWidth: 120,
      leading: Row(
        children: [
          SizedBox(width: 10.0),
          Icon(
            CupertinoIcons.back,
            color: CupertinoColors.activeOrange,
            size: 24,
          ),
          Text(
            "Folders",
            style: TextStyle(fontSize: 20, color: CupertinoColors.activeOrange),
          ),
        ],
      ),
      actions: [
        InkWell(
          child: Icon(
            CupertinoIcons.ellipsis_circle,
            color: CupertinoColors.activeOrange,
            size: 24,
          ),
          onTap: () {},
        ),
        SizedBox(width: 16.0),
      ],
    );
  }

  Widget _bottomSheet(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(width: 30),
          Center(
            child: Text(
              // total number of notes
              "0 Notes",
              style: TextStyle(fontSize: 14, color: CupertinoColors.black),
            ),
          ),
          Spacer(),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: GestureDetector(
                  child: Icon(
                    CupertinoIcons.create,
                    color: CupertinoColors.activeOrange,
                    size: 24,
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddEditNotePage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListOfNotes() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notes.length,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      itemBuilder: (context, index) {
        final note = notes[index];
        return GestureDetector(
          onTap: () async {
            if (isLoading) return;

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddEditNotePage(note: note),
              ),
            );
            refreshNotes();
          },
          child: NoteCardWidget(note: note, index: index),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          thickness: 1,
          indent: 16,
          endIndent: 16,
          height: 24,
        );
      },
    );
  }
}
