import 'dart:developer';
import 'dart:math' as m;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_hp_tracker/controllers/create_lobby.dart';
import 'package:dnd_hp_tracker/models/lobby.dart';
import 'package:dnd_hp_tracker/resources/images.dart';
import 'package:dnd_hp_tracker/widgets/containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import '../styles/colours.dart';
import '../styles/textstyles.dart';
import 'launch.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key, required this.lobby, required this.id});
  final Lobby lobby;
  final String id;

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> with SingleTickerProviderStateMixin {
  bool option = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    disposeLobby(context);
  }

  @override
  Widget build(BuildContext context) {

    Widget lobbyDetails() {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  getIconContainer(widget.lobby.iconIndex, false, false, landscapeIcons),
                  const SizedBox(height: 12.0),
                  Text(widget.lobby.code.toString(), style: widgetTitle,),
                ],
              )
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.lobby.name, style: widgetTitle,),
                    const SizedBox(height: 12.0),
                    Container(
                      height: 100,
                      child: ListView(
                        children: [
                          Text(widget.lobby.description, style: lobbyDescription,),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget hostTools() {
      if (widget.lobby.id != widget.id) {
        return Container();
      }
      else {
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
          icon: Icon(Icons.arrow_back_rounded),
        ),
        backgroundColor: headerColour,
        title: const Text('App Bar'),
      ),
      backgroundColor: backgroundColour,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            lobbyDetails(),
            hostTools(),
          ],
        ),
      ),
    );
  }
}