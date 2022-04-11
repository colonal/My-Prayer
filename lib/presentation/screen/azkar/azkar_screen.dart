import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/azkar_cubit.dart';
import 'package:my_prayer/presentation/screen/azkar/item_azkar_screen.dart';
import 'package:my_prayer/presentation/widgets/my_divider.dart';

import '../../widgets/icon_button_responsive.dart';
import '../../widgets/text_responsive.dart';

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

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            toolbarHeight: 40,
            centerTitle: true,
            title: TextResponsive(text: "Azkar", maxSize: 20, size: size)
                .headline3(context),
            leading: IconButtonResponsive(
              icons: Icons.arrow_back_ios_new_outlined,
              size: size,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
              child: SizedBox(
            width: double.infinity,
            child: ListView.separated(
                itemCount: v.length,
                separatorBuilder: (_,__)=>buildDivider1(color: Theme.of(context).primaryColorDark),
                itemBuilder: (_, index) =>
                    GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ItemAzkarScreen(azkars:cubit.azkars[v[index]]))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextResponsive(
                            text: v[index].toString(),
                            size: size,
                            maxSize: 20,
                      ).headline3(context,bold: true),
                          ],
                  ),),
                    ),),
          )),
        );
      },
    );
  }
}
