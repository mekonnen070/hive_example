import 'package:hive/hive.dart';
import 'package:hive_example/model/history_model.dart';

class Boxes {
  static Box<History> getHistories() => Hive.box<History>('history');
}
