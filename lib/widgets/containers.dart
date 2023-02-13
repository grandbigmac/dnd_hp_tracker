import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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