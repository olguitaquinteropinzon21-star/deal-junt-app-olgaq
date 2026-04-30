import '../models/discount.dart';
import '../database/database_helper.dart'; // Asegúrate que esta ruta sea correcta

abstract class IDiscountRepository {
  Future<List<Discount>> getAll();
  Future<List<Discount>> getByCategory(String categoryId);
  Future<List<Discount>> search(String query);
  Future<void> delete(int id);
  Future<void> updateFavorite(int id, bool isFavorite);
}

class DiscountRepository implements IDiscountRepository {
  final DatabaseHelper _dbHelper;

  DiscountRepository(this._dbHelper);

  @override
  Future<List<Discount>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('discounts');
    return List.generate(maps.length, (i) => Discount.fromMap(maps[i]));
  }

  @override
  Future<List<Discount>> getByCategory(String categoryId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'discounts',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );
    return List.generate(maps.length, (i) => Discount.fromMap(maps[i]));
  }

  @override
  Future<List<Discount>> search(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'discounts',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) => Discount.fromMap(maps[i]));
  }

  @override
  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete('discounts', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> updateFavorite(int id, bool isFavorite) async {
    final db = await _dbHelper.database;
    await db.update(
      'discounts',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
