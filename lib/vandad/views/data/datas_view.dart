import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qadata/utilities/dialogs/logout_dialog.dart';
import 'package:qadata/utilities/dialogs/show_error_dialog.dart';
import 'package:qadata/utilities/network_utils/api.dart';
import 'package:qadata/vandad/constants/routes.dart';
import 'package:qadata/vandad/services/crud/data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MenuAction { logout }

class DatasView extends StatefulWidget {
  const DatasView({Key? key}) : super(key: key);

  @override
  State<DatasView> createState() => _DatasViewState();
}

class _DatasViewState extends State<DatasView> {
  int qaMonitorId = 0;
  int clockNumber = 0000;
  String firstname = '';
  String lastname = '';
  String email = '';

  late final DataService _datasService;

  @override
  void initState() {
    _datasService = DataService();
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user') ?? '');

    if (user != null) {
      setState(() {
        qaMonitorId = user['id'];
        clockNumber = user['clock_number'];
        firstname = user['firstname'];
        lastname = user['lastname'];
        email = user['email'];
      });
    }
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newDataRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    logout();
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log Out'),
                ),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _datasService.getOrCreateUser(
          clockNumber: clockNumber,
          firstname: firstname,
          lastname: lastname,
          email: email,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _datasService.allDatas,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allData = snapshot.data as List<DatabaseData>;
                        return ListView.builder(
                          itemCount: allData.length,
                          itemBuilder: (context, index) {
                            final data = allData[index];
                            return ListTile(
                              title: Text(data.quantityChecked.toString()),
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void logout() async {
    try {
      var res = await Network().getData('/logout');
      var body = json.decode(res.body);
      if (body['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.remove('user');
        localStorage.remove('token');
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          loginRoute,
          (_) => false,
        );
      }
    } catch (e) {
      showErrorDialog(context,
          "Contact IT for support quoting the following: 'user token not found in server'");
    }
  }
}
