import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'ezlogin.dart';

class EzloginFirebase with Ezlogin {
  ///
  /// Constructor
  ///
  EzloginFirebase({this.usersPath = 'users'});

  ///
  /// Path to [users] in the database
  ///
  String usersPath;

  ///
  /// This is an internal structure to quickly access the current
  /// user information. These may therefore be out of sync with the database
  ///
  EzloginUser? _currentUser;

  @override
  EzloginUser? get currentUser => _currentUser;

  @override
  bool get isLogged => _currentUser != null;

  @override
  Future<EzloginUser?> user(String username) async {
    final id = emailToPath(username);
    final data = await FirebaseDatabase.instance.ref('$usersPath/$id').get();
    return data.value == null ? null : EzloginUser.fromSerialized(data.value);
  }

  @override
  Future<void> initialize(
      {bool useEmulator = false, FirebaseOptions? currentPlatform}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: currentPlatform);

    if (useEmulator) {
      // Connect Firebase to local emulators
      // IMPORTANT: when in production set android:usesCleartextTraffic to 'false'
      // in AndroidManifest.xml, to enforce 'https' connexions.
      assert(() {
        FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
        FirebaseDatabase.instance.useDatabaseEmulator(
            !kIsWeb && Platform.isAndroid ? '10.0.2.2' : 'localhost', 9000);
        FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
        return true;
      }());
    }
  }

  @override
  Future<EzloginStatus> login({
    required String username,
    required String password,
    required Future<EzloginUser?> Function() getNewUserInfo,
    required Future<String?> Function() getNewPassword,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);
    } catch (e) {
      if ((e as FirebaseAuthException).code == 'user-not-found') {
        return EzloginStatus.wrongUsername;
      } else if (e.code == 'wrong-password') {
        return EzloginStatus.wrongPassword;
      } else {
        return EzloginStatus.unrecognizedError;
      }
    }

    final status = await finalizeLogin(
        username: username,
        getNewUserInfo: getNewUserInfo,
        getNewPassword: getNewPassword);
    _currentUser = await user(username);

    return status;
  }

  @override
  Future<EzloginStatus> logout() async {
    final authenticator = FirebaseAuth.instance;

    _currentUser = null;
    try {
      await authenticator.signOut();
    } catch (e) {
      if ((e as FirebaseAuthException).code == 'user-not-found') {
        return EzloginStatus.wrongUsername;
      } else if (e.code == 'wrong-password') {
        return EzloginStatus.wrongPassword;
      } else {
        return EzloginStatus.unrecognizedError;
      }
    }
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> updatePassword(
      {required EzloginUser user, required String newPassword}) async {
    final authenticator = FirebaseAuth.instance;
    try {
      await authenticator.currentUser?.updatePassword(newPassword);
    } catch (e) {
      return EzloginStatus.couldNotCreateUser;
    }

    final id = emailToPath(user.email);
    try {
      await FirebaseDatabase.instance
          .ref(usersPath)
          .child('$id/${EzloginUser.shouldChangePasswordKey}')
          .set(false);
    } catch (e) {
      return EzloginStatus.unrecognizedError;
    }
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> addUser(
      {required EzloginUser newUser, required String password}) async {
    final authenticator = FirebaseAuth.instance;

    try {
      await authenticator.createUserWithEmailAndPassword(
          email: newUser.email, password: password);
    } catch (e) {
      return EzloginStatus.couldNotCreateUser;
    }

    final id = emailToPath(newUser.email);
    try {
      await FirebaseDatabase.instance
          .ref(usersPath)
          .child(id)
          .set(newUser.serialize());
    } catch (e) {
      return EzloginStatus.unrecognizedError;
    }
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> modifyUser(
      {required EzloginUser user, required EzloginUser newInfo}) async {
    if (user.email == currentUser?.email) {
      _currentUser = user;
    }

    final id = emailToPath(user.email);
    await FirebaseDatabase.instance
        .ref(usersPath)
        .child(id)
        .set(newInfo.serialize());
    return EzloginStatus.success;
  }

  @override
  Future<EzloginStatus> deleteUser({required EzloginUser user}) async {
    // Firebase does not allow to delete a user without being logged in
    // with this user
    return EzloginStatus.cancelled;
  }

  @override
  Future<EzloginStatus> clearUsers() async {
    _currentUser = null;
    try {
      FirebaseDatabase.instance.ref(usersPath).remove();
    } catch (_) {
      return EzloginStatus.cancelled;
    }
    return EzloginStatus.success;
  }
}
