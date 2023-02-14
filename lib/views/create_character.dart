import 'dart:developer';
import 'dart:math' as m;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_hp_tracker/controllers/get_assets.dart';
import 'package:dnd_hp_tracker/resources/tools.dart';
import 'package:dnd_hp_tracker/views/launch.dart';
import 'package:dnd_hp_tracker/widgets/containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';

import '../models/character.dart';
import '../resources/boxes.dart';
import '../resources/classes.dart';
import '../resources/images.dart';
import '../styles/colours.dart';
import '../styles/textstyles.dart';

class CreateCharacter extends StatefulWidget {
  CreateCharacter({super.key,});

  int iconIndex = m.Random().nextInt(characterIcons.length);

  @override
  State<CreateCharacter> createState() => _CreateCharacterState();
}

class _CreateCharacterState extends State<CreateCharacter> with TickerProviderStateMixin {

  TextEditingController charName = TextEditingController();
  TextEditingController charClass = TextEditingController();
  String selectedClass = 'Barbarian';
  int selectedInitiative = 0;
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
            for (int i = 0; i < characterIcons.length; i++) {
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
                  child: getIconContainer(i, false, sel, characterIcons))
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
                            'Select a new character icon.',
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
    if (charName.text.isEmpty) {
      log('Name empty');
      notification(context, 'Please enter a character name!');
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
              Text('Add this character?', style: widgetContent,),
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
                          Text(charName.text, style: widgetTitle,),
                          const SizedBox(height: 12.0,),
                          Text('Class:', style: widgetContent,),
                          Text(selectedClass, style: widgetTitle,),
                          const SizedBox(height: 48.0),
                          InkWell(
                            onTap: () {
                              log('Back');
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel_sharp, size: 30, color: widgetTextColour,),
                          ),
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
                        getIconContainer(widget.iconIndex, true, false, characterIcons),
                        const SizedBox(height: 48.0),
                        InkWell(
                          onTap: () {
                            log('Next');
                            characterBox.add(
                                Character(
                                  name: charName.text,
                                  initiative: selectedInitiative,
                                  charClass: selectedClass,
                                  iconIndex: widget.iconIndex,
                                )
                            );
                            Navigator.pop(context);
                            notification(context, '${charName.text} added to character list!');
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRightWithFade,
                                alignment: Alignment.topCenter,
                                child: const HomePage(),
                              ),
                            );
                          },
                          child: Icon(Icons.check, size: 30, color: widgetTextColour,),
                        ),
                        const SizedBox(height: 12.0),
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

  @override
  Widget build(BuildContext context) {

    Widget ccHeader() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Character Name', style: widgetContent,),
            TextField(
              controller: charName,
              style: widgetContent,
            ),
            const SizedBox(height: 12.0),
            Text('Character Class', style: widgetContent,),
            Container(
              child: DropdownButtonFormField<String>(
                dropdownColor: widgetBackgroundRed,
                style: widgetContent,
                menuMaxHeight: 200,
                value: selectedClass,
                onChanged: (value) {
                  setState(() {
                    selectedClass = value!;
                  });
                },
                items: getClassesToDropdown(),
              ),
            ),
          ],
        ),
      );
    }

    Widget chooseInitiative() {
      return Container(
        child: Column(
          children: [
            Text('Initiative', style: widgetContent,),
            DropdownButtonFormField<int>(
                dropdownColor: widgetBackgroundRed,
                style: widgetContent,
                isExpanded: true,
                items: initiatives(),
                onChanged: (value) {
                  setState(() {
                    selectedInitiative = value!;
                  });
                }
            )
          ],
        )
      );
    }

    Widget iconContainer(int index) {
      Container icon = getIconContainer(index, true, false, characterIcons);

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
            blockContainer(context, 'Create Character', 'Creating a character is easy, just fill in the following fields and you\'ll be ready for any encounter!', redBlockContainer),
            const SizedBox(height: 12.0),
            blockContainerCustomContent(context, ccHeader(), redBlockContainer),
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
                    children: [
                      blockContainerCustomContent(context, chooseInitiative(), redBlockContainer),
                      const SizedBox(height: 12.0),
                      continueWidget(),
                    ],
                  )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}