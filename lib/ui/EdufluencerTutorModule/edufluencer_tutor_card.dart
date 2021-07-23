import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/postcardactionbuttons.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/Edufluencer_Tutor_modles/edufluencer_list.dart';
import 'package:oho_works_app/ui/EdufluencerTutorModule/become_edufluencer_tutor_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EdufluencerTutorCard extends StatelessWidget {
  final String? imageUrl;
  final Color? borderColorForImage;
  final String? name;
  final String? designation;
  final Function? followButtonCallback;
  final Function? messageButtonCallback;
  final String? description;
  final String? title;
  final double? rating;
  final edufluencer_type? type;
  final List<SkillsList>? skillsList;
  final List<ClassesList>? classList;
  final List<SubjectsList>? subjectList;
  final bool? isfollowing;
final String? bookingStatus;
  EdufluencerTutorCard({
    this.imageUrl,
    this.borderColorForImage,
    this.name,
    this.designation,
    this.followButtonCallback,
    this.messageButtonCallback,
    this.description,
    this.title,
    this.rating,
    this.type,
    this.skillsList,
    this.classList,
    this.isfollowing,
    this.bookingStatus,
    this.subjectList
  });

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return TricycleListCard(
      child: Column(
        children: [
          SizedBox(height: 16,),
          TricycleAvatar(
            imageUrl: imageUrl,
            size: 120,
            resolution_type: RESOLUTION_TYPE.R64,
            service_type: SERVICE_TYPE.PERSON,
            borderDividersize: 4,
            withBorder: true,
            borderColor: borderColorForImage,
          ),
          Text(
            name!,
            style: styleElements.subtitle1ThemeScalable(context),
          ),
          Text(
            title!,
            style: styleElements.subtitle2ThemeScalable(context),
          ),
          Text(
            designation!,
            style: styleElements.subtitle2ThemeScalable(context),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                rating != null ? rating!.toStringAsFixed(2) : 0.0.toString(),
                style: styleElements.subtitle1ThemeScalable(context).copyWith(
                  color: HexColor(AppColors.appMainColor),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 8),
                child: RatingBar(
                  ignoreGestures: true,
                  initialRating: rating ?? 0.0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 12,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  ratingWidget: RatingWidget(
                    empty: Icon(
                      Icons.star_outline,
                      color: HexColor(AppColors.appMainColor),
                    ),
                    half: Icon(
                      Icons.star_half_outlined,
                      color: HexColor(AppColors.appMainColor),
                    ),
                    full: Icon(
                      Icons.star_outlined,
                      color: HexColor(AppColors.appMainColor),
                    ),
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
              Visibility(
                visible: isfollowing!=null? !isfollowing! :true,
                child: TricycleTextButton(
                  onPressed: followButtonCallback,
                  padding: EdgeInsets.all(0),
                  child: Text(
                    AppLocalizations.of(context)!.translate('follow'),
                    style: styleElements
                        .captionThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                ),
              ),
              SizedBox(width: 8,),
              Visibility(
                visible: bookingStatus!=null,
                child: TricycleTextButton(
                  onPressed: messageButtonCallback,
                  padding: EdgeInsets.all(0),
                  child: Text(
                    AppLocalizations.of(context)!.translate('message'),
                    style: styleElements
                        .captionThemeScalable(context)
                        .copyWith(color: HexColor(AppColors.appMainColor)),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24),
            child: Text(description!,
              textAlign: TextAlign.center,
              style: styleElements.bodyText2ThemeScalable(context),),
          ),
          Visibility(
            visible: type == edufluencer_type.E && skillsList != null && skillsList!.length > 0,
            child: Container(
              height: 30,
              margin: EdgeInsets.only(top:8),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: (skillsList != null && skillsList!.length > 0)
                    ? skillsList!.length + 1
                    : 0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return index == 0 ? Center(child: Text('Speacialist:')) :
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: HexColor(AppColors.appColorBackground)
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(skillsList![index-1].skillName!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: (type == edufluencer_type.T && (classList != null && classList!.length > 0)),
            child: Container(
              height: 30,
              margin: EdgeInsets.only(top:8),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: (classList != null && classList!.length > 0)
                    ? classList!.length + 1
                    : 0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return index == 0 ? Center(child: Text('Classes:')) :
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: HexColor(AppColors.appColorBackground)
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(classList![index-1].className!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          PostCardActionButtons(),

        ],
      ),
    );
  }
}
