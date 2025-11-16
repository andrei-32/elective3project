import 'package:elective3project/models/booking.dart';
import 'package:elective3project/models/user.dart'; // Import the User model
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  // *** FIX 1: Increment the database version to trigger the upgrade. ***
  static const _dbVersion = 3;

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
      version: _dbVersion, // Use the new version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // This runs only when the database file is created for the very first time.
  Future<void> _onCreate(Database db, int version) async {
    // Creates the 'users' table with all columns, including the new ones.
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        address TEXT,
        gender TEXT,
        birthday TEXT
      )
    ''');

    // Creates the 'bookings' table. Your existing schema looks correct.
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
  }

  // This runs when the _dbVersion is higher than the version stored in the database file.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // This block handles upgrades from version 1 (original schema).
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE bookings ADD COLUMN status TEXT NOT NULL DEFAULT \'Confirmed\'');
    }
    // *** FIX 2: Add the new columns to the 'users' table if upgrading from a version less than 3. ***
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE users ADD COLUMN address TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN gender TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN birthday TEXT');
    }
  }

  // --- User Management Methods ---

  Future<int> insertUser(User user) async {
    final db = await database;
    // Assuming User model has a toMap() method.
    // If not, you'd construct the map manually like in your old code.
    return await db.insert('users', user.toMap());
  }

  // Renamed from getUser to getUserByCredentials for clarity.
  Future<User?> getUserByCredentials(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // *** FIX 3: Add a method to get a single user by their ID. ***
  Future<User?> getUser(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // *** FIX 4: Add a method to update a single field for a user. ***
  Future<void> updateUserField(int userId, String column, String value) async {
    final db = await database;
    await db.update(
      'users',
      {column: value},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }


  // --- Booking Management Methods (Your existing methods are good) ---

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
}
