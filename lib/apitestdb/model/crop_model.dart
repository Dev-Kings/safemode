import 'dart:convert';

List<CropModel> cropFromJson(String str) =>
    List<CropModel>.from(json.decode(str).map((x) => CropModel.fromJson(x)));

String cropToJson(List<CropModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CropModel {
  int id;
  String cropName;

  CropModel({
    required this.id,
    required this.cropName,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) => CropModel(
        id: json['id'],
        cropName: json['crop_name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'crop_name': cropName,
      };
}
