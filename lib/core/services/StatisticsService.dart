import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/ShoppingListModel.dart';

class StatisticsService {
  /// Фільтрує списки за обраним діапазоном дат
  static List<ShoppingListModel> filterListsByDateRange({
    required List<ShoppingListModel> allLists,
    required DateTimeRange range,
  }) {
    final startOfDay = DateTime(range.start.year, range.start.month, range.start.day);
    final endOfDay = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59);

    return allLists.where((l) {
      return l.updatedAt.isAfter(startOfDay) && l.updatedAt.isBefore(endOfDay);
    }).toList();
  }

  /// Рахує загальну суму витрат
  static double calculateTotalSpent(List<ShoppingListModel> filteredLists) {
    double totalSpent = 0;
    for (var list in filteredLists) {
      totalSpent += list.items
          .where((i) => i.isPurchased)
          .fold(0.0, (sum, item) => sum + (item.price ?? 0));
    }
    return totalSpent;
  }

  /// Генерує точки для LineChart
  static List<FlSpot> generateChartSpots({
    required List<ShoppingListModel> lists,
    required DateTimeRange range,
  }) {
    final startOfDay = DateTime(range.start.year, range.start.month, range.start.day);
    final endOfDay = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59);

    Map<DateTime, double> dailyStats = {};

    // Ініціалізуємо всі дні у вибраному проміжку нулями
    for (var i = 0; i <= endOfDay.difference(startOfDay).inDays; i++) {
      final date = startOfDay.add(Duration(days: i));
      dailyStats[DateTime(date.year, date.month, date.day)] = 0.0;
    }

    // Заповнюємо реальними сумами
    for (var list in lists) {
      final key = DateTime(list.updatedAt.year, list.updatedAt.month, list.updatedAt.day);
      if (dailyStats.containsKey(key)) {
        double spent = list.items
            .where((i) => i.isPurchased)
            .fold(0.0, (sum, item) => sum + (item.price ?? 0));
        dailyStats[key] = (dailyStats[key] ?? 0.0) + spent;
      }
    }

    // Перетворюємо у список точок для графіка
    List<FlSpot> spots = [];
    int index = 0;
    final sortedKeys = dailyStats.keys.toList()..sort();
    
    for (var key in sortedKeys) {
      spots.add(FlSpot(index.toDouble(), dailyStats[key]!));
      index++;
    }
    
    return spots;
  }
}
