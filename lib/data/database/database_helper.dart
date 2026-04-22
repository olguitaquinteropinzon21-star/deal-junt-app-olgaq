import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Patrón Singleton: Permite que solo exista una instancia de la base de datos
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  // Constructor privado corregido (sin el punto y coma que causaba conflicto)
  DatabaseHelper._internal();

  static Database? _database;
  static const String _dbName = 'deal_hunt.db';
  static const int _dbVersion = 1;

  // Nombres de tablas y columnas
  static const String tableDiscounts = 'discounts';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colDescription = 'description';
  static const String colPercentage = 'percentage';
  static const String colCategoryId = 'category_id';
  static const String colStoreName = 'store_name';
  static const String colImageUrl = 'image_url';
  static const String colCouponCode = 'coupon_code';
  static const String colExpirationDate = 'expiration_date';
  static const String colIsFavorite = 'is_favorite';
  static const String colCreatedAt = 'created_at';

  // Obtener la base de datos o inicializarla si no existe
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Inicialización de la base de datos en el dispositivo
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Creación de la tabla
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableDiscounts (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT NOT NULL,
        $colDescription TEXT NOT NULL,
        $colPercentage REAL NOT NULL,
        $colCategoryId TEXT NOT NULL,
        $colStoreName TEXT NOT NULL,
        $colImageUrl TEXT,
        $colCouponCode TEXT DEFAULT "",
        $colExpirationDate TEXT NOT NULL,
        $colIsFavorite INTEGER DEFAULT 0,
        $colCreatedAt TEXT NOT NULL
      )
    ''');

    // Insertar los datos de prueba automáticamente
    await _insertSeedData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Para futuras actualizaciones de la estructura de la base de datos
  }

  // Insertar datos iniciales (Seeds)
  Future<void> _insertSeedData(Database db) async {
    final now = DateTime.now();

    final List<Map<String, dynamic>> seeds = [
      {
        colTitle: '50% OFF en Pizza',
        colDescription:
            'Disfruta la mitad de precio en cualquier pizza grande de la carta.',
        colPercentage: 50.0,
        colCategoryId: 'food',
        colStoreName: 'PizzaHot',
        colImageUrl: null,
        colCouponCode: 'PIZZA50',
        colExpirationDate: now.add(const Duration(days: 15)).toIso8601String(),
        colIsFavorite: 0,
        colCreatedAt: now.toIso8601String(),
      },
      {
        colTitle: '30% en Auriculares Sony',
        colDescription:
            'Aprovecha este descuento increíble en auriculares inalámbricos.',
        colPercentage: 30.0,
        colCategoryId: 'tech',
        colStoreName: 'TechStore',
        colImageUrl: null,
        colCouponCode: 'SONY30',
        colExpirationDate: now.add(const Duration(days: 7)).toIso8601String(),
        colIsFavorite: 1,
        colCreatedAt: now.subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        colTitle: '40% en Ropa de Verano',
        colDescription: 'Toda la colección de verano con descuento.',
        colPercentage: 40.0,
        colCategoryId: 'fashion',
        colStoreName: 'FashionWorld',
        colImageUrl: null,
        colCouponCode: 'SUMMER40',
        colExpirationDate: now.add(const Duration(days: 30)).toIso8601String(),
        colIsFavorite: 0,
        colCreatedAt: now.subtract(const Duration(days: 2)).toIso8601String(),
      },
      {
        colTitle: '25% en Vuelos Nacionales',
        colDescription: 'Ahorra 25% en cualquier destino nacional.',
        colPercentage: 25.0,
        colCategoryId: 'travel',
        colStoreName: 'AeroViajes',
        colImageUrl: null,
        colCouponCode: 'VUELO25',
        colExpirationDate: now.add(const Duration(days: 20)).toIso8601String(),
        colIsFavorite: 1,
        colCreatedAt: now.subtract(const Duration(days: 3)).toIso8601String(),
      },
      {
        colTitle: '35% en Equipamiento Deportivo',
        colDescription: 'Todo lo que necesitas para tu deporte favorito.',
        colPercentage: 35.0,
        colCategoryId: 'sports',
        colStoreName: 'SportMax',
        colImageUrl: null,
        colCouponCode: 'SPORT35',
        colExpirationDate: now.add(const Duration(days: 10)).toIso8601String(),
        colIsFavorite: 0,
        colCreatedAt: now.subtract(const Duration(days: 4)).toIso8601String(),
      },
      {
        colTitle: '20% en Cine y Streaming',
        colDescription: 'Dos meses de suscripción premium con descuento.',
        colPercentage: 20.0,
        colCategoryId: 'entertainment',
        colStoreName: 'CineMax',
        colImageUrl: null,
        colCouponCode: 'CINE20',
        colExpirationDate: now.add(const Duration(days: 25)).toIso8601String(),
        colIsFavorite: 0,
        colCreatedAt: now.subtract(const Duration(days: 5)).toIso8601String(),
      },
    ];

    // Bucle para insertar todos los datos de la lista anterior
    for (var seed in seeds) {
      await db.insert(tableDiscounts, seed);
    }
  }

  // Cerrar la base de datos de forma segura
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
