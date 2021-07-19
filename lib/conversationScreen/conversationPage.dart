/*
import 'dart:convert';

import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';

// ignore: must_be_immutable
class ConversationPage extends StatelessWidget {
  final String apiUrl = "http://test.tricycle.group/api/members/";
  TextStyleElements styleElements;
  // ignore: missing_return
  Future<List<dynamic>> fetchUsers() async {
    print("Starting");
    var result = await http.get(apiUrl, headers: {
      'Authorization': 'Token 2d1cbbe6a8369c8c9059dd179af0a3bd23cd710b'
    });
    print("API Calling");
    print(json.decode(result.body));
    // return json.decode(result.body);
    // if (result.statusCode==200){
    //   return json.decode(result.body) as List;
    // } else {
    //   throw Exception('Failed to load users')
    // }
  }

  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff3ff2f2),
      appBar: CustomAppBar(
          height: 72,
          child: Container(
            child: Row(
              children: <Widget>[
                new Flexible(
                    child: Container(
                        margin:
                            const EdgeInsets.only(top: 25, left: 16, right: 16),
                        width: 40,
                        height: 40,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new CachedNetworkImageProvider(
                                    "https://i.imgur.com/BoN9kdC.png"))))),
                new Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(top: 35, right: 16),
                    child: Column(children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "Savil Mehra",
                            textAlign: TextAlign.start,
                            style: styleElements.subtitle2ThemeScalable(context),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "online",
                            textAlign: TextAlign.start,
                            style: styleElements.captionThemeScalable(context),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          )),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
            future: fetchUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // print(_name(snapshot.data[0]));
                return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0 || index == 4 || index == 2) {
                        return Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: 0.7,
                              child: Card(
                                color: HexColor(AppColors.appColorWhite),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              child: Text(
                                                AppLocalizations.of(context).translate('received_msg'),
                                              ),
                                              margin: const EdgeInsets.all(8),
                                              width: 200.0,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                            ),
                                          )
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          child: Text(
                                            "16:55",
                                            style: styleElements.captionThemeScalable(context),
                                          ),
                                          margin: EdgeInsets.only(right: 8),
                                        ),
                                      )
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                  margin: EdgeInsets.only(bottom: 10.0),
                                ),
                              ),
                            ));
                      } else {
                        return Align(
                            alignment: Alignment.centerRight,
                            child: FractionallySizedBox(
                              widthFactor: 0.7,
                              child: Card(
                                color: Color(0xFFFFEBEE),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              child: AppLocalizations.of(context).translate('received_msg'),
                                              ),
                                              margin: const EdgeInsets.all(8),
                                              width: 200.0,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                            ),
                                          )
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          child: Text(
                                            "12:55",
                                            style: styleElements.captionThemeScalable(context),
                                          ),
                                          margin: EdgeInsets.only(right: 8),
                                        ),
                                      )
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                  margin: EdgeInsets.only(bottom: 10.0),
                                ),
                              ),
                            ));
                      }
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;

  CustomAppBar({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Color(0xFFECEFF1),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
*/
