
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:cafe_app/models/Product.dart';
import 'package:path/path.dart';

import '../models/ProductItem.dart';


class DBHelper{
  static Database? _db;

  Future<Database?> get db async{
    if (_db != null) {
      return _db;
    }
    
    _db = await initDatabase();
  }
  
  initDatabase() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version)async {
    await db.execute(
     'CREATE TABLE cart(cart_id INTEGER PRIMARY KEY, id INTERGER, title VARCHAR, desc VARCHAR, price DOUBLE, image STRING, quantity INTEGER )'
    );
  }

  Future<ProductItem> insert(ProductItem productItem) async{
    
    var dbClient = await db;

    // await dbClient!.insert('cart',productItem.toMap());

    return productItem;
  }
}

