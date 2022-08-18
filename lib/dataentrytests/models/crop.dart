import 'dart:convert';

class Crop {
  final int? id;
  final String cropName;

  Crop({
    this.id,
    required this.cropName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'crop_name': cropName,
    };
  }

  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
      id: map['id']?.toInt() ?? 0,
      cropName: map['crop_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory Crop.fromJson(String source) => Crop.fromMap(json.decode(source));

  @override
  String toString() => 'Crop(id: $id, crop_name: $cropName)';
}
