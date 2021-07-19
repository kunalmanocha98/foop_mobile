import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverlappedImagesLarger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      child: Stack(
        //alignment:new Alignment(x, y)
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      'https://homepages.cae.wisc.edu/~ece533/images/boy.bmp'),
                  fit: BoxFit.fill),
            ),
          ),
          Positioned(
            left: 8,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        'https://homepages.cae.wisc.edu/~ece533/images/fruits.png'),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Positioned(
            left: 20,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        'https://homepages.cae.wisc.edu/~ece533/images/boy.bmp'),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Positioned(
            left: 25,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        'https://tineye.com/images/widgets/mona.jpg'),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Positioned(
            left: 25,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        'https://homepages.cae.wisc.edu/~ece533/images/boy.bmp'),
                    fit: BoxFit.fill),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
