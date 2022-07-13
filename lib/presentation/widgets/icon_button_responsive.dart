import 'package:flutter/material.dart';

class IconButtonResponsive extends StatelessWidget {
  final IconData icons;
  final Size size;
  final bool isBackGroundColor;
  final Function()? onPressed;
  final bool opacity;
  final double maxeSize;
  const IconButtonResponsive({
    required this.icons,
    required this.size,
    this.onPressed,
    this.isBackGroundColor = false,
    this.opacity = false,
    this.maxeSize = 20,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: onPressed == null
          ? Padding(
              padding: EdgeInsets.all(size.width > 200 ? 0 : 0),
              child: Icon(
                icons,
                color: isBackGroundColor
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context)
                        .cardColor
                        .withOpacity(opacity ? 0.7 : 1),
                size: size.width > 200 ? 20 : size.width * 0.05,
              ),
            )
          : IconButton(
              onPressed: onPressed,
              icon: Icon(icons,
                  color: isBackGroundColor
                      ? Theme.of(context).backgroundColor
                      : Theme.of(context)
                          .cardColor
                          .withOpacity(opacity ? 0.7 : 1)),
              iconSize: size.width > 200 ? maxeSize : size.width * 0.05,
              padding: EdgeInsets.all(size.width > 200 ? 0 : 0),
            ),
    );
  }
}
