import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lottie/lottie.dart';

/*// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;*/
class TricycleSpeakerComponent extends StatelessWidget{
  final String? imageUrl;
  final double? size;
  final String? name;
  final String? designation;
  final bool speaking;
  final bool? isSpeaking;
  final bool isModerator;
  final bool isAudience;
  final Function(bool ,int)? videoClickCallBack;
 final RTCVideoRenderer? renderer;
  final bool? isMute;
  final int? isVideoOn;
  final int? userId;
  final int? participantId;
  TricycleSpeakerComponent({this.renderer,this.videoClickCallBack,this.userId,this.participantId,this.imageUrl,this.size,this.name,this.isVideoOn,this.designation,this.speaking = false,this.isModerator = false,this.isAudience = false,this.isMute,this.isSpeaking});
  @override
  Widget build(BuildContext context) {



    double newSize=size!-4;
    final TextStyleElements styleElements = TextStyleElements(context);
    return Container(
      child: Center(
        child: SizedBox(
          width: size,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
             children: [
               Center(
                 child: SizedBox(
                 height: newSize,
                 width: newSize,
                 child:isVideoOn==1? _renderLocalPreview(userId==participantId,participantId!):
                 Stack(
                   children: [
                     Visibility(
                       visible: isSpeaking!=null &&isSpeaking!,
                         child:  Lottie.asset(
                           'assets/voice.json',
                           width: size,
                           height: size,
                           fit: BoxFit.fill,
                         )
                     ),
                     Padding(
                       padding: isAudience? EdgeInsets.all(0.0):  newSize<100? EdgeInsets.all(10.0):EdgeInsets.all(20.0),
                       child: Align(
                         alignment: Alignment.topLeft,
                         child: TricycleAvatar(
                           imageUrl: imageUrl,
                           size: newSize,
                           key: UniqueKey(),
                           isClickable: false,
                           withBorder: false,
                           borderSize: 4,
                           isFullUrl: false,
                           withBorderDivider: speaking,
                           borderDividersize: 2,
                           borderColor: speaking?HexColor(AppColors.appMainColor):HexColor(AppColors.appColorWhite),
                           service_type: SERVICE_TYPE.PERSON,
                           resolution_type: RESOLUTION_TYPE.R64,
                         ),
                       ),
                     ),
                     Visibility(
                       visible: isAudience ? !isAudience : isMute!,
                       child: Align(
                         alignment: Alignment.bottomRight,
                         child: Padding(
                           padding: EdgeInsets.only(right: newSize>100?0.1*newSize:0.02*newSize,
                               bottom: newSize>100?0.25*newSize:0.15*newSize),
                           child: Visibility(
                             /* visible: !isAudience && !speaking,*/
                             child: Container(
                               padding: EdgeInsets.all(4),
                               decoration: BoxDecoration(
                                   border: Border.all(color: HexColor(AppColors.appMainColor,),width: 0.5),
                                   color: HexColor(AppColors.appColorWhite), shape: BoxShape.circle),
                               child: Icon(
                                 isMute!? Icons.mic_off_rounded:Icons.mic_none_outlined,
                                 size: newSize>100?24:18,
                                 color: HexColor(AppColors.appMainColor),
                               ),
                             ),
                           ),
                         ),
                       ),
                     ),

                   ],
                 ),
             ),
               ),],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isModerator?Padding(
                    padding:  EdgeInsets.only(right:4.0),
                    child: RoomButtons(context: context).moderatorImage,
                  ):Container(),
                  Flexible(
                    child: Text(
                      name!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:  styleElements.subtitle2ThemeScalable(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: HexColor(AppColors.appColorBlack65)
                      )
                    ),
                  )
                ],
              ),
              Text(designation??"", maxLines:1,overflow:TextOverflow.ellipsis,style: styleElements.captionThemeScalable(context),)
            ],
          ),
        ),
      ),
    );
  }
  // Generate local preview
  // ignore: missing_return
  Widget _renderLocalPreview(bool isLocalVideo,int id) {
    return
        InkWell(
          onTap: (){

            videoClickCallBack!(isLocalVideo,id);
          },
          child: Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                  height: 150,
                  width: 150,
                  color: HexColor(AppColors.appColorBlack85),
                  child:isLocalVideo ? SizedBox.expand(child: Center(child: RTCVideoView(renderer!, mirror: true,objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover))):Center(child: RTCVideoView(renderer!, mirror: false,objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)),
            )
          ),
        ));


  }


}