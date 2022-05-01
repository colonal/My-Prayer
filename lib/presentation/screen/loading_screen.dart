import 'package:flutter/material.dart';
import '../widgets/text_responsive.dart';

class LoadingScreen extends StatelessWidget {
  final String text;
  final bool isLTR;
  const LoadingScreen({required this.text, this.isLTR = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: SafeArea(
          child: Directionality(
        textDirection: isLTR ? TextDirection.ltr : TextDirection.rtl,
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: Colors.green[900],
            image: const DecorationImage(
                image: AssetImage("assets/images/backgound.png"),
                fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/loading.gif",
                height: size.height * 0.4,
                width: size.width * 0.9,
              ),
              SizedBox(height: size.height * 0.05),
              TextResponsive(text: text, maxSize: 25, size: size)
                  .headline3(context, color: Colors.white, bold: true),
              SizedBox(height: size.height * 0.05),
              CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
