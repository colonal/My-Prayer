import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_prayer/presentation/screen/Qoran/contents_screen.dart';
import 'package:my_prayer/presentation/screen/Qoran/prayer_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../constnats/quran.dart';
import '../../widgets/my_divider.dart';
import 'pages_screen.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({Key? key}) : super(key: key);

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int page = 1;
  double opacity = 1;
  bool showMenu = true;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  int indexQuranInfo = 0;

  @override
  void initState() {
    _pdfViewerController.addListener(({property}) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: SfPdfViewer.asset(
                'assets/quran/holy_quran_full.pdf',
                key: _pdfViewerKey,
                controller: _pdfViewerController,
                pageLayoutMode: PdfPageLayoutMode.single,
                // scrollDirection: PdfScrollDirection.horizontal,

                canShowScrollHead: false,
                enableTextSelection: true,
                onPageChanged: (PdfPageChangedDetails pageChangedDetails) {
                  setState(() {
                    page = pageChangedDetails.newPageNumber;
                    for (int index = 0; index < quranInfo.length; ++index) {
                      debugPrint("index: $index");
                      if (quranInfo[index]["Number_Page"] <= page &&
                          page < quranInfo[index + 1]["Number_Page"]) {
                        indexQuranInfo = index;
                        debugPrint("indexQuranInfo 0: $indexQuranInfo");
                        break;
                      }
                    }
                    debugPrint("indexQuranInfo: $indexQuranInfo");
                  });
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: AnimatedOpacity(
                opacity: opacity,
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
                        quranInfo[indexQuranInfo]["Name"],
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        page.toString(),
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
                left: opacity == 0 ? (size.width * 0.5) - 25 : 0,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: InkWell(
                    onTap: (opacity == 1
                        ? null
                        : () {
                            setState(() {
                              opacity = opacity == 1 ? 0 : 1;
                            });

                            Future.delayed(
                              const Duration(milliseconds: 400),
                              () {
                                setState(() {
                                  showMenu = !showMenu;
                                  debugPrint("showMenu: $showMenu");
                                });
                              },
                            );
                          }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: opacity == 0 ? 50 : 100,
                      width: opacity == 0 ? 50 : size.width,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape:
                            opacity == 0 ? BoxShape.circle : BoxShape.rectangle,
                      ),
                      child: !showMenu
                          ? const Icon(Icons.blur_on_outlined,
                              color: Colors.white)
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: newMethod(
                                        text: "حفظ علامة",
                                        icon: Icons.bookmark_border_sharp,
                                      ),
                                    ),
                                    buildDivider1(isVertical: true),
                                    Expanded(
                                      child: newMethod(
                                        text: "انتقال الى العلامة",
                                        icon: Icons.bookmark,
                                      ),
                                    ),
                                    buildDivider1(isVertical: true),
                                    IconButton(
                                        onPressed: (() => setState(() {
                                              opacity = opacity == 1 ? 0 : 1;
                                              showMenu = !showMenu;
                                            })),
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
                                          text: "الفهرس",
                                          icon: Icons.menu_rounded,
                                          onTap: () async {
                                            final contact = await Navigator.of(
                                                    context)
                                                .push(MaterialPageRoute(
                                                    builder: (_) =>
                                                        const ContentsScreen()));
                                            if (contact != null) {
                                              _pdfViewerController
                                                  .jumpToPage(contact);
                                            }
                                          }),
                                    ),
                                    buildDivider1(isVertical: true),
                                    Expanded(
                                      child: newMethod(
                                          text: "الصفحات",
                                          icon: Icons.menu_book_sharp,
                                          onTap: () async {
                                            final contact = await Navigator.of(
                                                    context)
                                                .push(MaterialPageRoute(
                                                    builder: (_) =>
                                                        const PagesScreen()));
                                            if (contact != null) {
                                              _pdfViewerController
                                                  .jumpToPage(contact);
                                            }
                                          }),
                                    ),
                                    buildDivider1(isVertical: true),
                                    Expanded(
                                      child: newMethod(
                                        text: "دعاء الختم",
                                        image: "assets/images/dua-hands.png",
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
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
      ),
    ));
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
