import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ReportsDashboardScreen extends StatelessWidget {
  const ReportsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foods = context.watch<AppState>().foods;
    
    // Group calories by date (last 7 days)
    final now = DateTime.now();
    final List<BarChartGroupData> barGroups = [];
    final List<String> days = [];
    
    double maxVal = 1000;

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      
      final dayFoods = foods.where((f) => f.date.startsWith(dateStr));
      final dayCalories = dayFoods.fold(0.0, (sum, f) => sum + f.calories);
      
      if (dayCalories > maxVal) maxVal = dayCalories;
      
      barGroups.add(
        BarChartGroupData(
          x: 6 - i,
          barRods: [
            BarChartRodData(
              toY: dayCalories,
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.cyan],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 16,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ],
        ),
      );
      days.add(DateFormat('E').format(date)); // Mon, Tue, etc.
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Weekly Calorie Intake',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxVal + 500,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox();
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 500,
                    getDrawingHorizontalLine: (value) => const FlLine(
                      color: Colors.black12,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Macro Pie chart if foods exist
            const Text(
              "Today's Macro Breakdown",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildMacroChart(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChart(BuildContext context) {
    final state = context.watch<AppState>();
    final p = state.todayProtein.toDouble();
    final c = state.todayCarbs.toDouble();
    final f = state.todayFat.toDouble();
    final total = p + c + f;
    
    if (total == 0) return const Center(child: Text('No food logged today.'));
    
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              color: Colors.redAccent,
              value: p,
              title: '${((p / total) * 100).toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.orangeAccent,
              value: c,
              title: '${((c / total) * 100).toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.blueAccent,
              value: f,
              title: '${((f / total) * 100).toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
