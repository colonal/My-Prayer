import 'package:flutter/material.dart';

import '../../../business_logic/cubit/ayah_cubit.dart';
import '../../../constnats/quran.dart';
import '../../widgets/my_divider.dart';

class DrawerScreen extends StatelessWidget {
  final AyahCubit cubit;
  final void Function()? onTapBookmark;
  final void Function(dynamic)? onTap;
  const DrawerScreen(
      {required this.cubit, this.onTapBookmark, this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(cubit.getText("Home") ?? "Home",
                    style: Theme.of(context).textTheme.headline3),
                trailing: Icon(
                  Icons.home_filled,
                  color: Theme.of(context).cardColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  if (cubit.isFavorite) {
                    cubit.changeIsFavorite();
                  }
                  if (cubit.isSearch) {
                    cubit.changeSeach();
                  }
                },
              ),
              ListTile(
                title: Text(cubit.getText("Bookmark") ?? "Bookmark",
                    style: Theme.of(context).textTheme.headline3),
                trailing: Icon(
                  Icons.bookmark_outlined,
                  color: Theme.of(context).cardColor,
                ),
                onTap: onTapBookmark,
              ),
              ListTile(
                title: Text(cubit.getText("Favorite") ?? "Favorite",
                    style: Theme.of(context).textTheme.headline3),
                trailing: Icon(
                  Icons.favorite,
                  color: Theme.of(context).cardColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  cubit.changeIsFavorite();
                },
              ),
              ListTile(
                title: Text(cubit.getText("Search") ?? "Seacrh",
                    style: Theme.of(context).textTheme.headline3),
                trailing: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).cardColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  cubit.changeSeach();
                },
              ),
              buildDivider1(),
              Flexible(
                child: ListView.separated(
                  itemCount: quranInfo.length,
                  separatorBuilder: (_, __) => Container(
                    color: Colors.black,
                    height: 1,
                    width: double.infinity,
                  ),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => onTap!(index),
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
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.6),
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          child: Image.asset(
                              quranInfo[index]["Descent"] == "مدنية"
                                  ? "assets/images/civil.webp"
                                  : "assets/images/kaaba.png"),
                        ),
                        Expanded(
                            child: Container(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.6),
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            cubit.isEn
                                ? quranInfo[index]["English_Name"].toString()
                                : quranInfo[index]["Name"].toString(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 18),
                          ),
                        )),
                        Container(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.6),
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.only(right: 2),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    cubit.getText("verses") ?? "verses",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    quranInfo[index]["Number_Verses"]
                                        .toString(),
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
