import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/models/user.dart';

class UserProvider extends ChangeNotifier {
  static UserProvider? instance;

  static UserProvider getInstance(BuildContext context, {bool listen = false}) {
    instance ??= Provider.of<UserProvider>(context, listen: listen);
    return instance!;
  }

  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    phoneNumber: '',
    token: '',
  );
  int _unreadNotifications = 0;
  int get unreadNotifications => _unreadNotifications;

  User get user => _user;

  void setUser(String userData) {
    _user = User.fromJson(userData);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void incrementNotifications() {
    _unreadNotifications++;
    notifyListeners();
  }

  void resetNotifications() {
    _unreadNotifications = 0;
    notifyListeners();
  }

  void clearUser() {
    _user = User(
      id: '',
      name: '',
      email: '',
      password: '',
      address: '',
      type: '',
      phoneNumber: '',
      token: '',
    );
    notifyListeners();
  }
}
