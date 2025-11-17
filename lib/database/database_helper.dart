import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/booking.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const String _dbName = 'flight_booking.db';
  static const int _dbVersion = 10; // Incremented version

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
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createUsersTable(db);
    await _createBookingsTable(db);
    await _createFlightTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 9) {
       await db.execute('ALTER TABLE bookings ADD COLUMN adults INTEGER NOT NULL DEFAULT 1');
      await db.execute('ALTER TABLE bookings ADD COLUMN children INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE bookings ADD COLUMN infants INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE bookings ADD COLUMN flightClass TEXT NOT NULL DEFAULT \'Economy\'');
    }
    if (oldVersion < 10) {
      // Add new columns for user details
      await db.execute('ALTER TABLE users ADD COLUMN firstName TEXT NOT NULL DEFAULT \'\'');
      await db.execute('ALTER TABLE users ADD COLUMN lastName TEXT NOT NULL DEFAULT \'\'');
      
      // For existing columns, we handle nulls carefully.
      // These will be enforced at the app level for new users.
      await db.execute('ALTER TABLE users ADD COLUMN address TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN gender TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN birthday TEXT');
    }
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        address TEXT NOT NULL,
        gender TEXT NOT NULL,
        birthday TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createBookingsTable(Database db) async {
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
        departureFlightDetails TEXT NOT NULL, 
        returnFlightDetails TEXT, 
        selectedBundle TEXT NOT NULL,
        totalPrice REAL NOT NULL,
        paymentMethod TEXT NOT NULL,
        status TEXT NOT NULL,
        cancellationReason TEXT, 
        adults INTEGER NOT NULL DEFAULT 1,
        children INTEGER NOT NULL DEFAULT 0,
        infants INTEGER NOT NULL DEFAULT 0,
        flightClass TEXT NOT NULL DEFAULT 'Economy',
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
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

  Future<User?> getUserById(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps[0]);
    }
    return null;
  }

  Future<void> updateUserField(int userId, String field, String value) async {
    final db = await database;
    await db.update(
      'users',
      {field: value},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<User?> getUserByUsername(String username) async {
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

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
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

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertBooking(Booking booking) async {
    final db = await database;
    return await db.insert('bookings', booking.toMap(booking.userId));
  }

  Future<Booking?> getBookingByReference(String bookingReference) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookings',
      where: 'bookingReference = ?',
      whereArgs: [bookingReference],
    );

    if (maps.isNotEmpty) {
      return Booking.fromMap(maps[0]);
    }
    return null;
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

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('bookings');
    await db.delete('users');
  }

  Future<double> getTotalRevenue() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(totalPrice) FROM bookings');
    return (result.first.values.first as num?)?.toDouble() ?? 0.0;
  }

  Future<int> getTotalBookings() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM bookings');
    return (result.first.values.first as num?)?.toInt() ?? 0;
  }

  Future<int> getTotalUsers() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM users');
    return (result.first.values.first as num?)?.toInt() ?? 0;
  }
}
