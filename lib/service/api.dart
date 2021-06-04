import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String idUser;

  ApiService(this.idUser);

  Future<http.Response> fetchUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _apiUrl = preferences.getString('apiUrl');
    return http.get(_apiUrl + '/' + idUser);
  }
}
