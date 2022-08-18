import 'dart:convert';

List<CropSpecs> cropFromJson(String str) => List<CropSpecs>.from(
    json.decode(str).map((x) => CropSpecs.fromJson(x)));

String cropToJson(List<CropSpecs> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CropSpecs {
  int id;
  String cropName;
  String specsName;

  CropSpecs({
    required this.id,
    required this.cropName,
    required this.specsName
  });

  factory CropSpecs.fromJson(Map<String, dynamic> json) => CropSpecs(
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
