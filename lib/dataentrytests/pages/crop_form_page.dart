import 'package:flutter/material.dart';
import 'package:qadata/dataentrytests/models/crop.dart';
import 'package:qadata/dataentrytests/services/database_service.dart';

class CropFormPage extends StatefulWidget {
  const CropFormPage({Key? key}) : super(key: key);

  @override
  State<CropFormPage> createState() => _CropFormPageState();
}

class _CropFormPageState extends State<CropFormPage> {
  final TextEditingController _cropNameController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  Future<void> _onSave() async {
    final cropName = _cropNameController.text;

    await _databaseService.insertCrop(Crop(cropName: cropName));

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new crop'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cropNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter name of the crop here',
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: const Text(
                  'Save the Crop',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
