import 'package:flutter/material.dart';
import 'package:flutter_pertemuan9/db/database_service.dart';
import 'package:go_router/go_router.dart';
import '../models/note.dart';
// import 'package:flutter_pertemuan9/utils/app_routes.dart';

// import 'package:hive_flutter/hive_flutter.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key, this.note});

  final Note? note;
  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late TextEditingController _title;
  late TextEditingController _description;
  DatabaseService databaseService = DatabaseService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _title = TextEditingController();
    _description = TextEditingController();
    if (widget.note != null) {
      _title.text = widget.note!.title;
      _description.text = widget.note!.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note != null ? "Edit note" : "add note",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _title,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                      hintText: "Title",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 48,
                      )),
                  validator: (value) {
                    if (value == "") {
                      return "the title must be empty";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _description,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: const InputDecoration(
                    hintText: "enter text here",
                    border: InputBorder.none,
                    hintStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                  validator: (value) {
                    if (value == "") {
                      return "the title must be empty";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            //add note
            Note note = Note(
              _title.text,
              _description.text,
              DateTime.now(),
            );

            if (widget.note != null) {
              await databaseService.editNote(widget.note!.key, note);
              GoRouter.of(context).pop();
            } else {
              await databaseService.addNote(note);
              GoRouter.of(context).pop();
            }
          }
        },
        label: const Text("Save"),
        icon: const Icon(
          color: Colors.red,
          Icons.save,
        ),
      ),
    );
  }
}
