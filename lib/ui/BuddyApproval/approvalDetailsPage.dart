import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/models/buddyApprovalModels/buddyListModels.dart';
import 'package:oho_works_app/ui/BuddyApproval/appRequestCard.dart';
import 'package:oho_works_app/ui/BuddyApproval/appquestionairecard.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/material.dart';

class ApprovalDetailsPage extends StatefulWidget {
   final RequestListItem? data;
   final int? index;
   final Null Function()? callbackPicker;


   ApprovalDetailsPage(
       {Key? key,
         this.data,this.index,this.callbackPicker})
       : super(key: key);
  @override
  ApprovalDetailsPageState createState() => ApprovalDetailsPageState(data:data,callbackPicker:callbackPicker);
}

class ApprovalDetailsPageState extends State<ApprovalDetailsPage> {
   RequestListItem? data;
    Null Function()? callbackPicker;
   ApprovalDetailsPageState({this.data,this.callbackPicker});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: OhoAppBar().getCustomAppBar(
          context,
          appBarTitle: AppLocalizations.of(context)!.translate('buddy_approval'),
          onBackButtonPress: (){
            Navigator.pop(context);
          },
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(children: [
              appRequestCard(
                imageUrl: data!.profileImage,
                onButtonClickCallback: null,
                buttonTitle: '',
                isContentVisible: false,
                isDetailPage: true,
              ),
              appQuestionnaireCard(
                data: data,
                callback: (bool ?value){
                  Map<String,int?> map = {
                    "value": value!?1:0,
                    "index":widget.index
                  };
                  if(callbackPicker!=null)
                  {callbackPicker!();}
                  Navigator.pop(context,map);
                }
              ),
            ],),
          )
        ),
      ),
    );
  }
}
