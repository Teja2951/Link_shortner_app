import 'dart:io';

import 'package:cofffe/link.dart';
import 'package:hive/hive.dart';

class Database {
  List Links = [];

  final _mybox = Hive.box('meraData');


  void loadData() {
    var loadedData = _mybox.get('key');
  if (loadedData != null && loadedData is List) {
    Links = List.from(loadedData);
  } else {
    Links = [];
  }
  }

  void addData(List a) {
    _mybox.put('key', a);
  }

  void saveData() {
    _mybox.put('key', Links);
    print(Links);
  }
}