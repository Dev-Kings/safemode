import 'package:flutter/material.dart';
import 'package:qadata/dataentrytests/services/database_service.dart';
import 'package:qadata/dataentrytests/models/variety.dart';

class VarietyBuilder extends StatelessWidget {
  const VarietyBuilder({
    Key? key,
    required this.future,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);
  final Future<List<Variety>> future;
  final Function(Variety) onEdit;
  final Function(Variety) onDelete;

  Future<String> getCropName(int id) async {
    final DatabaseService databaseService = DatabaseService();
    final crop = await databaseService.crop(id);
    return crop.cropName;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Variety>>(
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
              final variety = snapshot.data![index];
              return _buildVarietyCard(variety, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildVarietyCard(Variety variety, BuildContext context) {
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
                color: Colors.grey[200],
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.filter_vintage, size: 18.0),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variety.varietyName,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  FutureBuilder<String>(
                    future: getCropName(variety.cropId),
                    builder: (context, snapshot) {
                      return Text('Crop: ${snapshot.data}');
                    },
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Variety Code: ${variety.varietyCode}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onEdit(variety),
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.edit, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onDelete(variety),
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: Icon(Icons.delete, color: Colors.red[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
