import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OverlappedImages16dp extends StatelessWidget {
  List<String> images;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      child: Stack(
        //alignment:new Alignment(x, y)
        children: <Widget>[
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image:images!=null&&images.isNotEmpty?  CachedNetworkImage(
                    imageUrl: images[0],
                    placeholder: (context, url) => Center(
                        child:  Image.asset(
                          'assets/appimages/image_place.png',

                        )),
                    fit: BoxFit.fill,
                  ) as ImageProvider<Object>:AssetImage("assets/appimages/userplaceholder.jpg"),
                  fit: BoxFit.fill),
            ),
          ),
          Positioned(
            left: 6,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: images!=null && images.length>1? CachedNetworkImage(
                      imageUrl: images[1],
                      placeholder: (context, url) => Center(
                          child:  Image.asset(
                            'assets/appimages/image_place.png',

                          )),
                      fit: BoxFit.fill,
                    ) as ImageProvider<Object>:AssetImage("assets/appimages/userplaceholder.jpg"),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Positioned(
            left: 12,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: images!=null && images.length>2? CachedNetworkImage(
                      imageUrl: images[2],
                      placeholder: (context, url) => Center(
                          child:  Image.asset(
                            'assets/appimages/image_place.png',

                          )),
                      fit: BoxFit.fill,
                    ) as ImageProvider<Object>:AssetImage("assets/appimages/userplaceholder.jpg"),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Positioned(
            left: 18,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: images.length>3? CachedNetworkImage(
                      imageUrl: images[3],
                      placeholder: (context, url) => Center(
                          child:  Image.asset(
                            'assets/appimages/image_place.png',

                          )),
                      fit: BoxFit.fill,
                    ) as ImageProvider<Object>:AssetImage("assets/appimages/userplaceholder.jpg"),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Positioned(
            left: 24,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: images!=null && images.length>4? CachedNetworkImage(
                      imageUrl: images[4],
                      placeholder: (context, url) => Center(
                          child:  Image.asset(
                            'assets/appimages/image_place.png',

                          )),
                      fit: BoxFit.fill,
                    ) as ImageProvider<Object>:AssetImage("assets/appimages/userplaceholder.jpg"),
                    fit: BoxFit.fill),
              ),
            ),
          ),
        ],
      ),
    );
  }

  OverlappedImages16dp(this.images);
}
