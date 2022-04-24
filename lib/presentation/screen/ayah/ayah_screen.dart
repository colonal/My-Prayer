import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/ayah_cubit.dart';
import 'package:my_prayer/presentation/screen/loading_screen.dart';
import 'package:my_prayer/presentation/widgets/my_divider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../constnats/quran.dart';
import '../../../data/models/ayah.dart';
import '../../widgets/icon_button_responsive.dart';
import '../../widgets/text_responsive.dart';

class AyahScreen extends StatefulWidget {
  const AyahScreen({Key? key}) : super(key: key);

  @override
  State<AyahScreen> createState() => _AyahScreenState();
}

class _AyahScreenState extends State<AyahScreen> {
  late List<Ayah> ayahs;
  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionsListener;
  late PageController pageController;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 0,
      // keepPage: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AyahCubit, AyahState>(
        listener: ((context, state) {}),
        builder: (context, state) {
          AyahCubit cubit = AyahCubit.get(context);
          ayahs = cubit.ayahs;
          if (state is AyahLodingState) {
            return LoadingScreen(text: cubit.getText("Loading") ?? "Loading");
          }
          return Directionality(
            textDirection: cubit.isEn ? TextDirection.ltr : TextDirection.rtl,
            child: Scaffold(
              key: _key,
              drawer: Drawer(
                backgroundColor: Theme.of(context).backgroundColor,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(cubit.getText("Home") ?? "Home",
                              style: Theme.of(context).textTheme.headline2),
                          trailing: Icon(
                            Icons.home_filled,
                            color: Theme.of(context).cardColor,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            if (cubit.isFavorite) {
                              cubit.changeIsFavorite();
                            }
                          },
                        ),
                        ListTile(
                          title: Text(cubit.getText("Bookmark") ?? "Bookmark",
                              style: Theme.of(context).textTheme.headline2),
                          trailing: Icon(
                            Icons.bookmark_outlined,
                            color: Theme.of(context).cardColor,
                          ),
                          onTap: () async {
                            Navigator.of(context).pop();
                            pageController
                                .animateToPage(
                              cubit.indexSurah,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear,
                            )
                                .then((value) {
                              if (itemScrollController.isAttached) {
                                itemScrollController.scrollTo(
                                    index: 3,
                                    alignment: 0.5,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOutCubic);
                              }
                            });
                          },
                        ),
                        ListTile(
                          title: Text(cubit.getText("Favorite") ?? "Favorite",
                              style: Theme.of(context).textTheme.headline2),
                          trailing: Icon(
                            Icons.favorite,
                            color: Theme.of(context).cardColor,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            cubit.changeIsFavorite();
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
                              onTap: () {
                                Navigator.of(context).pop();
                                pageController.animateToPage(
                                  quranInfo[index]["Number"] - 1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear,
                                );
                              },
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
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Container(
                                    color: Theme.of(context).primaryColor,
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
                                    color: Theme.of(context).primaryColor,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      cubit.isEn
                                          ? quranInfo[index]["English_Name"]
                                              .toString()
                                          : quranInfo[index]["Name"].toString(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 18),
                                    ),
                                  )),
                                  Container(
                                    color: Theme.of(context).primaryColor,
                                    height: 50,
                                    width: 50,
                                    padding: const EdgeInsets.only(right: 2),
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              cubit.getText("verses") ??
                                                  "verses",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              quranInfo[index]["Number_Verses"]
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
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
              ),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                toolbarHeight: 50,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    TextResponsive(
                            text: cubit.isFavorite
                                ? cubit.getText("Favorite") ?? "Favorite"
                                : cubit.isEn
                                    ? ayahs[cubit.indexPage].transliteration
                                    : ayahs[cubit.indexPage].name,
                            maxSize: 20,
                            size: size)
                        .headline3(context),
                    IconButtonResponsive(
                      size: size,
                      icons: Icons.dehaze_rounded,
                      onPressed: () {
                        _key.currentState!.openDrawer();
                      },
                    ),
                  ],
                ),
                leading: IconButtonResponsive(
                  icons: cubit.isEn
                      ? Icons.arrow_back_ios_rounded
                      : Icons.arrow_back_ios_rounded,
                  size: size,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SizedBox(
                  height: size.height,
                  child: cubit.isFavorite
                      ? Column(
                          children: [
                            Flexible(
                              child: ListView.separated(
                                  itemCount: cubit.versesFavorite.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 20),
                                  itemBuilder: (context, index) =>
                                      buildVersesItems(
                                        context,
                                        cubit.versesFavorite[index][0],
                                        index,
                                        size,
                                        cubit,
                                        0,
                                      )),
                            ),
                          ],
                        )
                      : PageView.builder(
                          controller: pageController,
                          itemCount: ayahs.length,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (int index) {
                            cubit.setIndexPage(index);
                          },
                          itemBuilder: (context, index) {
                            itemScrollController = ItemScrollController();
                            itemPositionsListener =
                                ItemPositionsListener.create();
                            itemPositionsListener.itemPositions
                                .addListener(() => setState(() {}));
                            return buildItemAyah(cubit, ayahs[index], size,
                                cubit.indexSurah == index ? true : false);
                          })),
            ),
          );
        });
  }

  Widget buildItemAyah(AyahCubit cubit, Ayah ayah, Size size, bool savePage) {
    return Container(
      width: size.width,
      height: 200,
      padding: const EdgeInsets.all(20),
      child: ScrollablePositionedList.separated(
          initialScrollIndex: 0,
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemCount: ayah.verses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            return buildVersesItems(
                context, ayah.verses[index], index, size, cubit, ayah.id - 1,
                savePage: savePage, onPressed: () {
              cubit.changeSaveAyah(ayah.id - 1, ayah.verses[index].id - 1);
            });
          }),
    );
  }

  Widget buildVersesItems(BuildContext context, Verses verses, int index,
      Size size, AyahCubit cubit, int indexAyah,
      {bool savePage = false, dynamic Function()? onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextResponsive(
                        text: verses.id.toString(), maxSize: 20, size: size)
                    .headline3(context, bold: true),
              ),
              TextResponsive(text: verses.name, maxSize: 20, size: size)
                  .headline3(context, bold: true),
              Row(
                children: [
                  IconButtonResponsive(
                      icons: verses.favorite ?? false
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: size,
                      onPressed: () {
                        verses.favorite = !(verses.favorite ?? false);
                        cubit.addVersesFavorite(verses, indexAyah);
                      }),
                  if (!cubit.isFavorite)
                    IconButtonResponsive(
                        icons: (cubit.indexAyah == index && savePage)
                            ? Icons.bookmark
                            : Icons.bookmark_outline_outlined,
                        size: size,
                        onPressed: onPressed),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: buildDivider1(),
          ),
          const SizedBox(height: 10),
          Text(
            verses.text,
            style: TextStyle(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
              height: 2,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
