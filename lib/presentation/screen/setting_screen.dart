import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/home_cubit.dart';
import 'package:my_prayer/presentation/widgets/my_divider.dart';

import '../widgets/icon_button_responsive.dart';
import '../widgets/text_responsive.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    HomeCubit cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Directionality(
          textDirection: cubit.isEn ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              toolbarHeight: 40,
              centerTitle: true,
              title: TextResponsive(text: "Setting", maxSize: 20, size: size)
                  .headline3(context),
              leading: IconButtonResponsive(
                icons: cubit.isEn
                    ? Icons.arrow_back_ios_rounded
                    : Icons.arrow_back_ios_rounded,
                size: size,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      cubit.changeMode();
                    },
                    child: Row(
                      children: [
                        TextResponsive(text: "Mode", maxSize: 30, size: size)
                            .headline3(context, bold: true),
                        const Spacer(),
                        Image.asset(
                          "assets/images/mode.gif",
                          width: 60,
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: buildDivider1(),
                  ),
                  InkWell(
                    onTap: () {
                      cubit.changeLanguage();
                    },
                    child: Row(
                      children: [
                        TextResponsive(
                                text: "Language", maxSize: 30, size: size)
                            .headline3(context, bold: true),
                        const Spacer(),
                        Image.asset(
                          "assets/images/language.png",
                          width: 40,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
