import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_hp_tracker/resources/tools.dart';
import 'package:flutter/cupertino.dart';

import '../models/character.dart';
import '../models/lobby.dart';

Future<bool> postLobby(BuildContext context, Lobby lobby) async {
  var id = await getDeviceId();
  var data = <String, dynamic>{
    'name': lobby.name,
    'description': lobby.description,
    'iconIndex': lobby.iconIndex,
    'code': lobby.code,
    'characters': [],
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
    var query = await FirebaseFirestore.instance.collection('characters').where('lobbyID', isEqualTo: id).get();
    for (var i in query.docs) {
      await i.reference.delete();
    }
  }
  catch (e) {
    log('Failed to delete lobby');
  }
}

Future<bool> joinLobby(BuildContext context, Character character) async {
  //POST CHARACTER STATS TO CHARACTERS COLLECTION
  bool success = false;
  var id = await getDeviceId();
  var data = <String, dynamic>{
    'name': character.name,
  };

  try {
    await FirebaseFirestore.instance.collection('characters').doc(id).set(data);
  }
  catch (e) {
    log('Failed to join lobby.');
  }

  return success;
}