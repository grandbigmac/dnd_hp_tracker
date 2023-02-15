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
  int init = rollD20(character.initiative);
  var data = <String, dynamic>{
    'name': character.name,
    'charClass': character.charClass,
    'iconIndex': character.iconIndex,
    'initiative': init,
    'lobbyID': lobbyID,
    'monster': false,
    'selected': false,
    'currentHP': character.currentHP,
    'maxHP': character.maxHP,
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
  int init = rollD20(character.initiative);
  var data = <String, dynamic>{
    'name': character.name,
    'charClass': character.charClass,
    'iconIndex': character.iconIndex,
    'initiative': init,
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

Future<void> removeSelectedInit(BuildContext context, String id) async {
  try {
    await FirebaseFirestore.instance.collection('characters').doc(id).update(
        {'selected': false});
  }
  catch (e) {
    log(e.toString());
  }
}

Future<void> addSelectedInit(BuildContext context, String id) async {
  try {
    await FirebaseFirestore.instance.collection('characters').doc(id).update(
        {'selected': true});
  }
  catch (e) {
    log(e.toString());
  }
}

Future<void> takeDamageCharacter(BuildContext context, DocumentSnapshot doc) async {
  int current = doc['currentHP'];
  int newCurrent = current - 1;
  if (newCurrent < 0) {
    newCurrent = 0;
  }

  try {
    await FirebaseFirestore.instance.collection('characters').doc(doc.id).update({
      'currentHP': newCurrent
    });
  }
  catch (e) {
    log(e.toString());
  }
}

Future<void> takeHealingCharacter(BuildContext context, DocumentSnapshot doc) async {
  int current = doc['currentHP'];
  int newCurrent = current + 1;
  if (newCurrent > doc['maxHP']) {
    newCurrent = doc['maxHP'];
  }

  try {
    await FirebaseFirestore.instance.collection('characters').doc(doc.id).update({
      'currentHP': newCurrent
    });
  }
  catch (e) {
    log(e.toString());
  }
}

Future<void> removeMonster(String id) async {
  try {
    await FirebaseFirestore.instance.collection('characters').doc(id).delete();
  }
  catch (e) {
    log(e.toString());
  }
}