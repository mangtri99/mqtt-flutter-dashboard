import 'package:http/http.dart' as http;

class ApiService {
  final String idUser;

  ApiService(this.idUser);

  Future<http.Response> fetchUser() {
    return http.get('http://35ad9c5c08e2.ngrok.io/api/user/' + idUser);
  }
}
