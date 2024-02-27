import 'package:enhanced_containers/enhanced_containers.dart';

String emailToPath(String email) {
  var reducedEmail = email.replaceAll('@', '__at__');
  reducedEmail = reducedEmail.replaceAll('.', '__dot__');
  return reducedEmail;
}

String pathToEmail(String reducedEmail) {
  var email = reducedEmail.replaceAll('__at__', '@');
  email = email.replaceAll('__dot__', '.');
  return email;
}

class EzloginUser extends ItemSerializable {
  // Constructors and (de)serializer
  EzloginUser({
    required this.email,
    required this.mustChangePassword,
    id,
  }) : super(id: id ??= emailToPath(email));
  EzloginUser.fromSerialized(map)
      : email = map['email'],
        mustChangePassword = map[mustChangePasswordKey],
        super.fromSerialized(map);

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

  EzloginUser deserializeItem(map) {
    return EzloginUser.fromSerialized(map);
  }

  // Attributes and methods
  final String email;
  final bool mustChangePassword;
  static String mustChangePasswordKey = 'changePassword';
}
