import 'dart:math';

import 'package:oho_works_app/regisration_module/years_entity.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable

class DatePickerFromTo extends StatefulWidget {
  final Null Function(String?)? selectDateCallBack;
  final List<YearsData>? startYears;

  final List<YearsData>? passOutYear;
  final BuildContext? ctx;

  _DatePickerFromTo createState() => _DatePickerFromTo(selectDateCallBack);

  DatePickerFromTo(
      {this.selectDateCallBack, this.startYears, this.passOutYear, this.ctx});
}

class _DatePickerFromTo extends State<DatePickerFromTo>
    with SingleTickerProviderStateMixin {
  String? startDate;

  String? passOutDate;

  int selectedEpoch = 0;
  Widget? datePicker;
  late TextStyleElements styleElements;
  late Animation _animation;
  late AnimationController _controller;
  int? currentYear;
  bool isStartYearSelected = false;

  Null Function(String?)? selectDateCallBack;

  _DatePickerFromTo(this.selectDateCallBack);

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> markSelected(int index) async {
    for (int i = 0; i < 150; i++) {
      if (i == index) {
        isStartYearSelected
            ? widget.passOutYear![i].isSelected = true
            : widget.startYears![i].isSelected = true;
        isStartYearSelected
            ? passOutDate = widget.passOutYear![i].yearName
            : startDate = widget.startYears![i].yearName;
      } else {
        isStartYearSelected
            ? widget.passOutYear![i].isSelected = false
            : widget.startYears![i].isSelected = false;
      }
    }
    setState(() {});
  }

  get_chip(YearsData yearsData, int index, bool isStartYearSelected) {
    print(isStartYearSelected.toString());
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        markSelected(index);
      },
      child: Chip(
          elevation: 2.0,
          backgroundColor: yearsData.isSelected!
              ? HexColor(AppColors.appMainColor)
              : HexColor(AppColors.appColorWhite),
          label: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(yearsData.yearName ?? "",
                style: styleElements.subtitle2ThemeScalable(context).copyWith(
                    color: yearsData.isSelected!
                        ? HexColor(AppColors.appColorWhite)
                        : HexColor(AppColors.appColorBlack65))),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Dialog(
      backgroundColor: isStartYearSelected
          ? HexColor(AppColors.failure)
          : HexColor(AppColors.information),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          bool isFront = _controller.value < .5;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: 16, bottom: 16, left: 20, right: 20),
                        child: Text(
                          isStartYearSelected
                              ? AppLocalizations.of(context)!
                                  .translate('pass_out')
                              : AppLocalizations.of(context)!
                                  .translate('start_year'),
                          style: styleElements
                              .headline6ThemeScalable(context)
                              .copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                    IconButton(
                        icon: Icon(
                          isStartYearSelected
                              ? Icons.arrow_back_ios
                              : Icons.arrow_forward_ios,
                          color: HexColor(AppColors.appColorBlack),
                          size: 20,
                        ),
                        onPressed: () {
                          if (!isStartYearSelected) {
                            if (_animation.isDismissed) {
                              _controller.forward();
                            } else if (_animation.isCompleted) {
                              _controller.reverse();
                            }
                          }
                          setState(() {
                            if (isStartYearSelected)
                              isStartYearSelected = false;
                            else
                              isStartYearSelected = true;
                          });
                        })
                  ],
                ),
              ),
              !isStartYearSelected ? Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Visibility(
                      visible: !isStartYearSelected,
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: 16, bottom: 16, left: 20, right: 2),
                          child: Text(
                            AppLocalizations.of(context)!.translate('start_year_'),
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(),
                          )),
                    ),
                    Visibility(
                      visible: !isStartYearSelected,
                      child: Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 2,left: 20),
                          child: Text(
                            startDate ?? "--",
                            style: styleElements
                                .subtitle2ThemeScalable(context)
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          )),
                    ),

                  ],
                ),
              ):Opacity(opacity: 0.0),

              isStartYearSelected?  Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Visibility(
                      visible: isStartYearSelected,
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: 16, bottom: 16, left: 20, right: 2),
                          child: Text(
                            AppLocalizations.of(context)!.translate('pass_out_'),
                            style: styleElements
                                .captionThemeScalable(context)
                                .copyWith(),
                          )),
                    ),
                    Visibility(
                      visible: isStartYearSelected,
                      child: Padding(
                          padding:
                          EdgeInsets.only(top: 16, bottom: 16, right: 20,left: 20),
                          child: Text(
                            passOutDate ?? "--",
                            style: styleElements
                                .subtitle2ThemeScalable(context)
                                .copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ],
                ),
              ):Opacity(opacity: 0.0),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
                child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateX(pi * _animation.value + (isFront ? 0 : pi)),
                    alignment: FractionalOffset.center,
                    child: SizedBox(
                      height: 400,
                      child: Container(
                        height: 400,
                        child: GridView.count(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            crossAxisCount: 3,
                            childAspectRatio: 4 / 2,
                            children: List.generate(
                                isStartYearSelected
                                    ? widget.passOutYear!.length
                                    : widget.startYears!.length, (index) {
                              return Center(
                                  child: get_chip(
                                      isStartYearSelected
                                          ? widget.passOutYear![index]
                                          : widget.startYears![index],
                                      index,
                                      isStartYearSelected));
                            })),
                      ),
                    )),
              )),
              InkWell(
                  onTap: () {
                    if (startDate != null && startDate!.isNotEmpty) {
                      if (passOutDate != null && passOutDate!.isNotEmpty) {
                        Navigator.pop(context, null);
                        selectDateCallBack!(getAcademicYears());
                      } else {
                        ToastBuilder().showToast(
                            AppLocalizations.of(widget.ctx!)!
                                .translate("pass_out"),
                            context,
                            HexColor(AppColors.information));
                      }
                    } else {
                      ToastBuilder().showToast(
                          AppLocalizations.of(widget.ctx!)!
                              .translate("start_year"),
                          context,
                          HexColor(AppColors.information));
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Text(
                      AppLocalizations.of(context)!.translate('submit'),
                      style: styleElements.subtitle1ThemeScalable(context),
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }

  String? getAcademicYears() {
    if (startDate!.isNotEmpty && passOutDate!.isNotEmpty)
      return startDate.toString() + "-" + passOutDate.toString();
    else
      return null;
  }
}
