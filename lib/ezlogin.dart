import 'ezlogin_status.dart';
import 'ezlogin_user.dart';

export 'ezlogin_status.dart';
export 'ezlogin_user.dart';
export 'ezlogin_firebase.dart';

mixin Ezlogin {
  ///
  /// Returns the [EzloginUser] currently logged (null if there is none)
  ///
  EzloginUser? get currentUser;

  ///
  /// Should returns true if one is logged
  ///
  bool get isLogged;

  ///
  /// Initialize and connect to the database
  ///
  Future<void> initialize();

  ///
  /// Login to a specific [username] credential, usually email,
  /// with a given [password]. This method should call [finalizeLogin] before
  /// returning. The callbacks ([getNewUserInfo] and [getNewPassword]) are for
  /// the new users that are actually registered to the database but
  /// with no info associated with them.
  ///
  Future<EzloginStatus> login({
    required String username,
    required String password,
    required Future<EzloginUser?> Function() getNewUserInfo,
    required Future<String?> Function() getNewPassword,
  });

  ///
  /// This method should be called after a successful login. It ensures that
  /// the password is changed if it should be. It will automatically logout
  /// in the case the user does not change it.
  ///
  Future<EzloginStatus> finalizeLogin({
    required String username,
    required Future<EzloginUser?> Function() getNewUserInfo,
    required Future<String?> Function() getNewPassword,
  }) async {
    final currentUser = await user(username) ?? await getNewUserInfo();
    if (currentUser == null) {
      logout();
      return EzloginStatus.cancelled;
    }
    modifyUser(user: currentUser, newInfo: currentUser);

    if (currentUser.shouldChangePassword) {
      final newPassword = await getNewPassword();
      if (newPassword == null) {
        logout();
        return EzloginStatus.cancelled;
      }
      updatePassword(user: currentUser, newPassword: newPassword);
    }
    return EzloginStatus.success;
  }

  ///
  /// Logout from the application
  ///
  Future<EzloginStatus> logout();

  ///
  /// Get a specific user of a given [username] credential, usually email. For
  /// security purposes, this function should fail if the requester
  /// is not logged in (otherwise it exposes the database to everyone)
  ///
  Future<EzloginUser?> user(String username);

  ///
  /// Add a [newUser] to the users with a default [password]. The flag
  /// [shouldChangePassword] should be set to true, so the user will have to
  /// change their password when connecting the first time.
  ///
  Future<EzloginStatus> addUser(
      {required EzloginUser newUser, required String password});

  ///
  /// Replace the [user] by [newInfo] in the database
  ///
  Future<EzloginStatus> modifyUser(
      {required EzloginUser user, required EzloginUser newInfo});

  ///
  /// Remove the [user] from the database
  ///
  Future<EzloginStatus> deleteUser({required EzloginUser user});

  ///
  /// Change the password of the [user] by [newPassword]. This method
  /// should set the [shouldChangePassword] flag to false afterwards
  ///
  Future<EzloginStatus> updatePassword(
      {required EzloginUser user, required String newPassword});

  ///
  /// Completely clear the database. This is mostly for debugging purposes
  ///
  Future<EzloginStatus> clearUsers();
}
