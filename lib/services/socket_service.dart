import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

//TODO: cambiar ChangeNotifier por Streams
class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService() {
    connect();
  }

  connect() async {
    final token = await AuthService.getToken();

    // Dart client
    _socket = IO.io(
      Environment.socketUrl,
      IO.OptionBuilder().setTransports(['websocket']).setAuth({'token': token})
          //.setExtraHeaders({'token': token})
          .build(),
    );

    _socket.onConnect((_) {
      print('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  disconnect() {
    _socket.disconnect();
  }
}
