// import 'dart:async';
// import 'dart:io';
// import 'dart:isolate';
// import 'dart:ui';
//
// import 'package:oho_works_app/ui/dialogs/DownloadProgressDialog.dart';
// import 'package:oho_works_app/utils/config.dart';
// import 'package:oho_works_app/utils/toast_builder.dart';
// import 'package:oho_works_app/utils/utility_class.dart';
// import 'package:ext_storage/ext_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// const debug = true;
//
// class appDownloadButton extends StatefulWidget
//     with WidgetsBindingObserver {
//   final TargetPlatform platform;
//   final List<String> listOfLinks;
//   final bool isDarkTheme;
//
//   appDownloadButton({Key key, this.title, this.isDarkTheme =false,this.platform, this.listOfLinks})
//       : super(key: key);
//   final String title;
//
//   @override
//   appDownloadButtonState createState() =>
//       new appDownloadButtonState();
// }
//
// class appDownloadButtonState extends State<appDownloadButton> {
//   List<_TaskInfo> _tasks;
//   bool _isLoading;
//   bool _permissionReady;
//   String _localPath;
//   ReceivePort _port = ReceivePort();
//   int index = 0;
//   static final String TRICYCLE_PATH = "app";
//    BuildContext sctx;
//   UploadDownloadDialog pr;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _bindBackgroundIsolate();
//     FlutterDownloader.registerCallback(downloadCallback);
//     _isLoading = true;
//     _permissionReady = false;
//     _prepare();
//   }
//
//   @override
//   void dispose() {
//     _unbindBackgroundIsolate();
//     super.dispose();
//   }
//
//   void _bindBackgroundIsolate() {
//     bool isSuccess = IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     if (!isSuccess) {
//       _unbindBackgroundIsolate();
//       _bindBackgroundIsolate();
//       return;
//     }
//     _port.listen((dynamic data) {
//       pr ??= ToastBuilder().setProgressDialogWithPercent(sctx,'Downloading File...',barrierDismissable: true);
//       print(pr!=null?pr.isShowing().toString():"null");
//       if(!pr.isShowing()){
//         pr.show();
//       }
//
//       if (debug) {
//         print('UI Isolate Callback: $data');
//       }
//       if(data[2]<100) {
//         print("********** Progress ${data[2]}***************");
//         pr.update(progress: data[2].toDouble());
//       }else{
//         print("********** Progress ${data[2]}***************");
//         print("********** Hide ${data[2]}***************");
//         pr.hide();
//       }
//
//       // if (_tasks != null && _tasks.isNotEmpty) {
//       //   final task = _tasks.firstWhere((task) => task.taskId == id);
//       //   if (task != null) {
//       //     setState(() {
//       //       task.status = status;
//       //       task.progress = progress;
//       //     });
//       //   }
//       // }
//     });
//   }
//
//   void _unbindBackgroundIsolate() {
//     if(pr!=null && pr.isShowing()) pr.hide();
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//   }
//
//     static void downloadCallback(
//        String id, DownloadTaskStatus status, int progress) {
//
//     if (debug) {
//       print('Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
//     }
//
//     final SendPort send =
//     IsolateNameServer.lookupPortByName('downloader_send_port');
//     send.send([id, status, progress]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Builder(
//           builder: (context) {
//             sctx = context;
//             return _permissionReady
//                 ? _canShow() ? _buildDownloadButton() : Container()
//                 : _buildNoPermissionWarning();
//           }
//     );
//   }
//   void changeIndex(int index){
//     setState(() {
//       print("index-$index");
//       this.index = index;
//     }); }
//
//   Widget _buildDownloadButton() => Container(
//     child: IconButton(
//       icon: Icon(Icons.download_rounded,color: widget.isDarkTheme?Colors.white:Colors.black38,),
//       onPressed: _isLoading?null:() {
//         var task = _tasks[index];
//         _requestDownload(task);
//         // if (task.status == DownloadTaskStatus.undefined) {
//         //   _requestDownload(task);
//         // } else if (task.status == DownloadTaskStatus.running) {
//         //   _pauseDownload(task);
//         // } else if (task.status == DownloadTaskStatus.paused) {
//         //   _resumeDownload(task);
//         // } else if (task.status == DownloadTaskStatus.complete) {
//         //   _delete(task);
//         // } else if (task.status == DownloadTaskStatus.failed) {
//         //   _retryDownload(task);
//         // }
//       },
//     ),
//   );
//
//   Widget _buildNoPermissionWarning() => Container(
//     child: IconButton(
//       onPressed: () {
//         _checkPermission().then((hasGranted) {
//           setState(() {
//             _permissionReady = hasGranted;
//           });
//         });
//       },
//       icon: Icon(Icons.warning_amber_rounded,color:  Colors.black38,),
//     ),
//   );
//
//   void _requestDownload(_TaskInfo task) async {
//     task.taskId = await FlutterDownloader.enqueue(
//         url: task.link,
//         savedDir: _localPath,
//         showNotification: true,
//         openFileFromNotification: true);
//   }
//
//   static  requestDownloadFromOutSide(String mediaUrl) async {
//     _TaskInfo _task = _TaskInfo(link: Config.BASE_URL+mediaUrl);
//     var findLocalPath;
//     if (Platform.isAndroid) {
//       findLocalPath = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
//     } else {
//       findLocalPath = (await getApplicationDocumentsDirectory()).path;
//     }
//     var localPathOutside = findLocalPath + Platform.pathSeparator+TRICYCLE_PATH;
//     final savedDir = Directory(localPathOutside);
//     bool hasExisted = await savedDir.exists();
//     if (!hasExisted) {
//       savedDir.create();
//     }
//     _task.taskId = await FlutterDownloader.enqueue(
//       url: _task.link,
//       savedDir: localPathOutside,
//       showNotification: true,
//       openFileFromNotification: true,
//     );
//   }
//
//
//
//
//
//
//
//
//   Future<bool> _checkPermission() async {
//     print("print permission check---checking");
//     if (Platform.isAndroid) {
//       print("print permission check---android");
//       final status = await Permission.storage.status;
//       if (status != PermissionStatus.granted) {
//         print("print permission check---will requsting");
//         final result = await Permission.storage.request();
//         if (result == PermissionStatus.granted) {
//           print("print permission check---now its granted");
//           return true;
//         }
//       } else {
//         print("print permission check---already granted");
//         return true;
//       }
//     } else {
//       print("print permission check--- not android");
//       return true;
//     }
//
//     print("print permission check---nothing checks out");
//     return false;
//   }
//
//   Future<Null> _prepare() async {
//     final tasks = await FlutterDownloader.loadTasks();
//     _tasks = [];
//
//     widget.listOfLinks.forEach((element) {
//       _tasks.add(_TaskInfo(link: Config.BASE_URL+element));
//     });
//
//     tasks?.forEach((task) {
//       for (_TaskInfo info in _tasks) {
//         if (info.link == task.url) {
//           info.taskId = task.taskId;
//           info.status = task.status;
//           info.progress = task.progress;
//         }
//       }
//     });
//
//     _permissionReady = await _checkPermission();
//
//     _localPath = (await _findLocalPath())+Platform.pathSeparator+TRICYCLE_PATH;
//     print("Local Path -------------------------------------------"+_localPath);
//     // _localPath = "/storage/emulated/0/Download/TestDownloads";
//     final savedDir = Directory(_localPath);
//     bool hasExisted = await savedDir.exists();
//     if (!hasExisted) {
//       savedDir.create();
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   Future<String> _findLocalPath() async {
//     if (Platform.isAndroid) {
//       return await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
//     } else {
//       return (await getApplicationDocumentsDirectory()).path;
//     }
//   }
//
//   _canShow() {
//     return Utility().checkFileMimeType(Utility().getExtension(context, widget.listOfLinks[index]));
//   }
//
// }
//
//
// class _TaskInfo {
//   final String link;
//
//   String taskId;
//   int progress = 0;
//   DownloadTaskStatus status = DownloadTaskStatus.undefined;
//
//   _TaskInfo({this.link});
// }