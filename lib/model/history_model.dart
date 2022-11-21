import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 0)
class History extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late DateTime createdDate;
  @HiveField(2)
  late double price;

  History({
    required this.name,
    required this.createdDate,
    required this.price,
  });
}
