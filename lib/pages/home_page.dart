import 'package:flutter/material.dart';
import 'package:flutter_pertemuan9/db/database_service.dart';
import 'package:flutter_pertemuan9/extentions/format_date.dart';
import 'package:flutter_pertemuan9/utils/app_routes.dart';
import 'package:go_router/go_router.dart';
import '../models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 236, 236),
      appBar: AppBar(
        title: const Text("Simple Note App"),
        shadowColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).goNamed(
            AppRoutes.addNote,
          );
        },
        child: const Icon(
          Icons.note_add_rounded,
          color: Colors.black,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(DatabaseService.boxName).listenable(),
        builder: (context, box, child) {
          if (box.isEmpty) {
            return const Center(
              child: Text('tidak ada catatan'),
            );
          } else {
            return ListView.separated(
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(box.getAt(index).key.toString()),
                  child: NoteCard(
                    note: box.getAt(index),
                  ),
                  onDismissed: (_) async {
                    await dbService.deleteNote(box.getAt(index)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("${box.getAt(index).title} telah dihapus"),
                      ));
                    });
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 8,
              ),
              itemCount: box.length,
            );
          }
        },
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      child: ListTile(
        onTap: () {
          GoRouter.of(context).pushNamed(
            AppRoutes.editNote,
            extra: note,
          );
        },
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          note.description,
          maxLines: 1,
        ),
        trailing: Text(note.createdAt.formatDate()),
      ),
    );
  }
}
