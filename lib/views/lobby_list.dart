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

class LobbyList extends StatefulWidget {
  const LobbyList({super.key,});

  @override
  State<LobbyList> createState() => _LobbyListState();
}

class _LobbyListState extends State<LobbyList> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc['name'], style: widgetTitle,),
                Text('Lobby description', style: widgetContent),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        //Go to this lobby
                        log('Go!');
                      },
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: widgetTextColour,
                      ),
                    )
                  ],
                )
              ]
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
            lobbyStream(),
          ],
        ),
      ),
    );
  }
}