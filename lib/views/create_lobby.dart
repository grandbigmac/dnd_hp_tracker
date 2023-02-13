import 'dart:developer';
import 'dart:math' as m;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_hp_tracker/widgets/containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import '../styles/colours.dart';
import '../styles/textstyles.dart';

class CreateLobby extends StatefulWidget {
  const CreateLobby({super.key,});

  @override
  State<CreateLobby> createState() => _CreateLobbyState();
}

class _CreateLobbyState extends State<CreateLobby> with SingleTickerProviderStateMixin {

  TextEditingController encounterName = TextEditingController();
  TextEditingController encounterDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

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

    Widget chooseIcon() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select an icon for your encounter:', style: widgetContent,),
            const SizedBox(height: 12.0),
            Center(
              child: Icon(Icons.account_circle_rounded),
            )
          ],
        )
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
            blockContainerCustomContent(context, chooseIcon(), redBlockContainer),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: blockContainerCustomContent(context, Container(), redBlockContainer),
                ),
                const SizedBox(width: 12.0),
                Flexible(
                  flex: 1,
                  child: blockContainerCustomContent(context, Container(), redBlockContainer),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}