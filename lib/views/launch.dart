import 'dart:developer';
import 'dart:math' as m;
import 'package:dnd_hp_tracker/resources/boxes.dart';
import 'package:dnd_hp_tracker/resources/images.dart';
import 'package:dnd_hp_tracker/resources/tools.dart';
import 'package:dnd_hp_tracker/views/create_character.dart';
import 'package:dnd_hp_tracker/views/create_lobby.dart';
import 'package:dnd_hp_tracker/views/lobby_list.dart';
import 'package:dnd_hp_tracker/widgets/containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
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

  void deleteCharacterAlert(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: widgetBackgroundRed,
        title: Text('Are you sure?', style: widgetTitle,),
        content: Text('Are you sure you\'d like to delete ${characterBox.getAt(index).name}?', style: widgetContent,),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: widgetContent,),
              ),
              TextButton(
                onPressed: () {
                  characterBox.deleteAt(index);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState(() {

                  });
                },
                child: Text('Yes', style: widgetContent,),
              )
            ],
          )
        ],
      ),
    );
  }

  void showCharacter(int index) {
    showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
      return Container(
        height: 300,
        color: widgetBackgroundRed,
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(top: 24,),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Character Name:', style: widgetContent,),
                            Text(characterBox.getAt(index).name, style: widgetTitle,),
                            const SizedBox(height: 12.0,),
                            Text('Class:', style: widgetContent,),
                            Text(characterBox.getAt(index).charClass, style: widgetTitle,),
                            const SizedBox(height: 12.0),
                            Text('Initiative Mod', style: widgetContent,),
                            Text(characterBox.getAt(index).initiative.toString(), style: widgetTitle,),
                            const SizedBox(height: 12.0),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 24,),
                          getIconContainer(characterBox.getAt(index).iconIndex, true, false, characterIcons),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite, color: widgetTextColour,),
                              const SizedBox(width: 12.0,),
                              Text(characterBox.getAt(index).maxHP.toString(), style: widgetContent,),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          InkWell(
                            onTap: () {
                              //Delete this character
                              deleteCharacterAlert(index);
                            },
                            child: Column(
                              children: [
                                Icon(Icons.cancel_rounded, color: widgetTextColour,),
                                Text('Delete', style: widgetContent,),
                              ],
                            )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      );
    });
  }

  Widget bottomBar() {
    //characterBox.clear();
    List<Widget> icons = [];
    log('Character box length: ${characterBox.length}');
    for (int i = 0; i < characterBox.length; i++) {
      log('Icon index of i: ${characterBox.getAt(i).iconIndex}');
      icons.add(
        GestureDetector(
          onTap: () {
            showCharacter(i);
          },
          child: Container(
            child: Column(
              children: [
                const SizedBox(height: 12.0),
                Text(characterBox.getAt(i).name, style: widgetContent,),
                const SizedBox(height: 12.0,),
                getHomePageCharacterIcon(characterBox.getAt(i).iconIndex!, false,),
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
    //characters.clear();
    //for (int i = 0; i < characterBox.length; i++) {
    //  characters.add(characterBox.get(i));
    //}
    //log(characters.length.toString());

    //Widget character(int index) {
    //  log('Character List: ${characters.length}');
    //  log('Box list: ${characterBox.length}');
    //  return Container(
    //    child: Column(
    //      children: [
    //        const SizedBox(height: 12.0,),
    //        getHomePageCharacterIcon(characters[index].iconIndex, false,),
    //        const SizedBox(height: 12.0),
    //        Text(characters[index].name, style: widgetContent,),
    //      ],
    //    ),
    //  );
    //}

    log('Widgets in icons list: ${icons.length}');

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: characterBox.isEmpty? 0.0 : 200,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            gradient: redBlockContainer,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 9,
                offset: const Offset(0, 3),
              )
            ]
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: icons
            ),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Hive.box('characters').clear();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerColour,
        title: const Text('App Bar'),
      ),
      bottomNavigationBar: bottomBar(),
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
                            child: LobbyList(selectedCharIndex: 0,),
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
                            child: CreateLobby(),
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
                if (characterBox.length == 3 || characterBox.length > 3) {
                  notification(context, 'Character limit reached! Delete a character to create a new one.');
                  return;
                }
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