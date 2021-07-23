import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:flutter/material.dart';


class TricycleEditor extends StatefulWidget {
  @override
  _TricycleEditorState createState() => _TricycleEditorState();
}

class _TricycleEditorState extends State<TricycleEditor> {

  // @override
  // void initState() {
  //   super.initState();
  //   // Here we must load the document and pass it to Zefyr controller.
  //   final document = _loadDocument();
  //   _controller = ZefyrController(document);
  //   _focusNode = FocusNode();
  // }

  @override
  Widget build(BuildContext context) {
    // styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(context,
            appBarTitle: AppLocalizations.of(context)!.translate('post_create'),
            onBackButtonPress: () {
              Navigator.pop(context);
            }),
        // body: ZefyrScaffold(
        //   child: ZefyrEditor(
        //       padding: EdgeInsets.all(16),
        //       controller: _controller,
        //       focusNode: _focusNode),
        // ),
      ),
    );
  }
  // NotusDocument _loadDocument() {
  //   // For simplicity we hardcode a simple document with one line of text
  //   // saying "Zefyr Quick Start".
  //   // (Note that delta must always end with newline.)
  //   final Delta delta = Delta()..insert("Zefyr Quick Start\n");
  //   return NotusDocument.fromDelta(delta);
  // }
}
