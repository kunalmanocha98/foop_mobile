import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class HorizontalScrollCard extends StatelessWidget {
  CommonCardData data;
  TextStyleElements styleElements;

  HorizontalScrollCard({Key key, @required this.data, this.styleElements})
      : super(key: key);


  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    final List<Widget> imageSliders = data.data.map((item) =>  Container(
        decoration: BoxDecoration(
            color: HexColor(AppColors.appColorWhite65),
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            fit: BoxFit.fill,
            image:item.bannerImageUrl!=null?CachedNetworkImageProvider(item.bannerImageUrl):AssetImage('assets/appimages/image_place.png'),
          )
        ),
        height: 200,
        margin: EdgeInsets.only(right: 8.h),
        width: MediaQuery.of(context).size.width - 90,)).toList();
    return
      Container(
        margin: EdgeInsets.only(top:4,bottom: 4),
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 2.5,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              initialPage: 2,
              autoPlay: true,
            ),
            items: imageSliders,
          )
      );
    /* Container(
        height: 200,
        padding: EdgeInsets.all(0.0),
        margin: EdgeInsets.only(bottom: 4.h, top: 8.h, left: 8.h),
        child: Container(
            margin: const EdgeInsets.only(),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Flexible(
                    child: Container(
                        height: 200.0,
                        child: new ListView.builder(
                            padding: EdgeInsets.all(0.0),
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: data.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                color: HexColor(AppColors.appColorWhite65),
                                  margin: EdgeInsets.only(right: 8.h),
                                  width: MediaQuery.of(context).size.width - 90,
                                  child:  CachedNetworkImage(
                                    imageUrl: data.data[index].bannerImageUrl?? "",
                                    placeholder: (context, url) => Center(
                                        child:  FittedBox(
                                          child: Image.asset(
                                            'assets/appimages/image_place.png',

                                          ),
                                          fit: BoxFit.fill,
                                        )),
                                    fit: BoxFit.fill,
                                  ));
                            }))))));*/
  }
}
