import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart' as d;
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

Future<String?> getDeviceId() async {
  var deviceInfo = d.DeviceInfoPlugin();
  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if(Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
}

int rollD20(int mod) {
  var rng = m.Random();
  return rng.nextInt(20) + 1 + mod;
}