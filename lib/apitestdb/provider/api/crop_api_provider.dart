import 'package:dio/dio.dart';
import 'package:qadata/apitestdb/model/crop_model.dart';
import 'dart:developer' as devtools;
import 'package:qadata/apitestdb/provider/db/db_provider.dart';

class CropApiProvider {
  Future<List<CropModel?>> getAllCrops() async {
    var url = "http://quality-assurance-app.herokuapp.com/api/v1/crops";
    Response response = await Dio().get(url);

    return (response.data as List).map((crop) {
      devtools.log('Inserting $crop');
      DBProvider.db.createCrop(CropModel.fromJson(crop));
    }).toList();
  }
}
