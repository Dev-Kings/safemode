import 'package:flutter/material.dart';
import 'package:qadata/apitestdb/model/data_model.dart';
import 'package:qadata/apitestdb/pages/data_form_page.dart';
import 'package:qadata/apitestdb/pages/tabview/data_builder_test.dart';
import 'package:qadata/apitestdb/provider/db/db_provider.dart';
import 'package:qadata/dataentrytests/common_widgets/crop_builder.dart';
import 'package:qadata/dataentrytests/models/crop.dart';
// import 'package:qadata/dataentrytests/models/variety.dart';
// import 'package:qadata/dataentrytests/pages/variety_form_page.dart';
// import 'package:qadata/dataentrytests/services/database_service.dart';
import 'dart:developer' as devtools;

import 'package:qadata/dataentrytests/services/database_service.dart';

class QADataHomePageTest extends StatefulWidget {
  const QADataHomePageTest({Key? key}) : super(key: key);

  @override
  State<QADataHomePageTest> createState() => _QADataHomePageTestState();
}

class _QADataHomePageTestState extends State<QADataHomePageTest> {
  var isLoading = false;
  final DBProvider _databaseProviderService = DBProvider();
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Data>> _getData() async {
    return await _databaseProviderService.getAllData();
  }

  Future<List<Crop>> _getCrops() async {
    return await _databaseService.crops();
  }

  Future<void> _onDataDelete(Data data) async {
    await _databaseProviderService.deleteData(data.id!);
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
                child: Text('Data'),
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
            DataBuilder(
              future: _getData(),
              onEdit: (value) {
                {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => DataFormPage(data: value),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => setState(() {}));
                }
              },
              onDelete: _onDataDelete,
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
                Navigator.of(context)
                    .push(MaterialPageRoute(
                      builder: (_) => const DataFormPage(),
                      fullscreenDialog: true,
                    ))
                    .then((_) => setState(() => {}));
              },
              heroTag: 'addData',
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
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
