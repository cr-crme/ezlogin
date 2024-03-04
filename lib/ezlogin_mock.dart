import 'package:ezlogin/ezlogin.dart';

Map<String, dynamic> userForEzloginMock({
  required EzloginUser user,
  required String password,
}) =>
    {'user': user, 'password': password};

class EzloginMock with Ezlogin {
  EzloginMock(this.initialDatabase);

  @override
  bool get isLogged => currentUser != null;

  EzloginUser? _currentUser;
  @override
  EzloginUser? get currentUser => _currentUser;

  @override
  Future<EzloginUser?> fetchCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<EzloginUser?> user(String id) async {
    if (!_users.containsKey(id)) return null;

    return _users[id]!['user'];
  }

  @override
  Future<EzloginUser?> userFromEmail(String email) async {
    if (!_users.containsKey(email)) return null;

    return _users[email]!['user'];
  }

  @override
  Future<EzloginUser> validateNewUserInfo(EzloginUser user) async {
    return user;
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
    Future<EzloginUser?> Function()? getNewUserInfo,
    Future<String?> Function()? getNewPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!_users.containsKey(username)) return EzloginStatus.wrongUsername;
    final selectedUser = _users[username];

    if (password != selectedUser['password']) {
      return EzloginStatus.wrongPassword;
    }

    final status = await finalizeLogin(
        getNewUserInfo: getNewUserInfo, getNewPassword: getNewPassword);

    _currentUser = await user(username);
    return status;
  }

  @override
  Future<EzloginStatus> logout() async {
    _currentUser = null;
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> updatePassword(
      {required EzloginUser user, required String newPassword}) async {
    if (!_users.containsKey(user.email)) return EzloginStatus.wrongUsername;

    _users[user.email]!['password'] = newPassword;
    return EzloginStatus.success;
  }

  @override
  Future<EzloginUser?> addUser({
    required EzloginUser newUser,
    required String password,
  }) async {
    if (_users.containsKey(newUser.email)) {
      return null;
    }

    _users[newUser.email] = {"user": newUser, "password": password};
    return newUser;
  }

  @override
  Future<EzloginStatus> modifyUser(
      {required EzloginUser user, required EzloginUser newInfo}) async {
    if (!_users.containsKey(user.email)) return EzloginStatus.wrongUsername;

    _users[user.email]!["user"] = newInfo;

    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> deleteUser({required EzloginUser user}) async {
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
