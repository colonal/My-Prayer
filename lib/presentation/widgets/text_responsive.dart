import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextResponsive {
  final String text;
  final double maxSize;
  final Size size;
  const TextResponsive(
      {required this.text,
      required this.maxSize,
      required this.size,
      Key? key});

  Widget headline1(context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Text(text,
          style: GoogleFonts.arvo(
              textStyle: Theme.of(context).textTheme.headline1!.copyWith(
                  fontSize: size.height > 435
                      ? maxSize
                      : (size.height * 0.3) * 0.2))),
    );
  }

  Widget headline2(
    context, {
    Color? color,
    bool bold = true,
  }) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Text(
        text,
        style: GoogleFonts.robotoMono(
          textStyle: Theme.of(context).textTheme.headline2!.copyWith(
              color: color,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize:
                  size.height > 530 ? maxSize : (size.height * 0.3) * 0.1),
        ),
      ),
    );
  }

  Widget headline3(context,
      {bool bold = false, Color? color, int maxLines = 2}) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headline3!.copyWith(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: size.width > 480
                  ? maxSize
                  : size.width > 250
                      ? size.width * 0.040
                      : size.width * 0.04,
              color: color,
            ),
      ),
    );
  }

  Widget headline4(context,
      {bool bold = false, Color? color, int maxLines = 2}) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headline3!.copyWith(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: size.width > 250
                  ? maxSize
                  : size.width > 100
                      ? size.width * 0.040
                      : size.width * 0.04,
              color: color,
            ),
      ),
    );
  }
}
