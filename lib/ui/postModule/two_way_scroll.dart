import 'dart:async';
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/postcardheader.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/models/post/post_sub_type_list.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/ui/postcardDetail.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/preloadingview.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

// ignore: must_be_immutable
class TwoWayStrollPage extends StatefulWidget {
  Null Function()? callBack;
  PostListItem? postData;
  int? postId;

  TwoWayStrollPage({this.postData, this.postId});

  @override
  TwoWayStrollPageState createState() => TwoWayStrollPageState();
}

class TwoWayStrollPageState extends State<TwoWayStrollPage>
    with SingleTickerProviderStateMixin {
  Null Function()? callBack;
  PAGINATOR_ENUMS? pageEnum;
  List<PostCardDetailPage> detailPagesList = [];
  List<PostListItem?> postList = [];
  int totalItems = 0;
  SharedPreferences? prefs;
  int page = 1;
  String postType = 'news';
  TextStyleElements? styleElements;
  List<PostSubTypeListItem> selectedList = [];
  List<String> listOfSelections = [];
  String topic = "Choose topic";
  GlobalKey<PostCardHeaderState> headerKey = GlobalKey();
  int _currentPage = 0;
  int mSelectedPosition = 0;
  bool isFirstCall = true;
  int? postId;

  @override
  void initState() {
    pageEnum = PAGINATOR_ENUMS.SUCCESS;

    postId = widget.postData!.postId;
    detailPagesList.add(PostCardDetailPage(
      postData: widget.postData,
    ));
    postList.add(widget.postData);
    firstCall();
    super.initState();
  }

  Future<void> firstCall() async {
    await fetchList("next", widget.postData!.postId);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
            child: Scaffold(
          body: _buildPage(),
        )));
  }

  void _onPageChange(int index) {
    setState(() {
      _currentPage = index;
    });
    if (_currentPage == 0) {
      fetchList("previous", postList[0]!.postId);
    }

    if (_currentPage == detailPagesList.length - 1) {
      fetchList("next", postList[postList.length - 1]!.postId);
    }
  }

  void _onHorizontalSwipe(SwipeDirection direction) {
    setState(() {
      if (direction == SwipeDirection.left) {
        setState(() {
          mSelectedPosition = mSelectedPosition + 1;
        });
        print('Swiped left!');
      } else {
        setState(() {
          mSelectedPosition = mSelectedPosition - 1;
        });
        print('Swiped right!');
      }
    });
  }

  _buildPage() {
    // ignore: missing_enum_constant_in_switch
    switch (pageEnum) {
      case PAGINATOR_ENUMS.SUCCESS:
        return Container(
          child: SimpleGestureDetector(
            onHorizontalSwipe: _onHorizontalSwipe,
            swipeConfig: SimpleSwipeConfig(
              verticalThreshold: 40.0,
              horizontalThreshold: 40.0,
              swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
            ),
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: PageController(
                  initialPage: mSelectedPosition,
                  keepPage: true,
                  viewportFraction: 1),
              scrollDirection: Axis.horizontal,
              itemCount: _getItemCount(),
              itemBuilder: (BuildContext context, int index) {
                return detailPagesList[index];
              },
              onPageChanged: _onPageChange,
            ),
          ),
        );
      case PAGINATOR_ENUMS.LOADING:
        return Container(
            margin: const EdgeInsets.only(top: 62, bottom: 60),
            child: PreloadingView(url: "assets/appimages/dice.png"));
      case PAGINATOR_ENUMS.ERROR:
        // TODO: Handle this case.
        break;
      case PAGINATOR_ENUMS.EMPTY:
        // TODO: Handle this case.
        break;
    }
  }

  int _getItemCount() {
    return detailPagesList.length;
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    setState(() async {
      Navigator.of(context).pop(true);
    });
    return new Future(() => false);
  }

  Future<void> fetchList(String listType, int? id) async {
    final body = jsonEncode({
      "post_id": id,
      "page_size": 10,
      "page_number": 1,
      "post_type": widget.postData!.postType,
      "list_type": listType
    });
    var res = await Calls().call(body, context, Config.DETAIL_PAGE_PAGINATION);
    PostListResponse.fromJson(res);
    if (PostListResponse.fromJson(res).statusCode == Strings.success_code &&
        PostListResponse.fromJson(res).rows != null &&
        PostListResponse.fromJson(res).rows!.isNotEmpty) {
      List<PostCardDetailPage> newList = [];
      for (var item in PostListResponse.fromJson(res).rows!) {
        newList.add(PostCardDetailPage(
          postData: item,
        ));
      }
      setState(() {
        pageEnum = PAGINATOR_ENUMS.SUCCESS;
      });

      listType == "previous"
          ? detailPagesList = (new List.from(newList)..addAll(detailPagesList))
          : detailPagesList.addAll(newList);

      listType == "previous"
          ? postList = (new List.from(PostListResponse.fromJson(res).rows!)
            ..addAll(postList))
          : postList.addAll(PostListResponse.fromJson(res).rows!);

      listType == "previous"
          ? mSelectedPosition = newList.length - 1
          : mSelectedPosition = _currentPage + 1;
      page++;
      setState(() {
        print(detailPagesList.length.toString() +
            "-----------------------------------------------length");
      });
    }
    return null;
  }
}
