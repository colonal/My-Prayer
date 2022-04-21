import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/qoran_cubit.dart';
import 'package:my_prayer/presentation/widgets/icon_button_responsive.dart';
import 'package:my_prayer/presentation/widgets/text_responsive.dart';

import 'surah_screen.dart';

class QoranScreen extends StatelessWidget {
  const QoranScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 40,
        centerTitle: true,
        title: TextResponsive(text: "Qoran", maxSize: 20, size: size)
            .headline3(context),
        leading: IconButtonResponsive(
          icons: Icons.arrow_back_ios_new_outlined,
          size: size,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocProvider(
        create: (_) => QoranCubit()..readJson(),
        child: BlocConsumer<QoranCubit, QoranState>(
          listener: (context, state) {},
          builder: (context, state) {
            final List qurans = BlocProvider.of<QoranCubit>(context).qurans;
            if (state is QoranLodingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: qurans.length,
                  itemBuilder: ((context, index) => newMethod(
                        qurans,
                        context,
                        size,
                        index,
                        color: index % 2 == 0
                            ? themeData.primaryColor.withOpacity(0.3)
                            : themeData.backgroundColor,
                      ))),
            );
          },
        ),
      ),
    );
  }

  Widget newMethod(List qurans, BuildContext context, Size size, int index,
          {color}) =>
      GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => SurahScreen(qurans, index))),
        child: Container(
          height: 50,
          color: color,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextResponsive(
                      text: qurans[index].number.toString(),
                      maxSize: 20,
                      size: size)
                  .headline3(context),
              TextResponsive(text: qurans[index].name, maxSize: 30, size: size)
                  .headline3(context, bold: true),
              TextResponsive(
                      text: qurans[index].descent, maxSize: 20, size: size)
                  .headline3(context),
            ],
          ),
        ),
      );
}
