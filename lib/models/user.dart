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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'address': address,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      address: map['address'],
      gender: map['gender'],
      birthday: map['birthday'] != null ? DateTime.parse(map['birthday']) : null,
    );
  }
}
