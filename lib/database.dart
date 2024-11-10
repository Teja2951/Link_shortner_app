import 'package:cofffe/link.dart';
import 'package:hive/hive.dart';

class Database {
  List Links = [];

  final _mybox = Hive.box('meraData');

  void loadData() {
    Links = _mybox.get('key');
  }

  void addData(List a) {
    _mybox.put('key', a);
  }

  void saveData() {
    _mybox.put('key', Links);
    print(Links);
  }
}