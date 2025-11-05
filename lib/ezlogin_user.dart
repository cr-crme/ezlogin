import 'package:enhanced_containers_foundation/item_serializable.dart';

class EzloginUser extends ItemSerializable {
  // Constructors and (de)serializer
  EzloginUser({
    required this.email,
    required this.mustChangePassword,
    required super.id,
  });
  EzloginUser.fromSerialized(super.map)
      : email = map?['email'],
        mustChangePassword = map?[mustChangePasswordKey],
        super.fromSerialized();

  EzloginUser copyWith({
    String? email,
    bool? mustChangePassword,
    String? id,
  }) {
    email ??= this.email;
    mustChangePassword ??= this.mustChangePassword;
    id ??= this.id;
    return EzloginUser(
      email: email,
      mustChangePassword: mustChangePassword,
      id: id,
    );
  }

  @override
  Map<String, dynamic> serializedMap() {
    return {
      'email': email,
      mustChangePasswordKey: mustChangePassword,
    };
  }

  EzloginUser deserializeItem(Map? map) {
    return EzloginUser.fromSerialized(map);
  }

  // Attributes and methods
  final String email;
  final bool mustChangePassword;
  static String mustChangePasswordKey = 'changePassword';
}
