import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'products.db');
    return await openDatabase(
      path,
      version: 2, // Versi dinaikkan ke 2 agar tabel baru otomatis terbuat
      onCreate: (db, version) async {
        // 1. Membuat tabel master products
        await db.execute('''
          CREATE TABLE products(
            id TEXT PRIMARY KEY,
            name TEXT,
            price REAL,
            description TEXT,
            imagePath TEXT
          )
        ''');

        // 2. Membuat tabel local_cart
        await db.execute('''
          CREATE TABLE local_cart(
            id TEXT PRIMARY KEY,
            product_id TEXT,
            name TEXT,
            price REAL,
            quantity INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE local_cart(
              id TEXT PRIMARY KEY,
              product_id TEXT,
              name TEXT,
              price REAL,
              quantity INTEGER
            )
          ''');
        }
      },
    );
  }

  // ==================== METHOD PRODUK ====================
  static Future<int> insertProduct(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('products', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }

  static Future<int> deleteProduct(String id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== METHOD KERANJANG (CART) ====================
  static Future<int> insertCart(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('local_cart', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getCart() async {
    final db = await database;
    return await db.query('local_cart');
  }

  static Future<int> deleteCartItem(String id) async {
    final db = await database;
    return await db.delete('local_cart', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> clearCart() async {
    final db = await database;
    return await db.delete('local_cart');
  }
}