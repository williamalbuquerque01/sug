import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sug/services/employees_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var list;

  @override
  void initState() {
    //Future.delayed(Duration(seconds: 10),() async {
    list = EmployeesService().list();
    //});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white60,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.redAccent,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
      body: FutureBuilder(
        future: list,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            EmployeeData datatable = EmployeeData(data);
            return Column(
              children: [
                PaginatedDataTable(
                  header: const Text('Servidores Ativos'),
                  columns: const [
                    DataColumn(label: Text('Código')),
                    DataColumn(label: Text('Matrícula')),
                    DataColumn(label: Text('Nome')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Emprego')),
                  ],
                  source: datatable,
                  columnSpacing: 10,
                  horizontalMargin: 10,
                  rowsPerPage: 9,
                  showCheckboxColumn: false,
                )
              ],
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: Text(
                'Um erro ocorreu!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              content: Text(
                "${snapshot.error}",
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Voltar',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Isto pode demorar algum tempo...')
              ],
            ),
          );
        },
      )
    );
  }
}

class EmployeeData extends DataTableSource {
  var _data;
  EmployeeData(this._data)  {}

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['code'].toString(), style: TextStyle(fontSize: 10))),
      DataCell(Text(_data[index]['registration'].toString(), style: TextStyle(fontSize: 10))),
      DataCell(Text(_data[index]['name'].toString(), style: TextStyle(fontSize: 10))),
      DataCell(Text(_data[index]['status'].toString(), style: TextStyle(fontSize: 10))),
      DataCell(Text(_data[index]['role'].toString(), style: TextStyle(fontSize: 10))),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

