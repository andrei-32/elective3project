class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final String address;
  final String gender;
  final DateTime birthday;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    required this.address,
    required this.gender,
    required this.birthday,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'password': password,
      'address': address,
      'gender': gender,
      'birthday': birthday.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      username: map['username'],
      email: map['email'],
      password: map['password'],
      address: map['address'] ?? '',
      gender: map['gender'] ?? '',
      birthday: map['birthday'] != null ? DateTime.parse(map['birthday']) : DateTime.now(),
    );
  }
}
