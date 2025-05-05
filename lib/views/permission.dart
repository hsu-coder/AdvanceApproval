// user_provider.dart
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _department = "";

  String get department => _department;

  void setDepartment(String dept) {
    _department = dept;
    notifyListeners();
  }
}