import 'dart:ui';

import 'package:flutter/material.dart';

import '../../helpers/cache_helper.dart';
import '../widgets/build_material_app.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List data = [
    [
      "assets/images/qoran.png",
      "Quran",
      " Read  Quran , bookmark your favourite page."
    ],
    [
      "assets/images/ayah.png",
      "Ayahs",
      " Read  Ayahs , Save your favorite verses, and come back to them at any time."
    ],
    [
      "assets/images/pray.png",
      "Azkar",
      "Read the dhikr from one of the categories, save your favorite dhikr, and return to it at any time, count the repetitions of the dhikr."
    ],
    [
      "assets/images/prayer.png",
      "Prayer Time",
      "Get Azan times for the whole month, Prayer time left."
    ]
  ];

  int indexPage = 0;
  late PageController controller;
  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
              child: Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
                color: Colors.green[900],
                image: const DecorationImage(
                    image: AssetImage("assets/images/backgound.png"),
                    fit: BoxFit.cover)),
          )),
          Positioned(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Colors.black.withOpacity(0.1)),
          )),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 50.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                      controller: controller,
                      itemCount: data.length,
                      onPageChanged: (index) {
                        indexPage = index;
                        setState(() {});
                      },
                      itemBuilder: (context, index) => Column(
                            children: [
                              Expanded(
                                  child: Image.asset(
                                data[index][0],
                              )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        data[index][1],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        data[index][2],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      if (data[index][1] == "Prayer Time")
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.warning_amber_rounded,
                                              color: Colors.redAccent,
                                              size: 40,
                                            ),
                                            SizedBox(width: 20),
                                            Expanded(
                                              child: Text(
                                                "Warning, the prayer time may be inaccurate",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    ],
                                  )),
                            ],
                          )),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                            data.length,
                            (index) => Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: newMethod(index == indexPage),
                                )),
                      ),
                      InkWell(
                        onTap: () {
                          controller.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.linear);
                          if (indexPage == data.length - 1) {
                            navigator();
                          }
                        },
                        child: const CircleAvatar(
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
              right: 10,
              top: 20,
              child: InkWell(
                onTap: () {
                  navigator();
                },
                child: const Text(
                  "skip",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ))
        ],
      )),
    );
  }

  AnimatedContainer newMethod(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: isActive ? 14 : 6,
      width: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive ? Colors.grey[900] : Colors.grey[500],
      ),
    );
  }

  void navigator() {
    CacheHelper.saveData(key: "onboarding", value: true);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BuildMaterialApp()));
  }
}
