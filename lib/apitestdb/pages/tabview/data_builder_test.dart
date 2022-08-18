import 'package:flutter/material.dart';
import 'package:qadata/apitestdb/model/data_model.dart';
import 'package:qadata/apitestdb/pages/qualitydataview.dart';
import 'package:qadata/dataentrytests/services/database_service.dart';
// import 'package:qadata/dataentrytests/models/variety.dart';

class DataBuilder extends StatelessWidget {
  const DataBuilder({
    Key? key,
    required this.future,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);
  final Future<List<Data>> future;
  final Function(Data) onEdit;
  final Function(Data) onDelete;

  Future<String> getCropName(int id) async {
    final DatabaseService databaseService = DatabaseService();
    final crop = await databaseService.crop(id);
    return crop.cropName;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data![index];
              return _buildVarietyCard(data, context, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildVarietyCard(Data data, BuildContext context, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                tileColor: Colors.grey[100],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataView(
                        data: data,
                      ),
                    ),
                  );
                },
                leading: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 16.0),
                ),
                title: Text('Harvester ID: ${data.userId}'),
                subtitle: Text(
                    '''Total Mistakes: ${data.totalMistakes}
Quantity Checked: ${data.quantityChecked}
Date: ${data.createdAt}'''),
                // style: ,
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onEdit(data),
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.edit,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onDelete(data),
              child: Container(
                height: 20.0,
                width: 20.0,
                alignment: Alignment.center,
                child: Icon(
                  Icons.delete,
                  color: Colors.red[400],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
