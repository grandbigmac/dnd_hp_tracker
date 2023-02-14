import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_hp_tracker/resources/tools.dart';
import 'package:flutter/cupertino.dart';

import '../models/lobby.dart';

Future<bool> postLobby(BuildContext context, Lobby lobby) async {
  var id = await getDeviceId();
  var data = <String, dynamic>{
    'name': lobby.name,
    'description': lobby.description,
    'iconIndex': lobby.iconIndex,
    'code': lobby.code,
  };

  try {
    await FirebaseFirestore.instance.collection('lobbies').doc(id).set(data);
    return true;
  }
  catch (e) {
    notification(context, 'Error posting lobby! Please try again.');
    return false;
  }
}

Future<void> disposeLobby(BuildContext context) async {
  var id = await getDeviceId();
  try {
    await FirebaseFirestore.instance.collection('lobbies').doc(id).delete();
  }
  catch (e) {
    log('Failed to delete lobby');
  }
}