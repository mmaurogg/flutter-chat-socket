import 'package:chat/models/messages_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat/global/environment.dart';
import 'package:chat/models/user.dart';

class ChatService with ChangeNotifier {
  User? userPara;

  Future<List<Message>> getChat(String usuarioID) async {
    final token = await AuthService.getToken() ?? '';
    final resp = await http
        .get(Uri.parse('${Environment.apiUrl}/message/$usuarioID'), headers: {
      'Content-Type': 'application/json',
      'token': token,
    });

    final messageResponse = messagesResponseFromJson(resp.body);

    return messageResponse.messages;
  }
}
