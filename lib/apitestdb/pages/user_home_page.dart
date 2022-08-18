import 'package:flutter/material.dart';
import 'package:qadata/apitestdb/provider/api/user_api_provider.dart';
import 'package:qadata/apitestdb/provider/db/db_provider.dart';
import 'dart:developer' as devtools;

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users in DB'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadUsersFromApi();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _deleteUsersData();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildUserListView(),
    );
  }

  _loadUsersFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = UserApiProvider();
    await apiProvider.getAllUsers();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteUsersData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllUsers();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
    devtools.log('All users deleted');
  }

  _buildUserListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllUsers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            padding: const EdgeInsets.all(20.0),
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
                title: Text(        
                    "Name: ${snapshot.data[index].firstName} ${snapshot.data[index].lastName}"),
                subtitle: Text('Clock Number: ${snapshot.data[index].clockNumber}'),
              );
            },
          );
        }
      },
    );
  }
}
