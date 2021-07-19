/*
import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/models/post/keywordsList.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';

class TestMentionsPage extends StatefulWidget{
  @override
  _TestMentionsPage createState() => _TestMentionsPage();

}

class _TestMentionsPage extends State<TestMentionsPage>{
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  // bool _showList = false;
  List<Map<String,dynamic>> _users = [];

  @override
  void initState() {
    print(key.currentState?.controller?.markupText);
    key.currentState?.controller?.addListener(() {
      print(key.currentState?.controller?.text);
    });

    // Timer(Duration(seconds: 3), () {
    //   setState(() {
    //     _users = [
    //       ..._users,
    //       {
    //         'id': '45as1a4df1',
    //         'display': 'JayZ',
    //         'full_name': 'JayZ',
    //         'photo':
    //         'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
    //       },
    //     ];
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var arr = <Map<String, dynamic>>[];
    return Scaffold(
      appBar: TricycleAppBar().getCustomAppBar(context, appBarTitle: 'Mentions Test', onBackButtonPress: (){Navigator.pop(context);}),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TricycleElevatedButton(
            child: Text('Get Text'),
            onPressed: () {
              print(key.currentState.controller.markupText);
            },
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            height: 200,
            padding: EdgeInsets.only(bottom: 10.0),
            width: MediaQuery.of(context).size.width,
            child:
            FlutterMentions(
              key: key,
              decoration: InputDecoration(hintText: 'Enter here...'),
              suggestionPosition: SuggestionPosition.Top,
              onMarkupChanged: (val) {
                print(val);
              },
              onSuggestionVisibleChanged: (val) {
                setState(() {
                  // _showList = val;
                });
              },
              onSearchChanged: (
                  trigger,
                  value,
                  ) {
                fetchData(value);
                print('again | $trigger | $value ');
              },
              hideSuggestionList: false,
              onEditingComplete: () {
                key.currentState.controller.clear();
                // key.currentState.controller.text = '';
              },
              minLines: 1,
              maxLines: 4,
              mentions: [
                Mention(
                    trigger: r'@',
                    style: TextStyle(
                      color: HexColor(AppColors.appMainColor),
                    ),
                    matchAll: false,
                    data: _users,
                    suggestionBuilder: (data) {
                      return Container(
                        color: HexColor(AppColors.appColorWhite),
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            // CircleAvatar(
                            //   backgroundImage: CachedNetworkImageProvider(
                            //     data['photo'],
                            //   ),
                            // ),
                            // SizedBox(
                            //   width: 20.0,
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // Text(data['id']),
                                Text('@${data['keyword']}'),
                              ],
                            )
                          ],
                        ),
                      );
                    }
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void fetchData(String value) {
    KeywordListRequest request = KeywordListRequest();
    request.searchVal = value;
    request.pageNumber = 1;
    request.pageSize =5;
    var data = jsonEncode(request);
    Calls().call(data, context, Config.KEYWORDS_LIST).then((value){
      var res = KeywordListResponse.fromJson(value);
      if(res.statusCode == Strings.success_code){
        setState(() {
          _users  = res.toJson()['rows'];
        });
      }
    });
  }
}*/
