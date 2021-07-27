import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppSqliteDb {
  static Database? sqliteDb;
  static String sqliteDbName = 'db1.db';

  static Future init() async {
    String databasesPath = await getDatabasesPath();
    String userDBPath = join(databasesPath, '$sqliteDbName');
    sqliteDb = await openDatabase(
      userDBPath,
      version: 1,
      onCreate: (Database db, int version) async {
        db.execute('''CREATE TABLE IF NOT EXISTS user_contacts (
          name TEXT,
        mobileNumber INTEGER,
        )''');
      },
    );
  }
}
