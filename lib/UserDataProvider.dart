import 'package:flutter/foundation.dart';

class UserDataProvider extends ChangeNotifier {
  List<double> _monthlyData = [];
  String _selectedOperator = "Select Current Operator";


  // ✅ Add these filter states
  bool? _globalTurkcell;
  bool? _globalVodafone;
  bool? _globalTurkTelekom;

  // ✅ Getters
  bool get globalTurkcell => _globalTurkcell ?? false;
  bool get globalVodafone => _globalVodafone ?? false;
  bool get globalTurkTelekom => _globalTurkTelekom ?? false;

  // ✅ Setters
  void setGlobalTurkcell(bool value) {
    _globalTurkcell = value;
    notifyListeners();
  }

  void setGlobalVodafone(bool value) {
    _globalVodafone = value;
    notifyListeners();
  }

  void setGlobalTurkTelekom(bool value) {
    _globalTurkTelekom = value;
    notifyListeners();
  }


  String get selectedOperator => _selectedOperator;

  UserDataProvider() {
    // Initialize default dummy data when provider is first created
    if (_monthlyData.isEmpty) {
      _monthlyData = [25.5, 26.5, 25.0, 24.0, 27.8];
      print("Initialized default monthlyData: $_monthlyData");
    }
  }

  List<double> get monthlyData => _monthlyData;

  void setMonthlyData(List<double> data) {
    _monthlyData = data;
    notifyListeners();
  }

  void updateMonth(int index, double newValue) {
    if (index >= 0 && index < _monthlyData.length) {
      _monthlyData[index] = newValue;
      notifyListeners();
    }
  }

  void setSelectedOperator(String operator) {
    _selectedOperator = operator;
    notifyListeners(); // Notifies HomePage and any other listeners
  }
}

