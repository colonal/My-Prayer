import 'package:flutter/material.dart';

import '../../widgets/text_responsive.dart';
import '../../widgets/icon_button_responsive.dart';

class SurahScreen extends StatefulWidget {
  final List qoran;
  final int index;
  const SurahScreen(this.qoran, this.index, {Key? key}) : super(key: key);

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  late PageController _pageController;
  int selectPage = 0;
  @override
  void initState() {
    selectPage = widget.index;
    _pageController = PageController(
      initialPage: widget.index,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 228, 145),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 50,
        centerTitle: true,
        title: TextResponsive(
                text: widget.qoran[selectPage].name, maxSize: 20, size: size)
            .headline3(context, bold: true),
        leading: IconButtonResponsive(
          icons: Icons.arrow_back_ios_new_outlined,
          size: size,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView.builder(
          controller: _pageController,
          itemCount: widget.qoran.length,
          onPageChanged: (index) {
            setState(() {
              selectPage = index;
            });
          },
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  widget.qoran[index].surah,
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    height: 2,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            );
          }),
    );
  }
}
