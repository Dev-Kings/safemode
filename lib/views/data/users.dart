import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:qadata/screen/home.dart';
import 'package:qadata/utilities/dialogs/logout_dialog.dart';
import 'package:qadata/utilities/dialogs/show_error_dialog.dart';
import 'package:qadata/utilities/network_utils/api.dart';
import 'package:qadata/vandad/constants/routes.dart';
import 'package:qadata/views/data/crops.dart';
import 'package:qadata/views/data/qadata.dart';
import 'package:qadata/views/data/varieties.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersView extends StatefulWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState();
}

class Data {
  final int clockNumber;
  final String firstname;
  final String lastname;

  Data(
      {required this.clockNumber,
      required this.firstname,
      required this.lastname});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        clockNumber: json['clock_number'],
        firstname: json['firstname'],
        lastname: json['lastname']);
  }
}

class _UsersViewState extends State<UsersView> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    futureData = fetchData();
    super.initState();
  }

  Future<List<Data>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://quality-assurance-app.herokuapp.com/api/v1/users'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch harvesters data!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Center(child: Text('Harvesters')),
        leading: GestureDetector(
          onTap: () {},
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.list,
                size: 46,
                color: Colors.white,
              ),
              customItemsIndexes: const [6],
              customItemsHeight: 8,
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 160,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.brown,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ),
        actions: [
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
                )
              ];
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                List<Data> data = snapshot.data!;
                return SafeArea(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Card(
                            elevation: 8,
                            margin: const EdgeInsets.all(10),
                            child: Center(
                              child: ListTile(
                                isThreeLine: true,
                                minLeadingWidth: 2,
                                leading: const Icon(Icons.person_rounded),
                                title: Text(
                                    'Name: ${data[index].firstname} ${data[index].lastname}'),
                                subtitle: Text(
                                    'Clock Number: ${data[index].clockNumber}'),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text('Loading harvesters data'),
                  ),
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
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

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [
    home,
    crops,
    varieties,
    data,
    share,
    settings
  ];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const crops = MenuItem(text: 'Crops', icon: Icons.filter_vintage);
  static const varieties =
      MenuItem(text: 'Varieties', icon: Icons.local_florist);
  static const data = MenuItem(text: 'Data', icon: Icons.book);
  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.white,
          size: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        )
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
        break;
      case MenuItems.crops:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CropsView()),
        );
        break;
      case MenuItems.varieties:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VarietiesView()),
        );
        break;

      case MenuItems.data:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DataView()),
        );
        break;
      case MenuItems.settings:
        break;
      case MenuItems.share:
        break;
    }
  }
}
