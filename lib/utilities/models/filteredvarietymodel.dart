class FilteredVariety {
  final int id;
  final int cropId;
  final String cropName;
  final String varietyCode;
  final String varietyName;

  FilteredVariety({
    required this.id,
    required this.cropId,
    required this.cropName,
    required this.varietyCode,
    required this.varietyName,
  });

  factory FilteredVariety.fromJson(Map<String, dynamic> json) {
    return FilteredVariety(
        id: json['id'],
        cropId: json['crop_id'],
        cropName: json['crop_name'],
        varietyCode: json['variety_code'],
        varietyName: json['variety_name']
        );
  }
}
