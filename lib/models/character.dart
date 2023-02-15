import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character {
  @HiveField(0)
  String name;
  @HiveField(1)
  String charClass;
  @HiveField(2)
  int initiative;
  @HiveField(3)
  int iconIndex;
  @HiveField(4)
  int currentHP;
  @HiveField(5)
  int maxHP;

  Character({
    required this.name,
    required this.charClass,
    required this.initiative,
    required this.iconIndex,
    required this.currentHP,
    required this.maxHP,
  });
}