import 'dart:developer';
import 'dart:math' as m;
import 'package:dnd_hp_tracker/views/create_character.dart';
import 'package:dnd_hp_tracker/views/create_lobby.dart';
import 'package:dnd_hp_tracker/views/lobby_list.dart';
import 'package:dnd_hp_tracker/widgets/containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import '../styles/colours.dart';
import '../styles/textstyles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerColour,
        title: const Text('App Bar'),
      ),
      backgroundColor: backgroundColour,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        //Go to the list of available combat lobbies
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.leftToRightWithFade,
                            alignment: Alignment.topCenter,
                            child: const LobbyList(),
                          ),
                        );
                      },
                      child: blockContainer(context, 'Join Lobby', 'Join combat lobbies and track your teammates\' HP!', redBlockContainer)),
                  ),
                  const SizedBox(width: 12.0),
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        //Go to lobby creation
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.leftToRightWithFade,
                            alignment: Alignment.topCenter,
                            child: const CreateLobby(),
                          ),
                        );
                      },
                      child: blockContainer(context, 'Host Lobby', 'Create a lobby for your combat session to track your teammate\'s HP.', redBlockContainer)),
                  )
                ]
            ),
            const SizedBox(height: 12.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    alignment: Alignment.topCenter,
                    child: CreateCharacter(),
                  ),
                );
              },
              child: blockContainer(context, 'Create a Character', 'Set your character\'s name and HP to use in combat lobbies!', redBlockContainer),
            ),
          ],
        ),
      ),
    );
  }
}