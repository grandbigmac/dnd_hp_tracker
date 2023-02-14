import 'package:dnd_hp_tracker/styles/colours.dart';
import 'package:dnd_hp_tracker/styles/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as m;

void loadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator(),),
  );
}

void notification(BuildContext context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.up,
    backgroundColor: widgetBackgroundRedDark,
    content: Text(content, style: widgetContent,),
  ));
}

String generateRandomString() {
  int len = 3;
  var r = m.Random();
  const _chars = '1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}