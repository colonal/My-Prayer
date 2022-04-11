import 'package:flutter/material.dart';

SizedBox buildDivider({bool isVertical = false}) {
  return SizedBox(
    height: isVertical ? 39 : 10,
    child: Center(
        child: isVertical
            ? VerticalDivider(
                width: 5,
                color: Colors.black.withOpacity(0.6),
              )
            : const Divider()),
  );
}

SizedBox buildDivider1({bool isVertical = false,Color color =Colors.white}) {
  return SizedBox(
    height: isVertical ? 30 : 1,
    child: Center(
        child: isVertical
            ?  VerticalDivider(
                width: 5,
                color: color,
              )
            : Divider(
                color: color.withOpacity(0.6),
              )),
  );
}
