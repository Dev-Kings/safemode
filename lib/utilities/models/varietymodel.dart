class Variety {
  final int id;
  final int cropId;
  final String cropName;
  final String varietyCode;
  final String varietyName;

  Variety(
      {
      required this.id,
      required this.cropId,
      required this.cropName,
      required this.varietyCode,
      required this.varietyName,
      });

  factory Variety.fromJson(Map<String, dynamic> json) {
    return Variety(
        id: json['id'],
        cropId: json['crop_id'],
        cropName: json['crop_name'],
        varietyCode: json['variety_code'],
        varietyName: json['variety_name']);
  }
}
