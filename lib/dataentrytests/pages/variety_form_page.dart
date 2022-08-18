import 'package:flutter/material.dart';
import 'package:qadata/dataentrytests/common_widgets/crop_selector.dart';
import 'package:qadata/dataentrytests/models/crop.dart';
import 'package:qadata/dataentrytests/models/variety.dart';
import 'package:qadata/dataentrytests/services/database_service.dart';

class VarietyFormPage extends StatefulWidget {
  const VarietyFormPage({Key? key, this.variety}) : super(key: key);
  final Variety? variety;

  @override
  State<VarietyFormPage> createState() => _VarietyFormPageState();
}

class _VarietyFormPageState extends State<VarietyFormPage> {
  final TextEditingController _varietyCodeController = TextEditingController();
  final TextEditingController _varietyNameController = TextEditingController();

  static final List<Crop> _crops = [];

  final DatabaseService _databaseService = DatabaseService();

  int _selectedCrop = 0;

  @override
  void initState() {
    super.initState();
    if (widget.variety != null) {
      _varietyCodeController.text = widget.variety!.varietyCode;
      _varietyNameController.text = widget.variety!.varietyName;
    }
  }

  Future<List<Crop>> _getCrops() async {
    final crops = await _databaseService.crops();
    if (_crops.isEmpty) _crops.addAll(crops);
    if (widget.variety != null) {
      _selectedCrop = _crops.indexWhere((e) => e.id == widget.variety!.cropId);
    }
    return _crops;
  }

  Future<void> _onSave() async {
    final varietyCode = _varietyCodeController.text;
    final varietyName = _varietyNameController.text;
    final crop = _crops[_selectedCrop];

    // Add save code here
    widget.variety == null
        ? await _databaseService.insertVariety(
            Variety(
                cropId: crop.id!,
                varietyCode: varietyCode,
                varietyName: varietyName),
          )
        : await _databaseService.updateVariety(
            Variety(
              id: widget.variety!.id,
              cropId: crop.id!,
              varietyCode: varietyCode,
              varietyName: varietyName,
            ),
          );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Variety Record'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _varietyCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter code of the variety here',
              ),
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: _varietyNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter name of the variety here',
              ),
            ),
            const SizedBox(height: 24.0),
            // Crop Selector
            FutureBuilder<List<Crop>>(
              future: _getCrops(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading crops...");
                }
                return CropSelector(
                  crops: _crops.map((e) => e.cropName).toList(),
                  selectedIndex: _selectedCrop,
                  onChanged: (value) {
                    setState(() {
                      _selectedCrop = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: const Text(
                  'Save the Variety data',
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
