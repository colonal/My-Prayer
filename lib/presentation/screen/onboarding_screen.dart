import 'package:flutter/material.dart';
import 'package:my_prayer/presentation/screen/home_screen.dart';

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
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
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
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data[index][1],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    data[index][2],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18,
                                    ),
                                  ),
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
                child: Text(
                  "skip",
                  style: TextStyle(
                    color: Colors.grey[700],
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
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BuildMaterialApp()));
  }
}
