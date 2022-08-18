import 'dart:convert';

List<CropSpecsModel> cropFromJson(String str) => List<CropSpecsModel>.from(
    json.decode(str).map((x) => CropSpecsModel.fromJson(x)));

String cropToJson(List<CropSpecsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CropSpecsModel {
  int id;
  String cropName;
  String specsName;

  CropSpecsModel({
    required this.id,
    required this.cropName,
    required this.specsName
  });

  factory CropSpecsModel.fromJson(Map<String, dynamic> json) => CropSpecsModel(
        id: json['id'],
        cropName: json['crop_name'],
        specsName: json['specs_name']
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'crop_name': cropName,
        'specs_name': specsName,
      };
}
