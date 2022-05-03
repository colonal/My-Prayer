import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/cubit/ayah_cubit.dart';
import 'drawer_screen.dart';
import '../loading_screen.dart';
import '../../widgets/my_divider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

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
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 0,
    );
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    pageController.dispose();
    super.dispose();
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
              drawer: DrawerScreen(
                cubit: cubit,
                onTapBookmark: () async {
                  Navigator.of(context).pop();
                  if (cubit.isSearch) {
                    cubit.changeSeach();
                  }
                  if (cubit.isFavorite) {
                    cubit.changeIsFavorite();
                  }
                  await Future.delayed(const Duration(milliseconds: 500));
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
                onTap: (index) {
                  Navigator.of(context).pop();
                  pageController.animateToPage(
                    quranInfo[index]["Number"] - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                },
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
                    cubit.isSearch
                        ? buildSearchField(cubit, width: size.width * 0.5)
                        : TextResponsive(
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
                      : cubit.isSearch
                          ? cubit.ayahsSeash.isEmpty
                              ? Center(
                                  child: Text(
                                    cubit.getText("NotSearch") ??
                                        "No search results. Search in Arabic only",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                )
                              : Column(
                                  children: [
                                    Flexible(
                                      child: ListView.separated(
                                          itemCount: cubit.ayahsSeash.length,
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 20),
                                          itemBuilder: (context, index) =>
                                              buildVersesItems(
                                                context,
                                                cubit.ayahsSeash[index],
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
                  IconButtonResponsive(
                    icons: Icons.ios_share_rounded,
                    size: size,
                    onPressed: () {
                      _onShare(
                          context,
                          "${verses.name}\n${verses.text}  (${verses.id})",
                          "Ayah");
                    },
                  ),
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
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontSize: 20,
                  height: 2,
                ),
            maxLines: 10,
          ),
        ],
      ),
    );
  }

  Widget buildSearchField(cubit, {width}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
          height: 40,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).cardColor, width: 1),
            color: Theme.of(context).cardColor.withOpacity(0.2),
          ),
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Colors.grey[50],
                fontSize: 16,
              ),
              icon: Icon(
                Icons.search,
                color: Colors.grey[50],
              ),
            ),
            style: TextStyle(
              color: Colors.grey[50],
              fontSize: 18,
            ),
            cursorColor: Colors.white,
            onChanged: (String text) {
              cubit.search(text);
            },
          ),
        ),
      ),
    );
  }

  void _onShare(context, text, subject) async {
    if (Platform.isWindows) {
      ClipboardData data = ClipboardData(text: text);
      await Clipboard.setData(data);

      SnackBar snackBar = SnackBar(
          backgroundColor: Colors.black.withOpacity(0.8),
          content: const Text(
            "Done Copy",
            textAlign: TextAlign.center,
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      await Share.share(
        text,
        subject: subject,
      );
    }
  }
}
