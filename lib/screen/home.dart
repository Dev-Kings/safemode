import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:qadata/apitestdb/pages/data_home_page.dart';
import 'package:qadata/apitestdb/pages/data_test_home_page.dart';
import 'package:qadata/apitestdb/pages/tabview/home_page.dart';
import 'package:qadata/apitestdb/pages/user_home_page.dart';
import 'package:qadata/apitestdb/pages/variety_home_page.dart';
import 'package:qadata/dataentrytests/pages/home_page.dart';
import 'package:qadata/utilities/dialogs/logout_dialog.dart';
import 'package:qadata/utilities/dialogs/show_error_dialog.dart';
import 'package:qadata/utilities/network_utils/api.dart';
import 'package:qadata/vandad/constants/routes.dart';
// import 'package:qadata/views/data/crops.dart';
import 'package:qadata/views/data/dataentry.dart';
import 'package:qadata/views/data/qadata.dart';
// import 'package:qadata/views/data/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MenuAction { logout }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name = '';

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
        name = user['lastname'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            const Text('Main Page'),
            Text(
              'Hi $name',
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurpleAccent,
        leading: GestureDetector(
          onTap: () {},
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.list,
                size: 46,
                color: Colors.white,
              ),
              customItemsIndexes: const [2],
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
              itemPadding: const EdgeInsets.only(left: 12, right: 12),
              dropdownWidth: 160,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.brown,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ),
        actionsIconTheme:
            const IconThemeData(size: 35.0, color: Colors.white, opacity: 10.0),
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
                ),
              ];
            },
          )
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 50.0),
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DataView()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.purpleAccent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.book,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      'View Data',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DataEntryView()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.edit,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      'Enter New Data',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DataTestHomePage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 196, 135, 155)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.filter_vintage,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      'Local Data',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DataHomePage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.local_florist,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      'DB Data',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const QADataHomePageTest()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.deepOrangeAccent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.group_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      'Data Tests',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.deepPurpleAccent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.data_object,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      'Crops Data',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UserHomePage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.cyanAccent[700]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.group_add,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      'DB Harvesters',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const VarietyHomePage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.brown),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.local_florist,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(
                      'DB Varieties',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            )
          ],
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

  const MenuItem({required this.text, required this.icon});
}

class MenuItems {
  static const List<MenuItem> firstItems = [share, settings];

  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.settings:
        break;
      case MenuItems.share:
        break;
    }
  }
}
