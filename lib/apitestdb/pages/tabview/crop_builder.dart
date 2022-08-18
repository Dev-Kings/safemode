import 'package:flutter/material.dart';
import 'package:qadata/dataentrytests/models/crop.dart';

class CropBuilder extends StatelessWidget {
  const CropBuilder({
    Key? key,
    required this.future,
  }) : super(key: key);
  final Future<List<Crop>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Crop>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final crop = snapshot.data![index];
              return _buildCropCard(crop, context, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildCropCard(Crop crop, BuildContext context, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              alignment: Alignment.center,
              child: Text(
                 "${index + 1}",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crop.cropName,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}