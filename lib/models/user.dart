class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String? address;
  final String? gender;
  final DateTime? birthday;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.address,
    this.gender,
    this.birthday,
  });

<<<<<<< HEAD
  // *** THIS IS THE FIX ***
  // Add this 'toMap' method to your User class.
  // It converts the User object into a Map.
=======
  // Add this factory constructor
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }

>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'address': address,
      'gender': gender,
      // Convert DateTime to a string format suitable for database storage
      'birthday': birthday?.toIso8601String(),
    };
  }

  // Your 'fromMap' factory is also essential for reading data FROM the database.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      address: map['address'],
      gender: map['gender'],
      // Convert the string from the database back into a DateTime object
      birthday: map['birthday'] != null ? DateTime.parse(map['birthday']) : null,
    );
  }
}
