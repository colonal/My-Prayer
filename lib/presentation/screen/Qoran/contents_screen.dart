import 'package:flutter/material.dart';
import 'package:my_prayer/constnats/quran.dart';

class ContentsScreen extends StatelessWidget {
  const ContentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.separated(
          itemCount: quranInfo.length,
          separatorBuilder: (_, __) => Container(
            color: Colors.black,
            height: 1,
            width: double.infinity,
          ),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () =>
                Navigator.of(context).pop(quranInfo[index]["Number_Page"]),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Theme.of(context).backgroundColor,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    quranInfo[index]["Number"].toString(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18),
                  ),
                ),
                Container(
                  color: Theme.of(context).primaryColor,
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  child: Image.asset(quranInfo[index]["Descent"] == "مدنية"
                      ? "assets/images/civil.webp"
                      : "assets/images/kaaba.png"),
                ),
                Expanded(
                    child: Container(
                  color: Theme.of(context).primaryColor,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    quranInfo[index]["Name"].toString(),
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
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "آياتها",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14),
                          ),
                          Text(
                            quranInfo[index]["Number_Verses"].toString(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  color: Theme.of(context).backgroundColor,
                  child: Text(
                    quranInfo[index]["Number_Page"].toString(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
