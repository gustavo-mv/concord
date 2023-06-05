import 'dart:async';
import 'package:concord/model/chat.dart';
import 'package:concord/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static late StreamController<Chat> _socketResponse;
  static late StreamController<List<String>> _userResponse;
  static late io.Socket _socket;
  static String _userName = '';

  static String? get userId => _socket.id;

  static Stream<Chat> get getResponse =>
      _socketResponse.stream.asBroadcastStream();
  static Stream<List<String>> get userResponse =>
      _userResponse.stream.asBroadcastStream();

  static void setUserName(String name) {
    _userName = name;
  }

  static void sendMessage(String message) {
    _socket.emit(
        'message',
        Chat(
          userId: userId,
          userName: _userName,
          message: message,
          time: DateTime.now().toString(),
        ));
  }

  static void connectAndListen() {
    _socketResponse = StreamController<Chat>();
    _userResponse = StreamController<List<String>>();
    _socket = io.io(
        serverUrl,
        io.OptionBuilder()
            .setTransports(['websocket']) 
            .disableAutoConnect()
            .setQuery({'userName': _userName})
            .build());

    _socket.connect();

    _socket.on('message', (data) {
      _socketResponse.sink.add(Chat.fromRawJson(data));
    });

    _socket.on('users', (data) {
      var users = (data as List<dynamic>).map((e) => e.toString()).toList();
      _userResponse.sink.add(users);
    });
  }

  static void dispose() {
    _socket.dispose();
    _socket.destroy();
    _socket.close();
    _socket.disconnect();
    _socketResponse.close();
    _userResponse.close();
  }
}
