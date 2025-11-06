import 'package:elective3project/models/booking.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'flight_booking.db');

    return await openDatabase(
      path,
      version: 3, // Incremented version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // Create bookings table
    await db.execute('''
      CREATE TABLE bookings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        destination TEXT NOT NULL,
        departureTime TEXT NOT NULL,
        arrivalTime TEXT NOT NULL,
        tripType TEXT NOT NULL,
        departureDate TEXT NOT NULL,
        returnDate TEXT,
        adults INTEGER NOT NULL,
        children INTEGER NOT NULL,
        infants INTEGER NOT NULL,
        flightClass TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Create new tables for flight data
    await _createFlightTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE bookings ADD COLUMN status TEXT NOT NULL DEFAULT ''Confirmed''');
    }
    if (oldVersion < 3) {
      await _createFlightTables(db);
    }
  }

  Future<void> _createFlightTables(Database db) async {
    await db.execute('''
      CREATE TABLE daily_prices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        destination TEXT NOT NULL,
        price REAL,
        UNIQUE(date, destination)
      )
    ''');
    await db.execute('''
      CREATE TABLE flights(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        destination TEXT NOT NULL,
        departureTime TEXT NOT NULL,
        arrivalTime TEXT NOT NULL,
        duration TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps[0]);
    }
    return null;
  }

  Future<int> insertBooking(Booking booking, int userId) async {
    final db = await database;
    return await db.insert('bookings', booking.toMap(userId));
  }

  Future<List<Booking>> getBookings(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookings',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Booking.fromMap(maps[i]);
    });
  }

  Future<List<Booking>> getAllBookings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookings');

    return List.generate(maps.length, (i) {
      return Booking.fromMap(maps[i]);
    });
  }

  Future<void> updateBookingStatus(int id, String status) async {
    final db = await database;
    await db.update(
      'bookings',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- NEW METHODS FOR FLIGHT DATA ---

  Future<double?> getDailyPrice(DateTime date, String destination) async {
    final db = await database;
    final dateString = date.toIso8601String().split('T')[0];
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_prices',
      columns: ['price'],
      where: 'date = ? AND destination = ?',
      whereArgs: [dateString, destination],
    );

    if (maps.isNotEmpty) {
      return maps[0]['price'] as double?;
    }
    return null;
  }

  Future<void> saveDailyPrice(DateTime date, String destination, double? price) async {
    final db = await database;
    final dateString = date.toIso8601String().split('T')[0];
    await db.insert(
      'daily_prices',
      {'date': dateString, 'destination': destination, 'price': price},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getFlights(DateTime date, String destination) async {
    final db = await database;
    final dateString = date.toIso8601String().split('T')[0];
    return await db.query(
      'flights',
      where: 'date = ? AND destination = ?',
      whereArgs: [dateString, destination],
    );
  }

  Future<void> saveFlights(DateTime date, String destination, List<Map<String, dynamic>> flights) async {
    final db = await database;
    final dateString = date.toIso8601String().split('T')[0];
    final batch = db.batch();
    for (var flight in flights) {
      batch.insert('flights', {
        'date': dateString,
        'destination': destination,
        'departureTime': flight['departureTime'],
        'arrivalTime': flight['arrivalTime'],
        'duration': flight['duration'],
        'price': flight['price'],
      });
    }
    await batch.commit(noResult: true);
  }
}
