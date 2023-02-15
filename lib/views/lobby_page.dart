import 'dart:developer';
import 'dart:math' as m;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_hp_tracker/controllers/create_lobby.dart';
import 'package:dnd_hp_tracker/models/character.dart';
import 'package:dnd_hp_tracker/models/lobby.dart';
import 'package:dnd_hp_tracker/resources/images.dart';
import 'package:dnd_hp_tracker/resources/tools.dart';
import 'package:dnd_hp_tracker/widgets/containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import '../resources/classes.dart';
import '../styles/colours.dart';
import '../styles/textstyles.dart';
import 'launch.dart';

class LobbyPage extends StatefulWidget {
  LobbyPage({super.key, required this.lobby, required this.id, required this.monIndex});
  final Lobby lobby;
  final String id;
  int monIndex;

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> with SingleTickerProviderStateMixin {
  bool option = false;
  Duration animDur = const Duration(milliseconds: 500);
  int selIndex = 0;
  int characterTotal = 0;
  int selMonInit = 0;
  List characters = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (widget.id == widget.lobby.id) {
      log('Host left');
      disposeLobby(context);
    }
    else {
      log('User left');
      removeCharacter(context, widget.id);
    }
    super.dispose();
  }

  void createMonster() {
    TextEditingController monNameController = TextEditingController();

    showModalBottomSheet<void>(isScrollControlled: true, context: context, builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {

            List<Padding> rows = [];
            //If list % 3 is not 0, add remainder number of empty icons to list

            int count = 0;
            List<Widget> items = [];
            for (int i = 0; i < monsterIcons.length; i++) {
              bool sel = i == widget.monIndex;
              items.add(GestureDetector(
                  onTap: () {
                    log(i.toString());
                    setModalState(() {
                      widget.monIndex = i;
                    });
                    setState(() {
                      widget.monIndex = i;
                    });
                  },
                  child: getIconContainer(i, false, sel, monsterIcons))
              );
              count++;
              if (count == 3) {
                rows.add(Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: items,
                  ),
                ));
                items = [];
                count = 0;
              }
            }

            ListView mainGrid = ListView(
              children: rows,
            );

            return Container(
              color: widgetBackgroundRed,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24.0),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            'Select an icon for your monster.',
                            style: widgetContent,
                          ),
                        ),
                      ),
                    ),
                    Container(height: MediaQuery.of(context).size.height * 0.4, child: mainGrid),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text('Monster Name', style: widgetContent),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: monNameController,
                        style: widgetContent,
                        decoration: InputDecoration(
                          focusColor: widgetBackgroundRed,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Monster initiative', style: widgetContent),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: DropdownButtonFormField<int>(
                          dropdownColor: widgetBackgroundRed,
                          style: widgetContent,
                          isExpanded: true,
                          items: initiatives(),
                          onChanged: (value) {
                            setState(() {
                              selMonInit = value!;
                            });
                          }
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
                            //Create monster as character
                            //Pass character to firestore
                            loadingDialog(context);
                            Character mon = Character(
                                name: monNameController.text,
                                charClass: '',
                                initiative: selMonInit,
                                iconIndex: widget.monIndex,
                                currentHP: 0,
                                maxHP: 0,
                            );
                            bool success = await addMonster(context, mon, widget.lobby.id, generateRandomString());
                            if (success) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              log('Monster added');
                            }
                            else {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              notification(context, 'Failed to create monster!');
                            }
                          },
                          child: Icon(Icons.check, size: 30, color: widgetTextColour,),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
      );
    });
  }

  void _showTurnSnackBar(bool selected, bool matching) {
    if (selected && matching) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notification(context, 'It\'s your character\'s turn!');
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget lobbyCard(DocumentSnapshot doc, int index) {
      //Listen to the current turnIndex and update as appropriate
      //FirebaseFirestore.instance
      //    .collection('lobbies')
      //    .doc(widget.lobby.id)
      //    .snapshots()
      //    .listen((snapshot) {
      //  final data = snapshot.data() as Map<String, dynamic>;
      //  selIndex = data["turnIndex"];
      //  log('INDEX: $selIndex');
      //});

      //Add a 'selected' field to each character
      //If selIndex == characterIndex, update its selected field
      //On changing initiative, find the character with selected = true and change it to false

      //If it's your character, display a snack bar saying that
      _showTurnSnackBar(doc['selected'], widget.id == doc.id);

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              color: doc['selected'] ? widgetBackgroundRedDark : widgetBackgroundRed,
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
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getIconContainerSmall(doc['iconIndex'], index == selIndex ? true : false, doc['monster']? monsterIcons : characterIcons),
                const SizedBox(width: 12.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(doc['name'], style: widgetContent,),
                    Text(doc['charClass'], style: widgetContent),
                  ],
                ),
                const SizedBox(width: 12.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.bolt, color: widgetTextColour,),
                    Text(doc['initiative'].toString(), style: widgetContent,),
                  ],
                )
              ]
          ),
        ),
      );
    }

    Widget initiativeStream() {

      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('characters').where('lobbyID', isEqualTo: widget.lobby.id).orderBy('initiative', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return blockContainer(context, 'No characters found!', '', redBlockContainer);
            }
            else {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length + 1,
                  itemBuilder: (context, index) {
                    //Add a blank space underneath the last card so it's not cut off
                    //itemCount is increased for this
                    characters = snapshot.data.docs;
                    characterTotal = snapshot.data.docs.length;
                    if (index == snapshot.data.docs.length) {
                      return SizedBox(height: MediaQuery.of(context).size.height * 0.2);
                    }
                    log(index.toString());
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return lobbyCard(ds, index);
                  }
              );
            }
          },
        ),
      );
    }

    Widget initiativeTracker() {
      return IgnorePointer(
        ignoring: option? true : false,
        child: initiativeStream(),
      );
    }

    Widget characterHealthCard(DocumentSnapshot doc) {
      bool yourChar = doc.id == widget.lobby.id;
      log('My Device ID: ${widget.id}');
      log('My Lobby DocID: ${widget.lobby.id}');

      Widget takeDamage() {
        return InkWell(
          onTap: () async {
            log('Take damage');
            await takeDamageCharacter(context, doc);
            setState(() {

            });
          },
          child: Icon(Icons.arrow_drop_down_rounded, color: widgetTextColour,),
        );
      }

      Widget takeHealing() {
        return InkWell(
          onTap: () async {
            log('Take Healing');
            await takeHealingCharacter(context, doc);
            setState(() {

            });
          },
          child: Icon(Icons.arrow_drop_up_rounded, color: widgetTextColour,),
        );
      }

      return Column(
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                getIconContainerSmall(doc['iconIndex'], yourChar, characterIcons),
                const SizedBox(width: 24.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc['name'], style: widgetTitle, overflow: TextOverflow.ellipsis),
                    Text(doc['charClass'], style: widgetContent,),
                  ]
                ),
                const Spacer(),
                Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 12.0),
                      yourChar? takeHealing() : Container(),
                      const SizedBox(width: 12.0),
                      Column(
                          children: [
                            Icon(Icons.favorite, color: widgetTextColour,),
                            Text(doc['currentHP'].toString(), style: widgetContent,),
                          ]
                      ),
                      const SizedBox(width: 12.0),
                      yourChar? takeDamage() : Container(),
                      const SizedBox(width: 12.0),
                    ],
                  ),
                ),
              ]
          ),
          lineOut(),
        ],
      );
    }

    Widget healthTracker() {
      List<Widget> characterBlocks = [];
      for (var i in characters) {
        if (i['monster']) {
          continue;
        }
        characterBlocks.add(characterHealthCard(i));
      }


      return IgnorePointer(
        ignoring: option? false : true,
        child: Column(
          children: characterBlocks.isNotEmpty? characterBlocks : [
            Text('Health Tracker Empty!', style: widgetTitle,),
            Text('Invite players to your lobby to track their health points!', textAlign: TextAlign.center, style: widgetContent),
          ],
        )
      );
    }

    Widget pageContent() {
      log('Building page content');
      return Stack(
        children: [
          AnimatedOpacity(
              duration: animDur, opacity: option? 0.0 : 1.0,
              child: initiativeTracker()
          ),
          AnimatedOpacity(
              duration: animDur, opacity: option? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: blockContainerCustomContent(context, healthTracker(), redBlockContainer),
              )),
        ],
      );
    }

    Widget hostTools() {
      return Container(
        margin: const EdgeInsets.all(12.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        padding: const EdgeInsets.all(24.0),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                //Show modal menu to add a new monster to the initiative tracker
                createMonster();
              },
              child: Icon(Icons.add, color: widgetTextColour, size: 25,),
            ),
            const SizedBox(width: 12.0,),
            InkWell(
              onTap: () {
                //Show modal menu listing monsters that have been added and the option to delete them
              },
              child: Icon(Icons.person, color: widgetTextColour, size: 25,),
            ),
            const SizedBox(width: 12.0,),
            InkWell(
              onTap: () {

              },
              child: Icon(Icons.bolt, color: widgetTextColour, size: 25,),
            ),
            const SizedBox(width: 12.0,),
            InkWell(
              onTap: () async {
                if(characterTotal == 0) {
                  notification(context, 'No characters in the lobby!');
                  return;
                }
                int newIndex = selIndex + 1;
                if (newIndex == characterTotal || newIndex > characterTotal) {
                  newIndex = 0;
                }
                log('Number of characters: $characterTotal');
                bool success = await updateIndex(context, widget.lobby.id, newIndex);
                if (success) {
                  //Remove 'selected' from character at index selIndex
                  await removeSelectedInit(context, characters[selIndex].id);
                  //Add 'selected' for character at index newIndex
                  await addSelectedInit(context, characters[newIndex].id);
                  setState(() {
                    selIndex = newIndex;
                    log('New index is: $selIndex');
                  });
                }
                else {
                  notification(context, 'Error updating turn order! Please try again.');
                  return;
                }
              },
              child: Icon(Icons.next_plan_outlined, color: widgetTextColour, size: 25,),
            ),
          ],
        ),
      );
    }

    Widget detailsExpansionTile() {
      log('Build details expansion tile');
      return Container(
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
        child: ExpansionTile(
          leading: Text(widget.lobby.code.toString(), style: widgetContent,),
          trailing: Icon(Icons.arrow_drop_down_sharp, color: widgetTextColour,),
          title: Text(widget.lobby.name, style: widgetContent,),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: getIconContainer(widget.lobby.iconIndex, false, false, landscapeIcons),
                        ),
                      ],
                    )
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(widget.lobby.description, style: lobbyDescription,),
                        ),
                        const SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    Widget menuSelector() {
      log('Building menu selector');
      return Container(
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  option = false;
                });
              },
              child: Icon(Icons.bolt, color: widgetBackgroundRed, size: 25, shadows: option ? <Shadow>[const Shadow(color: Colors.white, blurRadius: 15.0)] : <Shadow>[Shadow(color: widgetBackgroundRedDark, blurRadius: 15.0)],),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  option = true;
                });
              },
              child: Icon(Icons.favorite, color: widgetBackgroundRed, size: 25, shadows: option ? <Shadow>[Shadow(color: widgetBackgroundRedDark, blurRadius: 15.0)] : <Shadow>[const Shadow(color: Colors.white, blurRadius: 15.0)],),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                alignment: Alignment.topCenter,
                child: const HomePage(),
              ),
            );
          },
          icon: Icon(Icons.cancel_outlined),
        ),
        backgroundColor: headerColour,
        title: Text('Lobby: ${widget.lobby.name}'),
      ),
      bottomNavigationBar: widget.id == widget.lobby.id? hostTools() : null,
      backgroundColor: backgroundColour,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            //lobbyDetails(),
            detailsExpansionTile(),
            menuSelector(),
            pageContent(),
            const SizedBox(height: 12.0,),
          ],
        ),
      ),
    );
  }
}