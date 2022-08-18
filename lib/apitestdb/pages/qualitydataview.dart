import 'package:flutter/material.dart';
import 'package:qadata/apitestdb/model/data_model.dart';

class DataView extends StatelessWidget {
  final Data data;
  const DataView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quality Data'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Quality Monitor: ${data.qamonitorId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Harvester\'s Id: ${data.userId}'),
                  Text('Variety Id: ${data.varietyId}'),
                  Text('Quantity Checked: ${data.quantityChecked}'),
                  Text(
                    'Total Mistakes: ${data.totalMistakes}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,),),
                  Text('Thick Cuttings: ${data.cuttingsTooThick}'),
                  Text('Thin Cuttings: ${data.cuttingsTooThin}'),
                  Text('Long Cuttings: ${data.cuttingsTooLong}'),
                  Text('Short Cuttings: ${data.cuttingsTooShort}'),
                  Text('Hard Cuttings: ${data.cuttingsTooHard}'),
                  Text('Soft Cuttings: ${data.cuttingsTooSoft}'),
                  Text('More Leaves: ${data.moreLeaves}'),
                  Text('Short Leaves: ${data.lessLeaves}'),
                  Text('Long Petioles: ${data.longPetiole}'),
                  Text('Short Petioles: ${data.shortPetiole}'),
                  Text('Overmature Cuttings: ${data.overmatureCuttings}'),
                  Text('Immature Cuttings: ${data.immatureCuttings}'),
                  Text('Short Sticking Length: ${data.shortStickingLength}'),
                  Text('Damaged Leaves: ${data.damagedLeaf}'),
                  Text('Mechanical Damages: ${data.mechanicalDamage}'),
                  Text('Disease Damages: ${data.diseaseDamage}'),
                  Text('Insect Damage: ${data.insectDamage}'),
                  Text('Chemical Damages: ${data.chemicalDamage}'),
                  Text('Heel Leaves: ${data.heelLeaf}'),
                  Text('Mutation: ${data.mutation}'),
                  Text('Blind Shoots: ${data.blindShoots}'),
                  Text('Buds: ${data.buds}'),
                  Text('Poor Hormoning: ${data.poorHormoning}'),
                  Text('Uneven Cuts: ${data.unevenCut}'),
                  Text('Overgrading: ${data.overgrading}'),
                  Text('Poor Packing: ${data.poorPacking}'),
                  Text('Overcount: ${data.overcount}'),
                  Text('Undercount: ${data.undercount}'),
                  Text('Big Leaves: ${data.bigLeaves}'),
                  Text('Small Leaves: ${data.smallLeaves}'),
                  Text('Big Cuttings: ${data.bigCuttings}'),
                  Text('Small Cuttings: ${data.smallCuttings}'),
                  Text('Time uploaded: ${data.createdAt}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
