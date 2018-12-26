 pubspec.yaml
 
   # add this two package
   dependencies:
      path_provider: any
      sqflite: any
 
   #DB_Assets is directory name and WordGame.db is locate in my DB_Assets directory
   assets:
      - DB_Assets/WordGame.db


import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper{

  static Database _db;

  Future<Database> get db async {
    _db = await initDb();
    return _db;
  }

  initDb() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "new_word_game_db.db");

    await deleteDatabase(path);
    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('DB_Assets', 'WordGame.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'new_word_game_db.db');
    var db = await openDatabase(databasePath);

    return db;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT (*) FROM tbl_points")
    );
    print(result);
    return result;

  }
}
