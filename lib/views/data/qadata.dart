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
import 'package:qadata/views/data/dataentry.dart';
import 'package:qadata/views/data/qualitydata.dart';
import 'package:qadata/views/data/users.dart';
import 'package:qadata/views/data/varieties.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataView extends StatefulWidget {
  const DataView({Key? key}) : super(key: key);

  @override
  State<DataView> createState() => _DataViewState();
}

class Data {
  final String qaMonitorName;
  final int clockNumber;
  final String harvesterName;
  final String cropName;
  final String varietyCode;
  final String varietyName;
  final int quantityChecked;
  final int totalMistakes;
  final int thickCuttings;
  final int thinCuttings;
  final int longCuttings;
  final int shortCuttings;
  final int hardCuttings;
  final int softCuttings;
  final int moreLeaves;
  final int lessLeaves;
  final int longPetiole;
  final int shortPetiole;
  final int overmature;
  final int immature;
  final int shortStickingLength;
  final int damagedLeaf;
  final int mechanicalDamage;
  final int diseaseDamage;
  final int insectDamage;
  final int chemicalDamage;
  final int heelLeaf;
  final int mutation;
  final int blindShoots;
  final int buds;
  final int poorHormoning;
  final int unevenCut;
  final int overgrading;
  final int poorPacking;
  final int overcount;
  final int undercount;
  final int bigLeaves;
  final int smallLeaves;
  final int bigCuttings;
  final int smallCuttings;
  final String createdAt;

  Data(
      {required this.qaMonitorName,
      required this.clockNumber,
      required this.harvesterName,
      required this.quantityChecked,
      required this.totalMistakes,
      required this.thickCuttings,
      required this.thinCuttings,
      required this.longCuttings,
      required this.shortCuttings,
      required this.hardCuttings,
      required this.softCuttings,
      required this.moreLeaves,
      required this.lessLeaves,
      required this.longPetiole,
      required this.shortPetiole,
      required this.overmature,
      required this.immature,
      required this.shortStickingLength,
      required this.damagedLeaf,
      required this.mechanicalDamage,
      required this.diseaseDamage,
      required this.insectDamage,
      required this.chemicalDamage,
      required this.heelLeaf,
      required this.mutation,
      required this.blindShoots,
      required this.buds,
      required this.poorHormoning,
      required this.unevenCut,
      required this.overgrading,
      required this.poorPacking,
      required this.overcount,
      required this.undercount,
      required this.bigLeaves,
      required this.smallLeaves,
      required this.bigCuttings,
      required this.smallCuttings,
      required this.createdAt,
      required this.varietyCode,
      required this.varietyName,
      required this.cropName});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        qaMonitorName: json['qamonitor'],
        clockNumber: json['clock_number'],
        harvesterName: json['harvester_name'],
        cropName: json['crop_name'],
        varietyCode: json['variety_code'],
        varietyName: json['variety_name'],
        quantityChecked: json['quantity_checked'],
        totalMistakes: json['total_mistakes'],
        thickCuttings: json['cuttings_too_thick'],
        thinCuttings: json['cuttings_too_thin'],
        longCuttings: json['cuttings_too_long'],
        shortCuttings: json['cuttings_too_short'],
        hardCuttings: json['cuttings_too_hard'],
        softCuttings: json['cuttings_too_soft'],
        moreLeaves: json['more_leaves'],
        lessLeaves: json['less_leaves'],
        longPetiole: json['long_petiole'],
        shortPetiole: json['short_petiole'],
        overmature: json['overmature_cuttings'],
        immature: json['immature_cuttings'],
        shortStickingLength: json['short_sticking_length'],
        damagedLeaf: json['damaged_leaf'],
        mechanicalDamage: json['mechanical_damage'],
        diseaseDamage: json['disease_damage'],
        insectDamage: json['insect_damage'],
        chemicalDamage: json['chemical_damage'],
        heelLeaf: json['heel_leaf'],
        mutation: json['mutation'],
        blindShoots: json['blind_shoots'],
        buds: json['buds'],
        poorHormoning: json['poor_hormoning'],
        unevenCut: json['uneven_cut'],
        overgrading: json['overgrading'],
        poorPacking: json['poor_packing'],
        overcount: json['overcount'],
        undercount: json['undercount'],
        bigLeaves: json['big_leaves'],
        smallLeaves: json['small_leaves'],
        bigCuttings: json['big_cuttings'],
        smallCuttings: json['small_cuttings'],
        createdAt: json['created_at']);
  }
}

class _DataViewState extends State<DataView> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    futureData = fetchData();
    super.initState();
  }

  Future<List<Data>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://quality-assurance-app.herokuapp.com/api/v1/data'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch Q.A data!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Q.A Data')),
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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataEntryView()),
              );
            },
            icon: const Icon(Icons.add),
          ),
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
                                leading: const Icon(Icons.content_paste_off),
                                title: Text(
                                    'Harvester: ${data[index].harvesterName}'),
                                subtitle: Text(
                                    'Crop: ${data[index].cropName}\nVariety Code: ${data[index].varietyCode}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            QualityDataView(data: data[index])),
                                  );
                                },
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
                    child: Text('Loading Q.A data'),
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
    crops,
    varieties,
    users,
    share,
    settings
  ];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const crops = MenuItem(text: 'Crops', icon: Icons.filter_vintage);
  static const varieties =
      MenuItem(text: 'Varieties', icon: Icons.local_florist);
  static const users = MenuItem(text: 'Harvesters', icon: Icons.people_alt_outlined);
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
