import 'dart:developer';
import 'dart:math' as m;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_hp_tracker/controllers/create_lobby.dart';
import 'package:dnd_hp_tracker/models/lobby.dart';
import 'package:dnd_hp_tracker/resources/images.dart';
import 'package:dnd_hp_tracker/resources/tools.dart';
import 'package:dnd_hp_tracker/widgets/containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import '../styles/colours.dart';
import '../styles/textstyles.dart';
import 'lobby_page.dart';

class CreateLobby extends StatefulWidget {
  CreateLobby({super.key,});
  int iconIndex = m.Random().nextInt(landscapeIcons.length);
  int lobbyID = int.parse(generateRandomString());

  @override
  State<CreateLobby> createState() => _CreateLobbyState();
}

class _CreateLobbyState extends State<CreateLobby> with TickerProviderStateMixin {

  TextEditingController encounterName = TextEditingController();
  TextEditingController encounterDescription = TextEditingController();
  late AnimationController iconAnim;
  late AnimationController continueAnim;
  late double iconScale;
  late double continueScale;

  @override
  void initState() {
    iconAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {

      });
    });
    continueAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    iconAnim.dispose();
    super.dispose();
  }

  void iconAnimActive(TapDownDetails details) {
    iconAnim.forward().whenComplete(() => iconAnim.reverse());
  }

  void continueAnimActive(TapDownDetails details) {
    continueAnim.forward().whenComplete(() => continueAnim.reverse());
  }

  void showIconSelection() {
    showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {

            List<Padding> rows = [];
            //If list % 3 is not 0, add remainder number of empty icons to list

            int count = 0;
            List<Widget> items = [];
            for (int i = 0; i < landscapeIcons.length; i++) {
              bool sel = i == widget.iconIndex;
              items.add(GestureDetector(
                  onTap: () {
                    log(i.toString());
                    setModalState(() {
                      widget.iconIndex = i;
                    });
                    setState(() {
                      widget.iconIndex = i;
                    });
                  },
                  child: getIconContainer(i, false, sel, landscapeIcons))
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(height: MediaQuery.of(context).size.height * 0.45, child: mainGrid),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            'Select a new landscape icon.',
                            style: widgetContent,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      );
    });
  }

  void continueButton() {
    //Take all fields and create a character to add to the hivebox
    //Check that fields have been filled
    if (encounterName.text.isEmpty || encounterDescription.text.isEmpty) {
      log('Name empty');
      notification(context, 'Please fill all fields!');
      return;
    }

    showModalBottomSheet<void>(isDismissible: false, enableDrag: false, context: context, builder: (BuildContext context) {
      return Container(
        height: 300,
        color: widgetBackgroundRed,
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                const SizedBox(height: 12.0),
                Text('Create this lobby?', style: widgetContent,),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(top: 24, left: 12.0, right: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12.0),
                            Text('Encounter Name:', style: widgetContent,),
                            Text(encounterName.text, style: widgetTitle,),
                            const SizedBox(height: 12.0,),
                            Text(encounterDescription.text, style: widgetContent, overflow: TextOverflow.ellipsis,),
                            const SizedBox(height: 48.0),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24,),
                          getIconContainer(widget.iconIndex, true, false, landscapeIcons),
                        ],
                      ),
                    ),
                  ],
                ),
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
                        loadingDialog(context);
                        var id = await getDeviceId();
                        Lobby lobby = Lobby(
                            name: encounterName.text,
                            description: encounterDescription.text,
                            iconIndex: widget.iconIndex,
                            code: widget.lobbyID,
                            id: id!,
                        );
                        bool result = await postLobby(context, lobby);

                        if (result) {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRightWithFade,
                              alignment: Alignment.topCenter,
                              child: LobbyPage(lobby: lobby, id: id,),
                            ),
                          );
                        }
                      },
                      child: Icon(Icons.check, size: 30, color: widgetTextColour,),
                    ),
                  ],
                )
              ],
            )
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {

    Widget continueWidget() {
      continueScale = 1 - continueAnim.value;
      return Container(
          width: MediaQuery.of(context).size.width,
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
          child: Center(
            child: GestureDetector(
              onTapDown: continueAnimActive,
              onTap: () {

              },
              child: Transform.scale(
                scale: continueScale,
                child: InkWell(
                  onTap: () {
                    continueButton();
                  },
                  child: Icon(Icons.add_circle_outline_sharp, size: 50, color: widgetTextColour,),
                ),
              ),
            ),
          )
      );
    }

    Widget iconContainer(int index) {
      Container icon = getIconContainer(index, true, false, landscapeIcons);

      iconScale = 1 - iconAnim.value;

      return GestureDetector(
        onTapDown: iconAnimActive,
        onTap: () {
          showIconSelection();
        },
        child: Transform.scale(
          scale: iconScale,
          child: icon,
        ),
      );
    }

    Widget chooseIcon() {
      return Container(
          child: Column(
            children: [
              Text('Icon', style: widgetContent, textAlign: TextAlign.center,),
              const SizedBox(height: 12.0),
              iconContainer(widget.iconIndex),
            ],
          )
      );
    }

    Widget registerContent() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Encounter Name', style: widgetContent,),
            TextField(
              controller: encounterName,
              style: widgetContent,
              decoration: InputDecoration(
                focusColor: widgetBackgroundRed,
              ),
            ),
            const SizedBox(height: 12.0),
            Text('Encounter Description', style: widgetContent,),
            Container(
              child: TextField(
                controller: encounterDescription,
                style: widgetContent,
                keyboardType: TextInputType.multiline,
                minLines: 1,//Normal textInputField will be displayed
                maxLines: 5,// when user presses enter it will adapt to it
              ),
            ),
          ],
        ),
      );
    }

    Widget lobbyPassword() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text('Code', style: widgetContent,)),
            const SizedBox(height: 12.0),
            Text(widget.lobbyID.toString(), style: widgetTitle,),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerColour,
        title: const Text('App Bar'),
      ),
      backgroundColor: backgroundColour,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            blockContainer(context, 'Create Lobby', 'To create a new lobby for your combat encounter, please enter the following details:', redBlockContainer),
            const SizedBox(height: 12.0),
            blockContainerCustomContent(context, registerContent(), redBlockContainer),
            const SizedBox(height: 12.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: blockContainerCustomContent(context, chooseIcon(), redBlockContainer),
                ),
                const SizedBox(width: 12.0),
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      blockContainerCustomContent(context, lobbyPassword(), redBlockContainer),
                      const SizedBox(height: 12.0),
                      continueWidget()
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}