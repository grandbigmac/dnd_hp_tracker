import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/images.dart';
import '../styles/colours.dart';
import '../styles/textstyles.dart';

Container blockContainer(BuildContext context, String title, String content, LinearGradient colour) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(24.0),
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        gradient: colour,
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
          Text(title, style: widgetTitle,),
          Text(content, style: widgetContent)
        ]
    ),
  );
}

Container blockContainerCustomContent(BuildContext context, Widget content, LinearGradient colour) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(24.0),
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        gradient: colour,
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
          content
        ]
    ),
  );
}

Container getIconContainer(int index, bool big, bool selected, List<dynamic> list) {
  if (index == -1) {
    return Container();
  }
  return Container(
    height: big ? 125: 100, width: big? 125: 100,
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 5,
            blurRadius: 9,
            offset: const Offset(0, 3),
          )
        ],
        border: Border.all(color: selected? Colors.orange : widgetBackgroundRed, width: 5.0),
        borderRadius: BorderRadius.circular(125),
        image: DecorationImage(
          image: list[index],
          fit: BoxFit.cover,
        )
    ),
  );
}

Container getHomePageCharacterIcon(int index, bool selected) {
  if (index == -1) {
    return Container();
  }
  return Container(
    height: 75, width: 75,
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 5,
            blurRadius: 9,
            offset: const Offset(0, 3),
          )
        ],
        border: Border.all(color: selected? Colors.orange : widgetBackgroundRed, width: 5.0),
        borderRadius: BorderRadius.circular(125),
        image: DecorationImage(
          image: characterIcons[index],
          fit: BoxFit.cover,
        )
    ),
  );
}