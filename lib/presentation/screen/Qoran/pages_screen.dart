import 'package:flutter/material.dart';

import '../../../constnats/quran.dart';

class PagesScreen extends StatefulWidget {
  const PagesScreen({Key? key}) : super(key: key);

  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  int indexQuranInfo = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.separated(
          itemCount: 569,
          separatorBuilder: (_, __) => Container(
            color: Colors.black,
            height: 1,
            width: double.infinity,
          ),
          itemBuilder: (context, index) {
            for (int indexItme = 0; indexItme < quranInfo.length; ++indexItme) {
              if (quranInfo[indexItme]["Number_Page"] <= index + 1 &&
                  index + 1 < quranInfo[indexItme + 1]["Number_Page"]) {
                indexQuranInfo = indexItme;
                debugPrint("indexQuranInfo 0: $indexQuranInfo");
                break;
              }
            }
            return InkWell(
              onTap: () => Navigator.of(context).pop(index + 1),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    color: Theme.of(context).backgroundColor,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      quranInfo[indexQuranInfo]["Number"].toString(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 18),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Theme.of(context).primaryColor,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      quranInfo[indexQuranInfo]["Name"].toString(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 18),
                    ),
                  )),
                  Container(
                    color: Theme.of(context).primaryColor,
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    child: Image.asset(
                        quranInfo[indexQuranInfo]["Descent"] == "مدنية"
                            ? "assets/images/civil.webp"
                            : "assets/images/kaaba.png"),
                  ),
                  Container(
                    width: 100,
                    height: 50,
                    alignment: Alignment.center,
                    color: Theme.of(context).backgroundColor,
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )),
    );
  }
}
