import 'dart:convert';

class Variety {
  final int? id;
  final int cropId;
  final String varietyCode;
  final String varietyName;

  Variety({
    this.id,
    required this.cropId,
    required this.varietyCode,
    required this.varietyName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'crop_id': cropId,
      'variety_code': varietyCode,
      'variety_name': varietyName,
    };
  }

  factory Variety.fromMap(Map<String, dynamic> map) {
    return Variety(
      id: map['id']?.toInt() ?? 0,
      cropId: map['crop_id']?.toInt() ?? 0,
      varietyCode: map['variety_code'] ?? '',
      varietyName: map['variety_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory Variety.fromJson(String source) =>
      Variety.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Variety(id: $id, crop_id: $cropId, variety_code: $varietyCode, variety_name: $varietyName)';
  }
}
