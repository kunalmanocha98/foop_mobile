import 'dart:convert';

import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/default_styles.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:url_launcher/url_launcher.dart';

class TricycleHtmlViewer extends StatefulWidget {
  final String sourceString;
  final bool isDetailPage;
  final bool isNewsPage;
  final bool isNoticeCard;
  final String searchHighlightWord;
  final bool isEmail;

  TricycleHtmlViewer(
      {this.sourceString,
        this.isNewsPage,
        this.isDetailPage,
        this.searchHighlightWord,
        this.isEmail = false,
        this.isNoticeCard});

  @override
  TricycleHtmlViewerState createState() => TricycleHtmlViewerState();
}

class TricycleHtmlViewerState extends State<TricycleHtmlViewer> {
  // bool isLoading= true;
  bool showHtmlViewer = false;
  QuillController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      Document doc = Document.fromJson(jsonDecode(widget.sourceString));
      _controller = QuillController(
          document: doc, selection: TextSelection.collapsed(offset: 0));

      if(widget.searchHighlightWord!=null) {
        var string = _controller.plainTextEditingValue.text;
        var regex = RegExp(widget.searchHighlightWord,caseSensitive: false);
        var matches = regex.allMatches(string)
            .toList(); /*string.allMatches("highly").toList();*/
        for (Match match in matches) {
          _controller.formatText(match.start, match.end - match.start,
              BackgroundAttribute("#FFFF00"));
        }
      }

      if (!widget.isDetailPage) {
        int ln = _controller.document.toPlainText().length;
        if (widget.isNoticeCard != null && widget.isNoticeCard) {
          if (ln > 100) {
            _controller.document.delete(99, ln - 100);
            _controller.document.insert(_controller.document
                .toPlainText()
                .length - 1, "...");
          }
        } else {
          if (!(widget.isNewsPage != null && widget.isNewsPage)) {
            if (ln > 165) {
              _controller.document.delete(164, ln - 165);
              _controller.document
                  .insert(_controller.document.toPlainText().length - 1, "...");
            }
          }
        }
      }
    } catch (onError) {
      showHtmlViewer = true;
      print(onError);
    }
    // return !isLoading?Builder(
    //   builder: (BuildContext context) {
    return showHtmlViewer ? getHtmlViewer() : AbsorbPointer(child: getQuillViewer());
    // },
    // ):PreloadingViewParagraph();
  }

  Widget getQuillViewer() {
    var defaultStyles = DefaultStyles.getInstance(context);

    var editor = QuillEditor(
      // maxHeight:
      // (widget.isNoticeCard != null && widget.isNoticeCard) ? 150 : null,
        controller: _controller,

        focusNode: FocusNode(),
        scrollController: ScrollController(),
        scrollable: (widget.isNoticeCard != null && widget.isNoticeCard)
            ? true
            : false,
        //   scrollable: true,
        enableInteractiveSelection: false,
        padding: EdgeInsets.only(left: 8),
        autoFocus: false,
        readOnly: true,
        expands: false,
        onLaunchUrl: _launchURL,
        customStyles: defaultStyles.merge(DefaultStyles(
            quote: getCustomBlockStyle(defaultStyles.quote),
            indent: getCustomBlockStyle(defaultStyles.indent),
            align: getCustomBlockStyle(defaultStyles.align),
            h1: getCustomBlockStyle(defaultStyles.h1),
            h2: getCustomBlockStyle(defaultStyles.h2),
            h3: getCustomBlockStyle(defaultStyles.h3),
            code: getCustomBlockStyle(defaultStyles.code),
            lists: getCustomBlockStyle(defaultStyles.lists),
            paragraph: DefaultTextBlockStyle(
                defaultStyles.paragraph.style.copyWith(
                    fontSize: 20, color: HexColor(AppColors.appColorBlack65)),
                defaultStyles.paragraph.verticalSpacing,
                defaultStyles.paragraph.lineSpacing,
                defaultStyles.paragraph.decoration))));
    return (widget.isNoticeCard != null && widget.isNoticeCard)?editor:editor;

  }

  Widget getHtmlViewer() {
    return SizedBox(
      child: Html(
        data: getData(widget.sourceString),

        // onLinkTap: (url) {
        //   _launchURL(url);
        // },
        style: {
          "body": Style(
              fontSize: FontSize(20.0),
              color: HexColor(AppColors.appColorBlack65)),
        },
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getData(String meta) {
    if (meta != null) {
      if (!widget.isDetailPage) {
        if (widget.isNewsPage != null && widget.isNewsPage) {
          // if (meta.length > 350) {
          //   return meta.substring(0, 350) + '....';
          // } else {
          return meta;
          // }
        } else {
          if (widget.isNoticeCard != null && widget.isNoticeCard) {
            if (meta.length > 100) {
              // print("notice eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
              // return meta.substring(0, 100) + '....';
              return meta;
            } else {
              return meta;
            }
          } else {
            if (meta.length > 165) {
              if(widget.isEmail){
                return meta.substring(0, 100) + '....';
              }else{
                return meta.substring(0, 165) + '....';
              }
            } else {
              return meta;
            }
          }
        }
      } else {
        return meta;
      }
    } else {
      return '';
    }
  }

  DefaultTextBlockStyle getCustomBlockStyle(DefaultTextBlockStyle defaultStyles){
    return DefaultTextBlockStyle(
        defaultStyles.style.copyWith(color: HexColor(AppColors.appColorBlack65)),
        defaultStyles.verticalSpacing,
        defaultStyles.lineSpacing,
        defaultStyles.decoration);
  }
}



