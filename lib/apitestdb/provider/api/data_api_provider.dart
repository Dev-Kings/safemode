import 'package:dio/dio.dart';
import 'package:qadata/apitestdb/model/data_model.dart';
import 'package:qadata/apitestdb/provider/db/db_provider.dart';
import 'dart:developer' as devtools;

class DataApiProvider {

  Future<List<Data?>> getAllData() async {
    var url = "http://quality-assurance-app.herokuapp.com/api/v1/raw-data";

    Response response = await Dio().get('$url/20');
    return (response.data as List).map((data) {
      devtools.log('Inserting $data');
      DBProvider.db.createData(Data.fromJson(data));
    }).toList();
  }
}
