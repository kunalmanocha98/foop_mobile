import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TestVideoPage extends StatefulWidget {
  @override
  _TestVideoState createState() => _TestVideoState();
}

class _TestVideoState extends State<TestVideoPage> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');

    _controller!.addListener(() {
      setState(() {});
    });
    _controller!.setLooping(true);
    _controller!.initialize().then((_) => setState(() {}));
    _controller!.play();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(context, appBarTitle: 'testvideopage', onBackButtonPress:(){

        }),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 20.0),
              ),
               Text(AppLocalizations.of(context)!.translate('with_assets_mp4')),
              Container(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_controller!),
                      _ControlsOverlay(controller: _controller),
                      VideoProgressIndicator(_controller!, allowScrubbing: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

