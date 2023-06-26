
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveServiceProvider extends ChangeNotifier {

  //Create table
  var taskBox = Hive.box('taskBox');
  List<Map<String, dynamic>> taskList = [];

  //Insert Data
  insertData(Map<String, dynamic> data) async {
    await taskBox.add(data);
    getData();
    notifyListeners();
    print('------------Data Inserted-------------');
  }

  //Update Data
  updateData(int? key, Map<String, dynamic> data) async {
    await taskBox.put(key, data);
    getData();
    notifyListeners();
    print('------------Data Updated-------------');
  }

  //Delete Data
  deleteData(int? key) async {
    await taskBox.delete(key);
    getData();
    notifyListeners();
    print('------------Data Deleted-------------');
  }

  //Get Data
  getData() async {
    var data = taskBox.keys.map((key) {
      final item = taskBox.get(key);
      return {
        'key': key,
        'title': item['title'],
        'task': item['task'],
      };
    }).toList();
    taskList = data.reversed.toList();
    //print('------------Data: $taskList');
  }



}

