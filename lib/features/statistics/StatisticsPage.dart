import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/models/ShoppingListModel.dart';
import '../../core/providers/ShoppingListsProvider.dart';
import '../../core/services/StatisticsService.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDateRange = DateTimeRange(
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF667EEA),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Consumer<ShoppingListsProvider>(
        builder: (context, provider, child) {
          final now = DateTime.now();
          final range = _selectedDateRange ?? DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);
          final startOfDay = DateTime(range.start.year, range.start.month, range.start.day);
          final endOfDay = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59);

          List<ShoppingListModel> filteredLists = StatisticsService.filterListsByDateRange(
            allLists: provider.lists, 
            range: range,
          );
          
          String periodLabel = "з ${DateFormat('dd.MM.yyyy').format(startOfDay)} по ${DateFormat('dd.MM.yyyy').format(endOfDay)}";

          double totalSpent = StatisticsService.calculateTotalSpent(filteredLists);

          final chartSpots = StatisticsService.generateChartSpots(
            lists: filteredLists, 
            range: range,
          );
          
          final maxY = chartSpots.isEmpty ? 100.0 : chartSpots.map((e) => e.y).fold(0.0, (m, v) => v > m ? v : m);
          // add 20% margin top
          final adjustedMaxY = maxY > 0 ? maxY * 1.2 : 100.0;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.show_chart, color: Colors.white, size: 28),
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
                              "Аналітика витрат",
                              style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                        icon: const Icon(Icons.date_range, color: Colors.white, size: 28),
                        onPressed: _pickDateRange,
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
                      // Date range indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              periodLabel,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _pickDateRange, 
                            icon: const Icon(Icons.edit_calendar, size: 18, color: Color(0xFF667EEA)), 
                            label: const Text("Змінити", style: TextStyle(color: Color(0xFF667EEA)))
                          )
                        ],
                      ),
                      const SizedBox(height: 16),

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
                              "Загальні витрати",
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            ),
                            const SizedBox(height: 40),

                            SizedBox(
                              height: 220,
                              child: chartSpots.isEmpty 
                              ? Center(
                                  child: Text(
                                    "Немає даних за цей період", 
                                    style: TextStyle(color: Colors.grey[400])
                                  ),
                                )
                              : LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true, 
                                    drawVerticalLine: false,
                                    horizontalInterval: adjustedMaxY / 4 > 0 ? adjustedMaxY / 4 : 25,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: Colors.grey.withOpacity(0.2),
                                      strokeWidth: 1,
                                    )
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 22,
                                        interval: (endOfDay.difference(startOfDay).inDays / 5).ceilToDouble().clamp(1.0, 30.0),
                                        getTitlesWidget: (value, meta) {
                                          int idx = value.toInt();
                                          final date = startOfDay.add(Duration(days: idx));
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              DateFormat('dd.MM').format(date),
                                              style: TextStyle(color: Colors.grey[500], fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: chartSpots,
                                      isCurved: true,
                                      color: const Color(0xFF667EEA),
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                          radius: 3,
                                          color: Colors.white,
                                          strokeWidth: 2,
                                          strokeColor: const Color(0xFF667EEA),
                                        ),
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFF667EEA).withOpacity(0.3),
                                            const Color(0xFF764BA2).withOpacity(0.0),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ],
                                  minY: 0,
                                  maxY: adjustedMaxY,
                                  lineTouchData: LineTouchData(
                                    touchTooltipData: LineTouchTooltipData(
                                      getTooltipColor: (_) => Colors.blueGrey.withOpacity(0.8),
                                      getTooltipItems: (touchedSpots) {
                                        return touchedSpots.map((spot) {
                                          final date = startOfDay.add(Duration(days: spot.x.toInt()));
                                          return LineTooltipItem(
                                            '${DateFormat('dd.MM.yy').format(date)}\n',
                                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                            children: [
                                              TextSpan(
                                                text: '${spot.y.toStringAsFixed(0)} ₴',
                                                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                            ],
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              title: "Створено списків",
                              value: "${filteredLists.length}",
                              icon: Icons.list_alt,
                              color: Colors.orangeAccent
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoCard(
                              title: "Куплено товарів",
                              value: "${filteredLists.fold(0, (sum, l) => sum + l.items.where((i) => i.isPurchased).length)}",
                              icon: Icons.check_circle_outline,
                              color: Colors.greenAccent
                            ),
                          ),
                        ],
                      )
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

  Widget _buildInfoCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}