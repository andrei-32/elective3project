<<<<<<< HEAD
import 'package:elective3project/models/booking.dart';
import 'package:elective3project/models/user.dart'; // Import the User model
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
=======
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/booking.dart';
import '../models/user.dart';
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
<<<<<<< HEAD
  // *** FIX 1: Increment the database version to trigger the upgrade. ***
  static const _dbVersion = 3;
=======
  static const String _dbName = 'flight_booking.db';
  static const int _dbVersion = 6; // <-- Incremented version
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
<<<<<<< HEAD
      version: _dbVersion, // Use the new version
=======
      version: _dbVersion,
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // This runs only when the database file is created for the very first time.
  Future<void> _onCreate(Database db, int version) async {
<<<<<<< HEAD
    // Creates the 'users' table with all columns, including the new ones.
=======
    await _createUsersTable(db);
    await _createBookingsTable(db);
    await _createFlightTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE bookings ADD COLUMN status TEXT NOT NULL DEFAULT \'\'Confirmed\'\'',
      );
    }
    if (oldVersion < 3) {
      await _createFlightTables(db);
    }
    if (oldVersion < 4) {
      await db.execute('DROP TABLE IF EXISTS bookings');
      await _createBookingsTable(db);
    }
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE bookings ADD COLUMN origin2 TEXT');
      await db.execute('ALTER TABLE bookings ADD COLUMN destination2 TEXT');
    }
    if (oldVersion < 6) {
      await db.execute(
        'ALTER TABLE bookings ADD COLUMN cancellationReason TEXT',
      );
    }
  }

  Future<void> _createUsersTable(Database db) async {
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
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
  }

<<<<<<< HEAD
    // Creates the 'bookings' table. Your existing schema looks correct.
=======
  Future<void> _createBookingsTable(Database db) async {
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
    await db.execute('''
      CREATE TABLE bookings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookingReference TEXT NOT NULL UNIQUE,
        userId INTEGER NOT NULL,
        origin TEXT NOT NULL,
        destination TEXT NOT NULL,
        origin2 TEXT,
        destination2 TEXT,
        departureDate TEXT NOT NULL,
        returnDate TEXT,
        tripType TEXT NOT NULL,
        guestFirstName TEXT NOT NULL,
        guestLastName TEXT NOT NULL,
        departureFlightDetails TEXT NOT NULL, -- JSON String
        returnFlightDetails TEXT, -- JSON String
        selectedBundle TEXT NOT NULL,
        totalPrice REAL NOT NULL,
        paymentMethod TEXT NOT NULL,
        status TEXT NOT NULL, -- e.g., 'Confirmed', 'Cancelled'
        cancellationReason TEXT, -- New column
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

<<<<<<< HEAD
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

=======
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

  // --- User Methods ---
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
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
<<<<<<< HEAD
      return User.fromMap(maps.first);
=======
      return User.fromMap(maps[0]);
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
    }
    return null;
  }

<<<<<<< HEAD
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
=======
  Future<User?> getUserByUsername(String username) async {
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps[0]);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // --- Booking Methods ---
  Future<int> insertBooking(Booking booking) async {
    final db = await database;
    return await db.insert('bookings', booking.toMap());
  }

  Future<List<Booking>> getBookings(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookings',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );

    return List.generate(maps.length, (i) {
      return Booking.fromMap(maps[i]);
    });
  }

  Future<List<Booking>> getAllBookings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookings',
      orderBy: 'id DESC',
    );

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

  Future<void> cancelBooking(int id, String reason) async {
    final db = await database;
    await db.update(
      'bookings',
      {'status': 'Cancelled', 'cancellationReason': reason},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Flight Data Methods ---
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

  Future<void> saveDailyPrice(
    DateTime date,
    String destination,
    double? price,
  ) async {
    final db = await database;
    final dateString = date.toIso8601String().split('T')[0];
    await db.insert('daily_prices', {
      'date': dateString,
      'destination': destination,
      'price': price,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getFlights(
    DateTime date,
    String destination,
  ) async {
    final db = await database;
    final dateString = date.toIso8601String().split('T')[0];
    return await db.query(
      'flights',
      where: 'date = ? AND destination = ?',
      whereArgs: [dateString, destination],
    );
  }

  Future<void> saveFlights(
    DateTime date,
    String destination,
    List<Map<String, dynamic>> flights,
  ) async {
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
