import 'dart:convert';

List<User> userFromJson(String source) =>
    List<User>.from(json.decode(source).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  int id;
  int clockNumber;
  String firstName;
  String lastName;

  User({
    required this.id,
    required this.clockNumber,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        clockNumber: json['clock_number'],
        firstName: json['firstname'],
        lastName: json['lastname'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'clock_number': clockNumber,
        'firstname': firstName,
        'lastname': lastName,
      };
}
