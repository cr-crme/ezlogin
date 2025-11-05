import 'package:ezlogin/ezlogin.dart';

class MyCustomEzloginUser extends EzloginUser {
  final String firstName;
  final String lastName;

  MyCustomEzloginUser({
    required this.firstName,
    required this.lastName,
    required super.email,
    required super.mustChangePassword,
    super.id,
  });
  MyCustomEzloginUser.fromSerialized(super.map)
      : firstName = map?['firstName'] ?? '',
        lastName = map?['lastName'] ?? '',
        super.fromSerialized();

  @override
  Map<String, dynamic> serializedMap() {
    return super.serializedMap()
      ..addAll({
        'firstName': firstName,
        'lastName': lastName,
      });
  }

  @override
  MyCustomEzloginUser deserializeItem(map) {
    return MyCustomEzloginUser.fromSerialized(map);
  }

  @override
  EzloginUser copyWith({
    String? firstName,
    String? lastName,
    String? email,
    bool? mustChangePassword,
    String? notes,
    String? id,
  }) {
    firstName ??= this.firstName;
    lastName ??= this.lastName;
    email ??= this.email;
    mustChangePassword ??= this.mustChangePassword;
    id ??= this.id;
    return MyCustomEzloginUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      mustChangePassword: mustChangePassword,
      id: id,
    );
  }
}
