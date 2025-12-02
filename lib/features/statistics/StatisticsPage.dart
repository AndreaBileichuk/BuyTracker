import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/models/ShoppingListModel.dart';
import '../../core/providers/ShoppingListsProvider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _selectedPeriod = 'month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Consumer<ShoppingListsProvider>(
        builder: (context, provider, child) {
          final now = DateTime.now();
          List<ShoppingListModel> filteredLists = [];
          String periodLabel = "";

          if (_selectedPeriod == 'week') {
            final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
            filteredLists = provider.lists.where((l) => l.updatedAt.isAfter(startOfWeek)).toList();
            periodLabel = "за цей тиждень";
          } else if (_selectedPeriod == 'month') {
            filteredLists = provider.lists.where((l) => l.updatedAt.month == now.month && l.updatedAt.year == now.year).toList();
            periodLabel = "за цей місяць";
          } else {
            filteredLists = provider.lists.where((l) => l.updatedAt.year == now.year).toList();
            periodLabel = "за цей рік";
          }

          double totalSpent = 0;
          for (var list in filteredLists) {
            totalSpent += list.items
                .where((i) => i.isPurchased)
                .fold(0.0, (sum, item) => sum + (item.price ?? 0));
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.bar_chart, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Статистика",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          "Витрати",
                          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            _buildTabButton("Тиждень", 'week'),
                            _buildTabButton("Місяць", 'month'),
                            _buildTabButton("Рік", 'year'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${totalSpent.toStringAsFixed(0)} ₴",
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Загальні витрати $periodLabel",
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            ),
                            const SizedBox(height: 30),

                            SizedBox(
                              height: 200,
                              child: BarChart(
                                BarChartData(
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          // Проста логіка підписів (можна покращити)
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              (value.toInt() + 1).toString(),
                                              style: TextStyle(color: Colors.grey[400], fontSize: 10),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: _generateChartData(filteredLists), // Генеруємо стовпчики
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(child: Text("Графік активності (к-сть списків)", style: TextStyle(color: Colors.grey[400], fontSize: 12))),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${filteredLists.length} списків",
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Створено або оновлено $periodLabel",
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabButton(String title, String value) {
    bool isSelected = _selectedPeriod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF667EEA) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateChartData(List<ShoppingListModel> lists) {
    Map<int, double> dataMap = {};

    for (var list in lists) {
      int key = 0;
      if (_selectedPeriod == 'week' || _selectedPeriod == 'month') {
        key = list.updatedAt.day; // Групуємо по днях
      } else {
        key = list.updatedAt.month; // Групуємо по місяцях
      }
      dataMap[key] = (dataMap[key] ?? 0) + 1;
    }

    return List.generate(dataMap.length > 7 ? 7 : dataMap.length, (index) {
      final key = dataMap.keys.elementAt(index);
      final value = dataMap[key]!;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: const Color(0xFF667EEA).withOpacity(0.5),
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}