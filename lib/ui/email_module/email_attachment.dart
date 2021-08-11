import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oho_works_app/models/email_module/email_list_modules.dart';

class EmailAttachmentWidget extends StatefulWidget{
  final List<Attachments>? attachments;
  final bool isDetailPage;
  final Function(int)? downLoadCallback;
  EmailAttachmentWidget({Key? key,this.attachments,this.isDetailPage= false,this.downLoadCallback}):super(key: key);
  @override
  EmailAttachmentWidgetState createState() => EmailAttachmentWidgetState();
}

class EmailAttachmentWidgetState extends State<EmailAttachmentWidget>{
  List<File> fileList=[];
  @override
  Widget build(BuildContext context) {
    if(widget.isDetailPage){
      return widget.attachments!.length == 0 ? Container() : Container(
        height: 56,
        child: ListView.builder(
          itemCount: widget.attachments!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.all(8),
              width: 190,
              child: Chip(
                label: Text(widget.attachments![index].filename!,
                  overflow: TextOverflow.ellipsis,),
                avatar: Icon(Icons.attach_file_rounded, size: 16,),
                onDeleted: (){widget.downLoadCallback!(index);},
                deleteIcon: Icon(Icons.download_rounded, size: 20,),
              ),
            );
          },
        ),
      );
    }else {
      return fileList.length == 0 ? Container() : Container(
        height: 72,
        child: ListView.builder(
          itemCount: fileList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.all(8),
              width: 200,
              child: Chip(
                label: Text(fileList[index].path.split('/')[fileList[index].path
                    .split('/')
                    .length - 1],
                  overflow: TextOverflow.ellipsis,),
                avatar: Icon(Icons.attach_file_rounded, size: 16,),
                onDeleted: () {
                  removeFile(index);
                },
                deleteIcon: Icon(Icons.close, size: 16,),
              ),
            );
          },
        ),
      );
    }
  }

  void addFile(File file){
    setState(() {
      fileList.add(file);
    });
  }

  void removeFile(int index) {
    setState(() {
      fileList.removeAt(index);
    });
  }

}
