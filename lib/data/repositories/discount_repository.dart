import 'package:sqflite/sqflite.dart';
import 'package:app_descuento_virtual_olga/data/models/discount.dart';
import '../database/database_helper.dart';

abstract class IDiscountRepository {
  Future<List<Discount>> getAll();
  Future<Discount?> getById(int id);
  Future<int> insert(Discount discount);
  Future<int> update(Discount discount);
  Future<int> delete(int id);
  Future<List<Discount>> getFavorites();
  Future<List<Discount>> search(String query);
  Future<int> toggleFavorite(int id, bool isFavorite);
}

class DiscountRepository implements IDiscountRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<List<Discount>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableDiscounts,
      orderBy: '${DatabaseHelper.colCreatedAt} DESC',
    );
    return maps.map((map) => Discount.fromMap(map)).toList();
  }

  @override
  Future<Discount?> getById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableDiscounts,
      where: '${DatabaseHelper.colId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Discount.fromMap(maps.first);
  }

  @override
  Future<int> insert(Discount discount) async {
    final db = await _dbHelper.database;
    return await db.insert(
      DatabaseHelper.tableDiscounts,
      discount.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> update(Discount discount) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.tableDiscounts,
      discount.toMap(),
      where: '${DatabaseHelper.colId} = ?',
      whereArgs: [discount.id],
    );
  }

  @override
  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableDiscounts,
      where: '${DatabaseHelper.colId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Discount>> getFavorites() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableDiscounts,
      where: '${DatabaseHelper.colIsFavorite} = ?',
      whereArgs: [1],
    );
    return maps.map((map) => Discount.fromMap(map)).toList();
  }

  @override
  Future<List<Discount>> search(String query) async {
    final db = await _dbHelper.database;
    final String likeQuery = '%$query%';
    final maps = await db.query(
      DatabaseHelper.tableDiscounts,
      where:
          '${DatabaseHelper.colTitle} LIKE ? OR ${DatabaseHelper.colStoreName} LIKE ?',
      whereArgs: [likeQuery, likeQuery],
    );
    return maps.map((map) => Discount.fromMap(map)).toList();
  }

  @override
  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.tableDiscounts,
      {DatabaseHelper.colIsFavorite: isFavorite ? 1 : 0},
      where: '${DatabaseHelper.colId} = ?',
      whereArgs: [id],
    );
  }
}
