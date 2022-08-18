import 'package:dio/dio.dart';
import 'package:qadata/apitestdb/model/user_model.dart';
import 'package:qadata/apitestdb/provider/db/db_provider.dart';
import 'dart:developer' as devtools;

class UserApiProvider {
  Future<List<User?>> getAllUsers() async {
    var url = "http://quality-assurance-app.herokuapp.com/api/v1/users";
    Response response = await Dio().get(url);

    return (response.data as List).map((user) {
      devtools.log('Inserting $user');
      DBProvider.db.createUser(User.fromJson(user));
    }).toList();
  }
}
