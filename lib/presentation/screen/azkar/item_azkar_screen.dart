import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_prayer/data/models/azkar.dart';
import 'package:my_prayer/presentation/widgets/icon_button_responsive.dart';
import 'package:my_prayer/presentation/widgets/my_divider.dart';
import 'package:my_prayer/presentation/widgets/text_responsive.dart';

class ItemAzkarScreen extends StatelessWidget {
  final List<Azkar> azkars;
  const ItemAzkarScreen({required this.azkars, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 40,
        centerTitle: true,
        title: TextResponsive(text: azkars[0].category, maxSize: 20, size: size)
            .headline3(context),
        leading: IconButtonResponsive(
          icons: Icons.arrow_back_ios_new_outlined,
          size: size,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(

        child: SizedBox(
          width: size.width,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.separated(
                itemCount: azkars.length,
              separatorBuilder: (_,__)=>const SizedBox(height: 10),
                itemBuilder: (context, index) =>Card(
                  color: Theme.of(context).primaryColorDark.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(azkars[index].description,style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                          maxLines: 10,
                        ),
                        if(azkars[index].description.isNotEmpty)

                        SizedBox(
                          height: 40,
                          child: buildDivider1(),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).primaryColorDark.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: Text(azkars[index].count,
                              style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 20),
                              maxLines: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(azkars[index].zekr,style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontSize: 20,
                        ),
                        maxLines: 10,
                        ),
                        if(azkars[index].reference.isNotEmpty)
                        SizedBox(
                          height: 30,
                          child: buildDivider1(),
                        ),

                        Text(azkars[index].reference,style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                          maxLines: 10,
                        ),

                      ],
                    ),),
                ),
    ),
          ),
        ),
      ));
  }
}
