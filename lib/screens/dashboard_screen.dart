import 'package:fitquest/screens/sleep_tracking_screen.dart';
import 'package:fitquest/screens/timer_screen.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/animated_counter.dart';
import 'package:fitquest/widgets/animated_progress_bar.dart';
import 'package:fitquest/widgets/animated_scale_tap.dart';
import 'package:fitquest/widgets/water_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

// ── Detail page imports ──
import 'package:fitquest/screens/food_detail_page.dart';
import 'package:fitquest/screens/workout_detail_page.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const _DashboardHeader(),
            const SizedBox(height: 20),
            const _QuickStatsGrid(),
            const SizedBox(height: 20),
            const _NutritionSummary(),
            const SizedBox(height: 16),
            const WaterTracker(),
            const SizedBox(height: 16),
            const _FoodLogCard(),
            const SizedBox(height: 16),
            const _WorkoutCard(),
            const SizedBox(height: 16),
            const _SleepCard(),
            const SizedBox(height: 16),
            const _TimerCard(),
            const SizedBox(height: 24),
          ]
              .animate(interval: 45.ms)
              .fadeIn(duration: 350.ms, curve: Curves.easeOutCubic)
              .slideY(begin: 0.04, end: 0, duration: 350.ms, curve: Curves.easeOutCubic),
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = '${now.day} ${_month(now.month)} ${now.year}';
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FitQuest',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.primary,
                  letterSpacing: -0.5,
                )),
        const SizedBox(height: 4),
        Text('Your fitness, your phone',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Today, $dateStr', style: Theme.of(context).textTheme.bodySmall),
            Row(children: [
              Icon(LucideIcons.flame, size: 20, color: cs.primary),
              const SizedBox(width: 4),
              Text("Let's go", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: cs.primary)),
            ]),
          ],
        ),
      ],
    );
  }

  static String _month(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}

// ─── Stats Grid (Steps / Burned / Active Min) ───────────────────────────────

class _QuickStatsGrid extends StatelessWidget {
  const _QuickStatsGrid();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Row(
          children: [
            Expanded(
                child: _StatCard(
                    icon: LucideIcons.footprints,
                    value: appState.steps,
                    label: 'Steps',
                    colors: [cs.primary, cs.secondary])),
            const SizedBox(width: 10),
            Expanded(
                child: _StatCard(
                    icon: LucideIcons.flame,
                    value: appState.todayExerciseCalories,
                    label: 'Burned',
                    colors: [cs.secondary, cs.tertiary])),
            const SizedBox(width: 10),
            Expanded(
                child: _StatCard(
                    icon: LucideIcons.timer,
                    value: appState.todayActiveMinutes,
                    label: 'Active Min',
                    colors: [cs.tertiary, cs.primary])),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final List<Color> colors;
  const _StatCard({required this.icon, required this.value, required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 6),
          AnimatedCounter(value: value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ─── Nutrition Summary (always visible macros) ──────────────────────────────

class _NutritionSummary extends StatelessWidget {
  const _NutritionSummary();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(LucideIcons.utensilsCrossed, size: 20, color: cs.primary),
                  const SizedBox(width: 10),
                  Text('Daily Nutrition',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 16),
                _macroRow(context, 'Calories', appState.todayCalories, appState.calorieGoal, 'kcal', cs.primary),
                const SizedBox(height: 12),
                _macroRow(context, 'Protein', appState.todayProtein, appState.proteinGoal, 'g', cs.tertiary),
                const SizedBox(height: 12),
                _macroRow(context, 'Carbs', appState.todayCarbs, appState.carbsGoal, 'g', cs.secondary),
                const SizedBox(height: 12),
                _macroRow(context, 'Fat', appState.todayFat, appState.fatGoal, 'g', const Color(0xFFA855F7)),
                const SizedBox(height: 12),
                _macroRow(context, 'Fiber', appState.todayFiber, appState.fiberGoal, 'g', const Color(0xFFD97706)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _macroRow(BuildContext context, String title, int current, int goal, String unit, Color color) {
    double percent = goal > 0 ? (current / goal) : 0;
    if (percent > 1.0) percent = 1.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        Text('$current / $goal $unit', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 6),
      AnimatedProgressBar(percent: percent, progressColor: color, height: 10, radius: 5),
    ]);
  }
}

// ─── Food Log Card (tap → full page) ─────────────────────────────────────────

class _FoodLogCard extends StatelessWidget {
  const _FoodLogCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final foods = appState.foods;
        final totalCal = appState.todayCalories;
        return AnimatedScaleTap(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, anim, secondaryAnim) => const FoodDetailPage(),
                transitionsBuilder: (context, anim, secondaryAnim, child) {
                  return SlideTransition(
                    position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                        .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(LucideIcons.clipboardList, color: cs.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Food Log', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${foods.length} items · $totalCal kcal today',
                        style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
                  ]),
                ),
                Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
              ]),
            ),
          ),
        );
      },
    );
  }
}

// ─── Workout Card (tap → full page) ──────────────────────────────────────────

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final burned = appState.todayExerciseCalories;
        final activeMin = appState.todayActiveMinutes;
        final count = appState.exercises.length;
        return AnimatedScaleTap(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, anim, secondaryAnim) => const WorkoutDetailPage(),
                transitionsBuilder: (context, anim, secondaryAnim, child) {
                  return SlideTransition(
                    position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                        .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(LucideIcons.dumbbell, color: cs.secondary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Workouts', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('$count exercises · $burned kcal · $activeMin min',
                        style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
                  ]),
                ),
                Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
              ]),
            ),
          ),
        );
      },
    );
  }
}

// ─── Sleep Card (tap → full page) ────────────────────────────────────────────

class _SleepCard extends StatelessWidget {
  const _SleepCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedScaleTap(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, anim, secondaryAnim) => const SleepTrackingScreen(),
            transitionsBuilder: (context, anim, secondaryAnim, child) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                    .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(14)),
              child: Icon(LucideIcons.bed, color: cs.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Sleep', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Track & manage your sleep', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
              ]),
            ),
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
          ]),
        ),
      ),
    );
  }
}

// ─── Timer Card (tap → full page) ────────────────────────────────────────────

class _TimerCard extends StatelessWidget {
  const _TimerCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedScaleTap(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, anim, secondaryAnim) => const TimerScreen(),
            transitionsBuilder: (context, anim, secondaryAnim, child) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                    .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 350),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: cs.secondaryContainer, borderRadius: BorderRadius.circular(14)),
              child: Icon(LucideIcons.timer, color: cs.secondary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Stopwatch', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Lap timer for workouts', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
              ]),
            ),
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
          ]),
        ),
      ),
    );
  }
}
