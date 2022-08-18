import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qadata/vandad/services/crud/data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as devtools;

class NewDataView extends StatefulWidget {
  const NewDataView({Key? key}) : super(key: key);

  @override
  State<NewDataView> createState() => _NewDataViewState();
}

class _NewDataViewState extends State<NewDataView> {
  int qamonitorId = 0;
  int clockNumber = 0000;
  String firstname = '';
  String lastname = '';
  String email = '';

  DatabaseData? _data;
  late final DataService _dataService;
  late final TextEditingController _harvesterController;
  late final TextEditingController _varietyController;
  late final TextEditingController _quantityController;
  late final TextEditingController _totalController;
  late final TextEditingController _thickController;
  late final TextEditingController _thinController;
  late final TextEditingController _longCuttingsController;
  late final TextEditingController _shortCuttingsController;
  late final TextEditingController _hardController;
  late final TextEditingController _softController;
  late final TextEditingController _moreLeavesController;
  late final TextEditingController _lessLeavesController;
  late final TextEditingController _longPetioleController;
  late final TextEditingController _shortPetioleController;
  late final TextEditingController _overmatureController;
  late final TextEditingController _immatureController;
  late final TextEditingController _shortStickingController;
  late final TextEditingController _damagedLeafController;
  late final TextEditingController _mechanicalDamageController;
  late final TextEditingController _diseaseDamageController;
  late final TextEditingController _insectDamageController;
  late final TextEditingController _chemicalDamageController;
  late final TextEditingController _heelLeafController;
  late final TextEditingController _mutationController;
  late final TextEditingController _blindShootsController;
  late final TextEditingController _budsController;
  late final TextEditingController _poorHormoningController;
  late final TextEditingController _unevenCutController;
  late final TextEditingController _overgradingController;
  late final TextEditingController _poorPackingController;
  late final TextEditingController _overcountController;
  late final TextEditingController _undercountController;
  late final TextEditingController _bigLeavesController;
  late final TextEditingController _smallLeavesController;
  late final TextEditingController _bigCuttingsController;
  late final TextEditingController _smallCuttingsController;

  @override
  void initState() {
    _dataService = DataService();
    _harvesterController = TextEditingController();
    _varietyController = TextEditingController();
    _quantityController = TextEditingController();
    _totalController = TextEditingController();
    _thickController = TextEditingController();
    _thinController = TextEditingController();
    _longCuttingsController = TextEditingController();
    _shortCuttingsController = TextEditingController();
    _hardController = TextEditingController();
    _softController = TextEditingController();
    _moreLeavesController = TextEditingController();
    _lessLeavesController = TextEditingController();
    _longPetioleController = TextEditingController();
    _shortPetioleController = TextEditingController();
    _overmatureController = TextEditingController();
    _immatureController = TextEditingController();
    _shortStickingController = TextEditingController();
    _damagedLeafController = TextEditingController();
    _mechanicalDamageController = TextEditingController();
    _diseaseDamageController = TextEditingController();
    _insectDamageController = TextEditingController();
    _chemicalDamageController = TextEditingController();
    _heelLeafController = TextEditingController();
    _mutationController = TextEditingController();
    _blindShootsController = TextEditingController();
    _budsController = TextEditingController();
    _poorHormoningController = TextEditingController();
    _unevenCutController = TextEditingController();
    _overgradingController = TextEditingController();
    _poorPackingController = TextEditingController();
    _overcountController = TextEditingController();
    _undercountController = TextEditingController();
    _bigLeavesController = TextEditingController();
    _smallLeavesController = TextEditingController();
    _bigCuttingsController = TextEditingController();
    _smallCuttingsController = TextEditingController();
    _loadUserData();
    super.initState();
  }

  void _textControllerListener() async {
    final data = _data;
    if (data == null) {
      return;
    }
    final harvesterId = int.parse(_harvesterController.text);
    final varietyId = int.parse(_varietyController.text);
    final quantityChecked = int.parse(_quantityController.text);
    final totalMistakes = int.parse(_totalController.text);
    final thickCuttings = int.parse(_thickController.text);
    final thinCuttings = int.parse(_thinController.text);
    final longCuttings = int.parse(_longCuttingsController.text);
    final shortCuttings = int.parse(_shortCuttingsController.text);
    final hardCuttings = int.parse(_hardController.text);
    final softCuttings = int.parse(_softController.text);
    final moreLeaves = int.parse(_moreLeavesController.text);
    final lessLeaves = int.parse(_lessLeavesController.text);
    final longPetiole = int.parse(_longPetioleController.text);
    final shortPetiole = int.parse(_shortPetioleController.text);
    final overmatureCuttings = int.parse(_overmatureController.text);
    final immatureCuttings = int.parse(_immatureController.text);
    final shortStickingLength = int.parse(_shortStickingController.text);
    final damagedLeaf = int.parse(_damagedLeafController.text);
    final mechanicalDamage = int.parse(_mechanicalDamageController.text);
    final diseaseDamage = int.parse(_diseaseDamageController.text);
    final insectDamage = int.parse(_insectDamageController.text);
    final chemicalDamage = int.parse(_chemicalDamageController.text);
    final heelLeaf = int.parse(_heelLeafController.text);
    final mutation = int.parse(_mutationController.text);
    final blindShoots = int.parse(_blindShootsController.text);
    final buds = int.parse(_budsController.text);
    final poorHormoning = int.parse(_poorHormoningController.text);
    final unevenCut = int.parse(_unevenCutController.text);
    final overgrading = int.parse(_overgradingController.text);
    final poorPacking = int.parse(_poorPackingController.text);
    final overcount = int.parse(_overcountController.text);
    final undercount = int.parse(_undercountController.text);
    final bigLeaves = int.parse(_bigLeavesController.text);
    final smallLeaves = int.parse(_smallLeavesController.text);
    final bigCuttings = int.parse(_bigCuttingsController.text);
    final smallCuttings = int.parse(_smallCuttingsController.text);
    try {
      await _dataService.updateData(
        data: data,
        harvesterId: harvesterId,
        varietyId: varietyId,
        quantityChecked: quantityChecked,
        totalMistakes: totalMistakes,
        thickCuttings: thickCuttings,
        thinCuttings: thinCuttings,
        longCuttings: longCuttings,
        shortCuttings: shortCuttings,
        hardCuttings: hardCuttings,
        softCuttings: softCuttings,
        moreLeaves: moreLeaves,
        lessLeaves: lessLeaves,
        longPetiole: longPetiole,
        shortPetiole: shortPetiole,
        overmatureCuttings: overmatureCuttings,
        immatureCuttings: immatureCuttings,
        shortStickingLength: shortStickingLength,
        damagedLeaf: damagedLeaf,
        mechanicalDamage: mechanicalDamage,
        diseaseDamage: diseaseDamage,
        insectDamage: insectDamage,
        chemicalDamage: chemicalDamage,
        heelLeaf: heelLeaf,
        mutation: mutation,
        blindShoots: blindShoots,
        buds: buds,
        poorHormoning: poorHormoning,
        unevenCut: unevenCut,
        overgrading: overgrading,
        poorPacking: poorPacking,
        overcount: overcount,
        undercount: undercount,
        bigLeaves: bigLeaves,
        smallLeaves: smallLeaves,
        bigCuttings: bigCuttings,
        smallCuttings: smallCuttings,
      );
    } on FormatException catch (e) {
      devtools.log(softCuttings.toString());
      devtools.log(e.message);
    }
  }

  void _setupTextControllerListener() {
    _harvesterController.removeListener(_textControllerListener);
    _harvesterController.addListener(_textControllerListener);
    _varietyController.removeListener(_textControllerListener);
    _varietyController.addListener(_textControllerListener);
    _quantityController.removeListener(_textControllerListener);
    _quantityController.addListener(_textControllerListener);
    _totalController.removeListener(_textControllerListener);
    _totalController.addListener(_textControllerListener);
    _thickController.removeListener(_textControllerListener);
    _thickController.addListener(_textControllerListener);
    _thinController.removeListener(_textControllerListener);
    _thinController.addListener(_textControllerListener);
    _longCuttingsController.removeListener(_textControllerListener);
    _longCuttingsController.addListener(_textControllerListener);
    _shortCuttingsController.removeListener(_textControllerListener);
    _shortCuttingsController.addListener(_textControllerListener);
    _hardController.removeListener(_textControllerListener);
    _hardController.addListener(_textControllerListener);
    _softController.removeListener(_textControllerListener);
    _softController.addListener(_textControllerListener);
    _moreLeavesController.removeListener(_textControllerListener);
    _moreLeavesController.addListener(_textControllerListener);
    _lessLeavesController.removeListener(_textControllerListener);
    _lessLeavesController.addListener(_textControllerListener);
    _longPetioleController.removeListener(_textControllerListener);
    _longPetioleController.addListener(_textControllerListener);
    _shortPetioleController.removeListener(_textControllerListener);
    _shortPetioleController.addListener(_textControllerListener);
    _overmatureController.removeListener(_textControllerListener);
    _overmatureController.addListener(_textControllerListener);
    _immatureController.removeListener(_textControllerListener);
    _immatureController.addListener(_textControllerListener);
    _shortStickingController.removeListener(_textControllerListener);
    _shortStickingController.addListener(_textControllerListener);
    _damagedLeafController.removeListener(_textControllerListener);
    _damagedLeafController.addListener(_textControllerListener);
    _mechanicalDamageController.removeListener(_textControllerListener);
    _mechanicalDamageController.addListener(_textControllerListener);
    _diseaseDamageController.removeListener(_textControllerListener);
    _diseaseDamageController.addListener(_textControllerListener);
    _insectDamageController.removeListener(_textControllerListener);
    _insectDamageController.addListener(_textControllerListener);
    _chemicalDamageController.removeListener(_textControllerListener);
    _chemicalDamageController.addListener(_textControllerListener);
    _heelLeafController.removeListener(_textControllerListener);
    _heelLeafController.addListener(_textControllerListener);
    _mutationController.removeListener(_textControllerListener);
    _mutationController.addListener(_textControllerListener);
    _blindShootsController.removeListener(_textControllerListener);
    _blindShootsController.addListener(_textControllerListener);
    _budsController.removeListener(_textControllerListener);
    _budsController.addListener(_textControllerListener);
    _poorHormoningController.removeListener(_textControllerListener);
    _poorHormoningController.addListener(_textControllerListener);
    _unevenCutController.removeListener(_textControllerListener);
    _unevenCutController.addListener(_textControllerListener);
    _overgradingController.removeListener(_textControllerListener);
    _overgradingController.addListener(_textControllerListener);
    _poorPackingController.removeListener(_textControllerListener);
    _poorPackingController.addListener(_textControllerListener);
    _overcountController.removeListener(_textControllerListener);
    _overcountController.addListener(_textControllerListener);
    _undercountController.removeListener(_textControllerListener);
    _undercountController.addListener(_textControllerListener);
    _bigLeavesController.removeListener(_textControllerListener);
    _bigLeavesController.addListener(_textControllerListener);
    _smallLeavesController.removeListener(_textControllerListener);
    _smallLeavesController.addListener(_textControllerListener);
    _bigCuttingsController.removeListener(_textControllerListener);
    _bigCuttingsController.addListener(_textControllerListener);
    _smallCuttingsController.removeListener(_textControllerListener);
    _smallCuttingsController.addListener(_textControllerListener);
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user') ?? '');

    if (user != null) {
      setState(() {
        qamonitorId = user['id'];
        clockNumber = user['clock_number'];
        firstname = user['firstname'];
        lastname = user['lastname'];
        email = user['email'];
      });
    }
    return email;
  }

  Future<DatabaseData> createNewData() async {
    final existingData = _data;
    if (existingData != null) {
      return existingData;
    }
    final owner = await _dataService.getUser(email: email);
    devtools.log(email);
    return await _dataService.createData(owner: owner);
  }

  void _deleteDataIfTextIsEmpty() {
    final data = _data;
    if (data != null) {
      _dataService.deleteData(id: data.id);
    }
  }

  void _saveDataIfTextNotEmpty() async {
    final data = _data;
    final harvesterId = int.parse(_harvesterController.text);
    final varietyId = int.parse(_varietyController.text);
    final quantityChecked = int.parse(_quantityController.text);
    final totalMistakes = int.parse(_totalController.text);
    final thickCuttings = int.parse(_thickController.text);
    final thinCuttings = int.parse(_thinController.text);
    final longCuttings = int.parse(_longCuttingsController.text);
    final shortCuttings = int.parse(_shortCuttingsController.text);
    final hardCuttings = int.parse(_hardController.text);
    final softCuttings = int.parse(_softController.text);
    final moreLeaves = int.parse(_moreLeavesController.text);
    final lessLeaves = int.parse(_lessLeavesController.text);
    final longPetiole = int.parse(_longPetioleController.text);
    final shortPetiole = int.parse(_shortPetioleController.text);
    final overmatureCuttings = int.parse(_overmatureController.text);
    final immatureCuttings = int.parse(_immatureController.text);
    final shortStickingLength = int.parse(_shortStickingController.text);
    final damagedLeaf = int.parse(_damagedLeafController.text);
    final mechanicalDamage = int.parse(_mechanicalDamageController.text);
    final diseaseDamage = int.parse(_diseaseDamageController.text);
    final insectDamage = int.parse(_insectDamageController.text);
    final chemicalDamage = int.parse(_chemicalDamageController.text);
    final heelLeaf = int.parse(_heelLeafController.text);
    final mutation = int.parse(_mutationController.text);
    final blindShoots = int.parse(_blindShootsController.text);
    final buds = int.parse(_budsController.text);
    final poorHormoning = int.parse(_poorHormoningController.text);
    final unevenCut = int.parse(_unevenCutController.text);
    final overgrading = int.parse(_overgradingController.text);
    final poorPacking = int.parse(_poorPackingController.text);
    final overcount = int.parse(_overcountController.text);
    final undercount = int.parse(_undercountController.text);
    final bigLeaves = int.parse(_bigLeavesController.text);
    final smallLeaves = int.parse(_smallLeavesController.text);
    final bigCuttings = int.parse(_bigCuttingsController.text);
    final smallCuttings = int.parse(_smallCuttingsController.text);
    if (data != null) {
      await _dataService.updateData(
        data: data,
        harvesterId: harvesterId,
        varietyId: varietyId,
        quantityChecked: quantityChecked,
        totalMistakes: totalMistakes,
        thickCuttings: thickCuttings,
        thinCuttings: thinCuttings,
        longCuttings: longCuttings,
        shortCuttings: shortCuttings,
        hardCuttings: hardCuttings,
        softCuttings: softCuttings,
        moreLeaves: moreLeaves,
        lessLeaves: lessLeaves,
        longPetiole: longPetiole,
        shortPetiole: shortPetiole,
        overmatureCuttings: overmatureCuttings,
        immatureCuttings: immatureCuttings,
        shortStickingLength: shortStickingLength,
        damagedLeaf: damagedLeaf,
        mechanicalDamage: mechanicalDamage,
        diseaseDamage: diseaseDamage,
        insectDamage: insectDamage,
        chemicalDamage: chemicalDamage,
        heelLeaf: heelLeaf,
        mutation: mutation,
        blindShoots: blindShoots,
        buds: buds,
        poorHormoning: poorHormoning,
        unevenCut: unevenCut,
        overgrading: overgrading,
        poorPacking: poorPacking,
        overcount: overcount,
        undercount: undercount,
        bigLeaves: bigLeaves,
        smallLeaves: smallLeaves,
        bigCuttings: bigCuttings,
        smallCuttings: smallCuttings,
      );
    }
  }

  @override
  void dispose() {
    _deleteDataIfTextIsEmpty();
    _saveDataIfTextNotEmpty();
    _harvesterController.dispose();
    _varietyController.dispose();
    _quantityController.dispose();
    _totalController.dispose();
    _thickController.dispose();
    _thinController.dispose();
    _longCuttingsController.dispose();
    _shortCuttingsController.dispose();
    _hardController.dispose();
    _softController.dispose();
    _moreLeavesController.dispose();
    _lessLeavesController.dispose();
    _longPetioleController.dispose();
    _shortPetioleController.dispose();
    _overmatureController.dispose();
    _immatureController.dispose();
    _shortStickingController.dispose();
    _damagedLeafController.dispose();
    _mechanicalDamageController.dispose();
    _diseaseDamageController.dispose();
    _insectDamageController.dispose();
    _chemicalDamageController.dispose();
    _heelLeafController.dispose();
    _mutationController.dispose();
    _blindShootsController.dispose();
    _budsController.dispose();
    _poorHormoningController.dispose();
    _unevenCutController.dispose();
    _overgradingController.dispose();
    _poorPackingController.dispose();
    _overcountController.dispose();
    _undercountController.dispose();
    _bigLeavesController.dispose();
    _smallLeavesController.dispose();
    _bigCuttingsController.dispose();
    _smallCuttingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Data'),
      ),
      body: FutureBuilder(
        future: createNewData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _data = snapshot.data as DatabaseData;
              _setupTextControllerListener();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _harvesterController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter Harvester ID',
                      ),
                    ),
                    TextField(
                      controller: _varietyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter Variety ID',
                      ),
                    ),
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Quantity Checked',
                      ),
                    ),
                    TextField(
                      controller: _totalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Total Mistakes',
                      ),
                    ),
                    TextField(
                      controller: _thickController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Thick Cuttings',
                      ),
                    ),
                    TextField(
                      controller: _thinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Thin Cuttings',
                      ),
                    ),
                    TextField(
                      controller: _longCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Long Cuttings',
                      ),
                    ),
                    TextField(
                      controller: _shortCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Short Cuttings',
                      ),
                    ),
                    TextField(
                      controller: _hardController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Hard Cuttings',
                      ),
                    ),
                    TextField(
                      controller: _softController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Soft Cuttings',
                      ),
                    ),
                    TextField(
                      controller: _moreLeavesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'More Leaves',
                      ),
                    ),
                    TextField(
                      controller: _lessLeavesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Less Leaves',
                      ),
                    ),
                    TextField(
                      controller: _longPetioleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Long Petiole',
                      ),
                    ),
                    TextField(
                      controller: _shortPetioleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Short Petiole',
                      ),
                    ),
                    TextField(
                      controller: _overmatureController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Overmature Cuttings',
                      ),
                    ),
                    TextField(
                      controller: _immatureController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Immature Cuttings',
                      ),
                    ),
                    TextField(
                      controller: _shortStickingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Short Sticking Length',
                      ),
                    ),
                    TextField(
                      controller: _damagedLeafController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Damaged Leaf',
                      ),
                    ),
                    TextField(
                      controller: _mechanicalDamageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Mechanical Damage',
                      ),
                    ),
                    TextField(
                      controller: _diseaseDamageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Disease Damage',
                      ),
                    ),
                    TextField(
                      controller: _insectDamageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Insect Damage',
                      ),
                    ),
                    TextField(
                      controller: _chemicalDamageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Chemical Damage',
                      ),
                    ),
                    TextField(
                      controller: _heelLeafController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Heel Leaf',
                      ),
                    ),
                    TextField(
                      controller: _mutationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Mutation',
                      ),
                    ),
                    TextField(
                      controller: _blindShootsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Blind Shoots',
                      ),
                    ),
                    TextField(
                      controller: _budsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Buds',
                      ),
                    ),
                    TextField(
                      controller: _poorHormoningController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Poor Hormoning',
                      ),
                    ),
                    TextField(
                      controller: _unevenCutController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Uneven Cut',
                      ),
                    ),
                    TextField(
                      controller: _overgradingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Overgrading',
                      ),
                    ),
                    TextField(
                      controller: _poorPackingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Poor Packing',
                      ),
                    ),
                    TextField(
                      controller: _overcountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Overcount',
                      ),
                    ),
                    TextField(
                      controller: _undercountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Undercount',
                      ),
                    ),
                    TextField(
                      controller: _bigLeavesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Big Leaves',
                      ),
                    ),
                    TextField(
                      controller: _smallLeavesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Small Leaves',
                      ),
                    ),
                    TextField(
                      controller: _bigCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Big Cuttings',
                      ),
                    ),
                    TextField(
                      controller: _smallCuttingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Small Cuttings',
                      ),
                    ),
                  ],
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
