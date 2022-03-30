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
