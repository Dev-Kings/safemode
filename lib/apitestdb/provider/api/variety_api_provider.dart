import 'package:dio/dio.dart';
import 'package:qadata/apitestdb/model/variety_model.dart';
import 'package:qadata/apitestdb/provider/db/db_provider.dart';
import 'dart:developer' as devtools;

class VarietyApiProvider {
  Future<List<VarietyModel?>> getAllVarieties() async {
    var url = "http://quality-assurance-app.herokuapp.com/api/v1/varieties";
    Response response = await Dio().get(url);

    return (response.data as List).map((variety) {
      devtools.log('Inserting $variety');
      DBProvider.db.createVariety(VarietyModel.fromJson(variety));
    }).toList();
  }
}
