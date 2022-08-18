// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qadata/utilities/models/cropmodel.dart';
import 'package:qadata/utilities/models/filteredvarietymodel.dart';
import 'package:qadata/utilities/network_utils/api.dart';
import 'package:qadata/views/data/qadata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as devtools show log;

class DataEntryView extends StatefulWidget {
  const DataEntryView({Key? key}) : super(key: key);

  @override
  State<DataEntryView> createState() => _DataEntryViewState();
}

class _DataEntryViewState extends State<DataEntryView> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  var qaMonitorId;
  var userId;
  var varietyId;
  var quantityChecked;

  var thickCuttings;
  var thinCuttings;
  var longCuttings;
  var shortCuttings;
  var hardCuttings;
  var overmature;
  var immature;
  var damagedLeaf;
  var insectDamage;
  var chemicalDamage;
  var heelLeaf;
  var mutation;
  var blindShoots;
  var buds;
  var poorHormoning;
  var unevenCut;
  var poorPacking;
  var overcount;
  var undercount;

  var totalMistakes;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  int? id = 0;
  String? fname = '';
  String? lname = '';
  List harvestersList = [];
  var dropdownvalue;

  var cropId;
  var cropName = '';
  List cropsList = [];
  var cropdropdown;

  Future getAllHarvesters() async {
    String fileName = 'harvestersString.json';
    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/$fileName");
    if (file.existsSync()) {
      devtools.log('Fetching harvesters data from local cache');
      final data = file.readAsStringSync();
      var jsonData = json.decode(data);
      setState(() {
        harvestersList = jsonData;
      });
    } else {
      devtools.log('Fetching harvesters data from server');
      final response = await http.get(
          Uri.parse('http://quality-assurance-app.herokuapp.com/api/v1/users'));

      if (response.statusCode == 200) {
        final body = response.body;

        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        var jsonData = jsonDecode(response.body);
        setState(() {
          harvestersList = jsonData;
        });
      } else {
        var jsonData = jsonDecode(response.body);
        setState(() {
          harvestersList = jsonData;
        });
      }
    }
  }

  @override
  void initState() {
    getAllHarvesters();
    _loadUserData();

    listCrop().then((List<Crop> value) {
      setState(() {
        crops = value;
      });
    });
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user') ?? '');

    if (user != null) {
      setState(() {
        qaMonitorId = user['id'];
        fname = user['firstname'];
        lname = user['lastname'];
      });
    }
  }

  final String varietyUrl =
      "http://quality-assurance-app.herokuapp.com/api/v1/varieties";

  List<Crop> crops = [];
  List<FilteredVariety> varieties = [];

  Crop? selectedCrop;
  FilteredVariety? selectedVariety;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Column(
          children: [
            const Text('Data Entry Panel'),
            Text(
              'Q.A.M : $fname $lname',
              ),
          ],
        ),
      ),
      body: Material(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 80.0, right: 80.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                      ),
                      hint: const Text('Select Harvester'),
                      items: harvestersList.map((item) {
                        return DropdownMenuItem(
                          value: item['id'].toString(),
                          child: Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            item['clock_number'].toString() +
                                ': ' +
                                item['firstname'] +
                                ' ' +
                                item['lastname'],
                          ),
                        );
                      }).toList(),
                      onChanged: (harvesterIdValue) {
                        setState(() {
                          userId = harvesterIdValue;
                        });
                      },
                      value: userId,
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    DropdownButtonFormField<Crop>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                      ),
                      hint: const Text('Select Crop Name'),
                      value: selectedCrop,
                      isExpanded: true,
                      items: crops.map((Crop cropObject) {
                        return DropdownMenuItem<Crop>(
                          value: cropObject,
                          child: Text(cropObject.cropName),
                        );
                      }).toList(),
                      onChanged: onCropChange,
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    DropdownButtonFormField<FilteredVariety>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                      ),
                      hint: const Text('Select Variety Code'),
                      value: selectedVariety,
                      isExpanded: true,
                      items: varieties.map((FilteredVariety varietyObject) {
                        return DropdownMenuItem<FilteredVariety>(
                          value: varietyObject,
                          child: Text(varietyObject.varietyCode),
                        );
                      }).toList(),
                      onChanged: onVarietyChange,
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: selectedVariety?.varietyName,
                      ),
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Variety Name",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Quantity Checked",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (quantityCheckedValue) {
                        if (quantityCheckedValue!.isEmpty) {
                          return 'Please enter number of quantity checked';
                        }
                        quantityChecked = quantityCheckedValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Thick Cuttings",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (thickCuttingsValue) {
                        if (thickCuttingsValue!.isEmpty) {
                          //return 'Please enter number of thick cuttings';
                          thickCuttings = 0;
                          return null;
                        }
                        thickCuttings = thickCuttingsValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Thin Cuttings",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (thinCuttingsValue) {
                        if (thinCuttingsValue!.isEmpty) {
                          //return 'Please enter number of thin cuttings';
                          thinCuttings = 0;
                          return null;
                        }
                        thinCuttings = thinCuttingsValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.lightBlue),
                      cursorColor: Colors.amber,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Long Cuttings",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (longCuttingsValue) {
                        if (longCuttingsValue!.isEmpty) {
                          //return 'Please enter number of long cuttings';
                          longCuttings = 0;
                          return null;
                        }
                        longCuttings = longCuttingsValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Short Cuttings",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (shortCuttingsValue) {
                        if (shortCuttingsValue!.isEmpty) {
                          //return 'Please enter number of short cuttings';
                          shortCuttings = 0;
                          return null;
                        }
                        shortCuttings = shortCuttingsValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Hard Cuttings",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (hardCuttingsValue) {
                        if (hardCuttingsValue!.isEmpty) {
                          //return 'Please enter number of hard cuttings';
                          hardCuttings = 0;
                          return null;
                        }
                        hardCuttings = hardCuttingsValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Overmature",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (overmatureValue) {
                        if (overmatureValue!.isEmpty) {
                          //return 'Please enter number of overmature cuttings';
                          overmature = 0;
                          return null;
                        }
                        overmature = overmatureValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Immature",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (immatureValue) {
                        if (immatureValue!.isEmpty) {
                          //return 'Please enter number of immature cuttings';
                          immature = 0;
                          return null;
                        }
                        immature = immatureValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Damaged Leaves",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (damagedLeafValue) {
                        if (damagedLeafValue!.isEmpty) {
                          //return 'Please enter number of damaged leaves';
                          damagedLeaf = 0;
                          return null;
                        }
                        damagedLeaf = damagedLeafValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.lightBlue),
                      cursorColor: Colors.amber,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Insect Damage",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (insectDamageValue) {
                        if (insectDamageValue!.isEmpty) {
                          //return 'Please enter number of cuttings damaged by insect';
                          insectDamage = 0;
                          return null;
                        }
                        insectDamage = insectDamageValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Chemical Damage",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (chemicalDamageValue) {
                        if (chemicalDamageValue!.isEmpty) {
                          //return 'Please enter number of cuttings damaged by chemical';
                          chemicalDamage = 0;
                          return null;
                        }
                        chemicalDamage = chemicalDamageValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Heel Leaves",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (heelLeefValue) {
                        if (heelLeefValue!.isEmpty) {
                          //return 'Please enter number of  heel leaves';
                          heelLeaf = 0;
                          return null;
                        }
                        heelLeaf = heelLeefValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Mutation",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (mutationValue) {
                        if (mutationValue!.isEmpty) {
                          //return 'Please enter number of mutation';
                          mutation = 0;
                          return null;
                        }
                        mutation = mutationValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Blind Shoots",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (blindShootsValue) {
                        if (blindShootsValue!.isEmpty) {
                          //return 'Please enter number of blind shoots';
                          blindShoots = 0;
                          return null;
                        }
                        blindShoots = blindShootsValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Buds",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (budsValue) {
                        if (budsValue!.isEmpty) {
                          //return 'Please enter number of buds';
                          buds = 0;
                          return null;
                        }
                        buds = budsValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.lightBlue),
                      cursorColor: Colors.amber,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Poor Hormoning",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (poorHormoningValue) {
                        if (poorHormoningValue!.isEmpty) {
                          //return 'Please enter number of cuttings with poor hormoning';
                          poorHormoning = 0;
                          return null;
                        }
                        poorHormoning = poorHormoningValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Uneven Cut",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (unevenCutValue) {
                        if (unevenCutValue!.isEmpty) {
                          //return 'Please enter number of cuttings with uneven cuts';
                          unevenCut = 0;
                          return null;
                        }
                        unevenCut = unevenCutValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Poor Packing",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (poorPackingValue) {
                        if (poorPackingValue!.isEmpty) {
                          //return 'Please enter number of poor packing';
                          poorPacking = 0;
                          return null;
                        }
                        poorPacking = poorPackingValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Overcount",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (overcountValue) {
                        if (overcountValue!.isEmpty) {
                          //return 'Please enter overcount value';
                          overcount = 0;
                          return null;
                        }
                        overcount = overcountValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Undercount",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (undecountValue) {
                        if (undecountValue!.isEmpty) {
                          //return 'Please enter undercount value';
                          undercount = 0;
                          return null;
                        }
                        undercount = undecountValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.deepPurple),
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Total Mistakes",
                        hintStyle: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      validator: (totalMistakesValue) {
                        if (totalMistakesValue!.isEmpty) {
                          return 'Please enter value of summation of total mistakes';
                        }
                        totalMistakes = totalMistakesValue;
                        return null;
                      },
                    ),
                    const Divider(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blueAccent),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey;
                              }
                              return Colors.orangeAccent;
                            }),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _sendData();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 10, right: 10),
                            child: Text(
                              _isLoading ? 'Processing...' : 'Save Data',
                              textDirection: TextDirection.ltr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendData() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'qamonitor_id': qaMonitorId,
      'user_id': userId,
      'variety_id': varietyId,
      'quantity_checked': quantityChecked,
      'cuttings_too_thick': thickCuttings,
      'cuttings_too_thin': thinCuttings,
      'cuttings_too_long': longCuttings,
      'cuttings_too_short': shortCuttings,
      'cuttings_too_hard': hardCuttings,
      'overmature_cuttings': overmature,
      'immature_cuttings': immature,
      'damaged_leaf': damagedLeaf,
      'insect_damage': insectDamage,
      'chemical_damage': chemicalDamage,
      'heel_leaf': heelLeaf,
      'mutation': mutation,
      'blind_shoots': blindShoots,
      'buds': buds,
      'poor_hormoning': poorHormoning,
      'uneven_cut': unevenCut,
      'poor_packing': poorPacking,
      'overcount': overcount,
      'undercount': undercount,
      'total_mistakes': totalMistakes
    };

    var res = await Network().authData(data, '/savedata');
    var body = json.decode(res.body);
    // print(body);
    if (body['success']) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DataView(),
        ),
      );
    } else {
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void onCropChange(crop) {
    setState(() {
      selectedCrop = crop;
      varieties = [];
      selectedVariety = null;
    });
    String endpoint = "$varietyUrl/${selectedCrop?.cropId}";

    listVariety(endpoint).then((List<FilteredVariety> value) {
      setState(() {
        varieties = value;
        value.retainWhere((FilteredVariety varietyObject) =>
            varietyObject.cropName == selectedCrop?.cropName);
      });
    });
  }

  void onVarietyChange(variety) {
    setState(() {
      selectedVariety = variety;
      varietyId = selectedVariety?.id;
    });
  }

  Future<List<FilteredVariety>> listVariety(String endpoint) async {
    String fileName = 'varietyString.json';
    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/$fileName");
    if (file.existsSync()) {
      devtools.log('Fetching varieties data from local cache');
      final data = file.readAsStringSync();
      List jsonResponse = json.decode(data);
      return jsonResponse
          .map((data) => FilteredVariety.fromJson(data))
          .toList();
    } else {
      devtools.log('Fetching varieties data from server');
      final response = await http.get(Uri.parse(
          'http://quality-assurance-app.herokuapp.com/api/v1/varieties'));
      if (response.statusCode == 200) {
        final body = response.body;

        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => FilteredVariety.fromJson(data))
            .toList();
      } else {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => FilteredVariety.fromJson(data))
            .toList();
      }
    }
  }

  Future<List<Crop>> listCrop() async {
    String fileName = 'pathString.json';
    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/$fileName");
    if (file.existsSync()) {
      // print('Fetching crops data from local cache');
      devtools.log('Fetching crops data from local cache');
      final data = file.readAsStringSync();
      List jsonResponse = json.decode(data);
      return jsonResponse.map((data) => Crop.fromJson(data)).toList();
    } else {
      // print('Fetching crops data from server');
      devtools.log('Fetching crops data from server');
      final response = await http.get(
          Uri.parse('http://quality-assurance-app.herokuapp.com/api/v1/crops'));

      if (response.statusCode == 200) {
        final body = response.body;

        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Crop.fromJson(data)).toList();
      } else {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Crop.fromJson(data)).toList();
      }
    }
  }
}
