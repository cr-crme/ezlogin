import 'ezlogin_status.dart';
import 'ezlogin_user.dart';

export 'ezlogin_status.dart';
export 'ezlogin_user.dart';

mixin Ezlogin {
  ///
  /// Path to [users] in the database
  ///
  String get usersPath;

  ///
  /// Returns the [EzLoginUser] currently logged (null if there is none)
  ///
  EzLoginUser? get currentUser;

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
  /// with a given [password]. This method should check the flat
  /// [ShouldChangePassword] of the user that is trying to connect and call
  /// the getNewPassword function if it is true. If null is returned by this
  /// latter function, this method should logout and
  /// return [EzloginStatus.cancelled]
  ///
  Future<EzloginStatus> login({
    required String username,
    required String password,
    required Future<String?> Function() getNewPassword,
  });

  ///
  /// Logout from the application
  ///
  Future<EzloginStatus> logout();

  ///
  /// Get a specific user of a given [username] credential, usually email. For
  /// security purposes, this function should fail if the requester
  /// is not logged in (otherwise it exposes the database to everyone)
  ///
  Future<EzLoginUser?> user(String username);

  ///
  /// Add a [newUser] to the users with a default [password]. The flag
  /// [shouldChangePassword] should be set to true, so the user will have to
  /// change their password when connecting the first time.
  ///
  Future<EzloginStatus> addUser(
      {required EzLoginUser newUser, required String password});

  ///
  /// Replace the [user] by [newInfo] in the database
  ///
  Future<EzloginStatus> modifyUser(
      {required EzLoginUser user, required EzLoginUser newInfo});

  ///
  /// Remove the [user] from the database
  ///
  Future<EzloginStatus> deleteUser({required EzLoginUser user});

  ///
  /// Change the password of the [user] by [newPassword]. This method
  /// should set the [shouldChangePassword] flag to false afterwards
  ///
  Future<EzloginStatus> updatePassword(
      {required EzLoginUser user, required String newPassword});

  ///
  /// Completely clear the database. This is mostly for debugging purposes
  ///
  Future<EzloginStatus> clearUsers();
}
