import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:my_prayer/business_logic/cubit/home/home_cubit.dart';
import '../../../business_logic/cubit/qoran/qoran_cubit.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    QoranCubit cubit = QoranCubit.get(context);

    return BlocConsumer<QoranCubit, QoranState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Directionality(
          textDirection: cubit.isEn ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            body: SafeArea(
                child: Container(
              color: HomeCubit.get(context).isDark ?? false
                  ? Theme.of(context).backgroundColor
                  : Colors.white,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  HomeCubit.get(context).isDark ?? false
                      ? InvertColors(
                          child: _buildImageQoran(cubit),
                        )
                      : _buildImageQoran(cubit),
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
                    child: HomeCubit.get(context).isDark ?? false
                        ? InvertColors(
                            child: _buildTopBar(cubit, size, context),
                          )
                        : _buildTopBar(cubit, size, context),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    bottom: 0,
                    left: cubit.opacity == 0 ? (size.width * 0.5) - 25 : 0,
                    child: HomeCubit.get(context).isDark ?? false
                        ? InvertColors(
                            child: _buildBottonBar(cubit, size, context),
                          )
                        : _buildBottonBar(cubit, size, context),
                  ),
                ],
              ),
            )),
          ),
        );
      },
    );
  }

  Widget _buildBottonBar(QoranCubit cubit, Size size, BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: (cubit.opacity == 1
            ? null
            : () {
                cubit.openMenu();
              }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: cubit.opacity == 0 ? 0 : 100,
          width: cubit.opacity == 0 ? 0 : size.width,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            shape: cubit.opacity == 0 ? BoxShape.circle : BoxShape.rectangle,
          ),
          child: !cubit.showMenu
              ? null
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: newMethod(
                              text: cubit.getText("saveMark") ?? "Save Mark",
                              icon: Icons.bookmark_border_sharp,
                              onTap: () {
                                cubit.saveFavorite();
                              }),
                        ),
                        buildDivider1(isVertical: true),
                        Expanded(
                          child: newMethod(
                              text: cubit.getText("GoToTag") ?? "Go To Tag",
                              icon: Icons.bookmark,
                              onTap: () {
                                if (cubit.indexFavorite != null) {
                                  pageController
                                      .jumpToPage(cubit.indexFavorite!);
                                }
                              }),
                        ),
                        buildDivider1(isVertical: true),
                        IconButton(
                            onPressed: (() => cubit.closeMenu()),
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
                              text: cubit.getText("Contents") ?? "Contents",
                              icon: Icons.menu_rounded,
                              onTap: () async {
                                final index = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ContentsScreen(isEn: cubit.isEn)));
                                if (index != null) {
                                  pageController.jumpToPage(index - 1);
                                }
                              }),
                        ),
                        buildDivider1(isVertical: true),
                        Expanded(
                          child: newMethod(
                              text: cubit.getText("Pages") ?? "Pages",
                              icon: Icons.menu_book_sharp,
                              onTap: () async {
                                final index = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            PagesScreen(isEn: cubit.isEn)));
                                if (index != null) {
                                  pageController.jumpToPage(index - 1);
                                }
                              }),
                        ),
                        buildDivider1(isVertical: true),
                        Expanded(
                          child: newMethod(
                            text: cubit.getText("SealPrayer") ?? "SealPrayer",
                            image: "assets/images/dua-hands.png",
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const PrayerScreen())),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
        ),
      ),
    );
  }

  AnimatedOpacity _buildTopBar(
      QoranCubit cubit, Size size, BuildContext context) {
    return AnimatedOpacity(
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
              icon: cubit.isEn
                  ? const Icon(Icons.arrow_back_ios_rounded,
                      color: Colors.white)
                  : const Icon(Icons.arrow_back_ios_rounded,
                      color: Colors.white),
            ),
            Text(
              cubit.isEn
                  ? quranInfo[cubit.indexQuranInfo]["English_Name"]
                  : quranInfo[cubit.indexQuranInfo]["Name"],
              style: const TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                cubit.page.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildImageQoran(QoranCubit cubit) {
    return InkWell(
      onTap: (cubit.opacity == 1
          ? () => cubit.closeMenu()
          : () {
              cubit.openMenu();
            }),
      child: PageView.builder(
        controller: pageController,
        itemCount: 604,
        onPageChanged: (index) {
          cubit.changePage(index);
        },
        itemBuilder: (context, index) => Image.asset(
          "assets/quran/quran-images/${index + 1}.png",
          fit: BoxFit.fill,
        ),
      ),
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
