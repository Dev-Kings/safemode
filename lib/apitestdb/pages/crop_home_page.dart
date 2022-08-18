import 'package:flutter/material.dart';
import 'package:qadata/apitestdb/provider/api/crop_api_provider.dart';
import 'package:qadata/apitestdb/provider/db/db_provider.dart';
import 'dart:developer' as devtools;

class CropHomePage extends StatefulWidget {
  const CropHomePage({Key? key}) : super(key: key);

  @override
  State<CropHomePage> createState() => _CropHomePageState();
}

class _CropHomePageState extends State<CropHomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crops in DB'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildCropListView(),
    );
  }

  _loadFromApi() async {
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

  _deleteData() async {
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

  _buildCropListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllCrops(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 20.0),
                ),
                title: Text("Name: ${snapshot.data[index].cropName}"),
              );
            },
          );
        }
      },
    );
  }
}
