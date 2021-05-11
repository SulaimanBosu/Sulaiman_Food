import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sulaimanfood/model/cart_model.dart';

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

  Future<Database> connectedDatabase() async {
    return openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertDataToSQLite(CartModel cartModel) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        tableDatabase,
        cartModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('$e insertData ==> ${e.toString()}');
    }
  }


  Future<List<CartModel>> readDataFromSQLite() async{
      Database database = await connectedDatabase();
      // ignore: deprecated_member_use
      List<CartModel> cartModels =List();

      List<Map<String, dynamic>> maps = await database.query(tableDatabase);

      for (var map in maps) {
        CartModel cartModel = CartModel.fromJson(map);
        cartModels.add(cartModel);
      }
      
      return cartModels;
  }

  Future<Null> deleteData(int orderId)async{
    Database database = await connectedDatabase();
    try {
      await database.delete(tableDatabase,where: '$orderid = $orderId');
    } catch (e) {
      print('e delete ==> ${e.toString()}');
    }
  }

  Future<Null> deleteAllData() async{
    Database database = await connectedDatabase();
    try {
      await database.delete(tableDatabase);
    } catch (e) {
      print('e deleteAllData ==> ${e.toString()}');
    }
  }
}
