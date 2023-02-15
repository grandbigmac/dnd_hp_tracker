import 'dart:developer';
import 'dart:math' as m;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_hp_tracker/models/lobby.dart';
import 'package:dnd_hp_tracker/resources/boxes.dart';
import 'package:dnd_hp_tracker/resources/images.dart';
import 'package:dnd_hp_tracker/resources/tools.dart';
import 'package:dnd_hp_tracker/widgets/containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import '../controllers/create_lobby.dart';
import '../models/character.dart';
import '../styles/colours.dart';
import '../styles/textstyles.dart';
import 'lobby_page.dart';

class LobbyList extends StatefulWidget {
  LobbyList({super.key, required this.selectedCharIndex});
  int selectedCharIndex;

  @override
  State<LobbyList> createState() => _LobbyListState();
}

class _LobbyListState extends State<LobbyList> with SingleTickerProviderStateMixin {

  TextEditingController lobbyIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void joinLobbyModal(DocumentSnapshot doc) {
    if (characterBox.length == 0) {
      notification(context, 'You must create a character before you can join a lobby!');
      return;
    }

    showModalBottomSheet<void>(isScrollControlled: true, context: context, builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext contextM, StateSetter setModalState) {

            List<Widget> icons = [];
            log('Character box length: ${characterBox.length}');
            for (int i = 0; i < characterBox.length; i++) {
              log('Icon index of i: ${characterBox.getAt(i).iconIndex}');
              icons.add(
                  GestureDetector(
                    onTap: () {
                      //Select this as the active icon
                      setModalState(() {
                        widget.selectedCharIndex = i;
                      });
                      log(widget.selectedCharIndex.toString());
                    },
                    child: Container(
                      child: Column(
                        children: [
                          const SizedBox(height: 12.0),
                          Text(characterBox.getAt(i).name, style: widgetContent,),
                          const SizedBox(height: 12.0,),
                          getHomePageCharacterIcon(characterBox.getAt(i).iconIndex!, i == widget.selectedCharIndex ? true : false,),
                          const SizedBox(height: 12.0),
                          Text(characterBox.getAt(i).charClass, style: widgetContent,),
                        ],
                      ),
                    ),
                  )
              );
              if (i == characterBox.length) {
                break;
              }
            }

            log('Widgets in icons list: ${icons.length}');

            Widget characterRow = Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: icons
            );

            return Scaffold(
              body: Container(
                height: MediaQuery.of(context).size.height,
                color: widgetBackgroundRed,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          height: 500,
                          child: Column(
                            children: [
                              Text('Join ${doc['name']}', style: widgetTitle,),
                              Text('Select a character.', style: widgetContent,),
                              const SizedBox(height: 12.0),
                              characterRow,
                              const SizedBox(height: 12.0),
                              Text('Enter lobby code to join:', style: widgetContent,),
                              Padding(
                                padding: const EdgeInsets.only(left: 48.0, right: 48.0),
                                child: TextField(
                                  maxLength: 3,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  controller: lobbyIdController,
                                  style: widgetContent,
                                  decoration: InputDecoration(
                                    focusColor: widgetBackgroundRed,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 48.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      log('Back');
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.cancel_sharp, size: 30, color: widgetTextColour,),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      //Confirm that the input lobby ID is equal to this lobby's ID
                                      bool success = doc['code'] == int.parse(lobbyIdController.text);
                                      log('Character: ${characterBox.getAt(widget.selectedCharIndex).name}');
                                      if (success) {
                                        log('Success!');
                                        log('Character: ${characterBox.getAt(widget.selectedCharIndex).name}');
                                        loadingDialog(context);
                                        //Join the lobby
                                        //Post character to firestore
                                        //Navigate to lobby page if posting is successful
                                        Character char = characterBox.getAt(widget.selectedCharIndex);
                                        Lobby lobby = Lobby(
                                            name: doc['name'],
                                            description: doc['description'],
                                            iconIndex: doc['iconIndex'],
                                            turnIndex: doc['turnIndex'],
                                            code: doc['code'],
                                            id: doc.id,
                                        );

                                        var devID = await getDeviceId();

                                        bool success = await joinLobby(context, char, doc.id);
                                        if (success) {
                                          Navigator.pop(context);
                                          log('Successful');
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.leftToRightWithFade,
                                              alignment: Alignment.topCenter,
                                              child: LobbyPage(lobby: lobby, id: devID!, monIndex: 0),
                                            ),
                                          );
                                        }
                                        else {
                                          Navigator.pop(context);
                                          notification(contextM, 'Failed joining lobby! Please try again.');
                                          return;
                                        }
                                      }
                                      else {
                                        notification(contextM, 'Lobby code incorrect!');
                                      }
                                    },
                                    child: Icon(Icons.check, size: 30, color: widgetTextColour,),
                                  ),
                                ],
                              )
                            ]
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget lobbyCard(DocumentSnapshot doc) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              color: widgetBackgroundRed,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 9,
                  offset: const Offset(0, 3),
                )
              ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(flex: 1, child: getIconContainerSmall(doc['iconIndex'], false, landscapeIcons)),
              Flexible(
                flex: 2,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc['name'], style: widgetTitle,),
                      Text('Lobby description', style: widgetContent, overflow: TextOverflow.ellipsis,),
                    ]
                ),
              ),
              const SizedBox(width: 12.0),
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    //Go to this lobby
                    lobbyIdController.text = '000';
                    joinLobbyModal(doc);
                  },
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: widgetTextColour,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget lobbyStream() {
      //This stream listens for changes to the firestore and automatically updates the list in real time

      return Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('lobbies').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return blockContainer(context, 'No lobbies found!', '', redBlockContainer);
            }
            else {
              return ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length + 1,
                itemBuilder: (context, index) {
                  //Add a blank space underneath the last card so it's not cut off
                  //itemCount is increased for this
                  if (index == snapshot.data.docs.length) {
                    return SizedBox(height: MediaQuery.of(context).size.height * 0.2);
                  }
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return lobbyCard(ds);
                }
              );
            }
          },
        ),
      );
    }

    Widget listHeader() {
      return blockContainer(context, 'Join a Lobby', 'Select a lobby to join using the correct lobby code.', redBlockContainer);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerColour,
        title: const Text('Lobby List'),
      ),
      backgroundColor: backgroundColour,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            listHeader(),
            lobbyStream(),
          ],
        ),
      ),
    );
  }
}