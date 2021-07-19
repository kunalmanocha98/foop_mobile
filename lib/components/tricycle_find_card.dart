import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:flutter/material.dart';

import 'customcard.dart';

class TricycleFindCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget image;
  final Color color;
  final Color titleColor;
  final Color subtitleColor;

  TricycleFindCard({
    this.title,
    this.subtitle,
    this.image,
    this.color,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return TricycleListCard(
      padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 24),
      color: color,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: styleElements.headline5ThemeScalable(context).copyWith(
                      color: titleColor
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Flexible(
                    child: Text(
                  subtitle,
                  style: styleElements.subtitle2ThemeScalable(context).copyWith(
                    color: subtitleColor
                  ),
                ))
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [image],
            ),
          )
        ],
      ),
    );
  }
}
