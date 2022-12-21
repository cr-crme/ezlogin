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
    required this.shouldChangePassword,
    id,
  }) : super(id: id ??= emailToPath(email));
  EzloginUser.fromSerialized(map)
      : email = map['email'],
        shouldChangePassword = map[shouldChangePasswordKey],
        super.fromSerialized(map);

  EzloginUser copyWith({
    String? email,
    bool? shouldChangePassword,
    String? id,
  }) {
    email ??= this.email;
    shouldChangePassword ??= this.shouldChangePassword;
    id ??= this.id;
    return EzloginUser(
      email: email,
      shouldChangePassword: shouldChangePassword,
      id: id,
    );
  }

  @override
  Map<String, dynamic> serializedMap() {
    return {
      'email': email,
      shouldChangePasswordKey: shouldChangePassword,
    };
  }

  EzloginUser deserializeItem(map) {
    return EzloginUser.fromSerialized(map);
  }

  // Attributes and methods
  final String email;
  final bool shouldChangePassword;
  static String shouldChangePasswordKey = 'changePassword';
}
