import 'package:flutter/material.dart';
import 'package:qadata/apitestdb/provider/api/crop_api_provider.dart';
import 'package:qadata/apitestdb/provider/api/variety_api_provider.dart';
import 'package:qadata/apitestdb/provider/db/db_provider.dart';
import 'package:qadata/dataentrytests/common_widgets/crop_builder.dart';
import 'package:qadata/dataentrytests/common_widgets/variety_builder.dart';
import 'package:qadata/dataentrytests/models/crop.dart';
import 'package:qadata/dataentrytests/models/variety.dart';
import 'package:qadata/dataentrytests/pages/variety_form_page.dart';
import 'package:qadata/dataentrytests/services/database_service.dart';
import 'dart:developer' as devtools;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Variety>> _getVarieties() async {
    return await _databaseService.varieties();
  }

  Future<List<Crop>> _getCrops() async {
    return await _databaseService.crops();
  }

  Future<void> _onVarietyDelete(Variety variety) async {
    await _databaseService.deleteVariety(variety.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Cached Data'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Varieties'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Crops'),
              ),
            ],
          ),
          actions: <Widget>[
           Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _deleteCropData();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _deleteVarietyData();
              },
            ),
          ),
        ],
        ),
        body: TabBarView(
          children: [
            VarietyBuilder(
              future: _getVarieties(),
              onEdit: (value) {
                {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => VarietyFormPage(variety: value),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => setState(() {}));
                }
              },
              onDelete: _onVarietyDelete,
            ),
            CropBuilder(
              future: _getCrops(),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                _loadCropFromApi();
              },
              heroTag: 'addCrop',
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 12.0),
            FloatingActionButton(
              onPressed: () {
                _loadVarietyFromApi();
              },
              heroTag: 'addVariety',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  _loadCropFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = CropApiProvider();
    await apiProvider.getAllCrops();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

   _loadVarietyFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = VarietyApiProvider();
    await apiProvider.getAllVarieties();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteCropData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllCrops();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    devtools.log('All crops deleted');
  }

    _deleteVarietyData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllVarieties();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    devtools.log('All varieties deleted');
  }
}
