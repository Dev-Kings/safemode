import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qadata/apitestdb/model/data_model.dart';
import 'package:qadata/apitestdb/pages/qualitydataview.dart';
import 'package:qadata/apitestdb/pages/data_form_page.dart';
import 'dart:developer' as devtools;
import 'package:qadata/apitestdb/provider/db/db_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataTestHomePage extends StatefulWidget {
  const DataTestHomePage({Key? key}) : super(key: key);

  @override
  State<DataTestHomePage> createState() => _DataTestHomePageState();
}

class _DataTestHomePageState extends State<DataTestHomePage> {
  var isLoading = false;
  var qaMonitorId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data in DB - Test'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadDataFromApi();
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
                  .then((_) => setState(() {}));
            },
            heroTag: 'addData',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 12.0,
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildDataListView(),
    );
  }

  _loadDataFromApi() async {
    setState(() {
      isLoading = true;
    });

    // var apiProvider = DataApiProvider();
    // await apiProvider.getAllData();

    await getAllDataLocally();

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

    await DBProvider.db.deleteAllData();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
    devtools.log('All data deleted');
  }

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user') ?? '');

    if (user != null) {
      setState(() {
        qaMonitorId = user['id'];
      });
    }
  }

  Future<List<Data?>> getAllDataLocally() async {
    var url = "http://quality-assurance-app.herokuapp.com/api/v1/raw-data";

    Response response = await Dio().get('$url/$qaMonitorId');
    return (response.data as List).map((data) {
      devtools.log(qaMonitorId.toString());
      devtools.log('Inserting $data');
      DBProvider.db.createData(Data.fromJson(data));
    }).toList();
  }

  _buildDataListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<Data> data = snapshot.data!;
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        tileColor: Colors.grey[100],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DataView(
                                data: data[index],
                              ),
                            ),
                          );
                        },
                        leading: Text(
                          "${index + 1}",
                          style: const TextStyle(fontSize: 20.0),
                        ),
                        title:
                            Text('Harvester: ${snapshot.data[index].userId}'),
                        subtitle: Text(
                            '''Total Mistakes: ${snapshot.data[index].totalMistakes}
Quantity Checked: ${snapshot.data[index].quantityChecked}
Date: ${snapshot.data[index].createdAt}'''),
                        // style: ,
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    GestureDetector(
                      onTap: () => {},
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    GestureDetector(
                      onTap: () => {},
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.delete,
                          color: Colors.red[400],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
