import 'package:flutter/material.dart';

class IconButtonResponsive extends StatelessWidget {
  final IconData icons;
  final Size size;
  final Function()? onPressed;
  final bool opacity;
  const IconButtonResponsive({
    required this.icons,
    required this.size,
    required this.onPressed,
    this.opacity = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icons,
          color: Theme.of(context).cardColor.withOpacity(opacity ? 0.7 : 1),
        ),
        iconSize: size.width > 200 ? 20 : size.width * 0.05,
        padding: EdgeInsets.all(size.width > 200 ? 0 : 0),
      ),
    );
  }
}
