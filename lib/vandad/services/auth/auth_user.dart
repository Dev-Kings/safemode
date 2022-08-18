class AuthUser {
  final int clockNumber;
  final String firstname;
  final String lastname;
  final String email;

  const AuthUser({
    required this.clockNumber,
    required this.firstname,
    required this.lastname,
    required this.email,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      clockNumber: json['clock_number'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
    );
  }
}
