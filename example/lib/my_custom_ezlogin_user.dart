import 'package:ezlogin/ezlogin.dart';

class MyCustomEzloginUser extends EzloginUser {
  final String firstName;
  final String lastName;

  MyCustomEzloginUser({
    required this.firstName,
    required this.lastName,
    required super.email,
    required super.shouldChangePassword,
    super.id,
  });
  MyCustomEzloginUser.fromSerialized(map)
      : firstName = map['firstName'],
        lastName = map['lastName'],
        super.fromSerialized(map);

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
    bool? shouldChangePassword,
    String? notes,
    String? id,
  }) {
    firstName ??= this.firstName;
    lastName ??= this.lastName;
    email ??= this.email;
    shouldChangePassword ??= this.shouldChangePassword;
    id ??= this.id;
    return MyCustomEzloginUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      shouldChangePassword: shouldChangePassword,
      id: id,
    );
  }
}
