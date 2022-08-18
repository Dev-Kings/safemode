class Crop {
  final int cropId;
  final String cropName;

  Crop({required this.cropId, required this.cropName});

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      cropId: json['id'],
      cropName: json['crop_name']
      );
  }
}
