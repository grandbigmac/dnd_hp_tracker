import 'dart:convert';

import 'package:dnd_hp_tracker/resources/classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<List> getCharacterIcons(BuildContext context) async {
  // Load as String
  final manifestContent =
  await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

  // Decode to Map
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  // Filter by path
  final filtered = manifestMap.keys
      .where((path) => path.startsWith('assets/images/characters/'))
      .toList();

  return filtered;
}

List<DropdownMenuItem<String>> getClassesToDropdown() {
  List<DropdownMenuItem<String>> result = [];
  for (String i in classes) {
    result.add(
      DropdownMenuItem(value: i,
        child: Container(
            child: Text(i)),)
    );
  }
  return result;
}

//Future<List>