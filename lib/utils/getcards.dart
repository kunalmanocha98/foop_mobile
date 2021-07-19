
import 'package:oho_works_app/components/tricycle_earn_card.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/common_cards/about_profile_card.dart';
import 'package:oho_works_app/profile_module/common_cards/art_and_photography.dart';
import 'package:oho_works_app/profile_module/common_cards/bio_card.dart';
import 'package:oho_works_app/profile_module/common_cards/card_courses_detail.dart';
import 'package:oho_works_app/profile_module/common_cards/classes_branshes_card.dart';
import 'package:oho_works_app/profile_module/common_cards/club_and_socities.dart';
import 'package:oho_works_app/profile_module/common_cards/club_detail_card.dart';
import 'package:oho_works_app/profile_module/common_cards/contact_info_card.dart';
import 'package:oho_works_app/profile_module/common_cards/cources_card.dart';
import 'package:oho_works_app/profile_module/common_cards/department_card.dart';
import 'package:oho_works_app/profile_module/common_cards/detailed_classes_branches_card.dart';
import 'package:oho_works_app/profile_module/common_cards/education_card.dart';
import 'package:oho_works_app/profile_module/common_cards/education_card_without_title.dart';
import 'package:oho_works_app/profile_module/common_cards/founder_card.dart';
import 'package:oho_works_app/profile_module/common_cards/goal_card_only.dart';
import 'package:oho_works_app/profile_module/common_cards/history_card.dart';
import 'package:oho_works_app/profile_module/common_cards/images_see_more.dart';
import 'package:oho_works_app/profile_module/common_cards/interest_card.dart';
import 'package:oho_works_app/profile_module/common_cards/language_card.dart';
import 'package:oho_works_app/profile_module/common_cards/language_card_single.dart';
import 'package:oho_works_app/profile_module/common_cards/langugae_card_detail_page.dart';
import 'package:oho_works_app/profile_module/common_cards/literature_composition_card.dart';
import 'package:oho_works_app/profile_module/common_cards/medium_card_detail.dart';
import 'package:oho_works_app/profile_module/common_cards/medium_education_card.dart';
import 'package:oho_works_app/profile_module/common_cards/parent_card.dart';
import 'package:oho_works_app/profile_module/common_cards/profile_card.dart';
import 'package:oho_works_app/profile_module/common_cards/rating_review_card.dart';
import 'package:oho_works_app/profile_module/common_cards/science_technology_card.dart';
import 'package:oho_works_app/profile_module/common_cards/select_profile_card.dart';
import 'package:oho_works_app/profile_module/common_cards/skill_card.dart';
import 'package:oho_works_app/profile_module/common_cards/sportsDetailcard.dart';
import 'package:oho_works_app/profile_module/common_cards/sports_card.dart';
import 'package:oho_works_app/profile_module/common_cards/staff_and_students_card.dart';
import 'package:oho_works_app/profile_module/common_cards/staggered_images_card.dart';
import 'package:oho_works_app/profile_module/common_cards/student_card.dart';
import 'package:oho_works_app/profile_module/common_cards/subject_detail_page_item.dart';
import 'package:oho_works_app/profile_module/common_cards/subjects_card.dart';
import 'package:oho_works_app/profile_module/common_cards/verified_card.dart';
import 'package:oho_works_app/ui/CustomCards/CommonInviteCard.dart';
import 'package:oho_works_app/ui/CustomCards/calendercard.dart';
import 'package:oho_works_app/ui/CustomCards/horizontal_scrollview_card.dart';
import 'package:oho_works_app/ui/CustomCards/news_card.dart';
import 'package:oho_works_app/ui/CustomCards/notice_card.dart';
import 'package:oho_works_app/ui/CustomCards/post_home_card.dart';
import 'package:oho_works_app/ui/CustomCards/profileProgressCard.dart';
import 'package:oho_works_app/ui/CustomCards/rating_card.dart';
import 'package:oho_works_app/ui/CustomCards/suggestioncard.dart';
import 'package:oho_works_app/ui/CustomCards/todayQuotescard.dart';
import 'package:oho_works_app/ui/JournalCommentCard.dart';
import 'package:flutter/cupertino.dart';

import 'TextStyles/TextStyleElements.dart';

class GetAllCards {
  GetAllCards();
  Widget getCard(
      String userName,
      String institutionId,
      bool isProfile,
      TextStyleElements styleElements,
      CommonCardData commonCardData,
      Persondata rows,
      String type,
      int id,
      String ownerType,
      int ownerId,
      String imageUrl,
      {Null Function() callBck}) {
    switch (commonCardData.cardName) {
      case "Biocard":
        {

          return BioCard(
              data: commonCardData,
              callback: callBck,
              persondata: rows,
              userId: id,
              ownerId: ownerId,
              type: type);
        }
        break;
      case "horizontalScrollCard":
        {
          return HorizontalScrollCard(data: commonCardData);
        }
      case "GoalsCardOnly":
        {
          return GoalsCardOnly(data: commonCardData);
        }
        break;
      /* case "GoalsAndObjectiveCardDetailPage":
        {
          return GoalsAndObjectiveCardDetailPage(data: commonCardData);
        }
        break;*/
      case "StudentCard":
        {
          return StudentCard(data: commonCardData);
        }
        break;
      case "SelectProfileCard":
        {
          return SelectProfileCard();
        }
        break;
       case "RatingAndReviewCard":
        {
          return RatingAndReviewCard(data: commonCardData,
              callback: callBck,
              showRating: ownerId!=id,
              persondata: rows,
              userId: id,
              userName:userName,
              ownerId: ownerId,
              type: type,
              imageUrl:imageUrl
          );
        }
        break;

      case "OnlyTextCard":
        {
          // return StaffAndStudentsCard(data: commonCardData);
          /** this code is commented to hide the quote card for the current requirement in 12March2021*/
          // return OnlyTextCard(
          //   data: commonCardData,
          //   rows: rows,
          //   callback: callBck,
          //   type: type,
          //   userId: id,
          //   ownerId: ownerId,
          // );
          return null;
        }
        break;

      case "Profiledetailcard":
        {
          return Profiledetailcard(
            data: commonCardData,
            callback: callBck,
            persondata: rows,
            ownerId: ownerId,
            PersonType:type,
            ownerType: ownerType,
          );
        }
        break;
      case "Verifiedcard":
        {
          return VerifiedCard(
            data: commonCardData
          );
        }
        break;

      case "MediumOfEducationCard":
        {
          if (isProfile)
            return MediumEducationcard(
              data: commonCardData,
              instId: institutionId,
              id: id,
              personType: type,
            );
          else
            return MediunDetail(
              data: commonCardData,
              callbackPicker: callBck,
              id: id,
              personType: type, onSeeMoreClicked: () {  },
            );
        }
        break;
      case "CourseCard":
        {
          if (isProfile)
            return CoursesCard(
              data: commonCardData,
              callbackPicker: callBck,
              instituteId: institutionId,
              id: id,
              personType: type,
            );
          else
            return CoursesDetailCard(
              data: commonCardData,
              callbackPicker: callBck,
              id: id,
              personType: type, onSeeMoreClicked: () {  },
            );
        }
        break;
      case "DepartmentCard":
        {
          if (isProfile)
            return DepartmentCard(
              data: commonCardData,
              callbackPicker: callBck,
              instituteId: institutionId,
              id: id,
              personType: type,
            );
          else
            return CoursesDetailCard(
              data: commonCardData,
              callbackPicker: callBck,
              id: id,
              personType: type, onSeeMoreClicked: () {  },
            );
        }
        break;
      case "LanguageCard":
        {
          if (isProfile)
            return LanguageCard(
              data: commonCardData,
              callbackPicker: callBck,
              instId: institutionId,
              id: id,
              personType: type,
            );
          else
            return LanguageCardDetailPage(
              userName:userName,
              data: commonCardData,
              callbackPicker: callBck,
              id: id,
              personType: type, onSeeMoreClicked: () {  },
            );
        }
        break;

      case "LanguageCardSingle":
        {
          return LanguageCardSingle(
              data: commonCardData, instId: institutionId);
        }
      case "SkillsCard":
        {
          return SkillsCard(data: commonCardData);
        }
        break;
      case "EducationCard":
        {
          if (isProfile)
            return EducationCard(
                data: commonCardData,
                callbackPicker: callBck,
                CardType:"education",
                id: id,
                personType: type);
          else
            return EducationCardWithOutTitle(
                data: commonCardData,
                callbackPicker: callBck,
                id: id,
                CardType:"education",
                personType: type);
        }
        break;

      case "WorkCard":
        {
          if (isProfile)
            return EducationCard(
                data: commonCardData,
                callbackPicker: callBck,
                CardType:"work",

                personType: type,
                id: id);
          else
            return EducationCardWithOutTitle(
                data: commonCardData,
                callbackPicker: callBck,
                CardType:"work",
                personType: type,
                id: id);
        }
        break;
      /* case "GoalsAndObjectiveCard":
        {
          return GoalsAndObjectiveCard(data: commonCardData);
        }
        break;*/
      case "ClassesAndBranches":
        {
          if (isProfile)
            return ClassesAndBranches(
              data: commonCardData,
              callbackPicker: callBck,
              id: id,
              type: type,
              institutionId: institutionId,
            );
          else
            return ClassesAndBranchesDetailed(
                data: commonCardData,
                callbackPicker: callBck,
                id: id,
                type: type,
                userName: userName,
                institutionId: institutionId);
        }
        break;
      case "ScienceAndTechnology":
        {
          return ScienceAndTechnology(data: commonCardData);
        }
        break;

      case "LiteratureAndCompositions":
        {
          return LiteratureAndCompositions(data: commonCardData);
        }
        break;
      case "InterestCard":
        {
          return InterestCard(data: commonCardData);
        }
        break;
      case "SubjectsCard":
        {
          if (isProfile)
            return SubjectsCard(
              data: commonCardData,
              callbackPicker: callBck,
              instId: institutionId,
              id: id,
              personType: type,
            );
          else
            return SubjectsDetailPageCard(
                data: commonCardData,
                callbackPicker: callBck,
                instId: institutionId,
                userName: userName,
                type: type,
                id: id, onSeeMoreClicked: () {  },);
        }
        break;
      case "ClubAndSocietyCard":
        {
          if (isProfile)
            return ClubAndSocities(
                data: commonCardData,
                isProfile: isProfile,
                callbackPicker: callBck,
                instituteId: institutionId,
                personType: type,
                id: id);
          else
            return ClubDetailCard(
                data: commonCardData,
                isProfile: isProfile,
                callbackPicker: callBck,
                instituteId: institutionId,
                personType: type,
                id: id);
        }
        break;

      case "ArtAndPhotography":
        {
          return ArtAndPhotography(data: commonCardData);
        }
        break;
      case "SportAndFitnessCard":
        {
          if (isProfile)
            return SportsCard(
              data: commonCardData,
              isProfile: isProfile,
              callbackPicker: callBck,
              instituteId: institutionId,
              id: id,
              personType: type,
            );
          else
            return SportsCardDetail(
              data: commonCardData,
              isProfile: isProfile,
              callbackPicker: callBck,
              instituteId: institutionId,
            );
        }
        break;
      case "Campus&FacilityCard":
        {
          if (isProfile)
            return StaggeredImagesCard(
              data: commonCardData,
              instId: institutionId,
              id: id,
              personType: type,
            );
          else
            return ImagesSeeMore(
              type: "person",
             /* data: commonCardData,
              instId: institutionId,
              id: id,
              callbackPicker: callBck,
              personType: type,*/
            );
        }
        break;
       case "ParentCard":
        {
          return ParentCard(  data: commonCardData,
              isProfile: isProfile,
              callbackPicker: callBck,
              instituteId: institutionId,
              personType: type,
              ownerType:ownerType,
              ownerId:ownerId,
              id: id);
        }
        break;
      case "ContactInfoCard":
        {
          return ContactInfoCard(data: commonCardData);
        }
        break;

      case "aboutCard":
        {
          return AboutProfileCard(
            data: commonCardData,
          );
        }
        break;

      case "historyCard":
        {
          return HistoryCard(data: commonCardData);
        }
        break;
      case "FounderCard":
        {
          return FounderCard(data: commonCardData);
        }
        break;
      case "StaffAndStudentsCard":
        {
          return StaffAndStudentsCard(data: commonCardData);
        }
        break;
      case "RatingCard":
        {
          return RatingCard(
            data: commonCardData,
          );
        }
        break;
      case "JournalCard":
        {
          return JournalCard(
            data: commonCardData,
          );
        }
        break;
      case "QouteCard":
        {
          return TodaysQouteCard(
            data: commonCardData,
          );
        }
        break;
      case "ProfileProgressCard":
        {
          return ProfileProgressCard(
          );
        }
        break;
      case "CommonInviteCard":
        {
          return CommonInviteCard(
            data: commonCardData,
          );
        }
        break;
      case "CalenderCard":
        {
          return TodaysCalenderCard(
            data: commonCardData,
          );
        }
        break;
      case "SuggestionCard":
        {
          return SuggestionCard(
            ownerType: ownerType,
            ownerId: ownerId,
            data: commonCardData,
          );
        }
        break;

      case "NoticeCards":
        {
          return NoticeCards(
            data: commonCardData,
          );
        }
        break;
      case "NewsCard":
        {
          return NewsCard(
            data: commonCardData,
            type: 'blog',
          );
        }
        break;
      case "NewsCard2":
        {
          print('newssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss');
          return NewsCard(
            data: commonCardData,
            type: 'news',
          );
        }
        break;
      default:
        {
          return null;
        }
    }
  }


  Widget getCardHome(
      String userName,
      String institutionId,
      bool isProfile,
      TextStyleElements styleElements,
      CommonCardData commonCardData,
      Persondata rows,
      String type,
      int id,
      String ownerType,
      int ownerId,
      {Null Function() callBck}) {
    switch (commonCardData.cardNames) {
      case "Biocard":
        {
          return BioCard(
              data: commonCardData,
              callback: callBck,
              persondata: rows,
              userId: id,
              ownerId: ownerId,
              type: type);
        }
        break;
      case "HorizontalScrollCard":
        {
          return HorizontalScrollCard(data: commonCardData);
        }
      case "GoalsCardOnly":
        {
          return GoalsCardOnly(data: commonCardData);
        }
        break;
    /* case "GoalsAndObjectiveCardDetailPage":
        {
          return GoalsAndObjectiveCardDetailPage(data: commonCardData);
        }
        break;*/
      case "StudentCard":
        {
          return StudentCard(data: commonCardData);
        }
        break;
      case "SelectProfileCard":
        {
          return SelectProfileCard();
        }
        break;
    /* case "RatingAndReviewCard":
        {
          return RatingAndReviewCard(data: commonCardData);
        }
        break;*/

      case "OnlyTextCard":
        {
          // return StaffAndStudentsCard(data: commonCardData);
          /** this code is commented to hide the quote card for the current requirement in 12March2021*/
          // return OnlyTextCard(
          //   data: commonCardData,
          //   rows: rows,
          //   callback: callBck,
          //   type: type,
          //   userId: id,
          //   ownerId: ownerId,
          // );
          return null;
        }
        break;


      case "Profiledetailcard":
        {
          return Profiledetailcard(
            data: commonCardData,
            callback: callBck,
            persondata: rows,
            ownerId: ownerId,
            ownerType: ownerType,
          );
        }
        break;

      case "MediumOfEducationCard":
        {
          if (isProfile)
            return MediumEducationcard(
              data: commonCardData,
              instId: institutionId,
              id: id,
              personType: type,
            );
          else
            return MediunDetail(
              data: commonCardData,
              callbackPicker: callBck,
              id: id,
              personType: type, onSeeMoreClicked: () {  },
            );
        }
        break;
      case "CourseCard":
        {
          if (isProfile)
            return CoursesCard(
              data: commonCardData,
              callbackPicker: callBck,
              instituteId: institutionId,
              id: id,
              personType: type,
            );
          else
            return CoursesDetailCard(
              data: commonCardData,
              callbackPicker: callBck,
              id: id,
              personType: type, onSeeMoreClicked: () {  },
            );
        }
        break;

      case "LanguageCard":
        {
          if (isProfile)
            return LanguageCard(
              data: commonCardData,
              callbackPicker: callBck,
              instId: institutionId,
              id: id,
              personType: type,
            );
          else
            return LanguageCardDetailPage(
              userName:userName,
              data: commonCardData,
              callbackPicker: callBck,
              id: id,
              personType: type, onSeeMoreClicked: () {  },
            );
        }
        break;

      case "LanguageCardSingle":
        {
          return LanguageCardSingle(
              data: commonCardData, instId: institutionId);
        }
      case "SkillsCard":
        {
          return SkillsCard(data: commonCardData);
        }
        break;
      case "EducationCard":
        {
          if (isProfile)
            return EducationCard(
                data: commonCardData,
                callbackPicker: callBck,
                id: id,
                personType: type);
          else
            return EducationCardWithOutTitle(
                data: commonCardData,
                callbackPicker: callBck,
                id: id,
                personType: type);
        }
        break;

      case "WorkCard":
        {
          if (isProfile)
            return EducationCard(
                data: commonCardData,
                callbackPicker: callBck,
                personType: type,
                id: id);
          else
            return EducationCardWithOutTitle(
                data: commonCardData,
                callbackPicker: callBck,
                personType: type,
                id: id);
        }
        break;
    /* case "GoalsAndObjectiveCard":
        {
          return GoalsAndObjectiveCard(data: commonCardData);
        }
        break;*/
      case "ClassesAndBranches":
        {
          if (isProfile)
            return ClassesAndBranches(
              data: commonCardData,
              callbackPicker: callBck,
              id: id,
              type: type,
              institutionId: institutionId,
            );
          else
            return ClassesAndBranchesDetailed(
                data: commonCardData,
                callbackPicker: callBck,
                id: id,
                type: type,
                userName: userName,
                institutionId: institutionId);
        }
        break;
      case "ScienceAndTechnology":
        {
          return ScienceAndTechnology(data: commonCardData);
        }
        break;

      case "LiteratureAndCompositions":
        {
          return LiteratureAndCompositions(data: commonCardData);
        }
        break;
      case "InterestCard":
        {
          return InterestCard(data: commonCardData);
        }
        break;
      case "SubjectsCard":
        {
          if (isProfile)
            return SubjectsCard(
              data: commonCardData,
              callbackPicker: callBck,
              instId: institutionId,
              id: id,
              personType: type,
            );
          else
            return SubjectsDetailPageCard(
              data: commonCardData,
              callbackPicker: callBck,
              instId: institutionId,
              userName: userName,
              type: type,
              id: id, onSeeMoreClicked: () {  },);
        }
        break;
      case "ClubAndSocietyCard":
        {
          if (isProfile)
            return ClubAndSocities(
                data: commonCardData,
                isProfile: isProfile,
                callbackPicker: callBck,
                instituteId: institutionId,
                personType: type,
                id: id);
          else
            return ClubDetailCard(
                data: commonCardData,
                isProfile: isProfile,
                callbackPicker: callBck,
                instituteId: institutionId,
                personType: type,
                id: id);
        }
        break;

      case "ArtAndPhotography":
        {
          return ArtAndPhotography(data: commonCardData);
        }
        break;
      case "SportAndFitnessCard":
        {
          if (isProfile)
            return SportsCard(
              data: commonCardData,
              isProfile: isProfile,
              callbackPicker: callBck,
              instituteId: institutionId,
              id: id,
              personType: type,
            );
          else
            return SportsCardDetail(
              data: commonCardData,
              isProfile: isProfile,
              callbackPicker: callBck,
              instituteId: institutionId,
            );
        }
        break;
      case "Campus&FacilityCard":
        {
          if (isProfile)
            return StaggeredImagesCard(
              data: commonCardData,
              instId: institutionId,
              id: id,
              personType: type,
            );
          else
            return ImagesSeeMore(
              type: "person",
              /* data: commonCardData,
              instId: institutionId,
              id: id,
              callbackPicker: callBck,
              personType: type,*/
            );
        }
        break;
      case "ParentCard":
        {
          return ParentCard(  data: commonCardData,
              isProfile: isProfile,
              callbackPicker: callBck,
              instituteId: institutionId,
              personType: type,
              ownerType:ownerType,
              ownerId:ownerId,
              id: id);
        }
        break;
      case "ContactInfoCard":
        {
          return ContactInfoCard(data: commonCardData);
        }
        break;

      case "aboutCard":
        {
          return AboutProfileCard(
            data: commonCardData,
          );
        }
        break;

      case "historyCard":
        {
          return HistoryCard(data: commonCardData);
        }
        break;
      case "FounderCard":
        {
          return FounderCard(data: commonCardData);
        }
        break;
      case "StaffAndStudentsCard":
        {
          return StaffAndStudentsCard(data: commonCardData);
        }
        break;
      case "RatingCard":
        {
          return RatingCard(
            data: commonCardData,
          );
        }
        break;
      case "JournalCard":
        {
          return JournalCard(
            data: commonCardData,
          );
        }
        break;
      case "QuoteCard":
        {
          return TodaysQouteCard(
            data: commonCardData,
          );
        }
        break;
      case "ProfileProgressCard":
        {
          return ProfileProgressCard(
            persondata: rows,
            callback: callBck,
          );
        }
        break;
      case "CommonInviteCard":
        {
          return CommonInviteCard(
            data: commonCardData,
            type:type
          );
        }
        break;
      case "CalenderCard":
        {
          return TodaysCalenderCard(
            data: commonCardData,
          );
        }
        break;
      case "SuggestionCard":
        {
          if(commonCardData.data!=null && commonCardData.data.isNotEmpty)
          return SuggestionCard(
            data: commonCardData,
             ownerType:ownerType,
             ownerId:ownerId,
            callbackPicker: callBck,
          );
          else
            return null;
        }
        break;
      case "Post":
        {
          if(commonCardData.data!=null && commonCardData.data.isNotEmpty)
            return PostHomeCard(
              data: commonCardData,
              callbackPicker: callBck,
            );
          else
            return null;
        }
        break;
      case "NoticeCard":
        {
          if(commonCardData.data!=null && commonCardData.data.isNotEmpty)
          return NoticeCards(
            data: commonCardData,
            type:"NoticeCard"
          );
          else
            return null;
        }
        break;
      case "QuestionCard":
        {
          if(commonCardData.data!=null && commonCardData.data.isNotEmpty)
          return NoticeCards(
            data: commonCardData,
              type:"QuestionCard"
          );
          else
            return null;
        }
        break;
      case "NewsCard":
        {
          if(commonCardData.data!=null && commonCardData.data.isNotEmpty)
          return NewsCard(
            data: commonCardData,
            type: 'blog',
          );
          else
            return null;
        }
        break;
      case "NewsCard2":
        {
          if(commonCardData.data!=null && commonCardData.data.isNotEmpty)
            return NewsCard(
              data: commonCardData,
              type: 'news',
            );
          else
            return null;
        }
        break;
      case "CommunityCard":
        {
          if(commonCardData.data!=null && commonCardData.data.isNotEmpty)
            // return CommunityRoomCard(
            //   data: commonCardData,
            // );
            return null;
          else
            return null;
        }
        break;
      case "Earn":
        {
          return TricycleEarnCard(
            imageUrl: commonCardData.imageUrl,
            moneyVal: commonCardData.moneyVal,
            quote: commonCardData.quote,
            title: commonCardData.heading,
            coinsValue: commonCardData.coins,
            type:commonCardData.cardNames
          );
        }
        //todo add in menulist.json when implying this.
      case "Buddy_Approval":
        {
          return TricycleEarnCard(
            imageUrl: commonCardData.imageUrl,
            moneyVal: commonCardData.moneyVal,
            quote: commonCardData.quote,
            title: commonCardData.heading,
            coinsValue: commonCardData.coins,
            type: commonCardData.cardNames
          );
        }

      default:
        {
          return Container();
        }
    }
  }
}
