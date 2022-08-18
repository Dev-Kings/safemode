import 'dart:convert';

List<VarietyModel> varietyFromJson(String source) => List<VarietyModel>.from(
    json.decode(source).map((x) => VarietyModel.fromJson(x)));

String varietyToJson(List<VarietyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VarietyModel {
  int id;
  int cropId;
  String cropName;
  String varietyCode;
  String varietyName;

  VarietyModel({
    required this.id,
    required this.cropId,
    required this.cropName,
    required this.varietyCode,
    required this.varietyName,
  });

  factory VarietyModel.fromJson(Map<String, dynamic> json) => VarietyModel(
        id: json['id'],
        cropId: json['crop_id'],
        cropName: json['crop_name'],
        varietyCode: json['variety_code'],
        varietyName: json['variety_name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'crop_id': cropId,
        'crop_name': cropName,
        'variety_code': varietyCode,
        'variety_name': varietyName,
      };
}
