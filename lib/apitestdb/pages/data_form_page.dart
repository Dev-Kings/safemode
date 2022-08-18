// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:qadata/apitestdb/model/crop_model.dart';
import 'package:qadata/apitestdb/model/crop_specs_model.dart';
import 'package:qadata/apitestdb/model/data_model.dart';
import 'package:qadata/apitestdb/model/user_model.dart';
import 'package:qadata/apitestdb/model/v2_crop_specs_model.dart';
import 'package:qadata/apitestdb/model/variety_model.dart';
import 'package:qadata/apitestdb/pages/tabview/common_widgets/variety_selector.dart';
import 'package:qadata/apitestdb/provider/db/db_provider.dart';
import 'package:qadata/dataentrytests/models/variety.dart';
// import 'package:qadata/apitestdb/provider/db/db_provider.dart';
// import 'package:qadata/dataentrytests/models/crop.dart';
// import 'package:qadata/dataentrytests/models/variety.dart';
// import 'package:qadata/dataentrytests/common_widgets/crop_selector.dart';
// import 'package:qadata/dataentrytests/models/crop.dart';
// import 'package:qadata/dataentrytests/models/variety.dart';
import 'package:qadata/dataentrytests/services/database_service.dart';
import 'dart:developer' as devtools;

import 'package:shared_preferences/shared_preferences.dart';

class DataFormPage extends StatefulWidget {
  const DataFormPage({Key? key, this.variety, this.data}) : super(key: key);
  final VarietyModel? variety;
  final Data? data;

  @override
  State<DataFormPage> createState() => _DataFormPageState();
}

class _DataFormPageState extends State<DataFormPage> {
  final _formKey = GlobalKey<FormState>();

  var qaMonitorId = 0;
  var userId = 0;

  final String varietyUrl =
      "http://quality-assurance-app.herokuapp.com/api/v1/varieties";

  List<CropSpecsModel> crops = [];
  List<VarietyModel> varieties = [];
  List<CropSpecs> specslist = [];
  CropSpecsModel? selectedCrop;

  VarietyModel? selectedVariety;

  var id;
  var varietyId;

  var thickCuttingsSpec;
  var thinCuttingsSpec;
  var longCuttingsSpec;
  var shortCuttingsSpec;
  var hardCuttingsSpec;
  var softCuttingsSpec;
  var moreLeavesSpec;
  var lessLeavesSpec;
  var longPetioleSpec;
  var shortPetioleSpec;
  var overmatureSpec;
  var immatureSpec;
  var shortStickingSpec;
  var damagedLeafSpec;
  var mechanicalDamageSpec;
  var diseaseDamageSpec;
  var insectDamageSpec;
  var chemicalDamageSpec;
  var heelLeafSpec;
  var mutationSpec;
  var blindShootsSpec;
  var budsSpec;
  var poorHormoningSpec;
  var unevenCutSpec;
  var overgradingSpec;
  var poorPackingSpec;
  var overcountSpec;
  var undercountSpec;
  var bigLeavesSpec;
  var smallLeavesSpec;
  var bigCuttingsSpec;
  var smallCuttingsSpec;

  var cropName = '';
  List cropsList = [];

  // final TextEditingController _qaMonitorIdController = TextEditingController();
  final _harvesterController = TextEditingController();
  final TextEditingController _varietyIdController = TextEditingController();
  final TextEditingController _quantityCheckedController =
      TextEditingController();
  final TextEditingController _totalMistakesController =
      TextEditingController();

  final TextEditingController _thickCuttingsController =
      TextEditingController();
  final TextEditingController _thinCuttingsController = TextEditingController();
  final TextEditingController _longCuttingsController = TextEditingController();
  final TextEditingController _shortCuttingsController =
      TextEditingController();
  final TextEditingController _hardCuttingsController = TextEditingController();
  final TextEditingController _softCuttingsController = TextEditingController();
  final TextEditingController _moreLeavesController = TextEditingController();
  final TextEditingController _lessLeavesController = TextEditingController();
  final TextEditingController _longPetioleController = TextEditingController();
  final TextEditingController _shortPetioleController = TextEditingController();
  final TextEditingController _overmatureController = TextEditingController();
  final TextEditingController _immatureController = TextEditingController();
  final TextEditingController _shortStickingLengthController =
      TextEditingController();
  final TextEditingController _damagedLeafController = TextEditingController();
  final TextEditingController _mechanicalDamageController =
      TextEditingController();
  final TextEditingController _diseaseDamageController =
      TextEditingController();
  final TextEditingController _insectDamageCuttings = TextEditingController();
  final TextEditingController _chemicalDamageController =
      TextEditingController();
  final TextEditingController _heelLeafController = TextEditingController();
  final TextEditingController _mutationController = TextEditingController();
  final TextEditingController _blindShootsController = TextEditingController();
  final TextEditingController _budsController = TextEditingController();
  final TextEditingController _poorHormoningController =
      TextEditingController();
  final TextEditingController _unevenCutController = TextEditingController();
  final TextEditingController _overgradingController = TextEditingController();
  final TextEditingController _poorPackingController = TextEditingController();
  final TextEditingController _overcountController = TextEditingController();
  final TextEditingController _undercountController = TextEditingController();
  final TextEditingController _bigLeavesController = TextEditingController();
  final TextEditingController _smallLeavesController = TextEditingController();
  final TextEditingController _bigCuttingsController = TextEditingController();
  final TextEditingController _smallCuttingsController =
      TextEditingController();

  // static final List<Crop> _crops = [];
  static final List<Variety> _varieties = [];

  final DatabaseService _databaseService = DatabaseService();
  final DBProvider _databaseProviderService = DBProvider();

  int _selectedVariety = 0;

  @override
  void initState() {
    _loadUserData();

    listCrop().then((List<CropSpecsModel> value) {
      setState(() {
        crops = value;
      });
    });
    super.initState();
    if (widget.data != null) {
      // _qaMonitorIdController.text = (widget.data!.qamonitorId).toString();
      // _harvesterController.text = widget.data!.userId;
      _varietyIdController.text = (widget.data!.varietyId).toString();
      _quantityCheckedController.text =
          (widget.data!.quantityChecked).toString();
      _totalMistakesController.text = (widget.data!.totalMistakes).toString();
      _thickCuttingsController.text =
          (widget.data!.cuttingsTooThick).toString();
      _thinCuttingsController.text = (widget.data!.cuttingsTooThin).toString();
      _longCuttingsController.text = (widget.data!.cuttingsTooLong).toString();
      _shortCuttingsController.text =
          (widget.data!.cuttingsTooShort).toString();
      _hardCuttingsController.text = (widget.data!.cuttingsTooHard).toString();
      _softCuttingsController.text = (widget.data!.cuttingsTooSoft).toString();
      _moreLeavesController.text = (widget.data!.moreLeaves).toString();
      _lessLeavesController.text = (widget.data!.lessLeaves).toString();
      _longPetioleController.text = (widget.data!.longPetiole).toString();
      _shortPetioleController.text = (widget.data!.shortPetiole).toString();
      _overmatureController.text = (widget.data!.overmatureCuttings).toString();
      _immatureController.text = (widget.data!.immatureCuttings).toString();
      _shortStickingLengthController.text =
          (widget.data!.shortStickingLength).toString();
      _damagedLeafController.text = (widget.data!.damagedLeaf).toString();
      _mechanicalDamageController.text =
          (widget.data!.mechanicalDamage).toString();
      _diseaseDamageController.text = (widget.data!.diseaseDamage).toString();
      _insectDamageCuttings.text = (widget.data!.insectDamage).toString();
      _chemicalDamageController.text = (widget.data!.chemicalDamage).toString();
      _heelLeafController.text = (widget.data!.heelLeaf).toString();
      _mutationController.text = (widget.data!.mutation).toString();
      _blindShootsController.text = (widget.data!.blindShoots).toString();
      _budsController.text = (widget.data!.buds).toString();
      _poorHormoningController.text = (widget.data!.poorHormoning).toString();
      _unevenCutController.text = (widget.data!.unevenCut).toString();
      _overgradingController.text = (widget.data!.overgrading).toString();
      _poorPackingController.text = (widget.data!.poorPacking).toString();
      _overcountController.text = (widget.data!.overcount).toString();
      _undercountController.text = (widget.data!.undercount).toString();
      _bigLeavesController.text = (widget.data!.bigLeaves).toString();
      _smallLeavesController.text = (widget.data!.smallLeaves).toString();
      _bigCuttingsController.text = (widget.data!.bigCuttings).toString();
      _smallCuttingsController.text = (widget.data!.smallCuttings).toString();
    }
  }

  Future<List<Variety>> _getVarieties() async {
    final varieties = await _databaseProviderService.varieties();
    if (_varieties.isEmpty) _varieties.addAll(varieties);
    if (widget.data != null) {
      _selectedVariety =
          _varieties.indexWhere((e) => e.id == widget.data!.varietyId);
    }
    return _varieties;
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

  Future<void> _onSave() async {
    final quantityChecked = int.tryParse(_quantityCheckedController.text);
    final totalMistakes = int.tryParse(_totalMistakesController.text);
    final thickCuttings = int.tryParse(_thickCuttingsController.text);
    final thinCuttings = int.tryParse(_thinCuttingsController.text);
    final longCuttings = int.tryParse(_longCuttingsController.text);
    final shortCuttings = int.tryParse(_shortCuttingsController.text);
    final hardCuttings = int.tryParse(_hardCuttingsController.text);
    final softCuttings = int.tryParse(_softCuttingsController.text);
    final moreLeaves = int.tryParse(_moreLeavesController.text);
    final lessLeaves = int.tryParse(_lessLeavesController.text);
    final longPetiole = int.tryParse(_longPetioleController.text);
    final shortPetiole = int.tryParse(_shortPetioleController.text);
    final overmature = int.tryParse(_overmatureController.text);
    final immature = int.tryParse(_immatureController.text);
    final shortStickingLength =
        int.tryParse(_shortStickingLengthController.text);
    final damagedLeaf = int.tryParse(_damagedLeafController.text);
    final mechanicalDamage = int.tryParse(_mechanicalDamageController.text);
    final diseaseDamage = int.tryParse(_diseaseDamageController.text);
    final insectDamage = int.tryParse(_insectDamageCuttings.text);
    final chemicalDamage = int.tryParse(_chemicalDamageController.text);
    final heelLeaf = int.tryParse(_heelLeafController.text);
    final mutation = int.tryParse(_mutationController.text);
    final blindShoots = int.tryParse(_blindShootsController.text);
    final buds = int.tryParse(_budsController.text);
    final poorHormoning = int.tryParse(_poorHormoningController.text);
    final unevenCut = int.tryParse(_unevenCutController.text);
    final overgrading = int.tryParse(_overgradingController.text);
    final poorPacking = int.tryParse(_poorPackingController.text);
    final overcount = int.tryParse(_overcountController.text);
    final undercount = int.tryParse(_undercountController.text);
    final bigLeaves = int.tryParse(_bigLeavesController.text);
    final smallLeaves = int.tryParse(_smallLeavesController.text);
    final bigCuttings = int.tryParse(_bigCuttingsController.text);
    final smallCuttings = int.tryParse(_smallCuttingsController.text);
    final DateTime now = DateTime.now();
    String createdAt = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);

    widget.data == null
        ? await _databaseService.insertData(
            Data(
              qamonitorId: qaMonitorId,
              userId: userId,
              varietyId: varietyId,
              quantityChecked: quantityChecked ?? 0,
              totalMistakes: totalMistakes ?? 0,
              cuttingsTooThick: thickCuttings ?? 0,
              cuttingsTooThin: thinCuttings ?? 0,
              cuttingsTooLong: longCuttings ?? 0,
              cuttingsTooShort: shortCuttings ?? 0,
              cuttingsTooHard: hardCuttings ?? 0,
              cuttingsTooSoft: softCuttings ?? 0,
              moreLeaves: moreLeaves ?? 0,
              lessLeaves: lessLeaves ?? 0,
              longPetiole: longPetiole ?? 0,
              shortPetiole: shortPetiole ?? 0,
              overmatureCuttings: overmature ?? 0,
              immatureCuttings: immature ?? 0,
              shortStickingLength: shortStickingLength ?? 0,
              damagedLeaf: damagedLeaf ?? 0,
              mechanicalDamage: mechanicalDamage ?? 0,
              diseaseDamage: diseaseDamage ?? 0,
              insectDamage: insectDamage ?? 0,
              chemicalDamage: chemicalDamage ?? 0,
              heelLeaf: heelLeaf ?? 0,
              mutation: mutation ?? 0,
              blindShoots: blindShoots ?? 0,
              buds: buds ?? 0,
              poorHormoning: poorHormoning ?? 0,
              unevenCut: unevenCut ?? 0,
              overgrading: overgrading ?? 0,
              poorPacking: poorPacking ?? 0,
              overcount: overcount ?? 0,
              undercount: undercount ?? 0,
              bigLeaves: bigLeaves ?? 0,
              smallLeaves: smallLeaves ?? 0,
              bigCuttings: bigCuttings ?? 0,
              smallCuttings: smallCuttings ?? 0,
              createdAt: createdAt,
            ),
          )
        : await _databaseService.updateData(
            Data(
              id: widget.data!.id,
              qamonitorId: qaMonitorId,
              userId: userId,
              varietyId: varietyId,
              quantityChecked: quantityChecked ?? 0,
              totalMistakes: totalMistakes ?? 0,
              cuttingsTooThick: thickCuttings ?? 0,
              cuttingsTooThin: thinCuttings ?? 0,
              cuttingsTooLong: longCuttings ?? 0,
              cuttingsTooShort: shortCuttings ?? 0,
              cuttingsTooHard: hardCuttings ?? 0,
              cuttingsTooSoft: softCuttings ?? 0,
              moreLeaves: moreLeaves ?? 0,
              lessLeaves: lessLeaves ?? 0,
              longPetiole: longPetiole ?? 0,
              shortPetiole: shortPetiole ?? 0,
              overmatureCuttings: overmature ?? 0,
              immatureCuttings: immature ?? 0,
              shortStickingLength: shortStickingLength ?? 0,
              damagedLeaf: damagedLeaf ?? 0,
              mechanicalDamage: mechanicalDamage ?? 0,
              diseaseDamage: diseaseDamage ?? 0,
              insectDamage: insectDamage ?? 0,
              chemicalDamage: chemicalDamage ?? 0,
              heelLeaf: heelLeaf ?? 0,
              mutation: mutation ?? 0,
              blindShoots: blindShoots ?? 0,
              buds: buds ?? 0,
              poorHormoning: poorHormoning ?? 0,
              unevenCut: unevenCut ?? 0,
              overgrading: overgrading ?? 0,
              poorPacking: poorPacking ?? 0,
              overcount: overcount ?? 0,
              undercount: undercount ?? 0,
              bigLeaves: bigLeaves ?? 0,
              smallLeaves: smallLeaves ?? 0,
              bigCuttings: bigCuttings ?? 0,
              smallCuttings: smallCuttings ?? 0,
              createdAt: createdAt,
            ),
          );

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<List<User>> getHarvesterSuggestions(String query) async {
    final List<User> harvesters = [];
    String fileName = 'harvestersString.json';
    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/$fileName");
    if (file.existsSync()) {
      devtools.log('Fetching harvesters data from local cache');
      final data = file.readAsStringSync();
      // var jsonData = json.decode(data);
      List harvesters = json.decode(data);
      setState(() {
        harvesters = jsonDecode(data);
      });

      return harvesters.map((json) => User.fromJson(json)).where((harvester) {
        final clockNumber = harvester.clockNumber.toString();
        final queryLower = query.toString();

        return clockNumber.contains(queryLower);
      }).toList();
    } else {
      devtools.log('Fetching harvesters data from server');

      final url =
          Uri.parse('http://quality-assurance-app.herokuapp.com/api/v1/users');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List harvesters = json.decode(response.body);
        final body = response.body;
        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        // var jsonData = jsonDecode(response.body);

        setState(() {
          harvesters = jsonDecode(response.body);
        });

        return harvesters.map((json) => User.fromJson(json)).where((harvester) {
          final clockNumber = harvester.clockNumber.toString();
          final queryLower = query.toString();

          return clockNumber.contains(queryLower);
        }).toList();
      }
    }
    return harvesters;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Data Record'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 10.0, left: 80.0, right: 80.0, bottom: 8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TypeAheadFormField<User?>(
                    hideSuggestionsOnKeyboardHide: true,
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _harvesterController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.group_add),
                        border: OutlineInputBorder(),
                        hintText: 'Enter clock number',
                      ),
                    ),
                    suggestionsCallback: getHarvesterSuggestions,
                    itemBuilder: (context, User? suggestion) {
                      final harvester = suggestion!;
                      return ListTile(
                        title: Text(harvester.clockNumber.toString()),
                        subtitle: Text(
                            '${harvester.firstName} ${harvester.lastName}'),
                      );
                    },
                    noItemsFoundBuilder: (context) => const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Harvester Not Found',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    onSuggestionSelected: (User? suggestion) {
                      final harvester = suggestion!;
                      userId = harvester.id;
                      _harvesterController.text =
                          '${harvester.firstName} ${harvester.lastName}';
                      devtools.log(userId.toString());
                    },
                    validator: (harvestervalue) {
                      if (harvestervalue!.isEmpty) {
                        return 'Enter clock number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<CropSpecsModel>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    hint: const Text('Select Crop Name'),
                    value: selectedCrop,
                    isExpanded: true,
                    items: crops.map((CropSpecsModel cropObject) {
                      return DropdownMenuItem<CropSpecsModel>(
                        value: cropObject,
                        child: Text(cropObject.cropName),
                      );
                    }).toList(),
                    onChanged: onCropChange,
                    validator: (cropNamevalue) {
                      if (cropNamevalue == null) {
                        return 'Select crop';
                      }
                      onCropChange;
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<VarietyModel>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    // hint: const Text('Select Variety Code'),
                    hint: Text(_varietyIdController.text),
                    // value: selectedVariety,
                    value: selectedVariety,
                    isExpanded: true,
                    items: varieties.map((VarietyModel varietyObject) {
                      return DropdownMenuItem<VarietyModel>(
                        value: varietyObject,
                        child: Text(varietyObject.varietyCode),
                      );
                    }).toList(),
                    onChanged: onVarietyChange,
                    validator: (varietyCodeValue) {
                      if (varietyCodeValue == null) {
                        return 'Select Variety Code';
                      }
                      onVarietyChange;
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    controller: TextEditingController(
                      text: selectedVariety?.varietyName,
                    ),
                    style: const TextStyle(color: Colors.deepPurple),
                    cursorColor: Colors.purple,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                      border: OutlineInputBorder(),
                      hintText: "Variety Name",
                      hintStyle: TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  FutureBuilder<List<Variety>>(
                    future: _getVarieties(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return VarietySelector(
                        varieties:
                            _varieties.map((e) => e.varietyName).toList(),
                        selectedIndex: _selectedVariety,
                        onChanged: (value) {
                          setState(() {
                            _selectedVariety = value;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _quantityCheckedController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Quantity checked',
                    ),
                    validator: (quantityCheckedvalue) {
                      if (quantityCheckedvalue!.isEmpty) {
                        return 'Enter number of cuttings checked!';
                      }
                      _quantityCheckedController.text = quantityCheckedvalue;
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  // if (specslist.any((item) => item == 'Cuttings Too Thick'))
                  if (thickCuttingsSpec == true)
                    TextFormField(
                      controller: _thickCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Thick cuttings',
                      ),
                      validator: (thickCuttingsvalue) {
                        if (thickCuttingsvalue!.isEmpty) {
                          _thickCuttingsController.text = '0';
                        }
                        _thickCuttingsController.text = thickCuttingsvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  // if (selectedCrop?.specsName == 'Cuttings - Too Thin')
                  if (thinCuttingsSpec == true)
                    TextFormField(
                      controller: _thinCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Thin cuttings',
                      ),
                      validator: (thinCuttingsvalue) {
                        if (thinCuttingsvalue!.isEmpty) {
                          _thinCuttingsController.text = '0';
                        }
                        _thinCuttingsController.text = thinCuttingsvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Cuttings - Too Long')
                  if (longCuttingsSpec == true)
                    TextFormField(
                      controller: _longCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Long cuttings',
                      ),
                      validator: (longCuttingsvalue) {
                        if (longCuttingsvalue!.isEmpty) {
                          _longCuttingsController.text = '0';
                        }
                        _longCuttingsController.text = longCuttingsvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  // if (selectedCrop?.specsName == 'Cuttings - Too short')
                  if (shortCuttingsSpec == true)
                    TextFormField(
                      controller: _shortCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Short cuttings',
                      ),
                      validator: (shortCuttingsvalue) {
                        if (shortCuttingsvalue!.isEmpty) {
                          _shortCuttingsController.text = '0';
                        }
                        _shortCuttingsController.text = shortCuttingsvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Cuttings - Too Hard')
                  if (hardCuttingsSpec == true)
                    TextFormField(
                      controller: _hardCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Hard cuttings',
                      ),
                      validator: (hardCuttingsvalue) {
                        if (hardCuttingsvalue!.isEmpty) {
                          _hardCuttingsController.text = '0';
                        }
                        _hardCuttingsController.text = hardCuttingsvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Cuttings - Too Soft')
                  if (softCuttingsSpec == true)
                    TextFormField(
                      controller: _softCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Soft Cuttings',
                      ),
                      validator: (softCuttingsvalue) {
                        if (softCuttingsvalue!.isEmpty) {
                          _softCuttingsController.text = '0';
                        }
                        _softCuttingsController.text = softCuttingsvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Leaves - More')
                  if (moreLeavesSpec == true)
                    TextFormField(
                      controller: _moreLeavesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'More Leaves',
                      ),
                      validator: (moreLeavesvalue) {
                        if (moreLeavesvalue!.isEmpty) {
                          _moreLeavesController.text = '0';
                        }
                        _moreLeavesController.text = moreLeavesvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Leaves - Less')
                  if (lessLeavesSpec == true)
                    TextFormField(
                      controller: _lessLeavesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Less Leaves',
                      ),
                      validator: (lessLeavesvalue) {
                        if (lessLeavesvalue!.isEmpty) {
                          _lessLeavesController.text = '0';
                        }
                        _lessLeavesController.text = lessLeavesvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Petiole - Long')
                  if (longPetioleSpec == true)
                    TextFormField(
                      controller: _longPetioleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Long Petioles',
                      ),
                      validator: (longPetiolevalue) {
                        if (longPetiolevalue!.isEmpty) {
                          _longPetioleController.text = '0';
                        }
                        _longPetioleController.text = longPetiolevalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Petiole - Short')
                  if (shortPetioleSpec == true)
                    TextFormField(
                      controller: _shortPetioleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Short Petioles',
                      ),
                      validator: (shortPetiolevalue) {
                        if (shortPetiolevalue!.isEmpty) {
                          _shortPetioleController.text = '0';
                        }
                        _shortPetioleController.text = shortPetiolevalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Cuttings - Overmature')
                  if (overmatureSpec == true)
                    TextFormField(
                      controller: _overmatureController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Overmature',
                      ),
                      validator: (overmaturevalue) {
                        if (overmaturevalue!.isEmpty) {
                          _overmatureController.text = '0';
                        }
                        _overmatureController.text = overmaturevalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Cuttings - Immature')
                  if (immatureSpec == true)
                    TextFormField(
                      controller: _immatureController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Immature',
                      ),
                      validator: (immaturevalue) {
                        if (immaturevalue!.isEmpty) {
                          _immatureController.text = '0';
                        }
                        _immatureController.text = immaturevalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Short Sticking Length')
                  if (shortStickingSpec == true)
                    TextFormField(
                      controller: _shortStickingLengthController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Short Sticking Length',
                      ),
                      validator: (shortStickvalue) {
                        if (shortStickvalue!.isEmpty) {
                          _shortStickingLengthController.text = '0';
                        }
                        _shortStickingLengthController.text = shortStickvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Damaged Leaf')
                  if (damagedLeafSpec == true)
                    TextFormField(
                      controller: _damagedLeafController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Damaged Leaves',
                      ),
                      validator: (damagedLeafvalue) {
                        if (damagedLeafvalue!.isEmpty) {
                          _damagedLeafController.text = '0';
                        }
                        _damagedLeafController.text = damagedLeafvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Mechanical damage')
                  if (mechanicalDamageSpec == true)
                    TextFormField(
                      controller: _mechanicalDamageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Mechanical Damage',
                      ),
                      validator: (mechanicalDamagevalue) {
                        if (mechanicalDamagevalue!.isEmpty) {
                          _mechanicalDamageController.text = '0';
                        }
                        _mechanicalDamageController.text =
                            mechanicalDamagevalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Disease damage')
                  if (diseaseDamageSpec == true)
                    TextFormField(
                      controller: _diseaseDamageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Disease Damage',
                      ),
                      validator: (diseaseDamagevalue) {
                        if (diseaseDamagevalue!.isEmpty) {
                          _diseaseDamageController.text = '0';
                        }
                        _diseaseDamageController.text = diseaseDamagevalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Insect Damage')
                  if (insectDamageSpec == true)
                    TextFormField(
                      controller: _insectDamageCuttings,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Insect Damage',
                      ),
                      validator: (insectDamagevalue) {
                        if (insectDamagevalue!.isEmpty) {
                          _insectDamageCuttings.text = '0';
                        }
                        _insectDamageCuttings.text = insectDamagevalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Chemical Damage')
                  if (chemicalDamageSpec == true)
                    TextFormField(
                      controller: _chemicalDamageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Chemical Damage',
                      ),
                      validator: (chemicalDamagevalue) {
                        if (chemicalDamagevalue!.isEmpty) {
                          _chemicalDamageController.text = '0';
                        }
                        _chemicalDamageController.text = chemicalDamagevalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Heel Leaf')
                  if (heelLeafSpec == true)
                    TextFormField(
                      controller: _heelLeafController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Heel Leaves',
                      ),
                      validator: (heelLeafvalue) {
                        if (heelLeafvalue!.isEmpty) {
                          _heelLeafController.text = '0';
                        }
                        _heelLeafController.text = heelLeafvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Mutation')
                  if (mutationSpec == true)
                    TextFormField(
                      controller: _mutationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Mutation',
                      ),
                      validator: (mutationvalue) {
                        if (mutationvalue!.isEmpty) {
                          _mutationController.text = '0';
                        }
                        _mutationController.text = mutationvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Blind Shoots')
                  if (blindShootsSpec == true)
                    TextFormField(
                      controller: _blindShootsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Blind Shoots',
                      ),
                      validator: (blindShootsvalue) {
                        if (blindShootsvalue!.isEmpty) {
                          _blindShootsController.text = '0';
                        }
                        _blindShootsController.text = blindShootsvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Buds')
                  if (budsSpec == true)
                    TextFormField(
                      controller: _budsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Buds',
                      ),
                      validator: (budsvalue) {
                        if (budsvalue!.isEmpty) {
                          _budsController.text = '0';
                        }
                        _budsController.text = budsvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Poor Hormoning')
                  if (poorHormoningSpec == true)
                    TextFormField(
                      controller: _poorHormoningController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Poor Hormoning',
                      ),
                      validator: (poorHormoningvalue) {
                        if (poorHormoningvalue!.isEmpty) {
                          _poorHormoningController.text = '0';
                        }
                        _poorHormoningController.text = poorHormoningvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Uneven Cut')
                  if (unevenCutSpec == true)
                    TextFormField(
                      controller: _unevenCutController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Uneven Cuts',
                      ),
                      validator: (unevenCutvalue) {
                        if (unevenCutvalue!.isEmpty) {
                          _unevenCutController.text = '0';
                        }
                        _unevenCutController.text = unevenCutvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Overgrading')
                  if (overgradingSpec == true)
                    TextFormField(
                      controller: _overgradingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Overgrading',
                      ),
                      validator: (overgradingvalue) {
                        if (overgradingvalue!.isEmpty) {
                          _overgradingController.text = '0';
                        }
                        _overgradingController.text = overgradingvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Poor Packing')
                  if (poorPackingSpec == true)
                    TextFormField(
                      controller: _poorPackingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Poor Packing',
                      ),
                      validator: (poorPackingvalue) {
                        if (poorPackingvalue!.isEmpty) {
                          _poorPackingController.text = '0';
                        }
                        _poorPackingController.text = poorPackingvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'overcount')
                  if (overcountSpec == true)
                    TextFormField(
                      controller: _overcountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Overcount',
                      ),
                      validator: (overcountvalue) {
                        if (overcountvalue!.isEmpty) {
                          _overcountController.text = '0';
                        }
                        _overcountController.text = overcountvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Under count')
                  if (undercountSpec == true)
                    TextFormField(
                      controller: _undercountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Undercount',
                      ),
                      validator: (undercountvalue) {
                        if (undercountvalue!.isEmpty) {
                          _undercountController.text = '0';
                        }
                        _undercountController.text = undercountvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  // if (selectedCrop?.specsName == 'Big leaves')
                  if (bigLeavesSpec == true)
                    TextFormField(
                      controller: _bigLeavesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Big Leaves',
                      ),
                      validator: (bigLeavesvalue) {
                        if (bigLeavesvalue!.isEmpty) {
                          _bigLeavesController.text = '0';
                        }
                        _bigLeavesController.text = bigLeavesvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Small leaves')
                  if (smallLeavesSpec == true)
                    TextFormField(
                      controller: _smallLeavesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Small Leaves',
                      ),
                      validator: (smallLeavesvalue) {
                        if (smallLeavesvalue!.isEmpty) {
                          _smallLeavesController.text = '0';
                        }
                        _smallLeavesController.text = smallLeavesvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'cutting-big')
                  if (bigCuttingsSpec == true)
                    TextFormField(
                      controller: _bigCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Big Cuttings',
                      ),
                      validator: (bigCuttingsvalue) {
                        if (bigCuttingsvalue!.isEmpty) {
                          _bigCuttingsController.text = '0';
                        }
                        _bigCuttingsController.text = bigCuttingsvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  //if (selectedCrop?.specsName == 'Cutting-Small')
                  if (smallCuttingsSpec == true)
                    TextFormField(
                      controller: _smallCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Small Cuttings',
                      ),
                      validator: (smallCuttingsvalue) {
                        if (smallCuttingsvalue!.isEmpty) {
                          _smallCuttingsController.text = '0';
                        }
                        _smallCuttingsController.text = smallCuttingsvalue;
                        return null;
                      },
                    ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _totalMistakesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Total mistakes',
                    ),
                  ),
                  const Divider(
                    height: 8.0,
                  ),
                  SizedBox(
                    height: 55.0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _onSave();
                          }
                        },
                        child: const Text(
                          'Save the data',
                          style: TextStyle(
                            fontSize: 16.0,
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
    );
  }

  void onCropChange(crop) {
    setState(() {
      selectedCrop = crop;
      varieties = [];
      selectedVariety = null;
    });
    String endpoint = "$varietyUrl/${selectedCrop?.id}";

    listVariety(endpoint).then((List<VarietyModel> value) {
      setState(() {
        value.retainWhere((VarietyModel varietyObject) =>
            varietyObject.cropName == selectedCrop?.cropName);
        varieties = value;
      });
    });

    listCropSpec().then((List<CropSpecs> value) {
      setState(() {
        value.retainWhere((CropSpecs cropspecObject) =>
            cropspecObject.cropName == selectedCrop?.cropName);
        specslist = value;

        var specsList = specslist.map((CropSpecs cropspecObject) {
          return cropspecObject.specsName;
        }).toList();
        // devtools.log(specsList.toString());
        thickCuttingsSpec =
            specsList.any((element) => element == 'Cuttings - Too Thick');
        thinCuttingsSpec =
            specsList.any((element) => element == 'Cuttings - Too Thin');
        longCuttingsSpec =
            specsList.any((element) => element == 'Cuttings - Too Long');
        shortCuttingsSpec =
            specsList.any((element) => element == 'Cuttings - Too short');
        hardCuttingsSpec =
            specsList.any((element) => element == 'Cuttings - Too Hard');
        softCuttingsSpec =
            specsList.any((element) => element == 'Cuttings - Too Soft');
        moreLeavesSpec = specsList.any((element) => element == 'Leaves - More');
        lessLeavesSpec = specsList.any((element) => element == 'Leaves - Less');
        longPetioleSpec =
            specsList.any((element) => element == 'Petiole - Long');
        shortPetioleSpec =
            specsList.any((element) => element == 'Petiole - Short');
        overmatureSpec =
            specsList.any((element) => element == 'Cuttings - Overmature');
        immatureSpec =
            specsList.any((element) => element == 'Cuttings - Immature');
        shortStickingSpec =
            specsList.any((element) => element == 'Short Sticking Length');
        damagedLeafSpec = specsList.any((element) => element == 'Damaged Leaf');
        mechanicalDamageSpec =
            specsList.any((element) => element == 'Mechanical damage');
        diseaseDamageSpec =
            specsList.any((element) => element == 'Disease damage');
        insectDamageSpec =
            specsList.any((element) => element == 'Insect Damage');
        chemicalDamageSpec =
            specsList.any((element) => element == 'Chemical Damage');
        heelLeafSpec = specsList.any((element) => element == 'Heel Leaf');
        mutationSpec = specsList.any((element) => element == 'Mutation');
        blindShootsSpec = specsList.any((element) => element == 'Blind Shoots');
        budsSpec = specsList.any((element) => element == 'Buds');
        poorHormoningSpec =
            specsList.any((element) => element == 'Poor Hormoning');
        unevenCutSpec = specsList.any((element) => element == 'Uneven Cut');
        overgradingSpec = specsList.any((element) => element == 'Overgrading');
        poorPackingSpec = specsList.any((element) => element == 'Poor Packing');
        overcountSpec = specsList.any((element) => element == 'overcount');
        undercountSpec = specsList.any((element) => element == 'Under count');
        bigLeavesSpec = specsList.any((element) => element == 'Big leaves');
        smallLeavesSpec = specsList.any((element) => element == 'Small leaves');
        bigCuttingsSpec = specsList.any((element) => element == 'cutting-big');
        smallCuttingsSpec =
            specsList.any((element) => element == 'Cutting-Small');
      });
    });
  }

  void onVarietyChange(variety) {
    setState(() {
      selectedVariety = variety;
      varietyId = selectedVariety?.id;
    });
  }

  Future<List<VarietyModel>> listVariety(String endpoint) async {
    String fileName = 'varietyString.json';
    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/$fileName");
    if (file.existsSync()) {
      devtools.log('Fetching varieties data from local cache');
      final data = file.readAsStringSync();
      List jsonResponse = json.decode(data);
      return jsonResponse.map((data) => VarietyModel.fromJson(data)).toList();
    } else {
      devtools.log('Fetching varieties data from server');
      final response = await http.get(Uri.parse(
          'http://quality-assurance-app.herokuapp.com/api/v1/varieties'));
      if (response.statusCode == 200) {
        final body = response.body;

        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => VarietyModel.fromJson(data)).toList();
      } else {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => VarietyModel.fromJson(data)).toList();
      }
    }
  }

  Future<List<CropSpecsModel>> listCrop() async {
    String fileName = 'pathString.json';
    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/$fileName");
    if (file.existsSync()) {
      // print('Fetching crops data from local cache');
      devtools.log('Fetching crops data from local cache');
      final data = file.readAsStringSync();
      List jsonResponse = json.decode(data);
      return jsonResponse.map((data) => CropSpecsModel.fromJson(data)).toList();
    } else {
      // print('Fetching crops data from server');
      devtools.log('Fetching crops data from server');
      final response = await http.get(
          // Uri.parse('http://10.0.2.2:8000/api/v1/crops'));
          Uri.parse('http://quality-assurance-app.herokuapp.com/api/v1/crops'));

      if (response.statusCode == 200) {
        final body = response.body;

        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => CropSpecsModel.fromJson(data))
            .toList();
      } else {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => CropSpecsModel.fromJson(data))
            .toList();
      }
    }
  }

  Future<List<CropSpecs>> listCropSpec() async {
    String fileName = 'v2pathString.json';
    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/$fileName");
    if (file.existsSync()) {
      // print('Fetching crops data from local cache');
      devtools.log('Fetching crops data from local cache');
      final data = file.readAsStringSync();
      List jsonResponse = json.decode(data);
      return jsonResponse.map((data) => CropSpecs.fromJson(data)).toList();
    } else {
      // print('Fetching crops data from server');
      devtools.log('Fetching crop-spec data from server');
      final response = await http.get(
          // Uri.parse('http://10.0.2.2:8000/api/v1/crops'));
          Uri.parse(
              'http://quality-assurance-app.herokuapp.com/api/v1/crop-spec'));

      if (response.statusCode == 200) {
        final body = response.body;

        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => CropSpecs.fromJson(data)).toList();
      } else {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => CropSpecs.fromJson(data)).toList();
      }
    }
  }
}
