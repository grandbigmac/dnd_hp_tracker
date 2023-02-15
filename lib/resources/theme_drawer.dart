import 'dart:developer';

import 'package:dnd_hp_tracker/resources/boxes.dart';
import 'package:dnd_hp_tracker/styles/colours.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../styles/textstyles.dart';
import '../views/launch.dart';

Drawer drawer(BuildContext context) {
  return Drawer(
    key: GlobalKey(),
    backgroundColor: widgetBackground,
    child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
          Container(
            padding: const EdgeInsets.all(24.0),
            color: widgetBackground,
            child: Center(
              child: Text('Change Theme', style: widgetTitle,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Colors.white
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      //Change theme
                      log('Tap red');
                      widgetBackground = widgetBackgroundRed;
                      themeBox.put(0, widgetBackground);
                      blockContainerGradient = LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topRight,
                          colors: [
                            widgetBackground,
                            widgetBackground.withAlpha(125),
                          ]
                      );

                      darkBlockContainerGradient = LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topRight,
                          colors: [
                            widgetBackgroundRedDark,
                            widgetBackgroundRedDark.withAlpha(20),
                          ]
                      );
                      headerColour = Colors.red;
                      gotoHome(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: widgetBackgroundRed, size: 40,),
                        const SizedBox(width: 24.0),
                        Text('Red Theme', style: drawerText,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  InkWell(
                    onTap: () {
                      //Change theme
                      log('Tap blue');
                      widgetBackground = widgetBackgroundBlue;
                      themeBox.put(0, widgetBackground);
                      blockContainerGradient = LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topRight,
                          colors: [
                            widgetBackground,
                            widgetBackground.withAlpha(125),
                          ]
                      );

                      darkBlockContainerGradient = LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topRight,
                          colors: [
                            widgetBackgroundRedDark,
                            widgetBackgroundRedDark.withAlpha(20),
                          ]
                      );
                      headerColour = Colors.blue;
                      gotoHome(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: widgetBackgroundBlue, size: 40,),
                        const SizedBox(width: 24.0),
                        Text('Blue Theme', style: drawerText,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  InkWell(
                    onTap: () {
                      //change theme
                      log('Tap yellow');
                      widgetBackground = widgetBackgroundYellow;
                      themeBox.put(0, widgetBackground);
                      blockContainerGradient = LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topRight,
                          colors: [
                            widgetBackground,
                            widgetBackground.withAlpha(125),
                          ]
                      );

                      darkBlockContainerGradient = LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topRight,
                          colors: [
                            widgetBackgroundRedDark,
                            widgetBackgroundRedDark.withAlpha(20),
                          ]
                      );
                      headerColour = Colors.yellow.shade800;
                      gotoHome(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: widgetBackgroundYellow, size: 40,),
                        const SizedBox(width: 24.0),
                        Text('Yellow Theme', style: drawerText,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  InkWell(
                    onTap: () {
                      //change theme
                      log('Tap green');
                      widgetBackground = widgetBackgroundGreen;
                      themeBox.put(0, widgetBackground);
                      blockContainerGradient = LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topRight,
                          colors: [
                            widgetBackground,
                            widgetBackground.withAlpha(125),
                          ]
                      );

                      darkBlockContainerGradient = LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topRight,
                          colors: [
                            widgetBackgroundRedDark,
                            widgetBackgroundRedDark.withAlpha(20),
                          ]
                      );
                      headerColour = Colors.green;
                      gotoHome(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: widgetBackgroundGreen, size: 40,),
                        const SizedBox(width: 24.0),
                        Text('Green Theme', style: drawerText,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  InkWell(
                    onTap: () {
                      //change theme
                      log('Tap purple');
                      widgetBackground = widgetBackgroundPurple;
                      themeBox.put(0, widgetBackground);
                      blockContainerGradient = LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topRight,
                          colors: [
                            widgetBackground,
                            widgetBackground.withAlpha(125),
                          ]
                      );

                      darkBlockContainerGradient = LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topRight,
                          colors: [
                            widgetBackgroundRedDark,
                            widgetBackgroundRedDark.withAlpha(20),
                          ]
                      );
                      headerColour = Colors.purple.shade600;
                      gotoHome(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: widgetBackgroundPurple, size: 40,),
                        const SizedBox(width: 24.0),
                        Text('Purple Theme', style: drawerText,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ]
              ),
            ),
          )
        ]
    ),
  );
}

void gotoHome(BuildContext context) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRightWithFade,
      alignment: Alignment.topCenter,
      child: HomePage(),
    ),
  );
}