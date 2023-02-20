import 'package:socket_io_client/socket_io_client.dart' as io;

class AppSocketIo {
  late io.Socket socket;

  AppSocketIo() {
    socket = io.io('http://localhost:8082', <String, dynamic>{
      'transports': ['websocket'],
    });
  }
}
