import 'package:flutter/material.dart';

Color backgroundColour = Colors.white;
Color headerColour = Colors.red;
Color widgetBackground = const Color.fromRGBO(236, 105, 101, 1);
Color widgetBackgroundRed = const Color.fromRGBO(236, 105, 101, 1);
Color widgetBackgroundGreen = const Color.fromRGBO(49, 171, 16, 1.0);
Color widgetBackgroundPurple = const Color.fromRGBO(103, 12, 208, 1.0);
Color widgetBackgroundRedDark = const Color.fromRGBO(44, 40, 40, 1.0);
Color widgetBackgroundBlue = const Color.fromRGBO(101, 182, 236, 1);
Color widgetBackgroundYellow = const Color.fromRGBO(206, 153, 0, 1.0);
Color widgetTextColour = Colors.white;

LinearGradient blockContainerGradient = LinearGradient(
    begin: Alignment.center,
    end: Alignment.topRight,
    colors: [
      widgetBackground,
      widgetBackground.withAlpha(125),
    ]
);

LinearGradient darkBlockContainerGradient = LinearGradient(
    begin: Alignment.center,
    end: Alignment.topRight,
    colors: [
      widgetBackgroundRedDark,
      widgetBackgroundRedDark.withAlpha(20),
    ]
);