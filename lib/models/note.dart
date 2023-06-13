import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveType(typeId: 0)
  late String title;

  @HiveType(typeId: 1)
  late String description;

  @HiveType(typeId: 2)
  late DateTime createdAt;

  Note(
    this.title,
    this.description,
    this.createdAt,
  );
}
