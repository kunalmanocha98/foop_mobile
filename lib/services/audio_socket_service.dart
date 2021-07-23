
import 'package:oho_works_app/utils/config.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AudioSocketService {
  IO.Socket? socket;
  AudioSocketService(){
    print('in the constructor');
    setupConnection();
  }

  // ignore: missing_return
  setupConnection()  {
    print('trying to connect');
    socket = IO.io(Config.BASE_URL_AUDIO, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    // socket.connect();
    socket!.onConnect((_) {
      print("connected+++++++++++++++++++++++++++++++++++Audio++++++++++++++++++++++++++++++++++++");
      return socket;
    });
    socket!.onDisconnect((_) {
      print(
          "disconnected++++++++++++++++++++++++++++++++Audio++++++++++++++++++++++++++++++++++++++++++");
    });
    socket!.onError((_) {
      print(
          "errrorr+++++++++++++++++++++++++++++++++++Audio++++++++++++++++++++++++++++++++++++++++++");
    });
  }

  IO.Socket? getSocket() {
    return socket;
  }
}
