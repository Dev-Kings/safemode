import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qadata/screen/home.dart';
import 'package:qadata/utilities/dialogs/logout_dialog.dart';
import 'package:qadata/utilities/dialogs/show_error_dialog.dart';
import 'package:qadata/utilities/models/varietymodel.dart';
import 'package:qadata/utilities/network_utils/api.dart';
import 'package:qadata/vandad/constants/routes.dart';
import 'package:qadata/views/data/crops.dart';
import 'package:qadata/views/data/qadata.dart';
import 'package:qadata/views/data/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as devtools show log;

class VarietiesView extends StatefulWidget {
  const VarietiesView({Key? key}) : super(key: key);

  @override
  State<VarietiesView> createState() => _VarietiesViewState();
}

class _VarietiesViewState extends State<VarietiesView> {
  late Future<List<Variety>> futureData;
  String email = '';

  @override
  void initState() {
    _loadUserData();
    futureData = fetchVarieties();
    super.initState();
  }

  set userEmail(String email) {
    this.email = email;
  }

  Future<String?> _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user') ?? '');
    if (user != null) {
      setState(() {
        email = user['email'];
      });
    }
    return email;
  }

  Future<List<Variety>> fetchVarieties() async {
    String fileName = 'varietyString.json';
    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/$fileName");
    if (file.existsSync()) {
      // print('Fetching varieties data from local cache');
      devtools.log('Fetching varieties data from local cache');
      final data = file.readAsStringSync();
      List jsonResponse = json.decode(data);
      return jsonResponse.map((data) => Variety.fromJson(data)).toList();
    } else {
      // print('Fetching varieties data from server');
      devtools.log('Fetching varieties data from server');
      final response = await http.get(Uri.parse(
          'http://quality-assurance-app.herokuapp.com/api/v1/varieties'));
      if (response.statusCode == 200) {
        final body = response.body;

        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Variety.fromJson(data)).toList();
      } else {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Variety.fromJson(data)).toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Center(child: Text('Crop Varieties')),
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
        child: FutureBuilder<List<Variety>>(
            future: futureData,
            builder: (context, snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                List<Variety> data = snapshot.data!;
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
                                leading: const Icon(Icons.local_florist),
                                title: Text(data[index].varietyName),
                                subtitle: Text(
                                    'Crop: ${data[index].cropName}\nVariety Code: ${data[index].varietyCode}'),
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
                    child: Text('Loading crop varieties data'),
                  ),
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            }),
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
    data,
    crops,
    users,
    share,
    settings
  ];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const data = MenuItem(text: 'Data', icon: Icons.book);
  static const crops = MenuItem(text: 'Crops', icon: Icons.filter_vintage);
  static const users =
      MenuItem(text: 'Harvesters', icon: Icons.people_alt_outlined);
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
      case MenuItems.data:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DataView()),
        );
        break;
      case MenuItems.crops:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CropsView()),
        );
        break;
      case MenuItems.users:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UsersView()),
        );
        break;
      case MenuItems.settings:
        break;
      case MenuItems.share:
        break;
    }
  }
}
