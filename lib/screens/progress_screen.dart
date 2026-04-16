import 'package:fitquest/screens/bmi_calculator_screen.dart';
import 'package:fitquest/screens/calendar_screen.dart';
import 'package:fitquest/screens/measurements_screen.dart';
import 'package:fitquest/screens/reports_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Progress',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Quick access cards
            Row(
              children: [
                Expanded(
                  child: _ProgressActionCard(
                    icon: LucideIcons.calculator,
                    label: 'BMI Calculator',
                    colors: [cs.primary, cs.secondary],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const BmiCalculatorScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProgressActionCard(
                    icon: LucideIcons.ruler,
                    label: 'Measurements',
                    colors: [cs.secondary, cs.tertiary],
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MeasurementsScreen()));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Reports',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(LucideIcons.barChart2, color: cs.primary),
                    title: const Text('Weekly Status'),
                    subtitle: const Text('View your weekly calorie and activity trends'),
                    trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsDashboardScreen()));
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(LucideIcons.lineChart, color: cs.primary),
                    title: const Text('Monthly Status'),
                    subtitle: const Text('View your monthly trends and progress'),
                    trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsDashboardScreen()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Planning & Organization',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(LucideIcons.calendarCheck, color: cs.primary),
                    title: const Text('Planner & Tasks'),
                    subtitle: const Text('Manage schedule, to-dos, and reminders'),
                    trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const CalendarScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProgressActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  const _ProgressActionCard({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
