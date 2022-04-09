import 'package:example_app/model/user_model.dart';
import 'package:get/get.dart';

class ApiServices extends GetConnect {
  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) {
    return super.get(url);
  }
}

class ApiHandler extends GetxController {
  List<UserModel?> listOfUser = [];
  Future getUser() async {
    final Response response =
        await ApiServices().get('https://jsonplaceholder.typicode.com/users');
    if (response.statusCode == 200) {
      // final data = jsonDecode();
      try {
        for (var element in response.body) {
          print(element);
          listOfUser.add(UserModel.fromJson(element));
          update();
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
