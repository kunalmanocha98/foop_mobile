import 'dart:async';

import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';



class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String type;

  const Camera({
    Key? key,
    required this.type,
    required this.cameras,
  }) : super(key: key);

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
bool _toggleCamera =false;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.low,
    );

    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(children: [CameraPreview(_controller!),Align(
              alignment: Alignment.bottomCenter,
              child:  Padding(
                padding: const EdgeInsets.only(bottom:50.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appTextButton(
                      color: HexColor(AppColors.appColorBlack).withOpacity(0.05),
                      shape: StadiumBorder( 
                        side: BorderSide(color: HexColor(AppColors.appColorBlack).withOpacity(0.05), width: 1),
                      ),
                      onPressed: () async {
                        try {
                        Navigator.of(context).pop();

                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.translate('cancel'),
                      style: TextStyle(
                      fontSize: 20,
                      color: HexColor(AppColors.appColorWhite),
                      ),
                    ),
                    ),

                    FloatingActionButton(
                      onPressed: () async {
                        try {
                          await _initializeControllerFuture;

                          // final path = join(
                          //   (await getTemporaryDirectory()).path,
                          //   '${DateTime.now()}.png',
                          // );

                          if(widget.type=="camera")
                            {
                              var path = await _controller!.takePicture();
                              Navigator.of(context).pop({'result': path.path});
                            }
                          else{
                            await _controller!.startVideoRecording();
                          }

                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Icon(Icons.camera_alt),
                    ),
                    appTextButton(
                      shape: StadiumBorder( 
                        side: BorderSide(color: HexColor(AppColors.appColorBlack).withOpacity(0.05), width: 1),
                      ),
                      onPressed: () async {
                        try {
                          await _initializeControllerFuture;
                          if (!_toggleCamera) {
                            onCameraSelected(widget.cameras[1]);
                            setState(() {
                              _toggleCamera = true;
                            });
                          } else {
                            onCameraSelected(widget.cameras[0]);
                            setState(() {
                              _toggleCamera = false;
                            });
                          }

                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Icon(Icons.flip_camera_ios_outlined, color: HexColor(AppColors.appColorWhite),),
                    ),

                  ],
                ),
              ),
            )],);
          } else {
            return Center(child: CircularProgressIndicator(),
            );
          }
        },
      ),

    );
  }



  void onCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) await _controller!.dispose();
    _controller = CameraController(cameraDescription, ResolutionPreset.low);

    _controller!.addListener(() {
      if (mounted) setState(() {});
      if (_controller!.value.hasError) {

      }
    });

    try {
      await _controller!.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) setState(() {});
  }

}

