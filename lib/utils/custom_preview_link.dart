import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'TextStyles/TextStyleElements.dart';

Widget CustomPreviewLink(BuildContext context,String url,  TextStyleElements styleElements) {
return Container();

  // return FlutterLinkPreview(
  //
  //   key: ValueKey(url),
  //   url:url,
  //   builder: (info) {
  //     if (info == null) return const SizedBox();
  //     if (info is WebImageInfo) {
  //       return CachedNetworkImage(
  //         imageUrl: info.image,
  //         fit: BoxFit.contain,
  //       );
  //     }
  //
  //     final WebInfo webInfo = info;
  //     if (!WebAnalyzer.isNotEmpty(webInfo.title)) return const SizedBox();
  //     return Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: const Color(0xFFF0F1F2),
  //       ),
  //       padding: const EdgeInsets.all(10),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: <Widget>[
  //           if (WebAnalyzer.isNotEmpty(webInfo.image)) ...[
  //             Padding(
  //               padding: const EdgeInsets.only(right:8.0),
  //               child: SizedBox(
  //                 height: 90,width: 90,
  //                 child: CachedNetworkImage(
  //                   imageUrl: webInfo.image,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //           ],
  //           Expanded(
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: <Widget>[
  //                     CachedNetworkImage(
  //                       imageUrl: webInfo.icon ?? "",
  //                       imageBuilder: (context, imageProvider) {
  //                         return Image(
  //                           image: imageProvider,
  //                           fit: BoxFit.contain,
  //                           width: 30,
  //                           height: 30,
  //                           errorBuilder: (context, error, stackTrace) {
  //                             return const Icon(Icons.link);
  //                           },
  //                         );
  //                       },
  //                     ),
  //                     const SizedBox(width: 8),
  //                     Expanded(
  //                       child: Text(
  //                         webInfo.title,
  //                         style: styleElements
  //                             .bodyText2ThemeScalable(context)
  //                             .copyWith(
  //                             color:
  //                             HexColor(AppColors.appColorBlack85)),
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 if (WebAnalyzer.isNotEmpty(webInfo.description)) ...[
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     webInfo.description,
  //                     maxLines: 3,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ],
  //               ],
  //             ),
  //           ),
  //
  //
  //         ],
  //       ),
  //     );
  //   },
  // );
}
