import 'package:ezlogin/ezlogin.dart';

import 'my_custom_ezlogin_user.dart';

Map<String, dynamic> defineNewUser(
  EzLoginUser user, {
  required String password,
}) =>
    {'user': user, 'password': password};

class EzloginMock implements Ezlogin {
  EzloginMock(this.initialDatabase);

  @override
  String get usersPath => 'users';

  MyCustomEzloginUser? _currentUser;
  @override
  MyCustomEzloginUser? get currentUser => _currentUser;
  @override
  bool get isLogged => _currentUser != null;

  @override
  Future<EzLoginUser?> user(String user) async {
    if (!_users.containsKey(user)) return null;

    return _users[user]!['user'];
  }

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  final Map<String, dynamic> initialDatabase;
  late Map<String, dynamic> _users = initialDatabase;

  @override
  Future<EzloginStatus> login({
    required String username,
    required String password,
    required Future<String?> Function() getNewPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!_users.containsKey(username)) return EzloginStatus.wrongUsername;

    if (password != _users[username]['password']) {
      return EzloginStatus.wrongPassword;
    }

    final user = _users[username]["user"];
    if (user.shouldChangePassword) {
      final newPassword = await getNewPassword();
      if (newPassword == null) {
        logout();
        return EzloginStatus.cancelled;
      }
      updatePassword(user: user, newPassword: newPassword);
    }

    _currentUser = user;
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> logout() async {
    _currentUser = null;
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> updatePassword(
      {required EzLoginUser user, required String newPassword}) async {
    if (!_users.containsKey(user.email)) return EzloginStatus.wrongUsername;

    _users[user.email]!['password'] = newPassword;
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> addUser({
    required EzLoginUser newUser,
    required String password,
  }) async {
    if (_users.containsKey(newUser.email)) {
      return EzloginStatus.couldNotCreateUser;
    }

    _users[newUser.email] = defineNewUser(newUser, password: password);
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> modifyUser(
      {required EzLoginUser user, required EzLoginUser newInfo}) async {
    if (!_users.containsKey(user.email)) return EzloginStatus.wrongUsername;

    _users[user.email] = newInfo;

    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> deleteUser({required EzLoginUser user}) async {
    if (!_users.containsKey(user.email)) return EzloginStatus.wrongUsername;

    _users.remove(user.email);
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> clearUsers() async {
    _users = initialDatabase;
    return EzloginStatus.success;
  }
}
