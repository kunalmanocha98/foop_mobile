
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CustomWebView extends StatefulWidget {
  final String? selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}
class _CustomWebViewState extends State<CustomWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();


  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endparam = params[1].split("&");
    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: WebviewScaffold(
          url: widget.selectedUrl!,
          ignoreSSLErrors: true,
          withZoom: true,
          withLocalStorage: true,
          hidden: true,

          initialChild: Container(
          child: const Center(
          child: CircularProgressIndicator(),
      )),

          appBar: OhoAppBar().getCustomAppBar(
              context,
              appBarTitle: getTitle(),
              onBackButtonPress: (){
                Navigator.of(context).pop(true);
              })
      ),
    );
  }

  String getTitle() {
    return  Uri.parse(widget.selectedUrl!).host;
  }
}
