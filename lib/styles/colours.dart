import 'package:flutter/material.dart';

Color backgroundColour = Colors.white;
Color headerColour = Colors.red;
Color widgetBackgroundRed = const Color.fromRGBO(236, 105, 101, 1);
Color widgetBackgroundRedDark = const Color.fromRGBO(44, 40, 40, 1.0);
Color widgetBackgroundBlue = const Color.fromRGBO(101, 182, 236, 1);
Color widgetBackgroundYellow = const Color.fromRGBO(234, 230, 72, 1);
Color widgetTextColour = Colors.white;

LinearGradient redBlockContainer = LinearGradient(
    begin: Alignment.center,
    end: Alignment.topRight,
    colors: [
      widgetBackgroundRed,
      widgetBackgroundRed.withAlpha(125),
    ]
);

LinearGradient redDarkBlockContainer = LinearGradient(
    begin: Alignment.center,
    end: Alignment.topRight,
    colors: [
      widgetBackgroundRedDark,
      widgetBackgroundRedDark.withAlpha(20),
    ]
);