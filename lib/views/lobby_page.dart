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
  Duration animDur = const Duration(milliseconds: 500);
  int selIndex = 0;
  int characterTotal = 0;

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

    Widget lobbyCard(DocumentSnapshot doc, int index) {

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              color: index == selIndex ? widgetBackgroundRedDark : widgetBackgroundRed,
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
                getIconContainerSmall(doc['iconIndex'], index == selIndex ? true : false, characterIcons),
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
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('characters').where('lobbyID', isEqualTo: widget.lobby.id).orderBy('initiative', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return blockContainer(context, 'No lobbies found!', '', redBlockContainer);
            }
            else {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length + 1,
                  itemBuilder: (context, index) {
                    //Add a blank space underneath the last card so it's not cut off
                    //itemCount is increased for this
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

    Widget healthTracker() {
      return IgnorePointer(
        ignoring: option? false : true,
        child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Text('This is the health tracker', style: widgetTitle,)
        ),
      );
    }

    Widget pageContent() {
      return Stack(
        children: [
          AnimatedOpacity(
              duration: animDur, opacity: option? 0.0 : 1.0,
              child: initiativeTracker()
          ),
          AnimatedOpacity(
              duration: animDur, opacity: option? 1.0 : 0.0,
              child: blockContainerCustomContent(context, healthTracker(), redBlockContainer)),
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
              },
              child: Icon(Icons.add, color: widgetTextColour, size: 25,),
            ),
            const SizedBox(width: 12.0,),
            InkWell(
              onTap: () {
                //Show modal menu displaying all users currently connected
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
              onTap: () {
                setState(() {
                  if (selIndex == characterTotal) {
                    selIndex = 0;
                  }
                  else {
                    selIndex++;
                  }
                });
              },
              child: Icon(Icons.next_plan_outlined, color: widgetTextColour, size: 25,),
            ),
          ],
        ),
      );
    }

    Widget detailsExpansionTile() {
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

    Widget menuSelector() {
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
          icon: Icon(Icons.cancel_outlined),
        ),
        backgroundColor: headerColour,
        title: const Text('App Bar'),
      ),
      bottomNavigationBar: widget.id == widget.lobby.id? hostTools() : Container(),
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