import 'package:hive/hive.dart';

class HiveDB{
  static String dbName = "db_firebase";
  static var box = Hive.box(dbName);

  static storeIdUser(String id)async{
    box.put("id", id);
  }

  static String loadIdUser(){
    String id = box.get("id");
    return id;
  }

  static Future<void> removeIdUser()async{
    await box.delete("id");
  }
}