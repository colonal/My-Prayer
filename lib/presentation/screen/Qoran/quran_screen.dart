import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/qoran_cubit.dart';

import '../../../constnats/quran.dart';
import '../../widgets/my_divider.dart';
import 'contents_screen.dart';
import 'pages_screen.dart';
import 'prayer_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late PageController pageController;
  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    QoranCubit cubit = QoranCubit.get(context);

    return BlocConsumer<QoranCubit, QoranState>(
      listener: (context, state) {},
      builder: (context, state) {
        print("${cubit.page} == ${cubit.indexFavorite}");
        return Scaffold(
          body: SafeArea(
              child: Container(
            color: Colors.white,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: 603,
                  onPageChanged: (index) {
                    cubit.changePage(index);
                  },
                  itemBuilder: (context, index) => Image.asset(
                    "assets/quran/quran-images/${index + 1}.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                    top: 0,
                    left: size.width * 0.15,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: cubit.page - 1 == cubit.indexFavorite ? 1 : 0,
                      child: Image.asset(
                        "assets/images/saveMark.png",
                        width: 75,
                        height: 150,
                      ),
                    )),
                Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedOpacity(
                    opacity: cubit.opacity,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: size.width,
                      height: size.height * 0.05,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      color: Colors.black.withOpacity(0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  color: Colors.white)),
                          Text(
                            cubit.isEn
                                ? quranInfo[cubit.indexQuranInfo]
                                    ["English_Name"]
                                : quranInfo[cubit.indexQuranInfo]["Name"],
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            cubit.page.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    bottom: 0,
                    left: cubit.opacity == 0 ? (size.width * 0.5) - 25 : 0,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: InkWell(
                        onTap: (cubit.opacity == 1
                            ? null
                            : () {
                                cubit.openMenu();
                              }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: cubit.opacity == 0 ? 50 : 100,
                          width: cubit.opacity == 0 ? 50 : size.width,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: cubit.opacity == 0
                                ? BoxShape.circle
                                : BoxShape.rectangle,
                          ),
                          child: !cubit.showMenu
                              ? const Icon(Icons.blur_on_outlined,
                                  color: Colors.white)
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: newMethod(
                                              text: cubit.getText("saveMark") ??
                                                  "Save Mark",
                                              icon: Icons.bookmark_border_sharp,
                                              onTap: () {
                                                cubit.saveFavorite();
                                              }),
                                        ),
                                        buildDivider1(isVertical: true),
                                        Expanded(
                                          child: newMethod(
                                              text: cubit.getText("GoToTag") ??
                                                  "Go To Tag",
                                              icon: Icons.bookmark,
                                              onTap: () {
                                                if (cubit.indexFavorite !=
                                                    null) {
                                                  pageController.jumpToPage(
                                                      cubit.indexFavorite!);
                                                }
                                              }),
                                        ),
                                        buildDivider1(isVertical: true),
                                        IconButton(
                                            onPressed: (() =>
                                                cubit.closeMenu()),
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                    buildDivider1(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: newMethod(
                                              text: cubit.getText("Contents") ??
                                                  "Contents",
                                              icon: Icons.menu_rounded,
                                              onTap: () async {
                                                final index = await Navigator
                                                        .of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (_) =>
                                                            const ContentsScreen()));
                                                if (index != null) {
                                                  pageController
                                                      .jumpToPage(index - 1);
                                                }
                                              }),
                                        ),
                                        buildDivider1(isVertical: true),
                                        Expanded(
                                          child: newMethod(
                                              text: cubit.getText("Pages") ??
                                                  "Pages",
                                              icon: Icons.menu_book_sharp,
                                              onTap: () async {
                                                final index = await Navigator
                                                        .of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (_) =>
                                                            const PagesScreen()));
                                                if (index != null) {
                                                  pageController
                                                      .jumpToPage(index - 1);
                                                }
                                              }),
                                        ),
                                        buildDivider1(isVertical: true),
                                        Expanded(
                                          child: newMethod(
                                            text: cubit.getText("SealPrayer") ??
                                                "SealPrayer",
                                            image:
                                                "assets/images/dua-hands.png",
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (_) =>
                                                        const PrayerScreen())),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                        ),
                      ),
                    ))
              ],
            ),
          )),
        );
      },
    );
  }

  InkWell newMethod({required String text, icon, onTap, image}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          image != null
              ? Image.asset(image)
              : Icon(
                  icon,
                  color: Colors.white,
                ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
