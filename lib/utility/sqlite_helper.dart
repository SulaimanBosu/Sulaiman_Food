import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String nameDatabase = 'Sulaiman_food.db';
  final String tableDatabase = 'orderTABLE';
  int version = 1;
  final String orderid = 'Order_id';
  final String shopid = 'Shop_id';
  final String nameshop = 'Name_shop';
  final String foodid = 'Food_id';
  final String namefood = 'Food_Name';
  final String price = 'Price';
  final String amount = 'Amount';
  final String sum = 'Sum';
  final String distance = 'Distance';
  final String transport = 'Transport';

  SQLiteHelper() {
    initDatabase();
  }
  Future<Null> initDatabase() async {
    await openDatabase(
        join(
          await getDatabasesPath(),
          nameDatabase,
        ),
        onCreate: (db, version) => db.execute(
              'CREATE TABLE $tableDatabase ($orderid INTEGER PRIMARY KEY, $shopid TEXT, $nameshop TEXT, $foodid TEXT, $namefood TEXT, $price TEXT, $amount TEXT, $sum TEXT, $distance TEXT, $transport TEXT)',
            ),
        version: version);
  }
}
