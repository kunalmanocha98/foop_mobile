import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OverlappedImages extends StatelessWidget {

  List<String> images;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      child: Stack(
        //alignment:new Alignment(x, y)
        children: <Widget>[
          images.length>0?  TricycleAvatar(
            size: 25,
            isFullUrl: true,
            imageUrl:  images.length>0?Config.BASE_URL+images[0]??"":"",
          ):Container(),
          images.length>1? Positioned(
            left: 8,
            child: TricycleAvatar(
              size: 25,
              isFullUrl: true,
              imageUrl:  images.length>1?Config.BASE_URL+images[1]??"":"",
            ),
          ):Container(),
          images.length>2?   Positioned(
            left: 20,
            child: TricycleAvatar(
              size: 25,
              isFullUrl: true,
              imageUrl: images.length>2?Config.BASE_URL+images[2]??"":"",
            )
          ):Container(),
          images.length>3?   Positioned(
            left: 25,
            child: TricycleAvatar(
              size: 25,
              isFullUrl: true,
              imageUrl: images.length>3?Config.BASE_URL+images[3]??"":"",
            )
          ):Container(),
          // Positioned(
          //   left: 25,
          //   child:TricycleAvatar(
          //     size: 25,
          //     imageUrl: images[4],
          //   )
          // ),
        ],
      ),
    );
  }

  OverlappedImages(this.images);
}
