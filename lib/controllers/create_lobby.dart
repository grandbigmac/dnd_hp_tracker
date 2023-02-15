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
    'turnIndex': lobby.turnIndex,
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

Future<bool> joinLobby(BuildContext context, Character character, String lobbyID) async {
  //POST CHARACTER STATS TO CHARACTERS COLLECTION
  bool success = false;
  var id = await getDeviceId();
  var data = <String, dynamic>{
    'name': character.name,
    'charClass': character.charClass,
    'iconIndex': character.iconIndex,
    'initiative': character.initiative,
    'lobbyID': lobbyID,
    'monster': false,
    'selected': false,
  };

  try {
    await FirebaseFirestore.instance.collection('characters').doc(id).set(data);
    success = true;
  }
  catch (e) {
    log('Failed to join lobby.');
    log(e.toString());
  }

  return success;
}

Future<bool> addMonster(BuildContext context, Character character, String lobbyID, String monID) async {
  //POST CHARACTER STATS TO CHARACTERS COLLECTION
  bool success = false;
  var data = <String, dynamic>{
    'name': character.name,
    'charClass': character.charClass,
    'iconIndex': character.iconIndex,
    'initiative': character.initiative,
    'lobbyID': lobbyID,
    'monster': true,
    'selected': false,
  };

  try {
    await FirebaseFirestore.instance.collection('characters').doc(monID).set(data);
    success = true;
  }
  catch (e) {
    log('Failed to join lobby.');
    log(e.toString());
  }

  return success;
}

Future<bool> removeCharacter(BuildContext context, String id) async {
  bool success = false;
  try {
    await FirebaseFirestore.instance.collection('characters').doc(id).delete();
    success = true;
  }
  catch (e) {
    log(e.toString());
  }
  return success;
}

Future<bool> updateIndex(BuildContext context, String lobbyID, int newIndex) async {
  bool success = false;
  try {
    await FirebaseFirestore.instance.collection('lobbies').doc(lobbyID).update(
        {'turnIndex': newIndex});
    success = true;
  }
  catch (e) {
    log(e.toString());
  }
  return success;
}