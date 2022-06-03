import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/cubit/azkar/azkar_cubit.dart';
import 'item_azkar_screen.dart';
import '../../widgets/my_divider.dart';

import '../../widgets/icon_button_responsive.dart';
import '../../widgets/text_responsive.dart';
import '../loading_screen.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({Key? key}) : super(key: key);

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  late AzkarCubit cubit;
  @override
  void initState() {
    cubit = AzkarCubit.get(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AzkarCubit, AzkarState>(
      listener: (_, __) {},
      builder: (context, state) {
        List v = cubit.azkars.keys.toList();
        if (state is AzkarLodingState) {
          return LoadingScreen(text: cubit.getText("Loading") ?? "Loading");
        }
        return Directionality(
          textDirection: cubit.isEn ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              toolbarHeight: 40,
              centerTitle: true,
              title: TextResponsive(
                      text: cubit.getText("Azkar") ?? "Azkar",
                      maxSize: 20,
                      size: size)
                  .headline3(context),
              leading: IconButtonResponsive(
                icons: cubit.isEn
                    ? Icons.arrow_back_ios_rounded
                    : Icons.arrow_back_ios_rounded,
                size: size,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ItemAzkarScreen(
                                      cubit: cubit,
                                      azkars: cubit.favorite,
                                      isFavorite: true,
                                    ))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextResponsive(
                                text: cubit.getText("Favorite") ?? "Favorite",
                                size: size,
                                maxSize: 20,
                              ).headline3(context, bold: true),
                            ],
                          ),
                        ),
                      ),
                      buildDivider1(color: Theme.of(context).primaryColorDark),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: v.length,
                        separatorBuilder: (_, __) => buildDivider1(
                            color: Theme.of(context).primaryColorDark),
                        itemBuilder: (_, index) => InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ItemAzkarScreen(
                                      cubit: cubit,
                                      azkars: cubit.azkars[v[index]]))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: SizedBox(
                              width: size.width,
                              child: Center(
                                child: TextResponsive(
                                  text: v[index].toString(),
                                  size: size,
                                  maxSize: 20,
                                ).headline3(context, bold: true),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
