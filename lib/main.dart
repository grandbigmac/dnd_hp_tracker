import 'dart:developer';

import 'package:dnd_hp_tracker/models/character.dart';
import 'package:dnd_hp_tracker/resources/boxes.dart';
import 'package:dnd_hp_tracker/styles/colours.dart';
import 'package:dnd_hp_tracker/views/launch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';

void main() async {
  //Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(CharacterAdapter());
  await Hive.openBox('character');
  await Hive.openBox('temp');
  await Hive.openBox('theme');
  characterBox = Hive.box('character');
  themeBox = Hive.box('theme');
  //Set the theme from hive box if there's a colour stored
  if (themeBox.isNotEmpty) {
    log('Found theme to set!');
    widgetBackground = themeBox.getAt(0);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Call this when you change an image
    //_____________________________
    //imageCache.clear();
    //_____________________________
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.white),
      ),
      home: const HomePage(),
    );
  }
}
