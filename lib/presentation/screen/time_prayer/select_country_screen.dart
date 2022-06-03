import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';

import '../../../business_logic/cubit/time_prayer/time_prayer_cubit.dart';
import '../../widgets/text_responsive.dart';

class SelectCountryScreen extends StatelessWidget {
  final Size size;
  final BuildContext context;
  final TimePrayerCubit cubit;
  final void Function()? onSubmit;
  final void Function(String) onCountryChanged;
  final void Function(String) onStateChanged;
  const SelectCountryScreen(
      {required this.context,
      required this.cubit,
      required this.size,
      this.onSubmit,
      required this.onCountryChanged,
      required this.onStateChanged,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: cubit.isEn ? TextDirection.ltr : TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                TextResponsive(
                        text: cubit.getText("Select") ??
                            "Select Country and City",
                        maxSize: 20,
                        size: size)
                    .headline2(context, color: themeData.primaryColorDark),
                const SizedBox(height: 10),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Card(
                    color: themeData.primaryColorDark.withOpacity(0.8),
                    margin: const EdgeInsets.all(50),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SelectState(
                            onCountryChanged: onCountryChanged,
                            onStateChanged: onStateChanged,
                            onCityChanged: (city) {},
                            style: themeData.textTheme.bodyText2!
                                .copyWith(color: themeData.backgroundColor),
                            dropdownColor: Colors.grey,
                          ),
                          const SizedBox(height: 20),
                          MaterialButton(
                            onPressed: onSubmit,
                            color: themeData.backgroundColor,
                            child: TextResponsive(
                                    text: cubit.getText("Submit") ?? "Submit",
                                    maxSize: 15,
                                    size: size)
                                .headline2(context,
                                    color: themeData.primaryColorDark),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
