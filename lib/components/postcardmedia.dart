import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/app_link_preview.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/media_files.dart';
import 'package:oho_works_app/models/post/postTagComponent.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:video_player/video_player.dart';

import 'CustomPaginator.dart';

// ignore: must_be_immutable
bool? onFullPage;

// ignore: must_be_immutable
class  PostCardMedia extends StatefulWidget {
  List<Media>? mediaList;
  bool? isFilterPage;
  // bool onFullPage;
  Function? onItemClick;
  Null Function(int position)? onPositionChange;
  int? pagePosition;
  bool? isNewsPage;
  bool? isMediaPage;
  int? pageNumber;
  int? ownerId;
  String? ownerType;
  int? totalItems;
  String link;
  bool? isLocalFile;
  bool onlyHorizontalList;
String? postType;
bool? isLearningPage;
bool? isFullImageUrl;
  // GlobalKey<appDownloadButtonState> downloadButtonKey;
  PostCardMedia(
      {required this.mediaList,
        this.onlyHorizontalList = false,
        // this.downloadButtonKey,
        this.isMediaPage,
        this.totalItems,
        this.pageNumber,
        this.isNewsPage,
        this.isLearningPage,
        this.link = "",
        this.ownerType,
        this.ownerId,
        this.postType,
        this.isFilterPage,
        bool? fullPage,
        this.onItemClick,
        this.onPositionChange,
        this.pagePosition,
        this.isFullImageUrl,
        this.isLocalFile}) {
    onFullPage = fullPage;
  }

  @override
  _PostCardMedia createState() => _PostCardMedia(
      mediaList: mediaList,
      // downloadButtonKey: downloadButtonKey,
      onFullPage: onFullPage,
      totalItems: totalItems,
      pageNumber: pageNumber,
      onItemClick: onItemClick,
      onPositionChange: onPositionChange,
      pagePosition: pagePosition,
      isLocalFile: isLocalFile);
}

class _PostCardMedia extends State<PostCardMedia> {
  List<Media>? mediaList;
  bool? onFullPage;
  bool? isLocalFile;
  Function? onItemClick;
  int _currentIndex = 0;
  Null Function(int position)? onPositionChange;
  int? pagePosition;
  PageController? _controller;
  int? pageNumber;

  // GlobalKey<appDownloadButtonState> downloadButtonKey;
  int? totalItems;
  late TextStyleElements styleElements;

  _PostCardMedia(
      {required this.mediaList,
        // this.downloadButtonKey,
        this.onFullPage,
        this.totalItems,
        this.pageNumber,
        this.onItemClick,

        this.onPositionChange,
        this.pagePosition,
        this.isLocalFile}) {
    if (mediaList == null) {
      mediaList = [];
      mediaList!.add(Media(mediaType: 'empty', mediaUrl: 'url'));
    }
    _currentIndex = pagePosition ??= 0;
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: pagePosition ??= 0);
  }

  List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return widget.onlyHorizontalList
        ? Visibility(
      visible: widget.onlyHorizontalList &&  mediaList!.length>0,
      child: Container(
        height: 74,
        margin: EdgeInsets.only(top: 16,left: 12,right: 12),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: mediaList!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                onPositionChange!(index);
                onItemClick!();
              },
              child: Container(
                margin: EdgeInsets.only(top:8,bottom: 2,left:12,right: 12),
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            Utility().getUrlForImage(
                                mediaList![index].mediaUrl,
                                RESOLUTION_TYPE.R128,
                                SERVICE_TYPE.POST),
                            maxHeight: 64,
                            maxWidth: 64))),
              ),
            );
          },
        ),
      ),
    )
        : (mediaList != null && mediaList!.length > 0)
        ? Container(
      child: GestureDetector(
        onTap: () {
          if (onFullPage != null && onFullPage!) {
          } else {
            onItemClick!();
          }
        },
        child: AspectRatio(
          aspectRatio:
          (widget.isNewsPage != null && widget.isNewsPage! ||widget.isLearningPage != null && widget.isLearningPage! )
              ? 4 / 3
              : 1 / 1,
          child: Stack(
            children: [
              (widget.isMediaPage != null && widget.isMediaPage!)
                  ? PageView.builder(
                onPageChanged: (pageIndex) {
                  // downloadButtonKey.currentState.changeIndex(pageIndex);
                  setState(() {
                    _currentIndex = pageIndex;
                    onPositionChange!(_currentIndex);
                  });
                },
                itemCount: getItemCount(),
                controller: _controller,
                // store this controller in a State to save the carousel scroll position
                // controller: PageController(viewportFraction: 0.8),
                itemBuilder:
                    (BuildContext context, int itemIndex) {
                  return _getItemBuilder(context, itemIndex);
                },
              )
                  : PageView.builder(
                onPageChanged: (pageIndex) {
                  // downloadButtonKey.currentState.changeIndex(pageIndex);
                  setState(() {
                    _currentIndex = pageIndex;
                    onPositionChange!(_currentIndex);
                  });
                },

                itemCount: mediaList!.length,
                controller: _controller,
                // store this controller in a State to save the carousel scroll position
                // controller: PageController(viewportFraction: 0.8),
                itemBuilder:
                    (BuildContext context, int itemIndex) {
                  return _buildCarouselItem(
                      context, itemIndex, mediaList![itemIndex]);
                },
              ),
              (widget.isMediaPage != null && widget.isMediaPage!)
                  ? Container()
                  : Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: (mediaList != null &&
                      mediaList!.length > 1),
                  child: (onFullPage != null && onFullPage!)
                      ? Container(
                    height: 72,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: mediaList!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context,
                          int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                              _controller!.jumpToPage(
                                  _currentIndex);
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(8),
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                    4),
                                border: (_currentIndex == index)
                                    ? Border.all(
                                    color: HexColor(AppColors
                                        .appMainColor),
                                    width: 3)
                                    : null,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                        Utility().getUrlForImage(
                                            mediaList![index]
                                                .mediaUrl,
                                            RESOLUTION_TYPE
                                                .R128,
                                            SERVICE_TYPE
                                                .POST),
                                        maxHeight: 64,
                                        maxWidth: 64))),
                          ),
                        );
                      },
                    ),
                  )
                      : Wrap(
                    direction: Axis.horizontal,
                    children: _generateChildren()
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: getLinkPreview()),

          Align(
              alignment: Alignment.bottomRight,
            child:

              ((widget.postType!=null && widget.postType!='general' && widget.isFilterPage!=null &&   !widget.isFilterPage!)?PostTagComponent(
                type: widget.postType,
              ):Container()))
            ],
          ),
        ),
      ),
    )
        : (widget.link != null && widget.link.isNotEmpty)
        ? getLinkPreview()
        : Container();
  }



  Widget _generateItem(int index) {

    return   Container(
      width: 6.0,
      height: 6.0,
      margin: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentIndex == index
            ? HexColor(
            AppColors.appMainColor)
            : HexColor(AppColors
            .appColorGrey500),
      ),
    );

  }



  List<Widget> _generateChildren() {

    List<Widget> items = [];



    for (int i = 0; i < mediaList!.length; i++) {

      items.add(_generateItem(i));

    }



    return items;

  }



  Widget getLinkPreview() {
    if (mediaList != null && mediaList!.length > 0) {
      return Container(
        child: appLinkPreview(
          url: widget.link,
          builder: (InfoBase? info) {
            String? title = "";
            String? description = "";

            if (info is WebImageInfo) {
              return Container();
            } else if (info is WebInfo) {
              final WebInfo webInfo = info;
              title = webInfo.title;
              description = webInfo.description;
            } else if (info is WebVideoInfo) {
              return Container();
            }

            if (WebAnalyzer.isNotEmpty(title)) {
              return ListTile(
                tileColor: HexColor(AppColors.appColorBackground),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Uri.parse(widget.link).host,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleElements
                          .captionThemeScalable(context)
                          .copyWith(
                          color: HexColor(AppColors.appColorBlack65),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleElements
                          .bodyText2ThemeScalable(context)
                          .copyWith(
                          color: HexColor(AppColors.appColorBlack65),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                subtitle: description != null && description.isNotEmpty
                    ? Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styleElements
                      .bodyText2ThemeScalable(context)
                      .copyWith(
                      color: HexColor(AppColors.appColorBlack35),
                      fontWeight: FontWeight.w600),
                )
                    : null,
              );
            } else {
              return Container();
            }
          },
          titleStyle: TextStyle(
            color: HexColor(AppColors.appColorBlue),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Container(
        child: appLinkPreview(
          url: widget.link,
          showMultimedia: true,
          useMultithread: true,
          builder: (InfoBase? info) {
            if (info == null) return const SizedBox();
            if (info is WebImageInfo) {
              return CachedNetworkImage(
                imageUrl: info.image!,
                fit: BoxFit.contain,
              );
            } else if (info is WebVideoInfo) {
              var videoInfo = info;
              return CachedNetworkImage(
                imageUrl: videoInfo.image!,
                fit: BoxFit.contain,
              );
            }
            final WebInfo webInfo = info as WebInfo;
            print(webInfo.redirectUrl);
            if (!WebAnalyzer.isNotEmpty(webInfo.title)) return const SizedBox();

            return Container(
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: (webInfo.icon != null || webInfo.image != null)
                          ? CachedNetworkImage(
                        imageUrl: webInfo.image != null
                            ? webInfo.image!
                            : webInfo.icon!,
                        height: 72,
                        width: 72,
                        fit: BoxFit.cover,
                      )
                          : Container(),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ListTile(
                        tileColor: HexColor(AppColors.appColorBackground),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              Uri.parse(widget.link).host,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: styleElements
                                  .captionThemeScalable(context)
                                  .copyWith(
                                  color:
                                  HexColor(AppColors.appColorBlack65),
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              webInfo.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: styleElements
                                  .bodyText2ThemeScalable(context)
                                  .copyWith(
                                  color:
                                  HexColor(AppColors.appColorBlack65),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          webInfo.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styleElements
                              .bodyText2ThemeScalable(context)
                              .copyWith(
                              color: HexColor(AppColors.appColorBlack35),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          titleStyle: TextStyle(
            color: HexColor(AppColors.appColorBlue),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  Future<MediaFiles> fetchMedia(int page) async {
    final body = jsonEncode({
      "owner_type": widget.ownerType,
      "owner_id": widget.ownerId,
      "searchVal": null,
      "page_size": 5,
      "page_number": page
    });
    var res = await Calls().call(body, context, Config.MEDIA_FILES);
    return MediaFiles.fromJson(res);
  }

  Widget _getItemBuilder(BuildContext context, int itemIndex) {
    if (itemIndex < mediaList!.length) {
      if (itemIndex == mediaList!.length) {
        return CustomPaginator(context).loadingWidgetMaker();
      } else {
        return _buildCarouselItem(context, itemIndex, mediaList![itemIndex]);
      }
    } else {
      return FutureBuilder(
        future: fetchMedia(pageNumber! + 1),
        builder: (BuildContext context, AsyncSnapshot<MediaFiles> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CustomPaginator(context).loadingWidgetMaker();
            case ConnectionState.done:
              mediaList!.addAll(snapshot.data!.rows!);
              pageNumber=pageNumber!+1;
              Future.microtask(() {
                setState(() {});
              });
              return CustomPaginator(context).loadingWidgetMaker();
            default:
              return CustomPaginator(context).loadingWidgetMaker();
          }
        },
      );
    }
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex, Media media) {
    if (media.mediaType != null && media.mediaType!.contains('image')) {
      return Container(
        child: isLocalFile != null && isLocalFile!
            ? new Image.file(new File(media.mediaUrl!))
            : appImageView(
          url:(widget.isFullImageUrl!=null && widget.isFullImageUrl!)?media.mediaUrl:(onFullPage != null && onFullPage!)
              ? Utility().getUrlForImage(
              media.mediaUrl, RESOLUTION_TYPE.R512, SERVICE_TYPE.POST)
              : Utility().getUrlForImage(media.mediaUrl,
              RESOLUTION_TYPE.R256, SERVICE_TYPE.POST),
        ),
      );
      // return PinchZoom(
      //   zoomedBackgroundColor: HexColor(AppColors.appColorBlack).withOpacity(0.5),
      //   resetDuration:  Duration(milliseconds: 100),
      //   zoomEnabled: true,
      //   maxScale: 2,
      //   image: CachedNetworkImage(
      //     imageUrl: Utility().getUrlForImage(media.mediaUrl, RESOLUTION_TYPE.R512, SERVICE_TYPE.POST),
      //     fit: BoxFit.contain,
      //   ),
      // );
    } else if (media.mediaType != null && media.mediaType!.contains('video')) {
      return Center(
          child: appVideoView(
              isLocalFile: isLocalFile,
              mediaUrl: media.mediaUrl,
              onFullPage: onFullPage));
    } else if (Utility().checkFileMimeType(media.mediaType ?? "")) {
      return Stack(
        children: [
          appImageView(
            url: (widget.isFullImageUrl!=null && widget.isFullImageUrl!)?media.mediaUrl:(onFullPage != null && onFullPage!)
                ? Utility().getUrlForImage(
                media.mediaUrl, RESOLUTION_TYPE.R512, SERVICE_TYPE.POST,
                shouldprint: true)
                : Utility().getUrlForImage(
                media.mediaUrl, RESOLUTION_TYPE.R256, SERVICE_TYPE.POST,
                shouldprint: true),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: double.infinity,
                color: HexColor(AppColors.appColorBackground),
                child: Padding(
                  padding:
                  EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_file,
                        color: HexColor(AppColors.appColorBlack65),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "${media.mediaType!.toUpperCase()} " +
                            AppLocalizations.of(context)!
                                .translate('file_attached'),
                        style: styleElements
                            .captionThemeScalable(context)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
          )
        ],
      );
    } else {
      return Container(
        child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate('no_media'),
            )),
        decoration: BoxDecoration(
          color: HexColor(AppColors.appColorGrey500),
        ),
      );
    }
  }

  int? getItemCount() {
    if (totalItems! > mediaList!.length) {
      return mediaList!.length + 1;
    } else {
      return totalItems;
    }
  }
}

class appImageView extends StatefulWidget {
  final String? url;
  final String? path;

  appImageView({this.url, this.path});

  @override
  appImageViewState createState() => appImageViewState();
}

class appImageViewState extends State<appImageView> {
  double aspectRatio = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          (onFullPage != null && onFullPage!)
              ? Container()
              : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(widget.url!)),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: HexColor(AppColors.appColorWhite).withOpacity(0.5),
              ),
            ),
          ),
          widget.path != null
              ? PinchZoom(
            zoomedBackgroundColor:
            HexColor(AppColors.appColorBlack).withOpacity(0.5),
            resetDuration: Duration(milliseconds: 100),
            zoomEnabled: true,
            maxScale: 2,
            image: new Image.file(File(widget.path!)),
          )
              : PinchZoom(
            zoomedBackgroundColor:
            HexColor(AppColors.appColorBlack).withOpacity(0.5),
            resetDuration: Duration(milliseconds: 100),
            zoomEnabled: true,
            maxScale: 2,
            image: CachedNetworkImage(
              imageUrl: widget.url!,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      // child: PinchZoom(
      //   zoomedBackgroundColor: HexColor(AppColors.appColorBlack).withOpacity(0.5),
      //   resetDuration:  Duration(milliseconds: 100),
      //   zoomEnabled: true,
      //   maxScale: 2,
      //   image: CachedNetworkImage(
      //     imageUrl: widget.url,
      //     fit: BoxFit.contain,
      //   ),
      // ),
    );
  }
}

// ignore: must_be_immutable
class appVideoView extends StatefulWidget {
  String? mediaUrl;
  bool? onFullPage;
  bool? isLocalFile;

  appVideoView({this.mediaUrl, this.onFullPage, this.isLocalFile});

  _appVideoView createState() => _appVideoView(
      mediaUrl: mediaUrl, onFullPage: onFullPage, isLocalFile: isLocalFile);
}

class _appVideoView extends State<appVideoView> {
  String? mediaUrl;
  bool? onFullPage;
  bool? isLocalFile;

  _appVideoView({this.mediaUrl, this.onFullPage, this.isLocalFile});

  VideoPlayerController? _controller;

  // BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    // BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
    //     BetterPlayerDataSourceType.NETWORK, Config.BASE_URL+mediaUrl);
    // _betterPlayerController = BetterPlayerController(
    //     BetterPlayerConfiguration(),
    //     betterPlayerDataSource: betterPlayerDataSource);

    _controller = isLocalFile != null && isLocalFile!
        ? VideoPlayerController.file(File(mediaUrl!))
        : VideoPlayerController.network(Config.BASE_URL + mediaUrl!);

    // _controller = VideoPlayerController.network(
    //     Config.BASE_URL + mediaUrl);
    _controller!.addListener(() {
      setState(() {});
    });

    _controller!.setLooping(false);
    _controller!.initialize().then((_) => setState(() {}));
    if (onFullPage != null && onFullPage!) {
      _controller!.play();
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _sigmaX = 10.0; // from 0-10
    double _sigmaY = 10.0; // from 0-10
    double _opacity = 0.5; // from 0-1.0
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(Utility().getUrlForImage(
                      mediaUrl, RESOLUTION_TYPE.R64, SERVICE_TYPE.POST))),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
              child: Container(
                color: HexColor(AppColors.appColorBlack).withOpacity(_opacity),
              ),
            ),
          ),
          Center(
            child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!)
              // :
              //             BetterPlayerListVideoPlayer(BetterPlayerDataSource(
              //               BetterPlayerDataSourceType.NETWORK,Config.BASE_URL+mediaUrl
              //             ),
              //               key: Key(mediaUrl.hashCode.toString()),
              //               playFraction: 0.8,
              //             )
            ),
          ),
          Visibility(
            visible: (onFullPage == null || !onFullPage!),
            child: Container(
              color: HexColor(AppColors.primaryTextColor10),
              child: Center(
                child: Icon(
                  Icons.play_arrow,
                  color: HexColor(AppColors.appColorWhite),
                  size: 100.0,
                ),
              ),
            ),
          ),
          Visibility(
            visible: (onFullPage != null && onFullPage!),
            child: _ControlsOverlay(controller: _controller),
          ),
          Visibility(
              visible: (onFullPage != null && onFullPage!),
              child: VideoProgressIndicator(
                _controller!,
                colors: VideoProgressColors(
                    bufferedColor: HexColor(AppColors.appColorWhite),
                    playedColor: HexColor(AppColors.appMainColor),
                    backgroundColor: HexColor(AppColors.appColorGrey500)),
                allowScrubbing: true,
              )),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, this.controller}) : super(key: key);

  final VideoPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller!.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: HexColor(AppColors.appColorBlack35),
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: HexColor(AppColors.appColorWhite),
                size: 100.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller!.value.isPlaying ? controller!.pause() : controller!.play();
          },
        ),
        // Align(
        //   alignment: Alignment.topRight,
        //   child: PopupMenuButton<double>(
        //     initialValue: controller.value.playbackSpeed,
        //     tooltip: 'Playback speed',
        //     onSelected: (speed) {
        //       controller.setPlaybackSpeed(speed);
        //     },
        //     itemBuilder: (context) {
        //       return [
        //         for (final speed in _examplePlaybackRates)
        //           PopupMenuItem(
        //             value: speed,
        //             child: Text('${speed}x'),
        //           )
        //       ];
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(
        //         // Using less vertical padding as the text is also longer
        //         // horizontally, so it feels like it would need more spacing
        //         // horizontally (matching the aspect ratio of the video).
        //         vertical: 12,
        //         horizontal: 16,
        //       ),
        //       child: Text('${controller.value.playbackSpeed}x'),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
