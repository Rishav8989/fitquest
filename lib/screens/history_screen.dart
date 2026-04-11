import 'package:fitquest/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.fileText),
            onPressed: () => _exportToPdf(context),
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Calorie Trends (Last 7 Logs)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: _buildChart(appState),
                ),
                const SizedBox(height: 24),
                Text('Food Logs', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildFoodList(appState),
                const SizedBox(height: 24),
                Text('Exercise Logs', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildExerciseList(appState),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChart(AppState appState) {
    final foods = appState.foods;
    if (foods.isEmpty) {
      return const Center(child: Text('No data to display chart.'));
    }
    
    // Group calories by date
    final Map<String, double> dailyCalories = {};
    for (var f in foods) {
      final date = f.date.split('T')[0];
      dailyCalories[date] = (dailyCalories[date] ?? 0) + f.calories;
    }
    
    final sortedKeys = dailyCalories.keys.toList()..sort();
    final latestKeys = sortedKeys.reversed.take(7).toList().reversed.toList();
    
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < latestKeys.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: dailyCalories[latestKeys[i]]!,
              color: Theme.of(context).colorScheme.primary,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < latestKeys.length) {
                  final date = DateTime.parse(latestKeys[value.toInt()]);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(DateFormat('MM/dd').format(date), style: const TextStyle(fontSize: 10)),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildFoodList(AppState appState) {
    final foods = appState.foods;
    if (foods.isEmpty) return const Text('No food logs found.');
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final f = foods[foods.length - 1 - index];
        return Card(
          child: ListTile(
            title: Text(f.name),
            subtitle: Text('${f.calories} kcal - ${f.date.split('T')[0]}'),
            trailing: IconButton(
              icon: const Icon(LucideIcons.trash, color: Colors.red),
              onPressed: () {
                appState.removeFood(f);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildExerciseList(AppState appState) {
    final exercises = appState.exercises;
    if (exercises.isEmpty) return const Text('No exercise logs found.');
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final e = exercises[exercises.length - 1 - index];
        return Card(
          child: ListTile(
            title: Text(e.name),
            subtitle: Text('${e.duration} min - ${e.calories} kcal burned'),
            trailing: IconButton(
              icon: const Icon(LucideIcons.trash, color: Colors.red),
              onPressed: () {
                appState.removeExercise(e);
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _exportToPdf(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Header(level: 0, child: pw.Text("FitQuest User Data Export")),
            pw.Header(level: 1, child: pw.Text("Profile Information")),
            pw.Text("Name: ${appState.profile.name}"),
            pw.Text("Email: ${appState.profile.email}"),
            pw.Text("Age: ${appState.profile.age}"),
            pw.Text("Gender: ${appState.profile.gender}"),
            pw.Text("BMI: ${appState.profile.bmi.toStringAsFixed(1)}"),
            pw.SizedBox(height: 20),
            pw.Header(level: 1, child: pw.Text("Food Logs")),
            if (appState.foods.isEmpty) pw.Text("No food logs.") else
            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Name', 'Calories', 'Protein', 'Carbs', 'Fat'],
              data: appState.foods.map((f) => [
                f.date.split('T')[0], f.name, f.calories.toString(), f.protein.toString(), f.carbs.toString(), f.fat.toString()
              ]).toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Header(level: 1, child: pw.Text("Exercise Logs")),
            if (appState.exercises.isEmpty) pw.Text("No exercise logs.") else
            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Name', 'Duration (min)', 'Calories Burned'],
              data: appState.exercises.map((e) => [
                e.timestamp.toIso8601String().split('T')[0], e.name, e.duration.toString(), e.calories.toString()
              ]).toList(),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}