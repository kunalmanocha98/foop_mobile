import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
class EmptyWidget extends StatelessWidget {
  const EmptyWidget( this.desc);

  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 60,top: 20),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(color: HexColor(AppColors.appColorBackground),),
        child: CustomPaginator(context).emptyListWidgetMaker(null));
  }

}
