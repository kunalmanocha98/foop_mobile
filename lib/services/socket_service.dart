
import 'package:oho_works_app/messenger_module/entities/user_status.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  // final NavigationService _navigationService = locator<NavigationService>();
  IO.Socket socket;
String personId;
  final db = DatabaseHelper.instance;
  SocketService(){
    print('in the constructor');
    setupConnection();
  }

  // ignore: missing_return
  Future<IO.Socket> setupConnection() async {
    socket = IO.io(Config.BASE_URL_MESSENGER, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    personId=  sharedPreferences.getInt("userId").toString();
    // socket.connect();
    socket.onConnect((_) {
      print("cobnected+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      UserStatusPayload userStatusPayload = UserStatusPayload();
      userStatusPayload.isOnline = true;
      userStatusPayload.personId = personId;
      socket.emit('user_status', userStatusPayload);
    /*  joinChat(sharedPreferences.getInt("userId").toString());*/
      return socket;
    });
    socket.onDisconnect((_) {
      print(
          "disconnected+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    });
    socket.onError((_) {
      print(
          "errrorr+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    });
  }

/*  joinChat(dynamic personId) {
    print("joining+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    socket.emit('join', personId);
  }*/
/*  userStatus(dynamic payload) async {
    UserStatusPayload userStatusPayload = UserStatusPayload.fromJson(payload);
    ConversationItemDb item= await db.getConversationWithOnlineStatus(userStatusPayload.personId);
    if(item!=null && item.isOnline==0)
      joinChat(personId);
    await db.updateStatus(userStatusPayload.personId, userStatusPayload.isOnline?1:0);
  }*/

  IO.Socket getSocket() {
    return socket;
  }
}
