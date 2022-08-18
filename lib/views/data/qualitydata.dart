import 'package:flutter/material.dart';
import 'package:qadata/views/data/qadata.dart';

class QualityDataView extends StatelessWidget {
  final Data data;
  const QualityDataView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quality Data'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Quality Monitor: ${data.qaMonitorName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Harvester\'s Clock Number: ${data.clockNumber}'),
                  Text('Harvester\'s Name: ${data.harvesterName}'),
                  Text('Crop Name: ${data.cropName}'),
                  Text('Variety Code: ${data.varietyCode}'),
                  Text('Variety Name: ${data.varietyName}'),
                  Text('Quantity Checked: ${data.quantityChecked}'),
                  Text(
                    'Total Mistakes: ${data.totalMistakes}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,),),
                  Text('Thick Cuttings: ${data.thickCuttings}'),
                  Text('Thin Cuttings: ${data.thinCuttings}'),
                  Text('Long Cuttings: ${data.longCuttings}'),
                  Text('Short Cuttings: ${data.shortCuttings}'),
                  Text('Hard Cuttings: ${data.hardCuttings}'),
                  Text('Soft Cuttings: ${data.softCuttings}'),
                  Text('More Leaves: ${data.moreLeaves}'),
                  Text('Short Leaves: ${data.lessLeaves}'),
                  Text('Long Petioles: ${data.longPetiole}'),
                  Text('Short Petioles: ${data.shortPetiole}'),
                  Text('Overmature Cuttings: ${data.overmature}'),
                  Text('Immature Cuttings: ${data.immature}'),
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
