// import 'dart:io';

// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper{
//   static Future<Database> _init() async {
//     // Get the storage path from the device [/storage/emulated/0/Android/data/com.example.app_3/files]
//     final externalPath = await getExternalStorageDirectory();

//     if (externalPath == null) {
//       // String createPath = join("Android", "data", "com.example.app_3", "files");
//       throw PathNotFoundException(externalPath!.path, const OSError("No directory found"));
//     }
    
//     // Created db file in that location
//     String dbFilePath = join(externalPath.path, "db", "pasumai.db");
//     File? dbFile = File(dbFilePath);
//     if (!dbFile.existsSync()) {
//       dbFile.createSync(recursive: true);
//     }
//      Database db = await openDatabase(
//       dbFile.path,
//       version:3,
//       readOnly: false,
//       onCreate: (Database db, version) async {
//        await  db.execute('''
//         create table customer (
//         id integer primary key autoincrement,
//         first_name text not null,
//         last_name text not null,
//         email text not null,
//         mobile_no text not null
//         )
//       ''');
//       },
//     );
//     return db;
//   } 
  
//   // Store Users in the database
//   static Future<void> storeUsers(Map<String, dynamic> customer) async {
//     Database db = await _init();
//     // Insert the User to the customer table
//     await db.insert('customer', customer, conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   // Get all the customers in the list
//   static Future<void> getCustomers() async {
//     Database db = await _init();
//     List<Map<String, dynamic>> customers = await db.query("customer");
//     print(customers);
//   }
  
// }                        
