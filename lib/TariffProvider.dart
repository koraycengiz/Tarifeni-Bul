import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


// Define the Tariff model
class Tariff {
  final String name;
  final int gb;
  final String minutes;
  final double price;
  final String specification;

  final int? specialPriceFirstMonths;
  final int? specialPriceRemainingMonths;
  final int? firstMonthsCount;
  final int? remainingMonthsCount;

  Tariff(
      this.name,
      this.gb,
      this.minutes,
      this.price,
      this.specification,
      this.specialPriceFirstMonths,
      this.specialPriceRemainingMonths,
      this.firstMonthsCount,
      this.remainingMonthsCount
      );

  // Optional: Implement == and hashCode for correct comparison in favorites list
  @override
  bool operator ==(Object other) {
    return other is Tariff &&
        other.name == name &&
        other.gb == gb &&
        other.minutes == minutes &&
        other.price == price &&
        other.specification == specification;
  }

  bool get hasSpecialPricing =>
      specialPriceFirstMonths != null &&
          specialPriceRemainingMonths != null &&
          firstMonthsCount != null &&
          remainingMonthsCount != null;

  @override
  int get hashCode => name.hashCode ^ gb.hashCode ^ minutes.hashCode^ price.hashCode ^ specification.hashCode;
}

// Define TariffProvider
class TariffProvider with ChangeNotifier {
  String _currentOperator = "";

  final List<Tariff> _tariffs = [];
  List<Tariff> get tariffs {
    final forbidden = "${_currentOperator.trim().toLowerCase()}_new_user";
    //print("Filtering out: $forbidden");

    return _tariffs.where((t) {
      final spec = t.specification.trim().toLowerCase();
      final isVisible = spec != forbidden;
      //print("Tariff: ${t.specification}, visible: $isVisible");
      return isVisible;
    }).toList();
  }





  List<Tariff> _favorites = [];
  List<Tariff> get favorites => _favorites;

  void setCurrentOperator(String operator) {
    _currentOperator = operator;
    notifyListeners();
  }

  // Check if a tariff is in favorites
  bool isFavorite(Tariff tariff) {
    return _favorites.contains(tariff);
  }

  // Add/remove tariff from favorites
  void toggleFavorite(Tariff tariff) {
    if (_favorites.contains(tariff)) {
      _favorites.remove(tariff);
    } else {
      _favorites.add(tariff);
    }
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  Future<void> loadTariffsFromJson() async {
    final String response = await rootBundle.loadString('assets/tariffs.json');
    final List<dynamic> data = json.decode(response);

    _tariffs.clear();
    _tariffs.addAll(data.map((jsonTariff) => Tariff(
      jsonTariff['name'],
      jsonTariff['gb'],
      jsonTariff['minutes'],
      (jsonTariff['price'] as num).toDouble(),
      jsonTariff['specification'],
      jsonTariff['specialPriceFirstMonths'],
      jsonTariff['specialPriceRemainingMonths'],
      jsonTariff['firstMonthsCount'],
      jsonTariff['remainingMonthsCount']
    )).toList());

    notifyListeners();
  }

}
