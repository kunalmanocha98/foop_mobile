import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostCardMediaList extends StatefulWidget{
  final List<Media> mediaList;
  PostCardMediaList({this.mediaList});
  @override
  PostCardMediaListState createState() => PostCardMediaListState(mediaList: mediaList);
}
class PostCardMediaListState extends State<PostCardMediaList>{
  final List<Media> mediaList;
  PostCardMediaListState({this.mediaList});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: mediaList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(8),
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(Utility().getUrlForImage( mediaList[index].mediaUrl, RESOLUTION_TYPE.R256, SERVICE_TYPE.POST),
                maxHeight: 64,maxWidth: 64)
              )
            ),
          );
        },
      ),
    );
  }

}