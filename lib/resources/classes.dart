import 'package:flutter/material.dart';

List<String> classes = ['Artificer', 'Barbarian', 'Bard', 'Bloodhunter',
  'Cleric', 'Druid', 'Fighter', 'Monk', 'Paladin', 'Ranger', 'Rogue',
  'Sorcerer', 'Warlock', 'Wizard'];

List<DropdownMenuItem<int>> initiatives() {
  List initiatives = [-3, -2, -1, 0, 1, 2, 3, 4, 5];
  List<DropdownMenuItem<int>> init = [];
  for (int i = -3; i < 6; i++) {
    init.add(
      DropdownMenuItem(value: i, child: Center(child: Text('$i')))
    );
  }
  return init;
}