import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/data/models/recitations.dart';

import '../../../business_logic/cubit/listen/listen_cubit.dart';
import '../../../business_logic/cubit/listen/listen_state.dart';
import '../../widgets/icon_button_responsive.dart';
import '../../widgets/text_responsive.dart';
import '../loading_screen.dart';

class RecitationsScreen extends StatelessWidget {
  final ListenCubit listenCubit;
  const RecitationsScreen({required this.listenCubit, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListenCubit>.value(
      value: listenCubit,
      child: BlocBuilder<ListenCubit, ListenState>(
        builder: (context, state) {
          Size size = MediaQuery.of(context).size;
          ListenCubit cubit = ListenCubit.get(context);
          List<Recitations> recitations = ListenCubit.recitations;
          if (state is LoadingRecitationsState) {
            return const LoadingScreen(text: "Loding ...");
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              toolbarHeight: 50,
              centerTitle: true,
              title: TextResponsive(
                      text: cubit.getText("recitations") ?? "Recitations",
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
            body: SizedBox(
              width: size.width,
              child: ListView.separated(
                itemCount: recitations.length,
                separatorBuilder: (_, __) => Container(
                  color: Colors.black,
                  height: 1,
                  width: double.infinity,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      cubit.changeRecitations(recitations[index]);

                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                cubit.isEn
                                    ? recitations[index].reciterName
                                    : recitations[index].nameAr,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
