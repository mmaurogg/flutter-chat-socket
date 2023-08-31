import 'package:http/http.dart' as http;

import 'package:chat/models/user.dart';
import 'package:chat/models/users_response.dart';
import 'package:chat/services/auth_service.dart';

import 'package:chat/global/environment.dart';

class UsersService {
  Future<List<User>?> getUsers() async {
    try {
      final token = await AuthService.getToken() ?? '';
      final resp =
          await http.get(Uri.parse('${Environment.apiUrl}/users'), headers: {
        'Content-Type': 'application/json',
        'token': token.toString(),
      });

      UsersResponse usersResponse = usersResponseFromJson(resp.body);

      return usersResponse.users;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
