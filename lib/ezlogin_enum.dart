enum EzloginUserType {
  none,
  user,
  superUser,
}

extension EzloginUserTypeExtension on EzloginUserType {
  bool get isSuperUser => this == EzloginUserType.superUser;
}

enum EzloginStatus {
  none,
  waitingForLogin,
  success,
  newUser,
  couldNotCreateUser,
  wrongUsername,
  wrongPassword,
  unrecognizedError,
  cancelled,
}
