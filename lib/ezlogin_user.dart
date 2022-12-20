import 'package:enhanced_containers/enhanced_containers.dart';

import 'ezlogin_enum.dart';

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

class EzLoginUser extends ItemSerializable {
  // Constructors and (de)serializer
  EzLoginUser({
    required this.email,
    required this.userType,
    required this.shouldChangePassword,
    id,
  }) : super(id: id ??= emailToPath(email));
  EzLoginUser.fromSerialized(map)
      : email = map['email'],
        userType = EzloginUserType.values[map['userType']],
        shouldChangePassword = map['changePassword'],
        super.fromSerialized(map);

  EzLoginUser copyWith({
    String? email,
    EzloginUserType? userType,
    bool? shouldChangePassword,
    String? id,
  }) {
    email ??= this.email;
    userType ??= this.userType;
    shouldChangePassword ??= this.shouldChangePassword;
    id ??= this.id;
    return EzLoginUser(
      email: email,
      userType: userType,
      shouldChangePassword: shouldChangePassword,
      id: id,
    );
  }

  @override
  Map<String, dynamic> serializedMap() {
    return {
      'email': email,
      'userType': userType.index,
      'changePassword': shouldChangePassword,
    };
  }

  EzLoginUser deserializeItem(map) {
    return EzLoginUser.fromSerialized(map);
  }

  // Attributes and methods
  final String email;
  final EzloginUserType userType;
  final bool shouldChangePassword;
}
