import 'package:hive/hive.dart';
import 'package:hive_databse/models/notes_model.dart';

class Boxes{

  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}